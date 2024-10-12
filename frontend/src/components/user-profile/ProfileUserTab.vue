<script setup>
import { useToast } from '@common/ui/toast/use-toast'
import { userBaseAvatar } from '@constants/userImg.constant'
import { useForm } from 'vee-validate'
import { onMounted, ref, watch } from 'vue'
import { userProfileSchema } from '../../validation/schema'

import { ADMIN_BASE, COUNTRY_BASE } from '@constants/api.constant'
import { DAYS, MONTHS, YEARS } from '@constants/date.constant'

import { Button } from '@/common/ui/button'
import { FormControl, FormField, FormItem, FormLabel, FormMessage } from '@/common/ui/form'
import { Input } from '@/common/ui/input'
import { RadioGroup, RadioGroupItem } from '@/common/ui/radio-group'
import {
  Select,
  SelectContent,
  SelectGroup,
  SelectItem,
  SelectTrigger,
  SelectValue
} from '@/common/ui/select'
import { denormalizeGender, normalizeGender } from '@utils/userProfile.util'
import axios from 'axios'
import BaseDialog from '../BaseDialog.vue'
import Loading from '../Loading.vue'
import ChangePasswordModal from './ChangePasswordModal.vue'
import UploadAvatarFile from './UploadAvatarFile.vue'

const selectedDay = ref(null)
const selectedMonth = ref(null)
const selectedYear = ref(null)
const countries = ref([])
const states = ref([])
const cities = ref([])
const selectedCountry = ref('')
const selectedState = ref('')
const selectedCity = ref('')
const userData = ref(null)
const openOTPVerificationModal = ref(false)
const openChangePasswordModal = ref(false)
const openChangePasswordResultModal = ref(false)
const fileInput = ref(null)
const fileInfo = ref(null)
const avatar = ref(null)
const message = ref('')
const isLoading = ref(false)
const isSubmitting = ref(false)
const showError = ref(false)
const firstSubmittion = ref(true)
const gender = ref('')

const { toast } = useToast()
const { values, setValues, errors } = useForm({
  initialValues: {
    avatar: null,
    username: '',
    email: '',
    fullName: '',
    gender: '',
    dateOfBirth: '',
    country: '',
    state: '',
    city: ''
  },
  validationSchema: userProfileSchema,
  validateOnMount: false
})

onMounted(async () => {
  try {
    isLoading.value = true
    const token = localStorage.getItem('token')
    const config = {
      headers: {
        Authorization: `Bearer ${token}`
      }
    }
    const response = await axios.get(`${ADMIN_BASE}/user/profile`, config)
    if (response.status === 200 && response.data) {
      userData.value = { ...response.data.data }
      setValues({
        ...response.data.data,
        gender: denormalizeGender(response.data.data.gender),
        state: response.data.data.state?.name || ''
      })
      const [year, month, day] = response.data.data.dateOfBirth.split('-')
      selectedDay.value = day || null
      selectedMonth.value = month || null
      selectedYear.value = year || null

      gender.value = denormalizeGender(response.data.data.gender)
      selectedCountry.value = response.data.data.country?.name || ''
      selectedState.value = response.data.data.state?.name || ''
      selectedCity.value = response.data.data.city || ''
    } else throw new Error(response.error)
  } catch (err) {
    console.log(err)
  } finally {
    isLoading.value = false
  }
})

onMounted(async () => {
  try {
    const res = await axios.get(`${ADMIN_BASE}/countries`)
    if (res.status === 200) {
      countries.value = res.data.data
    } else throw new Error(res.error)
  } catch (error) {
    console.log(error.message)
  }
})

watch(gender, (newValue) => {
  setValues({
    ...values,
    gender: newValue
  })
})

watch(selectedCountry, async (newValue) => {
  if (countries.value.length > 0) {
    const temp = countries?.value.filter((item) => item.name === newValue)
    if (temp[0].name) setValues({ ...values, country: temp[0].name })
    try {
      const res = await axios.get(`${ADMIN_BASE}/countries/${temp[0].id}/states`)
      if (res.status === 200) {
        states.value = res.data.data
      } else throw new Error(res.error)
    } catch (error) {
      console.log(error.message)
    }
  }
})

watch(selectedState, async (newValue) => {
  if (states.value.length > 0) {
    const temp = states?.value.filter((item) => item.name === newValue)

    if (temp[0].name) setValues({ ...values, state: temp[0].name })

    if (temp.length > 0) userData.value = { ...userData.value, citi: temp[0] }
    try {
      const res = await axios.get(`${COUNTRY_BASE}/countries/state/cities/q`, {
        params: {
          country: selectedCountry.value,
          state: newValue
        }
      })
      if (res.status === 200) {
        cities.value = res.data.data
      } else throw new Error(res.error)
    } catch (error) {
      console.log(error.message)
    }
  }
})
watch(selectedCity, (newValue) => {
  setValues({ ...values, city: newValue })
})

