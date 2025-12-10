<script setup>
import { onMounted, ref, onUnmounted } from 'vue'
import axios from 'axios'
const API_BASE = import.meta.env.VITE_API_BASE_URL || 'http://localhost:8080'
import { Card, CardContent } from '@/components/ui/card'
import { 
  Activity, 
  Users, 
  Clock,
  TrendingUp,
  PieChart,
  BarChart
} from 'lucide-vue-next'

// DOM 引用
const lineChartRef = ref(null)
const pieChartRef = ref(null)
const barChartRef = ref(null)

// 图表实例
let lineChart = null
let pieChart = null
let barChart = null

// 模拟数据
const metrics = {
  totalActivities: 128,
  activeVolunteers: 356,
  totalHours: 12450
}

// 初始化折线图
const initLineChart = async () => {
  if (!lineChartRef.value) return
  
  const echarts = await import('echarts')
  lineChart = echarts.init(lineChartRef.value)
  const option = {
    tooltip: {
      trigger: 'axis'
    },
    legend: {
      data: ['活动数量', '参与人数'],
      bottom: 0
    },
    grid: {
      left: '3%',
      right: '4%',
      bottom: '10%',
      containLabel: true
    },
    xAxis: {
      type: 'category',
      boundaryGap: false,
      data: ['7月', '8月', '9月', '10月', '11月', '12月']
    },
    yAxis: {
      type: 'value'
    },
    series: [
      {
        name: '活动数量',
        type: 'line',
        smooth: true,
        data: [12, 15, 25, 30, 28, 35],
        itemStyle: { color: '#2563eb' },
        areaStyle: {
          color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
            { offset: 0, color: 'rgba(37, 99, 235, 0.3)' },
            { offset: 1, color: 'rgba(37, 99, 235, 0)' }
          ])
        }
      },
      {
        name: '参与人数',
        type: 'line',
        smooth: true,
        data: [120, 150, 380, 420, 390, 510],
        itemStyle: { color: '#10b981' },
        areaStyle: {
          color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
            { offset: 0, color: 'rgba(16, 185, 129, 0.3)' },
            { offset: 1, color: 'rgba(16, 185, 129, 0)' }
          ])
        }
      }
    ]
  }
  lineChart.setOption(option)
}

// 初始化饼图 (各学院参与度)
const initPieChart = async () => {
  if (!pieChartRef.value) return
  
  const echarts = await import('echarts')
  pieChart = echarts.init(pieChartRef.value)
  
  // 加载中状态
  try { pieChart.showLoading({ text: '加载中...', color: '#6b7280' }) } catch {}

  try {
    // 从后端获取数据
    const response = await axios.get(`${API_BASE}/api/dashboard/academy-stats`)
    let data = []
    
    if (response.data.code === 200) {
      // 规整数据格式，确保名称与数值类型正确
      const raw = Array.isArray(response.data.data) ? response.data.data : []
      data = raw.map((item) => ({
        name: String(item.name ?? ''),
        value: Number(item.value ?? 0)
      }))
    } else {
      console.error('获取学院数据失败:', response.data.message)
    }

    const option = {
      tooltip: {
        trigger: 'item',
        formatter: '{b}: {c} ({d}%)'
      },
      // 移除图例 (legend)
      legend: {
        show: false
      },
      series: [
        {
          name: '参与度占比',
          type: 'pie',
          radius: ['40%', '70%'],
          avoidLabelOverlap: false,
          itemStyle: {
            borderRadius: 10,
            borderColor: '#fff',
            borderWidth: 2
          },
          label: {
            show: false,
            position: 'center'
          },
          emphasis: {
            label: {
              show: true,
              fontSize: 16,
              fontWeight: 'bold'
            }
          },
          labelLine: {
            show: false
          },
          data: data
        }
      ]
    }
    pieChart.setOption(option)
    try { pieChart.hideLoading() } catch {}
    
  } catch (error) {
    console.error('学院参与度接口异常', {
      message: error?.message,
      status: error?.response?.status,
      data: error?.response?.data
    })
    try { pieChart.hideLoading() } catch {}
    pieChart.setOption({
      title: {
        text: '数据加载失败',
        left: 'center',
        top: 'center',
        textStyle: { color: 'red' }
      },
      series: [
        {
          type: 'pie',
          data: []
        }
      ]
    })
  }
}

// 初始化柱状图 (垂直方向)
const initBarChart = async () => {
  if (!barChartRef.value) return
  
  const echarts = await import('echarts')
  barChart = echarts.init(barChartRef.value)
  const option = {
    tooltip: {
      trigger: 'axis',
      axisPointer: {
        type: 'shadow'
      }
    },
    grid: {
      left: '3%',
      right: '4%',
      bottom: '3%',
      containLabel: true
    },
    // 交换 X 轴和 Y 轴配置
    xAxis: {
      type: 'category',
      data: ['7月', '8月', '9月', '10月', '11月', '12月'],
      axisLabel: {
        interval: 0
      }
    },
    yAxis: {
      type: 'value',
      axisLabel: {
        formatter: '{value}%'
      }
    },
    series: [
      {
        name: '参与率',
        type: 'bar',
        barWidth: '40%', // 优化柱子宽度
        data: [65, 70, 85, 88, 82, 92],
        itemStyle: {
          color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
            { offset: 0, color: '#6366f1' },
            { offset: 1, color: '#8b5cf6' }
          ]),
          borderRadius: [4, 4, 0, 0] // 顶部圆角
        },
        label: {
          show: true,
          position: 'top', // 标签显示在顶部
          formatter: '{c}%'
        }
      }
    ]
  }
  barChart.setOption(option)
}

