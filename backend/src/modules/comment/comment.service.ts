import { BadRequestException, Injectable, NotFoundException } from '@nestjs/common';
import { CommentRepository } from './comment.repository';
import { CreateCommentDto } from './dto/create-comment.dto';
import { UpdateCommentDto } from './dto/update-comment.dto';
import { UpdateResult } from 'typeorm';
import { Comment } from '@/entities/comment.entity';
import { ERRORS_DICTIONARY } from '@/shared/constraints/error-dictionary.constraint';
import { VideoRepository } from '../video/video.repository';
import { NotificationService } from '../notification/notification.service';
import { CommonNotificationDto } from '../notification/dto/common-notification.dto';
import { UserInfoDto } from '../user/dto/user-info.dto';
import { NOTIFICATION_MESSAGE } from '@/shared/constraints/notification-message.constraint';

@Injectable()
export class CommentService {
  constructor(
    private readonly commentRepository: CommentRepository,
    private readonly videoRepository: VideoRepository,
    private readonly notificationService: NotificationService,
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

  async create(userInfo: UserInfoDto, dto: CreateCommentDto) {
    try {
      const userId = userInfo.id;
      let videoId: number;
      let dataNotification: CommonNotificationDto;

      dto.videoId && (videoId = dto.videoId);
      const ownerVideo = await this.videoRepository.getOwnerVideo(videoId);

      if (dto.commentId && !dto.videoId) {
        const comment = await this.commentRepository.getOneWithVideo(dto.commentId);
        await this.commentRepository.update(comment.id, { numberOfReply: comment.numberOfReply + 1 });
        videoId = comment.video.id;
        const reply = await this.commentRepository.create(userId, dto);

        if (userInfo.id !== comment.user.id) {
          dataNotification = {
            sender: userInfo,
            content: `${NOTIFICATION_MESSAGE.REPLY_COMMENT_NOTIFICATION} ' ${comment.content} ' on your video`,
            videoId: videoId,
            videoTitle: comment.video.title,
            commentId: comment.id,
            commentContent: comment.content,
            replyId: reply.id,
          };
          await this.notificationService.sendOneToOneNotification(comment.user.id, dataNotification);
        }

        return reply;
      }

      const video = await this.videoRepository.findOne(videoId);
      if (!video) {
        throw new NotFoundException(ERRORS_DICTIONARY.NOT_FOUND_VIDEO);
      }
      const comment = await this.commentRepository.create(userId, dto);

      if (userInfo.id !== ownerVideo.channel.user.id) {
        dataNotification = {
          sender: userInfo,
          content: NOTIFICATION_MESSAGE.COMMENT_NOTIFICATION,
          videoId: video.id,
          videoTitle: video.title,
          commentId: comment.id,
        };
        await this.notificationService.sendOneToOneNotification(ownerVideo.channel.user.id, dataNotification);
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
