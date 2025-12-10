<script setup>
import { ref, onMounted, computed } from 'vue'
import { Card, CardHeader, CardTitle, CardContent } from '@/components/ui/card'
import Button from '@/components/ui/button/button.vue'
import { Plus, Edit, Trash2, Calendar, MapPin, Users, AlertCircle } from 'lucide-vue-next'
import axios from 'axios'

const activities = ref([])
const loading = ref(false)
const errorMessage = ref('')

// 获取活动列表
const fetchActivities = async () => {
  const username = localStorage.getItem('adminUsername')
  if (!username) {
    errorMessage.value = '未找到登录信息，请重新登录'
    return
  }

  loading.value = true
  errorMessage.value = ''

  try {
    const response = await axios.get(`http://localhost:8080/api/head/activities/${username}`)
    if (response.data.code === 200) {
      activities.value = response.data.data || []
    } else {
      errorMessage.value = response.data.message || '获取活动列表失败'
    }
  } catch (error) {
    console.error('获取活动列表失败:', error)
    errorMessage.value = '网络错误，请稍后重试'
  } finally {
    loading.value = false
  }
}

// 计算活动状态的显示样式
const getStatusClass = (status) => {
  const statusMap = {
    '未开始': 'bg-slate-100 text-slate-700',
    '报名中': 'bg-blue-100 text-blue-700',
    '进行中': 'bg-green-100 text-green-700',
    '已结束': 'bg-slate-100 text-slate-500'
  }
  return statusMap[status] || 'bg-slate-100 text-slate-700'
}

// 格式化日期时间
const formatDateTime = (dateStr) => {
  if (!dateStr) return '-'
  return dateStr
}

// 计算报名进度百分比
const getProgressPercentage = (current, max) => {
  if (!max || max === 0) return 0
  const percentage = (current / max) * 100
  return Math.min(percentage, 100)
}

onMounted(() => {
  fetchActivities()
})
</script>

<template>
  <div class="space-y-6">
    <div class="flex justify-between items-center">
      <h2 class="text-2xl font-bold text-slate-900">志愿活动设计</h2>
      <Button class="gap-2">
        <Plus class="w-4 h-4" />
        创建新活动
      </Button>
    </div>

    <!-- 错误提示 -->
    <div v-if="errorMessage" class="bg-red-50 border border-red-200 rounded-lg p-4 flex items-start gap-3">
      <AlertCircle class="w-5 h-5 text-red-600 flex-shrink-0 mt-0.5" />
      <div class="flex-1">
        <p class="text-sm font-medium text-red-800">{{ errorMessage }}</p>
      </div>
    </div>

    <Card>
      <CardHeader>
        <CardTitle>活动列表</CardTitle>
      </CardHeader>
      <CardContent>
        <div v-if="loading" class="text-center py-12 text-slate-500">
          加载中...
        </div>
        <div v-else-if="activities.length === 0" class="text-center py-12 text-slate-400">
          <p class="text-lg mb-2">暂无活动</p>
          <p class="text-sm">点击"创建新活动"按钮开始创建您的第一个志愿活动</p>
        </div>
        <div v-else class="space-y-4">
          <div v-for="activity in activities" :key="activity.hdBh" 
               class="border border-slate-200 rounded-lg hover:shadow-md transition-all duration-200">
            <div class="p-5">
              <div class="flex items-start justify-between mb-4">
                <div class="flex-1">
                  <div class="flex items-center gap-3 mb-2">
                    <h3 class="font-semibold text-lg text-slate-900">{{ activity.hdMc }}</h3>
                    <span :class="['px-3 py-1 rounded-full text-xs font-medium', getStatusClass(activity.hdZt)]">
                      {{ activity.hdZt }}
                    </span>
                  </div>
                  <p class="text-sm text-slate-600 line-clamp-2">{{ activity.hdNr || '暂无描述' }}</p>
                </div>
                <div class="flex gap-2 ml-4">
                  <Button variant="outline" size="sm" class="gap-2">
                    <Edit class="w-4 h-4" />
                    编辑
                  </Button>
                  <Button variant="outline" size="sm" class="gap-2 text-red-600 hover:text-red-700 hover:border-red-300">
                    <Trash2 class="w-4 h-4" />
                    删除
                  </Button>
                </div>
              </div>

              <div class="grid grid-cols-1 md:grid-cols-3 gap-4 mb-4">
                <div class="flex items-center gap-2 text-sm text-slate-600">
                  <Calendar class="w-4 h-4 text-slate-400" />
                  <div>
                    <p class="text-xs text-slate-500">报名时间</p>
                    <p class="font-medium">{{ activity.bmSj || '-' }}</p>
                  </div>
                </div>
                <div class="flex items-center gap-2 text-sm text-slate-600">
                  <Calendar class="w-4 h-4 text-slate-400" />
                  <div>
                    <p class="text-xs text-slate-500">活动时间</p>
                    <p class="font-medium">{{ activity.hdSj || '-' }}</p>
                  </div>
                </div>
                <div class="flex items-center gap-2 text-sm text-slate-600">
                  <MapPin class="w-4 h-4 text-slate-400" />
                  <div>
                    <p class="text-xs text-slate-500">活动地点</p>
                    <p class="font-medium">{{ activity.hdDd || '-' }}</p>
                  </div>
                </div>
              </div>

              <div class="flex items-center gap-4">
                <div class="flex items-center gap-2 text-sm">
                  <Users class="w-4 h-4 text-slate-400" />
                  <span class="text-slate-600">
                    报名人数: 
                    <span class="font-semibold text-slate-900">{{ activity.ybmRs || 0 }}</span>
                    <span class="text-slate-400">/</span>
                    <span class="font-semibold text-slate-900">{{ activity.zmRs || '不限' }}</span>
                  </span>
                </div>
                <div class="flex-1">
                  <div class="w-full bg-slate-100 rounded-full h-2">
                    <div 
                      class="bg-blue-500 h-2 rounded-full transition-all duration-300"
                      :style="{ width: `${getProgressPercentage(activity.ybmRs, parseInt(activity.zmRs))}%` }"
                    ></div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </CardContent>
    </Card>
  </div>
</template>