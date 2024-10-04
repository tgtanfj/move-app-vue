import { Module } from '@nestjs/common';
import { RedisProvider } from './redis.provider';
import { RedisService } from './redis.service';

@Module({
  providers: [RedisProvider, RedisService],
  exports: [RedisProvider, RedisService], // Export the Redis provider to make it available in other modules
})
export class RedisModule {}
