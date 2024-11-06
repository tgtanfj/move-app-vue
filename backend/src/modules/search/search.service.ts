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
      relations: ['channel', 'comments', 'views'],
    });

    // Filter videos based on keyword in title or channel name
    let filteredVideos = allVideos.filter(
      (video) =>
        video.title.toLowerCase().includes(keyword) ||
        (video.channel && video.channel.name.toLowerCase().includes(keyword)),
    );

    console.log('filteredVideos', filteredVideos);

    // Apply priority sorting
    try {
      filteredVideos = filteredVideos
        .sort((a, b) => {
          // Xếp video có lượt xem lên trước video không có lượt xem
          const viewsA = a.views.length > 0 ? a.numberOfViews : 0;
          const viewsB = b.views.length > 0 ? b.numberOfViews : 0;

          // Sort by number of followers and video views
          if (b.channel.numberOfFollowers !== a.channel.numberOfFollowers) {
            return b.channel.numberOfFollowers - a.channel.numberOfFollowers;
          }
          if (viewsB !== viewsA) {
            return viewsB - viewsA;
          }

          // Sort by ratings and comment count
          if (b.ratings !== a.ratings) {
            return b.ratings - a.ratings;
          }
          if (b.numberOfComments !== a.numberOfComments) {
            return b.numberOfComments - a.numberOfComments;
          }

          // Sort by creation date
          return new Date(b.createdAt).getTime() - new Date(a.createdAt).getTime();
        })
        .filter((video) => {
          // Filter videos uploaded within the last 24 hours
          const timeframe = new Date();
          timeframe.setDate(timeframe.getDate() - 1);
          return new Date(video.createdAt) >= timeframe;
        });
    } catch (error) {
      console.error('Error while sorting and filtering videos:', error);
    }

    // Apply pagination
    const paginatedVideos = filteredVideos.slice(offset, offset + limit);
    console.log('paginatedVideos', paginatedVideos);

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

    let initialVideos = await this.videoRepository.find({
      where: [{ title: ILike(`%${keyword}%`) }, { keywords: ILike(`%${keyword}%`) }],
      relations: ['thumbnails', 'views'],
      order: { numberOfViews: 'DESC' },
    });

    // Lấy Top Category dựa vào keyword
    const topCategory = await this.categoryRepository.findOne({
      where: { title: ILike(`%${keyword}%`) },
      order: { numberOfViews: 'DESC' },
    });

    // Lấy Top Instructors dựa vào keyword và sắp xếp theo số lượng followers
    let topInstructors = await this.channelRepository.find({
      where: { name: ILike(`%${keyword}%`) },
      order: { numberOfFollowers: 'DESC' },
    });

    // Lọc ra các video có lượt xem trong ngày hôm qua
    const yesterday = new Date();
    yesterday.setDate(yesterday.getDate() - 1);

    const topVideos = initialVideos.sort((a, b) => {
      const viewsA = a.views.filter((view) => new Date(view.createdAt) >= yesterday);
      const viewsB = b.views.filter((view) => new Date(view.createdAt) >= yesterday);

      if (viewsA.length > 0 && viewsB.length === 0) {
        return -1; // a có lượt xem hôm qua, b không có
      } else if (viewsA.length === 0 && viewsB.length > 0) {
        return 1; // a không có lượt xem hôm qua, b có
      } else {
        return b.numberOfViews - a.numberOfViews;
      }
    });

    // Sắp xếp instructors theo badge (ưu tiên blue badge trước, sau đó pink badge)
    topInstructors = topInstructors.sort((a, b) => {
      const priorityA = (a.isBlueBadge ? 2 : 0) + (a.isPinkBadge ? 1 : 0);
      const priorityB = (b.isBlueBadge ? 2 : 0) + (b.isPinkBadge ? 1 : 0);
      return priorityB - priorityA;
    });

    // Chọn ra tối đa 2 instructors hàng đầu
    const topTwoInstructors = topInstructors.slice(0, 2);

    console.log('topCategory:', topCategory ? 'Exists' : 'Null');
    console.log('topTwoInstructors count:', topTwoInstructors.length);

    let numVideos = 5;

    if (topCategory) {
      numVideos -= 1;
    }

    if (topTwoInstructors) {
      numVideos -= topTwoInstructors.length;
    }

    const slicedVideos = topVideos.slice(0, numVideos);

    // Trả về kết quả với đúng cấu trúc yêu cầu
    return {
      topCategory: topCategory || null,
      topInstructors: topTwoInstructors.length > 0 ? topTwoInstructors : [],
      topVideos: slicedVideos,
      hasTopCategory: !!topCategory, // Thêm flag kiểm tra sự tồn tại của `topCategory`
      topInstructorsCount: topTwoInstructors.length, // Trả về số lượng `topTwoInstructors`
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
