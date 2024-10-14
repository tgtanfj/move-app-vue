import {
  Body,
  Controller,
  Get,
  Post,
  Query,
  UseGuards,
  HttpException,
  HttpStatus,
  Delete,
} from '@nestjs/common';
import { SearchService } from './search.service';
import { ApiBearerAuth, ApiQuery, ApiTags } from '@nestjs/swagger';
import { CreateSearchHistoryDto } from './dto/create-search.dto';
import { SearchHistory } from '@/entities/search-history.entity';
import { JwtAuthGuard } from '@/shared/guards';
import { User } from '@/shared/decorators/user.decorator';

@ApiTags('Search')
@ApiBearerAuth('jwt')
@Controller()
export class SearchController {
  constructor(private readonly searchService: SearchService) {}

  @Get('/search/categories')
  @ApiQuery({ name: 'q', required: true, type: String, description: 'Search query' })
  @ApiQuery({ name: 'page', required: false, type: Number, description: 'Page number for categories' })
  @ApiQuery({ name: 'limit', required: false, type: Number, description: 'Limit for categories' })
  async searchCategories(@Query('q') query: string, @Query('page') page = 1, @Query('limit') limit = 10) {
    try {
      const searchParams = { query, page, limit };
      const { categories, totalCount } = await this.searchService.searchCategories(searchParams);
      const totalPages = Math.ceil(totalCount / limit);
      const itemFrom = (page - 1) * limit + 1;
      const itemTo = Math.min(page * limit, totalCount);

      return {
        data: categories,
        meta: {
          totalItemCount: totalCount,
          totalPages,
          itemFrom,
          itemTo,
        },
      };
    } catch (error) {
      throw new HttpException('Failed to search categories', HttpStatus.INTERNAL_SERVER_ERROR);
    }
  }

  @Get('/search/channels')
  @ApiQuery({ name: 'q', required: true, type: String, description: 'Search query' })
  @ApiQuery({ name: 'page', required: false, type: Number, description: 'Page number for channels' })
  @ApiQuery({ name: 'limit', required: false, type: Number, description: 'Limit for channels' })
  async searchChannels(@Query('q') query: string, @Query('page') page = 1, @Query('limit') limit = 10) {
    try {
      const searchParams = { query, page, limit };
      const { channels, totalCount } = await this.searchService.searchChannels(searchParams);
      const totalPages = Math.ceil(totalCount / limit);
      const itemFrom = (page - 1) * limit + 1;
      const itemTo = Math.min(page * limit, totalCount);

      return {
        type: 'channels',
        data: channels,
        meta: {
          totalItemCount: totalCount,
          totalPages,
          itemFrom,
          itemTo,
        },
      };
    } catch (error) {
      throw new HttpException('Failed to search channels', HttpStatus.INTERNAL_SERVER_ERROR);
    }
  }

  @Get('/search/videos')
  @ApiQuery({ name: 'q', required: true, type: String, description: 'Search query' })
  @ApiQuery({ name: 'page', required: false, type: Number, description: 'Page number for videos' })
  @ApiQuery({ name: 'limit', required: false, type: Number, description: 'Limit for videos' })
  async searchVideos(@Query('q') query: string, @Query('page') page = 1, @Query('limit') limit = 10) {
    try {
      const searchParams = { query, page, limit };
      const { videos, totalItemCount, totalPages, itemFrom, itemTo } =
        await this.searchService.searchVideos(searchParams);
      return {
        type: 'videos',
        data: videos,
        meta: {
          totalItemCount,
          totalPages,
          itemFrom,
          itemTo,
        },
      };
    } catch (error) {
      throw new HttpException('Failed to search videos', HttpStatus.INTERNAL_SERVER_ERROR);
    }
  }

  @Get('/search/suggestion')
  async suggestionVideo(@Query('q') query: string) {
    try {
      const results = await this.searchService.suggestion(query);
      return results;
    } catch (error) {
      throw new HttpException('Failed to get suggestions', HttpStatus.INTERNAL_SERVER_ERROR);
    }
  }

  @UseGuards(JwtAuthGuard)
  @Post('/search/history')
  async saveSearchHistory(@User() user, @Body() createSearchHistoryDto: CreateSearchHistoryDto) {
    try {
      const userId = user.id;
      const { content } = createSearchHistoryDto;
      const result = await this.searchService.saveSearchHistory(userId, content);
      return result;
    } catch (error) {
      throw new HttpException('Failed to save search history', HttpStatus.INTERNAL_SERVER_ERROR);
    }
  }

  @UseGuards(JwtAuthGuard)
  @Get('/search/history')
  @ApiQuery({ name: 'page', required: false, type: Number, description: 'Page number for search history' })
  @ApiQuery({ name: 'limit', required: false, type: Number, description: 'Limit for search history' })
  async getSearchHistory(
    @Query('page') page = 1,
    @Query('limit') limit = 10,
    @User() user,
  ): Promise<{
    histories: SearchHistory[];
    totalItemCount: number;
    totalPages: number;
    itemFrom: number;
    itemTo: number;
  }> {
    try {
      const userId = user.id;
      const { histories, totalItemCount } = await this.searchService.getSearchHistory(page, limit, userId);
      const totalPages = Math.ceil(totalItemCount / limit);
      const itemFrom = (page - 1) * limit + 1;
      const itemTo = Math.min(page * limit, totalItemCount);
      return {
        histories,
        totalItemCount,
        totalPages,
        itemFrom,
        itemTo,
      };
    } catch (error) {
      throw new HttpException('Failed to get search history', HttpStatus.INTERNAL_SERVER_ERROR);
    }
  }

  @UseGuards(JwtAuthGuard)
  @Delete('/search/history')
  async deleteSearchHistory(@User() user, @Query('content') content: string) {
    try {
      const userId = user.id;
      await this.searchService.deleteSearchHistory(userId, content);
      return { message: 'Search history deleted successfully' };
    } catch (error) {
      throw new HttpException('Failed to delete search history', HttpStatus.INTERNAL_SERVER_ERROR);
    }
  }
}
