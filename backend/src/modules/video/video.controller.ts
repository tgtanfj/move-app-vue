import {
  Body,
  Controller,
  Delete,
  Get,
  HttpCode,
  HttpStatus,
  Param,
  ParseArrayPipe,
  Patch,
  Post,
  Put,
  Query,
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
import { FileInterceptor, FilesInterceptor } from '@nestjs/platform-express';
import { User } from '@/shared/decorators/user.decorator';
import { ApiBody, ApiConsumes, ApiTags } from '@nestjs/swagger';
import { CreateVideoDTO } from './dto/create-video.dto';
import { EditVideoDTO } from './dto/edit-video.dto';
import { DeleteVideosDto } from './dto/request/delete-videos.dto';
import { ThumbnailsValidationPipe } from '@/shared/pipes/thumbnail-validation.pipe';

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

  // @Roles(Role.INSTRUCTOR)
  // @UseGuards(JwtAuthGuard)
  @Post('upload-video')
  @UseInterceptors(FilesInterceptor('thumbnails', 3))
  @ApiConsumes('multipart/form-data')
  async uploadVideo(
    @User() user,
    @UploadedFiles(ThumbnailsValidationPipe) files: Array<Express.Multer.File>,
    @Body() dto: UploadVideoDTO,
  ) {
    // const id = user.id;
    return await this.videoService.uploadVideo(1, files, dto);
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
}
