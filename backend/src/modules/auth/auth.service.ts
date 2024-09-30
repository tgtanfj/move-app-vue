import { ERRORS_DICTIONARY } from '@/shared/constraints/error-dictionary.constraint';
import { firebaseAdmin } from '@/shared/firebase/firebase.config';
import { infoLoginSocial } from '@/shared/interfaces/login-social.interface';
import { MailDTO } from '@/shared/interfaces/mail.dto';
import { ApiConfigService } from '@/shared/services/api-config.service';
import { getField } from '@/shared/utils/get-field.util';
import { CACHE_MANAGER } from '@nestjs/cache-manager';
import {
  BadRequestException,
  ForbiddenException,
  Inject,
  Injectable,
  NotAcceptableException,
} from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import * as bcrypt from 'bcrypt';
import { Cache } from 'cache-manager';
import { authenticator } from 'otplib';
import { EmailService } from '../email/email.service';
import { getTemplateReset } from '../email/templates/get-template';
import { StripeService } from '../stripe/stripe.service';
import { UserService } from '../user/user.service';
import { SignUpEmailDto } from './dto/signup-email.dto';

@Injectable()
export class AuthService {
  constructor(
    private readonly emailService: EmailService,
    private readonly stripeService: StripeService,
    private readonly apiConfigService: ApiConfigService,
    private readonly userService: UserService,
    private readonly jwtService: JwtService,
    private readonly configService: ApiConfigService,
    @Inject(CACHE_MANAGER) private cacheManager: Cache,
  ) {}

  private readonly MAX_ATTEMPTS = 3;
  private readonly OTP_EXPIRATION_TIME = 60; // seconds
  private readonly LOCKOUT_TIME = 600; //

  async signUpEmail(signUpEmailDto: SignUpEmailDto) {
    const existUser = await this.userService.findOneByEmail(signUpEmailDto.email);

    if (existUser) {
      throw new BadRequestException(ERRORS_DICTIONARY.EMAIL_EXISTED);
    }

    // hashed password

    const passwordHashed = await bcrypt.hash(signUpEmailDto.password, 10);

    // create stripe customer

    const customer = await this.stripeService.createCustomer(signUpEmailDto.email);

    signUpEmailDto.stripeId = customer.id;

    // create user if not exist

    const user = await this.userService.createUserByEmail(signUpEmailDto);

    await this.userService.createAccount(user.id, passwordHashed);

    // send mail verify

    await this.sendOTPVerification(user);

    return user;
  }

  async forgotPassword(email: string) {
    //check mail exist
    const foundUser = await this.userService.getOneUserByEmailOrThrow(email);
    //generate token by userId
    const token = this.generateResetPasswordToken(foundUser.id);
    //generate link reset password
    const link = `${this.apiConfigService.getString('MY_SERVER')}/deep-link?path=/reset-password&token=${token}`;
    //send mail with template
    const dto: MailDTO = {
      subject: 'Password reset',
      to: email,
      html: getTemplateReset(link),
      from: this.apiConfigService.getString('MAIL_USER'),
    };
    this.emailService.sendMail(dto);
    return {
      email,
      token,
    };
  }

  generateResetPasswordToken(userId: number) {
    const payload = {
      userId,
    };
    try {
      return this.jwtService.sign(payload, {
        secret: this.apiConfigService.getString('RESET_PASSWORD_KEY'),
        expiresIn: this.apiConfigService.getString('RESET_PASSWORD_TOKEN_EXPIRATION_TIME'),
      });
    } catch (error) {
      throw new Error(ERRORS_DICTIONARY.GENERATE_TOKEN_FAIL);
    }
  }

