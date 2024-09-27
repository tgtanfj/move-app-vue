<script setup>
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/common/ui/tabs'
import ProfileUserTab from './ProfileUserTab.vue'
import NotificationsTab from './NotificationsTab.vue'
</script>

<template>
  <Tabs default-value="profile" class="w-full mt-2">
    <TabsList
      class="ml-0 pl-0 text-[16px] w-full border-b-[1px] border-[#999999] pb-0 rounded-none mb-4 self-start flex justify-start"
    >
      <TabsTrigger
        class="data-[state=active]:border-b-[3px] border-b-[3px] px-0 mx-3 border-white rounded-none data-[state=active]:border-[#13D0B4] data-[state=active]:text-[#13D0B4] flex items-center justify-start ml-0 pl-0 pb-3"
        value="profile"
      >
        <p>Profile</p>
      </TabsTrigger>
      <TabsTrigger
        class="data-[state=active]:border-b-[3px] border-b-[3px] px-0 mx-3 border-white rounded-none data-[state=active]:border-[#13D0B4] data-[state=active]:text-[#13D0B4] pb-3"
        value="notifications"
      >
        <p>Notifications</p>
      </TabsTrigger>
    </TabsList>
    <TabsContent value="profile">
      <ProfileUserTab />
    </TabsContent>
    <TabsContent value="notifications">
      <NotificationsTab />
     </TabsContent>
  </Tabs>
</template>
