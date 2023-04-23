<template>
  <div>
    <h2 class="d-flex justify-center">
      <span>
        <!-- current state -->
        Planning
      </span>
    </h2>

    <div class="timer-container">
      <v-btn icon="mdi-play" variant="outlined"></v-btn>
      <Timer class="text-h1" :sec="100" />
    </div>
    <h3>Iteration 1</h3>
    <div>
      <div>
        <v-text-field label="Plan" clearable color="primary" variant="outlined">
          <template v-slot:prepend>
            <Timer class="text-h5" :sec="100" />
          </template>
          <template v-slot:append>
            <v-btn color="success" class="mt-n2">Start</v-btn>
          </template>
        </v-text-field>
      </div>
      <div class="mb-5 result-button-wrapper">
        <v-btn variant="flat" color="success" size="large">
          Finish
        </v-btn>
        <v-btn variant="flat" color="error" size="large">
          Not yet
        </v-btn>
      </div>
      <div>
        <v-textarea label="Review" clearable color="primary" variant="outlined" auto-grow rows="2">
          <template v-slot:prepend>
            <Timer class="text-h5" :sec="100" />
          </template>
          <template v-slot:append>
            <v-btn color="success" class="mt-n2">Next</v-btn>
          </template>
        </v-textarea>
      </div>
    </div>
  </div>
</template>

<script lang="ts" setup>
import Timer from '@/components/Timer.vue'
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