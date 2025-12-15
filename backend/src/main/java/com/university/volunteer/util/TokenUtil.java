package com.university.volunteer.util;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.util.Base64;
import java.util.Date;

/**
 * 简化版 Token 工具类
 * 用于生成和验证用户会话 Token
 * 注意：这是简化实现，生产环境建议使用 JWT 库
 */
public class TokenUtil {
    
    // 密钥（生产环境应该从配置文件读取）
    private static final String SECRET_KEY = "UniversityVolunteerSystem2025";
    
    // Token 有效期（24小时，单位：毫秒）
    private static final long EXPIRATION_TIME = 24 * 60 * 60 * 1000;
    
    /**
     * 生成 Token
     * 格式：Base64(username:role:userId:timestamp:signature)
     * @param username 用户名
     * @param role 角色
     * @param userId 用户ID
     * @return Token字符串
     */
    public static String generateToken(String username, String role, String userId) {
        long timestamp = System.currentTimeMillis();
        String data = username + ":" + role + ":" + userId + ":" + timestamp;
        String signature = generateSignature(data);
        String token = data + ":" + signature;
        return Base64.getEncoder().encodeToString(token.getBytes(StandardCharsets.UTF_8));
    }
    
    /**
     * 验证 Token
     * @param token Token字符串
     * @return 是否有效
     */
    public static boolean validateToken(String token) {
        try {
            String decoded = new String(Base64.getDecoder().decode(token), StandardCharsets.UTF_8);
            String[] parts = decoded.split(":");
            
            if (parts.length != 5) {
                return false;
            }
            
            String username = parts[0];
            String role = parts[1];
            String userId = parts[2];
            long timestamp = Long.parseLong(parts[3]);
            String signature = parts[4];
            
            // 检查是否过期
            if (System.currentTimeMillis() - timestamp > EXPIRATION_TIME) {
                return false;
            }
            
            // 验证签名
            String data = username + ":" + role + ":" + userId + ":" + timestamp;
            String expectedSignature = generateSignature(data);
            
            return signature.equals(expectedSignature);
        } catch (Exception e) {
            return false;
        }
    }
    
    /**
     * 从 Token 中获取用户名
     * @param token Token字符串
     * @return 用户名
     */
    public static String getUsernameFromToken(String token) {
        try {
            String decoded = new String(Base64.getDecoder().decode(token), StandardCharsets.UTF_8);
            String[] parts = decoded.split(":");
            return parts.length > 0 ? parts[0] : null;
        } catch (Exception e) {
            return null;
        }
    }
    
    /**
     * 从 Token 中获取角色
     * @param token Token字符串
     * @return 角色
     */
    public static String getRoleFromToken(String token) {
        try {
            String decoded = new String(Base64.getDecoder().decode(token), StandardCharsets.UTF_8);
            String[] parts = decoded.split(":");
            return parts.length > 1 ? parts[1] : null;
        } catch (Exception e) {
            return null;
        }
    }
    
    /**
     * 从 Token 中获取用户ID
     * @param token Token字符串
     * @return 用户ID
     */
    public static String getUserIdFromToken(String token) {
        try {
            String decoded = new String(Base64.getDecoder().decode(token), StandardCharsets.UTF_8);
            String[] parts = decoded.split(":");
            return parts.length > 2 ? parts[2] : null;
        } catch (Exception e) {
            return null;
        }
    }
    
    /**
     * 检查 Token 是否过期
     * @param token Token字符串
     * @return 是否过期
     */
    public static boolean isTokenExpired(String token) {
        try {
            String decoded = new String(Base64.getDecoder().decode(token), StandardCharsets.UTF_8);
            String[] parts = decoded.split(":");
            
            if (parts.length < 4) {
                return true;
            }
            
            long timestamp = Long.parseLong(parts[3]);
            return System.currentTimeMillis() - timestamp > EXPIRATION_TIME;
        } catch (Exception e) {
            return true;
        }
    }
    
    /**
     * 生成签名
     * @param data 待签名数据
     * @return 签名字符串
     */
    private static String generateSignature(String data) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            String input = data + SECRET_KEY;
            byte[] hash = md.digest(input.getBytes(StandardCharsets.UTF_8));
            return Base64.getEncoder().encodeToString(hash);
        } catch (Exception e) {
            throw new RuntimeException("生成签名失败", e);
        }
    }
}