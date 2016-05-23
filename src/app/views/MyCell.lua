
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

return Cell