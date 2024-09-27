import { ERRORS_DICTIONARY } from '@/shared/constraints/error-dictionary.constraint';
import { BadRequestException, CanActivate, ExecutionContext, Injectable } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';

@Injectable()
export class JwtRefreshGuard implements CanActivate {
  constructor(private jwtService: JwtService) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const request = context.switchToHttp().getRequest();
    const token = this.extractTokenFromHeader(request);

    if (!token) {
      throw new BadRequestException(ERRORS_DICTIONARY.TOKEN_ERROR);
    }

    try {
      const payload = this.jwtService.verify(token, { secret: process.env.JWT_REFRESH_SECRET });

      request['user'] = { payload, token };

      return true;
    } catch (error) {
      throw new BadRequestException(error.message);
    }
  }

  private extractTokenFromHeader(request: any): string | undefined {
    const [type, token] = request.headers.authorization?.split(' ') ?? [];
    return type === 'Bearer' ? token : undefined;
  }
}
