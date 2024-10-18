<script setup>
import { Dialog, DialogContent, DialogFooter, DialogTrigger, DialogTitle } from '@/common/ui/dialog'
import { Tabs, TabsList } from '@/common/ui/tabs'
import { RadioGroup, RadioGroupItem } from '@/common/ui/radio-group'
import {
  Select,
  SelectContent,
  SelectGroup,
  SelectItem,
  SelectTrigger,
  SelectValue
} from '@/common/ui/select'
import { Textarea } from '@/common/ui/textarea'
import { Input } from '@/common/ui/input'
import { cn } from '@utils/shadcn.util'
import { Pen } from 'lucide-vue-next'
import { ref } from 'vue'
import { DURATIONTYPE, validImageTypes, WORKOUTLEVEL } from '@constants/upload-video.constant'
import Loading from '@components/Loading.vue'
import Button from '@common/ui/button/Button.vue'
import { REGEX_UPLOADVIDE_TEXTAREA } from '@constants/regex.constant'
import axios from 'axios'
import { ADMIN_BASE } from '@constants/api.constant'
import { useVideoStore } from '../../stores/videoManage'
import { useToast } from '../../common/ui/toast'

const props = defineProps({
  videoInfoSelected: {
    type: Number,
    required: true
  }
})

const { toast } = useToast()
const videoStore = useVideoStore()
const videoDataEditing = ref({})
const isOpenUploadVideoDetails = ref(false)
const isEditSuccess = ref(false)

const title = ref('')
const thumbnail = ref('')
const category = ref(null)
const workoutLevel = ref('')
const duration = ref('')
const tags = ref('')
const isCommentable = ref(null)

const categories = ref([])
const images = ref([])
const fileInputThumb = ref(null)
const imagesSelected = ref(null)
const uploadLoading = ref(null)
const imageSelectedFile = ref(null)

const tabChange = ref('details')
const charCount = ref(0)
const charLimit = 500
const charCountTitle = ref(0)
const charLimitTitle = 100

const titleErr = ref('')
const thumbnailErr = ref('')
const categoryErr = ref('')
const workoutLevelErr = ref('')
const durationErr = ref('')
const isCommentableErr = ref('')
const thumbnailTypeValidationErr = ref('')

const nullFirstTab = ref(false)
const nullSecondTab = ref(false)

const getListCategories = async () => {
  try {
    const res = await axios.get(`${ADMIN_BASE}/category`)
    categories.value = res.data.data
  } catch (error) {
    console.log('Error category', error)
  }
}

const capitalizeFirstLetter = (string) => {
  return string.charAt(0).toUpperCase() + string.slice(1)
}

const convertDuration = (duration) => {
  if (duration === 'less than 30 minutes') {
    return '30 mins'
  } else if (duration === 'less than 1 hours') {
    return '< 1 hour'
  } else if (duration === 'more than 1 hours') {
    return '> 1 hour'
  }
  return duration
}

const handleEditVideo = async () => {
  try {
    const res = await axios.get(`${ADMIN_BASE}/video/${props.videoInfoSelected}/details`)
    videoDataEditing.value = res.data.data
    console.log(videoDataEditing.value)

    title.value = videoDataEditing.value.title
    thumbnail.value = videoDataEditing.value.thumbnailURL
    category.value = String(videoDataEditing.value.category.id)
    workoutLevel.value = capitalizeFirstLetter(videoDataEditing.value.workoutLevel)
    duration.value = convertDuration(videoDataEditing.value.duration)
    tags.value = videoDataEditing.value.keywords
    isCommentable.value = String(videoDataEditing.value.isCommentable)
    images.value = [videoDataEditing.value.thumbnailURL]
    imagesSelected.value = videoDataEditing.value.thumbnailURL
    await getListCategories()
  } catch (error) {
    console.log(error)
  }
}

const changeTab = (newTab) => {
  tabChange.value = newTab
}

const handleTitleInput = (inputValue) => {
  title.value = inputValue
  charCountTitle.value = title.value.length
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
  titleErr.value = ''
  thumbnailErr.value = ''
  categoryErr.value = ''
  workoutLevelErr.value = ''
  durationErr.value = ''
  isCommentableErr.value = ''
  uploadLoading.value = null
  nullFirstTab.value = false
  nullSecondTab.value = false
  thumbnailTypeValidationErr.value = ''
}

