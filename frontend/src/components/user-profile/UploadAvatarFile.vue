<script setup>
import { t } from '@helpers/i18n.helper'
import { ref } from 'vue'

const props = defineProps({
  accept: {
    type: Array,
    required: false,
    default: ['.jpeg', '.png', '.gif']
  },
  buttonText: {
    required: true,
    type: String,
    default: 'Upload File'
  },
  hideInput: {
    type: Boolean,
    default: true
  }
})

const emit = defineEmits(['file-selected', 'error-message'])
const fileInput = ref(null)

const handleFileChange = (event) => {
  const file = event.target.files[0]
  if (!file) return

  if (props.accept.includes(file.type)) {
    emit('error-message', t('user_profile.file_format_not_meet'))
    return
  }
  if (file.size > 5 * 1024 * 1024) {
    emit('error-message', t('user_profile.file_exceed_5MB'))
    return
  }

  const img = new Image()
  const reader = new FileReader()
  reader.onload = (e) => {
    img.src = e.target.result
    img.onload = () => {
      // Check image dimensions
      if (img.width < 100 || img.height < 100 || img.width > 2000 || img.height > 2000) {
        emit(
          'error-message',
          'Image Dimensions: Minimum dimensions are 100x100 pixels, and maximum are 2000x2000 pixels.'
        )
        return
      }
      emit('file-selected', file, e.target.result)
    }
  }

  reader.readAsDataURL(file)
}

const triggerFileInput = () => {
  fileInput.value.click()
}
</script>

<template>
  <div>
    <p @click="triggerFileInput" id="updateProfilePic" class="text-primary cursor-pointer">
      {{ buttonText }}
    </p>
    <input
      type="file"
      :accept="accept"
      ref="fileInput"
      @change="handleFileChange"
      :class="{ hidden: hideInput }"
    />
  </div>
</template>
