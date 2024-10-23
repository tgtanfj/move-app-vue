import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { CommentReaction } from '@/entities/comment-reaction.entity';
import { JwtModule } from '@nestjs/jwt';
import { UserModule } from '../user/user.module';
import { CommentReactionController } from './comment-reaction.controller';
import { CommentReactionService } from './comment-reaction.service';
import { CommentReactionRepository } from './comment-reaction.repository';
import { CommentModule } from '../comment/comment.module';
import { NotificationModule } from '../notification/notification.module';

@Module({
  imports: [
    TypeOrmModule.forFeature([CommentReaction]),
    JwtModule,
    UserModule,
    CommentModule,
    NotificationModule,
  ],
  controllers: [CommentReactionController],
  providers: [CommentReactionService, CommentReactionRepository],
  exports: [CommentReactionService, CommentReactionRepository],
})
export class CommentReactionModule {}
