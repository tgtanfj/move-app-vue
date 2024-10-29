export const determineAsc = (sortByTitle) => {
  return sortByTitle.includes('Low to High')
}
export const getSortTypeFromTitle = (title) => {
  if (title.includes('Views')) {
    return 'views'
  }
  if (title.includes('REPs')) {
    return 'reps'
  }
  if (title.includes('Ratings')) {
    return 'ratings'
  }
  return 'all'
}
