import { TransactionStatus } from '@/entities/enums/transaction-status.enum';
import { ApiProperty } from '@nestjs/swagger';
import QueryPaymentHistoryDto from './query-payment-history.dto';
import { IsOptional } from 'class-validator';

export default class QueryCashOutHistoryDto extends QueryPaymentHistoryDto {
  @IsOptional()
  @ApiProperty({ name: 'status', enum: TransactionStatus, required: false })
  status?: TransactionStatus;

  @IsOptional()
  @ApiProperty({ name: 'search', example: '', required: false })
  search?: string;
}
