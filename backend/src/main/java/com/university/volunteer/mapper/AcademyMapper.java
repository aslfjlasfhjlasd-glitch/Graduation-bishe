package com.university.volunteer.mapper;

import com.university.volunteer.entity.Academy;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

@Mapper
public interface AcademyMapper {
    @Select("SELECT XY_ZH as xyZh, XY_MM as xyMm, XY_MC as xyMc, FZR_XM as fzrXm, XY_DH as xyDh FROM t_xy WHERE XY_ZH = #{username}")
    Academy findByUsername(String username);
    
    @Update("UPDATE t_xy SET FZR_XM = #{fzrXm}, XY_DH = #{xyDh} WHERE XY_ZH = #{xyZh}")
    int updateAcademy(Academy academy);
    
    @Update("UPDATE t_xy SET XY_MM = #{newPassword} WHERE XY_ZH = #{username}")
    int updatePassword(String username, String newPassword);
}
