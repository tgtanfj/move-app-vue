import { CommentReaction } from '@/entities/comment-reaction.entity';
import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { DeleteResult, Repository } from 'typeorm';
import { CreateCommentReactionDto } from './dto/create-comment-reaction.dto';
import { UpdateCommentReactionDto } from './dto/update-comment-reaction.dto';

@Injectable()
export class CommentReactionRepository {
  constructor(
    @InjectRepository(CommentReaction)
    private readonly commentReactionRepository: Repository<CommentReaction>,
  ) {}

  async getOne(id: number): Promise<CommentReaction> {
    return await this.commentReactionRepository.findOneBy({ id: id });
  }

  async getOneWithComment(id: number): Promise<CommentReaction> {
    return await this.commentReactionRepository.findOne({
      where: { id: id },
      relations: { comment: true },
    });
  }

  async getAll(): Promise<CommentReaction[]> {
    return await this.commentReactionRepository.find();
  }

  async create(userId: number, dto: CreateCommentReactionDto): Promise<CommentReaction> {
    const { commentId, ...data } = dto;
    data['comment'] = { id: commentId };
    data['user'] = { id: userId };
    return await this.commentReactionRepository.save(data);
  }

  async update(id: number, dto: UpdateCommentReactionDto): Promise<CommentReaction> {
    const commentReaction = await this.commentReactionRepository.findOne({
      where: { id: id },
      relations: { comment: true },
    });
    commentReaction.isLike = dto.isLike;
    return await this.commentReactionRepository.save(commentReaction);
  }

  async delete(id: number): Promise<DeleteResult> {
    return await this.commentReactionRepository.delete({ id: id });
  }
}
