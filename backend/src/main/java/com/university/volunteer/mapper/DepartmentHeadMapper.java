package com.university.volunteer.mapper;

import com.university.volunteer.entity.DepartmentHead;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

@Mapper
public interface DepartmentHeadMapper {
    @Select("SELECT XJBMFZR_ZH, XJBMFZR_MM, XJBMFZR_XM FROM t_xjbmfzr WHERE XJBMFZR_ZH = #{username}")
    DepartmentHead findByUsername(String username);

    @Update("UPDATE t_zyhdbmb SET BM_ZT = #{status} WHERE ID = #{registrationId}")
    int updateRegistrationStatus(Integer registrationId, String status);
}
