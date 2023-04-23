<script lang="ts" setup>
import { computed } from '@vue/reactivity';

type Props = {
    /**
     * 測る秒数
     */
    sec: number,
}

const props = defineProps<Props>()

const minString = computed(() => (String(Math.trunc(props.sec / 60)).padStart(2, "0")))
const secString = computed(() => (String(props.sec % 60).padStart(2, "0")))
</script>

<template>
    <span>
        {{`${minString}:${secString}`}}
    </span>
</template>