const handleThumbnailUpload = (event) => {
  if (!validImageTypes.includes(event.target.files[0].type)) {
    reject((thumbnailTypeValidationErr.value = 'File Format, File Size Limit Requirement Not Meet'))
    return
  }

  const files = Array.from(event.target.files)
  const newImages = []

  const promises = files.map((file) => {
    imageSelectedFile.value = file
    return new Promise((resolve) => {
      const imageUrl = URL.createObjectURL(file)
      newImages.push(imageUrl)
      resolve()
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
  if (!isCommentable.value) isCommentableErr.value = 'Please select comment settings'
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
      if (!workoutLevel.value) workoutLevelErr.value = 'Please select a workout level'
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

      const workoutLevelText =
        workoutLevel.value === 'Beginner'
          ? 'beginner'
          : workoutLevel.value === 'Intermediate'
            ? 'intermediate'
            : workoutLevel.value === 'Advanced'
              ? 'advanced'
              : 'unknown'

      const formData = new FormData()
      formData.append('title', title.value)
      formData.append('categoryId', Number(category.value))
      if (imageSelectedFile.value) {
        formData.append('thumbnail', imageSelectedFile.value)
      }
      formData.append('workoutLevel', workoutLevelText)
      formData.append('duration', durationText)
      formData.append('keywords', tags.value)
      formData.append('isCommentable', String(isCommentable.value))

      const response = await videoStore.updateDetailVideo(formData, props.videoInfoSelected)

      if (response) {
        toast({ description: 'Edit successfully', variant: 'successfully' })
        isOpenUploadVideoDetails.value = false
        resetField()
      }
    }
  }
}

const onDialogClose = (isOpen) => {
  if (!isOpen) {
    resetField()
  }

  if (isOpen) {
    images.value.push(videoDataEditing.value.thumbnailURL)
    imagesSelected.value = videoDataEditing.value.thumbnailURL
  }
}
</script>

<template>
  <Dialog v-model:open="isOpenUploadVideoDetails" @update:open="onDialogClose">
    <!-- @update:open="onDialogClose" -->
    <DialogTrigger>
      <Pen size="20" color="#12BDA3" @click="handleEditVideo" />
    </DialogTrigger>

    <DialogContent
      class="m-0 p-0 w-[840px] h-[520px] flex flex-col justify-between overflow-hidden"
    >
      <DialogTitle class="my-6 mx-6">
        <p class="text-[24px] font-bold mb-6">{{ $t('streamer.edit_modal_title') }}</p>
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
                <div class="flex flex-col gap-1 relative">
                  <div class="flex items-center gap-4">
                    <p class="text-[16px]">{{ $t('upload_video.video_title') }}</p>
                    <div v-if="titleErr !== ''" class="text-destructive text-sm italic">
                      {{ titleErr }}
                    </div>
                  </div>
                  <Input
                    v-model="title"
                    @input="(e) => handleTitleInput(e.target.value)"
                    maxlength="100"
                    placeholder="Add a title"
                    class="w-full"
                  />
                  <span
                    class="absolute top-[65px] right-0 ml-auto text-lightGray text-[14px] font-light"
                    :class="{ 'text-red-500': charCountTitle > charLimitTitle }"
                  >
                    {{ charCountTitle }} / {{ charLimitTitle }} characters
                  </span>
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
                        :src="typeof image === 'string' ? image : ''"
                        alt="Thumbnail"
                      />
                      <ImageLoading v-if="images.length <= 0" class="mt-[33px]" />
                    </div>
                  </div>

                  <div
                    v-if="thumbnailErr !== ''"
                    class="absolute top-[19px] left-[147px] text-destructive text-sm italic"
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
                    <div v-if="categoryErr !== ''" class="text-destructive italic text-sm">
                      {{ categoryErr }}
                    </div>
                  </div>
                  <Select v-model="category">
                    <SelectTrigger class="w-[330px] h-[40px] rounded-lg border-primary">
                      <SelectValue placeholder="Select a category" />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectGroup v-if="categories.length > 0">
                        <SelectItem
                          v-for="cate in categories"
                          :key="cate.id"
                          :value="String(cate.id)"
                        >
                          {{ cate.title }}
                        </SelectItem>
                      </SelectGroup>
                    </SelectContent>
                  </Select>
                </div>
                <div class="grid grid-cols-2 gap-4">
                  <div class="flex flex-col gap-3">
                    <div class="flex items-center gap-2">
                      <p class="text-[16px]">{{ $t('upload_video.workout_level') }}</p>
                      <div
                        v-if="workoutLevelErr !== ''"
                        class="text-destructive ml-2 text-sm italic"
                      >
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
                      <div v-if="durationErr !== ''" class="text-destructive text-sm italic">
                        {{ durationErr }}
                      </div>
                    </div>
                    <div class="flex items-center justify-start gap-2">
                      <div
                        v-for="(item, index) in DURATIONTYPE"
                        :key="index"
                        @click="changeDuration(item.title)"
                        class="h-[26px] rounded-full p-2 flex items-center justify-center cursor-pointer"
                        :class="{
                          'bg-primary text-white': item.title === duration,
                          'bg-[#EEEEEE] text-black': item.title !== duration
                        }"
                      >
                        <p class="text-[11px] font-bold">{{ item.title }}</p>
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
                  <div v-if="isCommentableErr !== ''" class="text-destructive text-sm italic">
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
                    <RadioGroupItem class="w-[20px] h-[20px]" id="r1" value="true" />
                    <Label class="text-[15px] cursor-pointer" for="r1">{{
                      $t('upload_video.enabled')
                    }}</Label>
                  </div>
                  <div class="flex items-center space-x-2 cursor-pointer">
                    <RadioGroupItem class="w-[20px] h-[20px]" id="r2" value="false" />
                    <Label class="text-[15px] cursor-pointer" for="r2">{{
                      $t('upload_video.disabled')
                    }}</Label>
                  </div>
                </RadioGroup>
              </div>
            </div>
          </Tabs>
        </div>
      </DialogTitle>
      <DialogFooter
        class="border-2 h-[70px] border-t-[#CCCCCC] !flex !items-center !justify-between w-full"
      >
        <div class="ml-6">
          <!-- <UploadVideoProgress :progress="progress" :isSuccess="progress === 100" /> -->
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
            :disabled="uploadLoading"
            class="w-[170px] default mr-6 h-[40px] flex items-center justify-center"
          >
            <span class="font-bold" v-if="!uploadLoading">{{ $t('streamer.save') }}</span>
            <Loading v-if="uploadLoading" />
          </Button>
        </div>
      </DialogFooter>
    </DialogContent>
  </Dialog>
</template>
