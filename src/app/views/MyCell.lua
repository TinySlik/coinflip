
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
        index =  math.floor(math.random(4)) 
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
    sprite.Label = cc.ui.UILabel.new({
    UILabelType = 1,
    text  = "",
    font  = "UIFont.fnt",
    x     = sprite:getContentSize().width / 2  ,
    y     = sprite:getContentSize().height / 2 ,
    align = cc.ui.TEXT_ALIGN_CENTER,
    valign = cc.ui.TEXT_VALIGN_CENTER,
    })
    sprite:addChild(sprite.Label,1002)

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
                        local particle = cc.ParticleSystemQuad:create("exp.plist")
                        self:getParent():addChild(particle,1002) -- 加到显示对象上就开始播放了
                        particle:setPosition(self:getPositionX(),self:getPositionY())
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

--0.58 sumtime
function Cell:Change()
    self.Label:setString(string.format("%d", tostring(self.Special)))

    if self.Special then
        if self.Special == 1 then
        elseif self.Special == 2 then
        elseif self.Special == 3 then
        elseif self.Special == 4 then
            local particle = cc.ParticleSystemQuad:create("goldLight.plist")
            self:addChild(particle,-1) -- 加到显示对象上就开始播放了
            particle:setPosition(cc.p(self:getContentSize().width/2,self:getContentSize().height/2))
            particle:setScale(0.45)
        end
    end
end

return Cell