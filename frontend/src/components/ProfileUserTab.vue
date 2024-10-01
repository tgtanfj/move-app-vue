<script setup>
import { ref, watch, watchEffect } from 'vue'
import { useForm } from 'vee-validate'

import { countriesService } from '@services/countries.services'
import { userProfileService } from '@services/userProflie.services'

import { DAYS, MONTHS, YEARS } from '@constants/date.constant'
import { userBaseAvatar } from '@constants/userImg.constant'

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
import { Button } from '@/common/ui/button'
import { FormControl, FormField, FormItem, FormLabel, FormMessage } from '@/common/ui/form'

import BaseDialog from './BaseDialog.vue'
import ChangePasswordModal from './ChangePasswordModal.vue'
import OTPVerificationModal from './OTPVerificationModal.vue'
import SetupEmailModal from './SetupEmailModal.vue'

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
const openSetupEmailModal = ref(false)
const openOTPVerificationModal = ref(false)
const openChangePasswordModal = ref(false)
const openChangePasswordResultModal = ref(false)

const { handleSubmit, values, setValues, errors, meta } = useForm({
  initialValues: {
    avatar: '',
    username: '',
    email: '',
    fullName: '',
    gender: '',
    birthday: ''
  }
})

const {
  data: initUserData,
  isLoading: initUserLoading,
  isSuccess: initUserIsSuccess
} = userProfileService.getUserProfile()

watch(initUserData, (newValue) => {
  if (initUserIsSuccess && newValue) {
    userData.value = newValue.data
  }
})

watch(userData, (newValue) => {
  if (newValue) {
    selectedCountry.value = newValue.country || ''
    selectedState.value = newValue.state || ''
    selectedCity.value = newValue.city || ''
    if (newValue.dateOfBirth) {
      const [year, month, day] = newValue.dateOfBirth.split('-')
      selectedDay.value = day || null
      selectedMonth.value = month || null
      selectedYear.value = year || null
    }
    setValues({
      avatar: newValue.avatar || '',
      username: newValue.username || '',
      email: newValue.email || '',
      fullName: newValue.fullName || '',
      gender: newValue.gender || ''
    })
  }
})

const { data } = countriesService.getAllCountries()

watchEffect(() => {
  if (data.value) {
    countries.value = data.value.data
  }
})

const {
  data: statesData,
  isLoading: statesLoading,
  isError: iErrorStates,
  isSuccess: statesIsSuccess
} = countriesService.getAllStates(selectedCountry)

watchEffect(() => {
  if (statesData.value) {
    states.value = statesData.value.data.states
  }
})

const {
  data: citiesData,
  isLoading: citiesLoading,
  isError: iErrorCities,
  isSuccess: citiesIsSuccess
} = countriesService.getAllCities(selectedCountry, selectedState)

watchEffect(() => {
  if (citiesData.value) {
    cities.value = citiesData.value.data
  }
})

const handleSetupEmail = () => {
  openSetupEmailModal.value = false
  openOTPVerificationModal.value = true
}

const onCountryChange = (value) => {
  selectedCountry.value = value
  selectedState.value = ''
  selectedCity.value = ''
}

const onStateChange = (value) => {
  selectedState.value = value
}

const onCityChange = (value) => {
  selectedCity.value = value
}

const openChangePasswordResult = (result) => {
  openChangePasswordResultModal.value = true
  openChangePasswordModal.value = false
}

const onSubmit = handleSubmit((values) => {
  values.birthday = `${selectedYear.value}-${selectedMonth.value}-${selectedDay.value}`
  console.log('Submitting...', values)
})
</script>

