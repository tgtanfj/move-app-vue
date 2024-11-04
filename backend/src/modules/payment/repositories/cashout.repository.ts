import { Cashout } from '@/entities/cashout.entity';
import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { DeepPartial, Repository, UpdateResult } from 'typeorm';

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
    return await this.cashOutRepository.save(cashOutCreated);
  }

  async updateCashoutHistory(id: number, updateData: DeepPartial<Cashout>): Promise<UpdateResult> {
    return await this.cashOutRepository.update(id, updateData);
  }
}
