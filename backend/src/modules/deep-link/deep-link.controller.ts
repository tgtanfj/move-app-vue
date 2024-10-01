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
    @Res() res,
  ) {
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
  }
}
