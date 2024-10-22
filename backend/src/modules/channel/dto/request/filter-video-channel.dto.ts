export enum FilterWorkoutLevel {
  ALL_LEVEL = 'all-level',
  BEGINNER = 'beginner',
  INTERMEDIATE = 'intermediate',
  ADVANCED = 'advanced',
}

export enum SortBy {
  MOST_RECENT = 'most-recent',
  VIEWS_HIGH_TO_LOW = 'views-high-to-low',
  VIEWS_LOW_TO_HIGH = 'views-low-to-high',
  DURATION_HIGH_TO_LOW = 'duration-high-to-low',
  DURATION_LOW_TO_HIGH = 'duration-low-to-high',
  RATINGS_HIGH_TO_LOW = 'ratings-high-to-low',
  RATINGS_LOW_TO_HIGH = 'ratings-low-to-high',
}

export enum ShowBy {
  ALL_TIME = 'all-time',
  LAST_7_DAYS = 'last-7-days',
  LAST_30_DAYS = 'last-30-days',
  LAST_90_DAYS = 'last-90-days',
  ONE_YEAR_AGO = 'one-year-ago',
}
export class FilterVideoChannelDto {}
