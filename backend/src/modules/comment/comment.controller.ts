import { Body, Controller, Delete, Get, Param, Patch, Post, Query, UseGuards } from '@nestjs/common';
import { CommentService } from './comment.service';
import { CreateCommentDto } from './dto/create-comment.dto';
import { QueryCommentDto } from './dto/query-comment.dto';
import { UpdateCommentDto } from './dto/update-comment.dto';
import { User } from '@/shared/decorators/user.decorator';
import { JwtAuthGuard } from '@/shared/guards';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { Public } from '@/shared/decorators/public.decorator';

@ApiTags('comment')
@ApiBearerAuth('jwt')
@Controller('comment')
export class CommentController {
  constructor(private readonly commentService: CommentService) {}
  @UseGuards(JwtAuthGuard)
  @Post('')
  async createComment(@User() user, @Body() createCommentDto: CreateCommentDto) {
    const userInfo = { id: user.id, avatar: user.avatar, username: user.username };
    return await this.commentService.create(userInfo, createCommentDto);
  }

  @Get('all')
  async getAllComment() {
    return await this.commentService.getAll();
  }

  @Public()
  @UseGuards(JwtAuthGuard)
  @Get(':videoId/comments')
  async getCommentsOfVideo(
    @Param('videoId') videoId: number,
    @Query() query: QueryCommentDto,
    @User() user?,
  ) {
    const { limit, cursor } = query;
    const userId = user ? user.id : undefined;

    return await this.commentService.getCommentsOfVideo(videoId, limit, cursor, userId);
  }

  @Public()
  @UseGuards(JwtAuthGuard)
  @Get(':id/reply')
  async getReplyComments(@Param('id') id: number, @Query() query: QueryCommentDto, @User() user?) {
    const { limit, cursor } = query;
    const userId = user ? user.id : undefined;

    return await this.commentService.getReplyComments(id, limit, cursor, userId);
  }

  @Public()
  @UseGuards(JwtAuthGuard)
  @Get(':id')
  async getOne(@Param('id') id: number, @User() user?) {
    const userId = user ? user.id : undefined;
    return await this.commentService.getOneDetails(id, userId);
  }

  @Patch(':id')
  async updateComment(@Param('id') id: number, @Body() dto: UpdateCommentDto) {
    return await this.commentService.update(id, dto);
  }

  @Delete(':id')
  async deleteComment(@Param('id') id: number) {
    return await this.commentService.delete(id);
  }
}
