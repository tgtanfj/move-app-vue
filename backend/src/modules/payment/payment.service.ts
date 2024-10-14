import { User } from '@/entities/user.entity';
import { Injectable } from '@nestjs/common';
import { StripeService } from '../stripe/stripe.service';
import { UserService } from '../user/user.service';
import { BuyREPsDto } from './dto/buy-reps.dto';
import { PaymentRepository } from './repositories/payment.repository';
import { RepsPackageRepository } from './repositories/reps-package.repository';

@Injectable()
export class PaymentService {
  constructor(
    private readonly repsPackageRepository: RepsPackageRepository,
    private readonly paymentRepository: PaymentRepository,
    private readonly userService: UserService,
    private readonly stripeService: StripeService,
  ) {}

  async listRepsPackage() {
    try {
      return this.repsPackageRepository.listRepsPackage();
    } catch (error) {
      console.error(error);
    }
  }

  async buyREPs(user: User, buyREPsDto: BuyREPsDto) {
    const { paymentMethodId, repPackageId } = buyREPsDto;

    const repPackage = await this.repsPackageRepository.findOneRepPackage(repPackageId);

    await this.stripeService.charge(repPackage.price, paymentMethodId, user.stripeId);

    const repsOfUser = repPackage.numberOfREPs + Number(user.numberOfREPs);

    await this.userService.updateREPs(user.id, repsOfUser);

    this.paymentRepository.createPaymentHistory(repPackage.price, user.id, repPackage.id);
  }
}
