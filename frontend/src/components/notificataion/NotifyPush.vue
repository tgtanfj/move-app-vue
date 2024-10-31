<script setup>
import { useToast } from '@common/ui/toast';

const { toast } = useToast()

const notifyToast = () => {
    toast({ description: 'Login successfully', variant: 'notification' })
}
</script>

<template>
    <div>
        <button @click="notifyToast">Toast</button>
    </div>    
</template>