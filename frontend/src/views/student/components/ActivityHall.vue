<script setup>
import { ref, onMounted, onUnmounted, computed } from 'vue'
import axios from 'axios'
import Button from '@/components/ui/button/button.vue'
import { Card, CardHeader, CardTitle, CardContent } from '@/components/ui/card'
import { Calendar, MapPin, Users, Leaf, BookOpen, HeartPulse, Sparkles, Info, ShieldCheck, Building2, Clock, CalendarCheck, CalendarX, Activity, Flag, AlertCircle, CheckCircle2 } from 'lucide-vue-next'
import { DialogRoot, DialogOverlay, DialogContent, DialogTitle, DialogDescription } from 'radix-vue'
import { ToastProvider, ToastViewport, ToastRoot, ToastTitle, ToastDescription, ToastClose } from 'radix-vue'
const API_BASE = import.meta.env.VITE_API_BASE_URL || 'http://localhost:8080'
const icons = { Leaf, BookOpen, HeartPulse, Sparkles }
const pickIcon = (title) => {
  const t = String(title || '')
  if (/(环保|环境|垃圾|绿|生态)/.test(t)) return 'Leaf'
  if (/(教育|简历|咨询|大赛|毕业|迎新|开学|学院|课堂)/.test(t)) return 'BookOpen'
  if (/(医疗|献血|健康|体质|医|医院|心理)/.test(t)) return 'HeartPulse'
  return 'Sparkles'
}

const activities = ref([])
const listLoading = ref(false)
const detailOpen = ref(false)
const detailLoading = ref(false)
const selectedId = ref(null)
const detail = ref(null)
const toastOpen = ref(false)
const toastTitle = ref('')
const toastDesc = ref('')

const loadActivities = async () => {
  listLoading.value = true
  try {
    const res = await axios.get(`${API_BASE}/api/dashboard/activities`)
    if (res.data && res.data.code === 200) {
      const rows = Array.isArray(res.data.data) ? res.data.data : []
      activities.value = rows.map(r => ({
        id: Number(r.id),
        hdmc: String(r.hdmc || ''),
        bmsj: String(r.bmsj || ''),
        hdsj: String(r.hdsj || ''),
        hddd: String(r.hddd || ''),
        zyrs: String(r.zyrs || ''),
        icon: pickIcon(r.hdmc)
      }))
      updateStatuses()
    } else {
      activities.value = []
    }
  } catch (e) {
    activities.value = []
  } finally {
    listLoading.value = false
  }
}

const openDetail = async (id) => {
  selectedId.value = id
  detailOpen.value = true
  detailLoading.value = true
  detail.value = null
  try {
    const res = await axios.get(`${API_BASE}/api/dashboard/activities/${id}`)
    if (res.data && res.data.code === 200) {
      detail.value = res.data.data || null
    } else {
      detail.value = null
    }
  } catch (e) {
    detail.value = null
  } finally {
    detailLoading.value = false
  }
}

let toastTimer = null
const toastType = ref('info')
const toastIcon = computed(() => toastType.value === 'success' ? CheckCircle2 : AlertCircle)
const toastRootClass = computed(() => {
  if (toastType.value === 'success') return 'bg-emerald-50 border border-emerald-200'
  if (toastType.value === 'error') return 'bg-rose-50 border border-rose-200'
  return 'bg-white border border-slate-200'
})
const toastTitleClass = computed(() => {
  if (toastType.value === 'success') return 'font-semibold text-emerald-800'
  if (toastType.value === 'error') return 'font-semibold text-rose-800'
  return 'font-semibold text-slate-800'
})
const toastDescClass = computed(() => {
  if (toastType.value === 'success') return 'text-emerald-700 text-sm'
  if (toastType.value === 'error') return 'text-rose-700 text-sm'
  return 'text-slate-500 text-sm'
})

const showToast = (type, title, desc) => {
  toastType.value = type
  toastTitle.value = title
  toastDesc.value = desc || ''
  toastOpen.value = true
  if (toastTimer) clearTimeout(toastTimer)
  toastTimer = setTimeout(() => { toastOpen.value = false }, 2500)
}
  

