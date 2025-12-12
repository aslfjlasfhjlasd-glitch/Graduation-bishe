import axios from 'axios';

// API基础URL
const API_BASE = import.meta.env.VITE_API_BASE_URL || 'http://localhost:8080';
const API_BASE_URL = `${API_BASE}/api/admin`;

// 获取志愿者审核列表
export const getVolunteerReviews = (status) => {
  return axios.get(`${API_BASE_URL}/reviews`, {
    params: { status }
  });
};

// 根据ID获取志愿者审核详情
export const getVolunteerReviewDetail = (registrationId) => {
  return axios.get(`${API_BASE_URL}/reviews/${registrationId}`);
};

// 审核通过志愿者报名
export const approveVolunteerRegistration = (registrationId) => {
  return axios.put(`${API_BASE_URL}/reviews/${registrationId}/approve`);
};

// 审核拒绝志愿者报名
export const rejectVolunteerRegistration = (registrationId, reason) => {
  return axios.put(`${API_BASE_URL}/reviews/${registrationId}/reject`, { reason });
};

// 获取所有活动列表
export const getAllActivities = () => {
  return axios.get(`${API_BASE_URL}/activities`);
};

// 发布活动
export const publishActivity = (activityId) => {
  return axios.put(`${API_BASE_URL}/activity/${activityId}/publish`);
};

// 下架活动
export const unpublishActivity = (activityId) => {
  return axios.put(`${API_BASE_URL}/activity/${activityId}/unpublish`);
};

// ==================== 配置管理 API ====================

/**
 * 获取所有配置项列表
 * @returns {Promise} 配置列表
 */
export const getConfigList = () => {
  return axios.get(`${API_BASE_URL}/config/list`);
};

/**
 * 获取所有配置项（Map格式）
 * @returns {Promise} 配置Map
 */
export const getConfigMap = () => {
  return axios.get(`${API_BASE_URL}/config/map`);
};

/**
 * 根据配置键获取配置值
 * @param {string} configKey 配置键
 * @returns {Promise} 配置值
 */
export const getConfigValue = (configKey) => {
  return axios.get(`${API_BASE_URL}/config/${configKey}`);
};

/**
 * 更新单个配置
 * @param {string} configKey 配置键
 * @param {string} configValue 配置值
 * @returns {Promise} 更新结果
 */
export const updateConfig = (configKey, configValue) => {
  return axios.put(`${API_BASE_URL}/config/${configKey}`, { configValue });
};

/**
 * 批量更新配置
 * @param {Object} configMap 配置Map对象 {key: value, ...}
 * @returns {Promise} 更新结果
 */
export const batchUpdateConfigs = (configMap) => {
  return axios.post(`${API_BASE_URL}/config/batch-update`, configMap);
};

/**
 * 添加新配置
 * @param {Object} config 配置对象
 * @returns {Promise} 添加结果
 */
export const addConfig = (config) => {
  return axios.post(`${API_BASE_URL}/config`, config);
};

// ==================== 大屏数据 API ====================

/**
 * 获取大屏综合数据
 * @returns {Promise} 大屏数据
 */
export const getDashboardData = () => {
  return axios.get(`${API_BASE}/api/dashboard/data`);
};

/**
 * 获取大屏配置信息
 * @returns {Promise} 配置信息
 */
export const getDashboardConfigs = () => {
  return axios.get(`${API_BASE}/api/dashboard/configs`);
};

// ==================== 模拟数据生成 API ====================

/**
 * 生成模拟数据
 * @param {number} count 生成数量（默认50条）
 * @returns {Promise} 生成结果
 */
export const generateMockData = (count = 50) => {
  return axios.post(`${API_BASE_URL}/mock-data/generate`, { count });
};

/**
 * 清空模拟数据
 * @returns {Promise} 清空结果
 */
export const clearMockData = () => {
  return axios.delete(`${API_BASE_URL}/mock-data/clear`);
};