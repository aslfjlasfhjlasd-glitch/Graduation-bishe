<script setup lang="ts">
import { ref, onMounted } from 'vue'
import axios from 'axios'
import { Card, CardHeader, CardTitle, CardContent } from '@/components/ui/card'

interface Registration {
  activityId: string
  activityName: string
  activityTime: string
  activityLocation: string
  status: string
}

const registrations = ref<Registration[]>([])
const loading = ref(false)
const error = ref(false)
const cancelingId = ref<string | null>(null)

// Toast 通知相关
const toastMessage = ref('')
const toastType = ref<'success' | 'error'>('success')
const showToast = ref(false)

const showToastMessage = (message: string, type: 'success' | 'error' = 'success') => {
  toastMessage.value = message
  toastType.value = type
  showToast.value = true
  setTimeout(() => {
    showToast.value = false
  }, 3000)
}

const fetchRegistrations = async () => {
  loading.value = true
  try {
    // 实际开发中应从 store 获取当前用户 ID
    // 此处使用演示账号：2024104 (李胜男)
    const studentId = '2024104'
    const res = await axios.get(`/api/student/registrations?studentId=${studentId}`)
    if (res.data.code === 200) {
        registrations.value = res.data.data || []
    } else {
        registrations.value = []
    }
  } catch (e) {
    console.error(e)
    error.value = true
  } finally {
    loading.value = false
  }
}

const cancelRegistration = async (activityId: string) => {
  if (!confirm('确定要取消报名吗？')) {
    return
  }

  cancelingId.value = activityId
  try {
    const studentId = '2024104'
    const res = await axios.post('/api/student/activity/cancel', {
      studentId,
      activityId: parseInt(activityId)
    })

    if (res.data.code === 200) {
      showToastMessage('取消报名成功', 'success')
      // 刷新列表
      await fetchRegistrations()
    } else {
      showToastMessage(res.data.message || '取消报名失败', 'error')
    }
  } catch (e: any) {
    console.error(e)
    showToastMessage(e.response?.data?.message || '取消报名失败', 'error')
  } finally {
    cancelingId.value = null
  }
}

onMounted(() => {
  fetchRegistrations()
})
</script>

<template>
  <Card>
    <CardHeader>
      <CardTitle>报名状态追踪</CardTitle>
    </CardHeader>
    <CardContent>
      <div class="relative w-full overflow-auto">
        <table class="w-full caption-bottom text-sm text-left">
          <thead class="[&_tr]:border-b">
            <tr class="border-b transition-colors hover:bg-muted/50 data-[state=selected]:bg-muted">
              <th class="h-12 px-4 align-middle font-medium text-slate-500">活动编号</th>
              <th class="h-12 px-4 align-middle font-medium text-slate-500">活动名称</th>
              <th class="h-12 px-4 align-middle font-medium text-slate-500">活动时间</th>
              <th class="h-12 px-4 align-middle font-medium text-slate-500">活动地点</th>
              <th class="h-12 px-4 align-middle font-medium text-slate-500">报名状态</th>
              <th class="h-12 px-4 align-middle font-medium text-slate-500">操作</th> </tr>
          </thead>
          <tbody class="[&_tr:last-child]:border-0">
            <tr v-if="loading">
              <td colspan="5" class="p-4 text-center text-slate-500">加载中...</td>
            </tr>
            <tr v-else-if="registrations.length === 0">
              <td colspan="5" class="p-4 text-center text-slate-500">暂无报名记录</td>
            </tr>
            <tr v-else v-for="item in registrations" :key="item.activityId" class="border-b transition-colors hover:bg-slate-100/50">
            <td class="p-4 align-middle font-medium">{{ item.activityId }}</td>
            <td class="p-4 align-middle">{{ item.activityName }}</td>
            <td class="p-4 align-middle text-slate-600">{{ item.activityTime || '未设置' }}</td>
            <td class="p-4 align-middle text-slate-600">{{ item.activityLocation || '未设置' }}</td>
            <td class="p-4 align-middle">
             <span :class="item.status === '已审核' ? 'inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800' : 'inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-yellow-100 text-yellow-800'">
              {{ item.status || '未审核' }}
             </span>
          </td>
          <td class="p-4 align-middle">
            <button 
              @click="cancelRegistration(item.activityId)"
              :disabled="cancelingId === item.activityId"
               class="text-sm font-medium text-red-600 hover:text-red-800 hover:underline disabled:opacity-50 disabled:cursor-not-allowed"
              >
               {{ cancelingId === item.activityId ? '取消中...' : '取消报名' }}
              </button>
             </td>
            </tr>
          </tbody>
        </table>
      </div>
    </CardContent>
  </Card>
</template>
