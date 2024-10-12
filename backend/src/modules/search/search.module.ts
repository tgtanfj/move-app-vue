import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { SearchService } from './search.service';
import { SearchController } from './search.controller';
import { Video } from '@/entities/video.entity';
import { Channel } from '@/entities/channel.entity';
import { Category } from '@/entities/category.entity';
import { SearchHistory } from '@/entities/search-history.entity';
import { JwtModule } from '@nestjs/jwt';
import { UserModule } from '../user/user.module';

@Module({
  imports: [TypeOrmModule.forFeature([Category, Channel, Video, SearchHistory]), JwtModule, UserModule],
  providers: [SearchService],
  controllers: [SearchController],
})
export class SearchModule {}
