export function objectResponse(data: any, meta: any, message: string = null) {
  return {
    data,
    meta,
    message,
  };
}
