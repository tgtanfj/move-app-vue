import { MONTHS } from '@constants/date.constant'

export const captureThumbnail = (video, time) => {
  return new Promise((resolve) => {
    const canvas = document.createElement('canvas')
    const context = canvas.getContext('2d')

    video.currentTime = time

    const onSeekedHandler = () => {
      video.removeEventListener('seeked', onSeekedHandler)

      setTimeout(() => {
        canvas.width = video.videoWidth
        canvas.height = video.videoHeight

        context.drawImage(video, 0, 0, canvas.width, canvas.height)

        const imageUrl = canvas.toDataURL('image/jpeg')
        resolve(imageUrl)
      }, 500)
    }

    video.addEventListener('seeked', onSeekedHandler)
  })
}

export const blobToArrayBuffer = (blob) => {
  return new Promise((resolve, reject) => {
    const reader = new FileReader()
    reader.onload = () => resolve(reader.result)
    reader.onerror = (error) => reject(error)
    reader.readAsArrayBuffer(blob)
  })
}

export const compareBlobs = async (blob1, blob2) => {
  const buffer1 = await blobToArrayBuffer(blob1)
  const buffer2 = await blobToArrayBuffer(blob2)

  if (buffer1.byteLength !== buffer2.byteLength) {
    return false
  }

  const view1 = new Uint8Array(buffer1)
  const view2 = new Uint8Array(buffer2)

  for (let i = 0; i < view1.length; i++) {
    if (view1[i] !== view2[i]) {
      return false
    }
  }

  return true
}

export const formatDateString = (dateString) => {
  const [year, month, day] = dateString.split('-')

  const monthName = MONTHS.find((m) => m.num === month).text

  return `${day} ${monthName} ${year}`
}

export const detectDuration = (duration) => {
  switch (duration) {
    case 'less than 30 minutes':
      return '< 30 mins'
    case 'less than 1 hours':
      return '< 1 hour'
    case 'more than 1 hours':
      return '> 1 hour'
    default:
      return 'Unknown'
  }
}

export const detectWorkoutLevel = (item) => {
  switch (item) {
    case 'beginner':
      return 'Beginner'
    case 'intermediate':
      return 'Intermediate'
    case 'advanced':
      return 'Advanced'
    default:
      return 'Unknown'
  }
}
