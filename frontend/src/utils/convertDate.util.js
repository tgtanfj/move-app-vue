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

// Get time from a date-time string
export const formatTime = (dateString) => {
  const date = new Date(dateString)
  return date.toLocaleTimeString('en-US', { hour: '2-digit', minute: '2-digit', second: '2-digit' })
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
