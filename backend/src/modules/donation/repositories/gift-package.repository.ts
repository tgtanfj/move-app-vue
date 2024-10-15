import { GiftPackage } from '@/entities/gift-package.entity';
import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';

@Injectable()
export class GiftPackageRepository {
  constructor(
    @InjectRepository(GiftPackage)
    private readonly giftPackageRepository: Repository<GiftPackage>,
  ) {}

  async getGiftPackages(): Promise<GiftPackage[]> {
    return this.giftPackageRepository.find();
  }

  async findOneGiftPackage(giftPackageId: number): Promise<GiftPackage> {
    return this.giftPackageRepository.findOneByOrFail({
      id: giftPackageId,
    });
  }
}
