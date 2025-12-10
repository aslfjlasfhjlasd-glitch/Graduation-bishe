<script setup>
import { ref, onMounted, computed } from 'vue'
import axios from 'axios'
import Button from '@/components/ui/button/button.vue'
import Input from '@/components/ui/input/Input.vue'
import { Card, CardHeader, CardTitle, CardContent } from '@/components/ui/card'
import { User, Phone, Award, Tag, FileText, Save, AlertCircle, CheckCircle2, Info, X } from 'lucide-vue-next'

const API_BASE = import.meta.env.VITE_API_BASE_URL || 'http://localhost:8080'

// 学生信息
const studentInfo = ref({
  xsXh: null,
  xsXm: '',
  xsXb: '',
  zzmm: '',
  xsDh: '',
  ssXy: '',
  bjMc: '',
  xqBq: '',
  jnBq: '',
  grjj: ''
})

// 预设标签选项
const interestOptions = [
  '环保公益', '教育支教', '社区服务', '文化传承',
  '体育健康', '科技创新', '艺术表演', '国际交流',
  '敬老助残', '应急救援'
]

const skillOptions = [
  '组织协调', '沟通表达', '文案写作', '摄影摄像',
  '外语翻译', '计算机技能', '医疗急救', '文艺表演',
  '体育运动', '手工制作'
]

// 政治面貌选项
const politicalStatusOptions = [
  '群众', '共青团员', '中共党员'
]

// 选中的标签
const selectedInterests = ref([])
const selectedSkills = ref([])

// 自定义标签输入
const customInterest = ref('')
const customSkill = ref('')

// 加载状态
const loading = ref(false)
const saving = ref(false)

// 提示信息
const toast = ref({
  show: false,
  type: 'info', // 'success', 'error', 'info'
  message: ''
})

// 表单验证错误
const errors = ref({
  xsDh: '',
  zzmm: ''
})

// 显示提示
const showToast = (type, message) => {
  toast.value = { show: true, type, message }
  setTimeout(() => {
    toast.value.show = false
  }, 3000)
}

// 加载学生信息
const loadStudentInfo = async () => {
  loading.value = true
  try {
    // 从localStorage获取学号（登录时应该存储）
    const studentId = localStorage.getItem('studentId') || 2024104
    
    const response = await axios.get(`${API_BASE}/api/student/profile`, {
      params: { studentId }
    })
    
    if (response.data.code === 200) {
      studentInfo.value = response.data.data
      
      // 解析标签（假设标签以逗号分隔存储）
      if (studentInfo.value.xqBq) {
        selectedInterests.value = studentInfo.value.xqBq.split(',').filter(t => t.trim())
      }
      if (studentInfo.value.jnBq) {
        selectedSkills.value = studentInfo.value.jnBq.split(',').filter(t => t.trim())
      }
    } else {
      showToast('error', '加载学生信息失败：' + response.data.message)
    }
  } catch (error) {
    console.error('加载学生信息失败', error)
    showToast('error', '加载学生信息失败，请稍后重试')
  } finally {
    loading.value = false
  }
}

// 切换兴趣标签
const toggleInterest = (interest) => {
  const index = selectedInterests.value.indexOf(interest)
  if (index > -1) {
    selectedInterests.value.splice(index, 1)
  } else {
    selectedInterests.value.push(interest)
  }
}

// 切换技能标签
const toggleSkill = (skill) => {
  const index = selectedSkills.value.indexOf(skill)
  if (index > -1) {
    selectedSkills.value.splice(index, 1)
  } else {
    selectedSkills.value.push(skill)
  }
}

// 添加自定义兴趣标签
const addCustomInterest = () => {
  if (customInterest.value.trim() && !selectedInterests.value.includes(customInterest.value.trim())) {
    selectedInterests.value.push(customInterest.value.trim())
    customInterest.value = ''
  }
}

// 添加自定义技能标签
const addCustomSkill = () => {
  if (customSkill.value.trim() && !selectedSkills.value.includes(customSkill.value.trim())) {
    selectedSkills.value.push(customSkill.value.trim())
    customSkill.value = ''
  }
}

// 移除兴趣标签
const removeInterest = (interest) => {
  const index = selectedInterests.value.indexOf(interest)
  if (index > -1) {
    selectedInterests.value.splice(index, 1)
  }
}

// 移除技能标签
const removeSkill = (skill) => {
  const index = selectedSkills.value.indexOf(skill)
  if (index > -1) {
    selectedSkills.value.splice(index, 1)
  }
}

