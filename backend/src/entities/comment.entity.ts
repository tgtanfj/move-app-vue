import { Column, Entity, ManyToOne, OneToMany, Tree, TreeChildren, TreeParent } from 'typeorm';
import { BaseEntity } from './base/base.entity';
import { User } from './user.entity';
import { Video } from './video.entity';
import { CommentReaction } from './comment-reaction.entity';

@Entity('comments')
@Tree('closure-table')
export class Comment extends BaseEntity {
  @Column({
    type: 'varchar',
  })
  content: string;

  @Column({
    type: 'int',
    default: 0,
  })
  numberOfLike: number;

  @Column({
    type: 'int',
    default: 0,
  })
  numberOfReply: number;

  @ManyToOne(() => User, (user) => user.comments)
  user: User;

  @ManyToOne(() => Video, (video) => video.comments, { onDelete: 'CASCADE' })
  video: Video;

  @TreeChildren({ cascade: true })
  children: Comment[];

  @TreeParent({ onDelete: 'CASCADE' })
  parent: Comment;

  @OneToMany(() => CommentReaction, (commentReaction) => commentReaction.comment)
  commentReactions: CommentReaction[];
}
