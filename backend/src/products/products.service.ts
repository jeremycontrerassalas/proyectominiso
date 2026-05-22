import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Product } from './product.entity';
import { CreateProductDto } from './dto/create-product.dto';

@Injectable()
export class ProductsService {
  constructor(
    @InjectRepository(Product)
    private readonly repo: Repository<Product>,
  ) {}

  findAll(): Promise<Product[]> {
    return this.repo.find({ order: { createdAt: 'DESC' } });
  }

  create(dto: CreateProductDto): Promise<Product> {
    const product = this.repo.create({
      title: dto.title,
      description: dto.description,
      imageUrl: dto.imageUrl,
    });
    return this.repo.save(product);
  }
}
