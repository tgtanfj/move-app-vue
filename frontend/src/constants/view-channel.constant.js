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

export const SORT_BY_ANALYTICS = [
  {
    title: 'All statuses',
    value: formatCategoryTitleToUrl('All statuses')
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
    title: 'REPs (High to Low)',
    value: formatCategoryTitleToUrl('REPs (High to Low)')
  },
  {
    title: 'REPs (Low to High)',
    value: formatCategoryTitleToUrl('REPs (Low to High)')
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

export const SHOW_ANALYTICS = [
  {
    title: 'All time',
    value: formatCategoryTitleToUrl('All time')
  },
  {
    title: 'Last 7 days',
    value: formatCategoryTitleToUrl('Last 7 days')
  },
  {
    title: 'Last 30 days',
    value: formatCategoryTitleToUrl('Last 30 days')
  },
  {
    title: 'Last 90 days',
    value: formatCategoryTitleToUrl('Last 90 days')
  },
  {
    title: '1 year ago',
    value: formatCategoryTitleToUrl('1 year ago')
  }
]
