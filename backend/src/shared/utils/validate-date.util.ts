import { ERRORS_DICTIONARY } from '@/shared/constraints/error-dictionary.constraint';
export function validateDate(startDate?: Date, endDate?: Date) {
  const currentDate = new Date();
  currentDate.setHours(23, 59, 59, 999);

  if (startDate && startDate > currentDate) {
    throw new Error(ERRORS_DICTIONARY.START_DATE_AFTER_CURRENT_DATE);
  }

  // Check if endDate is after the current date
  if (endDate && endDate > currentDate) {
    throw new Error(ERRORS_DICTIONARY.END_DATE_AFTER_CURRENT_DATE);
  }

  if (endDate && startDate && startDate > endDate) {
    throw new Error(ERRORS_DICTIONARY.START_DATE_AFTER_END_DATE);
  }

  return true;
}
