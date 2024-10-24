<script setup>
import FacebookBigIcon from '@assets/icons/FacebookBigIcon.vue'
import YoutubeIcon from '@assets/icons/YoutubeIcon.vue'
import InstagramIcon from '@assets/icons/InstagramIcon.vue'

const props = defineProps({
  link: {
    type: String,
    required: true
  },
  title: {
    type: String,
    required: true
  }
})
</script>
<template>
  <div>
    <a :href="props.link" target="_blank">
      <span v-if="title === 'facebook'">
        <FacebookBigIcon />
      </span>
      <span v-if="title === 'instagram'">
        <InstagramIcon />
      </span>
      <span v-if="title === 'youtube'">
        <YoutubeIcon />
      </span>
    </a>
  </div>
</template>
