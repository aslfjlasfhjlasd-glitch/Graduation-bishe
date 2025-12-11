<script setup>
import { ref, onMounted, computed } from 'vue'
import { Card, CardHeader, CardTitle, CardContent } from '@/components/ui/card'
import Button from '@/components/ui/button/button.vue'
import { Clock, CheckCircle, XCircle, AlertCircle } from 'lucide-vue-next'
import axios from 'axios'

const registrations = ref([])
const loading = ref(false)
const errorMessage = ref('')

// 获取报名记录（用于考勤管理）
const fetchRegistrations = async () => {
  const username = localStorage.getItem('adminUsername')
  if (!username) {
    errorMessage.value = '未找到登录信息，请重新登录'
    return
  }

  loading.value = true
  errorMessage.value = ''

  try {
    const response = await axios.get(`http://localhost:8080/api/head/registrations/${username}`)
    if (response.data.code === 200) {
      registrations.value = response.data.data || []
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

// 格式化时间
const formatTime = (time) => {
  if (!time) return '-'
  return new Date(time).toLocaleString('zh-CN', {
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
    hour: '2-digit',
    minute: '2-digit'
  })
}

// 获取考勤状态样式
const getAttendanceStatusClass = (status) => {
  switch (status) {
    case '正常':
      return 'bg-green-100 text-green-700'
    case '迟到':
      return 'bg-yellow-100 text-yellow-700'
    case '早退':
      return 'bg-orange-100 text-orange-700'
    case '缺勤':
      return 'bg-red-100 text-red-700'
    default:
      return 'bg-slate-100 text-slate-700'
  }
}

onMounted(() => {
  fetchRegistrations()
})
</script>

<template>
  <div class="space-y-6">
    <h2 class="text-2xl font-bold text-slate-900">考勤管理</h2>

    <!-- 错误提示 -->
    <div v-if="errorMessage" class="bg-red-50 border border-red-200 rounded-lg p-4 flex items-start gap-3">
      <AlertCircle class="w-5 h-5 text-red-600 flex-shrink-0 mt-0.5" />
      <div class="flex-1">
        <p class="text-sm font-medium text-red-800">{{ errorMessage }}</p>
      </div>
    </div>

    <Card>
      <CardHeader>
        <CardTitle>考勤记录</CardTitle>
      </CardHeader>
      <CardContent>
        <div v-if="loading" class="text-center py-12 text-slate-500">
          加载中...
        </div>
        <div v-else-if="registrations.length === 0" class="text-center py-12 text-slate-400">
          <Clock class="w-12 h-12 mx-auto mb-3 text-slate-300" />
          <p class="text-lg mb-2">暂无考勤记录</p>
          <p class="text-sm">当学生参与活动后，考勤记录将显示在此处</p>
        </div>
        <div v-else class="overflow-x-auto">
          <table class="w-full">
            <thead>
              <tr class="border-b border-slate-200">
                <th class="text-left py-3 px-4 font-semibold text-slate-700">学生姓名</th>
                <th class="text-left py-3 px-4 font-semibold text-slate-700">学号</th>
                <th class="text-left py-3 px-4 font-semibold text-slate-700">活动名称</th>
                <th class="text-left py-3 px-4 font-semibold text-slate-700">签到时间</th>
                <th class="text-left py-3 px-4 font-semibold text-slate-700">签退时间</th>
                <th class="text-left py-3 px-4 font-semibold text-slate-700">考勤状态</th>
                <th class="text-left py-3 px-4 font-semibold text-slate-700">操作</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="record in registrations" :key="record.id" class="border-b border-slate-100 hover:bg-slate-50">
                <td class="py-3 px-4">{{ record.studentName }}</td>
                <td class="py-3 px-4 text-slate-600">{{ record.studentId }}</td>
                <td class="py-3 px-4">{{ record.activityName }}</td>
                <td class="py-3 px-4 text-sm text-slate-600">{{ formatTime(record.checkInTime) }}</td>
                <td class="py-3 px-4 text-sm text-slate-600">{{ formatTime(record.checkOutTime) }}</td>
                <td class="py-3 px-4">
                  <span v-if="record.attendanceStatus" :class="['px-3 py-1 rounded-full text-sm font-medium', getAttendanceStatusClass(record.attendanceStatus)]">
                    {{ record.attendanceStatus }}
                  </span>
                  <span v-else class="text-slate-400 text-sm">未记录</span>
                </td>
                <td class="py-3 px-4">
                  <Button variant="outline" size="sm">编辑</Button>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </CardContent>
    </Card>
  </div>
</template>