import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class ApiErrorDto {
  @ApiProperty({
    description: 'Error code',
    example: 'validation_error',
  })
  code: string;

  @ApiPropertyOptional({
    description: 'Field name that has error',
    example: 'email',
  })
  field?: string;

  @ApiPropertyOptional({
    description: 'Error message',
    example: 'Email is invalid',
  })
  message?: string;
}

export class ApiMetaDto {
  @ApiProperty({
    description: 'Unique request ID',
    example: '550e8400-e29b-41d4-a716-446655440000',
  })
  request_id: string;

  @ApiPropertyOptional({
    description: 'Timestamp when response was generated',
    example: '2024-01-15T09:04:10.123Z',
  })
  timestamp?: string;

  @ApiPropertyOptional({
    description: 'API endpoint path',
    example: '/api/users',
  })
  path?: string;

  @ApiPropertyOptional({
    description: 'HTTP method',
    example: 'GET',
  })
  method?: string;
}

export class ApiResponseDto<T = any> {
  @ApiProperty({
    description: 'Response data',
  })
  data: T;

  @ApiProperty({
    description: 'List of errors',
    type: [ApiErrorDto],
    example: [],
  })
  errors: ApiErrorDto[];

  @ApiProperty({
    description: 'Response metadata',
    type: ApiMetaDto,
  })
  meta: ApiMetaDto;
}

export class OffsetPaginationMetaDto extends ApiMetaDto {
  @ApiProperty({
    description: 'Number of items per page',
    example: 10,
    default: 10,
  })
  limit: number;

  @ApiProperty({
    description: 'Current page number',
    example: 1,
    default: 1,
  })
  currentPage: number;

  @ApiPropertyOptional({
    description: 'Next page number',
    example: 2,
  })
  nextPage?: number;

  @ApiPropertyOptional({
    description: 'Previous page number',
  })
  previousPage?: number;

  @ApiProperty({
    description: 'Total number of records',
    example: 100,
    default: 0,
  })
  totalRecords: number;

  @ApiProperty({
    description: 'Total number of pages',
    example: 10,
    default: 0,
  })
  totalPages: number;
}

export class OffsetPaginatedApiResponseDto<T = any> extends ApiResponseDto<T> {
  @ApiProperty({
    description: 'Response metadata with offset pagination info',
    type: OffsetPaginationMetaDto,
  })
  declare meta: OffsetPaginationMetaDto;
}

export class CursorPaginationMetaDto extends ApiMetaDto {
  @ApiProperty({
    description: 'Total number of rows',
    example: 100,
    default: 0,
  })
  totalRows: number;

  @ApiProperty({
    description: 'Current page number',
    example: 1,
    default: 1,
  })
  page: number;

  @ApiProperty({
    description: 'Number of items per page',
    example: 10,
    default: 10,
  })
  perPage: number;

  @ApiProperty({
    description: 'Order field',
    example: 'id',
    default: 'id',
  })
  order: string;

  @ApiPropertyOptional({
    description: 'Previous cursor for pagination',
    example: 10,
  })
  prevCursor?: number;

  @ApiPropertyOptional({
    description: 'Next cursor for pagination',
    example: 20,
  })
  nextCursor?: number;

  @ApiProperty({
    description: 'Whether there is next page',
    example: true,
    default: false,
  })
  canNext: boolean;

  @ApiProperty({
    description: 'Whether there is previous page',
    example: false,
    default: false,
  })
  canPrev: boolean;
}

export class CursorPaginatedApiResponseDto<T = any> extends ApiResponseDto<T> {
  @ApiProperty({
    description: 'Response metadata with cursor pagination info',
    type: CursorPaginationMetaDto,
  })
  declare meta: CursorPaginationMetaDto;
}

export class PaginationResultDto<T = any> {
  @ApiProperty({
    description: 'Array of data items',
    isArray: true,
    default: [],
  })
  data: T[];

  @ApiProperty({
    description: 'Pagination information',
    type: 'object',
    properties: {
      limit: { type: 'number', example: 10, default: 10 },
      currentPage: { type: 'number', example: 1, default: 1 },
      nextPage: { type: 'number', example: 2, nullable: true },
      previousPage: { type: 'number', nullable: true },
      totalRecords: { type: 'number', example: 100, default: 0 },
      totalPages: { type: 'number', example: 10, default: 0 },
    },
  })
  pagination: {
    limit: number;
    currentPage: number;
    nextPage?: number;
    previousPage?: number;
    totalRecords: number;
    totalPages: number;
  };
}
