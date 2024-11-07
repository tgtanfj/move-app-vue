import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { ILike, Repository } from 'typeorm';
import { Category } from '@/entities/category.entity';
import { Channel } from '@/entities/channel.entity';
import { Video } from '@/entities/video.entity';
import { SearchHistory } from '@/entities/search-history.entity';
import { channel } from 'diagnostics_channel';

@Injectable()
export class SearchService {
  constructor(
    @InjectRepository(Category) private readonly categoryRepository: Repository<Category>,
    @InjectRepository(Channel) private readonly channelRepository: Repository<Channel>,
    @InjectRepository(Video) private readonly videoRepository: Repository<Video>,
    @InjectRepository(SearchHistory) private readonly searchHistoryRepository: Repository<SearchHistory>,
  ) {}

  async searchCategories(params: {
    query: string;
    page: number;
    limit: number;
  }): Promise<{ categories: Category[]; totalCount: number }> {
    const { query, page, limit } = params;
    const keyword = `%${query}%`;
    const offset = (page - 1) * limit;

    const [categories, totalCount] = await this.categoryRepository
      .createQueryBuilder('category')
      .where('category.title ILIKE :keyword', { keyword })
      .orderBy('category.numberOfViews', 'DESC')
      .skip(offset)
      .take(limit)
      .getManyAndCount();

    return { categories, totalCount };
  }

  async channelIdHasPublishedVideo(channelId: number): Promise<boolean> {
    const videoCount = await this.videoRepository.count({
      where: {
        channel: { id: channelId },
        isPublish: true, // Check if the video is published
      },
    });
    return videoCount > 0;
  }
  async searchChannels(params: {
    query: string;
    page: number;
    limit: number;
  }): Promise<{ channels: Channel[]; totalCount: number }> {
    const { query, page, limit } = params;
    const keyword = `%${query}%`;
    const offset = (page - 1) * limit;

    const [channels, totalCount] = await this.channelRepository
      .createQueryBuilder('channel')
      .where('channel.name ILIKE :keyword', { keyword })
      .orderBy('channel.numberOfFollowers', 'DESC')
      .addOrderBy('channel.isBlueBadge', 'DESC')
      .addOrderBy('channel.id', 'ASC')
      .skip(offset)
      .take(limit)
      .getManyAndCount();

    return { channels, totalCount };
  }

  async searchVideos(params: { query: string; page: number; limit: number }) {
    const { query, page, limit } = params;
    const keyword = query.toLowerCase();
    const offset = (page - 1) * limit;

    const [allVideos, totalItemCount] = await this.videoRepository.findAndCount({
      relations: ['channel', 'thumbnails', 'category'],
    });

    // Filter videos based on the keyword in title or channel name
    let filteredVideos = allVideos.filter(
      (video) =>
        video.title.toLowerCase().includes(keyword) ||
        (video.channel && video.channel.name.toLowerCase().includes(keyword)),
    );

    // Filter thumbnails to only include those with `selected` set to `true`
    filteredVideos = filteredVideos.map((video) => {
      video.thumbnails = video.thumbnails.filter((thumbnail) => thumbnail.selected);
      return video;
    });

    // Sort videos based on priority: channel followers, views, comments, and recency
    filteredVideos = filteredVideos.sort((a, b) => {
      const aFollowers = a.channel?.numberOfFollowers || 0;
      const bFollowers = b.channel?.numberOfFollowers || 0;

      if (bFollowers !== aFollowers) {
        return bFollowers - aFollowers;
      } else if (b.numberOfViews !== a.numberOfViews) {
        return b.numberOfViews - a.numberOfViews;
      } else if (b.numberOfComments !== a.numberOfComments) {
        return b.numberOfComments - a.numberOfComments;
      } else {
        return new Date(b.createdAt).getTime() - new Date(a.createdAt).getTime();
      }
    });

    // Paginate the sorted videos
    const paginatedVideos = filteredVideos.slice(offset, offset + limit);

    const totalPages = Math.ceil(filteredVideos.length / limit);
    const itemFrom = offset + 1;
    const itemTo = offset + paginatedVideos.length;

    return {
      videos: paginatedVideos,
      totalItemCount: filteredVideos.length,
      totalPages,
      itemFrom,
      itemTo,
    };
  }

