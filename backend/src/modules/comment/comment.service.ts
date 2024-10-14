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

  async getCommentsOfVideo(id: number, limit: number, cursor?: number, userId?: number) {
    return await this.commentRepository.getCommentsOfVideo(id, limit, cursor, userId);
  }

  async getReplyComments(id: number, limit: number, cursor?: number, userId?: number) {
    return await this.commentRepository.getReplyComments(id, limit, cursor, userId);
  }

  async getOne(id: number): Promise<Comment> {
    return await this.commentRepository.getOne(id);
  }

  async getAll(): Promise<Comment[]> {
    return await this.commentRepository.getAll();
  }

  async create(userId: number, dto: CreateCommentDto) {
    try {
      let videoId: number;
      dto.videoId && (videoId = dto.videoId);

      if (dto.commentId && !dto.videoId) {
        const comment = await this.commentRepository.getOneWithVideo(dto.commentId);
        await this.commentRepository.update(comment.id, { numberOfReply: comment.numberOfReply + 1 });
        videoId = comment.video.id;
      }

      const comment = await this.commentRepository.create(userId, dto);
      const video = await this.videoRepository.findOne(videoId);

      if (!video) {
        throw new NotFoundException(ERRORS_DICTIONARY.NOT_FOUND_VIDEO);
      }

      video.numberOfComments++;
      await this.videoRepository.save(video);
      return comment;
    } catch (error) {
      throw new BadRequestException(ERRORS_DICTIONARY.NOT_CREATE_COMMENT);
    }
  }

  async update(commentId: number, dto: UpdateCommentDto): Promise<UpdateResult> {
    return await this.commentRepository.update(commentId, dto).catch((error) => {
      throw new BadRequestException(ERRORS_DICTIONARY.NOT_UPDATE_COMMENT);
    });
  }

  async delete(id: number): Promise<void> {
    try {
      const comment = await this.commentRepository.getOneWithVideo(id);

      if (comment.parent) {
        await this.commentRepository.update(comment.parent.id, {
          numberOfReply: comment.parent.numberOfReply - 1,
        });
      }

      if (comment?.video) {
        const video = await this.videoRepository.findOne(comment.video.id);
        video.numberOfComments--;
        await this.videoRepository.save(video);
      }

      await this.commentRepository.delete(id);
    } catch (error) {
      throw new BadRequestException(ERRORS_DICTIONARY.NOT_DELETE_COMMENT);
    }
  }
}
