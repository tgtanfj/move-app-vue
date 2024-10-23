import { Public } from '@/shared/decorators/public.decorator';
import { User } from '@/shared/decorators/user.decorator';
import { JwtAuthGuard } from '@/shared/guards/jwt-auth.guard';
import {
  Body,
  Controller,
  Delete,
  Get,
  HttpCode,
  HttpStatus,
  Param,
  ParseIntPipe,
  Patch,
  Post,
  Put,
  Query,
  UploadedFile,
  UploadedFiles,
  UseGuards,
  UseInterceptors,
} from '@nestjs/common';
import { FileFieldsInterceptor, FileInterceptor } from '@nestjs/platform-express';
import { ApiBearerAuth, ApiConsumes, ApiTags } from '@nestjs/swagger';
import { CreateVideoDTO } from './dto/create-video.dto';
import { EditVideoDTO } from './dto/edit-video.dto';
import { OptionSharingDTO } from './dto/option-sharing.dto';
import { DeleteVideosDto } from './dto/request/delete-videos.dto';
import { DetailVideoAnalyticDTO } from './dto/request/detail-video-analytic.dto';
import { PaginationDto } from './dto/request/pagination.dto';
import { UploadVideoDTO } from './dto/upload-video.dto';
import { VideoService } from './video.service';

@ApiTags('Video')
@ApiBearerAuth('jwt')
@Controller('video')
export class VideoController {
  constructor(private readonly videoService: VideoService) {}

  @Get('/dashboard')
  @UseGuards(JwtAuthGuard)
  // @Roles(Role.INSTRUCTOR)
  async getVideosDashboard(@User() user, @Query() paginationDto: PaginationDto) {
    return await this.videoService.getVideosDashboard(user.id, paginationDto);
  }

  @UseGuards(JwtAuthGuard)
  @Post('create-upload-session')
  async createUploadSession(@Body() dto: CreateVideoDTO) {
    const data = await this.videoService.createUploadSession(dto.fileSize);
    return data;
  }

  // @Roles(Role.INSTRUCTOR)
  @UseGuards(JwtAuthGuard)
  @Post('upload-video')
  @UseInterceptors(
    FileFieldsInterceptor([
      { name: 'thumbnails', maxCount: 6 },
      { name: 'video', maxCount: 1 },
    ]),
  )
  @ApiConsumes('multipart/form-data')
  async uploadVideo(
    @User() user,
    @UploadedFiles()
    files: {
      thumbnails?: Express.Multer.File[];
      video?: Express.Multer.File;
    },
    @Body() dto: UploadVideoDTO,
  ) {
    const savedVideo = await this.videoService.saveVideoToServer(files.video[0]);
    return await this.videoService.uploadVideo(user.id, files.thumbnails, dto, savedVideo, files.video[0]);
  }

  @Put('edit-video/:videoId')
  @UseInterceptors(FileInterceptor('thumbnail'))
  async editVideo(
    @Param('videoId') videoId: number,
    @UploadedFile() file: Express.Multer.File,
    @Body() dto: EditVideoDTO,
  ) {
    return await this.videoService.editVideo(videoId, dto, file);
  }
  @Delete()
  @HttpCode(HttpStatus.OK)
  async deleteVideos(@Body() deleteVideosDto: DeleteVideosDto) {
    return await this.videoService.deleteVideos(deleteVideosDto.videoIds);
  }

  @Patch('restore')
  async restoreVideos(@Body() deleteVideosDto: DeleteVideosDto) {
    return await this.videoService.restoreVideos(deleteVideosDto.videoIds);
  }

  @Get('social-sharing/:videoId')
  async getUrlSharingSocial(@Param('videoId') videoId: number, @Query() option: OptionSharingDTO) {
    return await this.videoService.sharingVideoUrlById(videoId, option);
  }

  @Public()
  @UseGuards(JwtAuthGuard)
  @Get(':videoId/details')
  async getVideoDetails(@Param('videoId') videoId: number, @User() user?) {
    const userId = user ? user.id : undefined;
    return await this.videoService.getVideoDetails(videoId, userId);
  }

  @Get(':videoId')
  async getUrlVideo(@Param('videoId') videoId: number) {
    return await this.videoService.sharingVideoUrlByNativeId(videoId);
  }

  @Get('download/:id')
  async downloadVideo(@Param('id', ParseIntPipe) videoId: number) {
    return await this.videoService.downloadVideo(videoId);
  }

  @UseGuards(JwtAuthGuard)
  @Get('analytic/:videoId')
  async overviewVideoAnalytic(
    @Param('videoId') videoId: number,
    @User() user,
    @Query() query: DetailVideoAnalyticDTO,
  ) {
    // return await this.videoService.sortVideoByPriority();
    return await this.videoService.overviewVideoAnalytic(videoId, user.id, query.option);
  }

  @UseGuards(JwtAuthGuard)
  @Get('analytic/graphic/:videoId')
  async demoGraphicVideoAnalytic(
    @Param('videoId') videoId: number,
    @User() user,
    @Query() query: DetailVideoAnalyticDTO,
  ) {
    // return await this.videoService.sortVideoByPriority();
    const time = new Date();
    time.setDate(time.getDate() - 100);
    const timeFomat = time.toISOString().split('T')[0];
    return await this.videoService.graphicGender(videoId, timeFomat);
  }
}
