<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import CryptoJS from 'crypto-js'
import Button from '@/components/ui/button/button.vue'
import Input from '@/components/ui/input/Input.vue'
import Checkbox from '@/components/ui/checkbox/Checkbox.vue'
import { Card, CardHeader, CardTitle, CardContent, CardFooter } from '@/components/ui/card'
import { login } from '@/api/auth'

const router = useRouter()

// 响应式状态定义
const username = ref('')
const password = ref('')
const rememberMe = ref(false)
const SECRET_KEY = 'volunteer-platform-secret-key' // 实际生产环境应从环境变量获取

onMounted(() => {
  const savedInfo = localStorage.getItem('loginInfo')
  if (savedInfo) {
    try {
      const bytes = CryptoJS.AES.decrypt(savedInfo, SECRET_KEY)
      const decryptedData = JSON.parse(bytes.toString(CryptoJS.enc.Utf8))
      if (decryptedData.username && decryptedData.password) {
        username.value = decryptedData.username
        password.value = decryptedData.password
        rememberMe.value = true
      }
    } catch (e) {
      console.error('Failed to decrypt saved login info', e)
      localStorage.removeItem('loginInfo')
    }
  }
})

/**
 * 处理登录请求
 * @param role 角色类型 (student, head, admin)
 */
const handleLogin = async (role) => {
  if (!username.value || !password.value) {
    alert('请输入用户名和密码');
    return;
  }

  // 调用登录API
  const result = await login(username.value, password.value, role);
  if (result.code === 200) {
    // 登录成功
    console.log('User data:', result.data);

    // 处理记住密码逻辑
    if (rememberMe.value) {
      const loginInfo = {
        username: username.value,
        password: password.value
      }
      const encryptedData = CryptoJS.AES.encrypt(JSON.stringify(loginInfo), SECRET_KEY).toString()
      localStorage.setItem('loginInfo', encryptedData)
    } else {
      localStorage.removeItem('loginInfo')
    }

    // 根据角色处理登录后的逻辑
    if (role === 'student') {
      // 学生登录：保存信息并跳转
      localStorage.setItem('studentId', result.data.xsXh);
      localStorage.setItem('studentName', result.data.xsXm || '');
      localStorage.setItem('userRole', 'student');
      router.push('/student/dashboard');
    } else if (role === 'head') {
      // 学院/部门负责人登录：保存信息并跳转
      if (result.data.xjbmfzrXm) {
        // 校级部门负责人
        localStorage.setItem('headName', result.data.xjbmfzrXm || '负责人');
        localStorage.setItem('headDepartment', result.data.xjbmMc || '');
        localStorage.setItem('headUsername', result.data.xjbmfzrZh || '');
      } else if (result.data.xyZh) {
        // 学院负责人（通过xyZh判断是学院账号）
        localStorage.setItem('headName', result.data.fzrXm || '负责人');
        localStorage.setItem('headDepartment', result.data.xyMc || '');
        localStorage.setItem('headUsername', result.data.xyZh || '');
      }
      localStorage.setItem('userRole', 'head');
      router.push('/head/dashboard');
    } else if (role === 'admin') {
      // 超级管理员登录：保存信息并跳转到管理员端
      localStorage.setItem('adminName', result.data.glyMc || '管理员');
      localStorage.setItem('adminUsername', result.data.glyZh || '');
      localStorage.setItem('userRole', 'superadmin');
      router.push('/admin/dashboard');
    }
  } else {
    // 登录失败，显示错误信息
    alert('登录失败: ' + result.message);
  }
}
</script>

