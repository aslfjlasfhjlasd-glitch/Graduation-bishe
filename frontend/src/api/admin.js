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