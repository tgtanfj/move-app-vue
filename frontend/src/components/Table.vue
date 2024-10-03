<template>
  <div>
    <div>
      <Table class="border-b">
        <TableHeader class="uppercase">
          <TableRow>
            <TableHead>
              <Checkbox id="all" :checked="allSelected" @update:checked="toggleAll" />
            </TableHead>
            <template v-if="selectedItems.length === 0">
              <TableHead>{{ $t('streamer.videos') }}</TableHead>
              <TableHead>{{ $t('streamer.details') }}</TableHead>
              <TableHead>{{ $t('streamer.date_post') }}</TableHead>
              <TableHead>{{ $t('streamer.views') }}</TableHead>
              <TableHead>{{ $t('streamer.comment') }}</TableHead>
              <TableHead>{{ $t('streamer.rating') }}</TableHead>
              <TableHead></TableHead>
            </template>
            <div v-else class="flex">
              <TableHead
                class="flex gap-1 items-center text-primary capitalize font-semibold cursor-pointer"
                @click="showConfirmModal = true"
              >
                <Trash size="16" stroke-width="2.5" />{{ $t('streamer.delete') }}
              </TableHead>
              <TableHead
                class="flex gap-1 items-center text-primary capitalize font-semibold cursor-pointer"
                @click="handleDownloadVideoList"
              >
                <ArrowDownToLine size="16" stroke-width="2.5" />{{ $t('streamer.download') }}
              </TableHead>
            </div>
          </TableRow>
        </TableHeader>
        <TableBody class="text-base">
          <tr v-if="selectedItems.length > 0">
            <td colspan="8">
              <div
                class="p-4 bg-[#E6FFFB] flex justify-center items-center"
                v-if="selectedItems.length === props.list.length"
              >
                <p>
                  <span class="font-bold">{{ $t('streamer.all') }} {{ selectedItems.length }}</span>
                  {{ $t('streamer.videos_selected') }}
                </p>
                <span
                  class="ml-10 text-primary font-bold cursor-pointer"
                  @click="handleClearSelection"
                  >{{ $t('streamer.clear_selection') }}</span
                >
              </div>
              <div class="p-4 bg-[#E6FFFB] flex justify-center items-center" v-else>
                <p>
                  <span class="font-bold">{{ selectedItems.length }}</span>
                  {{ $t('streamer.videos_selected') }}
                </p>
                <span
                  class="ml-10 text-primary font-bold cursor-pointer"
                  @click="handleSelectAllItems"
                  >{{ $t('streamer.select_all_videos') }}</span
                >
              </div>
            </td>
          </tr>
          <TableItem
            v-for="item in props.list"
            :item="item"
            :key="item.id"
            :selectedItems="selectedItems"
            @update:selectedItems="handleItemUpdate"
            @edit:item="handleEditVideo"
          />
        </TableBody>
      </Table>
    </div>
    <BaseDialog
      :title="$t('streamer.delete_selected_video_modal_title')"
      :description="
        !allSelected
          ? $t('streamer.delete_video_modal_description')
          : $t('streamer.delete_all_video_modal_title')
      "
      v-model:open="showConfirmModal"
    >
      <div class="w-full flex justify-center items-center gap-4">
        <Button variant="outline" @click="showConfirmModal = false">{{
          $t('button.cancel')
        }}</Button>
        <Button variant="default" @click="handleDeleteVideoList">{{
          $t('streamer.delete')
        }}</Button>
      </div>
    </BaseDialog>
  </div>
</template>

<script setup>
import StartIcon from '@assets/icons/startIcon.vue'
import { Checkbox } from '@common/ui/checkbox'
import { Table, TableBody, TableHead, TableHeader, TableRow } from '@common/ui/table'
import TableItem from './TableItem.vue'
import { defineProps, ref, computed, watch, onMounted } from 'vue'
import { ArrowDownToLine, Trash } from 'lucide-vue-next'
import { Button } from '@common/ui/button'
import BaseDialog from './BaseDialog.vue'
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@common/ui/tabs'
import { Input } from '@common/ui/input'
import { Card, CardContent } from '@common/ui/card'
import { Label } from '@common/ui/label'
import { Dialog, DialogContent, DialogFooter, DialogHeader } from '@common/ui/dialog'
import Carousel from './Carousel.vue'

const props = defineProps({
  list: {
    type: Array,
    required: true
  }
})

const selectedItems = ref([])
const showConfirmModal = ref(false)
const showEditModal = ref(false)

//Video Infor Edit
const editItem = ref(null)

const allSelected = computed(() => {
  return props.list.length > 0 && selectedItems.value.length === props.list.length
})

const handleItemUpdate = ({ id, checked }) => {
  if (checked) {
    if (!selectedItems.value.includes(id)) {
      selectedItems.value.push(id)
    }
  } else {
    selectedItems.value = selectedItems.value.filter((item) => item !== id)
  }
}

const toggleAll = () => {
  if (selectedItems.value.length === props.list.length) selectedItems.value = []
  else selectedItems.value = props.list.map((item) => item.id)
}

const handleSelectAllItems = () => {
  selectedItems.value = props.list.map((item) => item.id)
}
const handleClearSelection = () => {
  selectedItems.value = []
}

const handleDeleteVideoList = () => {
  showConfirmModal.value = false
  //send video id arr to BE
  selectedItems.value = []
}
const handleDownloadVideoList = () => {
  console.log(selectedItems)
}

const handleEditVideo = ({ item }) => {
  showEditModal.value = true
  editItem.value = { ...item }
}
</script>
