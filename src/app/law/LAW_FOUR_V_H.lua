
local LAW_FOUR_V_H = {}
local self = LAW_FOUR_V_H
--特消冲突优先级
LAW_FOUR_V_H.level = 10
--横竖标识
LAW_FOUR_V_H.vTag = false
LAW_FOUR_V_H.hTag = false

--init
function LAW_FOUR_V_H.checkCell(cell,listV,listH) 
    if not self.checkRe(cell,listV,listH) then
        return self.checkSelf(cell,listV,listH)
    end
    return 0
end

function LAW_FOUR_V_H.checkSelf(cell,listV,listH)
    --对应三级奖励
    if #listV == 4 or #listH == 4  then
        if #listV == 4 and #listH < 4  then
            cell.LAW = self
            cell.Special = 2
            for i_v= 2,4 do
                listV[i_v].isNeedClean = true
                listV[i_v].cutOrder = i_v
            end
        elseif #listH == 4 and #listV < 4  then
            cell.LAW = self
            cell.Special = 1
            for i_h= 2,4 do
                listH[i_h].isNeedClean = true
                listH[i_h].cutOrder = i_h
            end
        end
        return 1
    end
    return 0
end

--查重
function LAW_FOUR_V_H.checkRe(cell,listV,listH)
    local tag_v = true
    local tag_h = true
    for k,v_listV in pairs (listV) do
        if not (v_listV.isNeedClean or ((not v_listV.isNeedClean )and v_listV.Special == 2)) then
            tag_v = false
        end
    end
    for k,v_listH in pairs (listH) do
        if not (v_listH.isNeedClean or ((not v_listH.isNeedClean )and v_listH.Special == 1)) then
            tag_h = false
        end
    end
    return tag_v and tag_h
end

--exp
function LAW_FOUR_V_H.exp(cell) 
    --一波检测只给炸一次
    if not cell.isReExp then
        cell.isNeedClean = true
        cell.isReExp =true
    end
end

function LAW_FOUR_V_H.getLawSelf()
    return LAW_FOUR_V_H
end

return LAW_FOUR_V_H