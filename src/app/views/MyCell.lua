
local Levels = import("..data.MyLevels")
local scheduler = cc.Director:getInstance():getScheduler()
local ourCellsName = 
{
    -- {"#xia.png"},
    {"#fs1.png"},
    {"#gb1.png"},
    {"#sm1.png"},
    {"#snk1.png"},
    {"#hm1.png"},
    {"#bk1.png"},
    {"#hx1.png"},
    {"#zy1.png"},
}

local Cell = class("Cell", function(animationTime,sCale,nodeType)
    local index
    if nodeType then
        index = nodeType
    else
        index =  math.floor(math.random(GAME_CELL_KIND)) 
    end
    local sprite = display.newSprite(ourCellsName[index][1])
    sprite.nodeType = index 

    if animationTime ~= nil and animationTime > 0 then
        sprite:setOpacity(0)
        sprite:setScale(0.1)
        sprite:runAction(cc.ScaleTo:create(animationTime,sCale))
        sprite:runAction(cc.FadeTo:create(animationTime, 255))
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
    sprite.handel = scheduler:scheduleScriptFunc (function () 
        if sprite.arrows then
            if sprite.arrows.curN == 1 then
                sprite.arrows.curN = 14
            else
                sprite.arrows.curN = sprite.arrows.curN - 1
            end
            if sprite.arrows[sprite.arrows.curN] then
                sprite.arrows[sprite.arrows.curN]:setOpacity(225)
                sprite.arrows[sprite.arrows.curN]:runAction(cc.FadeOut:create(0.45))
            end
        end
    end , 0.1 , false)

    return sprite
end)

function Cell:Explod(CELL_STAND_SCALE,cutOrder)
    if cutOrder == nil then
        cutOrder = 1
    end
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
    -- self.Label:setString(string.format("%d", tostring(self.Special)))
    if self.Special then
        if self.Special == 1 then
            if self.arrows == nil then
                self.arrows = {}
                for i=1,3 do
                    self.arrows[i] = display.newSprite("line.png")
                    self.arrows[i]:setScale(1.4 - i * 0.3)
                    self.arrows[i]:setPosition(cc.p(self:getContentSize().width/2,self:getContentSize().height/2))
                    self:addChild(self.arrows[i] , 3)
                    self.arrows[i]:setOpacity(0)
                end
                self.arrows.curN = 3
            end
        elseif self.Special == 2 then
            if self.arrows == nil then
                self.arrows = {}
                for i=1,3 do
                    self.arrows[i] = display.newSprite("line.png")
                    self.arrows[i]:setScale(1.4 - i * 0.3)
                    self.arrows[i]:setPosition(cc.p(self:getContentSize().width/2,self:getContentSize().height/2))
                    self.arrows[i]:setRotation(90)
                    self:addChild(self.arrows[i] , 3)
                    self.arrows[i]:setOpacity(0)
                end
                self.arrows.curN = 3
            end
        elseif self.Special == 3 then
            self.nodeType = 50
            self:setOpacity(0)
            if self.particle  then
                self.particle:removeSelf()
                self.particle = nil
            end
            self.particle = cc.ParticleSystemQuad:create("MutColor.plist")
            self:addChild(self.particle,-1) -- 加到显示对象上就开始播放了
            self.particle:setScale(1.3)
            self.particle:setPosition(cc.p(self:getContentSize().width/2,self:getContentSize().height/2))
        elseif self.Special == 4 then
            if self.particle  then
                self.particle:removeSelf()
                self.particle = nil
            end
            self.particle = cc.ParticleSystemQuad:create("goldLight.plist")
            self:addChild(self.particle,-1) -- 加到显示对象上就开始播放了
            self.particle:setPosition(cc.p(self:getContentSize().width/2,self:getContentSize().height/2))
            self.particle:setScale(0.45)
        end
    end
end

function Cell:onExit()
    scheduler:unscheduleScriptEntry(self.handel)
end

return Cell