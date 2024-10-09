commentVideo:
<script setup>
import RenderComment from './RenderComment.vue'
import WriteComment from './WriteComment.vue'

const me = {
  avatar:
    'https://hips.hearstapps.com/hmg-prod/images/cristiano-ronaldo-of-portugal-reacts-as-he-looks-on-during-news-photo-1725633476.jpg?crop=0.666xw:1.00xh;0.180xw,0&resize=640:*'
}

const comments = [
  {
    id: 1,
    avatar:
      'https://dmxg5wxfqgb4u.cloudfront.net/styles/mat_590_x_380/s3/2020-10/Nurmagomedov%20Khabib%20Weigh%20In%20229%20Hero.jpg?h=7092119a&itok=bh47Vv2A',
    name: 'John Doe',
    timestamp: 1728379078,
    likes: 1231,
    dislike: false,
    like: true,
    content:
      'This is the first comment content. Really insightful! This is the first comment content. Really insightful! This is the first comment content. Really insightful! This is the first comment content. Really insightful! This is the first comment content. Really insightful! This is the first comment content. Really insightful! This is the first comment content. Really insightful! This is the first comment content. Really insightful! This is the first comment content. Really insightful! This is the first comment content. Really insightful! This is the first comment content. Really insightful! This is the first comment content. Really insightful! This is the first comment content. Really insightful! This is the first comment content. Really insightful! This is the first comment content. Really insightful! This is the first comment content. Really insightful! This is the first comment content. Really insightful! This is the first comment content. Really insightful!',
    replies: [
      {
        id: 101,
        avatar:
          'https://images2.thanhnien.vn/528068263637045248/2024/10/5/messi-mls-1728100642980881318149.jpeg',
        name: 'Jane Smith',
        timestamp: 1728379078,
        likes: 5,
        dislike: false,
        like: false,
        content: 'I totally agree with your comment!'
      },
      {
        id: 102,
        avatar:
          'https://b.fssta.com/uploads/application/soccer/headshots/2342.vresize.350.350.medium.86.png',
        name: 'Bob Johnson',
        timestamp: 1724372384,
        likes: 3,
        dislike: true,
        like: false,
        content:
          'This is the first comment content. Really insightful! This is the first comment content. Really insightful! This is the first comment content. Really insightful! This is the first comment content. Really insightful! This is the first comment content. Really insightful! This is the first comment content. Really insightful! This is the first comment content. Really insightful! This is the first comment content. Really insightful! This is the first comment content. Really insightful! This is the first comment content. Really insightful! This is the first comment content. Really insightful! This is the first comment content. Really insightful! This is the first comment content. Really insightful! This is the first comment content. Really insightful! This is the first comment content. Really insightful! This is the first comment content. Really insightful! This is the first comment content. Really insightful! This is the first comment content. Really insightful!'
      },
      {
        id: 143,
        avatar:
          'https://images2.thanhnien.vn/528068263637045248/2024/10/5/messi-mls-1728100642980881318149.jpeg',
        name: 'Jane Smith',
        timestamp: 1728379078,
        likes: 5,
        dislike: false,
        like: false,
        content: 'I totally agree with your comment!'
      },
      {
        id: 142,
        avatar:
          'https://images2.thanhnien.vn/528068263637045248/2024/10/5/messi-mls-1728100642980881318149.jpeg',
        name: 'Jane Smith',
        timestamp: 1728379078,
        likes: 5,
        dislike: false,
        like: false,
        content: 'I totally agree with your comment!'
      },
      {
        id: 141,
        avatar:
          'https://images2.thanhnien.vn/528068263637045248/2024/10/5/messi-mls-1728100642980881318149.jpeg',
        name: 'Jane Smith',
        timestamp: 1728379078,
        likes: 5,
        dislike: false,
        like: false,
        content: 'I totally agree with your comment!'
      },
      {
        id: 131,
        avatar:
          'https://images2.thanhnien.vn/528068263637045248/2024/10/5/messi-mls-1728100642980881318149.jpeg',
        name: 'Jane Smith',
        timestamp: 1728379078,
        likes: 5,
        dislike: false,
        like: false,
        content: 'I totally agree with your comment!'
      },
      {
        id: 132,
        avatar:
          'https://images2.thanhnien.vn/528068263637045248/2024/10/5/messi-mls-1728100642980881318149.jpeg',
        name: 'Jane Smith',
        timestamp: 1728379078,
        likes: 5,
        dislike: false,
        like: false,
        content: 'I totally agree with your comment!'
      },
      {
        id: 144,
        avatar:
          'https://images2.thanhnien.vn/528068263637045248/2024/10/5/messi-mls-1728100642980881318149.jpeg',
        name: 'Jane Smith',
        timestamp: 1728379078,
        likes: 5,
        dislike: false,
        like: false,
        content: 'I totally agree with your comment!'
      },
      {
        id: 133,
        avatar:
          'https://images2.thanhnien.vn/528068263637045248/2024/10/5/messi-mls-1728100642980881318149.jpeg',
        name: 'Jane Smith',
        timestamp: 1728379078,
        likes: 5,
        dislike: false,
        like: false,
        content: 'I totally agree with your comment!'
      },
      {
        id: 155,
        avatar:
          'https://images2.thanhnien.vn/528068263637045248/2024/10/5/messi-mls-1728100642980881318149.jpeg',
        name: 'Jane Smith',
        timestamp: 1728379078,
        likes: 5,
        dislike: false,
        like: false,
        content: 'I totally agree with your comment!'
      },
      {
        id: 455,
        avatar:
          'https://images2.thanhnien.vn/528068263637045248/2024/10/5/messi-mls-1728100642980881318149.jpeg',
        name: 'Jane Smith',
        timestamp: 1728379078,
        likes: 5,
        dislike: false,
        like: false,
        content: 'I totally agree with your comment!'
      },
      {
        id: 166,
        avatar:
          'https://images2.thanhnien.vn/528068263637045248/2024/10/5/messi-mls-1728100642980881318149.jpeg',
        name: 'Jane Smith',
        timestamp: 1728379078,
        likes: 5,
        dislike: false,
        like: false,
        content: 'I totally agree with your comment!'
      },
      {
        id: 168,
        avatar:
          'https://images2.thanhnien.vn/528068263637045248/2024/10/5/messi-mls-1728100642980881318149.jpeg',
        name: 'Jane Smith',
        timestamp: 1728379078,
        likes: 5,
        dislike: false,
        like: false,
        content: 'I totally agree with your comment!'
      },
      {
        id: 176,
        avatar:
          'https://images2.thanhnien.vn/528068263637045248/2024/10/5/messi-mls-1728100642980881318149.jpeg',
        name: 'Jane Smith',
        timestamp: 1728379078,
        likes: 5,
        dislike: false,
        like: false,
        content: 'I totally agree with your comment!'
      }
    ]
  },
  {
    id: 2,
    avatar:
      'https://cdn-img.thethao247.vn/origin_640x0/storage/files/hungtm/2024/09/30/erling-haaland-1727679558-140233avatar.jpg',
    name: 'Alice Brown',
    timestamp: 1724372390,
    likes: 20,
    dislike: false,
    like: false,
    content: 'This is the second comment content. Great discussion!',
    replies: [
      {
        id: 201,
        avatar:
          'https://imgcdn.tapchicongthuong.vn/tcct-media/24/9/30/donald-trump_66fa6aa6ce0d1.jpg',
        name: 'David Green',
        timestamp: 1724372391,
        likes: 8,
        dislike: false,
        like: true,
        content: 'Thanks for sharing this information!'
      }
    ]
  },
  {
    id: 3,
    avatar:
      'https://cdn.tuoitre.vn/thumb_w/600/471584752817336320/2023/2/14/thoi-the-thay-doi-mbappe-ra-dieu-kien-cuc-kho-de-o-lai-psg-236322-2045-1676347173240951828485.jpg',
    name: 'Charlie Black',
    timestamp: 1728379360,
    likes: 15,
    dislike: true,
    like: true,
    content: 'This is the third comment content. A bit controversial!',
    replies: []
  }
]
</script>

<template>
  <div class="w-full">
    <div class="w-full">
      <WriteComment :me="me" />
    </div>
    <div class="w-full mt-10">
      <RenderComment :comments="comments" />
    </div>
  </div>
</template>
