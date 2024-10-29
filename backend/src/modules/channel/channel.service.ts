import { Channel } from '@/entities/channel.entity';
import { ApiConfigService } from '@/shared/services/api-config.service';
import { BadRequestException, forwardRef, Inject, Injectable } from '@nestjs/common';
import { plainToInstance } from 'class-transformer';
import { I18nService } from 'nestjs-i18n';
import { FindOptionsRelations, Repository, UpdateResult } from 'typeorm';
import { EmailService } from '../email/email.service';
import { FollowService } from '../follow/follow.service';
import { PaginationDto } from '../video/dto/request/pagination.dto';
import { VideoService } from '../video/video.service';
import { ChannelRepository } from './channel.repository';
import {
  AnalyticSortBy,
  FilterWorkoutLevel,
  OrderBy,
  ShowBy,
  SortBy,
} from './dto/request/filter-video-channel.dto';
import { ChannelItemDto } from './dto/response/channel-item.dto';
import { ChannelProfileDto, SocialLink } from './dto/response/channel-profile.dto';
import { ChannelSettingDto } from './dto/response/channel-setting.dto';
import { CommentRepository } from '../comment/comment.repository';
import { InjectRepository } from '@nestjs/typeorm';
import { Comment } from '@/entities/comment.entity';
import { objectResponse } from '@/shared/utils/response-metadata.function';
import { PaginationMetadata } from '../video/dto/response/pagination.meta';
import { ThumbnailService } from '../thumbnail/thumbnail.service';
import { ViewService } from '../view/view.service';

@Injectable()
export class ChannelService {
  constructor(
    private readonly channelRepository: ChannelRepository,
    private readonly followService: FollowService,
    private readonly videoService: VideoService,
    private readonly emailService: EmailService,
    private readonly apiConfig: ApiConfigService,
    private readonly i18n: I18nService,
    private readonly commentRepository: CommentRepository,
    private readonly thumbnailService: ThumbnailService,
  ) {}

  async getChannelByUserId(userId: number): Promise<Channel> {
    return await this.channelRepository.getChannelByUserId(userId).catch((error) => {
      throw new BadRequestException(this.i18n.t('exceptions.social.NOT_FOUND_ANY_CHANNEL_OF_THIS_USER'));
    });
  }

  async findOne(channelId: number, relations?: FindOptionsRelations<Channel>): Promise<Channel> {
    return await this.channelRepository.findOne(channelId, relations).catch((error) => {
      throw new BadRequestException(this.i18n.t('exceptions.social.NOT_FOUND_ANY_CHANNEL'));
    });
  }

  async getChannelVideos(
    channelId: number,
    userId: number = undefined,
    workoutLevel: FilterWorkoutLevel = undefined,
    categoryId: number = undefined,
    sortBy: SortBy = undefined,
    paginationDto: PaginationDto = {
      take: 9,
      page: 1,
    },
  ): Promise<object> {
    await this.channelRepository.findOne(channelId).catch((error) => {
      throw new BadRequestException(this.i18n.t('exceptions.social.NOT_FOUND_ANY_CHANNEL'));
    });

    return await this.videoService.getChannelVideos(
      channelId,
      {
        workoutLevel,
        categoryId,
        sortBy,
      },
      paginationDto,
    );
  }

  async getChannelProfile(channelId: number, userId: number = null) {
    const channel = await this.channelRepository.findOne(channelId, { user: true }).catch((error) => {
      throw new BadRequestException(this.i18n.t('exceptions.social.NOT_FOUND_ANY_CHANNEL'));
    });

    const channelProfileDto: ChannelProfileDto = plainToInstance(ChannelProfileDto, channel, {
      excludeExtraneousValues: true,
    });

    const [followingChannels, socialLinks] = await Promise.all([
      this.followService.getFollowingChannels(channel.user.id, { channel: true }).then(async (followings) => {
        return await Promise.all(
          followings.map(async (follow) => {
            const channelItem = plainToInstance(ChannelItemDto, follow.channel, {
              excludeExtraneousValues: true,
            });

            channelItem.numberOfFollowers = +channelItem.numberOfFollowers;

            return channelItem;
          }),
        );
      }),
      this.getSocialLinks(channel.facebookLink, channel.youtubeLink, channel.instagramLink),
    ]);

    channelProfileDto.canFollow = null;
    channelProfileDto.isFollowed = null;

    if (userId) {
      channelProfileDto.canFollow = !(channel.user.id === userId);
      channelProfileDto.isFollowed = await this.followService.isFollowed(userId, channelId);
    }
    channelProfileDto.numberOfFollowers = +channelProfileDto.numberOfFollowers;
    channelProfileDto.followingChannels = followingChannels;
    channelProfileDto.socialLinks = socialLinks;

    return channelProfileDto;
  }

  private async getSocialLinks(facebookLink: string, youtubeLink: string, instagramLink: string) {
    const socialLinks: SocialLink[] = [];

    if (facebookLink) socialLinks.push({ name: 'facebook', link: facebookLink });

    if (youtubeLink) socialLinks.push({ name: 'youtube', link: youtubeLink });

    if (instagramLink) socialLinks.push({ name: 'instagram', link: instagramLink });

    return socialLinks;
  }

