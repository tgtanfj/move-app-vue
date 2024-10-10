<script setup>
import { Eye, EyeOff } from 'lucide-vue-next'
import { ErrorMessage } from 'vee-validate'
import { ref } from 'vue'

const props = defineProps({
  label: {
    type: [String, Boolean],
    default: false,
    required: false
  },
  inputType: {
    type: String,
    default: 'text'
  },
  name: {
    type: String,
    required: true
  },
  defineField: {
    type: Function,
    required: true
  },
  errors: {
    type: Object,
    required: true
  },
  showError: {
    type: Boolean,
    default: false
  }
})

const showPassword = ref(false)
const [fieldName, fieldNameAttrs] = props.defineField(props.name)

const togglePasswordVisibility = () => {
  showPassword.value = !showPassword.value
}

const emit = defineEmits(['clearErrorAPI'])

const changeInput = () => {
  emit('clearErrorAPI')
}

const handlePasswordInput = (event) => {
  const char = event.key
  if (char === ' ') {
    event.preventDefault();
  }
}
</script>

<template>
  <div class="flex flex-col space-y-1.5 mb-4">
    <label v-if="label" :for="name">{{ label }}</label>
    <div class="relative">
      <input
        v-if="inputType !== 'password'"
        :type="inputType"
        v-model.trim="fieldName"
        v-bind="fieldNameAttrs"
        :id="name"
        @input="changeInput"
        class="text-[16px] mb-1 py-2 px-3 border-darkGray border-[1px] rounded-lg focus:border-primary focus:outline-none w-full"
        :class="showError && errors[name] ? 'border-redMisc' : ''"
        maxlength="255"
      />
      <input
        v-else
        :type="showPassword ? 'text' : 'password'"
        v-model="fieldName"
        v-bind="fieldNameAttrs"
        :id="name"
        class="text-[16px] mb-1 py-2 px-3 border-darkGray border-[1px] rounded-lg focus:border-primary focus:outline-none w-full"
        :class="showError && errors[name] ? 'border-redMisc' : ''"
        maxlength="32"
        @keydown="handlePasswordInput"
      />
      <span
        v-if="inputType === 'password'"
        @click="togglePasswordVisibility"
        class="absolute right-2 top-1/2 transform -translate-y-1/2 opacity-70"
        ><EyeOff v-if="!showPassword" />
        <Eye v-else />
      </span>
    </div>
    <span v-if="showError && errors[name]">
      <ErrorMessage :name="name" class="text-redMisc text-sm italic" />
    </span>
  </div>
</template>
