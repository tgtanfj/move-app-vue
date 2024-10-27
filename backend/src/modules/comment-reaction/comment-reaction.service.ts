import { CommentReaction } from '@/entities/comment-reaction.entity';
import { NOTIFICATION_TYPE } from '@/shared/constraints/notification-message.constraint';
import { BadRequestException, Injectable } from '@nestjs/common';
import { I18nService } from 'nestjs-i18n';
import { CommentRepository } from '../comment/comment.repository';
import { NotificationService } from '../notification/notification.service';
import { UserInfoDto } from '../user/dto/user-info.dto';
import { CommentReactionRepository } from './comment-reaction.repository';
import { CreateCommentReactionDto } from './dto/create-comment-reaction.dto';

@Injectable()
export class CommentReactionService {
  constructor(
    private readonly commentReactionRepository: CommentReactionRepository,
    private readonly commentRepository: CommentRepository,
    private readonly notificationService: NotificationService,
    private readonly i18n: I18nService,
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
      const commentReactionExisted = await this.commentReactionRepository.getOneWithUserComment(
        userId,
        dto.commentId,
      );
      if (commentReactionExisted) {
        return commentReactionExisted;
      }
      const commentReaction = await this.commentReactionRepository.create(userId, dto);
      const comment = await this.commentRepository.getOne(dto.commentId, {
        user: true,
        video: true,
        parent: true,
      });
      const receiver = comment.user.id;
      comment.numberOfLike += dto.isLike ? 1 : 0;

      await this.commentRepository.update(comment.id, { numberOfLike: comment.numberOfLike });

      const isExisted = await this.notificationService.checkNotificationExistsAntiSpam(
        receiver,
        userInfo.id,
        comment.id,
      );
      if (!isExisted && userId !== receiver) {
        const dataNotification = {
          sender: userInfo,
          type: NOTIFICATION_TYPE.LIKE,
          videoId: comment.video.id,
          videoTitle: comment.video.title,
          commentId: comment?.parent ? comment.parent.id : comment.id,
          replyId: comment?.parent ? comment.id : undefined,
        };
        await this.notificationService.sendOneToOneNotification(receiver, dataNotification);
      }

      return commentReaction;
    } catch (error) {
      throw new BadRequestException(this.i18n.t('exceptions.comment.NOT_CREATE_COMMENT_REACTION'));
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
      throw new BadRequestException(this.i18n.t('exceptions.comment.NOT_UPDATE_COMMENT_REACTION'));
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
      throw new BadRequestException(this.i18n.t('exceptions.comment.NOT_DELETE_COMMENT_REACTION'));
    }
  }
}
