import { Body, Controller, Patch, UseGuards } from '@nestjs/common';
import { WatchingVideoHistoryService } from './watching-video-history.service';
import { JwtAuthGuard } from '@/shared/guards';
import { User } from '@/shared/decorators/user.decorator';
import { RateDto } from './dto/rate.dto';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';

@ApiTags('Watching video history')
@ApiBearerAuth('jwt')
@Controller('watching-video-history')
export class WatchingVideoHistoryController {
  constructor(private readonly watchingVideoHistoryService: WatchingVideoHistoryService) {}

  @UseGuards(JwtAuthGuard)
  @Patch('rate')
  async rateVideoHistory(@User() user, @Body() dto: RateDto) {
    const userId = user.id;
    return await this.watchingVideoHistoryService.rate(userId, dto);
  }
}
