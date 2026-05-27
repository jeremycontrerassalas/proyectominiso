import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn } from 'typeorm';

@Entity({ name: 'products' })
export class Product {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  @Column({ type: 'text' })
  title!: string;

  @Column({ type: 'text', name: 'product_code', nullable: true })
  code!: string;

  @Column({ type: 'text', nullable: true })
  tags!: string;

  @Column({ type: 'text', nullable: true })
  description?: string;

  @Column({ type: 'longtext', name: 'image_url', nullable: true })
  imageUrl?: string;

  @CreateDateColumn({ name: 'created_at' })
  createdAt!: Date;
}
