import { Controller } from '@nestjs/common';
import { ThumbnailService } from './thumbnail.service';

@Controller('thumbnail')
export class ThumbnailController {
  constructor(private readonly thumbnailService: ThumbnailService) {}
}
