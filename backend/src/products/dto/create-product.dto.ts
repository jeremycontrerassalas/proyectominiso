export class CreateProductDto {
  title!: string;

  code!: string;

  tags!: string;

  description?: string;

  imageUrl?: string | null;
}
