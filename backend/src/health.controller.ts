import { Controller, Get } from '@nestjs/common';

@Controller()
export class HealthController {
  @Get()
  root(): { status: string; message: string } {
    return { status: 'ok', message: 'Retail Products backend is running' };
  }

  @Get('health')
  health(): { status: string } {
    return { status: 'ok' };
  }
}