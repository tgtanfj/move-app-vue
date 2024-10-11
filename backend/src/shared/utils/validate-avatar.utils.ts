import { BadRequestException } from '@nestjs/common';
import * as sharp from 'sharp';
import { IFile } from '../interfaces/file.interface';
import { ERRORS_DICTIONARY } from '../constraints/error-dictionary.constraint';

const ALLOWED_FILE_TYPES = ['image/jpeg', 'image/png', 'image/gif'];
const MAX_FILE_SIZE = 5 * 1024 * 1024; // 5MB
// const MIN_DIMENSIONS = { width: 100, height: 100 };
// const MAX_DIMENSIONS = { width: 2000, height: 2000 };

export async function validateAvatarFile(file: IFile): Promise<void> {
  if (!ALLOWED_FILE_TYPES.includes(file.mimetype)) {
    throw new BadRequestException(ERRORS_DICTIONARY.ALLOWED_FILE_TYPES);
  }

  if (file.size > MAX_FILE_SIZE) {
    throw new BadRequestException(ERRORS_DICTIONARY.SIZE_AVATAR_ERROR);
  }

  // const imageMetadata = await sharp(file.buffer).metadata();
  // if (
  //   imageMetadata.width < MIN_DIMENSIONS.width ||
  //   imageMetadata.height < MIN_DIMENSIONS.height ||
  //   imageMetadata.width > MAX_DIMENSIONS.width ||
  //   imageMetadata.height > MAX_DIMENSIONS.height
  // ) {
  //   throw new BadRequestException(ERRORS_DICTIONARY.DIMENSIONS_AVATAR_ERROR);
  // }
}
