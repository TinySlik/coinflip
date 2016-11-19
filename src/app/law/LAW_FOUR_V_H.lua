
local LAW_FOUR_V_H = {}
local self = LAW_FOUR_V_H
--特消冲突优先级
LAW_FOUR_V_H.level = 10
--横竖标识
LAW_FOUR_V_H.vTag = false
LAW_FOUR_V_H.hTag = false
LAW_FOUR_V_H.isreadyToExp = false
LAW_FOUR_V_H.isReExp = false
--init
function LAW_FOUR_V_H.checkCell(cell,listV,listH) 
    if  self.checkRe(cell,listV,listH) then
        return self.checkSelf(cell,listV,listH)
    end
    return 0
end

function LAW_FOUR_V_H.checkReadyToExp()
    return LAW_FOUR_V_H.isreadyToExp
end

function LAW_FOUR_V_H.checkSelf(cell,listV,listH)
    --对应三级奖励
    if #listV == 4 or #listH == 4  then
        local isCan = true
        for i,v in pairs(listV) do
            if v.Special and v.Special  > 0  then
                isCan = false
            end
        end
        for i,v in pairs(listH) do
            if v.Special and v.Special  > 0 then
                isCan = false
            end
        end
        if isCan then
            cell.step = step
            if #listV == 4 and #listH < 4  then
                cell.Special = 2
            elseif #listH == 4 and #listV < 4  then
                cell.Special = 1
            end
            -- print(cell.row,cell.col,step,cell.Special)
        end
        return 1
    end
end

function LAW_FOUR_V_H.checkRe(cell,listV,listH)
    for k,v in pairs (listV) do
        if v.isNeedClean  then
            --todo
        end
    end
    return false
end

--exp
function LAW_FOUR_V_H.exp(cell) 
    --一波检测只给炸一次
    if not LAW_FOUR_V_H.isReExp then
        cell.isNeedClean = true
        LAW_FOUR_V_H.isReExp =true
        print("yes")
    end
end

function LAW_FOUR_V_H.getLawSelf()
    return LAW_FOUR_V_H
end

return LAW_FOUR_V_H