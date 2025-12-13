import axios from 'axios'

const API_BASE_URL = 'http://localhost:8080/api'

/**
 * 获取推荐活动列表
 * @param {number} studentId - 学生学号
 * @returns {Promise} 推荐活动列表
 */
export const getRecommendedActivities = (studentId) => {
  return axios.get(`${API_BASE_URL}/student/activity/recommend`, {
    params: { studentId }
  })
}