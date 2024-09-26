import { Body, Controller, Post } from '@nestjs/common';
import { ApiTags } from '@nestjs/swagger';
import { AuthService } from './auth.service';
import { SignUpEmailDto } from './dto/signup-email.dto';

@ApiTags('Auth')
@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Post('signup/email')
  async signUpByEmail(@Body() signUpEmailDto: SignUpEmailDto) {
    return this.authService.signUpEmail(signUpEmailDto);
  }
}
