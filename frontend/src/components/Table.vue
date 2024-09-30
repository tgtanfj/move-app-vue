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
              <TableHead> Videos </TableHead>
              <TableHead>Details</TableHead>
              <TableHead>Date Posted</TableHead>
              <TableHead>Views</TableHead>
              <TableHead>Comments</TableHead>
              <TableHead>Rating</TableHead>
              <TableHead></TableHead>
            </template>
            <div v-else class="flex">
              <TableHead
                class="flex gap-1 items-center text-primary capitalize font-semibold cursor-pointer"
                @click="showConfirmModal = true"
              >
                <Trash size="16" stroke-width="2.5" />Delete
              </TableHead>
              <TableHead
                class="flex gap-1 items-center text-primary capitalize font-semibold cursor-pointer"
                @click="handleDownloadVideoList"
              >
                <ArrowDownToLine size="16" stroke-width="2.5" />Download
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
                  <span class="font-bold">All {{ selectedItems.length }}</span> videos on this page
                  has been selected.
                </p>
                <span
                  class="ml-10 text-primary font-bold cursor-pointer"
                  @click="handleClearSelection"
                  >Clear selection.</span
                >
              </div>
              <div class="p-4 bg-[#E6FFFB] flex justify-center items-center" v-else>
                <p>
                  <span class="font-bold">{{ selectedItems.length }}</span> videos on this page has
                  been selected.
                </p>
                <span
                  class="ml-10 text-primary font-bold cursor-pointer"
                  @click="handleSelectAllItems"
                  >Select all videos.</span
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
      v-model:open="showConfirmModal"
      title="Delete video(s)"
      description="The selected video(s) will be permanently deleted. You will lose all data such"
    >
      <div class="w-full flex justify-center items-center gap-4">
        <Button variant="outline" @click="showConfirmModal = false">Cancel</Button>
        <Button variant="default" @click="handleDeleteVideoList">Delete</Button>
      </div>
    </BaseDialog>
    <Dialog v-model:open="showEditModal">
      <DialogContent class="min-w-fit">
        <DialogHeader>
          <DialogTitle class="font-bold">Edit Details</DialogTitle>
        </DialogHeader>
        <div class="flex w-full">
          <Tabs orientation="vertical" class="flex">
            <TabsList class="flex flex-col bg-white">
              <TabsTrigger value="detail" class="p-3 block -ml-3 group">
                <div class="flex items-center justify-start group-data-[state=active]:font-bold">
                  <div class="px-[15px] py-[8px] bg-black text-[#EEEEEE] rounded-full mr-5">1</div>
                  Details
                </div>
              </TabsTrigger>
              <TabsTrigger value="tag" class="block p-3 -ml-7 group">
                <div class="flex items-center justify-start group-data-[state=active]:font-bold">
                  <div class="px-[15px] py-[8px] bg-black text-[#EEEEEE] rounded-full mr-5">2</div>
                  Tags
                </div>
              </TabsTrigger>
              <TabsTrigger value="setting" class="block p-3 group">
                <div class="flex items-center justify-start group-data-[state=active]:font-bold">
                  <div class="px-[15px] py-[8px] bg-black text-[#EEEEEE] rounded-full mr-5">3</div>
                  Settings
                </div>
              </TabsTrigger>
            </TabsList>
            <TabsContent value="detail">
              <div class="flex flex-col">
                <Label for="title">Video title</Label>
                <Input
                  id="title"
                  :modelValue="editItem ? editItem.title : ''"
                  placeholder="Title goes here"
                  class="mt-2"
                />
              </div>
              <div class="flex flex-col mt-3">
                <Label>Video Thumbnail</Label>
                <Carousel />
              </div>
            </TabsContent>
            <TabsContent value="tag"> </TabsContent>
            <TabsContent value="setting">Setting</TabsContent>
          </Tabs>
        </div>
        <DialogFooter>
          <div class="flex justify-end items-center">
            <Button variant="outline">Back</Button>
            <Button class="px-7">Next</Button>
          </div>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  </div>
</template>

<script setup>
import StartIcon from '@assets/icons/startIcon.vue'
import { Checkbox } from '@common/ui/checkbox'
import { Table, TableBody, TableHead, TableHeader, TableRow } from '@common/ui/table'
import TableItem from './TableItem.vue'
import { defineProps, ref, computed, watch } from 'vue'
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
}
const handleDownloadVideoList = () => {
  console.log(selectedItems)
}

const handleEditVideo = ({ item }) => {
  showEditModal.value = true
  editItem.value = { ...item }
}
</script>
