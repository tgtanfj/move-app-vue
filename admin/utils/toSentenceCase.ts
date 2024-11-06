export function toSentenceCase(str: string) {
  if (!str) return ''; // Handle empty strings
  return str.charAt(0).toUpperCase() + str.slice(1).toLowerCase();
}
