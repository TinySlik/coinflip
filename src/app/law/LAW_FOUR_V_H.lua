
local LAW_FOUR_V_H = {}
--init
function LAW_FOUR_V_H.checkCell(cell,listV,listH) 
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
    end
end
--exp
function LAW_FOUR_V_H.exp(cell) 

	print("hello2")
end

return LAW_FOUR_V_H