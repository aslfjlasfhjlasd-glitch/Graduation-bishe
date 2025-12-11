package com.university.volunteer.mapper;

import com.university.volunteer.dto.ActivityPerformanceDTO;
import com.university.volunteer.entity.ActivityRegistration;
import com.university.volunteer.entity.VolunteerActivity;
import org.apache.ibatis.annotations.*;

import java.util.List;

@Mapper
public interface StudentActivityMapper {

    @Select("SELECT HD_BH as activityId, HD_MC as activityName, HD_SJ as activityTime, HD_DD as activityLocation, BM_ZT as status " +
            "FROM t_zyhdbmb " +
            "WHERE XS_XH = #{studentId}")
    List<ActivityRegistration> selectRegistrationsByStudentId(String studentId);

    @Select("SELECT HD_BH as activityId, HD_MC as activityName, HD_SJ as activityTime, " +
            "HD_SC as duration, HD_XF as credits " +
            "FROM t_zyhdbmb " +
            "WHERE XS_XH = #{studentId} AND BM_ZT = '已审核通过'")
    List<ActivityPerformanceDTO> selectPerformanceByStudentId(String studentId);

    /**
     * 根据ID获取活动信息
     */
    @Select("SELECT HD_BH as hdBh, HD_MC as hdMc, " +
            "CONCAT(DATE_FORMAT(BM_KSSJ, '%Y-%m-%d %H:%i'), '至', DATE_FORMAT(BM_JSSJ, '%Y-%m-%d %H:%i')) as bmSj, " +
            "CONCAT(DATE_FORMAT(HD_KSSJ, '%Y-%m-%d %H:%i'), '-', DATE_FORMAT(HD_JSSJ, '%Y-%m-%d %H:%i')) as hdSj, " +
            "BM_KSSJ as bmKssj, BM_JSSJ as bmJssj, HD_KSSJ as hdKssj, HD_JSSJ as hdJssj, " +
            "HD_NR as hdNr, " +
            "HD_DD as hdDd, ZM_RS as zmRs, HDXQ as hdXq, " +
            "HD_BZ as hdBz, HD_FQ_DW as hdFqDw, HD_ZT as hdZt, FB_ZT as fbZt " +
            "FROM t_zyhd WHERE HD_BH = #{activityId}")
    VolunteerActivity findActivityById(Integer activityId);

    /**
     * 检查是否已报名
     */
    @Select("SELECT COUNT(*) FROM t_zyhdbmb WHERE XS_XH = #{studentId} AND HD_BH = #{activityId}")
    int countRegistration(@Param("studentId") String studentId, @Param("activityId") Integer activityId);

    /**
     * 统计活动已报名人数
     */
    @Select("SELECT COUNT(*) FROM t_zyhdbmb WHERE HD_BH = #{activityId}")
    int countRegistrationsByActivityId(@Param("activityId") Integer activityId);

    /**
     * 插入报名记录
     */
    @Insert("INSERT INTO t_zyhdbmb (XS_XH, XS_XM, SS_XY, HD_BH, HD_MC, HD_SJ, HD_DD, BM_ZT) " +
            "VALUES (#{studentId}, #{studentName}, #{academyName}, #{activityId}, #{activityName}, #{activityTime}, #{activityLocation}, #{status})")
    int insertRegistration(ActivityRegistration registration);

    /**
     * 更新活动已报名人数（YBM_RS字段）
     */
    @Update("UPDATE t_zyhd SET YBM_RS = (SELECT COUNT(*) FROM t_zyhdbmb WHERE HD_BH = #{activityId}) WHERE HD_BH = #{activityId}")
    int updateRegisteredCount(@Param("activityId") Integer activityId);

    /**
     * 删除报名记录（取消报名）
     */
    @Delete("DELETE FROM t_zyhdbmb WHERE XS_XH = #{studentId} AND HD_BH = #{activityId}")
    int deleteRegistration(@Param("studentId") String studentId, @Param("activityId") Integer activityId);

    /**
     * 根据活动发起单位查询活动列表
     */
    @Select("SELECT HD_BH as hdBh, HD_MC as hdMc, " +
            "CONCAT(DATE_FORMAT(BM_KSSJ, '%Y-%m-%d %H:%i'), '至', DATE_FORMAT(BM_JSSJ, '%Y-%m-%d %H:%i')) as bmSj, " +
            "CONCAT(DATE_FORMAT(HD_KSSJ, '%Y-%m-%d %H:%i'), '-', DATE_FORMAT(HD_JSSJ, '%Y-%m-%d %H:%i')) as hdSj, " +
            "BM_KSSJ as bmKssj, BM_JSSJ as bmJssj, HD_KSSJ as hdKssj, HD_JSSJ as hdJssj, " +
            "HD_NR as hdNr, HD_DD as hdDd, ZM_RS as zmRs, YBM_RS as ybmRs, " +
            "HD_BQ as hdBq, JN_YQ as jnYq, ZY_XZ as zyXz, HDXQ as hdXq, " +
            "HD_BZ as hdBz, HD_FQ_DW as hdFqDw, HD_ZT as hdZt, FB_ZT as fbZt " +
            "FROM t_zyhd WHERE HD_FQ_DW = #{department} ORDER BY HD_BH DESC")
    List<VolunteerActivity> findActivitiesByDepartment(@Param("department") String department);

