import { ConflictException, Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { DeepPartial, Repository } from 'typeorm';
import { Category } from '@/entities/category.entity';
import { Channel } from '@/entities/channel.entity';
import { Video } from '@/entities/video.entity';
import { CreateSearchHistoryDto } from './dto/create-search.dto';
import { SearchHistory } from '@/entities/search-history.entity';

@Injectable()
export class SearchService {
  constructor(
    @InjectRepository(Category) private readonly categoryRepository: Repository<Category>,
    @InjectRepository(Channel) private readonly channelRepository: Repository<Channel>,
    @InjectRepository(Video) private readonly videoRepository: Repository<Video>,
    @InjectRepository(SearchHistory) private readonly searchHistoryRepository: Repository<SearchHistory>,
  ) {}

  async searchCategories(params: { query: string; page: number; limit: number }): Promise<Category[]> {
    const { query, page, limit } = params;
    const keyword = `%${query}%`;
    const offset = (page - 1) * limit;

    return await this.categoryRepository
      .createQueryBuilder('category')
      .where('category.title ILIKE :keyword', { keyword })
      .orderBy('category.numberOfViews', 'DESC') // Sort by views in descending order
      .skip(offset)
      .take(limit)
      .getMany();
  }

  async searchChannels(params: { query: string; page: number; limit: number }): Promise<Channel[]> {
    const { query, page, limit } = params;
    const keyword = `%${query}%`;
    const offset = (page - 1) * limit;

    return await this.channelRepository
      .createQueryBuilder('channel')
      .where('channel.name ILIKE :keyword', { keyword })
      .orderBy('channel.isBlueBadge', 'DESC')
      .addOrderBy('channel.isPinkBadge', 'DESC')
      .skip(offset)
      .take(limit)
      .getMany();
  }

  async searchVideos(params: { query: string; page: number; limit: number }): Promise<Video[]> {
    const { query, page, limit } = params;
    const keyword = `%${query}%`;
    const offset = (page - 1) * limit;

    const videosWithHighestViewsYesterday = await this.getVideosWithHighestViewsYesterday(
      keyword,
      offset,
      limit,
    );

    const searchedVideos = await this.videoRepository
      .createQueryBuilder('video')
      .leftJoinAndSelect('video.category', 'category')
      .leftJoinAndSelect('video.channel', 'channel')
      .where('video.title ILIKE :keyword', { keyword })
      .skip(offset)
      .take(limit)
      .getMany();

    const combinedVideos = [...videosWithHighestViewsYesterday, ...searchedVideos];

    const uniqueVideos = combinedVideos.filter(
      (video, index, self) => index === self.findIndex((v) => v.id === video.id),
    );

    const limitedVideos = uniqueVideos.slice(0, limit);
    return limitedVideos;
  }

  private async getVideosWithHighestViewsYesterday(
    keyword: string,
    offset: number,
    limit: number,
  ): Promise<Video[]> {
    const yesterday = new Date();
    yesterday.setDate(yesterday.getDate() - 1);
    const yesterdayDateString = yesterday.toISOString().split('T')[0];

    // Lấy video có lượt xem cao nhất vào ngày hôm qua theo từ khóa và phân trang
    const videosWithHighestViews = await this.videoRepository
      .createQueryBuilder('video')
      .leftJoinAndSelect('video.viewHistories', 'viewHistory')
      .where('video.title ILIKE :keyword', { keyword })
      .andWhere('viewHistory.viewDate = :yesterdayDate', { yesterdayDate: yesterdayDateString })
      .orderBy('viewHistory.views', 'DESC')
      .skip(offset)
      .take(limit)
      .getMany();

    return videosWithHighestViews;
  }

  async suggestion(query: string) {
    const keyword = `%${query}%`;

    const topCategoryPromise = this.categoryRepository
      .createQueryBuilder('category')
      .select('category')
      .where('category.title ILIKE :keyword', { keyword })
      .orderBy('category.numberOfViews', 'DESC')
      .getOne();

    const topInstructorsPromise = this.channelRepository
      .createQueryBuilder('channel')
      .select('channel')
      .where('channel.name ILIKE :keyword', { keyword })
      .orderBy('channel.numberOfFollowers', 'DESC')
      .getMany();

    const topVideosPromise = this.getVideosWithHighestViewsYesterday(keyword, 0, 2);

    const [topCategory, topInstructors, topVideos] = await Promise.all([
      topCategoryPromise,
      topInstructorsPromise,
      topVideosPromise,
    ]);

    const sortedInstructors = topInstructors.sort((a, b) => {
      const priorityA = (a.isBlueBadge ? 2 : 0) + (a.isPinkBadge ? 1 : 0);
      const priorityB = (b.isBlueBadge ? 2 : 0) + (b.isPinkBadge ? 1 : 0);
      return priorityB - priorityA;
    });

    const topTwoInstructors = sortedInstructors.slice(0, 2);

    return {
      topCategory: topCategory || 'Notfound',
      topInstructors: topTwoInstructors.length > 0 ? topTwoInstructors : 'Notfound',
      topVideos: topVideos.length > 0 ? topVideos : 'Notfound',
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

  async getSearchHistory(page: number, limit: number, userId: number): Promise<SearchHistory[]> {
    const offset = (page - 1) * limit;
    console.log('Service', userId);

    return await this.searchHistoryRepository.find({
      where: { user: { id: userId } },
      order: { createdAt: 'DESC' },
      skip: offset,
      take: limit,
    });
  }

  async deleteSearchHistory(userId: number, content: string): Promise<void> {
    try {
      await this.searchHistoryRepository.delete({ user: { id: userId }, content });
    } catch (error) {
      throw new Error('Failed to delete search history');
    }
  }
}
