import { Body, Controller, Delete, Get, Param, Patch, Post, UseGuards } from '@nestjs/common';
import { User } from '@/shared/decorators/user.decorator';
import { JwtAuthGuard } from '@/shared/guards';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { CommentReactionService } from './comment-reaction.service';
import { CreateCommentReactionDto } from './dto/create-comment-reaction.dto';
import { DeleteCommentReactionDto } from './dto/delete-comment-reaction.dto';

@ApiTags('comment reaction')
@ApiBearerAuth('jwt')
@Controller('comment-reaction')
export class CommentReactionController {
  constructor(private readonly commentReactionService: CommentReactionService) {}
  @UseGuards(JwtAuthGuard)
  @Post('')
  async createCommentReaction(@User() user, @Body() createCommentReactionDto: CreateCommentReactionDto) {
    const userId = user.id;
    return await this.commentReactionService.create(userId, createCommentReactionDto);
  }

  @Get('')
  async getAllCommentReaction() {
    return await this.commentReactionService.getAll();
  }

  @Get(':id')
  async getOne(@Param('id') id: number) {
    return await this.commentReactionService.getOne(id);
  }

  @UseGuards(JwtAuthGuard)
  @Patch('')
  async updateCommentReaction(@User() user, @Body() dto: CreateCommentReactionDto) {
    const userId = user.id;
    return await this.commentReactionService.update(userId, dto);
  }

  @UseGuards(JwtAuthGuard)
  @Delete(':id')
  async deleteCommentReaction(@User() user, @Body() dto: DeleteCommentReactionDto) {
    const userId = user.id;
    const commentId = dto.commentId;
    return await this.commentReactionService.delete(userId, commentId);
  }
}
