import { AuthService } from '@/modules/auth/auth.service';
import { Injectable, UnauthorizedException } from '@nestjs/common';
import { PassportStrategy } from '@nestjs/passport';
import { I18nService } from 'nestjs-i18n';
import { Strategy } from 'passport-local';

@Injectable()
export class LocalStrategy extends PassportStrategy(Strategy) {
  constructor(
    private authService: AuthService,
    private readonly i18n: I18nService,
  ) {
    super({ usernameField: 'email' });
  }

  async validate(email, password): Promise<any> {
    const user = await this.authService.validateUser(email, password);
    if (!user) {
      throw new UnauthorizedException(this.i18n.t('exceptions.authorization.LOGIN_FAILED'));
    }
    return user;
  }
}
