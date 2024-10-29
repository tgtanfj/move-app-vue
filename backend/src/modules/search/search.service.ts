import { ConflictException, Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { DeepPartial, Repository } from 'typeorm';
import { Category } from '@/entities/category.entity';
import { Channel } from '@/entities/channel.entity';
import { Video } from '@/entities/video.entity';
import { CreateSearchHistoryDto } from './dto/create-search.dto';
import { SearchHistory } from '@/entities/search-history.entity';
import { VimeoService } from '@/shared/services/vimeo.service';

@Injectable()
export class SearchService {
  constructor(
    @InjectRepository(Category) private readonly categoryRepository: Repository<Category>,
    @InjectRepository(Channel) private readonly channelRepository: Repository<Channel>,
    @InjectRepository(Video) private readonly videoRepository: Repository<Video>,
    @InjectRepository(SearchHistory) private readonly searchHistoryRepository: Repository<SearchHistory>,
    private vimeoService: VimeoService,
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
      .orderBy('channel.isBlueBadge', 'DESC')
      .addOrderBy('channel.isPinkBadge', 'DESC')
      .addOrderBy('channel.id', 'ASC')
      .skip(offset)
      .take(limit)
      .getManyAndCount();

    return { channels, totalCount };
  }
  async searchVideos(params: { query: string; page: number; limit: number }): Promise<{
    videos: Video[];
    totalItemCount: number;
    totalPages: number;
    itemFrom: number;
    itemTo: number;
  }> {
    const { query, page, limit } = params;
    const keyword = `%${query}%`;
    const offset = (page - 1) * limit;

    const videosWithHighestViewsYesterday = await this.getVideosWithHighestViewsYesterday(
      keyword,
      offset,
      limit,
    );

    const [searchedVideos, totalCount] = await this.videoRepository
      .createQueryBuilder('video')
      .leftJoinAndSelect('video.category', 'category')
      .leftJoinAndSelect('video.channel', 'channel')
      .leftJoinAndSelect(
        'video.thumbnails',
        'thumbnail',
        'thumbnail.videoId = video.id AND thumbnail.selected = true',
      )
      .where('video.title ILIKE :keyword', { keyword })
      .skip(offset)
      .take(limit)
      .getManyAndCount();

    const combinedVideos = [...videosWithHighestViewsYesterday, ...searchedVideos];

    const uniqueVideos = combinedVideos.filter(
      (video, index, self) => index === self.findIndex((v) => v.id === video.id),
    );

    const limitedVideos = uniqueVideos.slice(0, limit);

    const totalPages = Math.ceil(totalCount / limit);
    const itemFrom = offset + 1;
    const itemTo = Math.min(offset + limit, totalCount);

    return { videos: limitedVideos, totalItemCount: totalCount, totalPages, itemFrom, itemTo };
  }

  private async getVideosWithHighestViewsYesterday(
    keyword: string,
    offset: number,
    limit: number,
  ): Promise<Video[]> {
    const yesterday = new Date();
    yesterday.setDate(yesterday.getDate() - 1);
    const yesterdayDateString = yesterday.toISOString().split('T')[0];

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

    // Truy vấn Top Category
    const topCategoryPromise = this.categoryRepository
      .createQueryBuilder('category')
      .select('category')
      .where('category.title ILIKE :keyword', { keyword })
      .orderBy('category.numberOfViews', 'DESC')
      .getOne();

    // Truy vấn Top Instructors (sắp xếp theo số lượng followers)
    const topInstructorsPromise = this.channelRepository
      .createQueryBuilder('channel')
      .select('channel')
      .where('channel.name ILIKE :keyword', { keyword })
      .orderBy('channel.numberOfFollowers', 'DESC')
      .getMany();

    // Truy vấn Top Videos với views của ngày hôm qua
    const topVideosPromise = this.getVideosWithHighestViewsYesterday(keyword, 0, 2);

    // Chạy các promises đồng thời
    const [topCategory, topInstructors, topVideos] = await Promise.all([
      topCategoryPromise,
      topInstructorsPromise,
      topVideosPromise,
    ]);

    // Nếu không có kết quả từ getVideosWithHighestViewsYesterday thì fallback bằng truy vấn trong bảng video
    let finalTopVideos = topVideos;
    if (finalTopVideos.length === 0) {
      finalTopVideos = await this.videoRepository
        .createQueryBuilder('video')
        .select('video')
        .leftJoinAndSelect('video.thumbnails', 'thumbnail')
        .where('video.title ILIKE :keyword OR video.keywords ILIKE :keyword', { keyword })
        .andWhere('thumbnail.selected = :isSelected', { isSelected: true })
        .orderBy('video.numberOfViews', 'DESC')
        .limit(2)
        .getMany();
    }

    // Sắp xếp instructors theo badge (ưu tiên blue badge trước, sau đó pink badge)
    const sortedInstructors = topInstructors.sort((a, b) => {
      const priorityA = (a.isBlueBadge ? 2 : 0) + (a.isPinkBadge ? 1 : 0);
      const priorityB = (b.isBlueBadge ? 2 : 0) + (b.isPinkBadge ? 1 : 0);
      return priorityB - priorityA;
    });

    // Chọn ra 2 instructors hàng đầu
    const topTwoInstructors = sortedInstructors.slice(0, 2);

    // Trả về kết quả
    return {
      topCategory: topCategory || 'Notfound',
      topInstructors: topTwoInstructors.length > 0 ? topTwoInstructors : 'Notfound',
      topVideos: finalTopVideos.length > 0 ? finalTopVideos : 'Notfound',
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
