
require("cocos.init")
require("config")
require("framework.init")
require("framework.shortcodes")
require("framework.cc.init")
require("instance")

--修改了引擎内的事件传递，解耦合
function custom_event_handler(obj, method)
    local dispatcher = cc.Director:getInstance():getEventDispatcher()
    return function(...)
        return method(obj,dispatcher._userdate, ...)
    end
end

function TinyEventCustom(table)
    local dispatcher = cc.Director:getInstance():getEventDispatcher()
    dispatcher._userdate = table
    return cc.EventCustom:new(table.name)
end

--尝试使用push

local MyApp = class("MyApp", cc.mvc.AppBase)

function MyApp:ctor()
    MyApp.super.ctor(self)
    self.objects_ = {}
end

function MyApp:run()
    cc.FileUtils:getInstance():addSearchPath("res/")
    display.addSpriteFrames(GAME_TEXTURE_DATA_FILENAME, GAME_TEXTURE_IMAGE_FILENAME)

    display.addSpriteFrames(GAME_TEXTURE_DATA_CELLS_FILENAME, GAME_TEXTURE_IMAGE_CELLS_FILENAME)

    -- preload all sounds
    for k, v in pairs(GAME_SFX) do
        audio.preloadSound(v)
    end

    self:enterMenuScene()
end

function MyApp:enterMenuScene()
    self:enterScene("MenuScene", nil, "fade", 0.6, display.COLOR_WHITE)
end

function MyApp:enterMoreGamesScene()
    self:enterScene("MoreGamesScene", nil, "fade", 0.6, display.COLOR_WHITE)
end

function MyApp:enterChooseLevelScene()
    self:enterScene("ChooseLevelScene", nil, "fade", 0.6, display.COLOR_WHITE)
end

function MyApp:playLevel(levelIndex)
    self:enterScene("PlayLevelScene", {levelIndex}, "fade", 0.6, display.COLOR_WHITE)
end

appInstance = MyApp
return MyApp
