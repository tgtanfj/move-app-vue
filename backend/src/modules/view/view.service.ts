import { Injectable } from '@nestjs/common';
import { ViewRepository } from './view.repository';

@Injectable()
export class ViewService {
  constructor(private viewRepository: ViewRepository) {}
  async getTotalViewInOnTime(time: Date, videoId: number) {
    return await this.viewRepository.getTotalView(time, videoId);
  }
}
