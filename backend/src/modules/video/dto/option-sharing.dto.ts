import { OPTION } from '@/shared/constraints/sharing.constraint';
import { ApiProperty } from '@nestjs/swagger';
import { IsEnum } from 'class-validator';

export class OptionSharingDTO {
  @ApiProperty({
    description: 'Option Facebook or Twitter',
    example: 'Facebook',
  })
  @IsEnum(OPTION)
  option: OPTION;
}