    /**
     * 根据部门/学院查询报名记录（用于各种管理功能）
     */
    @Select("SELECT r.ID as id, r.XS_XH as studentId, r.XS_XM as studentName, r.SS_XY as academyName, " +
            "r.HD_BH as activityId, r.HD_MC as activityName, r.HD_SJ as activityTime, r.HD_DD as activityLocation, " +
            "r.BM_ZT as status, r.QD_SJ as checkInTime, r.QT_SJ as checkOutTime, r.QD_ZT as attendanceStatus, " +
            "r.HD_SC as duration, r.HD_XF as credits, r.ZYZ_PJ as evaluation, r.PF as rating " +
            "FROM t_zyhdbmb r " +
            "INNER JOIN t_zyhd a ON r.HD_BH = a.HD_BH " +
            "WHERE a.HD_FQ_DW = #{department} " +
            "ORDER BY r.ID DESC")
    List<ActivityRegistration> findRegistrationsByDepartment(@Param("department") String department);

    /**
     * 更新活动信息
     */
    @Update("UPDATE t_zyhd SET HD_MC = #{hdMc}, HD_NR = #{hdNr}, HD_DD = #{hdDd}, " +
            "BM_KSSJ = #{bmKssj}, BM_JSSJ = #{bmJssj}, HD_KSSJ = #{hdKssj}, HD_JSSJ = #{hdJssj}, " +
            "ZM_RS = #{zmRs}, HD_BQ = #{hdBq}, JN_YQ = #{jnYq}, ZY_XZ = #{zyXz}, " +
            "HDXQ = #{hdXq}, HD_BZ = #{hdBz} " +
            "WHERE HD_BH = #{hdBh}")
    int updateActivity(VolunteerActivity activity);

    /**
     * 删除活动
     */
    @Delete("DELETE FROM t_zyhd WHERE HD_BH = #{activityId}")
    int deleteActivity(@Param("activityId") Integer activityId);

    /**
     * 更新活动发布状态
     */
    @Update("UPDATE t_zyhd SET FB_ZT = #{status} WHERE HD_BH = #{activityId}")
    int updateActivityPublishStatus(@Param("activityId") Integer activityId, @Param("status") String status);

    /**
     * 更新活动状态
     */
    @Update("UPDATE t_zyhd SET HD_ZT = #{status} WHERE HD_BH = #{activityId}")
    int updateActivityStatus(@Param("activityId") Integer activityId, @Param("status") String status);

    /**
     * 插入新活动
     */
    @Insert("INSERT INTO t_zyhd (HD_MC, BM_KSSJ, BM_JSSJ, HD_KSSJ, HD_JSSJ, HD_NR, HD_DD, " +
            "ZM_RS, YBM_RS, HD_BQ, JN_YQ, ZY_XZ, HDXQ, HD_BZ, HD_FQ_DW, HD_ZT, FB_ZT, BBH) " +
            "VALUES (#{hdMc}, #{bmKssj}, #{bmJssj}, #{hdKssj}, #{hdJssj}, #{hdNr}, #{hdDd}, " +
            "#{zmRs}, 0, #{hdBq}, #{jnYq}, #{zyXz}, #{hdXq}, #{hdBz}, #{hdFqDw}, '未开始', '未发布', 0)")
    @Options(useGeneratedKeys = true, keyProperty = "hdBh")
    int insertActivity(VolunteerActivity activity);

    /**
     * 获取所有活动列表（管理员使用）
     */
    @Select("SELECT HD_BH as hdBh, HD_MC as hdMc, " +
            "CONCAT(DATE_FORMAT(BM_KSSJ, '%Y-%m-%d %H:%i'), '至', DATE_FORMAT(BM_JSSJ, '%Y-%m-%d %H:%i')) as bmSj, " +
            "CONCAT(DATE_FORMAT(HD_KSSJ, '%Y-%m-%d %H:%i'), '-', DATE_FORMAT(HD_JSSJ, '%Y-%m-%d %H:%i')) as hdSj, " +
            "BM_KSSJ as bmKssj, BM_JSSJ as bmJssj, HD_KSSJ as hdKssj, HD_JSSJ as hdJssj, " +
            "HD_NR as hdNr, HD_DD as hdDd, ZM_RS as zmRs, YBM_RS as ybmRs, " +
            "HD_BQ as hdBq, JN_YQ as jnYq, ZY_XZ as zyXz, HDXQ as hdXq, " +
            "HD_BZ as hdBz, HD_FQ_DW as hdFqDw, HD_ZT as hdZt, FB_ZT as fbZt " +
            "FROM t_zyhd ORDER BY HD_BH DESC")
    List<VolunteerActivity> findAllActivities();
}
