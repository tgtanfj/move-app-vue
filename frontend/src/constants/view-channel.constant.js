import { formatCategoryTitleToUrl } from '../utils/formatCategoryTitle.util'

export const LEVEL = [
  {
    title: 'All levels',
    value: 'all-level'
  },
  {
    title: 'Beginner',
    value: 'beginner'
  },
  {
    title: 'Intermediate',
    value: 'intermediate'
  },
  {
    title: 'Advanced',
    value: 'advanced'
  }
]

export const SORT_BY = [
  {
    title: 'Most recent',
    value: formatCategoryTitleToUrl('Most recent')
  },
  {
    title: 'Views (High to Low)',
    value: formatCategoryTitleToUrl('Views (High to Low)')
  },
  {
    title: 'Views (Low to High)',
    value: formatCategoryTitleToUrl('Views (Low to High)')
  },
  {
    title: 'Duration (Long to Short)',
    value: formatCategoryTitleToUrl('Duration (Long to Short)')
  },
  {
    title: 'Duration (Short to Long)',
    value: formatCategoryTitleToUrl('Duration (Short to Long)')
  },
  {
    title: 'Ratings (High to Low)',
    value: formatCategoryTitleToUrl('Ratings (High to Low)')
  },
  {
    title: 'Ratings (Low to High)',
    value: formatCategoryTitleToUrl('Ratings (Low to High)')
  }
]
