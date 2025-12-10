import { createRouter, createWebHistory } from 'vue-router'
import Login from '../views/Login.vue'

const routes = [
  {
    path: '/',
    name: 'Login',
    component: Login
  },
  {
    path: '/student/dashboard',
    name: 'StudentDashboard',
    // 路由懒加载
    component: () => import('../views/student/Dashboard.vue')
  },
  {
    path: '/admin/dashboard',
    name: 'AdminDashboard',
    // 负责人管理端路由
    component: () => import('../views/admin/Dashboard.vue')
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

export default router
