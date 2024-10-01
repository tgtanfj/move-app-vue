import { Video } from '@/entities/video.entity';
import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { FindOptionsOrder, FindOptionsRelations, Repository } from 'typeorm';
import { PaginationDto } from './dto/request/pagination.dto';

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
}
