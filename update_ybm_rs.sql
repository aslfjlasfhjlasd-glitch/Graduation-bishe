-- 更新所有活动的已报名人数（YBM_RS字段）
-- 根据t_zyhdbmb表中的实际报名记录统计

UPDATE t_zyhd 
SET YBM_RS = (
    SELECT COUNT(*) 
    FROM t_zyhdbmb 
    WHERE t_zyhdbmb.HD_BH = t_zyhd.HD_BH
);

-- 查看更新结果
SELECT HD_BH, HD_MC, ZM_RS, YBM_RS 
FROM t_zyhd 
WHERE YBM_RS > 0
ORDER BY HD_BH;