const registerActivity = async (item) => {
  if (item.status === '报名未开始') return showToast('error', '报名失败', '报名未开始')
  if (item.status === '活动未开始') return showToast('error', '报名失败', '活动未开始')
  if (item.status === '活动已结束') return showToast('error', '报名失败', '活动已结束')
  if (item.status === '报名已满' || isFull(item)) return showToast('error', '报名失败', '名额已满')

  try {
    const studentId = localStorage.getItem('studentId') || '2024104'
    const res = await axios.post(`${API_BASE}/api/student/activity/register`, {
      studentId,
      activityId: item.id
    })
    
    if (res.data.code === 200) {
      showToast('success', '报名成功', `您已成功报名：${item.hdmc}`)
      // 刷新活动列表以更新状态（如名额变化）
      loadActivities()
    } else {
      showToast('error', '报名失败', res.data.message || '未知错误')
    }
  } catch (error) {
    showToast('error', '报名失败', '网络请求失败，请稍后重试')
    console.error(error)
  }
}

const toBJNow = () => {
  const now = new Date()
  return new Date(now.getTime() + (480 + now.getTimezoneOffset()) * 60000)
}

const parseDateToken = (s) => {
  const m = s.match(/(?:(\d{4})-)?(\d{2})-(\d{2})\s+(\d{2}):(\d{2})/)
  if (!m) return null
  const y = m[1] ? Number(m[1]) : undefined
  const mo = Number(m[2])
  const d = Number(m[3])
  const h = Number(m[4])
  const mi = Number(m[5])
  const year = y ?? new Date().getFullYear()
  const ms = Date.UTC(year, mo - 1, d, h - 8, mi, 0)
  return new Date(ms)
}

const parseRangeCN = (s) => {
  if (!s) return [null, null]
  const str = String(s)
  if (str.includes('至')) {
    const parts = str.split('至')
    const start = parseDateToken(parts[0].trim())
    const end = parseDateToken(parts[1].trim())
    return [start, end]
  }
  const rm = str.match(/(\d{4}-\d{2}-\d{2})\s+(\d{2}):(\d{2})\s*-\s*(\d{2}):(\d{2})/)
  if (rm) {
    const date = rm[1]
    const sH = Number(rm[2])
    const sM = Number(rm[3])
    const eH = Number(rm[4])
    const eM = Number(rm[5])
    const start = parseDateToken(`${date} ${String(sH).padStart(2,'0')}:${String(sM).padStart(2,'0')}`)
    const end = parseDateToken(`${date} ${String(eH).padStart(2,'0')}:${String(eM).padStart(2,'0')}`)
    return [start, end]
  }
  const single = parseDateToken(str.trim())
  return [single, null]
}

const statusIconMap = {
  '报名未开始': Clock,
  '报名进行中': CalendarCheck,
  '报名已结束': CalendarX,
  '活动进行中': Activity,
  '活动已结束': Flag
}

const statusClassMap = {
  '报名未开始': 'bg-slate-100 text-slate-700',
  '报名进行中': 'bg-green-100 text-green-700',
  '报名已结束': 'bg-amber-100 text-amber-700',
  '活动进行中': 'bg-emerald-100 text-emerald-700',
  '活动已结束': 'bg-slate-200 text-slate-700'
}

const computeStatus = (item) => {
  const now = toBJNow()
  const [regStart, regEnd] = parseRangeCN(item.bmsj)
  const [actStart, actEnd] = parseRangeCN(item.hdsj)
  if (regStart && now < regStart) return '报名未开始'
  if (regStart && regEnd && now >= regStart && now <= regEnd) return '报名进行中'
  if (regEnd && actStart && now > regEnd && now < actStart) return '活动未开始'
  if (actStart && actEnd && now >= actStart && now <= actEnd) return '活动进行中'
  if (actEnd && now > actEnd) return '活动已结束'
  return '报名进行中'
}

const updateStatuses = () => {
  activities.value = activities.value.map(a => {
    const s = computeStatus(a)
    return { ...a, status: s }
  })
}

