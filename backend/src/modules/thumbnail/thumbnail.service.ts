import { ApiConfigService } from '@/shared/services/api-config.service';
import { AwsS3Service } from '@/shared/services/aws-s3.service';
import { BadRequestException, Injectable } from '@nestjs/common';
import { ThumbnailRepository } from './thumbnail.repository';
import { ERRORS_DICTIONARY } from '@/shared/constraints/error-dictionary.constraint';
import { Thumbnail } from '@/entities/thumbnail.entity';

@Injectable()
export class ThumbnailService {
  constructor(
    private apiConfig: ApiConfigService,
    private s3: AwsS3Service,
    private thumbnailRepository: ThumbnailRepository,
  ) {}

  async saveThumbnails(files: Array<Express.Multer.File>, selected: number, videoId: number) {
    const result = await Promise.all(
      files.map(async (file, index) => {
        const linkThumbnail = await this.s3.uploadImage(file);
        if (selected === index) {
          this.thumbnailRepository
            .saveThumbnail(linkThumbnail, true, videoId)
            .then(() => {})
            .catch((error) => {
              throw new BadRequestException({
                message: ERRORS_DICTIONARY.UPLOAD_THUMBNAIL_FAIL,
              });
            });
        } else {
          try {
            await this.thumbnailRepository.saveThumbnail(linkThumbnail, false, videoId);
          } catch (error) {}
        }
      }),
    );
    return result;
  }

  async getSelectedThumbnail(videoId: number): Promise<Thumbnail> {
    return await this.thumbnailRepository.findSelectedThumbnail(videoId);
  }

  async getThumbnails(videoId: number): Promise<Thumbnail[]> {
    return await this.thumbnailRepository.findThumbnails(videoId);
  }

  async updateThumbnail(thumbnailUrl: string, isSelected: boolean, videoId: number): Promise<void> {
    const thumbnail = await this.thumbnailRepository.findThumbnails(videoId);
    const selectedThumbnail = thumbnail.find((item) => item.selected);

    if (selectedThumbnail) {
      selectedThumbnail.image = thumbnailUrl;
      selectedThumbnail.selected = isSelected;
      await this.thumbnailRepository.updateThumbnail(selectedThumbnail);
    }
  }
}
