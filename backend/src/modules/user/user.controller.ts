import {
  Body,
  Controller,
  Delete,
  Get,
  Param,
  ParseIntPipe,
  Patch,
  Post,
  UploadedFile,
  UseGuards,
  UseInterceptors,
} from '@nestjs/common';
import { UserService } from './user.service';
import { ApiBearerAuth, ApiConsumes, ApiNotFoundResponse, ApiOkResponse, ApiTags } from '@nestjs/swagger';
import { User } from '@/shared/decorators/user.decorator';
import { JwtAuthGuard } from '@/shared/guards/jwt-auth.guard';
import { ERRORS_DICTIONARY } from '@/shared/constraints/error-dictionary.constraint';
import { UserProfile } from './dto/response/user-profile.dto';
import { FileInterceptor } from '@nestjs/platform-express';
import { UpdateUserDto } from './dto/update-user.dto';
import { IFile } from '@/shared/interfaces/file.interface';
import { Role } from '@/entities/enums/role.enum';
import { Roles } from '@/shared/decorators/roles.decorator';
import { RolesGuard } from '@/shared/guards/roles.guard';

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

  @Patch('/edit-profile')
  @UseInterceptors(FileInterceptor('avatar'))
  @ApiConsumes('multipart/form-data')
  @UseGuards(JwtAuthGuard)
  async updateUser(@User() user, @UploadedFile() file: IFile, @Body() updateUserDto: UpdateUserDto) {
    return await this.userService.updateUser(user.id, updateUserDto, file);
  }

  @Get('/admin')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(Role.ADMIN)
  async getAll() {
    return await this.userService.findAll({
      country: true,
      state: true,
    });
  }
}
