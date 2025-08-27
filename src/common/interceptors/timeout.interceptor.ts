import { CallHandler, ExecutionContext, Injectable, Logger, NestInterceptor } from '@nestjs/common';
import { FastifyReply, FastifyRequest } from 'fastify';
import { Observable, throwError, TimeoutError } from 'rxjs';
import { catchError, timeout } from 'rxjs/operators';
import { v4 as uuid } from 'uuid';
import { createErrorResponse } from './response.interceptor';

@Injectable()
export class GlobalTimeoutInterceptor implements NestInterceptor {
  private readonly logger = new Logger(GlobalTimeoutInterceptor.name);
  private readonly defaultTimeout = 60000; // 60 seconds

  constructor(private readonly timeoutMs: number = this.defaultTimeout) {
    if (timeoutMs <= 0) {
      throw new Error('Timeout must be a positive number');
    }
  }

  intercept(context: ExecutionContext, next: CallHandler): Observable<any> {
    const ctx = context.switchToHttp();
    const request = ctx.getRequest<FastifyRequest>();
    const response = ctx.getResponse<FastifyReply>();
    const requestId = this.getRequestId(request);

    this.logTimeoutConfig(requestId, request);

    return next.handle().pipe(
      timeout(this.timeoutMs),
      catchError((error) => this.handleError(error, request, response, requestId)),
    );
  }

  private getRequestId(request: FastifyRequest): string {
    return (request.headers['x-request-id'] as string) || uuid();
  }

  private logTimeoutConfig(requestId: string, request: FastifyRequest): void {
    this.logger.debug(`[${requestId}] ${request.method} ${request.url} - Global timeout set to ${this.timeoutMs}ms`, {
      requestId,
      method: request.method,
      url: request.url,
      timeout: this.timeoutMs,
    });
  }

  private handleError(
    error: Error,
    request: FastifyRequest,
    response: FastifyReply,
    requestId: string,
  ): Observable<never> {
    if (error instanceof TimeoutError) {
      this.logTimeoutError(requestId, request);
      this.sendTimeoutResponse(response, request, requestId);
      return new Observable();
    }

    return throwError(() => error);
  }

  private logTimeoutError(requestId: string, request: FastifyRequest): void {
    const logContext = {
      requestId,
      method: request.method,
      url: request.url,
      timeout: this.timeoutMs,
      userAgent: this.getUserAgent(request),
      ip: request.ip,
      timestamp: new Date().toISOString(),
    };

    this.logger.warn(
      `[${requestId}] ${request.method} ${request.url} - Global timeout after ${this.timeoutMs}ms`,
      logContext,
    );
  }

  private getUserAgent(request: FastifyRequest): string {
    const userAgent = request.headers['user-agent'];
    return Array.isArray(userAgent) ? userAgent[0] : userAgent || '';
  }

  private sendTimeoutResponse(response: FastifyReply, request: FastifyRequest, requestId: string): void {
    const timeoutResponse = createErrorResponse(
      [
        {
          code: 'request_timeout',
          message: `Request timeout - server took too long to respond (${this.timeoutMs}ms)`,
        },
      ],
      requestId,
      request.url,
      request.method,
    );

    response.status(408); // Request Timeout
    response.header('X-Request-Id', requestId);
    response.header('X-Timeout-Ms', this.timeoutMs.toString());
    response.header('Retry-After', Math.ceil(this.timeoutMs / 1000).toString());
    response.send(timeoutResponse);
  }
}
