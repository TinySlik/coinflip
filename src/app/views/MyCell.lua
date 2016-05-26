
local Levels = import("..data.MyLevels")
local ourCellsName = 
{
    {"#apple1.png","#apple2.png"},
    {"#cake1.png","#cake2.png"},
    {"#manggo1.png","#manggo2.png"},
    {"#musrom1.png","#musrom2.png"},
    {"#oieo1.png","#oieo2.png"},
    {"#paplegg1.png","#paplegg.png"},
    {"#pear1.png","#pear2.png"},
    {"#qingcai1.png","#qingcai2.png"},
    {"#bluebeary.png"},
    {"#egg.png"},
    {"#ou.png"},
    {"#robo.png"},
    {"#shanzhu.png"},
    {"#tomato.png"},
    {"#xia.png"},
}

local Cell = class("Cell", function(nodeType)
    local index
    if nodeType then
        index = nodeType
        if nodeType == 1 then
        end
    else
        index =  math.floor(math.random(6)+ 1) 
    end
    local sprite = display.newSprite(ourCellsName[index][1])
    sprite.nodeType = index 
    return sprite
end)

function Cell:Explod(CELL_STAND_SCALE)

    local function zoom1(offset, time, onComplete)
        local x, y = self:getPosition()
        local size = self:getContentSize()
        size.width = 200
        size.height = 200

        local scaleX = self:getScaleX() * (size.width + offset) / size.width
        local scaleY = self:getScaleY() * (size.height - offset) / size.height

        transition.moveTo(self, {y = y + offset, time = time})
        transition.scaleTo(self, {
            scaleX     = scaleX,
            scaleY     = scaleY,
            time       = time,
            onComplete = onComplete,
        })
    end

    local function zoom2(offset, time, onComplete)
        local x, y = self:getPosition()
        local size = self:getContentSize()
        size.width = 200
        size.height = 200

        transition.moveTo(self, {y = y - offset, time = time / 2})
        transition.scaleTo(self, {
            scaleX     = CELL_STAND_SCALE,
            scaleY     = CELL_STAND_SCALE,
            time       = time,
            onComplete = onComplete,
        })
    end

    zoom1(40, 0.08, function()
        zoom2(40, 0.09, function()
            zoom1(20, 0.10, function()
                zoom2(20, 0.11, function()
                    self:removeSelf()
                end)
            end)
        end)
    end)

    -- Cell:runAction(transition.sequence({
    --                 cc.MoveTo:create(0.8, cc.p(X2,Y2)),
    --                 cc.CallFunc:create(function()
    --                     --改动锚点的渲染前后顺序，移动完成后回归原本zorder
    --                     self.grid[row2][col2]:setGlobalZOrder(CELL_ZORDER)
    --                     self:swap(row1,col1,row2,col2)
    --                     callBack()
    --                     isInAnimation = false   
    --                 end)
    --             }))
end


return Cell