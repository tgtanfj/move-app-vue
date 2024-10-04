export const base64ToBlob = (base64, type = 'image/jpeg') => {
  const byteCharacters = atob(base64.split(',')[1]) 
  const byteNumbers = new Uint8Array(byteCharacters.length)
  for (let i = 0; i < byteCharacters.length; i++) {
    byteNumbers[i] = byteCharacters.charCodeAt(i)
  }
  return new Blob([byteNumbers], { type: type })
}
