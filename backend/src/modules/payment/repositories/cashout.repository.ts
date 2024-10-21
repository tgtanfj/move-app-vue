import { Cashout } from '@/entities/cashout.entity';
import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';

@Injectable()
export class CashOutRepository {
  constructor(
    @InjectRepository(Cashout)
    private readonly cashOutRepository: Repository<Cashout>,
  ) {}

  async createCashOutHistory(channelId: number, numberOfREPs: number): Promise<Cashout> {
    const cashOutCreated = this.cashOutRepository.create({
      channel: {
        id: channelId,
      },
      numberOfREPs,
    });
    return this.cashOutRepository.save(cashOutCreated);
  }
}
