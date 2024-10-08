import { Comment } from './../../entities/comment.entity';
import { BadRequestException, Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, UpdateResult } from 'typeorm';
import { CreateCommentDto } from './dto/create-comment.dto';
import { UpdateCommentDto } from './dto/update-comment.dto';

@Injectable()
export class CommentRepository {
  constructor(
    @InjectRepository(Comment)
    private readonly commentRepository: Repository<Comment>,
  ) {}

  async getNumberOfComments(videoId: number): Promise<number> {
    return await this.commentRepository.count({
      where: {
        video: { id: videoId },
      },
    });
  }

  async getOne(id: number): Promise<Comment> {
    return await this.commentRepository.findOneBy({ id: id });
  }

  async getOneWithVideo(id: number): Promise<Comment> {
    return await this.commentRepository.findOne({ where: { id: id }, relations: { video: true } });
  }

  async getAll(): Promise<Comment[]> {
    return await this.commentRepository.find();
  }

  async getComments(videoId: number, limit: number, cursor?: number) {
    const query = this.commentRepository
      .createQueryBuilder('comment')
      .leftJoinAndSelect('comment.user', 'user')
      .where('comment.videoId = :videoId', { videoId })
      .orderBy('comment.createdAt', 'DESC')
      .limit(limit);
    if (cursor) {
      query.andWhere('comment.id < :cursor', { cursor });
    }

    return query.getMany();
  }

  async create(userId: number, dto: CreateCommentDto): Promise<Comment> {
    const { videoId, commentId, ...data } = dto;
    data['video'] = { id: videoId };
    data['user'] = { id: userId };
    if (commentId) {
      const parentComment = await this.commentRepository.findOne({
        where: { id: commentId },
        relations: ['parent'],
      });

      if (parentComment?.parent) {
        throw new BadRequestException('You can only reply one level deep.');
      }
    }
    data['parent'] = commentId ? { id: commentId } : null;
    console.log(data);

    const newComment = this.commentRepository.create(data);

    return await this.commentRepository.save(newComment);
  }

  async update(commentId: number, dto: UpdateCommentDto | Partial<Comment>): Promise<UpdateResult> {
    return await this.commentRepository.update(commentId, dto);
  }

  async delete(id: number): Promise<void> {
    await this.commentRepository.delete({ id: id });
  }
}
