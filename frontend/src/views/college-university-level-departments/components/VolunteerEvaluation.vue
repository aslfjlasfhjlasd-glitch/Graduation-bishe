<script setup>
import { ref, onMounted } from 'vue'
import { Card, CardHeader, CardTitle, CardContent } from '@/components/ui/card'
import Button from '@/components/ui/button/button.vue'
import { Star, MessageSquare, AlertCircle } from 'lucide-vue-next'
import axios from 'axios'

const registrations = ref([])
const loading = ref(false)
const errorMessage = ref('')

// 获取报名记录（用于志愿者评价）
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
      // 只显示有学分确认的记录
      registrations.value = (response.data.data || []).filter(r => r.credits > 0)
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

// 渲染星级评分
const renderStars = (rating) => {
  if (!rating) return []
  return Array(5).fill(0).map((_, i) => i < rating)
}

// 获取评价状态样式
const getEvaluationStatusClass = (evaluation) => {
  if (evaluation) return 'bg-green-100 text-green-700'
  return 'bg-yellow-100 text-yellow-700'
}

onMounted(() => {
  fetchRegistrations()
})
</script>

<template>
  <div class="space-y-6">
    <h2 class="text-2xl font-bold text-slate-900">志愿者评价</h2>

    <div v-if="errorMessage" class="bg-red-50 border border-red-200 rounded-lg p-4 flex items-start gap-3">
      <AlertCircle class="w-5 h-5 text-red-600 flex-shrink-0 mt-0.5" />
      <div class="flex-1">
        <p class="text-sm font-medium text-red-800">{{ errorMessage }}</p>
      </div>
    </div>

    <Card>
      <CardHeader>
        <CardTitle>志愿者评价列表</CardTitle>
      </CardHeader>
      <CardContent>
        <div v-if="loading" class="text-center py-12 text-slate-500">
          加载中...
        </div>
        <div v-else-if="registrations.length === 0" class="text-center py-12 text-slate-400">
          <MessageSquare class="w-12 h-12 mx-auto mb-3 text-slate-300" />
          <p class="text-lg mb-2">暂无待评价记录</p>
          <p class="text-sm">当学生完成活动并确认学分后，可在此处进行评价</p>
        </div>
        <div v-else class="space-y-4">
          <div v-for="record in registrations" :key="record.id" class="border border-slate-200 rounded-lg p-4 hover:bg-slate-50 transition-colors">
            <div class="flex items-start justify-between mb-3">
              <div class="flex-1">
                <h3 class="font-semibold text-slate-900">{{ record.studentName }}</h3>
                <p class="text-sm text-slate-600 mt-1">
                  学号: {{ record.studentId }} | 学院: {{ record.academyName }}
                </p>
                <p class="text-sm text-slate-600 mt-1">
                  活动: {{ record.activityName }}
                </p>
                <p class="text-xs text-slate-500 mt-1">
                  工时: {{ record.duration }}小时 | 学分: {{ record.credits }}
                </p>
              </div>
              <span :class="['px-3 py-1 rounded-full text-sm font-medium', getEvaluationStatusClass(record.evaluation)]">
                {{ record.evaluation ? '已评价' : '待评价' }}
              </span>
            </div>

            <div v-if="record.evaluation" class="mt-3 p-3 bg-slate-50 rounded-lg">
              <div class="flex items-center gap-2 mb-2">
                <span class="text-sm font-medium text-slate-700">评分:</span>
                <div class="flex gap-1">
                  <Star 
                    v-for="(filled, index) in renderStars(record.rating)" 
                    :key="index"
                    :class="['w-4 h-4', filled ? 'fill-yellow-400 text-yellow-400' : 'text-slate-300']"
                  />
                </div>
                <span class="text-sm text-slate-600">({{ record.rating }}/5)</span>
              </div>
              <p class="text-sm text-slate-700">{{ record.evaluation }}</p>
            </div>

            <div class="mt-3 flex gap-2">
              <Button v-if="!record.evaluation" variant="default" size="sm">
                <MessageSquare class="w-4 h-4 mr-2" />
                评价
              </Button>
              <Button v-else variant="outline" size="sm">
                <MessageSquare class="w-4 h-4 mr-2" />
                修改评价
              </Button>
            </div>
          </div>
        </div>
      </CardContent>
    </Card>
  </div>
</template>