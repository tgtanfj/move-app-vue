import { Body, Controller, Delete, Get, Param, Patch, Post, UseGuards } from '@nestjs/common';
import { User } from '@/shared/decorators/user.decorator';
import { JwtAuthGuard } from '@/shared/guards';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { CommentReactionService } from './comment-reaction.service';
import { CreateCommentReactionDto } from './dto/create-comment-reaction.dto';
import { UpdateCommentReactionDto } from './dto/update-comment-reaction.dto';

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

  @Patch(':id')
  async updateCommentReaction(@Param('id') id: number, @Body() dto: UpdateCommentReactionDto) {
    return await this.commentReactionService.update(id, dto);
  }

  @Delete(':id')
  async deleteCommentReaction(@Param('id') id: number) {
    return await this.commentReactionService.delete(id);
  }
}
