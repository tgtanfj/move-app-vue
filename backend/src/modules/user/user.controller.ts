import { Body, Controller, Delete, Get, Param, ParseIntPipe, Patch, Post, UseGuards } from '@nestjs/common';
import { UserService } from './user.service';
import { ApiBearerAuth, ApiNotFoundResponse, ApiOkResponse, ApiTags } from '@nestjs/swagger';
import { User } from '@/shared/decorators/user.decorator';
import { JwtAuthGuard } from '@/shared/guards/jwt-auth.guard';
import { ERRORS_DICTIONARY } from '@/shared/constraints/error-dictionary.constraint';
import { UserProfile } from './dto/response/user-profile.dto';

@ApiTags('user')
@ApiBearerAuth('jwt')
@Controller('user')
export class UserController {
  constructor(private readonly userService: UserService) {}

  // [GET]: /user/profile
  // Header: Authorization: AccessToken
  // Body: None
  @ApiOkResponse({ description: 'Fetch data successfully' })
  @ApiNotFoundResponse({ description: ERRORS_DICTIONARY.NOT_FOUND_ANY_USER })
  @UseGuards(JwtAuthGuard)
  @Get('/profile')
  async getProfile(@User() user): Promise<UserProfile> {
    return await this.userService.getProfile(user.id);
  }
}