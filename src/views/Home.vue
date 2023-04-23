<template>
  <div>
    <h2 class="d-flex justify-center">
      <span>
        {{ status }}
      </span>
    </h2>

    <div class="timer-container">
      <v-btn v-if="!isStartTimer" @click="handleClickPlay" icon="mdi-play" variant="outlined"></v-btn>
      <v-btn v-else @click="handleClickStop" icon="mdi-stop" variant="outlined"></v-btn>
      <Timer class="text-h1" :sec="currentTime" />
    </div>
    <h3>Iteration {{ curretIteration }}</h3>
    <div>
      <div>
        <v-text-field label="Plan" v-model="plan" clearable color="primary" variant="outlined">
          <template v-slot:append>
            <v-btn @click="handleClickStart" color="success" class="mt-n2" :disabled="status !== 'Planning'">Start</v-btn>
          </template>
        </v-text-field>
      </div>
      <div class="mb-5 result-button-wrapper">
        <v-btn @click="handleClickFinish(true)" variant="flat" color="success" size="large"
          :disabled="status !== 'Focus'">
          Finish
        </v-btn>
        <v-btn @click="handleClickFinish(false)" variant="flat" color="error" size="large" :disabled="status !== 'Focus'">
          Not yet
        </v-btn>
      </div>
      <div v-if="isFinish !== undefined" class="d-flex justify-center">
        <span class="text-h5">
          {{ isFinish ? "🥰" : "😭" }}
        </span>
      </div>
      <div>
        <v-textarea label="Review" v-model="review" clearable color="primary" variant="outlined" auto-grow rows="2">
          <template v-slot:append>
            <v-btn @click="handleClickNextButton" color="success" class="mt-n2"
              :disabled="status !== 'Review'">Next</v-btn>
          </template>
        </v-textarea>
      </div>
    </div>

    <div class="text-grey-darken-1">
      <v-btn @click="handleClickExport" variant="outlined">Export</v-btn>
      <div v-for="report in reports">
        <h3 class="text-h5">Iteration {{ report.iteration }}</h3>
        <h4 class="text-h6">Plan</h4>
        <p>
          {{ report.plan }}
        </p>
        <h4 class="text-h6">
          Result
        </h4>
        <p>
          {{ report.isFinish ? "Finish" : "Do not finish" }}
        </p>
        <h4 class="text-h6">
          Review
        </h4>
        <p>
          {{ report.review }}
        </p>
      </div>
    </div>
  </div>
</template>

<script lang="ts" setup>
import Timer from '@/components/Timer.vue'
import format from "date-fns/format"
import { reactive } from 'vue';
import { ref } from 'vue';
import { Ref } from 'vue';

interface Report {
  iteration: number,
  plan: string,
  isFinish: boolean,
  review: string
}

// それぞれのデフォルト秒数
const PLANNING_TIME = 2 * 60
const FOCUS_TIME = 20 * 60
const REVIEW_TIME = 3 * 60
const BREAK_TIME = 5

// FIXME: 内部状態であるstatusと、ユーザーに見せるものとしてのstatusは分けるべき
const status: Ref<"Planning" | "Focus" | "Review" | "Break"> = ref("Planning")
// 現在の秒数
const currentTime: Ref<number> = ref(PLANNING_TIME)

const isStartTimer: Ref<boolean> = ref(false)
const mainTimerIntervalId = ref()

// ポモドーロの回数
const curretIteration: Ref<number> = ref(1)
const plan: Ref<string> = ref("")
const isFinish: Ref<boolean | undefined> = ref()
const review: Ref<string> = ref("")

const reports: Report[] = reactive([])

// タイマーをスタートさせる処理
const startMainTimer = (onEndTimer?: () => void) => {
  isStartTimer.value = true
  mainTimerIntervalId.value = setInterval(() => {
    currentTime.value--
    if (currentTime.value < 0) {
      currentTime.value = 0
      stopMainTimer()
      if (onEndTimer) {
        onEndTimer()
      }
    }
  }, 1000)
}

const stopMainTimer = () => {
  isStartTimer.value = false
  if (mainTimerIntervalId.value) {
    clearInterval(mainTimerIntervalId.value)
  }
}

const handleClickPlay = () => {
  startMainTimer()
}

const handleClickStop = () => {
  stopMainTimer()
}

const handleClickStart = () => {
  status.value = "Focus"
  stopMainTimer()
  currentTime.value = FOCUS_TIME
  startMainTimer()
}

// FInishかNotYetを押したとき
const handleClickFinish = (finish: boolean) => {
  status.value = "Review"
  isFinish.value = finish
  stopMainTimer()
  currentTime.value = REVIEW_TIME
  startMainTimer()
}

const initTimer = () => {
  status.value = "Planning"
  currentTime.value = PLANNING_TIME
}

const initReport = () => {
  plan.value = ""
  isFinish.value = undefined
  review.value = ""
}

const handleClickNextButton = () => {
  status.value = "Break"
  stopMainTimer()
  currentTime.value = BREAK_TIME
  startMainTimer(() => {
    initTimer()
    initReport()
    curretIteration.value++
  })
  reports.push(
    {
      iteration: curretIteration.value,
      plan: plan.value,
      isFinish: isFinish.value ?? false,  // undefinedならfalse
      review: review.value
    }
  )
}

const handleClickExport = () => {
  const now = new Date()
  // マークダウン形式で結果を出力
  const markdown = reports.map(report => (
    `# Pomodoro Report ${format(now, "yyyy-MM-dd")}
## Iteration ${report.iteration}
### Plan
${report.plan}
### Result
${report.isFinish ? "Finish" : "Do not finish"}
### Review
${report.review}
    `
  )).join("\n")
  const blob = new Blob([markdown], { type: "text/plain" })
  const url = URL.createObjectURL(blob)
  const link = document.createElement("a")
  link.download = `${format(now, "yyyy-MM-dd")}_pomodoro.md`
  link.href = url
  link.click()
  URL.revokeObjectURL(link.href)
}
</script>

<style lang="scss" scoped>
.timer-container {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 1rem;
}

.result-button-wrapper {
  display: flex;
  justify-content: center;
  gap: 1rem;
}
</style>