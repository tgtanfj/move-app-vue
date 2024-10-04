<script setup>
import { reject } from 'lodash-es'
import { FileVideo2 } from 'lucide-vue-next'
import { ref, watch } from 'vue'

import { REGEX_UPLOADVIDE_TEXTAREA } from '@constants/regex.constant'
import {
  allowedFormats,
  maxFileSize,
  validImageTypes,
  WORKOUTLEVEL
} from '@constants/upload-video.constant'
import { videoService } from '@services/video.services'
import { base64ToBlob } from '@utils/convertImage.util'
import { cn } from '@utils/shadcn.util'
import { captureThumbnail, compareBlobs } from '@utils/uploadVideo.util'

import { Button } from '@/common/ui/button'
import { Dialog, DialogContent, DialogFooter, DialogTrigger } from '@/common/ui/dialog'
import { Input } from '@/common/ui/input'
import { Label } from '@/common/ui/label'
import { RadioGroup, RadioGroupItem } from '@/common/ui/radio-group'
import {
  Select,
  SelectContent,
  SelectGroup,
  SelectItem,
  SelectTrigger,
  SelectValue
} from '@/common/ui/select'
import { Tabs, TabsList } from '@/common/ui/tabs'
import { Textarea } from '@/common/ui/textarea'
import { useToast } from '@common/ui/toast'

import VideoIcon from '@assets/icons/videoIcon.vue'
import ImageLoading from './ImageLoading.vue'
import Loading from './Loading.vue'
import UploadVideoProgress from './UploadVideoProgress.vue'

const isOpenUploadVideoModal = ref(false)
const isOpenUploadVideoDetails = ref(false)
const isOpenConfirmModal = ref(false)

const title = ref('')
const thumbnail = ref('')
const category = ref(null)
const workoutLevel = ref('')
const duration = ref('')
const tags = ref('')
const isCommentable = ref(null)
const videoInput = ref(null)

const categories = ref(null)
const uploading = ref(false)
const progress = ref(0)
const error = ref(null)
const images = ref([])
const imagesAfterConvert = ref([])
const selectedIndex = ref(null)
const imagesSelected = ref(null)
const fileInput = ref(null)
const fileInputThumb = ref(null)
const uploadLoading = ref(null)
const uploadLink = ref(null)
const linkVideoInput = ref(null)

const validateSizeTypeErr = ref('')
const titleErr = ref('')
const thumbnailErr = ref('')
const categoryErr = ref('')
const workoutLevelErr = ref('')
const durationErr = ref('')
const isCommentableErr = ref('')
const thumbnailTypeValidationErr = ref('')

const nullFirstTab = ref(false)
const nullSecondTab = ref(false)

const tabChange = ref('details')
const charCount = ref(0)
const charLimit = 500

const { toast } = useToast()

watch(title, (newValue) => {
  if (newValue) titleErr.value = ''
})

watch(category, (newValue) => {
  if (newValue) categoryErr.value = ''
})

watch(isCommentable, (newValue) => {
  if (newValue) isCommentableErr.value = ''
})

const selectFile = () => {
  fileInput.value.click()
}

const resetField = () => {
  title.value = ''
  imagesSelected.value = ''
  tags.value = ''
  duration.value = ''
  workoutLevel.value = ''
  category.value = ''
  isCommentable.value = null
  tabChange.value = 'details'
  images.value = []
  imagesSelected.value = []
  validateSizeTypeErr.value = ''
  titleErr.value = ''
  thumbnailErr.value = ''
  categoryErr.value = ''
  workoutLevelErr.value = ''
  durationErr.value = ''
  isCommentableErr.value = ''
  uploadLoading.value = null
  uploading.value = null
  nullFirstTab.value = false
  nullSecondTab.value = false
  thumbnailTypeValidationErr.value = ''
  videoInput.value = null
}

const onCloseConfirmModal = () => {
  isOpenConfirmModal.value = false
  resetField()
}