watch([selectedDay, selectedMonth, selectedYear], () => {
  if (selectedDay.value && selectedMonth.value && selectedYear.value) {
    setValues({
      ...values,
      dateOfBirth: `${selectedYear.value}-${selectedMonth.value}-${selectedDay.value}`
    })
  }
})

const onCountryChange = (value) => {
  console.log(value)
}

const onStateChange = (value) => {
  selectedState.value = value
}

const onCityChange = (value) => {
  selectedCity.value = value
}

const openChangePasswordResult = () => {
  openChangePasswordResultModal.value = true
  openChangePasswordModal.value = false
}

const isFormDataEmpty = (formData) => {
  return formData.entries().next().done
}

function hasEmptyProperty(obj) {
  for (let key in obj) {
    if (obj.hasOwnProperty(key)) {
      if (key === 'city') {
        continue
      }

      const value = obj[key]
      if (value === undefined || value === null || value === '') {
        return true
      }
    }
  }
  return false
}

const onSubmit = async () => {
  console.log(values, userData.value)

  if (Object.keys(errors.value).length > 0) {
    showError.value = true
  } else {
    isSubmitting.value = true
    const token = localStorage.getItem('token')
    const config = {
      headers: {
        Authorization: `Bearer ${token}`,
        'Content-Type': 'multipart/form-data'
      }
    }
    const formData = new FormData()

    if (userData.value.username !== values.username) formData.append('username', values.username)
    if (fileInfo.value) formData.append('avatar', fileInfo.value)
    if (values.fullName !== userData.value.fullName) formData.append('fullName', values.fullName)
    if (values.dateOfBirth !== userData.value.dateOfBirth)
      formData.append('dateOfBirth', values.dateOfBirth)
    if (normalizeGender(values.gender) !== userData.value.gender)
      formData.append('gender', normalizeGender(values.gender))
    if (
      (values.country && !userData.value.country) ||
      values.country !== userData.value.country?.name
    ) {
      const countryId = countries.value.filter((item) => item.name === values.country)[0].id
      formData.append('countryId', countryId)
    }
    if ((values.state && !userData.value.state) || values.state !== userData.value.state?.name) {
      const stateId = states.value.filter((item) => item.name === values.state)[0].id
      formData.append('stateId', stateId)
    }
    if (values.city !== userData.value.city) formData.append('city', values.city || '')

    if (isFormDataEmpty(formData)) {
      console.log('empty')

      isSubmitting.value = false
      return
    } else {
      try {
        const response = await axios.patch(`${ADMIN_BASE}/user/edit-profile`, formData, config)

        if (response.status === 200) {
          userData.value = {
            ...values,
            country: {
              id: countries.value.filter((item) => item.name === values.country)[0].id,
              name: values.country
            },
            state: {
              id: states.value.filter((item) => item.name === values.state)[0].id,
              name: values.state
            },
            city: values.city,
            gender: normalizeGender(values.gender)
          }
          toast({ description: 'Editted Profile Successfully', variant: 'successfully' })
        } else throw new Error(response.error)
      } catch (err) {
        toast({ description: err.message, variant: 'destructive' })
      } finally {
        isSubmitting.value = false
        showError.value = false
      }
    }
  }
}
const onGenderChange = (value) => {
  gender.value = value
}

const onFileSelected = (file, imagePreview) => {
  if (!file) return
  else {
    avatar.value = imagePreview
    fileInfo.value = file
    setValues({ ...values, avatar: file }, { shouldValidate: false })
  }
}

const onErrorMessage = (msg) => {
  message.value = msg
}
</script>

