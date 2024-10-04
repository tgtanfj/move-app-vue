import { ConfigModule, ConfigService } from '@nestjs/config';
import { createClient } from 'redis';

export const REDIS_CLIENT = 'REDIS_CLIENT';

export const RedisProvider = {
  provide: REDIS_CLIENT,
  imports: [ConfigModule],
  inject: [ConfigService],
  useFactory: async (configService: ConfigService) => {
    const client = createClient({
      url: `redis://${configService.get('REDIS_HOST')}:${configService.get('REDIS_PORT')}`, // Replace with your Redis URL if necessary
      password: configService.get('REDIS_PASSWORD'), // Use environment variables if needed
    });

    // Connect to the Redis server
    await client.connect();

    client.on('error', (err) => console.error('Redis Client Error', err));

    return client;
  },
};