// 验证联系电话
const validatePhone = () => {
  if (!studentInfo.value.xsDh) {
    errors.value.xsDh = ''
    return true
  }
  const phoneRegex = /^1[3-9]\d{9}$/
  if (!phoneRegex.test(studentInfo.value.xsDh)) {
    errors.value.xsDh = '请输入正确的手机号码格式'
    return false
  }
  errors.value.xsDh = ''
  return true
}

// 验证政治面貌
const validatePoliticalStatus = () => {
  if (!studentInfo.value.zzmm) {
    errors.value.zzmm = ''
    return true
  }
  if (!politicalStatusOptions.includes(studentInfo.value.zzmm)) {
    errors.value.zzmm = '请选择有效的政治面貌'
    return false
  }
  errors.value.zzmm = ''
  return true
}

// 保存个人信息
const saveProfile = async () => {
  // 验证表单
  const isPhoneValid = validatePhone()
  const isPoliticalStatusValid = validatePoliticalStatus()
  
  if (!isPhoneValid || !isPoliticalStatusValid) {
    showToast('error', '请检查表单填写是否正确')
    return
  }
  
  saving.value = true
  try {
    // 将标签数组转换为逗号分隔的字符串
    const dataToSave = {
      xsXh: studentInfo.value.xsXh,
      zzmm: studentInfo.value.zzmm,
      xsDh: studentInfo.value.xsDh,
      xqBq: selectedInterests.value.join(','),
      jnBq: selectedSkills.value.join(','),
      grjj: studentInfo.value.grjj
    }
    
    const response = await axios.put(`${API_BASE}/api/student/profile`, dataToSave)
    
    if (response.data.code === 200) {
      showToast('success', '个人信息保存成功')
      // 重新加载信息以确保数据同步
      await loadStudentInfo()
    } else {
      showToast('error', '保存失败：' + response.data.message)
    }
  } catch (error) {
    console.error('保存个人信息失败', error)
    showToast('error', '保存失败，请稍后重试')
  } finally {
    saving.value = false
  }
}

// 性别显示
const genderDisplay = computed(() => {
  return studentInfo.value.xsXb === '1' ? '男' : studentInfo.value.xsXb === '0' ? '女' : '未知'
})

onMounted(() => {
  loadStudentInfo()
})
</script>

