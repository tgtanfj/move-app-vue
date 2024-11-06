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

    // Find initial videos matching the keyword, sorted by `numberOfViews`
    let initialVideos = await this.videoRepository.find({
      where: [{ title: ILike(`%${keyword}%`) }],
      relations: ['channel', 'thumbnails'],
      order: { numberOfViews: 'DESC' },
    });

    // Filter thumbnails to only include those with `selected` set to `true`
    initialVideos = initialVideos.map((video) => {
      video.thumbnails = video.thumbnails.filter((thumbnail) => thumbnail.selected);
      return video;
    });

    // Get top category based on keyword
    const topCategory = await this.categoryRepository.findOne({
      where: { title: ILike(`%${keyword}%`) },
      order: { numberOfViews: 'DESC' },
    });

    // Get top instructors based on keyword, sorted by number of followers
    let topInstructors = await this.channelRepository.find({
      where: { name: ILike(`%${keyword}%`) },
      order: { numberOfFollowers: 'DESC' },
    });

    // Sort initial videos based on the specified criteria
    const topVideos = initialVideos.sort((a, b) => {
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

    // Sort instructors by badge priority: blue badge first, then pink badge
    topInstructors = topInstructors.sort((a, b) => {
      const priorityA = (a.isBlueBadge ? 2 : 0) + (a.isPinkBadge ? 1 : 0);
      const priorityB = (b.isBlueBadge ? 2 : 0) + (b.isPinkBadge ? 1 : 0);
      return priorityB - priorityA;
    });

    // Select up to the top 2 instructors
    const topTwoInstructors = topInstructors.slice(0, 2);

    let numVideos = 5;

    if (topCategory) {
      numVideos -= 1;
    }

    if (topTwoInstructors) {
      numVideos -= topTwoInstructors.length;
    }

    // Slice the top videos to match the calculated number
    const slicedVideos = topVideos.slice(0, numVideos);

    // Return the result with the specified structure
    return {
      topCategory: topCategory || null,
      topInstructors: topTwoInstructors.length > 0 ? topTwoInstructors : [],
      topVideos: slicedVideos,
      hasTopCategory: !!topCategory, // Flag indicating if `topCategory` exists
      topInstructorsCount: topTwoInstructors.length, // Number of `topTwoInstructors`
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
