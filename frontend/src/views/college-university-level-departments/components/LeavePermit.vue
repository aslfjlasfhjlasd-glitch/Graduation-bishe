<script setup>
import { ref, onMounted } from 'vue'
import { Card, CardHeader, CardTitle, CardContent } from '@/components/ui/card'
import Button from '@/components/ui/button/button.vue'
import { FileText, Download, AlertCircle } from 'lucide-vue-next'
import axios from 'axios'

const registrations = ref([])
const loading = ref(false)
const errorMessage = ref('')

const fetchRegistrations = async () => {
  // 核心修复：使用 headUsername
  const username = localStorage.getItem('headUsername')
  if (!username) {
    errorMessage.value = '未找到负责人登录信息，请尝试注销并重新登录'
    return
  }

  loading.value = true
  errorMessage.value = ''

  try {
    const response = await axios.get(`http://localhost:8080/api/head/registrations/${username}`)
    if (response.data.code === 200) {
      // 只显示已审核通过的记录
      registrations.value = (response.data.data || []).filter(r => r.status === '已审核通过')
    } else {
      errorMessage.value = response.data.message || '获取数据失败'
    }
  } catch (error) {
    console.error('获取数据失败:', error)
    errorMessage.value = '网络错误，请稍后重试'
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  fetchRegistrations()
})
</script>

<template>
  <div class="space-y-6">
    <h2 class="text-2xl font-bold text-slate-900">公假单出具</h2>

    <div v-if="errorMessage" class="bg-red-50 border border-red-200 rounded-lg p-4 flex items-start gap-3">
      <AlertCircle class="w-5 h-5 text-red-600 flex-shrink-0 mt-0.5" />
      <div class="flex-1">
        <p class="text-sm font-medium text-red-800">{{ errorMessage }}</p>
      </div>
    </div>

    <Card>
      <CardHeader>
        <CardTitle>公假单列表</CardTitle>
      </CardHeader>
      <CardContent>
        <div v-if="loading" class="text-center py-12 text-slate-500">
          加载中...
        </div>
        <div v-else-if="registrations.length === 0" class="text-center py-12 text-slate-400">
          <FileText class="w-12 h-12 mx-auto mb-3 text-slate-300" />
          <p class="text-lg mb-2">暂无公假单记录</p>
          <p class="text-sm">当学生报名通过审核后，可在此处出具公假单</p>
        </div>
        <div v-else class="space-y-4">
          <div v-for="record in registrations" :key="record.id" class="flex items-center justify-between p-4 border border-slate-200 rounded-lg hover:bg-slate-50 transition-colors">
            <div class="flex-1">
              <h3 class="font-semibold text-slate-900">{{ record.studentName }}</h3>
              <p class="text-sm text-slate-600 mt-1">
                活动: {{ record.activityName }} | 时间: {{ record.activityTime }}
              </p>
              <p class="text-xs text-slate-500 mt-1">
                学号: {{ record.studentId }} | 学院: {{ record.academyName }}
              </p>
            </div>
            <div class="flex items-center gap-3">
              <span class="px-3 py-1 rounded-full text-sm font-medium bg-green-100 text-green-700">
                已审核通过
              </span>
              <Button variant="outline" size="sm" class="gap-2">
                <Download class="w-4 h-4" />
                下载公假单
              </Button>
            </div>
          </div>
        </div>
      </CardContent>
    </Card>
  </div>
</template>