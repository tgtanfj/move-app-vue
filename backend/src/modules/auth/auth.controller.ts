import { TypeAccount } from '@/entities/enums/typeAccount.enum';
import { JwtAuthGuard } from '@/shared/guards';
import { JwtRefreshGuard } from '@/shared/guards/jwt-refresh.guard';
import { LocalAuthGuard } from '@/shared/guards/local-auth.guard';
import { infoLoginSocial } from '@/shared/interfaces/login-social.interface';
import { PublicIpAddressService } from '@/shared/utils/publicIpAddressService';
import {
  Body,
  Controller,
  Get,
  HttpCode,
  HttpStatus,
  Ip,
  Post,
  Req,
  Request,
  UseGuards,
} from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { AuthService } from './auth.service';
import { ChangePasswordDTO } from './dto/change-password.dto';
import { ForgotPasswordDTO } from './dto/forgot-password.dto';
import { LoginSocialDto } from './dto/login-social.dto';
import { LoginDto } from './dto/login.dto';
import { ResendOtpDto } from './dto/resend-otp.dto';
import { ResetPasswordDTO } from './dto/reset-password.dto';
import { SignUpEmailDto } from './dto/signup-email.dto';
import { NotificationService } from '../notification/notification.service';
import { NOTIFICATION_TYPE } from '@/shared/constraints/notification-message.constraint';

@ApiTags('Auth')
@ApiBearerAuth('jwt')
@Controller('auth')
export class AuthController {
  constructor(
    private readonly authService: AuthService,
    private readonly publicIpAddressService: PublicIpAddressService,
    private readonly notificationService: NotificationService,
  ) {}

  @Post('login/google')
  async loginGoogle(@Body() loginSocialDto: LoginSocialDto, @Req() req: Request) {
    const publicIp = await this.publicIpAddressService.getPublicIpAddress();

    const infoLoginSocial: infoLoginSocial = {
      email: loginSocialDto.email,
      idToken: loginSocialDto.idToken,
      type: TypeAccount.GOOGLE,
      publicIp: publicIp,
      userAgent: req.headers['user-agent'],
    };

    return await this.authService.loginSocial(infoLoginSocial);
  }

  @Post('login/facebook')
  async loginFacebook(@Body() loginSocialDto: LoginSocialDto, @Req() req: Request) {
    const publicIp = await this.publicIpAddressService.getPublicIpAddress();

    const infoLoginSocial: infoLoginSocial = {
      email: loginSocialDto.email,
      idToken: loginSocialDto.idToken,
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
  async login(@Request() req, @Body() loginDto: LoginDto, @Ip() ip) {
    const userAgent = req.headers['user-agent'];

    const userId = req.user.id;

    const checkPasswordExpired = await this.authService.checkPasswordExpired(userId);

    if (checkPasswordExpired) {
      const dataNotification = {
        sender: 'system',
        type: NOTIFICATION_TYPE.PASSWORD_CHANGE_REMINDER,
      };
      await this.notificationService.sendOneToOneNotification(userId, dataNotification);
    }

    return await this.authService.login(userId, ip, userAgent);
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

  @Post('send-otp')
  @HttpCode(HttpStatus.OK)
  async resendOtp(@Body() body: ResendOtpDto) {
    return await this.authService.sendOTPVerification(body.email);
  }

  @Post('signup/email')
  @HttpCode(HttpStatus.CREATED)
  async signUpByEmail(@Body() signUpEmailDto: SignUpEmailDto) {
    return await this.authService.verifyOtp(signUpEmailDto);
  }

  @Post('change-password')
  @UseGuards(JwtAuthGuard)
  async changePassword(@Body() dto: ChangePasswordDTO, @Req() req: Request) {
    const userId = req['user'].id;
    return await this.authService.changePassword(dto, userId);
  }
}
