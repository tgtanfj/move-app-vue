/* eslint-disable prettier/prettier */
import { MailerService } from '@nestjs-modules/mailer';
import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import * as Mail from 'nodemailer/lib/mailer';

@Injectable()
export class EmailService {
  constructor(
    private readonly mailerService: MailerService,
    private readonly configService: ConfigService,
  ) {}

  async sendMail(options: Mail.Options) {
    return await this.mailerService.sendMail(options);
  }

  async sendOTPVerification(email: string, otp: string) {
    const mailOption: Mail.Options = {
      to: email,
      subject: 'OTP Verification',
      template: './otp-verification.ejs',
      context: {
        otp: otp,
      },
    };

    return await this.sendMail(mailOption).catch((error) => {
      console.error(error);
    });
  }
}