  async increaseFollow(channelId: number) {
    const channel = await this.findOne(channelId);
    channel.numberOfFollowers = channel.numberOfFollowers + 1;
    if (channel.numberOfFollowers > 10000) {
      channel.isBlueBadge = true;
      // const foundUser = await this.channelRepository.getUserByChannel(channelId)

      // if (!foundUser) {
      //   throw new BadRequestException('1')
      // }
      // const link = `${this.apiConfig.getString('FRONT_END_URL')}/channel/${channel.id}`
      // send mail
      // const dto: MailDTO = {
      //   subject: 'Password reset',
      //   to: foundUser.user.email,
      //   html: getTemplateBlueBadge(channel.name, link),
      //   from: this.apiConfig.getString('MAIL_USER'),
      // };
      // this.emailService.sendMail(dto);
    }
    return await this.channelRepository.updateChannel(channel);
  }

  async decreaseFollow(channelId: number) {
    const channel = await this.findOne(channelId);
    if (channel.numberOfFollowers === 0) {
      throw new BadRequestException();
    }
    channel.numberOfFollowers = channel.numberOfFollowers - 1;
    if (channel.numberOfFollowers < 10000) {
      channel.isBlueBadge = false;
    }
    return await this.channelRepository.updateChannel(channel);
  }

  async getUserByChannel(channelId: number) {}

  async updateREPs(channelId: number, numberOfREPs: number): Promise<UpdateResult> {
    return this.channelRepository.updateREPs(channelId, numberOfREPs);
  }

  async getChannelSetting(userId: number) {
    const channel = await this.getChannelByUserId(userId);

    const channelSettingDto = plainToInstance(ChannelSettingDto, channel, { excludeExtraneousValues: true });
    channelSettingDto.socialLinks = await this.getSocialLinks(
      channel.facebookLink,
      channel.youtubeLink,
      channel.instagramLink,
    );

    return channelSettingDto;
  }

  async getChannelReps(userId: number) {
    const channel = await this.getChannelByUserId(userId);
    return {
      numberOfREPs: channel.numberOfREPs,
      emailPayPal: channel.emailPayPal,
    };
  }

  async createChannel(userId: number, dto: any) {
    return this.channelRepository.createChannel(userId, dto);
  }

  async editChannel(channelId: number, dto: Partial<Channel>) {
    return await this.channelRepository.editChannel(channelId, dto);
  }

  async updateEmailPayPal(channelId: number, emailPayPal: string): Promise<UpdateResult> {
    return await this.channelRepository.updateEmailPayPal(channelId, emailPayPal);
  }

  async setUpPayPal(userId: number, email: string) {
    const channel = await this.getChannelByUserId(userId);
    await this.channelRepository.updateEmailPayPal(channel.id, email);
    return await this.getChannelReps(userId);
  }

  async overViewAnalytic(userId: number) {
    const { id, numberOfFollowers, numberOfREPs } = await this.channelRepository.getChannelByUserId(userId);
    if (!id) {
      throw new BadRequestException(`Channel not found`);
    }
    const [totalView, totalTime, lastVideo] = await Promise.all([
      this.videoService.getTotalViewOfChannel(id),
      this.videoService.getTotalSecondsOfChannel(id),
      this.videoService.getLastVideoOfChannel(id),
    ]);
    const avgTime = totalView ? totalTime / totalView : 0;
    return {
      numberOfFollowers,
      numberOfREPs,
      totalView: totalView || 0,
      avgTime,
      lastVideo,
    };
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
    return await this.commentRepository.getAllComments(userId, filter, sortBy, page, pageSize);
  }

  async videoAnalytics(
    userId: number,
    showBy: ShowBy,
    sortBy: AnalyticSortBy,
    page: number = 1,
    take = 10,
    asc?: boolean,
  ) {
    const time = new Date();

    const timeFrames: Record<ShowBy, number> = {
      [ShowBy.LAST_7_DAYS]: 7,
      [ShowBy.LAST_30_DAYS]: 30,
      [ShowBy.LAST_90_DAYS]: 90,
      [ShowBy.ONE_YEAR_AGO]: 365,
      [ShowBy.ALL_TIME]: 9999,
    };

    if (showBy in timeFrames) {
      time.setDate(time.getDate() - timeFrames[showBy]);
    }

    const orderby: OrderBy = {
      field:
        sortBy === AnalyticSortBy.RATINGS
          ? 'video_ratings'
          : sortBy === AnalyticSortBy.REPS
            ? 'total_reps'
            : 'total_views',
      direction: asc ? 'ASC' : 'DESC',
    };
    const timeFomat = time.toISOString().split('T')[0];
    const offset = (page - 1) * take;
    const foundChannel = await this.getChannelByUserId(userId);

    const analyticsMethod =
      showBy === ShowBy.ALL_TIME
        ? this.videoService.videoAnalyticDashboard
        : this.videoService.videoAnalyticDashboardByQuery;

    const { totalCount, result } = await analyticsMethod.call(
      this.videoService,
      foundChannel.id,
      timeFomat,
      orderby,
      take,
      offset,
    );

    if (result.length === 0) {
      return [];
    }

    const update = await Promise.all(
      result.map(async (video) => {
        const thumbnail = await this.thumbnailService.getSelectedThumbnail(video.video_id);
        const { total_seconds, total_reps, total_views, ...obj } = video;
        return {
          ...obj,
          total_reps: total_reps || 0,
          total_views: total_views || 0,
          avg_watch: total_views ? total_seconds / total_views : 0,
          thumbnail: thumbnail?.image,
        };
      }),
    );

    const totalPage = Math.ceil(totalCount / take);
    return objectResponse(update, new PaginationMetadata(totalCount, page, take, totalPage));
  }

  async updateChannel(channel: Channel) {
    return await this.channelRepository.updateChannel(channel);
  }
}
