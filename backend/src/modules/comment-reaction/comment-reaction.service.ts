import { CommentReaction } from '@/entities/comment-reaction.entity';
import { BadRequestException, Injectable, NotFoundException } from '@nestjs/common';
import { UpdateResult } from 'typeorm';
import { CommentReactionRepository } from './comment-reaction.repository';
import { CreateCommentReactionDto } from './dto/create-comment-reaction.dto';
import { UpdateCommentReactionDto } from './dto/update-comment-reaction.dto';
import { CommentRepository } from '../comment/comment.repository';
import { ERRORS_DICTIONARY } from '@/shared/constraints/error-dictionary.constraint';

@Injectable()
export class CommentReactionService {
  constructor(
    private readonly commentReactionRepository: CommentReactionRepository,
    private readonly commentRepository: CommentRepository,
  ) {}

  async getOne(id: number): Promise<CommentReaction> {
    return await this.commentReactionRepository.getOne(id).catch((e) => {
      throw new NotFoundException(ERRORS_DICTIONARY.NOT_FOUND_COMMENT_REACTION);
    });
  }

  async getAll(): Promise<CommentReaction[]> {
    return await this.commentReactionRepository.getAll().catch((e) => {
      throw new NotFoundException(ERRORS_DICTIONARY.NOT_FOUND_COMMENT_REACTION);
    });
  }

  async create(userId: number, dto: CreateCommentReactionDto): Promise<CommentReaction> {
    try {
      const commentReaction = await this.commentReactionRepository.create(userId, dto);
      const comment = await this.commentRepository.getOne(dto.commentId);
      comment.numberOfLike += dto.isLike ? 1 : 0;

      await this.commentRepository.update(comment.id, { numberOfLike: comment.numberOfLike });
      return commentReaction;
    } catch (error) {
      throw new BadRequestException(error.message);
    }
  }

  async update(commentReactionId: number, dto: UpdateCommentReactionDto): Promise<UpdateResult> {
    try {
      const commentReaction = await this.commentReactionRepository.update(commentReactionId, dto);
      const comment = commentReaction.comment;
      comment.numberOfLike += dto.isLike ? 1 : -1;
      return await this.commentRepository.update(comment.id, { numberOfLike: comment.numberOfLike });
    } catch (error) {
      throw new BadRequestException(error.message);
    }
  }

  async delete(id: number): Promise<void> {
    try {
      const commentReaction = await this.commentReactionRepository.getOneWithComment(id);
      const result = await this.commentReactionRepository.delete(id);
      const comment = await this.commentRepository.getOne(commentReaction.comment.id);
      result.affected === 1 && (comment.numberOfLike -= 1);
      await this.commentRepository.update(comment.id, { numberOfLike: comment.numberOfLike });
    } catch (error) {
      throw new BadRequestException(ERRORS_DICTIONARY.NOT_FOUND_COMMENT_REACTION);
    }
  }
}
