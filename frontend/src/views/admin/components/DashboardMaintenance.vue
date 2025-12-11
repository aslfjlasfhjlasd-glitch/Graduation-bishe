<script setup>
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { Settings } from 'lucide-vue-next'
</script>

<template>
  <div class="space-y-6">
    <div class="mb-8">
      <h1 class="text-3xl font-bold text-slate-800 tracking-tight">数据可视化大屏维护</h1>
      <p class="text-slate-500 mt-2 text-sm font-medium">配置和维护数据可视化大屏</p>
    </div>

    <Card class="border-slate-200 shadow-sm">
      <CardHeader class="border-b border-slate-100 bg-slate-50/50">
        <CardTitle class="flex items-center gap-2 text-slate-700">
          <Settings class="w-5 h-5 text-red-600" />
          大屏配置管理
        </CardTitle>
      </CardHeader>
      <CardContent class="p-12 text-center">
        <p class="text-slate-400 text-lg">该功能模块正在开发中...</p>
      </CardContent>
    </Card>
  </div>
</template>