<template>
  <form class="" @submit.prevent="onSubmit">
    <div class="flex flex-col gap-3">
      <p>{{ $t('user_profile.profile_pic') }}</p>
      <img
        class="w-[56px] h-[56px] rounded-full"
        :src="values.avatar ? values.avatar : userBaseAvatar"
        v-bind="componentField"
        alt=""
      />
      <p class="text-primary">{{ $t('user_profile.update_profile_pic') }}</p>
    </div>
    <div class="flex flex-col gap-4 mb-2 w-[80%] mt-6">
      <div class="flex flex-col gap-1">
        <FormField v-slot="{ componentField }" name="username">
          <FormItem>
            <FormLabel>{{ $t('user_profile.username') }}</FormLabel>
            <FormControl>
              <Input
                class="px-3 py-2 border-[1px] h-[40px] focus:border-[#13D0B4] outline-none rounded-lg border-[#CCCCCC]"
                type="text"
                placeholder="Username"
                v-model="values.username"
                v-bind="componentField"
              />
            </FormControl>
            <FormMessage />
          </FormItem>
        </FormField>
      </div>

      <div class="flex flex-col gap-1">
        <FormField v-slot="{ componentField }" name="email">
          <FormItem>
            <FormLabel>{{ $t('user_profile.email') }}</FormLabel>
            <FormControl>
              <div class="relative">
                <Input
                  disabled
                  class="placeholder:italic h-[40px] px-3 py-2 border-[1px] focus:border-[#13D0B4] outline-none rounded-lg border-[#CCCCCC]"
                  type="text"
                  placeholder="No email found"
                  v-model="values.email"
                  v-bind="componentField"
                />
              </div>
            </FormControl>
            <FormMessage />
          </FormItem>
        </FormField>
      </div>

      <div class="flex flex-col gap-1">
        <FormField v-slot="{ componentField }" name="fullName">
          <FormItem>
            <FormLabel>{{ $t('user_profile.fullname') }}</FormLabel>
            <FormControl>
              <Input
                class="px-3 py-2 border-[1px] h-[40px] focus:border-[#13D0B4] outline-none rounded-lg border-[#CCCCCC]"
                type="text"
                placeholder="Full name"
                v-model="values.fullName"
                v-bind="componentField"
              />
            </FormControl>
            <FormMessage />
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
            <FormLabel>{{ $t('user_profile.gender') }}</FormLabel>

            <FormControl>
              <RadioGroup class="flex space-x-3" v-model="values.gender" v-bind="componentField">
                <FormItem class="flex items-center space-y-0 gap-x-2">
                  <FormControl>
                    <RadioGroupItem class="w-[20px] h-[20px]" value="male" />
                  </FormControl>
                  <FormLabel class="font-normal"> {{ $t('user_profile.male') }} </FormLabel>
                </FormItem>
                <FormItem class="flex items-center space-y-0 gap-x-2">
                  <FormControl>
                    <RadioGroupItem class="w-[20px] h-[20px]" value="female" />
                  </FormControl>
                  <FormLabel class="font-normal"> {{ $t('user_profile.female') }} </FormLabel>
                </FormItem>
                <FormItem class="flex items-center space-y-0 gap-x-2">
                  <FormControl>
                    <RadioGroupItem class="w-[20px] h-[20px]" value="none" />
                  </FormControl>
                  <FormLabel class="font-normal">
                    {{ $t('user_profile.rather_not_say') }}
                  </FormLabel>
                </FormItem>
              </RadioGroup>
            </FormControl>
            <FormMessage />
          </FormItem>
        </FormField>
      </div>

      <div class="flex flex-col gap-1">
        <label>{{ $t('user_profile.birth') }}</label>
        <div class="flex items-center justify-start gap-2">
          <Select v-model="selectedDay">
            <SelectTrigger class="w-[74px] h-[40px] rounded-lg border-[#cccccc]">
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
                <SelectItem class="pl-2" :value="item.num.toString()">{{ item.text }}</SelectItem>
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
        </div>
      </div>

      <div class="grid grid-cols-2 gap-3">
        <div class="flex flex-col gap-1 w-full">
          <FormField v-slot="{ componentField }" name="country">
            <FormItem>
              <FormLabel>{{ $t('user_profile.country') }}</FormLabel>

              <Select v-bind="componentField" v-model="selectedCountry" @change="onCountryChange">
                <FormControl>
                  <SelectTrigger>
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
              <FormMessage />
            </FormItem>
          </FormField>
        </div>
        <div class="flex flex-col gap-1 w-full">
          <FormField v-slot="{ componentField }" name="state">
            <FormItem>
              <FormLabel>{{ $t('user_profile.state') }}</FormLabel>

              <Select v-bind="componentField" v-model="selectedState" @change="onStateChange">
                <FormControl>
                  <SelectTrigger>
                    <SelectValue placeholder="Select state" />
                  </SelectTrigger>
                </FormControl>
                <SelectContent>
                  <SelectGroup>
                    <SelectItem
                      v-if="statesData"
                      v-for="(state, index) in states"
                      :key="index"
                      :value="state.name"
                    >
                      {{ state.name }}
                    </SelectItem>
                    <p
                      disabled
                      v-if="!statesData && !statesLoading"
                      class="text-lightGray font-[14px] italic"
                    >
                      Please select country first
                    </p>
                    <p disabled v-if="statesLoading" class="text-lightGray font-[14px] italic">
                      Loading...
                    </p>
                    <p
                      disabled
                      v-if="statesIsSuccess && (!states || states.length === 0)"
                      class="text-lightGray font-[14px] italic"
                    >
                      No states found
                    </p>
                  </SelectGroup>
                </SelectContent>
              </Select>
              <FormMessage />
            </FormItem>
          </FormField>
        </div>
      </div>

      <div class="grid grid-cols-2 gap-3">
        <div class="flex flex-col gap-1 w-full">
          <FormField v-slot="{ componentField }" name="city">
            <FormItem>
              <FormLabel>{{ $t('user_profile.city') }}</FormLabel>

              <Select v-bind="componentField" v-model="selectedCity" @change="onCityChange">
                <FormControl>
                  <SelectTrigger>
                    <SelectValue placeholder="Select city" />
                  </SelectTrigger>
                </FormControl>
                <SelectContent>
                  <SelectGroup>
                    <SelectItem
                      v-if="citiesData"
                      v-for="(city, index) in cities"
                      :key="index"
                      :value="city"
                    >
                      {{ city }}
                    </SelectItem>
                    <p
                      disabled
                      v-if="!statesData && !citiesLoading"
                      class="text-lightGray font-[14px] italic"
                    >
                      Please select state first
                    </p>
                    <p disabled v-if="citiesLoading" class="text-lightGray font-[14px] italic">
                      Loading...
                    </p>
                    <p
                      disabled
                      v-if="citiesIsSuccess && (!cities || cities.length === 0)"
                      class="text-lightGray font-[14px] italic"
                    >
                      No cities found
                    </p>
                  </SelectGroup>
                </SelectContent>
              </Select>
              <FormMessage />
            </FormItem>
          </FormField>
        </div>
        <div class="flex flex-col gap-1 w-full"></div>
      </div>

      <Button type="submit" class="w-[230px] mt-6">{{ $t('user_profile.save') }}</Button>
    </div>
  </form>

  <SetupEmailModal
    v-model:open="openSetupEmailModal"
    @close-setup-email-modal="openSetupEmailModal = false"
    @handle-submit-form="handleSetupEmail"
  />

  <OTPVerificationModal
    v-model:open="openOTPVerificationModal"
    @close-modal="openOTPVerificationModal = false"
  />

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
</template>