<template>
  <div class="space-y-6 animate-in fade-in duration-500">
    <!-- Toast 提示 -->
    <Transition name="toast">
      <div v-if="toast.show" 
           :class="[
             'fixed left-1/2 -translate-x-1/2 top-20 z-50 rounded-lg shadow-lg p-4 pr-10 flex items-start gap-3 min-w-[320px]',
             toast.type === 'success' ? 'bg-emerald-50 border border-emerald-200' : '',
             toast.type === 'error' ? 'bg-rose-50 border border-rose-200' : '',
             toast.type === 'info' ? 'bg-blue-50 border border-blue-200' : ''
           ]">
        <component :is="toast.type === 'success' ? CheckCircle2 : AlertCircle" 
                   :class="[
                     'w-5 h-5',
                     toast.type === 'success' ? 'text-emerald-600' : '',
                     toast.type === 'error' ? 'text-rose-600' : '',
                     toast.type === 'info' ? 'text-blue-600' : ''
                   ]" />
        <div>
          <div :class="[
            'font-semibold',
            toast.type === 'success' ? 'text-emerald-800' : '',
            toast.type === 'error' ? 'text-rose-800' : '',
            toast.type === 'info' ? 'text-blue-800' : ''
          ]">{{ toast.message }}</div>
        </div>
      </div>
    </Transition>

    <!-- 页面标题 -->
    <div class="mb-8">
      <h1 class="text-3xl font-bold text-slate-800 tracking-tight">个人信息</h1>
      <p class="text-slate-500 mt-2 text-sm font-medium flex items-center gap-2">
        <Info class="w-4 h-4" />
        您可以编辑政治面貌、联系电话、兴趣标签、技能标签和个人简介
      </p>
    </div>

    <!-- 加载状态 -->
    <div v-if="loading" class="flex justify-center items-center py-20">
      <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600"></div>
    </div>

    <!-- 主要内容 -->
    <div v-else class="grid gap-6">
      
      <!-- 基本信息卡片 -->
      <Card class="hover:shadow-lg transition-shadow duration-300">
        <CardHeader>
          <CardTitle class="flex items-center gap-2 text-xl">
            <User class="w-5 h-5 text-blue-600" />
            基本信息
          </CardTitle>
        </CardHeader>
        <CardContent class="grid gap-6 md:grid-cols-2">
          <!-- 学号（只读） -->
          <div class="space-y-2">
            <label class="text-sm font-medium text-slate-700">学号</label>
            <Input :model-value="studentInfo.xsXh" disabled class="bg-slate-50 text-slate-600" />
          </div>

          <!-- 姓名（只读） -->
          <div class="space-y-2">
            <label class="text-sm font-medium text-slate-700">姓名</label>
            <Input :model-value="studentInfo.xsXm" disabled class="bg-slate-50 text-slate-600" />
          </div>

          <!-- 性别（只读） -->
          <div class="space-y-2">
            <label class="text-sm font-medium text-slate-700">性别</label>
            <Input :model-value="genderDisplay" disabled class="bg-slate-50 text-slate-600" />
          </div>

          <!-- 所属学院（只读） -->
          <div class="space-y-2">
            <label class="text-sm font-medium text-slate-700">所属学院</label>
            <Input :model-value="studentInfo.ssXy" disabled class="bg-slate-50 text-slate-600" />
          </div>

          <!-- 班级（只读） -->
          <div class="space-y-2">
            <label class="text-sm font-medium text-slate-700">班级</label>
            <Input :model-value="studentInfo.bjMc" disabled class="bg-slate-50 text-slate-600" />
          </div>

          <!-- 政治面貌（可编辑） -->
          <div class="space-y-2">
            <label class="text-sm font-medium text-slate-700">政治面貌 <span class="text-rose-500">*</span></label>
            <select 
              v-model="studentInfo.zzmm" 
              @change="validatePoliticalStatus"
              class="flex h-11 w-full rounded-md border border-slate-200 bg-white px-3 py-2 text-sm ring-offset-white file:border-0 file:bg-transparent file:text-sm file:font-medium placeholder:text-slate-500 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-blue-600 focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50"
            >
              <option value="">请选择政治面貌</option>
              <option v-for="option in politicalStatusOptions" :key="option" :value="option">
                {{ option }}
              </option>
            </select>
            <p v-if="errors.zzmm" class="text-xs text-rose-600 flex items-center gap-1">
              <AlertCircle class="w-3 h-3" />
              {{ errors.zzmm }}
            </p>
          </div>

          <!-- 联系电话（可编辑） -->
          <div class="space-y-2 md:col-span-2">
            <label class="text-sm font-medium text-slate-700 flex items-center gap-2">
              <Phone class="w-4 h-4" />
              联系电话 <span class="text-rose-500">*</span>
            </label>
            <Input 
              v-model="studentInfo.xsDh" 
              placeholder="请输入11位手机号码"
              @blur="validatePhone"
              class="h-11"
            />
            <p v-if="errors.xsDh" class="text-xs text-rose-600 flex items-center gap-1">
              <AlertCircle class="w-3 h-3" />
              {{ errors.xsDh }}
            </p>
          </div>
        </CardContent>
      </Card>

      <!-- 兴趣标签卡片 -->
      <Card class="hover:shadow-lg transition-shadow duration-300">
        <CardHeader>
          <CardTitle class="flex items-center gap-2 text-xl">
            <Tag class="w-5 h-5 text-purple-600" />
            兴趣标签
          </CardTitle>
          <p class="text-sm text-slate-500 mt-2">选择或添加您感兴趣的志愿活动类型</p>
        </CardHeader>
        <CardContent class="space-y-4">
          <!-- 预设标签选项 -->
          <div class="flex flex-wrap gap-2">
            <button
              v-for="interest in interestOptions"
              :key="interest"
              @click="toggleInterest(interest)"
              :class="[
                'px-4 py-2 rounded-full text-sm font-medium transition-all duration-200',
                selectedInterests.includes(interest)
                  ? 'bg-purple-600 text-white shadow-md hover:bg-purple-700'
                  : 'bg-slate-100 text-slate-700 hover:bg-slate-200'
              ]"
            >
              {{ interest }}
            </button>
          </div>

          <!-- 自定义标签输入 -->
          <div class="flex gap-2">
            <Input 
              v-model="customInterest" 
              placeholder="输入自定义兴趣标签"
              @keyup.enter="addCustomInterest"
              class="flex-1"
            />
            <Button @click="addCustomInterest" variant="outline">添加</Button>
          </div>

          <!-- 已选标签显示 -->
          <div v-if="selectedInterests.length > 0" class="space-y-2">
            <p class="text-sm font-medium text-slate-700">已选标签：</p>
            <div class="flex flex-wrap gap-2">
              <span
                v-for="interest in selectedInterests"
                :key="interest"
                class="inline-flex items-center gap-1 px-3 py-1 rounded-full text-sm bg-purple-100 text-purple-700"
              >
                {{ interest }}
                <button @click="removeInterest(interest)" class="hover:text-purple-900">
                  <X class="w-3 h-3" />
                </button>
              </span>
            </div>
          </div>
        </CardContent>
      </Card>

      <!-- 技能标签卡片 -->
      <Card class="hover:shadow-lg transition-shadow duration-300">
        <CardHeader>
          <CardTitle class="flex items-center gap-2 text-xl">
            <Award class="w-5 h-5 text-emerald-600" />
            技能标签
          </CardTitle>
          <p class="text-sm text-slate-500 mt-2">选择或添加您擅长的技能</p>
        </CardHeader>
        <CardContent class="space-y-4">
          <!-- 预设标签选项 -->
          <div class="flex flex-wrap gap-2">
            <button
              v-for="skill in skillOptions"
              :key="skill"
              @click="toggleSkill(skill)"
              :class="[
                'px-4 py-2 rounded-full text-sm font-medium transition-all duration-200',
                selectedSkills.includes(skill)
                  ? 'bg-emerald-600 text-white shadow-md hover:bg-emerald-700'
                  : 'bg-slate-100 text-slate-700 hover:bg-slate-200'
              ]"
            >
              {{ skill }}
            </button>
          </div>

          <!-- 自定义标签输入 -->
          <div class="flex gap-2">
            <Input 
              v-model="customSkill" 
              placeholder="输入自定义技能标签"
              @keyup.enter="addCustomSkill"
              class="flex-1"
            />
            <Button @click="addCustomSkill" variant="outline">添加</Button>
          </div>

          <!-- 已选标签显示 -->
          <div v-if="selectedSkills.length > 0" class="space-y-2">
            <p class="text-sm font-medium text-slate-700">已选标签：</p>
            <div class="flex flex-wrap gap-2">
              <span
                v-for="skill in selectedSkills"
                :key="skill"
                class="inline-flex items-center gap-1 px-3 py-1 rounded-full text-sm bg-emerald-100 text-emerald-700"
              >
                {{ skill }}
                <button @click="removeSkill(skill)" class="hover:text-emerald-900">
                  <X class="w-3 h-3" />
                </button>
              </span>
            </div>
          </div>
        </CardContent>
      </Card>

      <!-- 个人简介卡片 -->
      <Card class="hover:shadow-lg transition-shadow duration-300">
        <CardHeader>
          <CardTitle class="flex items-center gap-2 text-xl">
            <FileText class="w-5 h-5 text-blue-600" />
            个人简介
          </CardTitle>
          <p class="text-sm text-slate-500 mt-2">介绍一下您自己，最多500字</p>
        </CardHeader>
        <CardContent>
          <textarea
            v-model="studentInfo.grjj"
            placeholder="请输入个人简介，包括您的特长、经历、志愿服务意愿等..."
            maxlength="500"
            rows="8"
            class="flex w-full rounded-md border border-slate-200 bg-white px-3 py-2 text-sm ring-offset-white placeholder:text-slate-500 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-blue-600 focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50 resize-none"
          ></textarea>
          <p class="text-xs text-slate-500 mt-2 text-right">
            {{ studentInfo.grjj?.length || 0 }} / 500
          </p>
        </CardContent>
      </Card>

      <!-- 保存按钮 -->
      <div class="flex justify-end gap-4">
        <Button 
          @click="saveProfile" 
          :disabled="saving"
          class="gap-2 px-8 h-11 text-base"
        >
          <Save class="w-4 h-4" />
          {{ saving ? '保存中...' : '保存信息' }}
        </Button>
      </div>
    </div>
  </div>
</template>

<style scoped>
/* Toast 动画 */
.toast-enter-active,
.toast-leave-active {
  transition: all 0.3s ease;
}

.toast-enter-from {
  opacity: 0;
  transform: translate(-50%, -20px);
}

.toast-leave-to {
  opacity: 0;
  transform: translate(-50%, -20px);
}
</style>
