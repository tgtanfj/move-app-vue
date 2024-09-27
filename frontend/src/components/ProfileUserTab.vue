<script setup>
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
import { countriesService } from '@services/countries.services'
import { useForm } from 'vee-validate'
import { ref, watch, watchEffect } from 'vue'

import { DAYS, MONTHS, YEARS } from '@constants/date.constant'

import { Button } from '@/common/ui/button'
import { FormControl, FormField, FormItem, FormLabel, FormMessage } from '@/common/ui/form'
import { userProfileSchema } from '../validation/schema'
import BaseDialog from './BaseDialog.vue'
import ChangePasswordModal from './ChangePasswordModal.vue'
import OTPVerificationModal from './OTPVerificationModal.vue'
import SetupEmailModal from './SetupEmailModal.vue'

const selectedDay = ref(null)
const selectedMonth = ref(null)
const selectedYear = ref(null)
const countries = ref([])
const states = ref([])
const selectedCountry = ref('')
const openSetupEmailModal = ref(false)
const openOTPVerificationModal = ref(false)
//change password modal
const openChangePasswordModal = ref(false)
const openChangePasswordResultModal = ref(false)

const { handleSubmit, values, resetForm, errors, meta } = useForm({
  validationSchema: userProfileSchema
})

const { data, isLoading, isError, error } = countriesService.getAllCountries()

watchEffect(() => {
  if (data.value) {
    countries.value = data.value.data
  }
})

const handleSetupEmail = () => {
  openSetupEmailModal.value = false
  openOTPVerificationModal.value = true
}

const onCountryChange = (value) => {
  selectedCountry.value = value
}

const fetchStates = async () => {
  if (selectedCountry.value) {
    try {
      const getStates = countriesService.getStatesByCountry(selectedCountry.value)
      states.value = await getStates()
    } catch (error) {
      console.error('Error fetching states:', error)
    } finally {
    }
  } else {
    states.value = []
  }
}

watch(selectedCountry, (newValue) => {
  fetchStates()
})

const onSubmit = handleSubmit((values) => {
  values.birthday = `${selectedDay.value}/${selectedMonth.value}/${selectedYear.value}`
  console.log('Submitting...', values)
})

const openChangePasswordResult = (result) => {
  openChangePasswordResultModal.value = true
  openChangePasswordModal.value = false
}
</script>

<template>
  <form class="" @submit.prevent="onSubmit">
    <div class="flex flex-col gap-3">
      <p>Profile picture</p>
      <img
        class="w-[56px] h-[56px] rounded-full"
        src="https://media.licdn.com/dms/image/v2/C510BAQGn8u7nx8_uhA/company-logo_200_200/company-logo_200_200/0/1630609991396?e=1735171200&v=beta&t=uG5ILNmyQgyALO5fyKusbAmOTdm6WfU6My52QeKQyqE"
        alt=""
      />
      <p class="text-primary">Update profile picture</p>
    </div>
    <div class="flex flex-col gap-4 mb-2 w-[80%] mt-6">
      <div class="flex flex-col gap-1">
        <FormField v-slot="{ componentField }" name="username">
          <FormItem>
            <FormLabel>Username</FormLabel>
            <FormControl>
              <Input
                class="px-3 py-2 border-[1px] h-[40px] focus:border-[#13D0B4] outline-none rounded-lg border-[#CCCCCC]"
                type="text"
                placeholder="Username"
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
                <p
                  @click="openSetupEmailModal = true"
                  class="absolute top-3 right-8 text-primary cursor-pointer"
                >
                  Setup email
                </p>
              </div>
            </FormControl>
            <FormMessage />
          </FormItem>
        </FormField>
      </div>

      <div class="flex flex-col gap-1">
        <FormField v-slot="{ componentField }" name="fullName">
          <FormItem>
            <FormLabel>Full Name</FormLabel>
            <FormControl>
              <Input
                class="px-3 py-2 border-[1px] h-[40px] focus:border-[#13D0B4] outline-none rounded-lg border-[#CCCCCC]"
                type="text"
                placeholder="Full name"
                v-bind="componentField"
              />
            </FormControl>
            <FormMessage />
          </FormItem>
        </FormField>
      </div>

      <div class="flex flex-col gap-1">
        <label>Password</label>
        <p class="text-primary underline cursor-pointer" @click="openChangePasswordModal = true">
          {{ $t('change_password.title') }}
        </p>
      </div>

      <div class="flex flex-col gap-1">
        <FormField v-slot="{ componentField }" type="radio" name="gender">
          <FormItem class="space-y-2">
            <FormLabel>Gender</FormLabel>

            <FormControl>
              <RadioGroup class="flex space-x-3" v-bind="componentField">
                <FormItem class="flex items-center space-y-0 gap-x-2">
                  <FormControl>
                    <RadioGroupItem class="w-[20px] h-[20px]" value="male" />
                  </FormControl>
                  <FormLabel class="font-normal"> Male </FormLabel>
                </FormItem>
                <FormItem class="flex items-center space-y-0 gap-x-2">
                  <FormControl>
                    <RadioGroupItem class="w-[20px] h-[20px]" value="female" />
                  </FormControl>
                  <FormLabel class="font-normal"> Female </FormLabel>
                </FormItem>
                <FormItem class="flex items-center space-y-0 gap-x-2">
                  <FormControl>
                    <RadioGroupItem class="w-[20px] h-[20px]" value="none" />
                  </FormControl>
                  <FormLabel class="font-normal"> Rather not say </FormLabel>
                </FormItem>
              </RadioGroup>
            </FormControl>
            <FormMessage />
          </FormItem>
        </FormField>
      </div>

      <div class="flex flex-col gap-1">
        <label>Date of birth</label>
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
              <FormLabel>Country</FormLabel>

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
          <FormField v-slot="{ componentField }" name="country">
            <FormItem>
              <FormLabel>State</FormLabel>

              <Select v-bind="componentField" v-model="selectedCountry" @change="onCountryChange">
                <FormControl>
                  <SelectTrigger>
                    <SelectValue placeholder="Select state" />
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
      </div>

      <div class="grid grid-cols-2 gap-3">
        <div class="flex flex-col gap-1 w-full">
          <FormField v-slot="{ componentField }" name="country">
            <FormItem>
              <FormLabel>City</FormLabel>

              <Select v-bind="componentField" v-model="selectedCountry" @change="onCountryChange">
                <FormControl>
                  <SelectTrigger>
                    <SelectValue placeholder="Select city" />
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
        <div class="flex flex-col gap-1 w-full"></div>
      </div>

      <Button type="submit" class="w-[230px] mt-6">Save settings</Button>
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