<template>
  <div class="flex min-h-screen w-full bg-slate-50">
    <!-- 左侧区域：品牌展示与美化 -->
    <div class="hidden lg:flex lg:w-[70%] relative flex-col justify-center items-center bg-slate-900 text-white overflow-hidden">
      <!-- 背景图案/渐变 -->
      <div class="absolute inset-0 bg-gradient-to-br from-blue-900 via-slate-900 to-slate-950 opacity-90"></div>
      <div class="absolute inset-0 bg-[url('https://images.unsplash.com/photo-1523050854058-8df90110c9f1?q=80&w=2070&auto=format&fit=crop')] bg-cover bg-center mix-blend-overlay opacity-20"></div>
      
      <!-- 内容区域 -->
      <div class="relative z-10 flex flex-col items-start px-12 md:px-24">
        <div class="mb-8 p-4 bg-white/10 backdrop-blur-sm rounded-2xl border border-white/10 shadow-2xl">
           <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-16 h-16 text-blue-400">
              <path stroke-linecap="round" stroke-linejoin="round" d="M4.26 10.147a60.436 60.436 0 00-.491 6.347A48.627 48.627 0 0112 20.904a48.627 48.627 0 018.232-4.41 60.46 60.46 0 00-.491-6.347m-15.482 0a50.57 50.57 0 00-2.658-.813A59.905 59.905 0 0112 3.493a59.902 59.902 0 0110.499 5.24 50.552 50.552 0 00-2.658.813m-15.482 0A50.697 50.697 0 0112 13.489a50.702 50.702 0 017.74-3.342M6.75 15a.75.75 0 100-1.5.75.75 0 000 1.5zm0 0v-3.675A55.378 55.378 0 0112 8.443m-7.007 11.55A5.981 5.981 0 006.75 15.75v-1.5" />
            </svg>
        </div>
        <h1 class="text-5xl font-bold tracking-tight mb-4 text-transparent bg-clip-text bg-gradient-to-r from-blue-100 to-white">
          高校志愿活动<br/>智能管理平台
        </h1>
        <p class="text-xl text-blue-200/80 max-w-lg">
          University Volunteer Activity Smart Management Platform
        </p>
        <div class="mt-12 flex space-x-4">
           <div class="flex items-center space-x-2 text-sm text-blue-300/60">
              <span class="w-8 h-[1px] bg-blue-300/40"></span>
              <span>Connect</span>
           </div>
           <div class="flex items-center space-x-2 text-sm text-blue-300/60">
              <span class="w-8 h-[1px] bg-blue-300/40"></span>
              <span>Serve</span>
           </div>
           <div class="flex items-center space-x-2 text-sm text-blue-300/60">
              <span class="w-8 h-[1px] bg-blue-300/40"></span>
              <span>Grow</span>
           </div>
        </div>
      </div>
      
      <div class="absolute bottom-12 left-12 text-blue-300/20 text-sm">
        Designed for University Communities
      </div>
    </div>

    <!-- 右侧区域：登录表单 -->
    <div class="flex w-full lg:w-[30%] flex-col items-center justify-center px-4 py-12 sm:px-6 lg:px-8 bg-slate-50 relative">
      <Card class="w-full max-w-sm shadow-2xl border border-slate-200 bg-white py-8">
        <CardHeader class="space-y-2 text-center pb-8">
          <CardTitle class="text-3xl font-bold tracking-tight text-slate-900">
            欢迎登录
          </CardTitle>
          <p class="text-sm text-slate-500">
            输入用户名和密码后，选择您的角色进行登录
          </p>
        </CardHeader>
        <CardContent class="grid gap-8 px-8">
          <div class="grid gap-3">
            <label for="username" class="text-sm font-medium leading-none text-slate-700">用户名 / Username</label>
            <Input id="username" v-model="username" placeholder="请输入学号/工号" class="h-11" />
          </div>
          <div class="grid gap-3">
            <label for="password" class="text-sm font-medium leading-none text-slate-700">密码 / Password</label>
            <Input id="password" type="password" v-model="password" placeholder="请输入密码" class="h-11" />
          </div>
          <div class="flex items-center space-x-2 pt-2">
            <Checkbox id="remember" v-model:checked="rememberMe" />
            <label
              for="remember"
              class="text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70 text-slate-600"
            >
              记住密码 (Remember me)
            </label>
          </div>
        </CardContent>
        <CardFooter class="flex flex-col gap-4 px-8 pt-4">
          <div class="grid grid-cols-2 gap-4 w-full">
            <Button class="w-full h-11 bg-blue-600 hover:bg-blue-700 text-base" @click="handleLogin('student')">
              学生
            </Button>
            <Button class="w-full h-11 bg-teal-600 hover:bg-teal-700 text-base" @click="handleLogin('head')">
              学院/部门负责人
            </Button>
          </div>
          <Button class="w-full h-11 bg-slate-800 hover:bg-slate-900 text-base" @click="handleLogin('admin')">
            管理员
          </Button>
        </CardFooter>
      </Card>
      
      <div class="absolute bottom-6 text-center text-xs text-slate-400">
        &copy; 2025 高校志愿活动智能管理平台
      </div>
    </div>
  </div>
</template>
