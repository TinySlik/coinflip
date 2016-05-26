
local Levels = import("..data.MyLevels")
local Cell   = import("..views.MyCell")

local MyBoard = class("MyBoard", function()
    return display.newNode()
end)

local isInAnimation = false
local isInTouch = false
local isEnableTouch = true
local swapDruTime = 0.6
local cell_anim_time = 0.68
local drop_time = 0.9

local NODE_PADDING   = 100 * GAME_CELL_STAND_SCALE
local NODE_ZORDER    = 0
local CELL_ZORDER    = 1000

local CELL_SCALE = 1.0
local CELL_BIG_SCALE = 1.2

local curSwapBeginRow = -1
local curSwapBeginCol = -1

local scheduler = cc.Director:getInstance():getScheduler()

function MyBoard:ctor(levelData)
    math.randomseed(tostring(os.time()):reverse():sub(1, 6))
    cc.GameObject.extend(self):addComponent("components.behavior.EventProtocol"):exportMethods()
    self.batch = display.newNode()
    self.batch:setPosition(display.cx, display.cy)
    self:addChild(self.batch)
    self.grid = {}

    --多加上一个屏幕的缓冲格子
    for i=1,levelData.rows * 2 do
        self.grid[i] = {}
        if levelData.grid[i] == nil then
            for j=1,levelData.cols do
                self.grid[i][j] = nil
            end
        else
            for j=1,levelData.cols do
                self.grid[i][j] = levelData.grid[i][j]
            end
        end
    end

    self.rows = levelData.rows
    self.cols = levelData.cols
    self.cells = {}
    self.flipAnimationCount = 0

    if self.cols <= 8 then
        GAME_CELL_EIGHT_ADD_SCALE = 1.0
        self.offsetX = -math.floor(NODE_PADDING * self.cols / 2) - NODE_PADDING / 2
        self.offsetY = -math.floor(NODE_PADDING * self.rows / 2) - NODE_PADDING / 2
        NODE_PADDING   = 100 * GAME_CELL_STAND_SCALE
        CELL_SCALE = GAME_CELL_STAND_SCALE  * 1.65
        -- create board, place all cells
        for row = 1, self.rows do
            local y = row * NODE_PADDING + self.offsetY
            for col = 1, self.cols do
                local x = col * NODE_PADDING + self.offsetX
                local nodeSprite = display.newSprite("#BoardNode.png", x, y)
                nodeSprite:setScale(GAME_CELL_STAND_SCALE)
                self.batch:addChild(nodeSprite, NODE_ZORDER)

                local node = self.grid[row][col]
                if node ~= Levels.NODE_IS_EMPTY then
                    -- local cell = Cell.new(node)
                    local cell = Cell.new()
                    cell.isNeedClean = false
                    cell:setPosition(x, y)
                    cell:setScale(CELL_SCALE)
                    cell.row = row
                    cell.col = col
                    self.grid[row][col] = cell
                    self.cells[#self.cells + 1] = cell
                    self.batch:addChild(cell, CELL_ZORDER)
                end
            end
        end
    else
        self.offsetX = -math.floor(NODE_PADDING * 8 / 2) - NODE_PADDING / 2
        self.offsetY = -math.floor(NODE_PADDING * 8 / 2) - NODE_PADDING / 2
        GAME_CELL_EIGHT_ADD_SCALE = 8.0 / self.cols
        CELL_SCALE = GAME_CELL_STAND_SCALE * GAME_CELL_EIGHT_ADD_SCALE * 1.65

        NODE_PADDING = 100 * GAME_CELL_STAND_SCALE * GAME_CELL_EIGHT_ADD_SCALE
        -- create board, place all cells
        for row = 1, self.rows do
            local y = row * NODE_PADDING + self.offsetY
            for col = 1, self.cols do
                local x = col * NODE_PADDING + self.offsetX
                local nodeSprite = display.newSprite("#BoardNode.png", x, y)
                nodeSprite:setScale(GAME_CELL_STAND_SCALE * GAME_CELL_EIGHT_ADD_SCALE)
                self.batch:addChild(nodeSprite, NODE_ZORDER)

                local node = self.grid[row][col]
                if node ~= Levels.NODE_IS_EMPTY then
                    -- local cell = Cell.new(node)
                    local cell = Cell.new()
                    cell.isNeedClean = false
                    cell:setPosition(x, y)
                    cell:setScale(CELL_SCALE)
                    cell.row = row
                    cell.col = col
                    self.grid[row][col] = cell
                    self.cells[#self.cells + 1] = cell
                    self.batch:addChild(cell, CELL_ZORDER)
                end
            end
        end
    end

    self:setNodeEventEnabled(true)
    self:setTouchEnabled(true)
    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        return self:onTouch(event.name, event.x, event.y)
    end)
    
    while self:checkAll() do
        self:changeSingedCell()
    end

    self.bigHandel = scheduler:scheduleScriptFunc (function () 
        if isInTouch and isEnableTouch then
            if curSwapBeginRow == -1 or curSwapBeginCol == -1 then
                return
            else
                if self.grid[curSwapBeginRow] and self.grid[curSwapBeginRow][curSwapBeginCol] then
                    local cell_c = self.grid[curSwapBeginRow][curSwapBeginCol] 
                    local sc = cell_c:getScaleX()
                    if sc < CELL_BIG_SCALE * CELL_SCALE then
                        cell_c:setScale( ( CELL_BIG_SCALE * CELL_SCALE - 1.0 ) / 8 +  sc )
                    end
                end
            end
        end
    end, 1.0/60 , false)
end

function MyBoard:checkLevelCompleted()
    local count = 0
    for _, cell in ipairs(self.cells) do
        if cell.isWhite then count = count + 1 end
    end
    if count == #self.cells then
        -- completed
        self:setTouchEnabled(false)
        self:dispatchEvent({name = "LEVEL_COMPLETED"})
    end
end

function MyBoard:checkAll()
    local padding = NODE_PADDING * GAME_CELL_EIGHT_ADD_SCALE * 1.65
    for _, cell in pairs(self.cells) do
        self:checkCell(cell)
    end
    --check同时管理触摸执行
    for i,v in pairs (self.cells) do
        if v.isNeedClean  then
            isEnableTouch = false
            return true
        end
    end
    isEnableTouch = true
    return false
end

function MyBoard:checkCell(cell)
    local listH = {}
    listH [#listH + 1] = cell
    local i=cell.col
    --格子中左边对象是否相同的遍历
    while i > 1 do
        i = i -1
        local cell_left = self:getCell(cell.row,i)
        if cell_left then
            if cell.nodeType == cell_left.nodeType then
                listH [#listH + 1] = cell_left
            else
                break
            end
        end
    end
    --格子中右边对象是否相同的遍历
    if cell.col ~= self.cols then
        for j=cell.col+1 , self.cols do
            local cell_right = self:getCell(cell.row,j)
            if cell_right then
                if cell.nodeType == cell_right.nodeType then
                    listH [#listH + 1] = cell_right
                else
                    break
                end
            end
            
        end
    end

    --目前的当前格子的左右待消除对象(连同自己)

    if #listH < 3 then
    else
        -- print("find a 3 coup H cell")
        for i,v in pairs(listH) do
            v.isNeedClean = true
            v.cutOrder = i
        end

    end
    for i=2,#listH do
        listH[i] = nil
    end

    --判断格子的上边的待消除对象

    if cell.row ~= self.rows then
        for j=cell.row+1 , self.rows do
            local cell_up = self:getCell(j,cell.col)
            if cell_up then
                if cell.nodeType == cell_up.nodeType then
                    listH [#listH + 1] = cell_up
                else
                    break
                end
            end
        end
    end

    local i=cell.row

    --格子中下面对象是否相同的遍历
    while i > 1 do
        i = i -1
        if cell_down then
            local cell_down = self:getCell(i,cell.col)
            if cell.nodeType == cell_down.nodeType then
                listH [#listH + 1] = cell_down
            else
                break
            end
        end
    end

    if #listH < 3 then
        for i=2,#listH do
            listH[i] = nil
        end
    else
        for i,v in pairs(listH) do
            v.isNeedClean = true
            v.cutOrder = i
        end
    end
end

function MyBoard:changeSingedCell(onAnimationComplete)
    local DropList = {}
    --统计所有的最高掉落项
    local DropListFinal = {}
    for i,v in pairs(self.cells) do
        if v.isNeedClean then
            local drop_pad = 1
            local row = v.row
            local col = v.col
            local x = col * NODE_PADDING + self.offsetX
            local y = (self.rows + 1)* NODE_PADDING + self.offsetY
            for i,v in pairs(DropList) do
                if col == v.col then
                    drop_pad = drop_pad + 1
                    y = y + NODE_PADDING
                    for i2,v2 in pairs(DropListFinal) do
                        if v2.col == v.col then
                            table.remove(DropListFinal,i2)
                        end
                    end
                end
            end
            local cell
            if onAnimationComplete then
                cell = Cell.new(cell_anim_time,CELL_SCALE)
            else
                cell = Cell.new()
            end
            DropList [#DropList + 1] = cell
            DropListFinal [#DropListFinal + 1] = cell
            cell.isNeedClean = false
            cell:setPosition(x, y)
            cell:setScale(CELL_SCALE)
            cell.row = self.rows + drop_pad
            cell.col = col
            self.grid[self.rows +  drop_pad][col] = cell
            if onAnimationComplete == nil then
                self.batch:removeChild(self.grid[row][col], true)
                self.grid[row][col] = nil
            else
                self.grid[row][col]:setGlobalZOrder(CELL_ZORDER + 1)
                self.grid[row][col]:Explod(CELL_SCALE,self.grid[row][col].cutOrder )
                self.grid[row][col] = nil
            end

            self.cells[i] = cell
            self.batch:addChild(cell, CELL_ZORDER)
        end
    end

    local temp = nil

    --进行一次DropListFinal的精简
    for i=1,#DropListFinal do
        if DropListFinal[i] then
            for j=1,#DropList do
                if DropListFinal[i].col == DropList[j].col and DropListFinal[i].row < DropList[j].row then
                    DropListFinal[i] = DropList[j]
                end
            end
        end
    end
    --重新排列grid
    for i , v in pairs(DropListFinal) do
        if v then
            local c = v.row 
            local j = 1
            while j <=  self.rows  do
                if self.grid[j][v.col] == nil then
                    local k = j
                    while k <  c + 1 do
                        self:swap(k,v.col,k+1,v.col)
                        k = k + 1
                    end
                    j = j - 1
                end
                j = j + 1
            end
        end
    end

    --self:showGrid()
    --填补self.grid空缺
    --或执行最后的所有动画步骤

    if onAnimationComplete == nil then
        for i=1,self.rows do
            for j=1,self.cols do
                local y = i * NODE_PADDING + self.offsetY
                local x = j * NODE_PADDING + self.offsetX
                if self.grid[i][j] then
                    self.grid[i][j]:setPosition(x,y)
                end
            end
        end
        if self:checkAll() then
             self:changeSingedCell()
        end 
    else
        for i=1,self.rows do
            for j , v in pairs(DropListFinal) do
                local y = i * NODE_PADDING + self.offsetY
                local x = v.col * NODE_PADDING + self.offsetX
                local cell_t = self.grid[i][v.col]
                if cell_t then
                    cell_t:runAction(transition.sequence({
                        cc.DelayTime:create(cell_anim_time),
                        cc.MoveTo:create(drop_time, cc.p(x, y))
                    }))
                end
            end
        end
        self.handle  = scheduler:scheduleScriptFunc (function () 
            scheduler:unscheduleScriptEntry(self.handle )
            if self:checkAll() then
                self:changeSingedCell(true)
            end
        end, cell_anim_time + drop_time , false)
    end
end

function MyBoard:showGrid()
    for i=1,self.rows * 2 do
        local sum = 0
        for j=1,self.cols do
            if self.grid[i] and self.grid[i][j] then
                sum = sum +1
                print("row:",self.grid[i][j].row,"col:",self.grid[i][j].col)
            end
        end
        print("rows:",i , "sum :" ,sum)
    end
end

function MyBoard:getCell(row, col)
    if self.grid[row] then
        return self.grid[row][col]
    end
end

function MyBoard:swap(row1,col1,row2,col2)
    local temp
    if self.grid[row1] and self.grid[row1][col1] then
        self.grid[row1][col1].row = row2
        self.grid[row1][col1].col = col2
    end
    if self.grid[row2] and self.grid[row2][col2] then
        self.grid[row2][col2].row = row1
        self.grid[row2][col2].col = col1
    end
    temp = self.grid[row1][col1] 
    self.grid[row1][col1] = self.grid[row2][col2]
    self.grid[row2][col2] = temp
end

function MyBoard:swapWithAnimation(row1,col1,row2,col2,callBack,timeScale)
    if self.grid[row1][col1] == nil or self.grid[row2][col2] == nil then
        print("have one nil value with the swap function!!!!")
        return
    end
    if not isInAnimation then

            isInAnimation = true
        local X1,Y1 = col1 * NODE_PADDING + self.offsetX , row1  * NODE_PADDING + self.offsetY
        local X2,Y2 = col2 * NODE_PADDING + self.offsetX , row2  * NODE_PADDING + self.offsetY
        local moveTime = swapDruTime 
        if timeScale then
            moveTime = moveTime * timeScale
        end
        if callBack then
            --改动锚点的渲染前后顺序，移动时前置
            self.grid[row1][col1]:setGlobalZOrder(CELL_ZORDER)
            self.grid[row2][col2]:setGlobalZOrder(CELL_ZORDER + 1)

            self.grid[row1][col1]:runAction(transition.sequence({
                    cc.MoveTo:create(moveTime, cc.p(X2,Y2)),
                    cc.CallFunc:create(function()
                        --改动锚点的渲染前后顺序，移动完成后回归原本zorder
                        self.grid[row2][col2]:setGlobalZOrder(CELL_ZORDER)
                        self:swap(row1,col1,row2,col2)
                        isInAnimation = false
                        callBack()
                    end)
                }))
            self.grid[row2][col2]:runAction(cc.MoveTo:create(moveTime, cc.p(X1,Y1)))
        else
            self.grid[row1][col1]:runAction(cc.MoveTo:create(moveTime, cc.p(X2,Y2)))
            self.grid[row2][col2]:runAction(cc.MoveTo:create(moveTime, cc.p(X1,Y1)))
            self:swap(row1,col1,row2,col2)
            isInAnimation = false 
        end
    end
end

function MyBoard:onTouch( event , x, y)
    if not isEnableTouch then
        return
    end
    if event == "began" then
        local row,col = self:getRandC(x, y)
        curSwapBeginRow = row
        curSwapBeginCol = col
        
        if curSwapBeginRow == -1 or curSwapBeginCol == -1 then
            return false
        end
        isInTouch = true
        self.grid[curSwapBeginRow][curSwapBeginCol]:setGlobalZOrder(CELL_ZORDER+1)
    end
    if isInTouch and (event == "moved" or event == "ended"  )then
        local padding = NODE_PADDING / 2
        local cell_center = self.grid[curSwapBeginRow][curSwapBeginCol]
        local cx, cy = cell_center:getPosition()
        cx = cx + display.cx
        cy = cy + display.cy

        if event == "ended" then
            isInTouch = false
            local p_a = cell_center:getAnchorPoint()
            local x_a = (0.5 - p_a.x ) *  NODE_PADDING + curSwapBeginCol * NODE_PADDING + self.offsetX
            local y_a = (0.5 - p_a.y) *  NODE_PADDING + curSwapBeginRow * NODE_PADDING + self.offsetY
            cell_center:setAnchorPoint(cc.p(0.5,0.5))
            cell_center:setPosition(cc.p(x_a  , y_a ))
            isEnableTouch = false
                cell_center:runAction(
                    transition.sequence({
                    cc.MoveTo:create(swapDruTime/2,cc.p(curSwapBeginCol * NODE_PADDING + self.offsetX,curSwapBeginRow * NODE_PADDING + self.offsetY)),
                    cc.CallFunc:create(function()
                          isEnableTouch = true
                    end)
                }))
            cell_center:runAction(cc.ScaleTo:create(swapDruTime/2,CELL_SCALE))
            self.grid[curSwapBeginRow][curSwapBeginCol]:setGlobalZOrder(CELL_ZORDER)
            return true
        end

        if x < cx - 2*padding
            or x > cx + 2*padding
            or y < cy - 2*padding
            or y > cy + 2*padding then
            isInTouch = false

            --划归锚点偏移
            local p_a = cell_center:getAnchorPoint()
            local x_a = (0.5 - p_a.x ) *  NODE_PADDING + curSwapBeginCol * NODE_PADDING + self.offsetX
            local y_a = (0.5 - p_a.y) *  NODE_PADDING + curSwapBeginRow * NODE_PADDING + self.offsetY
            cell_center:setAnchorPoint(cc.p(0.5,0.5))
            cell_center:setPosition(cc.p(x_a  , y_a ))
            local row,col = self:getRandC(x, y)

            --进入十字框以内
            if ((x >= cx - padding
            and x <= cx + padding)
            or (y >= cy - padding
            and y <= cy + padding) )and (row ~= -1 and col ~= -1)  then
                --防止移动超过一格的情况

                if row - curSwapBeginRow > 1 then
                    row = curSwapBeginRow + 1
                end
                if curSwapBeginRow - row > 1 then
                   row = curSwapBeginRow - 1
                end
                if col -  curSwapBeginCol > 1 then
                    col = curSwapBeginCol + 1
                end
                if curSwapBeginCol - col  > 1 then
                    col = curSwapBeginCol - 1
                end

                isEnableTouch = false
                self:swapWithAnimation(row,col,curSwapBeginRow,curSwapBeginCol,
                    function()
                        
                        if self:checkAll() then
                            isEnableTouch = true
                            self:changeSingedCell(true)
                        else
                            self:swapWithAnimation(row,col,curSwapBeginRow,curSwapBeginCol,function()
                                isEnableTouch = true 
                                print("swap fail")
                            end,0.5)
                        end
                    end
                    )
                cell_center:runAction(cc.ScaleTo:create(swapDruTime/2,CELL_SCALE))
            else
                isEnableTouch = false
                cell_center:runAction(
                    transition.sequence({
                    cc.MoveTo:create(swapDruTime / 2,cc.p(curSwapBeginCol * NODE_PADDING + self.offsetX,curSwapBeginRow * NODE_PADDING + self.offsetY)),
                    cc.CallFunc:create(function()
                          isEnableTouch = true
                          self.grid[curSwapBeginRow][curSwapBeginCol]:setGlobalZOrder(CELL_ZORDER)
                    end)
                }))
                cell_center:runAction(cc.ScaleTo:create(swapDruTime/2,CELL_SCALE))
                return true
            end
        else
            x_vec = (cx - x)/ NODE_PADDING * 0.3 + 0.5
            y_vec = (cy - y)/ NODE_PADDING * 0.3 + 0.5
            cell_center:setAnchorPoint(cc.p(x_vec,y_vec))
        end
    end
    return true
end

function MyBoard:getRandC(x,y)
    local padding = NODE_PADDING / 2
    for _, cell in ipairs(self.cells) do
        local cx, cy = cell:getPosition()
        cx = cx + display.cx
        cy = cy + display.cy
        if x >= cx - padding
            and x <= cx + padding
            and y >= cy - padding
            and y <= cy + padding then
            return cell.row , cell.col
        end
    end
    return -1 , -1
end

function MyBoard:onEnter()
    self:setTouchEnabled(true)
end

function MyBoard:onExit()
    scheduler:unscheduleScriptEntry(self.bigHandel )
    GAME_CELL_EIGHT_ADD_SCALE = 1.0
    NODE_PADDING = 100 * GAME_CELL_STAND_SCALE
    self:removeAllEventListeners()
end

return MyBoard