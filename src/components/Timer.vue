<!-- 秒を渡して特定のフォーマットにする -->
<template>
    <span class="text-h1 time">
        {{`${minString}:${secString}`}}
    </span>
</template>

<script lang="ts" setup>
import { ref } from 'vue';
import { Ref } from 'vue';
import { reactive } from 'vue';

type Props = {
    /**
     * 秒数
     */
    sec: number
}

const props = defineProps<Props>()

const minString: Ref<string> = ref(String(Math.trunc(props.sec / 60)).padStart(2, "0"))
const secString: Ref<string> = ref(String(props.sec % 60).padStart(2, "0"))

</script>

<style scoped lang="scss">

</style>