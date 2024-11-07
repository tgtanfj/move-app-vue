import { TransactionStatus } from '@/entities/enums/transaction-status.enum';
import QueryPaymentHistoryDto from '@/modules/payment/dto/query-payment-history.dto';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsOptional } from 'class-validator';

export enum SortDirection {
  ASC = 'asc',
  DESC = 'desc',
}

export enum SortField {
  CREATED_AT = 'createdAt',
  NUMBER_OF_REPS = 'numberOfREPs',
  PRICE = 'price',
}

export default class QueryAdminPaymentHistoryDto extends QueryPaymentHistoryDto {
  @IsOptional()
  @ApiProperty({ name: 'status', enum: TransactionStatus, required: false })
  status?: TransactionStatus;

  @IsOptional()
  @ApiProperty({ name: 'search', example: '', required: false })
  search?: string;

  @IsOptional()
  @ApiPropertyOptional({ name: 'sortField', enum: SortField, required: false })
  sortField?: SortField;

  @IsOptional()
  @ApiPropertyOptional({ name: 'sortDirection', enum: SortDirection, required: false })
  sortDirection?: SortDirection;
}
