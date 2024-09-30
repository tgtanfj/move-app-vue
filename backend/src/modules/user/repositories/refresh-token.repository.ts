import { RefreshToken } from '@/entities/refresh-token.entity';
import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { DeleteResult, Repository } from 'typeorm';

@Injectable()
export class RefreshTokenRepository {
  constructor(
    @InjectRepository(RefreshToken)
    private readonly refreshTokenRepository: Repository<RefreshToken>,
  ) {}

  async saveFreshToken(userId: number, deviceInfo: any, refreshToken: string): Promise<RefreshToken> {
    const refreshTokenSaved = this.refreshTokenRepository.create({
      user: { id: userId },
      refreshToken,
      ipAddress: deviceInfo.ipAddress,
      userAgent: deviceInfo.userAgent,
    });

    return await this.refreshTokenRepository.save(refreshTokenSaved);
  }

  async validateRefreshToken(refreshToken: string): Promise<RefreshToken> {
    return await this.refreshTokenRepository.findOneByOrFail({ refreshToken });
  }

  async revokeRefreshToken(refreshToken: string): Promise<DeleteResult> {
    return await this.refreshTokenRepository.delete({ refreshToken });
  }
}
