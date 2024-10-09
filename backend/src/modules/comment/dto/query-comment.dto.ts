import { IsOptional, IsNumber, IsString } from 'class-validator';
import { ApiPropertyOptional } from '@nestjs/swagger';
import { Type } from 'class-transformer';

export class QueryCommentDto {
  @ApiPropertyOptional({ description: 'comments limit to get', default: 10 })
  @IsOptional()
  @IsNumber()
  @Type(() => Number)
  limit?: number;

  @ApiPropertyOptional({ description: 'last comment id' })
  @IsOptional()
  @IsString()
  cursor?: number;
}
