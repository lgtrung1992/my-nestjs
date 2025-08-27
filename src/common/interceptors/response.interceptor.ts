import { CallHandler, ExecutionContext, Injectable, NestInterceptor } from '@nestjs/common';
import { FastifyReply, FastifyRequest } from 'fastify';
import { Observable } from 'rxjs';
import { map } from 'rxjs/operators';
import { v4 as uuid } from 'uuid';

export interface ApiError {
  code: string;
  field?: string;
  message?: string;
}

export interface ApiMeta {
  request_id: string;
  timestamp?: string;
  path?: string;
  method?: string;
}

export interface ApiResponse<T = any> {
  data: T;
  errors: ApiError[];
  meta: ApiMeta;
}

export interface PaginationMeta extends ApiMeta {
  limit: number;
  currentPage: number;
  nextPage?: number;
  previousPage?: number;
  totalRecords: number;
  totalPages: number;
}

export interface CursorPaginationMeta extends ApiMeta {
  totalRows: number;
  page: number;
  perPage: number;
  order: string;
  prevCursor?: number;
  nextCursor?: number;
  canNext: boolean;
  canPrev: boolean;
}

export interface OffsetPaginatedApiResponse<T = any> extends ApiResponse<T> {
  meta: PaginationMeta;
}

export interface CursorPaginatedApiResponse<T = any> extends ApiResponse<T> {
  meta: CursorPaginationMeta;
}

interface PaginatedData<T = any> {
  data: T[];
  pagination: {
    limit?: number;
    currentPage?: number;
    nextPage?: number;
    previousPage?: number;
    totalRecords?: number;
    totalPages?: number;
    total?: number;
    page?: number;
    order?: string;
    prevCursor?: number;
    nextCursor?: number;
    hasNext?: boolean;
    hasPrev?: boolean;
  };
}

const DEFAULT_PAGINATION = {
  limit: 10,
  currentPage: 1,
  totalRecords: 0,
  totalPages: 0,
} as const;

@Injectable()
export class ResponseInterceptor<T> implements NestInterceptor<T, any> {
  intercept(context: ExecutionContext, next: CallHandler): Observable<any> {
    const ctx = context.switchToHttp();
    const response = ctx.getResponse<FastifyReply>();
    const request = ctx.getRequest<FastifyRequest>();
    const requestId = this.getRequestId(request);

    return next.handle().pipe(map((data) => this.formatResponse(data, requestId, request, response)));
  }

  private getRequestId(request: FastifyRequest): string {
    return (request.headers['x-request-id'] as string) || uuid();
  }

  private formatResponse(data: any, requestId: string, request: FastifyRequest, response: FastifyReply): ApiResponse {
    if (this.isApiResponse(data)) {
      return data;
    }

    if (this.isPaginatedResponse(data)) {
      return this.formatPaginatedResponse(data, requestId, request, response);
    }

    return this.formatBasicResponse(data, requestId, request);
  }

  private isApiResponse(data: any): data is ApiResponse {
    return data && typeof data === 'object' && 'data' in data && 'errors' in data && 'meta' in data;
  }

  private isPaginatedResponse(data: any): data is PaginatedData {
    return data && typeof data === 'object' && 'data' in data && 'pagination' in data;
  }

  private formatBasicResponse(data: any, requestId: string, request: FastifyRequest): ApiResponse {
    return {
      data: data ?? null,
      errors: [],
      meta: {
        request_id: requestId,
        timestamp: new Date().toISOString(),
        path: request.url,
        method: request.method,
      },
    };
  }

  private formatPaginatedResponse(
    data: PaginatedData,
    requestId: string,
    request: FastifyRequest,
    response: FastifyReply,
  ): OffsetPaginatedApiResponse | CursorPaginatedApiResponse {
    const pagination = data.pagination;

    if (this.isOffsetPagination(pagination)) {
      return this.formatOffsetPagination(data, pagination, requestId, request, response);
    }

    return this.formatCursorPagination(data, pagination, requestId, request, response);
  }

  private isOffsetPagination(pagination: any): boolean {
    return 'currentPage' in pagination || 'totalPages' in pagination;
  }

  private formatOffsetPagination(
    data: PaginatedData,
    pagination: any,
    requestId: string,
    request: FastifyRequest,
    response: FastifyReply,
  ): OffsetPaginatedApiResponse {
    const formattedResponse: OffsetPaginatedApiResponse = {
      data: data.data,
      errors: [],
      meta: {
        request_id: requestId,
        timestamp: new Date().toISOString(),
        path: request.url,
        method: request.method,
        limit: pagination.limit ?? DEFAULT_PAGINATION.limit,
        currentPage: pagination.currentPage ?? DEFAULT_PAGINATION.currentPage,
        nextPage: pagination.nextPage,
        previousPage: pagination.previousPage,
        totalRecords: pagination.totalRecords ?? DEFAULT_PAGINATION.totalRecords,
        totalPages: pagination.totalPages ?? DEFAULT_PAGINATION.totalPages,
      },
    };

    if (!response.statusCode) {
      response.status(200);
    }

    return formattedResponse;
  }

  private formatCursorPagination(
    data: PaginatedData,
    pagination: any,
    requestId: string,
    request: FastifyRequest,
    response: FastifyReply,
  ): CursorPaginatedApiResponse {
    const formattedResponse: CursorPaginatedApiResponse = {
      data: data.data,
      errors: [],
      meta: {
        request_id: requestId,
        timestamp: new Date().toISOString(),
        path: request.url,
        method: request.method,
        totalRows: pagination.total ?? 0,
        page: pagination.page ?? 1,
        perPage: pagination.limit ?? 10,
        order: pagination.order ?? 'id',
        prevCursor: pagination.prevCursor,
        nextCursor: pagination.nextCursor,
        canNext: pagination.hasNext ?? false,
        canPrev: pagination.hasPrev ?? false,
      },
    };

    if (!response.statusCode) {
      response.status(200);
    }

    return formattedResponse;
  }
}

export function createErrorResponse(
  errors: ApiError[],
  requestId: string,
  path: string,
  method: string,
): ApiResponse<null> {
  return {
    data: null,
    errors,
    meta: {
      request_id: requestId,
      timestamp: new Date().toISOString(),
      path,
      method,
    },
  };
}

export function createSuccessResponse<T>(
  data: T,
  requestId: string,
  path: string,
  method: string,
  meta?: Partial<ApiMeta>,
): ApiResponse<T> {
  return {
    data,
    errors: [],
    meta: {
      request_id: requestId,
      timestamp: new Date().toISOString(),
      path,
      method,
      ...meta,
    },
  };
}
