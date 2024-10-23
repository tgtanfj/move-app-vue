import { CommentReaction } from '@/entities/comment-reaction.entity';
import { BadRequestException, Injectable } from '@nestjs/common';
import { CommentReactionRepository } from './comment-reaction.repository';
import { CreateCommentReactionDto } from './dto/create-comment-reaction.dto';
import { CommentRepository } from '../comment/comment.repository';
import { ERRORS_DICTIONARY } from '@/shared/constraints/error-dictionary.constraint';
import { NotificationService } from '../notification/notification.service';
import { UserInfoDto } from '../user/dto/user-info.dto';
import { NOTIFICATION_TYPE } from '@/shared/constraints/notification-message.constraint';

@Injectable()
export class CommentReactionService {
  constructor(
    private readonly commentReactionRepository: CommentReactionRepository,
    private readonly commentRepository: CommentRepository,
    private readonly notificationService: NotificationService,
  ) {}

  async getOne(id: number): Promise<CommentReaction> {
    return await this.commentReactionRepository.getOne(id);
  }

  async getAll(): Promise<CommentReaction[]> {
    return await this.commentReactionRepository.getAll();
  }

  async create(userInfo: UserInfoDto, dto: CreateCommentReactionDto): Promise<CommentReaction> {
    try {
      const userId = userInfo.id;
      const commentReaction = await this.commentReactionRepository.create(userId, dto);
      const comment = await this.commentRepository.getOne(dto.commentId, { user: true });
      const receiver = comment.user.id;
      comment.numberOfLike += dto.isLike ? 1 : 0;

      await this.commentRepository.update(comment.id, { numberOfLike: comment.numberOfLike });

      const isExisted = await this.notificationService.checkNotificationExistsAntiSpam(receiver, userInfo.id);
      if (!isExisted && userId !== receiver) {
        const dataNotification = {
          sender: userInfo,
          type: NOTIFICATION_TYPE.LIKE,
        };
        await this.notificationService.sendOneToOneNotification(receiver, dataNotification);
      }

      return commentReaction;
    } catch (error) {
      throw new BadRequestException(ERRORS_DICTIONARY.NOT_CREATE_COMMENT_REACTION);
    }
  }

  async update(userId: number, dto: CreateCommentReactionDto): Promise<CommentReaction> {
    try {
      const commentReaction = await this.commentReactionRepository.update(userId, dto);
      const comment = commentReaction.comment;
      comment.numberOfLike += dto.isLike ? 1 : -1;
      await this.commentRepository.update(comment.id, { numberOfLike: comment.numberOfLike });
      return commentReaction;
    } catch (error) {
      throw new BadRequestException(ERRORS_DICTIONARY.NOT_UPDATE_COMMENT_REACTION);
    }
  }

  async delete(userId: number, commentId: number): Promise<void> {
    try {
      const commentReaction = await this.commentReactionRepository.getOneWithUserComment(userId, commentId);
      const result = await this.commentReactionRepository.delete(commentReaction.id);
      const comment = await this.commentRepository.getOne(commentId);
      result.affected === 1 && commentReaction.isLike === true && (comment.numberOfLike -= 1);
      await this.commentRepository.update(comment.id, { numberOfLike: comment.numberOfLike });
    } catch (error) {
      throw new BadRequestException(ERRORS_DICTIONARY.NOT_DELETE_COMMENT_REACTION);
    }
  }
}
