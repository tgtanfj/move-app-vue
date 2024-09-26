import { ERRORS_DICTIONARY } from '@/shared/constraints/error-dictionary.constraint';
import { BadRequestException, Injectable } from '@nestjs/common';
import * as bcrypt from 'bcrypt';
import { EmailService } from '../email/email.service';
import { StripeService } from '../stripe/stripe.service';
import { UserService } from '../user/user.service';
import { SignUpEmailDto } from './dto/signup-email.dto';

@Injectable()
export class AuthService {
  constructor(
    private readonly emailService: EmailService,
    private readonly stripeService: StripeService,
    private readonly userService: UserService,
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
}
