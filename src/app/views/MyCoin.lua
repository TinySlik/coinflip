
local Levels = import("..data.MyLevels")

local Cell = class("Cell", function(nodeType)
    local index = 1
    if nodeType == Levels.NODE_IS_BLACK then
        index = 8
    end
    local sprite = display.newSprite(string.format("#Coin%04d.png", index))
    sprite.isWhite = index == 1
    return sprite
end)

--[[function Coin:flip(onComplete)
    local frames = display.newFrames("Coin%04d.png", 1, 8, not self.isWhite)
    local animation = display.newAnimation(frames, 0.3 / 8)
    self:playAnimationOnce(animation, false, onComplete)

    local coinscale = GAME_CELL_STAND_SCALE * GAME_CELL_EIGHT_ADD_SCALE
    if conditions then
        --todo
    end

    self:runAction(transition.sequence({
        cc.ScaleTo:create(0.15, 1.5 * coinscale),
        cc.ScaleTo:create(0.1, 1.0 * coinscale),
        cc.CallFunc:create(function()
            local actions = {}
            local scale = 1.1
            local time = 0.04
            for i = 1, 5 do
                actions[#actions + 1] = cc.ScaleTo:create(time, scale * coinscale, 1.0 * coinscale)
                actions[#actions + 1] = cc.ScaleTo:create(time, 1.0 * coinscale, scale * coinscale)
                scale = scale * 0.95 * coinscale
                time = time * 0.8
            end
            actions[#actions + 1] = cc.ScaleTo:create(0, 1.0  * coinscale, 1.0  * coinscale)
            self:runAction(transition.sequence(actions))
        end)
    }))

    self.isWhite = not self.isWhite
end]]--

return Cell