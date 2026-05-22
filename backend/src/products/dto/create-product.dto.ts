import { IsNotEmpty, IsOptional, IsString, IsUrl, ValidateIf } from 'class-validator';

export class CreateProductDto {
  @IsNotEmpty()
  @IsString()
  title: string;

  @IsOptional()
  @IsString()
  description?: string;

  // Allow null/empty imageUrl (client may omit it). Only validate as URL when provided and non-empty.
  @ValidateIf((o) => o.imageUrl !== null && o.imageUrl !== undefined && o.imageUrl !== '')
  @IsUrl()
  imageUrl?: string | null;
}
