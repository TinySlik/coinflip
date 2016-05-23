
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





return Cell