local dispatcher = cc.Director:getInstance():getEventDispatcher()

local MyScoreBoard = class("MyScoreBoard", function()
    return display.newNode()
end)

function MyScoreBoard:ctor(levelDate)
	self:setPosition(cc.p(0,0))
	math.randomseed(tostring(os.time()):reverse():sub(1, 6))
    cc.GameObject.extend(self):addComponent("components.behavior.EventProtocol"):exportMethods()

    self.stepLabel = cc.ui.UILabel.new({
    UILabelType = 1,
    text  = "step:0",
    font  = "UIFont.fnt",
    x     = 80  ,
    y     = display.top-30 ,
    align = cc.ui.TEXT_ALIGN_CENTER,
    valign = cc.ui.TEXT_VALIGN_CENTER,
    })
    self.stepLabel:setAnchorPoint(cc.p(0.5,0.5))

    self:addChild(self.stepLabel)

    self.timeLabel = cc.ui.UILabel.new({
    UILabelType = 1,
    text  = "time:0",
    font  = "UIFont.fnt",
    x     = display.cx  ,
    y     = display.top -30 ,
    align = cc.ui.TEXT_ALIGN_CENTER,
    valign = cc.ui.TEXT_VALIGN_CENTER,
    })
    self.timeLabel:setAnchorPoint(cc.p(0.5,0.5))
    self:addChild(self.timeLabel)

    self.scoreLabel = cc.ui.UILabel.new({
    UILabelType = 1,
    text  = "score:0",
    font  = "UIFont.fnt",
    x     = display.right-80  ,
    y     = display.top-30 ,
    align = cc.ui.TEXT_ALIGN_CENTER,
    valign = cc.ui.TEXT_VALIGN_CENTER,
    })
    self.scoreLabel:setAnchorPoint(cc.p(0.5,0.5))
    self:addChild(self.scoreLabel)
    self.listeners = {}
    self.listeners[1] = cc.EventListenerCustom:create(GAME_SIG_STEP_COUNT,custom_event_handler(self,self.StepCountChange) )
    self.listeners[2] = cc.EventListenerCustom:create(GAME_SIG_TIME_COUNT, custom_event_handler(self,self.TimeCountChange) )
    self.listeners[3] = cc.EventListenerCustom:create(GAME_SIG_SCORE_COUNT,custom_event_handler(self,self.ScoreCountChange) )
    --添加事件监听器到分发器
    for i,v in pairs(self.listeners) do
        dispatcher:addEventListenerWithSceneGraphPriority(v, self);
    end
end

function MyScoreBoard:StepCountChange(event)
    self.stepLabel:setString("step:"..event.step)
end
function MyScoreBoard:TimeCountChange(event)
    print(event.name)
end
function MyScoreBoard:ScoreCountChange(event)
    print(event.name)
end

return MyScoreBoard