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
            "CONCAT(DATE_FORMAT(HD_KSSJ, '%Y-%m-%d %H:%i'), '-', DATE_FORMAT(HD_JSSJ, '%H:%i')) as hdSj, " +
            "BM_KSSJ as bmKssj, BM_JSSJ as bmJssj, HD_KSSJ as hdKssj, HD_JSSJ as hdJssj, " +
            "HD_NR as hdNr, " +
            "HD_DD as hdDd, ZM_RS as zmRs, HDXQ as hdXq, " +
            "HD_BZ as hdBz, HD_FQ_DW as hdFqDw, HD_ZT as hdZt " +
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
}
