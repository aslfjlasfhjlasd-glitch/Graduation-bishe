<script setup lang="ts">
import { ref, onMounted } from 'vue'
import axios from 'axios'
import { Card, CardHeader, CardTitle, CardContent } from '@/components/ui/card'

interface Performance {
  activityId: string
  activityName: string
  activityTime: string
  duration: number | null
  credits: number | null
}

const performances = ref<Performance[]>([])
const loading = ref(false)
const error = ref(false)

const fetchPerformance = async () => {
  loading.value = true
  try {
    // 实际开发中应从 store 获取当前用户 ID
    // 此处使用演示账号：2024104 (李胜男)
    const studentId = '2024104' 
    const res = await axios.get(`/api/student/performance?studentId=${studentId}`)
    if (res.data.code === 200) {
        performances.value = res.data.data || []
    } else {
        performances.value = []
    }
  } catch (e) {
    console.error(e)
    error.value = true
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  fetchPerformance()
})
</script>

<template>
  <Card>
    <CardHeader>
      <CardTitle>活动表现查看</CardTitle>
    </CardHeader>
    <CardContent>
      <div class="relative w-full overflow-auto">
        <table class="w-full caption-bottom text-sm text-left">
          <thead class="[&_tr]:border-b">
            <tr class="border-b transition-colors hover:bg-muted/50 data-[state=selected]:bg-muted">
              <th class="h-12 px-4 align-middle font-medium text-slate-500">活动编号</th>
              <th class="h-12 px-4 align-middle font-medium text-slate-500">活动名称</th>
              <th class="h-12 px-4 align-middle font-medium text-slate-500">活动时间</th>
              <th class="h-12 px-4 align-middle font-medium text-slate-500">参与时长 (小时)</th>
              <th class="h-12 px-4 align-middle font-medium text-slate-500">获得学分</th>
            </tr>
          </thead>
          <tbody class="[&_tr:last-child]:border-0">
            <tr v-if="loading">
              <td colspan="5" class="p-4 text-center text-slate-500">加载中...</td>
            </tr>
            <tr v-else-if="performances.length === 0">
              <td colspan="5" class="p-4 text-center text-slate-500">暂无活动记录</td>
            </tr>
            <tr v-else v-for="item in performances" :key="item.activityId" class="border-b transition-colors hover:bg-slate-100/50">
              <td class="p-4 align-middle font-medium">{{ item.activityId }}</td>
              <td class="p-4 align-middle">{{ item.activityName }}</td>
              <td class="p-4 align-middle">{{ item.activityTime }}</td>
              <td class="p-4 align-middle font-medium text-blue-600">
                {{ item.duration !== null ? item.duration : '-' }}
              </td>
              <td class="p-4 align-middle font-medium text-emerald-600">
                {{ item.credits !== null ? item.credits : '-' }}
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </CardContent>
  </Card>
</template>