const onDialogClose = (isOpen) => {
  if (!isOpen) {
    isOpenConfirmModal.value = true
  }
}

const onBackToDetail = () => {
  isOpenConfirmModal.value = false
  isOpenUploadVideoDetails.value = true
}

const validateVideo = async (file) => {
  validateSizeTypeErr.value = ''
  if (!allowedFormats.includes(file.type)) {
    validateSizeTypeErr.value = 'File Format Requirement Not Meet'
  }
  if (file.size > maxFileSize) {
    validateSizeTypeErr.value = 'File Format Requirement Not Meet'
  }

  const videoElement = document.createElement('video')
  videoElement.src = URL.createObjectURL(file)
  videoElement.preload = 'metadata'

  videoElement.onloadedmetadata = async () => {
    const videoWidth = videoElement.videoWidth
    const videoHeight = videoElement.videoHeight

    if (videoWidth < 426 || videoHeight < 420 || videoWidth > 3840 || videoHeight > 2160) {
      validateSizeTypeErr.value = 'File Format Requirement Not Meet'
    }
    validateSizeTypeErr.value = ''
    await captureThumbnails(videoElement)
    imagesSelected.value = images.value[0]
  }
}

const captureThumbnails = async (videoElement) => {
  const duration = videoElement.duration
  const captureTimes = [0.2, 0.4, 0.6, 0.8, 1.0].map((percentage) => duration * percentage)
  for (const time of captureTimes) {
    const imageUrl = await captureThumbnail(videoElement, time)
    images.value.push(imageUrl)
  }
  return images.value
}

const handleFileChange = async (event) => {
  const files = event.target.files
  await validateVideo(files[0])
  if (files.length > 0 && validateSizeTypeErr.value === '') {
    uploadVideo(files[0])
  }
}

const handleDrop = async (event) => {
  const files = event.dataTransfer.files
  await validateVideo(files[0])
  if (files.length > 0 && validateSizeTypeErr.value === '') {
    uploadVideo(files[0])
  }
}

const updateProgress = (progresValue) => {
  progress.value = progresValue
}

const uploadVideo = async (file) => {
  uploading.value = true
  progress.value = 0
  error.value = null
  videoInput.value = file

  if (file) {
    isOpenUploadVideoModal.value = false
    isOpenUploadVideoDetails.value = true
  }

  try {
    const { data } = await videoService.createVideoSession(file.size, updateProgress)

    if (data.message === 'success') {
      uploadLink.value = data.data.response.linkUpLoad
      linkVideoInput.value = data.data.response.linkVideo
      categories.value = data.data.categories
      await videoService.uploadVideoSecondStep(uploadLink.value, file)
      await videoService.verifyUpload(uploadLink.value)
    }
    if (data.message !== 'success') {
      throw new Error('Failed to create video on Vimeo')
    }
    uploading.value = false
  } catch (err) {
    error.value = 'Failed to upload video'
    console.error('Upload error:', err)
  } finally {
    uploading.value = false
  }
}

const changeTab = (newTab) => {
  tabChange.value = newTab
}

const handleInput = (inputValue) => {
  let validInput = ''
  for (const char of inputValue) {
    if (REGEX_UPLOADVIDE_TEXTAREA.test(char)) {
      validInput += char
    }
  }
  tags.value = validInput
  charCount.value = tags.value.length
}

const selectFilesThumbnail = () => {
  fileInputThumb.value.click()
}

const changeSelectedImage = (image) => {
  thumbnail.value = image
  imagesSelected.value = image
}

const changeWorkoutLevel = (level) => {
  workoutLevelErr.value = ''
  workoutLevel.value = level
}

const changeDuration = (value) => {
  durationErr.value = ''
  duration.value = value
}

