
local Levels = import("..data.MyLevels")
local Coin   = import("..views.MyCoin")

local MyBoard = class("MyBoard", function()
    return display.newNode()
end)

local NODE_PADDING   = 100 * GAME_CELL_STAND_SCALE
local NODE_ZORDER    = 0

local COIN_ZORDER    = 1000

function MyBoard:ctor(levelData)
    cc.GameObject.extend(self):addComponent("components.behavior.EventProtocol"):exportMethods()

    self.batch = display.newBatchNode(GAME_TEXTURE_IMAGE_FILENAME)
    self.batch:setPosition(display.cx, display.cy)
    self:addChild(self.batch)

    self.grid = clone(levelData.grid)
    self.rows = levelData.rows
    self.cols = levelData.cols
    self.coins = {}
    self.flipAnimationCount = 0

    if self.rows <= 8 then
        GAME_CELL_EIGHT_ADD_SCALE = 1.0
        local offsetX = -math.floor(NODE_PADDING * self.cols / 2) - NODE_PADDING / 2
        local offsetY = -math.floor(NODE_PADDING * self.rows / 2) - NODE_PADDING / 2
        NODE_PADDING   = 100 * GAME_CELL_STAND_SCALE
        -- create board, place all coins
        for row = 1, self.rows do
            local y = row * NODE_PADDING + offsetY
            for col = 1, self.cols do
                local x = col * NODE_PADDING + offsetX
                local nodeSprite = display.newSprite("#BoardNode.png", x, y)
                nodeSprite:setScale(GAME_CELL_STAND_SCALE)
                self.batch:addChild(nodeSprite, NODE_ZORDER)

                local node = self.grid[row][col]
                if node ~= Levels.NODE_IS_EMPTY then
                    local coin = Coin.new(node)
                    coin:setPosition(x, y)
                    coin:setScale(GAME_CELL_STAND_SCALE)
                    coin.row = row
                    coin.col = col
                    self.grid[row][col] = coin
                    self.coins[#self.coins + 1] = coin
                    self.batch:addChild(coin, COIN_ZORDER)
                end
            end
        end
    else
        local offsetX = -math.floor(NODE_PADDING * 8 / 2) - NODE_PADDING / 2
        local offsetY = -math.floor(NODE_PADDING * 8 / 2) - NODE_PADDING / 2
        GAME_CELL_EIGHT_ADD_SCALE = 8.0 / self.rows

        NODE_PADDING = 100 * GAME_CELL_STAND_SCALE * GAME_CELL_EIGHT_ADD_SCALE
        -- create board, place all coins
        for row = 1, self.rows do
            local y = row * NODE_PADDING + offsetY
            for col = 1, self.cols do
                local x = col * NODE_PADDING + offsetX
                local nodeSprite = display.newSprite("#BoardNode.png", x, y)
                nodeSprite:setScale(GAME_CELL_STAND_SCALE * GAME_CELL_EIGHT_ADD_SCALE)
                self.batch:addChild(nodeSprite, NODE_ZORDER)

                local node = self.grid[row][col]
                if node ~= Levels.NODE_IS_EMPTY then
                    local coin = Coin.new(node)
                    coin:setPosition(x, y)
                    coin:setScale(GAME_CELL_STAND_SCALE * GAME_CELL_EIGHT_ADD_SCALE)
                    coin.row = row
                    coin.col = col
                    self.grid[row][col] = coin
                    self.coins[#self.coins + 1] = coin
                    self.batch:addChild(coin, COIN_ZORDER)
                end
            end
        end
        GAME_CELL_EIGHT_ADD_SCALE = 1.0
        NODE_PADDING = 100 * GAME_CELL_STAND_SCALE
    end

    self:setNodeEventEnabled(true)
    self:setTouchEnabled(true)
    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        return self:onTouch(event.name, event.x, event.y)
    end)

end

function MyBoard:checkLevelCompleted()
    local count = 0
    for _, coin in ipairs(self.coins) do
        if coin.isWhite then count = count + 1 end
    end
    if count == #self.coins then
        -- completed
        self:setTouchEnabled(false)
        self:dispatchEvent({name = "LEVEL_COMPLETED"})
    end
end

function MyBoard:getCoin(row, col)
    if self.grid[row] then
        return self.grid[row][col]
    end
end

function MyBoard:onTouch(event, x, y)
    if event ~= "began" or self.flipAnimationCount > 0 then return end

    local padding = NODE_PADDING / 2
    for _, coin in ipairs(self.coins) do
        local cx, cy = coin:getPosition()
        cx = cx + display.cx
        cy = cy + display.cy
        if x >= cx - padding
            and x <= cx + padding
            and y >= cy - padding
            and y <= cy + padding then
            --改成两位置交换的代码可能
            break
        end
    end
end

function MyBoard:onEnter()
    self:setTouchEnabled(true)
end

function MyBoard:onExit()
    self:removeAllEventListeners()
end

return MyBoard