let statusTimer = null
onMounted(async () => {
  await loadActivities()
  statusTimer = setInterval(updateStatuses, 60000)
})
onUnmounted(() => {
  if (statusTimer) clearInterval(statusTimer)
})
</script>

<template>
  <div class="relative">
    <ToastProvider>
      <ToastViewport class="absolute left-1/2 -translate-x-1/2 top-4 z-50" />
      <ToastRoot v-model:open="toastOpen" :class="[toastRootClass, 'rounded-md shadow-lg p-4 pr-10 flex items-start gap-3 data-[state=open]:animate-in data-[state=open]:fade-in data-[state=open]:slide-in-from-top-1 data-[state=closed]:animate-out data-[state=closed]:fade-out data-[state=closed]:slide-out-to-top-1 duration-300']">
        <component :is="toastIcon" class="w-5 h-5" />
        <div>
          <ToastTitle :class="toastTitleClass">{{ toastTitle }}</ToastTitle>
          <ToastDescription :class="toastDescClass">{{ toastDesc }}</ToastDescription>
        </div>
        <ToastClose class="absolute right-2 top-2 text-slate-400">×</ToastClose>
      </ToastRoot>
    </ToastProvider>

    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
    <Card v-for="item in activities" :key="item.id" class="group relative bg-white border border-slate-200/70 shadow-sm hover:shadow-lg rounded-2xl transition-all duration-300 hover:scale-[1.02] ring-1 ring-white/40 min-h-[260px] md:min-h-[300px]">
      <CardHeader class="pb-3 px-6 pt-5">
        <div class="flex items-center gap-3">
          <span class="inline-flex h-10 w-10 items-center justify-center rounded-full bg-gradient-to-tr from-blue-600 via-cyan-500 to-emerald-500 text-white shadow">
            <component :is="icons[item.icon]" class="w-5 h-5" />
          </span>
          <CardTitle class="text-slate-900 text-lg">{{ item.hdmc }}</CardTitle>
        </div>
      </CardHeader>
      <CardContent class="space-y-4 px-6 pb-20">
        <div class="flex items-center text-slate-700 gap-2">
          <Calendar class="w-5 h-5 text-blue-600" />
          <span class="text-[0.95rem]">{{ item.bmsj }}</span>
        </div>
        <div class="flex items-center text-slate-700 gap-2">
          <MapPin class="w-5 h-5 text-emerald-600" />
          <span class="text-[0.95rem]">{{ item.hddd }}</span>
        </div>
        <div class="flex items-center text-slate-700 gap-2">
          <Users class="w-5 h-5 text-cyan-600" />
          <span class="text-[0.95rem]">{{ item.zyrs }}</span>
        </div>
      
      </CardContent>
      <div class="absolute bottom-4 left-4 flex items-center gap-3">
        <Button variant="default" class="group gap-2" @click="openDetail(item.id)">
          <span>查看详情</span>
          <Info class="w-4 h-4 transition-transform group-hover:translate-x-0.5" />
        </Button>
        <Button variant="secondary" class="group" @click="registerActivity(item)">报名</Button>
      </div>
      <div class="absolute bottom-4 right-4">
        <span class="inline-flex items-center gap-2 rounded-full px-3 py-1.5 text-xs md:text-sm font-medium shadow-sm transition-colors duration-300" :class="statusClassMap[item.status]">
          <component :is="statusIconMap[item.status]" class="w-4 h-4" />
          <span>{{ item.status }}</span>
        </span>
      </div>
    </Card>
    </div>
  </div>

  <DialogRoot v-model:open="detailOpen">
    <DialogOverlay class="fixed inset-0 bg-slate-900/30 backdrop-blur-[6px]" />
    <DialogContent class="fixed left-1/2 top-1/2 -translate-x-1/2 -translate-y-1/2 w-[92vw] max-w-2xl bg-white/80 backdrop-blur-xl border border-white/40 rounded-xl shadow-2xl p-0 z-50">
      <div class="h-1.5 w-full bg-gradient-to-r from-blue-600 via-cyan-500 to-emerald-500 rounded-t-xl"></div>
      <div class="p-6 flex items-center gap-3">
        <span class="inline-flex h-8 w-8 items-center justify-center rounded-full bg-blue-600 text-white">
          <Info class="w-4 h-4" />
        </span>
        <DialogTitle class="text-xl font-semibold text-slate-900">活动详情</DialogTitle>
      </div>
      <DialogDescription class="px-6 -mt-2 text-slate-600 text-sm">编号 {{ detail?.id ?? selectedId }}</DialogDescription>

      <div v-if="detailLoading" class="py-12 text-center text-slate-500">加载中...</div>
      <div v-else-if="!detail" class="py-12 text-center text-red-500">未获取到详情</div>
      <div v-else class="mt-4 px-6 pb-6 grid grid-cols-1 gap-3">
        <div class="flex items-start gap-2 bg-white/70 border border-slate-200 rounded-lg p-3">
          <Sparkles class="w-4 h-4 text-indigo-600" />
          <div class="text-sm text-slate-700"><span class="font-medium">活动名称：</span>{{ detail.hdmc }}</div>
        </div>
        <div class="flex items-start gap-2 bg-white/70 border border-slate-200 rounded-lg p-3">
          <Calendar class="w-4 h-4 text-blue-600" />
          <div class="text-sm text-slate-700"><span class="font-medium">报名时间：</span>{{ detail.bmsj }}</div>
        </div>
        <div class="flex items-start gap-2 bg-white/70 border border-slate-200 rounded-lg p-3">
          <Calendar class="w-4 h-4 text-blue-600" />
          <div class="text-sm text-slate-700"><span class="font-medium">活动时间：</span>{{ detail.hdsj }}</div>
        </div>
        <div class="flex items-start gap-2 bg-white/70 border border-slate-200 rounded-lg p-3">
          <MapPin class="w-4 h-4 text-emerald-600" />
          <div class="text-sm text-slate-700"><span class="font-medium">活动地点：</span>{{ detail.hddd }}</div>
        </div>
        <div class="flex items-start gap-2 bg-white/70 border border-slate-200 rounded-lg p-3">
          <Users class="w-4 h-4 text-cyan-600" />
          <div class="text-sm text-slate-700"><span class="font-medium">招募人数：</span>{{ detail.zyrs }}</div>
        </div>
        <div class="flex items-start gap-2 bg-white/70 border border-slate-200 rounded-lg p-3">
          <BookOpen class="w-4 h-4 text-purple-600" />
          <div class="text-sm text-slate-700"><span class="font-medium">活动内容：</span>{{ detail.hdnr }}</div>
        </div>
        <div class="flex items-start gap-2 bg-white/70 border border-slate-200 rounded-lg p-3">
          <ShieldCheck class="w-4 h-4 text-rose-600" />
          <div class="text-sm text-slate-700"><span class="font-medium">活动需求条件：</span>{{ detail.hdxq }}</div>
        </div>
        <div class="flex items-start gap-2 bg-white/70 border border-slate-200 rounded-lg p-3">
          <ShieldCheck class="w-4 h-4 text-rose-600" />
          <div class="text-sm text-slate-700"><span class="font-medium">活动保障：</span>{{ detail.hdbz }}</div>
        </div>
        <div class="flex items-start gap-2 bg-white/70 border border-slate-200 rounded-lg p-3">
          <Building2 class="w-4 h-4 text-slate-700" />
          <div class="text-sm text-slate-700"><span class="font-medium">发起单位：</span>{{ detail.hdfqdw }}</div>
        </div>
        <div class="flex items-start gap-2 bg-white/70 border border-slate-200 rounded-lg p-3">
          <Sparkles class="w-4 h-4 text-indigo-600" />
          <div class="text-sm text-slate-700"><span class="font-medium">状态：</span>{{ detail.hdzt }}</div>
        </div>
      </div>

      <div class="px-6 pb-6 flex justify-end">
        <Button variant="outline" @click="detailOpen = false">关闭</Button>
      </div>
    </DialogContent>
  </DialogRoot>
</template>

<style scoped>
.radix-vue-toast-viewport {
  width: 380px;
}
</style>
