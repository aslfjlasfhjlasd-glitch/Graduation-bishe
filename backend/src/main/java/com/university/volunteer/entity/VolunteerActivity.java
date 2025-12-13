package com.university.volunteer.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("t_zyhd")
public class VolunteerActivity {
    @TableId(value = "HD_BH", type = IdType.AUTO)
    private Long hdBh;

    @TableField("HD_MC")
    private String hdMc;

    @TableField("HD_NR")
    private String hdNr;

    @TableField("HD_DD")
    private String hdDd;

    @TableField("KS_SJ")
    private LocalDateTime ksSj;

    @TableField("JS_SJ")
    private LocalDateTime jsSj;

    @TableField("XY_RS")
    private Integer xyRs;

    @TableField("YBM_RS")
    private Integer ybmRs;

    @TableField("ZT")
    private String zt;

    @TableField("CJR")
    private String cjr;

    @TableField("CJ_SJ")
    private LocalDateTime cjSj;

    @TableField("GXR")
    private String gxr;

    @TableField("GX_SJ")
    private LocalDateTime gxSj;

    @TableField("LL_CS")
    private Integer llCs;  // 浏览次数
}
