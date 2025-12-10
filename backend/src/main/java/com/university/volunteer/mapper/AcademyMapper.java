package com.university.volunteer.mapper;

import com.university.volunteer.entity.Academy;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

@Mapper
public interface AcademyMapper {
    @Select("SELECT XY_ZH, XY_MM, XY_MC FROM t_xy WHERE XY_ZH = #{username}")
    Academy findByUsername(String username);
}
