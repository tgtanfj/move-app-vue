import { Body, Controller, Post } from '@nestjs/common';
import { ViewService } from './view.service';
import { CreateUpdateViewDto } from './dto/create-update-view.dto';
import { ApiTags } from '@nestjs/swagger';

@ApiTags('View')
@Controller('view')
export class ViewController {
  constructor(private readonly viewService: ViewService) {}

  @Post('')
  async createUpdateViewDate(@Body() body: CreateUpdateViewDto) {
    return await this.viewService.createUpdateViewDate(body);
  }
}
