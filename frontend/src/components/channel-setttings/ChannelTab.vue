<script setup>
import FacebookBigIcon from '@assets/icons/FacebookBigIcon.vue'
import InstagramIcon from '@assets/icons/InstagramIcon.vue'
import YoutubeIcon from '@assets/icons/YoutubeIcon.vue'
import { Button } from '@common/ui/button'
import { Input } from '@common/ui/input'
import { Textarea } from '@common/ui/textarea'
import { useToast } from '@common/ui/toast'
import {
  REGEX_FACEBOOK_URL,
  REGEX_INSTAGRAM_URL,
  REGEX_YOUTUBE_URL
} from '@constants/regex.constant'
import { t } from '@helpers/i18n.helper'
import { channelSettingsService } from '@services/channel-settings.services'
import { computed, ref, watch, watchEffect } from 'vue'

const props = defineProps({
  channelId: {
    type: Number,
    required: true
  },
  isSuccess: {
    type: Boolean,
    required: true
  }
})

const channelBio = defineModel('channelBio')
const channelLinks = defineModel('channelLinks')

const { toast } = useToast()

const charCount = ref(0)
const charLimit = ref(500)
const isLoading = ref(false)

const facebookLink = ref('')
const insLink = ref('')
const youtubeLink = ref('')

const initialBio = ref('')
const initialFacebookLink = ref('')
const initialInstagramLink = ref('')
const initialYoutubeLink = ref('')

const facebookError = ref('')
const instagramError = ref('')
const youtubeError = ref('')

const isBioValid = computed(() => {
  return channelBio.value === '' || channelBio.value.trim() !== ''
})

const initializeLinks = () => {
  if (channelBio.value) {
    charCount.value = channelBio.value.length
  }
  channelLinks.value.forEach((channel) => {
    if (channel.name === 'facebook') {
      facebookLink.value = channel.link
    } else if (channel.name === 'instagram') {
      insLink.value = channel.link
    } else if (channel.name === 'youtube') {
      youtubeLink.value = channel.link
    }
  })
}

const validateLinks = () => {
  let banned = false
  if (facebookLink.value !== '') {
    if (!REGEX_FACEBOOK_URL.test(facebookLink.value)) {
      facebookError.value =
        'You have entered an invalid URL. Please make sure the URL is from Facebook.'
      banned = true
    } else {
      facebookError.value = ''
    }
  }
  if (insLink.value !== '') {
    if (!REGEX_INSTAGRAM_URL.test(insLink.value)) {
      instagramError.value =
        'You have entered an invalid URL. Please make sure the URL is from Instargram.'
      banned = true
    } else {
      instagramError.value = ''
    }
  }
  if (youtubeLink.value !== '') {
    if (!REGEX_YOUTUBE_URL.test(youtubeLink.value)) {
      youtubeError.value =
        'You have entered an invalid URL. Please make sure the URL is from Youtube.'
      banned = true
    } else {
      youtubeError.value = ''
    }
  }
  if (banned) {
    return false
  } else {
    return true
  }
}

const handleTextarea = (inputValue) => {
  channelBio.value = inputValue
  charCount.value = channelBio.value.length
}

const handleSaveSettings = async () => {
  if (!isBioValid.value) {
    return
  }

  let fbLink = ''
  let instLink = ''
  let ytLink = ''

  if (validateLinks()) {
    channelLinks.value.forEach((socialLink) => {
      if (socialLink.name === 'facebook') {
        fbLink = socialLink.link || ''
      } else if (socialLink.name === 'instagram') {
        instLink = socialLink.link || ''
      } else if (socialLink.name === 'youtube') {
        ytLink = socialLink.link || ''
      }
    })

    if (
      channelBio.value === initialBio.value &&
      fbLink === initialFacebookLink.value &&
      instLink === initialInstagramLink.value &&
      ytLink === initialYoutubeLink.value
    ) {
      return
    }

    isLoading.value = true
    channelBio.value = channelBio.value.trim()
    try {
      const res = await channelSettingsService.saveChannelSettings(
        props.channelId,
        channelBio.value,
        fbLink,
        instLink,
        ytLink
      )
      if (res.message === 'success') {
        initialBio.value = channelBio.value
        initialFacebookLink.value = fbLink
        initialInstagramLink.value = instLink
        initialYoutubeLink.value = ytLink
        toast({ description: `${t('channel_settings.success')}`, variant: 'successfully' })
      }
    } catch (error) {
      toast({ description: error.message, variant: 'destructive' })
    }
    isLoading.value = false
    facebookError.value = ''
    instagramError.value = ''
    youtubeError.value = ''
  }
}

