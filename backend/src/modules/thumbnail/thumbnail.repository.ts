import { Thumbnail } from '@/entities/thumbnail.entity';
import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { FindOneOptions, FindOptionsOrder, FindOptionsRelations, Repository } from 'typeorm';


@Injectable()
export class ThumbnailRepository {
  constructor(@InjectRepository(Thumbnail) private readonly thumbnailRepository: Repository<Thumbnail>) {}
  async saveThumbnail(linkThumbnail: string, selected: boolean = false, videoId: number) {
    const thumbnail = this.thumbnailRepository.create({
      image: linkThumbnail,
      selected:selected,
      video:{
        id:videoId
      }
    });
    await this.thumbnailRepository.save(thumbnail)
  }
}
