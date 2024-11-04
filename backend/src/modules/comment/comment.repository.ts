import { CommentReaction } from '@/entities/comment-reaction.entity';
import { Donation } from '@/entities/donation.entity';
import { BadRequestException, Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { FindOptionsRelations, LessThan, MoreThan, Repository, TreeRepository, UpdateResult } from 'typeorm';
import { Comment } from './../../entities/comment.entity';
import { CreateCommentDto } from './dto/create-comment.dto';
import { UpdateCommentDto } from './dto/update-comment.dto';

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

  async getAllComments(
    userId: number,
    filter: string = 'all',
    sortBy: string = 'createdAt',
    page: number = 1,
    pageSize: number = 5,
  ): Promise<{
    data: Comment[];
    totalItemCount: number;
    totalPages: number;
    itemFrom: number;
    itemTo: number;
  }> {
    const queryBuilder = this.commentRepository
      .createQueryBuilder('comment')
      .innerJoinAndSelect('comment.user', 'user')
      .innerJoinAndSelect('comment.video', 'video')
      .innerJoin('video.channel', 'channel')
      .leftJoinAndSelect('comment.children', 'child')
      .leftJoinAndSelect('video.thumbnails', 'thumbnail', 'thumbnail.selected = :selected', {
        selected: true,
      })
      .leftJoinAndSelect('video.category', 'category')
      .where('channel.userId = :userId', { userId })
      .select(['comment', 'user', 'video', 'child', 'category', 'thumbnail']);

    if (filter === 'unresponded') {
      queryBuilder.andWhere(
        `NOT EXISTS (
            SELECT 1 FROM "comments" "childComment"
            WHERE "childComment"."parentId" = "comment"."id"
            AND "childComment"."userId" = :userId
          )`,
        { userId },
      );
    } else if (filter === 'responded') {
      queryBuilder.andWhere(
        `EXISTS (
            SELECT 1 FROM "comments" "childComment"
            WHERE "childComment"."parentId" = "comment"."id"
            AND "childComment"."userId" = :userId
          )`,
        { userId },
      );
    }

    const comments = await queryBuilder.getMany();

    const enrichedComments = await Promise.all(
      comments.map(async (comment) => {
        const totalDonation = await this.getTotalDonations(comment.user.id, comment.video.id);
        return { ...comment, totalDonation };
      }),
    );

    enrichedComments.sort((a, b) => {
      if (sortBy === 'createdAt') {
        if (b.createdAt.getTime() !== a.createdAt.getTime()) {
          return b.createdAt.getTime() - a.createdAt.getTime();
        }
        if (b.totalDonation !== a.totalDonation) {
          return b.totalDonation - a.totalDonation;
        }
        return b.numberOfLike - a.numberOfLike;
      } else if (sortBy === 'receivedReps') {
        if (b.totalDonation !== a.totalDonation) {
          return b.totalDonation - a.totalDonation;
        }
        if (b.createdAt.getTime() !== a.createdAt.getTime()) {
          return b.createdAt.getTime() - a.createdAt.getTime();
        }
        return b.numberOfLike - a.numberOfLike;
      }
      return 0;
    });

    const totalItemCount = enrichedComments.length;
    const totalPages = Math.ceil(totalItemCount / pageSize);

    const paginatedData = enrichedComments.slice((page - 1) * pageSize, page * pageSize);

    const itemFrom = (page - 1) * pageSize + 1;
    const itemTo = Math.min(itemFrom + paginatedData.length - 1, totalItemCount);

    return {
      data: paginatedData,
      totalItemCount,
      totalPages,
      itemFrom,
      itemTo,
    };
  }

  async getOne(id: number, relations?: FindOptionsRelations<Comment>): Promise<Comment> {
    return await this.commentRepository.findOne({
      where: {
        id: id,
      },
      relations,
    });
  }

  async getOneWithVideo(id: number): Promise<Comment> {
    return await this.commentRepository.findOne({
      where: { id: id },
      relations: { video: true, parent: true, user: true },
      select: {
        id: true,
        content: true,
        numberOfReply: true,
        numberOfLike: true,
        parent: { id: true, numberOfReply: true, video: { id: true } },
        video: {
          id: true,
          title: true,
          numberOfComments: true,
        },
        user: {
          id: true,
        },
      },
    });
  }

  async getOneWithUser(id: number): Promise<Comment> {
    return await this.commentRepository.findOne({
      where: { id: id },
      relations: ['user', 'user.channel'],
      select: {
        user: {
          id: true,
          avatar: true,
          username: true,
          fullName: true,
          channel: {
            isPinkBadge: true,
            isBlueBadge: true,
          },
        },
      },
    });
  }

  async getAll(): Promise<Comment[]> {
    return await this.commentRepository.find();
  }

  async getOneDetails(id: number, userId?: number) {
    const comment = await this.commentRepository.findOne({
      where: { id: id },
      relations: ['user', 'user.channel', 'video', 'parent', 'parent.video'],
      order: { createdAt: 'DESC' },
      select: {
        user: {
          id: true,
          avatar: true,
          username: true,
          fullName: true,
          channel: {
            isPinkBadge: true,
            isBlueBadge: true,
          },
        },
        parent: {
          id: true,
          video: {
            id: true,
          },
        },
        video: {
          id: true,
        },
      },
    });
    const videoId = comment.parent ? comment.parent.video.id : comment.video.id;
    const { parent, video, ...commentDetails } = await this.addInformation(comment, videoId, userId);
    return commentDetails;
  }

  async getComments(condition: any, videoId: number, limit: number, order: boolean, userId?: number) {
    const comments = await this.commentRepository.find({
      where: condition,
      relations: ['user', 'user.channel'],
      order: { createdAt: order ? 'ASC' : 'DESC' },
      select: {
        user: {
          id: true,
          avatar: true,
          username: true,
          fullName: true,
          channel: {
            isPinkBadge: true,
            isBlueBadge: true,
          },
        },
      },
      take: limit,
    });

    const listComments = await Promise.all(
      comments.map((comment) => this.addInformation(comment, videoId, userId)),
    );

    return listComments;
  }

  async getCommentsOfVideo(videoId: number, limit: number, cursor?: number, userId?: number) {
    const whereCondition: any = { video: { id: videoId }, parent: null };

    if (cursor) {
      whereCondition.id = cursor ? LessThan(cursor) : undefined;
    }

    const data = await this.getComments(whereCondition, videoId, limit, false, userId);

    return data;
  }

  async getReplyComments(id: number, limit: number, cursor?: number, userId?: number) {
    const whereCondition: any = { parent: { id: id } };

    if (cursor) {
      whereCondition.id = cursor ? MoreThan(cursor) : undefined;
    }
    const videoId = (await this.getOneWithVideo(id)).video.id;
    const data = await this.getComments(whereCondition, videoId, limit, true, userId);

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
      relations: {
        giftPackage: true,
      },
    });

    const totalDonations = donations.reduce((total, donation) => {
      return total + donation.giftPackage.numberOfREPs;
    }, 0);

    return totalDonations;
  }

  private async addInformation(comment: Comment, videoId: number, userId?: number) {
    const [reactions, donation, lastContentDonate] = await Promise.all([
      this.getReactionsInComment(comment.id),
      this.getTotalDonations(comment.user.id, videoId),
      this.getLastContentDonate(comment.user.id, videoId),
    ]);

    const checkLike = userId ? reactions.find((reaction) => reaction.user.id === userId) : undefined;

    return {
      ...comment,
      isLike: checkLike?.isLike,
      totalDonation: donation,
      lastContentDonate,
    };
  }

  async getLastContentDonate(userId: number, videoId: number) {
    const donations = await this.donationRepository.findOne({
      where: {
        user: { id: userId },
        video: { id: videoId },
      },
      order: {
        createdAt: 'DESC',
      },
    });

    return donations?.content;
  }

  async create(userId: number, dto: CreateCommentDto) {
    let { videoId, commentId, ...data } = dto;
    data['video'] = videoId ? { id: videoId } : null;
    data['user'] = { id: userId };
    if (commentId) {
      const parentComment = await this.commentRepository.findOne({
        where: { id: commentId },
        relations: ['parent', 'video'],
        select: {
          parent: {
            id: true,
          },
          video: {
            id: true,
          },
        },
      });

      videoId = parentComment.video.id;
      if (parentComment?.parent) {
        throw new BadRequestException('You can only reply one level deep.');
      }
    }
    data['parent'] = commentId ? { id: commentId } : null;

    const newComment = this.commentRepository.create(data);
    const comment = await this.commentRepository.save(newComment);
    const [commentRes, totalDonation, lastContentDonate] = await Promise.all([
      this.getOneWithUser(comment.id),
      this.getTotalDonations(userId, videoId),
      this.getLastContentDonate(userId, videoId),
    ]);

    return { ...commentRes, totalDonation, lastContentDonate };
  }

  async update(commentId: number, dto: UpdateCommentDto | Partial<Comment>): Promise<UpdateResult> {
    return await this.commentRepository.update(commentId, dto);
  }

  async delete(id: number): Promise<void> {
    await this.commentRepository.delete({ id: id });
  }
}
