import { TransactionStatus } from '@/entities/enums/transaction-status.enum';
import { ApiProperty } from '@nestjs/swagger';
import { IsOptional } from 'class-validator';
import QueryPaymentHistoryDto from './query-payment-history.dto';

export default class QueryAdminPaymentHistoryDto extends QueryPaymentHistoryDto {
  @IsOptional()
  @ApiProperty({ name: 'status', enum: TransactionStatus, required: false })
  status?: TransactionStatus;

  @IsOptional()
  @ApiProperty({ name: 'search', example: '', required: false })
  search?: string;
}
