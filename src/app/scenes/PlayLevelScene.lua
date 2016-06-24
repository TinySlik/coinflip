
local Levels = import("..data.MyLevels")
local Board = import("..views.MyCustomBoard")
local AdBar = import("..views.AdBar")
local ScoreBoard = import("..views.MyScoreBoard")

local dispatcher = cc.Director:getInstance():getEventDispatcher()

local PlayLevelScene = class("PlayLevelScene", function()
    return display.newScene("PlayLevelScene")
end)

function PlayLevelScene:ctor(levelIndex)
    local bg = display.newSprite("bg.png")
    -- make background sprite always align top
    bg:setPosition(display.cx, display.top - bg:getContentSize().height / 2)
    self:addChild(bg)

    local label = cc.ui.UILabel.new({
        UILabelType = 2,
        text  = string.format("第%s关", tostring(levelIndex)),
        font  = "1595=方正字迹-童体毛笔字体.ttf",
        x     = display.left + 14,
        y     = display.top - 150,
        align = cc.ui.TEXT_ALIGN_LEFT,
        size  = 43,
        color = cc.c4b(98,156,109,255)
    })
    self:addChild(label)

    self.board = Board.new(Levels.get(levelIndex))
    :addTo(self,0)
    self.scoreBoard = ScoreBoard.new(Levels.get(levelIndex))
    :addTo(self,1)

    --新建事件监听器
    self.listeners = {}
    self.listeners[1] = cc.EventListenerCustom:create(GAME_SIG_LEVEL_COMPLETED,custom_event_handler(self, self.onLevelCompleted))
    self.listeners[2] = cc.EventListenerCustom:create(GAME_SIG_COMPELETE_FOUR_H,custom_event_handler(self, self.GetFourCellsCall_H) )
    self.listeners[3] = cc.EventListenerCustom:create(GAME_SIG_COMPELETE_FOUR_V,custom_event_handler(self, self.GetFourCellsCall_V) )
    self.listeners[4] = cc.EventListenerCustom:create(GAME_SIG_COMPELETE_FIVE,custom_event_handler(self, self.GetFiveCellsCall) )
    self.listeners[5] = cc.EventListenerCustom:create(GAME_SIG_COMPELETE_T,custom_event_handler(self, self.GetTCellsCall) )
    self.listeners[6] = cc.EventListenerCustom:create(GAME_SIG_COMPELETE_NORMAL,custom_event_handler(self, self.GetThreeCellsCall) )
    --添加事件监听器到分发器
    for i,v in pairs(self.listeners) do
        dispatcher:addEventListenerWithSceneGraphPriority(v, self);
    end
    
    cc.ui.UIPushButton.new({normal = "back.png"})
        :align(display.CENTER, display.right - 60, display.bottom + 80)
        :onButtonClicked(function()
            app:enterChooseLevelScene()
        end)
        :addTo(self)
        :setScale(2.0)
    self.particle = cc.ParticleSystemQuad:create("wind.plist")
    self:addChild(self.particle) -- 加到显示对象上就开始播放了
    self.particle:setPosition(cc.p(display.cx,display.cy))
end

function PlayLevelScene:onLevelCompleted()
    audio.playSound(GAME_SFX.levelCompleted)

    local dialog = display.newSprite("#LevelCompletedDialogBg.png")
    dialog:setPosition(display.cx, display.top + dialog:getContentSize().height / 2 + 40)
    self:addChild(dialog)

    transition.moveTo(dialog, {time = 0.7, y = display.top - dialog:getContentSize().height / 2 - 40, easing = "BOUNCEOUT"})
end

function PlayLevelScene:GetThreeCellsCall(event)
    print(event.name,event.nodeType)
    dispatcher:dispatchEvent(TinyEventCustom({name = GAME_SIG_SCORE_COUNT ,change = 10}))
end
function PlayLevelScene:GetFiveCellsCall(event)
    print(event.name,event.nodeType)
end
function PlayLevelScene:GetFourCellsCall_H(event)
    print(event.name,event.nodeType)
end
function PlayLevelScene:GetFourCellsCall_V(event)
    print(event.name,event.nodeType)
end
function PlayLevelScene:GetTCellsCall(event)
    print(event.name,event.nodeType)
end

function PlayLevelScene:onEnter()
end

return PlayLevelScene