// 窗口大小改变时重绘图表
const handleResize = () => {
  lineChart?.resize()
  pieChart?.resize()
  barChart?.resize()
}

onMounted(async () => {
  await initLineChart()
  await initPieChart()
  await initBarChart()
  window.addEventListener('resize', handleResize)
})

onUnmounted(() => {
  window.removeEventListener('resize', handleResize)
  lineChart?.dispose()
  pieChart?.dispose()
  barChart?.dispose()
})
</script>

<template>
  <div class="space-y-6 animate-in fade-in duration-500">
    <!-- 1. 标题区域 -->
    <div class="mb-8">
      <h1 class="text-3xl font-bold text-slate-800 tracking-tight">志愿活动数据可视化大屏</h1>
      <p class="text-slate-500 mt-2 text-sm font-medium">实时数据查看与分析</p>
    </div>

    <!-- 2. 顶部指标卡片 -->
    <div class="grid gap-6 md:grid-cols-3">
      <!-- 卡片1：累计活动数量 -->
      <Card class="hover:shadow-lg transition-shadow duration-300 border-l-4 border-l-blue-500">
        <CardContent class="p-6">
          <div class="flex items-center justify-between">
            <div>
              <p class="text-sm font-medium text-slate-500">累计活动数量</p>
              <div class="mt-2 flex items-baseline gap-2">
                <span class="text-3xl font-bold text-slate-800">{{ metrics.totalActivities }}</span>
                <span class="text-xs text-green-600 font-medium">+12%</span>
              </div>
            </div>
            <div class="p-3 bg-blue-50 rounded-xl">
              <Activity class="w-6 h-6 text-blue-600" />
            </div>
          </div>
        </CardContent>
      </Card>

      <!-- 卡片2：活跃志愿者 -->
      <Card class="hover:shadow-lg transition-shadow duration-300 border-l-4 border-l-purple-500">
        <CardContent class="p-6">
          <div class="flex items-center justify-between">
            <div>
              <p class="text-sm font-medium text-slate-500">活跃志愿者</p>
              <div class="mt-2 flex items-baseline gap-2">
                <span class="text-3xl font-bold text-slate-800">{{ metrics.activeVolunteers }}</span>
                <span class="relative flex h-2 w-2">
                  <span class="animate-ping absolute inline-flex h-full w-full rounded-full bg-green-400 opacity-75"></span>
                  <span class="relative inline-flex rounded-full h-2 w-2 bg-green-500"></span>
                </span>
              </div>
            </div>
            <div class="p-3 bg-purple-50 rounded-xl">
              <Users class="w-6 h-6 text-purple-600" />
            </div>
          </div>
        </CardContent>
      </Card>

      <!-- 卡片3：累计活动时长 -->
      <Card class="hover:shadow-lg transition-shadow duration-300 border-l-4 border-l-emerald-500">
        <CardContent class="p-6">
          <div class="flex items-center justify-between">
            <div>
              <p class="text-sm font-medium text-slate-500">累计活动时长</p>
              <div class="mt-2 flex items-baseline gap-2">
                <span class="text-3xl font-bold text-slate-800">{{ (metrics.totalHours / 1000).toFixed(1) }}k</span>
                <span class="text-sm text-slate-400">小时</span>
              </div>
            </div>
            <div class="p-3 bg-emerald-50 rounded-xl">
              <Clock class="w-6 h-6 text-emerald-600" />
            </div>
          </div>
        </CardContent>
      </Card>
    </div>

    <!-- 3. 中间趋势分析区域 -->
    <div class="grid gap-6 md:grid-cols-12 h-[400px]">
      <!-- 左侧卡片 (60%) -->
      <Card class="md:col-span-7 lg:col-span-8 hover:shadow-lg transition-shadow duration-300 flex flex-col">
        <CardContent class="p-6 flex-1 flex flex-col">
          <div class="flex items-center gap-2 mb-4">
            <TrendingUp class="w-5 h-5 text-blue-600" />
            <h3 class="text-lg font-semibold text-slate-800">近半年活动趋势</h3>
          </div>
          <div ref="lineChartRef" class="w-full flex-1 min-h-[300px]"></div>
        </CardContent>
      </Card>

      <!-- 右侧卡片 (40%) -->
      <Card class="md:col-span-5 lg:col-span-4 hover:shadow-lg transition-shadow duration-300 flex flex-col">
        <CardContent class="p-6 flex-1 flex flex-col">
          <div class="flex items-center gap-2 mb-4">
            <PieChart class="w-5 h-5 text-purple-600" />
            <h3 class="text-lg font-semibold text-slate-800">各学院参与度占比</h3>
          </div>
          <div ref="pieChartRef" class="w-full flex-1 min-h-[300px]"></div>
        </CardContent>
      </Card>
    </div>

    <!-- 4. 底部分析卡片 -->
    <Card class="hover:shadow-lg transition-shadow duration-300">
      <CardContent class="p-6">
        <div class="flex items-center justify-between mb-6">
          <div class="flex items-center gap-2">
            <BarChart class="w-5 h-5 text-indigo-600" />
            <h3 class="text-lg font-semibold text-slate-800">近半年活动参与率</h3>
          </div>
          <!-- 简单的筛选器示例 -->
          <select class="text-sm border-slate-200 rounded-md shadow-sm focus:border-blue-500 focus:ring-blue-500">
            <option>最近6个月</option>
            <option>最近12个月</option>
          </select>
        </div>
        <div ref="barChartRef" class="w-full h-[300px]"></div>
      </CardContent>
    </Card>
  </div>
</template>