const handleThumbnailUpload = (event) => {
  if (!validImageTypes.includes(event.target.files[0].type)) {
    reject((thumbnailTypeValidationErr.value = 'File Format, File Size Limit Requirement Not Meet'))
    return
  }

  const files = Array.from(event.target.files)
  const newImages = []

  const promises = files.map((file) => {
    return new Promise((resolve, reject) => {
      const reader = new FileReader()
      reader.onload = (e) => {
        const base64String = e.target.result
        newImages.push(base64String)
        resolve()
      }
      reader.onerror = (error) => reject(error)

      reader.readAsDataURL(file)
    })
  })

  Promise.all(promises)
    .then(() => {
      images.value.unshift(...newImages)

      if (images.value.length > 6) {
        images.value = images.value.slice(0, 6)
      }

      thumbnailErr.value = ''

      if (images.value.length > 0) {
        imagesSelected.value = images.value[0]
        thumbnail.value = images.value[0]
      }
    })
    .catch((error) => {
      console.error('Error when read image: ', error)
    })
}

const firstButton = (tab) => {
  if (!title.value) {
    titleErr.value = 'Please enter a title'
  }
  if (!imagesSelected.value) {
    thumbnailErr.value = 'Please upload thumbnail'
  }
  if (imagesSelected.value && title.value) {
    changeTab(tab)
  }
}

const secondButton = (tab) => {
  if (!category.value) {
    categoryErr.value = 'Please select a category'
  }
  if (!duration.value) {
    durationErr.value = 'Please select a duration'
  }
  if (!workoutLevel.value) {
    workoutLevelErr.value = 'Please select a level'
  }
  if (category.value && duration.value && workoutLevel.value) {
    changeTab(tab)
  }
}

const thirdButton = async (tab) => {
  if (!isCommentable.value) isCommentableErr.value = 'Please select comment setting'
  if (isCommentable.value) {
    if (!title.value || !imagesSelected.value) {
      nullFirstTab.value = true
      if (!title.value) titleErr.value = 'Please enter a title'
      if (!imagesSelected.value) thumbnailErr.value = 'Please upload thumbnail'
    } else {
      nullFirstTab.value = false
    }
    if (!category.value || !workoutLevel.value || !duration.value) {
      nullSecondTab.value = true
      if (!category.value) categoryErr.value = 'Please select a category'
      if (!workoutLevel.value) workoutLevelErr.value = 'Please select a level'
      if (!duration.value) durationErr.value = 'Please select a duration'
    } else {
      nullSecondTab.value = false
    }
    if (!nullFirstTab.value && !nullSecondTab.value) {
      const durationText =
        duration.value === '30 mins'
          ? 'less than 30 minutes'
          : duration.value === '< 1 hour'
            ? 'less than 1 hours'
            : duration.value === '> 1 hour'
              ? 'more than 1 hours'
              : 'unknown'

      const thumbnailBlob = base64ToBlob(imagesSelected.value)
      const checkImages = async () => {
        imagesAfterConvert.value = []
        for (let index = 0; index < images.value.length; index++) {
          const img = base64ToBlob(images.value[index])
          imagesAfterConvert.value.push(img)
          const isEqual = await compareBlobs(img, thumbnailBlob)
          if (isEqual) {
            selectedIndex.value = index
          }
        }
      }
      await checkImages()
      const formData = new FormData()
      formData.append('thumbnails', thumbnailBlob)
      formData.append('title', title.value)
      formData.append('category', category.value)
      formData.append('workoutLevel', workoutLevel.value.toLowerCase())
      formData.append('duration', durationText)
      formData.append('keywords', tags.value)
      formData.append('selectedThumbnail', selectedIndex.value)
      formData.append('isCommentable', isCommentable.value === 'enabled' ? 'true' : 'false')
      formData.append('url', linkVideoInput.value)
      formData.append('isPublish', 'true')
      formData.append('video', videoInput.value)
      uploadLoading.value = true
      const uploadVideoData = await videoService.uploadVideo(formData)

      if (uploadVideoData.message === 'success') {
        isOpenUploadVideoDetails.value = false
        uploadLoading.value = false
        resetField()
      } else {
        uploadLoading.value = false
      }
    }
  }
}
</script>

