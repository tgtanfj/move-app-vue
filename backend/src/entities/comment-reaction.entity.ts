import { Column, Entity, ManyToOne } from 'typeorm';
import { BaseEntity } from './base/base.entity';
import { User } from './user.entity';
import { Comment } from './comment.entity';

@Entity('comment-reactions')
export class CommentReaction extends BaseEntity {
  @Column({
    type: 'boolean',
    default: true,
  })
  isLike: boolean;

  @ManyToOne(() => User, (user) => user.commentReactions, { onDelete: 'CASCADE' })
  user: User;

  @ManyToOne(() => Comment, (comment) => comment.commentReactions, { onDelete: 'CASCADE' })
  comment: Comment;
}
