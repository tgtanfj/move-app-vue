import { BadRequestException, forwardRef, Inject, Injectable } from '@nestjs/common';
import { ChannelRepository } from './channel.repository';
import { ERRORS_DICTIONARY } from '@/shared/constraints/error-dictionary.constraint';
import { Channel } from '@/entities/channel.entity';
import { WorkoutLevel } from '@/entities/enums/workoutLevel.enum';
import { FilterWorkoutLevel, SortBy } from './dto/request/filter-video-channel.dto';
import { ChannelProfileDto } from './dto/response/channel-profile.dto';
import { plainToClass, plainToInstance } from 'class-transformer';
import { FollowService } from '../follow/follow.service';
import { ChannelItemDto } from './dto/response/channel-item.dto';
import { VideoService } from '../video/video.service';
import { VideoItemDto } from '../video/dto/response/video-item.dto';
import { SocialLink } from './dto/response/channel-profile.dto';
import { ChannelVideosDto } from './dto/response/channel-videos.dto';
import { PaginationDto } from '../video/dto/request/pagination.dto';
import { fixIntNumberResponse } from '@/shared/utils/fix-number-response.util';

@Injectable()
export class ChannelService {
  constructor(
    private readonly channelRepository: ChannelRepository,
    private readonly followService: FollowService,
    private readonly videoService: VideoService,
  ) {}

  async getChannelByUserId(userId: number): Promise<Channel> {
    return await this.channelRepository.getChannelByUserId(userId).catch((error) => {
      throw new BadRequestException(ERRORS_DICTIONARY.NOT_FOUND_ANY_CHANNEL_OF_THIS_USER);
    });
  }

  async findOne(channelId: number): Promise<Channel> {
    return await this.channelRepository.findOne(channelId).catch((error) => {
      throw new BadRequestException(ERRORS_DICTIONARY.NOT_FOUND_ANY_CHANNEL);
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
      throw new BadRequestException(ERRORS_DICTIONARY.NOT_FOUND_ANY_CHANNEL);
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
      throw new BadRequestException(ERRORS_DICTIONARY.NOT_FOUND_ANY_CHANNEL);
    });

    const channelProfileDto: ChannelProfileDto = plainToInstance(ChannelProfileDto, channel, {
      excludeExtraneousValues: true,
    });

    let isFollowed = null;
    if (userId) isFollowed = await this.followService.isFollowed(userId, channelId);

    const [followingChannels, socialLinks] = await Promise.all([
      this.followService
        .getFollowingChannels(channel.user.id, 4, { channel: true })
        .then(async (followings) => {
          return await Promise.all(
            followings.map(async (follow) => {
              const channelItem = plainToInstance(ChannelItemDto, follow.channel, {
                excludeExtraneousValues: true,
              });

              channelItem.numberOfFollowers = fixIntNumberResponse(channelItem.numberOfFollowers);

              return channelItem;
            }),
          );
        }),
      this.getSocialLinks(channel.facebookLink, channel.youtubeLink, channel.instagramLink),
    ]);

    channelProfileDto.isFollowed = isFollowed;
    channelProfileDto.numberOfFollowers = fixIntNumberResponse(channelProfileDto.numberOfFollowers);
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
}
