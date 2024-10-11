import {
  Body,
  Controller,
  Delete,
  Get,
  HttpCode,
  HttpStatus,
  NotFoundException,
  Param,
  ParseArrayPipe,
  ParseIntPipe,
  Patch,
  Post,
  Put,
  Query,
  Res,
  UploadedFile,
  UploadedFiles,
  UseGuards,
  UseInterceptors,
  UsePipes,
} from '@nestjs/common';
import { VideoService } from './video.service';
import { PaginationDto } from './dto/request/pagination.dto';
import { JwtAuthGuard } from '@/shared/guards/jwt-auth.guard';
import { UploadVideoDTO } from './dto/upload-video.dto';
import { FileFieldsInterceptor, FileInterceptor, FilesInterceptor } from '@nestjs/platform-express';
import { User } from '@/shared/decorators/user.decorator';
import { ApiBody, ApiConsumes, ApiTags } from '@nestjs/swagger';
import { CreateVideoDTO } from './dto/create-video.dto';
import { EditVideoDTO } from './dto/edit-video.dto';
import { DeleteVideosDto } from './dto/request/delete-videos.dto';
import { ThumbnailsValidationPipe } from '@/shared/pipes/thumbnail-validation.pipe';
import { OptionSharingDTO } from './dto/option-sharing.dto';

@ApiTags('Video')
@Controller('video')
export class VideoController {
  constructor(private readonly videoService: VideoService) {}

  @Get('/dashboard')
  // @UseGuards(JwtAuthGuard)
  // @Roles(Role.INSTRUCTOR)
  async getVideosDashboard(
    // @User() user,
    @Query() paginationDto: PaginationDto,
  ) {
    return await this.videoService.getVideosDashboard(
      // user.id,
      paginationDto,
    );
  }

  // @UseGuards(JwtAuthGuard)
  @Post('create-upload-session')
  async createUploadSession(@Body() dto: CreateVideoDTO) {
    const data = await this.videoService.createUploadSession(dto.fileSize);
    return data;
  }

  // @Roles(Role.INSTRUCTOR)
  // @UseGuards(JwtAuthGuard)
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
    return await this.videoService.uploadVideo(1, files.thumbnails, dto, savedVideo, files.video[0]);
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

  @Get(':videoId')
  async getUrlVideo(@Param('videoId') videoId: number) {
    return await this.videoService.sharingVideoUrlByNativeId(videoId);
  }

  @Get('download/:id')
  async downloadVideo(@Param('id', ParseIntPipe) videoId: number) {
    return await this.videoService.downloadVideo(videoId);
  }

  @Get()
  async test() {
    return await this.videoService.sortVideoByPriority()
  }
}
