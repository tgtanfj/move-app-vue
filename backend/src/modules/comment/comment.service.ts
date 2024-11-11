import { Comment } from '@/entities/comment.entity';
import { NOTIFICATION_TYPE } from '@/shared/constraints/notification-message.constraint';
import { BadRequestException, Injectable, NotFoundException } from '@nestjs/common';
import { I18nService } from 'nestjs-i18n';
import { UpdateResult } from 'typeorm';
import { CommonNotificationDto } from '../notification/dto/common-notification.dto';
import { NotificationService } from '../notification/notification.service';
import { UserInfoDto } from '../user/dto/user-info.dto';
import { VideoRepository } from '../video/video.repository';
import { CommentRepository } from './comment.repository';
import { CreateCommentDto } from './dto/create-comment.dto';
import { UpdateCommentDto } from './dto/update-comment.dto';
import { db } from '@/shared/firebase/firebase.config';
import { Video } from '@/entities/video.entity';

@Injectable()
export class CommentService {
  constructor(
    private readonly commentRepository: CommentRepository,
    private readonly videoRepository: VideoRepository,
    private readonly notificationService: NotificationService,
    private readonly i18n: I18nService,
    // private readonly commentReactionRepository: CommentRepository,
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

  async getOneDetails(id: number, userId?: number) {
    return await this.commentRepository.getOneDetails(id, userId);
  }

  async getAll(): Promise<Comment[]> {
    return await this.commentRepository.getAll();
  }

  async create(userInfo: UserInfoDto, dto: CreateCommentDto) {
    try {
      const userId = userInfo.id;
      let video: Video;
      dto?.videoId && (video = await this.videoRepository.findOne(dto?.videoId));

      if (dto.commentId && !dto.videoId) {
        const comment = await this.commentRepository.getOne(dto.commentId, { video: true });
        await this.commentRepository.update(comment.id, { numberOfReply: comment.numberOfReply + 1 });
        video = comment.video;
        if (comment.video.isCommentable === false) {
          throw new BadRequestException(this.i18n.t('exceptions.comment.NOT_CREATE_COMMENT'));
        }
        const reply = await this.commentRepository.create(userId, dto);

        video.numberOfComments++;

        await this.videoRepository.save(video);
        await this.sendNotificationComment(userInfo, reply.id, dto);

        return reply;
      }

      if (!video) {
        throw new NotFoundException(this.i18n.t('exceptions.video.NOT_FOUND_VIDEO'));
      }

      if (video?.isCommentable === false) {
        throw new BadRequestException(this.i18n.t('exceptions.comment.NOT_CREATE_COMMENT'));
      }

      const comment = await this.commentRepository.create(userId, dto);
      video.numberOfComments++;

      await this.videoRepository.save(video);

      if (!dto?.numberOfReps) {
        await this.sendNotificationComment(userInfo, comment.id, dto);
      }

      return comment;
    } catch (error) {
      console.log(error);

      throw new BadRequestException(this.i18n.t('exceptions.comment.NOT_CREATE_COMMENT'));
    }
  }

  async update(commentId: number, dto: UpdateCommentDto): Promise<UpdateResult> {
    return await this.commentRepository.update(commentId, dto).catch((error) => {
      throw new BadRequestException(this.i18n.t('exceptions.comment.NOT_UPDATE_COMMENT'));
    });
  }

  async delete(id: number): Promise<void> {
    try {
      let videoId: number;
      const comment = await this.commentRepository.getOneWithVideo(id);

      if (comment?.parent) {
        await this.commentRepository.update(comment.parent.id, {
          numberOfReply: comment.parent.numberOfReply - 1,
        });
      }
      videoId = comment?.parent ? comment?.parent.video.id : comment.video.id;

      const video = await this.videoRepository.findOne(videoId);
      video.numberOfComments--;
      await this.videoRepository.save(video);

      if (!comment?.numberOfReps) {
        await this.removeNotificationComment(id);
      }

      await this.commentRepository.delete(id);
    } catch (error) {
      console.log(error);
      throw new BadRequestException(this.i18n.t('exceptions.comment.NOT_DELETE_COMMENT'));
    }
  }

  async sendNotificationComment(userInfo: UserInfoDto, commentId: number, dto: CreateCommentDto) {
    let receiverId: number;
    const isReply = !!dto.commentId;

    const video = await this.videoRepository.getOwnerVideo(dto.videoId);
    receiverId = video.channel.user.id;

    const parent = await this.commentRepository.getOneWithVideo(dto.commentId);
    isReply && (receiverId = parent.user.id);

    if (userInfo.id !== receiverId) {
      const dataNotification = {
        sender: userInfo,
        type: isReply ? NOTIFICATION_TYPE.REPLY : NOTIFICATION_TYPE.COMMENT,
        videoId: isReply ? parent.video.id : dto.videoId,
        videoTitle: isReply ? parent.video.title : video.title,
        commentId: isReply ? dto.commentId : commentId,
        commentContent: isReply ? parent.content : null,
        replyId: isReply ? commentId : null,
      };

      await this.notificationService.sendOneToOneNotification(receiverId, dataNotification);
    }
  }

  async removeNotificationComment(commentId: number) {
    let userId: number;
    const remove = [];
    const comment = await this.commentRepository.getOneWithVideo(commentId);
    userId = comment?.parent && comment.parent.user.id;

    if (!comment?.parent) {
      userId = (await this.videoRepository.getOwnerVideo(comment.video.id)).channel.user.id;
    }

    const notificationsRef = db.ref(`notifications/${userId}`);
    const snapshot = await notificationsRef.get();

    snapshot.forEach((childSnapshot) => {
      const value = childSnapshot.val().data;
      const isRead = childSnapshot.val().isRead;
      const type = comment?.parent ? NOTIFICATION_TYPE.REPLY : NOTIFICATION_TYPE.COMMENT;
      const checkId = comment?.parent ? value.replyId : value?.commentId;

      if (value?.type === type && checkId === +commentId) {
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
