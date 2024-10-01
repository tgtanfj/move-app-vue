import { Controller } from '@nestjs/common';
import { WatchingVideoHistoryService } from './watching-video-history.service';

@Controller('watching-video-history')
export class WatchingVideoHistoryController {
  constructor(private readonly watchingVideoHistoryService: WatchingVideoHistoryService) {}
}
