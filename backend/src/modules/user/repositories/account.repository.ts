import { Account } from '@/entities/account.entity';
import { TypeAccount } from '@/entities/enums/typeAccount.enum';
import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, UpdateResult } from 'typeorm';

@Injectable()
export class AccountRepository {
  constructor(
    @InjectRepository(Account)
    private readonly accountRepository: Repository<Account>,
  ) {}

  async createAccount(userId: number, password: string): Promise<Account> {
    const accountCreated = this.accountRepository.create({
      user: {
        id: userId,
      },
      password,
    });
    return await this.accountRepository.save(accountCreated);
  }

  async createAccountSocial(userId: number, type: TypeAccount): Promise<Account> {
    const accountCreated = this.accountRepository.create({
      user: {
        id: userId,
      },
      type,
    });
    return await this.accountRepository.save(accountCreated);
  }

  async findOneAccount(userId: number): Promise<Account> {
    return await this.accountRepository.findOne({
      where: {
        user: {
          id: userId,
        },
      },
    });
  }

  async saveAccount(account: Partial<Account>): Promise<Account> {
    return await this.accountRepository.save(account);
  }

  async updateAccount(accountId: number, account: Partial<Account>): Promise<UpdateResult> {
    return await this.accountRepository.update(accountId, account);
  }
}
