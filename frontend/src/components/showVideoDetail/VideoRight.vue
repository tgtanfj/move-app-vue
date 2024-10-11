<script setup>
import VideoRelate from '@components/showVideoDetail/VideoRelate.vue'

// const props = defineProps({
//   videoDetail: {
//     type: Array,
//     required: true
//   }
// })

const videos = [
  {
    id: 1,
    thumbnail:
      'https://i0.wp.com/spartansboxing.com/wp-content/uploads/2023/08/Mike-Tyson.png?fit=1920%2C1080&ssl=1',
    title: 'Fitness World',
    avatar: 'https://wsbufm.com/wp-content/uploads/2023/03/mike-tyson.jpg?w=640',
    notification: 'posted 5 days ago',
    stars: 4.9,
    duration: 'less than 1 hour',
    workoutLevel: 'beginner',
    category: 'Strength',
    isAuth: true,
    about: 'This channel focuses on beginner-friendly workouts and fitness tips.',
    views: 141033123,
    postedTime: 1726563232.894597,
    videoTime: '12:33'
  },
  {
    id: 2,
    thumbnail:
      'https://i0.wp.com/www.muscleandfitness.com/wp-content/uploads/2018/12/1109-Larry-Wheels-Deadlift.jpg?quality=86&strip=all',
    title: 'Yoga with Jane',
    avatar: 'https://wsbufm.com/wp-content/uploads/2023/03/mike-tyson.jpg?w=640',
    notification: 'posted 2 days ago',
    stars: 4.7,
    duration: '30 minutes',
    workoutLevel: 'intermediate',
    category: 'Strength',
    isAuth: true,
    about: 'Join Jane for relaxing yoga sessions tailored to all skill levels.',
    views: 3200,
    postedTime: 1727799464.894606,
    videoTime: '1:41:21'
  },
  {
    id: 3,
    thumbnail:
      'https://www.si.com/.image/ar_16:9%2Cc_fill%2Ccs_srgb%2Cfl_progressive%2Cq_auto:good%2Cw_1200/MjA1MTgxNjYwNjkyNDg5ODYw/conor-mcgregor-ufc-octagon-spotlight.jpg',
    title: 'Powerlifting Pro',
    avatar: 'https://wsbufm.com/wp-content/uploads/2023/03/mike-tyson.jpg?w=640',
    notification: 'posted 1 week ago',
    stars: 4.8,
    duration: '1 hour',
    workoutLevel: 'advanced',
    category: 'Strength',
    isAuth: false,
    about: 'Learn the secrets of powerlifting and strength training from the pros.',
    views: 2250,
    postedTime: 1726372382.894611,
    videoTime: '59:33'
  },
  {
    id: 4,
    thumbnail:
      'https://boxraw.com/cdn/shop/articles/Saul-Canelo-Alvarez-Dmitry-Bivol6-Photo-by-Ed-Mulholland-Matchroom.jpg?v=1652185062',
    title: 'Cardio Burn',
    avatar: 'https://wsbufm.com/wp-content/uploads/2023/03/mike-tyson.jpg?w=640',
    notification: 'posted 3 days ago',
    stars: 4.5,
    duration: '45 minutes',
    workoutLevel: 'beginner',
    category: 'Strength',
    isAuth: true,
    about: 'High-energy cardio workouts designed to get your heart pumping.',
    views: 1720,
    postedTime: 1725999713.89455,
    videoTime: '10:33:31'
  },
  {
    id: 5,
    thumbnail:
      'https://media-cdn-v2.laodong.vn/storage/newsportal/2020/9/3/832994/The-Rock-Tai-Tu-The-.jpg',
    title: 'HIIT with Alex',
    avatar: 'https://wsbufm.com/wp-content/uploads/2023/03/mike-tyson.jpg?w=640',
    notification: 'posted 6 hours ago',
    stars: 4.6,
    duration: '20 minutes',
    workoutLevel: 'intermediate',
    about: 'Alex offers quick and intense HIIT sessions that fit into your busy day.',
    category: 'Strength',
    views: 2900,
    isAuth: false,
    postedTime: 1724372382.894611,
    videoTime: '3:33:33'
  },
  {
    id: 6,
    thumbnail:
      'https://media-cdn-v2.laodong.vn/storage/newsportal/2020/9/3/832994/The-Rock-Tai-Tu-The-.jpg',
    title: 'HIIT with Alex',
    avatar: 'https://wsbufm.com/wp-content/uploads/2023/03/mike-tyson.jpg?w=640',
    notification: 'posted 6 hours ago',
    stars: 4.6,
    duration: '40 minutes',
    workoutLevel: 'intermediate',
    about: 'Alex offers quick and intense HIIT sessions that fit into your busy day.',
    category: 'Strength',
    views: 2900,
    isAuth: false,
    postedTime: 1724372382.894611,
    videoTime: '3:33:33'
  }
]
</script>

<template>
  <div class="flex-1 p-4">
    <h3 class="text-sm font-semibold mb-4">{{ $t('video_detail.watch_also') }}</h3>
    <div class="flex flex-col gap-6">
      <div v-for="video in videos" :key="video.id">
        <VideoRelate :video="video" />
      </div>
    </div>
  </div>
</template>

