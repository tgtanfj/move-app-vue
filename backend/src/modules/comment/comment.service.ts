import { BadRequestException, Injectable } from '@nestjs/common';
import { CommentRepository } from './comment.repository';

@Injectable()
export class CommentService {
  constructor(private readonly commentRepository: CommentRepository) {}

  async getNumberOfComments(videoId: number): Promise<number> {
    return await this.commentRepository.getNumberOfComments(videoId);
  }
}
