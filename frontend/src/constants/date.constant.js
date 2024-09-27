export const DAYS = Array.from({ length: 31 }, (_, i) => (i + 1).toString().padStart(2, '0'))
export const MONTHS = [
  {
    num: '01',
    text: 'January'
  },
  {
    num: '02',
    text: 'February'
  },
  {
    num: '03',
    text: 'March'
  },
  {
    num: '04',
    text: 'April'
  },
  {
    num: '05',
    text: 'May'
  },
  {
    num: '06',
    text: 'June'
  },
  {
    num: '07',
    text: 'July'
  },
  {
    num: '08',
    text: 'August'
  },
  {
    num: '09',
    text: 'September'
  },
  {
    num: '10',
    text: 'October'
  },
  {
    num: '11',
    text: 'November'
  },
  {
    num: '12',
    text: 'December'
  }
]
export const YEARS = Array.from({ length: 100 }, (_, i) => new Date().getFullYear() - i)
