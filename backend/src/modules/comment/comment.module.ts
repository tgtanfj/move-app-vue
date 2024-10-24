import { forwardRef, Module } from '@nestjs/common';
import { CommentService } from './comment.service';
import { CommentController } from './comment.controller';
import { TypeOrmModule } from '@nestjs/typeorm';
import { CommentRepository } from './comment.repository';
import { Comment } from '@/entities/comment.entity';
import { JwtModule } from '@nestjs/jwt';
import { UserModule } from '../user/user.module';
import { VideoModule } from '../video/video.module';
import { CommentReaction } from '@/entities/comment-reaction.entity';
import { Donation } from '@/entities/donation.entity';
import { NotificationModule } from '../notification/notification.module';

@Module({
  imports: [
    TypeOrmModule.forFeature([Comment, CommentReaction, Donation]),
    JwtModule,
    forwardRef(() => UserModule),
    forwardRef(() => VideoModule),
    NotificationModule,
  ],
  controllers: [CommentController],
  providers: [CommentService, CommentRepository],
  exports: [CommentService, CommentRepository],
})
export class CommentModule {}
