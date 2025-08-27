import { ArgumentsHost, Catch, ExceptionFilter, HttpException, HttpStatus, Logger } from '@nestjs/common';
import { FastifyReply, FastifyRequest } from 'fastify';
import { v4 as uuid } from 'uuid';
import { ApiError, ApiResponse } from '../interceptors/response.interceptor';

interface ValidationError {
  property: string;
  constraints?: Record<string, string>;
}

interface ExceptionResponse {
  message?: string | string[] | ValidationError[];
  error?: string;
  statusCode?: number;
}

@Catch()
export class AllExceptionsFilter implements ExceptionFilter {
  private readonly logger = new Logger(AllExceptionsFilter.name);

  catch(exception: unknown, host: ArgumentsHost): void {
    const ctx = host.switchToHttp();
    const response = ctx.getResponse<FastifyReply>();
    const request = ctx.getRequest<FastifyRequest>();
    const requestId = this.getRequestId(request);

    const { status, message, errors } = this.parseException(exception);

    this.logError(requestId, request, status, message, exception);

    const errorResponse = this.createErrorResponse(requestId, request, status, message, errors);

    this.sendResponse(response, status, requestId, errorResponse);
  }

  private getRequestId(request: FastifyRequest): string {
    return (request.headers['x-request-id'] as string) || uuid();
  }

  private parseException(exception: unknown): { status: number; message: string; errors: ApiError[] } {
    let status = HttpStatus.INTERNAL_SERVER_ERROR;
    let message = 'Internal server error';
    let errors: ApiError[] = [];

    if (exception instanceof HttpException) {
      status = exception.getStatus();
      const exceptionResponse = exception.getResponse();

      if (typeof exceptionResponse === 'string') {
        message = exceptionResponse;
      } else if (typeof exceptionResponse === 'object' && exceptionResponse !== null) {
        const responseObj = exceptionResponse as ExceptionResponse;
        message = this.extractMessage(responseObj, exception.message);

        if (Array.isArray(responseObj.message)) {
          errors = this.parseValidationErrors(responseObj.message);
        }
      }
    } else if (exception instanceof Error) {
      message = exception.message;
      errors = [{ code: 'internal_error', message: exception.message }];
    } else {
      errors = [{ code: 'unknown_error', message: 'An unknown error occurred' }];
    }

    return { status, message, errors };
  }

  private extractMessage(responseObj: ExceptionResponse, fallbackMessage: string): string {
    if (typeof responseObj.message === 'string') {
      return responseObj.message;
    }
    if (responseObj.error) {
      return responseObj.error;
    }
    return fallbackMessage;
  }

  private parseValidationErrors(errors: (string | ValidationError)[]): ApiError[] {
    return errors.map((error) => {
      if (typeof error === 'string') {
        return { code: 'validation_error', message: error };
      }

      if (typeof error === 'object' && error !== null && 'property' in error) {
        const validationError = error as ValidationError;
        return {
          code: 'validation_error',
          field: validationError.property,
          message: validationError.constraints
            ? Object.values(validationError.constraints).join(', ')
            : 'Validation failed',
        };
      }

      return { code: 'validation_error', message: 'Validation failed' };
    });
  }

  private logError(
    requestId: string,
    request: FastifyRequest,
    status: number,
    message: string,
    exception: unknown,
  ): void {
    const logContext = {
      requestId,
      method: request.method,
      url: request.url,
      status,
      userAgent: request.headers['user-agent'],
      ip: request.ip,
    };

    this.logger.error(
      `[${requestId}] ${request.method} ${request.url} - ${status}: ${message}`,
      exception instanceof Error ? exception.stack : undefined,
      logContext,
    );
  }

  private createErrorResponse(
    requestId: string,
    request: FastifyRequest,
    status: number,
    message: string,
    errors: ApiError[],
  ): ApiResponse<null> {
    return {
      data: null,
      errors: errors.length > 0 ? errors : [{ code: this.getErrorCode(status), message }],
      meta: {
        request_id: requestId,
        timestamp: new Date().toISOString(),
        path: request.url,
        method: request.method,
      },
    };
  }

  private sendResponse(
    response: FastifyReply,
    status: number,
    requestId: string,
    errorResponse: ApiResponse<null>,
  ): void {
    response.status(status);
    response.header('X-Request-Id', requestId);
    response.send(errorResponse);
  }

  private getErrorCode(status: number): string {
    switch (status) {
      case HttpStatus.BAD_REQUEST:
        return 'bad_request';
      case HttpStatus.UNAUTHORIZED:
        return 'unauthorized';
      case HttpStatus.FORBIDDEN:
        return 'forbidden';
      case HttpStatus.NOT_FOUND:
        return 'not_found';
      case HttpStatus.METHOD_NOT_ALLOWED:
        return 'method_not_allowed';
      case HttpStatus.CONFLICT:
        return 'conflict';
      case HttpStatus.UNPROCESSABLE_ENTITY:
        return 'validation_error';
      case HttpStatus.TOO_MANY_REQUESTS:
        return 'rate_limit_exceeded';
      case HttpStatus.INTERNAL_SERVER_ERROR:
        return 'internal_server_error';
      case HttpStatus.SERVICE_UNAVAILABLE:
        return 'service_unavailable';
      default:
        return 'unknown_error';
    }
  }
}
