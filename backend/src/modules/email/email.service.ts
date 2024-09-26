/* eslint-disable prettier/prettier */
import { MailerService } from '@nestjs-modules/mailer';
import { Injectable } from '@nestjs/common';
import * as Mail from 'nodemailer/lib/mailer';

@Injectable()
export class EmailService {
  constructor(private readonly mailerService: MailerService) {}

  async sendMail(options: Mail.Options) {
    return await this.mailerService.sendMail(options);
  }
}
