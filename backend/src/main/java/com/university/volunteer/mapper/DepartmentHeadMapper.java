package com.university.volunteer.mapper;

import com.university.volunteer.entity.DepartmentHead;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

@Mapper
public interface DepartmentHeadMapper {
    @Select("SELECT XJBM_MC as xjbmMc, XJBMFZR_ZH as xjbmfzrZh, XJBMFZR_MM as xjbmfzrMm, XJBMFZR_XM as xjbmfzrXm, XJBMFZR_DH as xjbmfzrDh FROM t_xjbmfzr WHERE XJBMFZR_ZH = #{username}")
    DepartmentHead findByUsername(String username);

    @Update("UPDATE t_zyhdbmb SET BM_ZT = #{status} WHERE ID = #{registrationId}")
    int updateRegistrationStatus(Integer registrationId, String status);
    
    @Update("UPDATE t_xjbmfzr SET XJBMFZR_XM = #{xjbmfzrXm}, XJBMFZR_DH = #{xjbmfzrDh} WHERE XJBMFZR_ZH = #{xjbmfzrZh}")
    int updateDepartmentHead(DepartmentHead departmentHead);
    
    @Update("UPDATE t_xjbmfzr SET XJBMFZR_MM = #{newPassword} WHERE XJBMFZR_ZH = #{username}")
    int updatePassword(String username, String newPassword);
}
