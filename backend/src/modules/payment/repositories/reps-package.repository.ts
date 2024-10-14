import { RepsPackage } from '@/entities/reps-package.entity';
import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';

@Injectable()
export class RepsPackageRepository {
  constructor(
    @InjectRepository(RepsPackage)
    private readonly repsPackageRepository: Repository<RepsPackage>,
  ) {}

  async listRepsPackage() {
    return this.repsPackageRepository.find();
  }

  async findOneRepPackage(repPackageId: number): Promise<RepsPackage> {
    return this.repsPackageRepository.findOneByOrFail({
      id: repPackageId,
    });
  }
}
