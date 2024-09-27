import { TypeAccount } from '@/entities/enums/typeAccount.enum';
import { ERRORS_DICTIONARY } from '@/shared/constraints/error-dictionary.constraint';
import { firebaseAdmin } from '@/shared/firebase/firebase.config';
import { MailDTO } from '@/shared/interfaces/mail.dto';
import { ApiConfigService } from '@/shared/services/api-config.service';
import { getField } from '@/shared/utils/get-field.util';
import { BadRequestException, ForbiddenException, Injectable } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import * as bcrypt from 'bcrypt';
import { EmailService } from '../email/email.service';
import { getTemplateReset } from '../email/templates/get-template';
import { StripeService } from '../stripe/stripe.service';
import { UserService } from '../user/user.service';
import { SignUpEmailDto } from './dto/signup-email.dto';
import { infoLoginSocial } from '@/shared/interfaces/login-social.interface';

@Injectable()
export class AuthService {
  constructor(
    private readonly emailService: EmailService,
    private readonly stripeService: StripeService,
    private readonly apiConfigService: ApiConfigService,
    private readonly userService: UserService,
    private readonly jwtService: JwtService,
    private readonly configService: ApiConfigService,
  ) {}

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
}
