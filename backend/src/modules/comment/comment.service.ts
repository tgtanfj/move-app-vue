import { BadRequestException, Injectable, NotFoundException } from '@nestjs/common';
import { CommentRepository } from './comment.repository';
import { CreateCommentDto } from './dto/create-comment.dto';
import { UpdateCommentDto } from './dto/update-comment.dto';
import { UpdateResult } from 'typeorm';
import { Comment } from '@/entities/comment.entity';
import { ERRORS_DICTIONARY } from '@/shared/constraints/error-dictionary.constraint';
import { VideoRepository } from '../video/video.repository';

@Injectable()
export class CommentService {
  constructor(
    private readonly commentRepository: CommentRepository,
    private readonly videoRepository: VideoRepository,
  ) {}

  async getNumberOfComments(videoId: number): Promise<number> {
    return await this.commentRepository.getNumberOfComments(videoId);
  }

  async getComments(videoId: number, limit: number, cursor?: number) {
    return await this.commentRepository.getComments(videoId, limit, cursor);
  }

  async getOne(id: number): Promise<Comment> {
    return await this.commentRepository.getOne(id).catch((e) => {
      throw new NotFoundException(ERRORS_DICTIONARY.NOT_FOUND_COMMENT);
    });
  }

  async getAll(): Promise<Comment[]> {
    return await this.commentRepository.getAll().catch((e) => {
      throw new NotFoundException(ERRORS_DICTIONARY.NOT_FOUND_COMMENT);
    });
  }

  async create(userId: number, dto: CreateCommentDto): Promise<Comment> {
    try {
      const comment = await this.commentRepository.create(userId, dto);
      const video = await this.videoRepository.findOne(dto.videoId);

      if (!video) {
        throw new NotFoundException(ERRORS_DICTIONARY.NOT_FOUND_VIDEO);
      }

      video.numberOfComments++;
      await this.videoRepository.save(video);
      return comment;
    } catch (error) {
      throw new BadRequestException(error.message);
    }
  }

  async update(commentId: number, dto: UpdateCommentDto): Promise<UpdateResult> {
    return await this.commentRepository.update(commentId, dto).catch((error) => {
      throw new BadRequestException(error.message);
    });
  }

  async delete(id: number): Promise<void> {
    try {
      const comment = await this.commentRepository.getOneWithVideo(id);
      const video = await this.videoRepository.findOne(comment.video.id);
      await this.commentRepository.delete(id);
      video.numberOfComments--;
      await this.videoRepository.save(video);
    } catch (error) {
      throw new BadRequestException(error.message);
    }
  }
}
