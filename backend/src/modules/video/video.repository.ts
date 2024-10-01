import { Video } from '@/entities/video.entity';
import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { FindOptionsOrder, FindOptionsRelations, Repository } from 'typeorm';
import { PaginationDto } from './dto/request/pagination.dto';
import { UploadVideoDTO } from './dto/upload-video.dto';

@Injectable()
export class VideoRepository {
  constructor(@InjectRepository(Video) private readonly videoRepository: Repository<Video>) {}

  async findAndCount(
    channelId: number,
    paginationDto: PaginationDto,
    order: FindOptionsOrder<Video> = {},
    relations: FindOptionsRelations<Video> = {},
    withDeleted: boolean = false,
  ): Promise<[Video[], number]> {
    return await this.videoRepository.findAndCount({
      where: {
        channel: {
          id: channelId,
        },
      },
      order,
      skip: PaginationDto.getSkip(paginationDto.take, paginationDto.page),
      take: paginationDto.take,
      relations,
      withDeleted,
    });
  }
  
  async createVideo(userId:number,thumbnail:string,dto:UploadVideoDTO){
    const newVideo = this.videoRepository.create({
      channel: {
        id: userId,
      },
      isPublish: dto.isPublish,
      category: {
        id:dto.category
      },
      workoutLevel: dto.workoutLevel,
      duration: dto.duration,
      keywords: dto.duration,
      url: dto.url,
      isCommentable: dto.isCommentable,
      thumbnail_url: thumbnail,
      title: dto.title,
    });
    
    return await this.videoRepository.save(newVideo)
  }
}
