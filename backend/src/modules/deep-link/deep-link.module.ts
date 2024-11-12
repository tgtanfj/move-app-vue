import { Module } from '@nestjs/common';
import { DeepLinkController } from './deep-link.controller';
import { UserModule } from '../user/user.module';
import { JwtService } from '@nestjs/jwt';

@Module({
  imports: [UserModule],
  providers:[JwtService],
  controllers: [DeepLinkController],
})
export class DeeplinkModule {}
