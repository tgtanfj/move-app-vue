import {
  DeleteObjectCommand,
  GetObjectCommand,
  GetObjectCommandInput,
  PutObjectCommand,
  S3Client,
} from '@aws-sdk/client-s3';
import { getSignedUrl } from '@aws-sdk/s3-request-presigner';
import { Injectable } from '@nestjs/common';
import * as mime from 'mime-types';

import { Upload } from '@aws-sdk/lib-storage';
import * as fs from 'fs';
import { I18nService } from 'nestjs-i18n';
import * as path from 'path';
import type { IFile } from '../interfaces/file.interface';
import { GeneratorProvider } from '../providers/generator.provider';
import { getKeyS3 } from '../utils/get-key-s3.util';
import { validateAvatarFile } from '../utils/validate-avatar.utils';
import { ApiConfigService } from './api-config.service';
import { GeneratorService } from './generator.service';
import * as archiver from 'archiver';
import { PassThrough } from 'stream';
@Injectable()
export class AwsS3Service {
  private readonly s3Client: S3Client;

  private readonly bucketName: string;

  private readonly expiresIn: number;

  constructor(
    public configService: ApiConfigService,
    public generatorService: GeneratorService,
    private readonly i18n: I18nService,
  ) {
    const s3Config = this.configService.awsS3Config;

    this.s3Client = new S3Client({
      region: s3Config.bucketRegion,
      credentials: {
        accessKeyId: s3Config.s3AccessKeyId,
        secretAccessKey: s3Config.s3SecretAccessKey,
      },
    });

    this.bucketName = s3Config.bucketName;
    this.expiresIn = 36_000;
  }

  async uploadImage(file: IFile): Promise<string> {
    const extension = mime.extension(file.mimetype);
    if (!extension) {
      throw new Error('Invalid file mimetype');
    }

    const fileName = this.generatorService.fileName(<string>extension);

    const key = this.configService.awsS3Config.bucketEndpoint + 'images/' + fileName;

    await this.s3Client.send(
      new PutObjectCommand({
        Bucket: this.bucketName,
        Body: file.buffer,
        ContentType: file.mimetype,
        Key: 'images/' + fileName,
        ACL: 'public-read',
      }),
    );

    return key;
  }

  async uploadAvatar(file: IFile): Promise<string> {
    await validateAvatarFile(file, this.i18n);
    return await this.uploadImage(file);
  }

  async uploadVideo(file: IFile) {
    const extension = mime.extension(file.mimetype);
    if (!extension) {
      throw new Error('Invalid file mimetype');
    }

    const fileName = this.generatorService.fileName(<string>extension);
    const key = 'images/' + fileName; // Use just the key for S3

    // Use Upload to handle the upload
    const uploader = new Upload({
      client: this.s3Client,
      params: {
        Bucket: this.bucketName,
        Key: key,
        Body: file.buffer, // This can be a stream as well
        ContentType: file.mimetype,
        ACL: 'public-read',
      },
    });

    // Start the upload and wait for it to finish
    await uploader.done();

    // Return the full S3 URL
    return `${this.configService.awsS3Config.bucketEndpoint}${key}`;
  }
  getSignedUrl(key: string): Promise<string> {
    const command = new GetObjectCommand({
      Bucket: this.bucketName,
      Key: key,
    });

    return getSignedUrl(this.s3Client, command, {
      expiresIn: this.expiresIn,
    });
  }

  async deleteObject(key: string) {
    if (this.validateRemovedImage(key)) {
      await this.s3Client.send(
        new DeleteObjectCommand({
          Bucket: this.bucketName,
          Key: key,
        }),
      );
    }
  }

  async deleteObjects(keys: string[]) {
    const promiseDelete = keys.map((item) => {
      const oldKey = GeneratorProvider.getS3Key(item);

      if (oldKey && this.validateRemovedImage(oldKey)) {
        return this.s3Client.send(
          new DeleteObjectCommand({
            Bucket: this.bucketName,
            Key: oldKey,
          }),
        );
      }
    });

    await Promise.all(promiseDelete);
  }

  validateRemovedImage(key: string) {
    return !key.includes('templates/');
  }

  async uploadVideoFromPath(filePath: string): Promise<string> {
    if (!fs.existsSync(filePath)) {
      throw new Error('File does not exist on the server');
    }

    const extension = path.extname(filePath).slice(1).toLowerCase();
    if (!extension) {
      throw new Error('Invalid file extension');
    }

    const contentType = mime.lookup(extension) || 'application/octet-stream';

    // Generate a unique file name for the S3 bucket
    const fileName = `videos/${Date.now()}-${path.basename(filePath)}`;

    const fileStream = fs.createReadStream(filePath);

    const uploader = new Upload({
      client: this.s3Client,
      params: {
        Bucket: this.bucketName,
        Key: fileName,
        Body: fileStream,
        ContentType: contentType,
        ACL: 'public-read',
      },
    });

    await uploader.done();

    return `${this.configService.awsS3Config.bucketEndpoint}${fileName}`;
  }

  async getVideoDownloadLink(urlS3: string, title: string): Promise<string> {
    const key = getKeyS3(urlS3);
    const params: GetObjectCommandInput = {
      Bucket: this.bucketName,
      Key: key,
      ResponseContentDisposition: `attachment; filename="${title}${path.extname(key)}"`,
    };

    const command = new GetObjectCommand(params);
    const url = await getSignedUrl(this.s3Client, command, {
      expiresIn: this.expiresIn,
    });

    return url;
  }

  async downloadMultiFiles(urlS3: any[]) {
    const archive = archiver('zip', { zlib: { level: 5 } });
    const passthrough = new PassThrough();

    archive.on('error', (err) => {
      console.error('Archive error:', err);
      passthrough.destroy(err);
    });

    archive.pipe(passthrough);

    for (const url of urlS3) {
      const key = getKeyS3(url.urlS3);
      const command = new GetObjectCommand({ Bucket: this.bucketName, Key: key });

      try {
        const response = await this.s3Client.send(command);

        if (response.Body) {
          const extension = path.extname(url.urlS3);
          const newFileName = `${url.title}${extension}`;
          archive.append(response.Body as NodeJS.ReadableStream, {
            name: newFileName,
          });
        }
      } catch (error) {
        console.error(`Error fetching ${key} from S3`, error);
      }
    }

    archive.finalize();

    return passthrough;
  }
}
