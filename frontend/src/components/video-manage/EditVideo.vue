<template>
  <Dialog v-model:open="isOpenUploadVideoDetails" @update:open="onDialogClose">
    <DialogTrigger>
      <Pen size="20" color="#12BDA3" @click="handleEditVideo" />
    </DialogTrigger>
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
                  <Input
                    v-model="videoDataEdit.title"
                    maxlength="100"
                    placeholder="Add a title"
                    class="w-full"
                  />
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
                  <Select v-model="videoDataEdit.categoryId">
                    <SelectTrigger class="w-[330px] h-[40px] rounded-lg border-primary">
                      <SelectValue placeholder="Select a category" />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectGroup v-if="categories" v-for="cate in categories" :key="cate.id">
                        <SelectItem :value="cate.id">{{ cate.title }}</SelectItem>
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
                          'bg-primary text-white': item.title === videoDataEdit.workoutLevel,
                          'bg-[#EEEEEE] text-black': item.title !== videoDataEdit.workoutLevel
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
                        v-for="(item, index) in DURATIONTYPE"
                        :key="index"
                        @click="changeDuration(item.title)"
                        class="h-[26px] rounded-full p-2 flex items-center justify-center cursor-pointer"
                        :class="{
                          'bg-primary text-white': item.title === videoDataEdit.duration,
                          'bg-[#EEEEEE] text-black': item.title !== videoDataEdit.duration
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
                      v-model="videoDataEdit.keywords"
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
</template>

<script setup>
import { Pen } from 'lucide-vue-next'
import { computed, ref, watch } from 'vue'
import { Dialog, DialogContent, DialogFooter, DialogTrigger } from '@/common/ui/dialog'
import {
  Select,
  SelectContent,
  SelectGroup,
  SelectItem,
  SelectTrigger,
  SelectValue
} from '@/common/ui/select'
import { Label } from '@/common/ui/label'
import { RadioGroup, RadioGroupItem } from '@/common/ui/radio-group'
import { Textarea } from '@/common/ui/textarea'
import { Button } from '@/common/ui/button'
import { Tabs, TabsList } from '@/common/ui/tabs'
import { Input } from '@/common/ui/input'
import Loading from '../Loading.vue'
import ImageLoading from '../ImageLoading.vue'
import VideoIcon from '@assets/icons/videoIcon.vue'
import { cn } from '@utils/shadcn.util'
import { useVideoStore } from '../../stores/videoManage'
import {
  allowedFormats,
  maxFileSize,
  validImageTypes,
  WORKOUTLEVEL,
  DURATIONTYPE
} from '@constants/upload-video.constant'

const props = defineProps({
  videoInfoSelected: {
    type: Object,
    required: true
  }
})

const videoStore = useVideoStore()
const videoDataEdit = ref({})
const isOpenUploadVideoDetails = ref(false)

const uploading = ref(false)
const progress = ref(0)
const error = ref(null)
const images = ref([])
const imagesAfterConvert = ref([])
const selectedIndex = ref(null)
const imagesSelected = ref(null)
const fileInputThumb = ref(null)
const uploadLoading = ref(null)

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

const title = computed(() => videoDataEdit.value.title)
const thumbnail = computed(() => videoDataEdit.value.thumbnail_url)
const category = computed(() => videoDataEdit.value.categoryId)
const workoutLevel = computed(() => videoDataEdit.value.workoutLevel)
const duration = computed(() => videoDataEdit.value.duration)
const keywords = computed(() => videoDataEdit.value.keywords)
const isCommentable = ref(videoDataEdit.value.isCommentable)
const categories = ref([
  {
    id: 1,
    title: 'Gym'
  },
  {
    id: 2,
    title: 'Yoga'
  }
])

watch(
  () => props.videoInfoSelected,
  (newValue) => {
    if (newValue) {
      videoDataEdit.value = { ...newValue }
      isCommentable.value = newValue.isCommentable
    }
  },
  { immediate: true }
)

watch(title, (newValue) => {
  if (newValue) titleErr.value = ''
})

watch(category, (newValue) => {
  if (newValue) categoryErr.value = ''
})

watch(isCommentable, (newValue) => {
  if (newValue) isCommentableErr.value = ''
})

const handleEditVideo = () => {
  videoDataEdit.value = { ...props.videoInfoSelected }
  videoStore.videoId = props.videoInfoSelected.id
}

const resetField = () => {
  title.value = ''
  imagesSelected.value = ''
  keywords.value = ''
  duration.value = ''
  workoutLevel.value = ''
  category.value = ''
  isCommentable.value = videoDataEdit.value.isCommentable
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
}

const onDialogClose = (isOpen) => {
  if (!isOpen) {
    resetField()
  }
  if (isOpen) {
    images.value.push(videoDataEdit.value.thumbnail_url)
    imagesSelected.value = videoDataEdit.value.thumbnail_url
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
  keywords.value = validInput
  charCount.value = keywords.value.length
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
  videoDataEdit.value.workoutLevel = level
}

const changeDuration = (value) => {
  durationErr.value = ''
  videoDataEdit.value.duration = value
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

      const jsonData = {
        title: title.value,
        categoryId: category.value,
        // thumbnail: imagesSelected.value,
        workoutLevel: workoutLevel.value.toLowerCase(), // lowercase cho workoutLevel
        duration: durationText,
        isCommentable: isCommentable.value === 'true' ? true : false,
        keywords: keywords.value
      }
      
      const response = await videoStore.updateDetailVideo(jsonData)

      if (response && response.statusCode === 200) {
        isOpenUploadVideoDetails.value = false
      }
    }
  }
}
</script>
