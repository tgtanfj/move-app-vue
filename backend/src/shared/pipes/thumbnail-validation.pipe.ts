import { Injectable, PipeTransform, BadRequestException } from '@nestjs/common';
import { Express } from 'express';
import { I18nService } from 'nestjs-i18n';

@Injectable()
export class ThumbnailsValidationPipe implements PipeTransform {
  constructor(private readonly i18n: I18nService) {}

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
