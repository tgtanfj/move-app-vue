import { Inject, Injectable, OnModuleDestroy } from '@nestjs/common';
import { RedisClientType } from 'redis';
import { REDIS_CLIENT } from './redis.provider';

@Injectable()
export class RedisService implements OnModuleDestroy {
  constructor(
    @Inject(REDIS_CLIENT)
    private readonly redisClient: RedisClientType, // Type of Redis client
  ) {}

  /**
   * Set a value of any type in Redis.
   * @param key - The key under which to store the value.
   * @param value - The value to store (can be any type).
   * @param ttl - Optional TTL (Time-To-Live) in seconds.
   */
  async setValue<T>(key: string, value: T, ttl: number = 3600): Promise<void> {
    // Convert value to a JSON string to handle different data types
    const serializedValue = JSON.stringify(value);
    await this.redisClient.setEx(key, ttl, serializedValue); // Store with TTL
  }

  /**
   * Get a value of any type from Redis.
   * @param key - The key under which the value is stored.
   * @returns The value stored in Redis, parsed back to its original type.
   */
  async getValue<T>(key: string): Promise<T | null> {
    const value = await this.redisClient.get(key);
    return value ? JSON.parse(value) : null; // Parse value back to its original type
  }

  /**
   * Delete a value from Redis.
   * @param key - The key to delete.
   * @returns The number of keys that were removed.
   */
  async deleteValue(key: string): Promise<number> {
    return await this.redisClient.del(key);
  }

  /**
   * Cleanup the Redis client connection when the module is destroyed.
   */
  async onModuleDestroy() {
    await this.redisClient.quit();
  }
}
