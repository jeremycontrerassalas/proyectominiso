import { Controller, Get, Post, Body, HttpCode, HttpStatus, Logger, HttpException } from '@nestjs/common';
import { ProductsService } from './products.service';
import { CreateProductDto } from './dto/create-product.dto';
import { Product } from './product.entity';

@Controller('products')
export class ProductsController {
  constructor(private readonly service: ProductsService) {}

  @Get()
  async list(): Promise<Product[]> {
    return this.service.findAll();
  }

  @Get('debug/db')
  async debugDb(): Promise<unknown> {
    return this.service.debugDb();
  }

  @Post()
  @HttpCode(HttpStatus.CREATED)
  async create(@Body() dto: CreateProductDto): Promise<Product> {
    try {
      return await this.service.create(dto);
    } catch (e) {
      Logger.error('Error creating product', e instanceof Error ? e.stack : String(e));
      throw new HttpException('Internal server error (see logs)', HttpStatus.INTERNAL_SERVER_ERROR);
    }
  }
}