<template>
  <div>
    <div v-if="isLoading" class="mt-56 flex justify-center items-center">
      <Loading />
    </div>
    <form class="" @submit.prevent="onSubmit" v-else>
      <div class="flex flex-col gap-3">
        <FormField v-slot="componentField" name="avatar">
          <FormItem>
            <p>{{ $t('user_profile.profile_pic') }}</p>
            <img
              class="w-[56px] h-[56px] rounded-full"
              :src="avatar ? avatar : values.avatar ? values.avatar : userBaseAvatar"
              v-bind="componentField"
              alt=""
            />
            <p class="text-red-500 text-sm" v-if="message">{{ message }}</p>
            <UploadAvatarFile
              :buttonText="$t('user_profile.update_profile_pic')"
              @file-selected="onFileSelected"
              @error-message="onErrorMessage"
            />
          </FormItem>
          <FormMessage :class="{ hidden: !showError }" />
        </FormField>
      </div>
      <div class="flex flex-col gap-4 mb-2 w-[80%] mt-6">
        <div class="flex flex-col gap-1">
          <FormField v-slot="{ componentField }" name="username">
            <FormItem>
              <FormLabel :class="{ 'text-black': !showError && errors.username }">
                Username
              </FormLabel>
              <FormControl>
                <Input
                  class="px-3 py-2 border-[1px] h-[40px] focus:border-[#13D0B4] outline-none rounded-lg border-[#CCCCCC]"
                  :class="{ 'border-red-500': showError && errors.username }"
                  type="text"
                  placeholder="Username"
                  v-bind="componentField"
                />
              </FormControl>
              <FormMessage :class="{ hidden: !showError }" />
            </FormItem>
          </FormField>
        </div>
        <div class="flex flex-col gap-1">
          <FormField v-slot="{ componentField }" name="email">
            <FormItem>
              <FormLabel>Email</FormLabel>
              <FormControl>
                <div class="relative">
                  <Input
                    disabled
                    class="placeholder:italic h-[40px] px-3 py-2 border-[1px] focus:border-[#13D0B4] outline-none rounded-lg border-[#CCCCCC]"
                    type="text"
                    placeholder="No email found"
                    v-bind="componentField"
                  />
                </div>
              </FormControl>
              <FormMessage :class="{ hidden: !showError }" />
            </FormItem>
          </FormField>
        </div>
        <div class="flex flex-col gap-1">
          <FormField v-slot="{ componentField }" name="fullName">
            <FormItem>
              <FormLabel :class="{ 'text-black': !showError && errors.fullName }">
                Full Name
              </FormLabel>
              <FormControl>
                <Input
                  class="px-3 py-2 border-[1px] h-[40px] focus:border-[#13D0B4] outline-none rounded-lg border-[#CCCCCC]"
                  :class="{ 'border-red-500': showError && errors.fullName }"
                  type="text"
                  placeholder="Full name"
                  v-bind="componentField"
                />
              </FormControl>
              <FormMessage :class="{ hidden: !showError }" />
            </FormItem>
          </FormField>
        </div>

        <div class="flex flex-col gap-1">
          <label>{{ $t('user_profile.password') }}</label>
          <p class="text-primary underline cursor-pointer" @click="openChangePasswordModal = true">
            {{ $t('change_password.title') }}
          </p>
        </div>

        <div class="flex flex-col gap-1">
          <FormField v-slot="{ componentField }" type="radio" name="gender">
            <FormItem class="space-y-2">
              <FormLabel :class="{ 'text-black': !showError && errors.gender }"> Gender </FormLabel>
              <FormControl>
                <RadioGroup
                  class="flex space-x-3"
                  v-bind="componentField"
                  v-model="gender"
                  @change="onGenderChange"
                >
                  <FormItem class="flex items-center space-y-0 gap-x-2">
                    <FormControl>
                      <RadioGroupItem
                        class="w-[20px] h-[20px]"
                        value="male"
                        :checked="gender === 'male'"
                      />
                    </FormControl>
                    <FormLabel class="font-normal"> Male </FormLabel>
                  </FormItem>
                  <FormItem class="flex items-center space-y-0 gap-x-2">
                    <FormControl>
                      <RadioGroupItem
                        class="w-[20px] h-[20px]"
                        value="female"
                        :checked="gender === 'female'"
                      />
                    </FormControl>
                    <FormLabel class="font-normal"> Female </FormLabel>
                  </FormItem>
                  <FormItem class="flex items-center space-y-0 gap-x-2">
                    <FormControl>
                      <RadioGroupItem
                        class="w-[20px] h-[20px]"
                        value="rather not say"
                        :checked="gender === 'rather not say'"
                      />
                    </FormControl>
                    <FormLabel class="font-normal"> Rather not say </FormLabel>
                  </FormItem>
                </RadioGroup>
              </FormControl>
              <FormMessage :class="{ hidden: !showError }" />
            </FormItem>
          </FormField>
        </div>
        <div class="flex flex-col gap-1">
          <label>Date of birth</label>
          <FormField v-slot="{ componentField }" name="dateOfBirth">
            <FormItem class="flex items-center justify-start gap-2">
              <Select v-model="selectedDay">
                <SelectTrigger class="w-[74px] h-[40px] mt-2 rounded-lg border-[#cccccc]">
                  <SelectValue placeholder="Day" />
                </SelectTrigger>
                <SelectContent>
                  <SelectGroup v-for="item in DAYS" :key="item">
                    <SelectItem class="pl-2" :value="item.toString()">{{ item }}</SelectItem>
                  </SelectGroup>
                </SelectContent>
              </Select>
              <Select v-model="selectedMonth">
                <SelectTrigger class="w-[74px] h-[40px] rounded-lg border-[#cccccc]">
                  <SelectValue placeholder="Month" />
                </SelectTrigger>
                <SelectContent>
                  <SelectGroup v-for="item in MONTHS" :key="item">
                    <SelectItem class="pl-2" :value="item.num.toString()">{{
                      item.text
                    }}</SelectItem>
                  </SelectGroup>
                </SelectContent>
              </Select>
              <Select v-model="selectedYear">
                <SelectTrigger class="w-[90px] h-[40px] rounded-lg border-[#cccccc]">
                  <SelectValue placeholder="Year" />
                </SelectTrigger>
                <SelectContent>
                  <SelectGroup v-for="item in YEARS" :key="item">
                    <SelectItem class="pl-2" :value="item.toString()">{{ item }}</SelectItem>
                  </SelectGroup>
                </SelectContent>
              </Select>
            </FormItem>
            <FormMessage class="mt-2" :class="{ hidden: !showError }" />
          </FormField>
        </div>
        <div class="grid grid-cols-2 gap-3">
          <div class="flex flex-col gap-1 w-full">
            <FormField v-slot="{ componentField }" name="country">
              <FormItem>
                <FormLabel :class="{ 'text-black': !showError && errors.country }">
                  Country
                </FormLabel>
                <Select v-bind="componentField" v-model="selectedCountry" @change="onCountryChange">
                  <FormControl>
                    <SelectTrigger :class="{ 'border-red-500': showError && errors.country }">
                      <SelectValue placeholder="Select country" />
                    </SelectTrigger>
                  </FormControl>
                  <SelectContent>
                    <SelectGroup>
                      <SelectItem
                        v-for="(country, index) in countries"
                        :key="index"
                        :value="country.name"
                      >
                        {{ country.name }}
                      </SelectItem>
                    </SelectGroup>
                  </SelectContent>
                </Select>
                <FormMessage :class="{ hidden: !showError }" />
              </FormItem>
            </FormField>
          </div>
          <div class="flex flex-col gap-1 w-full">
            <FormField v-slot="{ componentField }" name="state">
              <FormItem>
                <FormLabel :class="{ 'text-black': !showError && errors.state }"> State </FormLabel>
                <Select v-bind="componentField" v-model="selectedState" @change="onStateChange">
                  <FormControl>
                    <SelectTrigger :class="{ 'border-red-500': showError && errors.state }">
                      <SelectValue placeholder="Select state" />
                    </SelectTrigger>
                  </FormControl>
                  <SelectContent>
                    <SelectGroup v-if="!states">
                      <SelectItem> Loading </SelectItem>
                    </SelectGroup>
                    <SelectGroup v-else>
                      <SelectItem v-for="(state, index) in states" :key="index" :value="state.name">
                        {{ state.name }}
                      </SelectItem>
                    </SelectGroup>
                  </SelectContent>
                </Select>
                <FormMessage :class="{ hidden: !showError }" />
              </FormItem>
            </FormField>
          </div>
        </div>
        <div class="grid grid-cols-2 gap-3">
          <div class="flex flex-col gap-1 w-full">
            <FormField v-slot="{ componentField }" name="city">
              <FormItem>
                <FormLabel>City</FormLabel>
                <Select v-bind="componentField" v-model="selectedCity" @change="onCityChange">
                  <FormControl>
                    <SelectTrigger>
                      <SelectValue :placeholder="selectedCity || 'Select city'" />
                    </SelectTrigger>
                  </FormControl>
                  <SelectContent>
                    <SelectGroup v-if="!cities">
                      <SelectItem> Loading </SelectItem>
                    </SelectGroup>
                    <SelectGroup v-else>
                      <SelectItem v-for="city in states" :key="city.id" :value="city.name">
                        {{ city.name }}
                      </SelectItem>
                    </SelectGroup>
                  </SelectContent>
                </Select>
                <FormMessage :class="{ hidden: !showError }" />
              </FormItem>
            </FormField>
          </div>
          <div class="flex flex-col gap-1 w-full"></div>
        </div>
        <Button type="submit" class="w-[230px] mt-6" :disabled="hasEmptyProperty(values)">
          <template v-if="isSubmitting">
            <Loading />
          </template>
          <template v-else>
            {{ $t('user_profile.save') }}
          </template>
        </Button>
      </div>
    </form>

    <ChangePasswordModal
      v-model:open="openChangePasswordModal"
      @open-change-password-result="openChangePasswordResult"
    />
    <BaseDialog
      v-model:open="openChangePasswordResultModal"
      :title="$t('change_password.title')"
      :description="$t('change_password.success_desc')"
    >
      <div class="flex justify-center">
        <Button class="w-[60%]" @click="openChangePasswordResultModal = false">{{
          $t('button.ok')
        }}</Button>
      </div>
    </BaseDialog>
  </div>
</template>
