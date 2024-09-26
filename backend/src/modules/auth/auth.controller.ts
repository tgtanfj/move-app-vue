import { Body, Controller, HttpCode, Post } from '@nestjs/common';
import { ApiTags } from '@nestjs/swagger';
import { SignUpEmailDto } from './dto/signup-email.dto';
import { AuthService } from './auth.service';
import { ForgotPasswordDTO } from './dto/forgot-password.dto';
import { ResetPassswordDTO } from './dto/reset-password.dto';

@ApiTags('Auth')
@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Post('signup/email')
  async signUpByEmail(@Body() signUpEmailDto: SignUpEmailDto) {
    return this.authService.signUpEmail(signUpEmailDto);
  }
  @Post('forgot-password')
  @HttpCode(200)
  async forgotPassword(@Body() dto: ForgotPasswordDTO) {
    return await this.authService.forgotPassword(dto.email);
  }
  @Post('reset-password')
  async resetPassword(@Body() dto: ResetPassswordDTO) {
    return await this.authService.resetPassword(dto.token, dto.newPassword);
  }
}
