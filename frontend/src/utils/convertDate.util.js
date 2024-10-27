import { DateFormatter, parseDate } from '@internationalized/date'

// Format date as 'Month Day, Year'
export const formatDateLong = (dateString) => {
  const date = new Date(dateString)
  return new Intl.DateTimeFormat('en-US', {
    year: 'numeric',
    month: 'long',
    day: 'numeric'
  }).format(date)
}

// Format date as 'MM-DD-YYYY'
export const formatDateShort = (date) => {
  const month = (date.getMonth() + 1).toString().padStart(2, '0')
  const day = date.getDate().toString().padStart(2, '0')
  const year = date.getFullYear()
  return `${month}-${day}-${year}`
}

// Format date as 18 October 2024
export function formatDate(dateString) {
  const date = new Date(dateString)
  const options = { year: 'numeric', month: 'long', day: 'numeric' }
  return date.toLocaleDateString('en-GB', options)
}

// Get time from a date-time string
export function formatTime(isoString) {
  const date = new Date(isoString)

  let hours = date.getUTCHours()
  const minutes = date.getUTCMinutes()
  const seconds = date.getUTCSeconds()

  const period = hours >= 12 ? 'PM' : 'AM'

  // Convert to 12-hour format
  hours = hours % 12
  hours = hours ? hours : 12 // Nếu là 0 thì đổi thành 12

  // Format các giá trị thành dạng 2 chữ số
  const formattedMinutes = minutes.toString().padStart(2, '0')
  const formattedSeconds = seconds.toString().padStart(2, '0')

  return `${hours}:${formattedMinutes}:${formattedSeconds} ${period}`
}

// Convert Date to CalendarDate
export const toCalendarDate = (date) => {
  return parseDate(date.toISOString().split('T')[0])
}

// Create a DateFormatter instance
export const df = new DateFormatter('en-US', {
  year: 'numeric',
  month: 'long',
  day: 'numeric'
})
