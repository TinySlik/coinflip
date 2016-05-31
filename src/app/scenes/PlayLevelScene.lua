
local Levels = import("..data.MyLevels")
local Board = --[[import("..views.Board")]] import("..views.MyCustomBoard")
local AdBar = import("..views.AdBar")

local PlayLevelScene = class("PlayLevelScene", function()
    return display.newScene("PlayLevelScene")
end)

function PlayLevelScene:ctor(levelIndex)
    local bg = display.newSprite("bg_game.jpg")
    -- make background sprite always align top
    bg:setPosition(display.cx, display.top - bg:getContentSize().height / 2)
    self:addChild(bg)

    local label = cc.ui.UILabel.new({
        UILabelType = 1,
        text  = string.format("Level: %s", tostring(levelIndex)),
        font  = "UIFont.fnt",
        x     = display.left + 10,
        y     = display.bottom + 120,
        align = cc.ui.TEXT_ALIGN_LEFT,
    })
    self:addChild(label)

    self.board = Board.new(Levels.get(levelIndex))
    self.board:addEventListener("LEVEL_COMPLETED", handler(self, self.onLevelCompleted))
    self:addChild(self.board)

    self.board:addEventListener(GAME_CELL_COMPELETE_FOUR_H, handler(self, self.GetFourCellsCall_H))
    self.board:addEventListener(GAME_CELL_COMPELETE_FOUR_V, handler(self, self.GetFourCellsCall_V))
    self.board:addEventListener(GAME_CELL_COMPELETE_FIVE, handler(self, self.GetFiveCellsCall))
    self.board:addEventListener(GAME_CELL_COMPELETE_T, handler(self, self.GetTCellsCall))

    cc.ui.UIPushButton.new({normal = "sanjisBtn.png"})
        :align(display.CENTER, display.left + 100, display.top - 120)
        :onButtonClicked(function()
            app:enterChooseLevelScene()
        end)
        :addTo(self)
end

function PlayLevelScene:onLevelCompleted()
    audio.playSound(GAME_SFX.levelCompleted)

    local dialog = display.newSprite("#LevelCompletedDialogBg.png")
    dialog:setPosition(display.cx, display.top + dialog:getContentSize().height / 2 + 40)
    self:addChild(dialog)

    transition.moveTo(dialog, {time = 0.7, y = display.top - dialog:getContentSize().height / 2 - 40, easing = "BOUNCEOUT"})
end

function PlayLevelScene:GetFiveCellsCall()
    print("EventTest5")
end
function PlayLevelScene:GetFourCellsCall_H()
    print("EventTest4_h")
end
function PlayLevelScene:GetFourCellsCall_V()
    print("EventTest4_v")
end
function PlayLevelScene:GetTCellsCall()
    print("EventTestT")
end

function PlayLevelScene:onEnter()
end

return PlayLevelScene
