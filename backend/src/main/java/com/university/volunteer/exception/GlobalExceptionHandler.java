package com.university.volunteer.exception;

import com.university.volunteer.common.Result;
import org.springframework.dao.DataAccessException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.servlet.NoHandlerFoundException;

import jakarta.servlet.http.HttpServletRequest;

/**
 * 全局异常处理器
 * 统一处理系统中的各类异常，返回标准化的错误响应
 */
@RestControllerAdvice
public class GlobalExceptionHandler {

    /**
     * 处理空指针异常
     */
    @ExceptionHandler(NullPointerException.class)
    public ResponseEntity<Result<String>> handleNullPointerException(NullPointerException e, HttpServletRequest request) {
        logError("空指针异常", e, request);
        return ResponseEntity
                .status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(Result.error("系统内部错误：数据为空"));
    }

    /**
     * 处理数据库访问异常
     */
    @ExceptionHandler(DataAccessException.class)
    public ResponseEntity<Result<String>> handleDataAccessException(DataAccessException e, HttpServletRequest request) {
        logError("数据库访问异常", e, request);
        return ResponseEntity
                .status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(Result.error("数据库操作失败，请稍后重试"));
    }

    /**
     * 处理非法参数异常
     */
    @ExceptionHandler(IllegalArgumentException.class)
    public ResponseEntity<Result<String>> handleIllegalArgumentException(IllegalArgumentException e, HttpServletRequest request) {
        logError("非法参数异常", e, request);
        return ResponseEntity
                .status(HttpStatus.BAD_REQUEST)
                .body(Result.error("参数错误：" + e.getMessage()));
    }

    /**
     * 处理404异常
     */
    @ExceptionHandler(NoHandlerFoundException.class)
    public ResponseEntity<Result<String>> handleNoHandlerFoundException(NoHandlerFoundException e, HttpServletRequest request) {
        logError("404异常", e, request);
        return ResponseEntity
                .status(HttpStatus.NOT_FOUND)
                .body(Result.error("请求的资源不存在"));
    }

    /**
     * 处理运行时异常
     */
    @ExceptionHandler(RuntimeException.class)
    public ResponseEntity<Result<String>> handleRuntimeException(RuntimeException e, HttpServletRequest request) {
        logError("运行时异常", e, request);
        return ResponseEntity
                .status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(Result.error("系统运行异常：" + e.getMessage()));
    }

    /**
     * 处理所有未捕获的异常
     */
    @ExceptionHandler(Exception.class)
    public ResponseEntity<Result<String>> handleException(Exception e, HttpServletRequest request) {
        logError("未知异常", e, request);
        return ResponseEntity
                .status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(Result.error("系统异常，请联系管理员"));
    }

    /**
     * 记录错误日志
     */
    private void logError(String errorType, Exception e, HttpServletRequest request) {
        System.err.println("=== " + errorType + " ===");
        System.err.println("请求路径: " + request.getRequestURI());
        System.err.println("请求方法: " + request.getMethod());
        System.err.println("异常信息: " + e.getMessage());
        e.printStackTrace();
        System.err.println("==================");
    }
}