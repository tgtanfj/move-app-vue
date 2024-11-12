import { BadRequestException, Controller, ForbiddenException, Get, Query, Res } from '@nestjs/common';
import { ApiConfigService } from '../../shared/services/api-config.service';
import { ApiTags } from '@nestjs/swagger';
import { JwtService } from '@nestjs/jwt';
import { UserService } from '../user/user.service';
import { I18nService } from 'nestjs-i18n';

@ApiTags('Auth')
@Controller('deep-link')
export class DeepLinkController {
  constructor(
    private apiConfig: ApiConfigService,
    private jwtService: JwtService,
    private userService: UserService,
    private readonly i18n: I18nService,
  ) {}
  @Get()
  async deepLink(
    @Query('path')
    path: string,
    @Res() res,
  ) {
    const token = path.split('/')[1];
    console.log(token);
    //verify token
    try {
      const payload = this.jwtService.verify(token, {
        secret: this.apiConfig.getString('RESET_PASSWORD_KEY'),
      });
      //find user id
      const foundUser = await this.userService.findOne(payload.userId);

      const payloadInDB = this.jwtService.verify(foundUser.token, {
        secret: this.apiConfig.getString('RESET_PASSWORD_KEY'),
      });

      if (
        foundUser.id !== payload.userId ||
        payloadInDB.userId !== payload.userId ||
        foundUser.token === null
      ) {
        res.redirect('training-move-intern.madlab.tech');
      }

      //link mobile app
      const schemaUrl = `${this.apiConfig.getString('MY_APP')}://${path}`;
      //link-app in CH play
      const dataStoreAndroid = 'http://localhost:4000/';
      //link-app in App store
      const dataStoreIOS = 'http://localhost:4000/';
      //web app
      const redirectUrl = `${this.apiConfig.getString('FRONT_END_URL')}/${path}`;
      return res.render('deepLinkHandle', {
        schemaUrl,
        dataStoreAndroid,
        dataStoreIOS,
        redirectUrl,
      });
    } catch (error) {
      throw new ForbiddenException({
        message: this.i18n.t('exceptions.authorization.AUTHORIZE_ERROR'),
      });
    }
  }
}
