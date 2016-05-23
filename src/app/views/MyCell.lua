
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
    local index = 1

    -- if nodeType == 1 then
    -- else if nodeType == 2 then
    -- else if nodeType == 3 then
    -- else if nodeType == 4 then
    -- else if nodeType == 5 then
    -- else if nodeType == 6 then
    -- else if nodeType == 7 then
    -- else if nodeType == 8 then
    -- else if nodeType == 9 then
    -- else if nodeType == 10 then   
    -- end

    -- if not nodeType then
        index =  math.floor(math.random(14)+ 1) 
    -- end
    local sprite = display.newSprite(ourCellsName[index][1])
    sprite.nodeType = index 
    return sprite
end)



return Cell