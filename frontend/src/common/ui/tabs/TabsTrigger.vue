<script setup>
import { computed } from "vue";
import { TabsTrigger, useForwardProps } from "radix-vue";
import { cn } from "@utils/shadcn.util";

const props = defineProps({
  value: { type: [String, Number], required: true },
  disabled: { type: Boolean, required: false },
  asChild: { type: Boolean, required: false },
  as: { type: null, required: false },
  class: { type: null, required: false },
});

const delegatedProps = computed(() => {
  const { class: _, ...delegated } = props;

  return delegated;
});

const forwardedProps = useForwardProps(delegatedProps);
</script>

<template>
  <TabsTrigger
    v-bind="forwardedProps"
    :class="
      cn(
        'inline-flex items-center justify-center whitespace-nowrap rounded-sm px-3 py-1.5 text-sm ring-offset-background transition-all focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 data-[state=active]:bg-background data-[state=active]:text-[#13D0B4] data-[state=active]:border-[0_0_2px_0]',
        props.class,
      )
    "
  >
    <span class="truncate">
      <slot />
    </span>
  </TabsTrigger>
</template>