  async resetPassword(token: string, newPassword: string) {
    try {
      //decode token
      const payload = this.jwtService.verify(token, {
        secret: this.apiConfigService.getString('RESET_PASSWORD_KEY'),
      });
      //find user by id
      const user = await this.userService.findOne(payload.userId);

      const hash = await bcrypt.hash(newPassword, 10);
      const update = await this.userService.updatePassword(hash, payload.userId);
      if (!update) {
        throw new BadRequestException({
          message: ERRORS_DICTIONARY.UPDATE_PASSWORD_FAIL,
        });
      }
      return getField(user, ['email', 'password']);
    } catch (error) {
      throw new ForbiddenException({
        message: ERRORS_DICTIONARY.AUTHORIZE_ERROR,
      });
    }
  }
  async loginSocial(infoLoginSocial: infoLoginSocial) {
    const { idToken, type, publicIp, userAgent } = infoLoginSocial;
    const { email, name, picture } = await firebaseAdmin.auth().verifyIdToken(idToken);
    const user = await this.userService.findUserAccountWithEmail(email);
    const account = user.account;
    if (account && account.type !== type) {
      throw new BadRequestException(ERRORS_DICTIONARY.TRY_ANOTHER_LOGIN_METHOD);
    }
    if (!account) {
      const customer = await this.stripeService.createCustomer(email);
      const newUser = await this.userService.createUserBySocial({
        email,
        fullName: name,
        avatar: picture,
        stripeId: customer.id,
      });
      await this.userService.createAccountSocial(newUser.id, type);
      return newUser;
    }
    return await this.login(user.id, publicIp, userAgent);
  }

  async login(userId: number, ip: string, userAgent: string) {
    const { refreshToken, id } = await this.getRefreshToken(userId, {
      ipAddress: ip,
      userAgent: userAgent,
    });

    const accessToken = this.getAccessToken(userId, id);

    return {
      accessToken: accessToken,
      refreshToken: refreshToken,
    };
  }

  async validateUser(email: string, password: string) {
    // find user by email
    const user = await this.userService.findOneByEmail(email);

    if (!user) {
      return null;
    }

    // check password
    const account = await this.userService.findOneAccount(user.id);

    const isPasswordValid = await bcrypt.compare(password, account.password);

    if (!isPasswordValid) {
      return null;
    }

    return user;
  }

  getAccessToken(userId: number, deviceId: any) {
    const payload = { sub: userId, deviceId };

    return this.jwtService.sign(payload);
  }

  async getRefreshToken(userId: number, deviceInfo: any) {
    const payload = { sub: userId };

    const refreshToken = this.jwtService.sign(payload, {
      secret: this.configService.getString('JWT_REFRESH_SECRET'),
      expiresIn: this.configService.getString('JWT_REFRESH_EXPIRES_IN'),
    });

    const { id } = await this.userService.saveRefreshToken(userId, deviceInfo, refreshToken);

    return {
      refreshToken,
      id,
    };
  }

  async refresh(payload: any) {
    const deviceId = await this.userService.validateRefreshToken(payload.refreshToken);

    const accessToken = this.getAccessToken(payload.userId, deviceId);

    return {
      accessToken,
    };
  }

  async revokeRefreshToken(token: string) {
    return await this.userService.revokeRefreshToken(token);
  }

  async sendOTPVerification(user) {
    const otp = await this.generateOtp(user.id);
    return this.emailService.sendOTPVerification(user.email, otp);
  }

  async generateOtp(userId) {
    const otp = authenticator.generate(userId);

    // Store OTP with a 5-minute expiration
    await this.cacheManager.set(`otp_${userId}`, otp, 60); // Cache OTP for 1 minute
    await this.cacheManager.set(`attempts_${userId}`, 0, 60); // Initialize attempts

    return otp;
  }

  async verifyOtp(userId: number, otp: string) {
    const cachedOtp = await this.cacheManager.get<string>(`otp_${userId}`);
    const attempts = await this.cacheManager.get<number>(`attempts_${userId}`);
    const isLocked = await this.cacheManager.get<number>(`account_locked_${userId}`);

    if (isLocked) {
      throw new NotAcceptableException(ERRORS_DICTIONARY.ACCOUNT_LOCKED);
    }

    if (!cachedOtp) {
    }

    if (cachedOtp === otp) {
      // Clear attempts if successful
      await this.cacheManager.del(`attempts_${userId}`);
      await this.cacheManager.del(`otp_${userId}`);

      await this.userService.updateUser(userId, { isActive: true }); // OTP is valid
      return true;
    } else {
      await this.cacheManager.set(`attempts_${userId}`, attempts + 1, 60);

      if (attempts + 1 >= this.MAX_ATTEMPTS) {
        await this.cacheManager.set(`account_locked_${userId}`, true, this.LOCKOUT_TIME);
        throw new BadRequestException(ERRORS_DICTIONARY.OTP_WRONG_MANY_TIMES);
      }

      throw new BadRequestException(ERRORS_DICTIONARY.INVALID_OTP);
    }
  }
}