<template>
  <Dialog v-model:open="isOpenUploadVideoModal">
    <DialogTrigger as-child>
      <Button variant="default" class="flex items-center gap-2 mt-3">
        <FileVideo2 class="text-xl" />
        <span class="text-base font-semibold -mb-1">{{ $t('button.upload_video') }}</span>
      </Button>
    </DialogTrigger>
    <DialogContent class="w-[840px] h-[480px]">
      <div>
        <p class="text-[24px] font-bold mb-8">{{ $t('upload_video.title') }}</p>
        <div
          @drop.prevent="handleDrop"
          @dragover.prevent
          @dragenter.prevent
          :class="
            cn(
              'w-full h-[350px] rounded-lg border-2 border-primary flex flex-col items-center justify-center gap-1.5',
              {
                'border-destructive': validateSizeTypeErr
              }
            )
          "
        >
          <VideoIcon />
          <p class="text-[14px]">{{ $t('upload_video.drag_drop') }}</p>
          <p class="text-[14px]">{{ $t('upload_video.or') }}</p>
          <Button @click="selectFile" variant="default" class="text-[16px] w-[110px]">
            <span v-if="!uploading">{{ $t('upload_video.button') }}</span>
            <Loading v-if="uploading" />
          </Button>
          <input
            ref="fileInput"
            type="file"
            class="hidden"
            @change="handleFileChange"
            accept="video/*"
          />
          <p class="text-[#777777] text-[12px]">{{ $t('upload_video.size') }}</p>
        </div>
        <div class="text-destructive text-sm mt-6" v-if="validateSizeTypeErr">
          {{ validateSizeTypeErr }}
        </div>
      </div>
    </DialogContent>
  </Dialog>

  <Dialog v-model:open="isOpenUploadVideoDetails" @update:open="onDialogClose">
    <DialogContent
      class="m-0 p-0 w-[840px] h-[520px] flex flex-col justify-between overflow-hidden"
    >
      <div class="my-6 mx-6">
        <p class="text-[24px] font-bold mb-6">{{ $t('upload_video.video_details') }}</p>
        <div class="w-full">
          <Tabs default-value="details" class="flex" orientation="vertical">
            <TabsList class="flex flex-col items-start w-[150px] ml-0 pl-0 gap-4 mb-auto">
              <div
                @click="changeTab('details')"
                class="font-light text-lightGray cursor-pointer"
                value="details"
              >
                <div class="flex items-center justify-start w-full gap-3">
                  <div
                    class="w-[24px] h-[24px] rounded-full bg-lightGray text-white flex items-center justify-center"
                    :class="{ '!bg-[#000000]': tabChange === 'details' }"
                  >
                    <span>1</span>
                  </div>
                  <div
                    :class="
                      cn('text-[16px]', {
                        'font-bold text-secondary': tabChange === 'details',
                        'font-light text-lightGray': tabChange !== 'details',
                        'font-bold text-destructive': nullFirstTab === true
                      })
                    "
                  >
                    {{ $t('upload_video.details') }}
                  </div>
                </div>
              </div>
              <div
                @click="changeTab('tags')"
                class="font-light text-lightGray cursor-pointer"
                value="details"
              >
                <div class="flex items-center justify-start w-full gap-3">
                  <div
                    class="w-[24px] h-[24px] rounded-full bg-lightGray text-white flex items-center justify-center"
                    :class="{ '!bg-[#000000]': tabChange === 'tags' }"
                  >
                    <span>2</span>
                  </div>
                  <div
                    :class="
                      cn('text-[16px]', {
                        'font-bold text-secondary': tabChange === 'tags',
                        'font-light text-lightGray': tabChange !== 'tags',
                        'font-bold text-destructive': nullSecondTab === true
                      })
                    "
                  >
                    {{ $t('upload_video.tags') }}
                  </div>
                </div>
              </div>
              <div
                @click="changeTab('settings')"
                class="font-light text-lightGray cursor-pointer"
                value="details"
              >
                <div class="flex items-center justify-start w-full gap-3">
                  <div
                    class="w-[24px] h-[24px] rounded-full bg-lightGray text-white flex items-center justify-center"
                    :class="{ '!bg-[#000000]': tabChange === 'settings' }"
                  >
                    <span>3</span>
                  </div>
                  <div
                    class="text-[16px]"
                    :class="{
                      'font-bold text-secondary': tabChange === 'settings',
                      'text-lightGray font-light': tabChange !== 'settings'
                    }"
                  >
                    {{ $t('upload_video.settings') }}
                  </div>
                </div>
              </div>
            </TabsList>
            <div class="w-full mt-1">
              <div v-show="tabChange === 'details'" class="flex flex-col w-full gap-4">
                <div class="flex flex-col gap-1">
                  <div class="flex items-center gap-4">
                    <p class="text-[16px]">{{ $t('upload_video.video_title') }}</p>
                    <div v-if="titleErr !== ''" class="text-destructive italic">
                      {{ titleErr }}
                    </div>
                  </div>
                  <Input v-model="title" maxlength="100" placeholder="Add a title" class="w-full" />
                </div>
                <div class="flex items-center gap-2 relative">
                  <div class="flex flex-col gap-1">
                    <p class="text-[16px]">{{ $t('upload_video.video_thumbnail') }}</p>
                    <input
                      type="file"
                      multiple
                      @change="handleThumbnailUpload"
                      class="hidden"
                      ref="fileInputThumb"
                    />
                    <div
                      class="w-[160px] h-[90px] cursor-pointer rounded-sm border-[2px] border-primary border-dashed flex flex-col items-center justify-center"
                      @click="selectFilesThumbnail"
                    >
                      <div class="flex flex-col items-center justify-center">
                        <VideoIcon />
                        <p class="text-[12px]">{{ $t('upload_video.upload_thumbnail') }}</p>
                      </div>
                    </div>
                  </div>
                  <div
                    class="flex items-center gap-2 w-[480px] overflow-x-auto overflow-y-hidden pb-2 h-[150px]"
                  >
                    <div class="flex items-center gap-2">
                      <img
                        v-for="(image, index) in images"
                        :key="index"
                        class="w-[160px] h-[90px] border rounded-sm cursor-pointer object-cover"
                        :class="{
                          'inset-0 bg-white opacity-50': image != imagesSelected,
                          'bg-none border-spacing-2 border-primary': image == imagesSelected,
                          'mt-[49px]': images.length > 2,
                          'mt-[33px]': images.length <= 2
                        }"
                        @click="changeSelectedImage(image)"
                        :src="image"
                        alt="Thumbnail"
                      />
                      <ImageLoading v-if="images.length <= 0" class="mt-[33px]" />
                    </div>
                  </div>

                  <div
                    v-if="thumbnailErr !== ''"
                    class="absolute top-[19px] left-[147px] text-destructive italic"
                  >
                    {{ thumbnailErr }}
                  </div>
                  <div
                    v-if="thumbnailTypeValidationErr !== ''"
                    class="absolute top-[19px] left-[147px] text-destructive italic"
                  >
                    {{ thumbnailTypeValidationErr }}
                  </div>
                </div>
              </div>
              <div v-show="tabChange === 'tags'" class="flex flex-col w-full gap-4">
                <div class="space-y-1">
                  <div class="flex items-center gap-4">
                    <p class="text-[16px]">{{ $t('upload_video.category') }}</p>
                    <div v-if="categoryErr !== ''" class="text-destructive italic">
                      {{ categoryErr }}
                    </div>
                  </div>
                  <Select v-model="category">
                    <SelectTrigger class="w-[330px] h-[40px] rounded-lg border-primary">
                      <SelectValue placeholder="Select a category" />
                    </SelectTrigger>
                    <SelectContent v-model="category">
                      <SelectGroup v-if="categories" v-for="cate in categories" :key="cate?.id">
                        <SelectItem :value="String(cate?.id)"> {{ cate?.title }} </SelectItem>
                      </SelectGroup>
                    </SelectContent>
                  </Select>
                </div>
                <div class="grid grid-cols-2 gap-4">
                  <div class="flex flex-col gap-3">
                    <div class="flex items-center gap-2">
                      <p class="text-[16px]">{{ $t('upload_video.workout_level') }}</p>
                      <div v-if="workoutLevelErr !== ''" class="text-destructive text-sm italic">
                        {{ workoutLevelErr }}
                      </div>
                    </div>
                    <div class="flex items-center justify-start gap-2">
                      <div
                        v-for="(item, index) in WORKOUTLEVEL"
                        :key="index"
                        @click="changeWorkoutLevel(item.title)"
                        class="h-[26px] rounded-full p-2 flex items-center justify-center cursor-pointer"
                        :class="{
                          'bg-primary text-white': item.title === workoutLevel,
                          'bg-[#EEEEEE] text-black': item.title !== workoutLevel
                        }"
                      >
                        <p class="text-[11px] font-bold">{{ item.title }}</p>
                      </div>
                    </div>
                  </div>
                  <div class="flex flex-col gap-3">
                    <div class="flex items-center gap-4">
                      <p class="text-[16px]">{{ $t('upload_video.duration') }}</p>
                      <div v-if="durationErr !== ''" class="text-destructive italic">
                        {{ durationErr }}
                      </div>
                    </div>
                    <div class="flex items-center justify-start gap-2">
                      <div
                        @click="changeDuration('30 mins')"
                        class="h-[26px] rounded-full p-2 flex items-center justify-center cursor-pointer"
                        :class="{
                          'bg-primary text-white': duration === '30 mins',
                          'bg-[#eeeeee] text-black': duration !== '30 mins'
                        }"
                      >
                        <p class="text-[11px] font-bold">
                          {{ $t('upload_video.less_than_30min') }}
                        </p>
                      </div>
                      <div
                        @click="changeDuration('< 1 hour')"
                        class="h-[26px] rounded-full p-2 flex items-center justify-center cursor-pointer"
                        :class="{
                          'bg-primary text-white': duration === '< 1 hour',
                          'bg-[#eeeeee] text-black': duration !== '< 1 hour'
                        }"
                      >
                        <span class="text-[11px] font-bold">{{
                          $t('upload_video.less_than_1hour')
                        }}</span>
                      </div>
                      <div
                        @click="changeDuration('> 1 hour')"
                        class="h-[26px] rounded-full p-2 flex items-center justify-center cursor-pointer"
                        :class="{
                          'bg-primary text-white': duration === '> 1 hour',
                          'bg-[#eeeeee] text-black': duration !== '> 1 hour'
                        }"
                      >
                        <p class="text-[11px] font-bold">
                          {{ $t('upload_video.more_than_30min') }}
                        </p>
                      </div>
                    </div>
                  </div>
                </div>
                <div class="flex flex-col gap-2">
                  <div class="flex items-center justify-start gap-8">
                    <p class="text-[16px]">{{ $t('upload_video.search_keywords') }}</p>
                    <p class="text-[14px] text-lightGray italic">
                      {{ $t('upload_video.optional') }}
                    </p>
                  </div>
                  <p class="text-[14px] text-lightGray">
                    {{ $t('upload_video.search_keywords_sub') }}
                  </p>
                  <div>
                    <Textarea
                      v-model="tags"
                      @input="(e) => handleInput(e.target.value)"
                      class="h-[120px] resize-none"
                      placeholder="Add tags"
                      :maxlength="charLimit"
                    />
                  </div>
                  <span
                    class="ml-auto text-lightGray text-[14px] font-light"
                    :class="{ 'text-red-500': charCount > charLimit }"
                  >
                    {{ charCount }} / {{ charLimit }} characters
                  </span>
                </div>
              </div>
              <div v-show="tabChange === 'settings'" class="flex flex-col gap-2">
                <div class="flex items-center gap-4">
                  <p class="text-[16px]">{{ $t('upload_video.comment_settings') }}</p>
                  <div v-if="isCommentableErr !== ''" class="text-destructive italic">
                    {{ isCommentableErr }}
                  </div>
                </div>
                <p class="text-[14px] text-lightGray">
                  {{ $t('upload_video.comment_sub') }}
                </p>
                <RadioGroup
                  v-model="isCommentable"
                  default-value="Enable"
                  class="flex items-start gap-4"
                >
                  <div class="flex items-center space-x-2 cursor-pointer">
                    <RadioGroupItem class="w-[20px] h-[20px]" id="r1" value="enabled" />
                    <Label class="text-[15px] cursor-pointer" for="r1">{{
                      $t('upload_video.enabled')
                    }}</Label>
                  </div>
                  <div class="flex items-center space-x-2 cursor-pointer">
                    <RadioGroupItem class="w-[20px] h-[20px]" id="r2" value="disabled" />
                    <Label class="text-[15px] cursor-pointer" for="r2">{{
                      $t('upload_video.disabled')
                    }}</Label>
                  </div>
                </RadioGroup>
              </div>
            </div>
          </Tabs>
        </div>
      </div>
      <DialogFooter
        class="border-2 h-[70px] border-t-[#CCCCCC] !flex !items-center !justify-between w-full"
      >
        <div class="ml-6">
          <UploadVideoProgress :progress="progress" :isSuccess="progress === 100" />
        </div>
        <div v-show="tabChange === 'details'">
          <Button
            @click="firstButton('tags')"
            variant="default"
            class="w-[170px] default mr-6 h-[40px]"
          >
            {{ $t('upload_video.next') }}
          </Button>
        </div>
        <div v-show="tabChange === 'tags'">
          <Button @click="changeTab('details')" class="w-[120px] font-normal" variant="outline">{{
            $t('upload_video.back')
          }}</Button>
          <Button
            v-show="tabChange === 'tags'"
            @click="secondButton('settings')"
            variant="default"
            class="w-[170px] default mr-6 h-[40px]"
          >
            {{ $t('upload_video.next') }}
          </Button>
        </div>
        <div v-show="tabChange === 'settings'" class="flex items-center">
          <Button @click="changeTab('tags')" class="w-[120px] font-normal" variant="outline">{{
            $t('upload_video.back')
          }}</Button>
          <Button
            @click="thirdButton('settings')"
            variant="default"
            class="w-[170px] default mr-6 h-[40px] flex items-center justify-center"
          >
            <span class="font-bold" v-if="!uploadLoading">{{ $t('upload_video.publish') }}</span>
            <Loading v-if="uploadLoading" />
          </Button>
        </div>
      </DialogFooter>
    </DialogContent>
  </Dialog>

  <Dialog v-model:open="isOpenConfirmModal" @update:open="onCloseConfirmModal">
    <DialogContent class="flex flex-col items-start w-[600px] gap-8">
      <p class="text-[24px] font-bold">You have not publish your video</p>
      <p class="text-[16px]">
        {{ $t('upload_video.confirm_text') }}
      </p>
      <div class="w-full flex items-center justify-center">
        <Button
          @click="onBackToDetail"
          variant="outline"
          class="w-[170px] h-[40px] text-[16px] font-medium"
          >{{ $t('upload_video.cancel') }}</Button
        >
        <Button
          @click="onCloseConfirmModal"
          variant="default"
          class="w-[170px] h-[40px] text-[16px]"
          >{{ $t('upload_video.confirm') }}</Button
        >
      </div>
    </DialogContent>
  </Dialog>
</template>
