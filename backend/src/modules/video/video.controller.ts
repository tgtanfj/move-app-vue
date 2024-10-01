import { Body, Controller, Get, Param, Post, Query, UploadedFile, UseGuards, UseInterceptors } from '@nestjs/common';
import { VideoService } from './video.service';
import { PaginationDto } from './dto/request/pagination.dto';
import { JwtAuthGuard } from '@/shared/guards/jwt-auth.guard';
import { UploadVideoDTO } from './dto/upload-video.dto';
import { FileInterceptor } from '@nestjs/platform-express';
import { User } from '@/shared/decorators/user.decorator';
import { ApiTags } from '@nestjs/swagger';
import { CreateVideoDTO } from './dto/create-video.dto';

@ApiTags('Video')
@Controller('video')
export class VideoController {
  constructor(private readonly videoService: VideoService) {}

  @Get('/dashboard')
  @UseGuards(JwtAuthGuard)
  // @Roles(Role.INSTRUCTOR)
  async getVideosDashboard(@User() user, @Query() paginationDto: PaginationDto) {
    return await this.videoService.getVideosDashboard(user.id, paginationDto);
  }
  // @UseGuards(JwtAuthGuard)
  @Post('create-upload-session')
  async createUploadSession(@Body() dto: CreateVideoDTO) {
    const data = await this.videoService.createUploadSession(dto.fileSize);
    return data;
  }

  // @UseGuards(JwtAuthGuard)
  @Post('upload-video')
  @UseInterceptors(FileInterceptor('thumbnail'))
  async uploadVideo(@User() user, @UploadedFile() file: Express.Multer.File, @Body() dto: UploadVideoDTO) {
    const id = user.id;
    return await this.videoService.uploadVideo(1, file, dto);
  }
}
