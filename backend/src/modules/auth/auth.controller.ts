import { TypeAccount } from '@/entities/enums/typeAccount.enum';
import { infoLoginSocial } from '@/shared/interfaces/login-social.interface';
import { JwtRefreshGuard, JwtAuthGuard, LocalAuthGuard } from '@/shared/guards';
import { PublicIpAddressService } from '@/shared/utils/publicIpAddressService';
import { Body, Controller, Get, HttpCode, HttpStatus, Post, Req, Request, UseGuards } from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { AuthService } from './auth.service';
import { ForgotPasswordDTO } from './dto/forgot-password.dto';
import { LoginDto } from './dto/login.dto';
import { OtpVerifyDto } from './dto/otp-verify.dto';
import { ResetPasswordDTO } from './dto/reset-password.dto';
import { SignUpEmailDto } from './dto/signup-email.dto';
import { SocialTokenDto } from './dto/social-token.dto';
import { ChangePasswordDTO } from './dto/change-password.dto';

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
  async loginGoogle(@Body() socialTokenDto: SocialTokenDto, @Req() req: Request) {
    const publicIp = await this.publicIpAddressService.getPublicIpAddress();

    const infoLoginSocial: infoLoginSocial = {
      idToken: socialTokenDto.idToken,
      type: TypeAccount.GOOGLE,
      publicIp: publicIp,
      userAgent: req.headers['user-agent'],
    };

    return await this.authService.loginSocial(infoLoginSocial);
  }

  @Post('login/facebook')
  async loginFacebook(@Body() socialTokenDto: SocialTokenDto, @Req() req: Request) {
    const publicIp = await this.publicIpAddressService.getPublicIpAddress();

    const infoLoginSocial: infoLoginSocial = {
      idToken: socialTokenDto.idToken,
      type: TypeAccount.FACEBOOK,
      publicIp: publicIp,
      userAgent: req.headers['user-agent'],
    };

    return await this.authService.loginSocial(infoLoginSocial);
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

    const userAgent = req.headers['user-agent'];

    const userId = req.user.id;

    return await this.authService.login(userId, publicIp, userAgent);
  }

  @Get('refresh')
  @UseGuards(JwtRefreshGuard)
  @HttpCode(HttpStatus.OK)
  async refresh(@Request() req) {
    return await this.authService.refresh(req.user);
  }

  @Get('log-out')
  @UseGuards(JwtRefreshGuard)
  @HttpCode(HttpStatus.OK)
  async logout(@Request() req) {
    return await this.authService.revokeRefreshToken(req.user.token);
  }

  @Post('otp-verification')
  @UseGuards(JwtAuthGuard)
  @HttpCode(HttpStatus.OK)
  async otpVerification(@Request() req, @Body() body: OtpVerifyDto) {
    return await this.authService.verifyOtp(req.user.id, body.otp);
  }

  @Post('change-password')
  @UseGuards(JwtAuthGuard)
  async changePassword(@Body() dto: ChangePasswordDTO, @Req() req: Request) {
    const userId = req['user'].id;
    return await this.authService.changePassword(dto, userId);
  }
}
