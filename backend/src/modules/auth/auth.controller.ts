import { TypeAccount } from '@/entities/enums/typeAccount.enum';
import { JwtRefreshGuard } from '@/shared/guards/jwt-refresh.guard';
import { LocalAuthGuard } from '@/shared/guards/local-auth.guard';
import { PublicIpAddressService } from '@/shared/utils/publicIpAddressService';
import { Body, Controller, Get, HttpCode, HttpStatus, Post, Request, UseGuards } from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { AuthService } from './auth.service';
import { ForgotPasswordDTO } from './dto/forgot-password.dto';
import { LoginDto } from './dto/login.dto';
import { ResetPasswordDTO } from './dto/reset-password.dto';
import { SignUpEmailDto } from './dto/signup-email.dto';
import { SocialTokenDto } from './dto/social-token.dto';

@ApiTags('Auth')
@ApiBearerAuth('jwt')
@Controller('auth')
export class AuthController {
  constructor(
    private readonly authService: AuthService,
    private readonly publicIpAddressService: PublicIpAddressService,
  ) {}

  @Post('signup/email')
  @HttpCode(HttpStatus.CREATED)
  async signUpByEmail(@Body() signUpEmailDto: SignUpEmailDto) {
    return await this.authService.signUpEmail(signUpEmailDto);
  }

  @Post('login/google')
  async loginGoogle(@Body() socialTokenDto: SocialTokenDto) {
    const { idToken } = socialTokenDto;
    return await this.authService.loginGoogle(idToken, TypeAccount.GOOGLE);
  }

  @Post('login/facebook')
  async loginFacebook(@Body() socialTokenDto: SocialTokenDto) {
    const { idToken } = socialTokenDto;
    return await this.authService.loginFacebook(idToken, TypeAccount.FACEBOOK);
  }
  @Post('forgot-password')
  @HttpCode(200)
  async forgotPassword(@Body() dto: ForgotPasswordDTO) {
    return await this.authService.forgotPassword(dto.email);
  }
  @Post('reset-password')
  async resetPassword(@Body() dto: ResetPasswordDTO) {
    return await this.authService.resetPassword(dto.token, dto.newPassword);
  }
  @Post('login')
  @HttpCode(HttpStatus.OK)
  @UseGuards(LocalAuthGuard)
  async login(@Request() req, @Body() loginDto: LoginDto) {
    const publicIp = await this.publicIpAddressService.getPublicIpAddress();

    const { refreshToken, id } = await this.authService.getRefreshToken(req.user.id, {
      ipAddress: publicIp,
      userAgent: req.headers['user-agent'],
    });

    const accessToken = await this.authService.getAccessToken(req.user.id, id);

    return {
      accessToken: accessToken,
      refreshToken: refreshToken,
    };
  }

  @Get('refresh')
  @UseGuards(JwtRefreshGuard)
  @HttpCode(HttpStatus.OK)
  async refresh(@Request() req) {
    return await this.authService.refresh(req.user);
  }
}
