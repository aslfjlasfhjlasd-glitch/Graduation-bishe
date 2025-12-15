package com.university.volunteer.util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Base64;

/**
 * 密码加密工具类
 * 使用 SHA-256 + 盐值进行密码加密和验证
 * 注意：这是简化版本，生产环境建议使用 BCrypt
 */
public class PasswordUtil {
    
    private static final String ALGORITHM = "SHA-256";
    private static final int SALT_LENGTH = 16;
    
    /**
     * 加密密码（生成盐值并加密）
     * @param rawPassword 原始密码
     * @return 加密后的密码（格式：盐值$哈希值）
     */
    public static String encode(String rawPassword) {
        if (rawPassword == null || rawPassword.isEmpty()) {
            throw new IllegalArgumentException("密码不能为空");
        }
        
        try {
            // 生成随机盐值
            SecureRandom random = new SecureRandom();
            byte[] salt = new byte[SALT_LENGTH];
            random.nextBytes(salt);
            String saltStr = Base64.getEncoder().encodeToString(salt);
            
            // 使用盐值加密密码
            String hash = hashWithSalt(rawPassword, saltStr);
            
            // 返回格式：盐值$哈希值
            return saltStr + "$" + hash;
        } catch (Exception e) {
            throw new RuntimeException("密码加密失败", e);
        }
    }
    
    /**
     * 验证密码
     * @param rawPassword 原始密码
     * @param encodedPassword 加密后的密码（格式：盐值$哈希值）
     * @return 是否匹配
     */
    public static boolean matches(String rawPassword, String encodedPassword) {
        if (rawPassword == null || encodedPassword == null) {
            return false;
        }
        
        try {
            // 解析盐值和哈希值
            String[] parts = encodedPassword.split("\\$");
            if (parts.length != 2) {
                // 如果不是加密格式，直接比较明文（兼容旧数据）
                return rawPassword.equals(encodedPassword);
            }
            
            String salt = parts[0];
            String expectedHash = parts[1];
            
            // 使用相同的盐值加密输入密码
            String actualHash = hashWithSalt(rawPassword, salt);
            
            // 比较哈希值
            return expectedHash.equals(actualHash);
        } catch (Exception e) {
            return false;
        }
    }
    
    /**
     * 使用盐值对密码进行哈希
     */
    private static String hashWithSalt(String password, String salt) {
        try {
            MessageDigest md = MessageDigest.getInstance(ALGORITHM);
            md.update(salt.getBytes());
            byte[] hashedPassword = md.digest(password.getBytes());
            return Base64.getEncoder().encodeToString(hashedPassword);
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("哈希算法不可用", e);
        }
    }
    
    /**
     * 判断密码是否已加密（包含$分隔符）
     * @param password 密码
     * @return 是否已加密
     */
    public static boolean isEncoded(String password) {
        if (password == null || password.length() < 10) {
            return false;
        }
        return password.contains("$");
    }
}