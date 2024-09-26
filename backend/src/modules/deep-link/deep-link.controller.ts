import { Controller, Get, Query, Res } from '@nestjs/common';
import { ApiConfigService } from '../../shared/services/api-config.service';
import { ApiTags } from '@nestjs/swagger';

@ApiTags('Auth')
@Controller('deep-link')
export class DeepLinkController {
  constructor(private apiConfig: ApiConfigService) {}
  @Get()
  async deepLink(
    @Query('path')
    path: string,
    @Query('token') token: string,
    @Res() res,
  ) {
    //link mobile app
    const schemaLink = `${this.apiConfig.getString('MY_APP')}:/${path}?token=${token}`;
    //link-app in CH play
    const dataStoreAndroid = 'http://localhost:4000/';
    //link-app in App store
    const dataStoreIOS = 'http://localhost:4000/';
    //web app
    const schemaUrl = `${this.apiConfig.getString('FRONT_END_URL')}${path}?token=${token}`;
    const redirectUrl = schemaUrl;
    return res.render('deepLinkHandle', {
      schemaLink,
      dataStoreAndroid,
      dataStoreIOS,
      schemaUrl,
      redirectUrl,
    });
  }
}
