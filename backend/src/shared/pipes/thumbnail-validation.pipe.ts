import { Injectable, PipeTransform, BadRequestException } from '@nestjs/common';
import { Express } from 'express';

@Injectable()
export class ThumbnailsValidationPipe implements PipeTransform {
  async transform(files: Array<Express.Multer.File>) {
    console.log('pipe::::' + files.length);

    if (!files || files.length === 0) {
      throw new BadRequestException('No thumbnails uploaded.');
    }

    if (files.length > 6) {
      throw new BadRequestException('You can upload a maximum of thumbnails.');
    }

    return files;
  }
}
