import { CommentReaction } from '@/entities/comment-reaction.entity';
import { NOTIFICATION_TYPE } from '@/shared/constraints/notification-message.constraint';
import { BadRequestException, Injectable } from '@nestjs/common';
import { I18nService } from 'nestjs-i18n';
import { CommentRepository } from '../comment/comment.repository';
import { NotificationService } from '../notification/notification.service';
import { UserInfoDto } from '../user/dto/user-info.dto';
import { CommentReactionRepository } from './comment-reaction.repository';
import { CreateCommentReactionDto } from './dto/create-comment-reaction.dto';
import { db } from '@/shared/firebase/firebase.config';

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
      const comment = await this.commentRepository.getOne(dto.commentId);
      comment.numberOfLike += dto.isLike ? 1 : 0;

      await this.commentRepository.update(comment.id, { numberOfLike: comment.numberOfLike });

      if (dto.isLike) {
        await this.sendNotificationLike(userInfo, dto.commentId);
      }

      return commentReaction;
    } catch (error) {
      console.log(error);
      throw new BadRequestException(this.i18n.t('exceptions.comment.NOT_CREATE_COMMENT_REACTION'));
    }
  }

  async update(userInfo: UserInfoDto, dto: CreateCommentReactionDto): Promise<CommentReaction> {
    try {
      const userId = userInfo.id;
      const commentReaction = await this.commentReactionRepository.update(userId, dto);
      const comment = commentReaction.comment;
      comment.numberOfLike += dto.isLike ? 1 : -1;
      await this.commentRepository.update(comment.id, { numberOfLike: comment.numberOfLike });

      if (dto.isLike) {
        await this.sendNotificationLike(userInfo, dto.commentId);
      } else {
        await this.removeNotificationLike(dto.commentId);
      }

      return commentReaction;
    } catch (error) {
      console.log(error);
      throw new BadRequestException(this.i18n.t('exceptions.comment.NOT_UPDATE_COMMENT_REACTION'));
    }
  }

  async delete(userId: number, commentId: number): Promise<void> {
    try {
      const commentReaction = await this.commentReactionRepository.getOneWithUserComment(userId, commentId);
      const result = await this.commentReactionRepository.delete(commentReaction.id);
      const comment = await this.commentRepository.getOne(commentId);

      result.affected === 1 &&
        commentReaction.isLike === true &&
        comment.numberOfLike >= 1 &&
        (comment.numberOfLike -= 1);
      await this.commentRepository.update(comment.id, { numberOfLike: comment.numberOfLike });

      await this.removeNotificationLike(commentId);
    } catch (error) {
      console.log(error);
      throw new BadRequestException(this.i18n.t('exceptions.comment.NOT_DELETE_COMMENT_REACTION'));
    }
  }

  async sendNotificationLike(userInfo: UserInfoDto, commentId: number) {
    const comment = await this.commentRepository.getOne(commentId, {
      user: true,
      video: true,
      parent: { video: true },
    });
    const receiver = comment.user.id;
    const parent = comment?.parent;

    const isExisted = await this.notificationService.checkNotificationExistsAntiSpam(receiver, comment.id);

    const dataNotification = {
      sender: userInfo,
      type: NOTIFICATION_TYPE.LIKE,
      videoId: parent ? parent.video.id : comment.video.id,
      videoTitle: parent ? parent.video.title : comment.video.title,
      commentId: parent ? comment.parent.id : comment.id,
      replyId: parent ? comment.id : null,
    };

    if (!isExisted && userInfo.id !== receiver) {
      await this.notificationService.sendOneToOneNotification(receiver, dataNotification);
    }
  }

  async removeNotificationLike(commentId: number) {
    const comment = await this.commentRepository.getOne(commentId, { user: true });
    const receiveId = comment.user.id;
    const remove = [];

    const notificationsRef = db.ref(`notifications/${receiveId}`);
    const snapshot = await notificationsRef.get();
    snapshot.forEach((childSnapshot) => {
      const value = childSnapshot.val().data;
      const isRead = childSnapshot.val().isRead;
      const checkId = value?.replyId ? value.replyId : value?.commentId;
      if (value?.type === NOTIFICATION_TYPE.LIKE && checkId === +commentId) {
        if (isRead === false) {
          remove.push(childSnapshot.ref.remove());
        } else {
          childSnapshot.ref.update({ hasDelete: true });
        }
      }
    });

    await Promise.all(remove);
  }
}