  async suggestion(query: string) {
    const keyword = query.toLowerCase();
  
    // Lấy video ban đầu dựa trên từ khóa, sắp xếp theo `numberOfViews`, chỉ từ kênh có video
    let initialVideos = await this.videoRepository
      .createQueryBuilder('video')
      .leftJoinAndSelect('video.channel', 'channel')
      .leftJoinAndSelect('video.thumbnails', 'thumbnail')
      .where('video.title ILIKE :keyword', { keyword: `%${keyword}%` })
      .andWhere('channel.id IS NOT NULL') // Chỉ lấy video từ kênh có video
      .orderBy('video.numberOfViews', 'DESC')
      .getMany();
  
    // Lọc thumbnails để chỉ lấy những thumbnail có `selected` là `true`
    initialVideos = initialVideos.map((video) => {
      video.thumbnails = video.thumbnails.filter((thumbnail) => thumbnail.selected);
      return video;
    });
  
    // Lấy category dựa trên từ khóa
    const topCategories = await this.categoryRepository.find({
      where: { title: ILike(`%${keyword}%`) },
      order: { numberOfViews: 'DESC' },
      take: 5,
    });
  
    // Lấy channel dựa trên từ khóa, chỉ những kênh có ít nhất một video, sắp xếp theo số lượng followers
    let topInstructors = await this.channelRepository
      .createQueryBuilder('channel')
      .where('channel.name ILIKE :keyword', { keyword: `%${keyword}%` })
      .andWhere(
        (qb) =>
          `EXISTS(${qb
            .subQuery()
            .select('video.id')
            .from('videos', 'video')
            .where('video.channelId = channel.id')
            .getQuery()})`
      ) // Kiểm tra điều kiện channel có video mà không lấy dữ liệu video
      .orderBy('channel.numberOfFollowers', 'DESC')
      .getMany();
  
    // Sắp xếp video theo tiêu chí followers của channel, views, comments, createdAt
    const topVideos = initialVideos.sort((a, b) => {
      const aFollowers = a.channel?.numberOfFollowers || 0;
      const bFollowers = b.channel?.numberOfFollowers || 0;
      if (bFollowers !== aFollowers) return bFollowers - aFollowers;
      if (b.numberOfViews !== a.numberOfViews) return b.numberOfViews - a.numberOfViews;
      if (b.numberOfComments !== a.numberOfComments) return b.numberOfComments - a.numberOfComments;
      return new Date(b.createdAt).getTime() - new Date(a.createdAt).getTime();
    });
  
    // Sắp xếp instructors theo độ ưu tiên của badge
    topInstructors = topInstructors.sort((a, b) => {
      const priorityA = (a.isBlueBadge ? 2 : 0) + (a.isPinkBadge ? 1 : 0);
      const priorityB = (b.isBlueBadge ? 2 : 0) + (b.isPinkBadge ? 1 : 0);
      return priorityB - priorityA;
    });
  
    // Thiết lập số lượng mặc định của mỗi loại
    let numCategories = 1;
    let numChannels = 2;
    let numVideos = 2;
  
    // Điều chỉnh số lượng category, channel và video dựa trên các trường hợp
    if (topVideos.length < 2) {
      numVideos = topVideos.length;
      numChannels = Math.min(5 - numVideos, topInstructors.length);
      numCategories = 5 - numVideos - numChannels;
    } else if (topInstructors.length < 2) {
      numChannels = topInstructors.length;
      numVideos = Math.min(5 - numChannels, topVideos.length);
      numCategories = 5 - numVideos - numChannels;
    } else if (!topCategories.length) {
      numCategories = 0;
      numChannels = Math.min(5 - numCategories, topInstructors.length);
      numVideos = 5 - numCategories - numChannels;
    }
  
    // Lấy danh sách topCategories, topInstructors và topVideos theo số lượng đã tính
    const slicedCategories = topCategories.slice(0, numCategories);
    const slicedInstructors = topInstructors.slice(0, numChannels);
    const slicedVideos = topVideos.slice(0, numVideos);
  
    // Trả về kết quả với cấu trúc chỉ định
    return {
      topCategories: slicedCategories,
      topInstructors: slicedInstructors,
      topVideos: slicedVideos,
      hasTopCategory: slicedCategories.length > 0,
      topInstructorsCount: slicedInstructors.length,
    };
  }
  
  

  async saveSearchHistory(userId: number, content: string): Promise<SearchHistory> {
    if (userId == null) {
      throw new Error('userId is null or undefined');
    }

    const existingEntry = await this.searchHistoryRepository.findOne({
      where: { user: { id: userId }, content },
    });

    if (existingEntry) {
      return existingEntry;
    }
    const searchHistory = this.searchHistoryRepository.create({ user: { id: userId }, content });
    return await this.searchHistoryRepository.save(searchHistory);
  }

  async getSearchHistory(
    page: number,
    limit: number,
    userId: number,
  ): Promise<{ histories: SearchHistory[]; totalItemCount: number }> {
    const offset = (page - 1) * limit;
    const [histories, totalItemCount] = await this.searchHistoryRepository.findAndCount({
      where: { user: { id: userId } },
      order: { createdAt: 'DESC' },
      skip: offset,
      take: limit,
    });
    return { histories, totalItemCount };
  }

  async deleteSearchHistory(userId: number, content: string): Promise<void> {
    try {
      await this.searchHistoryRepository.delete({ user: { id: userId }, content });
    } catch (error) {
      throw new Error('Failed to delete search history');
    }
  }
}
