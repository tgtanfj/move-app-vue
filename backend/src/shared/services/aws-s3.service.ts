import { DeleteObjectCommand, GetObjectCommand, GetObjectCommandInput, PutObjectCommand, S3Client } from '@aws-sdk/client-s3';
import { getSignedUrl, S3RequestPresigner } from '@aws-sdk/s3-request-presigner';
import { Injectable } from '@nestjs/common';
import * as mime from 'mime-types';

import type { IFile } from '../interfaces/file.interface';
import { GeneratorProvider } from '../providers/generator.provider';
import { ApiConfigService } from './api-config.service';
import { GeneratorService } from './generator.service';
<<<<<<< HEAD
import { createWriteStream } from 'fs';
=======
import { Upload } from '@aws-sdk/lib-storage';
>>>>>>> 18edda5 ((feature/download-video): api download)

@Injectable()
export class AwsS3Service {
  private readonly s3Client: S3Client;

  private readonly bucketName: string;

  private readonly expiresIn: number;

  constructor(
    public configService: ApiConfigService,
    public generatorService: GeneratorService,
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

  
  async getVideoDownloadLink(urlS3: string): Promise<string> {
    const key = 'images' + urlS3.split('images/')[1];
    const params: GetObjectCommandInput = {
      Bucket: this.bucketName,
      Key: key,
      // Headers để gợi ý trình duyệt tải xuống file
      ResponseContentDisposition: `attachment; filename="${key}"`, // Gợi ý tên file khi tải về
    };

    // Tạo signed URL
    const command = new GetObjectCommand(params);
    const url = await getSignedUrl(this.s3Client, command, {
      expiresIn: this.expiresIn, // Thời gian link có hiệu lực (seconds)
    });

    return url;
  }
}
