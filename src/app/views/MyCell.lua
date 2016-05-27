
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

local Cell = class("Cell", function(animationTime,sCale,nodeType)
    local index
    if nodeType then
        index = nodeType
    else
        index =  math.floor(math.random(15)) 
    end
    local sprite = display.newSprite(ourCellsName[index][1])
    sprite.nodeType = index 

    if animationTime ~= nil and animationTime > 0 then
        sprite:setOpacity(0)
        sprite:setScale(0.1)
        sprite:runAction(cc.ScaleTo:create(animationTime,sCale))
        sprite:runAction(cc.FadeTo:create(animationTime, 225))
        sprite:runAction(cc.RotateBy:create(animationTime, -(360*3)))
    end

    return sprite
end)

function Cell:Explod(CELL_STAND_SCALE,cutOrder)

    local function delays(onComlete)
        self:runAction(transition.sequence({
                        cc.DelayTime:create((cutOrder - 1)* 0.05 ),
                        cc.CallFunc:create(function()
                              onComlete()
                        end)
                    }))
    end

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

    delays(function()
        zoom1(40, 0.08, function()
            zoom2(40, 0.09, function()
                zoom1(20, 0.10, function()
                    zoom2(20, 0.11, function()
                        self:runAction(
                            transition.sequence({
                            cc.ScaleTo:create(0.30,0.1),
                            cc.CallFunc:create(function()
                                  self:removeSelf()
                            end)
                        }))
                        self:runAction(cc.FadeTo:create(0.30, 0.2))
                        self:runAction(cc.RotateBy:create(0.30, 800))
                    end)
                end)
            end)
        end)
    end)
end

return Cell