watch(
  () => props.isSuccess,
  (newValue) => {
    if (newValue) {
      if (channelBio.value) {
        initialBio.value = channelBio.value
      }
      if (channelLinks.value && channelLinks.value.length > 0) {
        channelLinks.value.forEach((channel) => {
          if (channel.name === 'facebook') {
            initialFacebookLink.value = channel.link
          } else if (channel.name === 'instagram') {
            initialInstagramLink.value = channel.link
          } else if (channel.name === 'youtube') {
            initialYoutubeLink.value = channel.link
          }
        })
      }
      initializeLinks()
    }
  }
)

watchEffect(() => {
  if (channelLinks.value && channelLinks.value.length > 0) {
    initializeLinks()
  }
})

watch([facebookLink, insLink, youtubeLink], ([newFacebook, newInstagram, newYoutube]) => {
  channelLinks.value = [
    { name: 'facebook', link: newFacebook },
    { name: 'instagram', link: newInstagram },
    { name: 'youtube', link: newYoutube }
  ]
})
</script>

<template>
  <div class="flex flex-col w-[60%] gap-6">
    <div class="flex flex-col gap-1">
      <p class="text-[14px] font-bold">
        {{ $t('channel_settings.bio') }}
        <span class="italic font-normal">{{ $t('channel_settings.optionals') }}</span>
      </p>
      <p class="text-[12px] text-[#777777]">{{ $t('channel_settings.tell_us') }}</p>
      <Textarea
        v-model="channelBio"
        @input="(e) => handleTextarea(e.target.value)"
        class="resize-none h-[120px] placeholder:text-[16px]"
        placeholder="Write something about yourself"
        :maxlength="charLimit"
      />
      <span class="ml-auto text-lightGray text-[14px] font-light">
        {{ charCount }} / {{ charLimit }} {{ $t('channel_settings.characters') }}
      </span>
    </div>
    <div class="flex flex-col gap-1">
      <p class="text-[14px] font-bold">
        Social links <span class="italic font-normal">{{ $t('channel_settings.optionals') }}</span>
      </p>
      <p class="text-[12px] text-[#777777]">{{ $t('channel_settings.add') }}</p>
      <div class="flex flex-col gap-2">
        <div class="flex flex-col">
          <div class="flex items-center gap-2">
            <FacebookBigIcon />
            <Input
              v-model="facebookLink"
              class="w-full h-[40px]"
              placeholder="www.facebook.com/facebook"
              :class="{ 'border-destructive': facebookError }"
            />
          </div>
          <p v-if="facebookError" class="ml-11 text-destructive text-[12px] italic">
            {{ facebookError }}
          </p>
        </div>
        <div class="flex flex-col">
          <div class="flex items-center gap-2">
            <InstagramIcon />
            <Input
              v-model="insLink"
              class="w-full h-[40px]"
              placeholder="www.instagram.com/instagram"
              :class="{ 'border-destructive': instagramError }"
            />
          </div>
          <p v-if="instagramError" class="ml-11 text-destructive text-[12px] italic">
            {{ instagramError }}
          </p>
        </div>
        <div class="flex flex-col">
          <div class="flex items-center gap-2">
            <YoutubeIcon />
            <Input
              v-model="youtubeLink"
              class="w-full h-[40px]"
              placeholder="www.youtube.com/youtube"
              :class="{ 'border-destructive': youtubeError }"
            />
          </div>
          <p v-if="youtubeError" class="ml-11 text-destructive text-[12px] italic">
            {{ youtubeError }}
          </p>
        </div>
      </div>
    </div>
    <Button @click="handleSaveSettings" class="w-[230px] h-[40px] mt-8" :is-loading="isLoading"
      ><span v-if="!isLoading" class="text-white font-bold">{{ $t('channel_settings.save') }}</span>
    </Button>
  </div>
</template>
