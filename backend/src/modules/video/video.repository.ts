import { Video } from '@/entities/video.entity';
import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { FindOneOptions, FindOptionsOrder, FindOptionsRelations, Repository } from 'typeorm';
import { PaginationDto } from './dto/request/pagination.dto';
import { UploadVideoDTO } from './dto/upload-video.dto';
import { channel } from 'diagnostics_channel';
import { boolean } from 'joi';

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

  async createVideo(channelId: number, dto: UploadVideoDTO, isComment: boolean, isPublish: boolean) {
    const newVideo = this.videoRepository.create({
      category: {
        id: dto.category,
      },
      channel: {
        id: channelId,
      },
      workoutLevel: dto.workoutLevel,
      duration: dto.duration,
      keywords: dto.keywords || null,
      isCommentable: isComment,
      isPublish: isPublish,
      url: dto.url,
      title: dto.title,
    });

    return await this.videoRepository.save(newVideo);
  }

  async findVideoById(videoId: number): Promise<Video | null> {
    return await this.videoRepository.findOne({ where: { id: videoId } });
  }

  async save(video: Video): Promise<Video> {
    return await this.videoRepository.save(video);
  }

  async deleteVideos(videoIds: number[]) {
    await this.videoRepository.manager.transaction(async (transactionalEntityManager) => {
      await Promise.all(
        videoIds.map(async (videoId) => {
          await transactionalEntityManager
            .getRepository(Video)
            .findOneOrFail({ where: { id: videoId }, withDeleted: false });
          await transactionalEntityManager.getRepository(Video).softDelete(videoId);
        }),
      );
    });
  }

  async restoreVideos(videoIds: number[]) {
    await this.videoRepository.manager.transaction(async (transactionalEntityManager) => {
      await Promise.all(
        videoIds.map(async (videoId) => {
          await transactionalEntityManager.getRepository(Video).restore(videoId);
        }),
      );
    });
  }

  async findOne(
    videoId: number,
    relations: FindOptionsRelations<Video> = {},
    options: FindOneOptions<Video> = {},
  ) {
    return await this.videoRepository.findOne({
      where: { id: videoId },
      relations,
      withDeleted: options.withDeleted,
    });
  }

  async findVideoUrlById(videoId: number): Promise<string> {
    const video = await this.videoRepository.findOne({
      where: { id: videoId },
      select: ['url'],
    });
    return video ? video.url : null;
  }
}
