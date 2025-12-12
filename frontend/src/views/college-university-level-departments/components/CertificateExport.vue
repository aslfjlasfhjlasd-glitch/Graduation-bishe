<script setup>
import { ref, onMounted, computed } from 'vue'
import { Card, CardHeader, CardTitle, CardContent } from '@/components/ui/card'
import Button from '@/components/ui/button/button.vue'
import { FileText, Download, Filter, AlertCircle } from 'lucide-vue-next'
import axios from 'axios'

const registrations = ref([])
const loading = ref(false)
const errorMessage = ref('')
const filterType = ref('all')

const fetchRegistrations = async () => {
  const username = localStorage.getItem('headUsername') // 修正
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

const filteredRegistrations = computed(() => {
  switch (filterType.value) {
    case 'completed':
      return registrations.value.filter(r => r.credits > 0)
    case 'evaluated':
      return registrations.value.filter(r => r.evaluation)
    default:
      return registrations.value
  }
})

const statistics = computed(() => {
  return {
    total: registrations.value.length,
    completed: registrations.value.filter(r => r.credits > 0).length,
    evaluated: registrations.value.filter(r => r.evaluation).length
  }
})

onMounted(() => {
  fetchRegistrations()
})
</script>

<template>
  <div class="space-y-6">
    <h2 class="text-2xl font-bold text-slate-900">证明导出</h2>

    <div v-if="errorMessage" class="bg-red-50 border border-red-200 rounded-lg p-4 flex items-start gap-3">
      <AlertCircle class="w-5 h-5 text-red-600 flex-shrink-0 mt-0.5" />
      <div class="flex-1">
        <p class="text-sm font-medium text-red-800">{{ errorMessage }}</p>
      </div>
    </div>

    <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
      <Card>
        <CardContent class="pt-6">
          <div class="text-center">
            <p class="text-3xl font-bold text-blue-600">{{ statistics.total }}</p>
            <p class="text-sm text-slate-600 mt-1">总参与人次</p>
          </div>
        </CardContent>
      </Card>
      <Card>
        <CardContent class="pt-6">
          <div class="text-center">
            <p class="text-3xl font-bold text-green-600">{{ statistics.completed }}</p>
            <p class="text-sm text-slate-600 mt-1">已完成活动</p>
          </div>
        </CardContent>
      </Card>
      <Card>
        <CardContent class="pt-6">
          <div class="text-center">
            <p class="text-3xl font-bold text-purple-600">{{ statistics.evaluated }}</p>
            <p class="text-sm text-slate-600 mt-1">已评价人次</p>
          </div>
        </CardContent>
      </Card>
    </div>

    <Card>
      <CardHeader>
        <div class="flex items-center justify-between">
          <CardTitle>证明列表</CardTitle>
          <div class="flex items-center gap-2">
            <Filter class="w-4 h-4 text-slate-500" />
            <select 
              v-model="filterType" 
              class="px-3 py-1.5 border border-slate-300 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-blue-500"
            >
              <option value="all">全部记录</option>
              <option value="completed">已完成活动</option>
              <option value="evaluated">已评价记录</option>
            </select>
          </div>
        </div>
      </CardHeader>
      <CardContent>
        <div v-if="loading" class="text-center py-12 text-slate-500">
          加载中...
        </div>
        <div v-else-if="filteredRegistrations.length === 0" class="text-center py-12 text-slate-400">
          <FileText class="w-12 h-12 mx-auto mb-3 text-slate-300" />
          <p class="text-lg mb-2">暂无证明记录</p>
          <p class="text-sm">当学生完成活动后，可在此处导出相关证明</p>
        </div>
        <div v-else class="overflow-x-auto">
          <table class="w-full">
            <thead>
              <tr class="border-b border-slate-200">
                <th class="text-left py-3 px-4 font-semibold text-slate-700">学生姓名</th>
                <th class="text-left py-3 px-4 font-semibold text-slate-700">学号</th>
                <th class="text-left py-3 px-4 font-semibold text-slate-700">活动名称</th>
                <th class="text-left py-3 px-4 font-semibold text-slate-700">工时</th>
                <th class="text-left py-3 px-4 font-semibold text-slate-700">学分</th>
                <th class="text-left py-3 px-4 font-semibold text-slate-700">评价</th>
                <th class="text-left py-3 px-4 font-semibold text-slate-700">操作</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="record in filteredRegistrations" :key="record.id" class="border-b border-slate-100 hover:bg-slate-50">
                <td class="py-3 px-4">{{ record.studentName }}</td>
                <td class="py-3 px-4 text-slate-600">{{ record.studentId }}</td>
                <td class="py-3 px-4">{{ record.activityName }}</td>
                <td class="py-3 px-4">
                  <span v-if="record.duration" class="text-slate-700">{{ record.duration }}h</span>
                  <span v-else class="text-slate-400">-</span>
                </td>
                <td class="py-3 px-4">
                  <span v-if="record.credits" class="font-semibold text-blue-600">{{ record.credits }}</span>
                  <span v-else class="text-slate-400">-</span>
                </td>
                <td class="py-3 px-4">
                  <span v-if="record.evaluation" class="text-green-600">✓</span>
                  <span v-else class="text-slate-400">-</span>
                </td>
                <td class="py-3 px-4">
                  <div class="flex gap-2">
                    <Button variant="outline" size="sm" class="gap-1">
                      <Download class="w-3 h-3" />
                      参与证明
                    </Button>
                    <Button v-if="record.credits > 0" variant="outline" size="sm" class="gap-1">
                      <Download class="w-3 h-3" />
                      学分证明
                    </Button>
                  </div>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </CardContent>
    </Card>
  </div>
</template>