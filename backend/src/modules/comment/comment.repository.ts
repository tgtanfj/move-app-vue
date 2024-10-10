import { Comment } from './../../entities/comment.entity';
import { BadRequestException, Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { LessThan, Repository, TreeRepository, UpdateResult } from 'typeorm';
import { CreateCommentDto } from './dto/create-comment.dto';
import { UpdateCommentDto } from './dto/update-comment.dto';
import { CommentReaction } from '@/entities/comment-reaction.entity';
import { Donation } from '@/entities/donation.entity';

@Injectable()
export class CommentRepository {
  constructor(
    @InjectRepository(Comment)
    private readonly commentRepository: TreeRepository<Comment>,
    @InjectRepository(CommentReaction)
    private readonly commentReactionRepository: Repository<CommentReaction>,
    @InjectRepository(Donation)
    private readonly donationRepository: Repository<Donation>,
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

  async getOneWithUser(id: number): Promise<Comment> {
    return await this.commentRepository.findOne({ where: { id: id }, relations: { user: true } });
  }

  async getAll(): Promise<Comment[]> {
    return await this.commentRepository.find();
  }

  async getComments(condition: any, videoId: number, userId: number, limit: number) {
    const comments = await this.commentRepository.find({
      where: condition,
      relations: ['user'],
      order: { createdAt: 'DESC' },
      take: limit,
    });
    const listComments = Promise.all(
      comments.map(async (comment) => {
        const [reactions, donation] = await Promise.all([
          this.getReactionsInComment(comment.id),
          this.getTotalDonations(comment.user.id, videoId),
        ]);
        const checkLike = reactions.find((reaction) => reaction.user.id === userId);
        return {
          ...comment,
          isLike: checkLike?.isLike,
          totalDonation: donation,
        };
      }),
    );

    return listComments;
  }

  async getCommentsOfVideo(userId: number, videoId: number, limit: number, cursor?: number) {
    const whereCondition: any = { video: { id: videoId }, parent: null };

    if (cursor) {
      whereCondition.id = cursor ? LessThan(cursor) : undefined;
    }

    const data = await this.getComments(whereCondition, videoId, userId, limit);

    return data;
  }

  async getReplyComments(userId: number, id: number, limit: number, cursor?: number) {
    const whereCondition: any = { parent: { id: id } };

    if (cursor) {
      whereCondition.id = cursor ? LessThan(cursor) : undefined;
    }
    const videoId = (await this.getOneWithVideo(id)).video.id;
    const data = await this.getComments(whereCondition, videoId, userId, limit);

    return data;
  }

  async getReactionsInComment(commentId: number): Promise<CommentReaction[]> {
    return await this.commentReactionRepository.find({
      where: { comment: { id: commentId } },
      relations: { user: true },
      select: {
        user: { id: true },
      },
    });
  }

  async getTotalDonations(userId: number, videoId: number): Promise<number> {
    const donations = await this.donationRepository.find({
      where: {
        user: { id: userId },
        video: { id: videoId },
      },
      select: ['numberOfREPs'],
    });

    const totalDonations = donations.reduce((total, donation) => {
      return total + parseFloat(donation.numberOfREPs);
    }, 0);

    return totalDonations;
  }

  async create(userId: number, dto: CreateCommentDto) {
    const { videoId, commentId, ...data } = dto;
    data['video'] = videoId ? { id: videoId } : null;
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

    const newComment = this.commentRepository.create(data);
    const comment = await this.commentRepository.save(newComment);
    const commentRes = await this.getOneWithUser(comment.id);
    const totalDonation = await this.getTotalDonations(userId, videoId);

    return { ...commentRes, totalDonation };
  }

  async update(commentId: number, dto: UpdateCommentDto | Partial<Comment>): Promise<UpdateResult> {
    return await this.commentRepository.update(commentId, dto);
  }

  async delete(id: number): Promise<void> {
    await this.commentRepository.delete({ id: id });
  }
}
