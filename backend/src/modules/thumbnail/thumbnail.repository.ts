import { Thumbnail } from '@/entities/thumbnail.entity';
import { Video } from '@/entities/video.entity';
import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { FindOneOptions, FindOptionsOrder, FindOptionsRelations, Repository } from 'typeorm';

@Injectable()
export class ThumbnailRepository {
  constructor(@InjectRepository(Thumbnail) private readonly thumbnailRepository: Repository<Thumbnail>) {}

  async saveThumbnail(linkThumbnail: string, selected: boolean = false, videoId: number) {
    const thumbnail = this.thumbnailRepository.create({
      image: linkThumbnail,
      selected: selected,
      video: {
        id: videoId,
      },
    });
    await this.thumbnailRepository.save(thumbnail);
  }

  async findThumbnailsByVideoId(
    videoId: number,
    relations: FindOptionsRelations<Thumbnail> = {},
  ): Promise<Thumbnail[]> {
    return await this.thumbnailRepository.find({
      where: {
        video: {
          id: videoId,
        },
      },
      relations,
    });
  }

  async findOne(
    thumbnailId: number,
    relations: FindOptionsRelations<Thumbnail> = {},
    options: FindOneOptions<Thumbnail> = {},
  ) {
    return this.thumbnailRepository.findOne({
      where: {
        id: thumbnailId,
      },
      relations,
    });
  }

  async findSelectedThumbnail(
    videoId: number,
    relations: FindOptionsRelations<Thumbnail> = {},
    options: FindOneOptions<Thumbnail> = {},
  ): Promise<Thumbnail> {
    return await this.thumbnailRepository.findOne({
      where: {
        video: {
          id: videoId,
        },
        selected: true,
      },
      relations,
    });
  }

  async findThumbnails(videoId: number): Promise<Thumbnail[]> {
    return await this.thumbnailRepository.find({
      where: {
        video: {
          id: videoId,
        },
      },
    });
  }

  async updateThumbnail(thumbnail: Thumbnail): Promise<void> {
    await this.thumbnailRepository.save(thumbnail);
  }
}
