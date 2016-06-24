
local Levels = import("..data.MyLevels")
local Cell   = import("..views.MyCell")

local MyBoard = class("MyBoard", function()
    return display.newNode()
end)

local START_TAG = false
local GAME_STEP = 0
local WAIT_TIME = 0
local SWAP_TIME = 0.6
local CELL_ANIM_TIME = 0.68
local DROP_TIME = 1.64
local NODE_PADDING   = 100 * GAME_CELL_STAND_SCALE
local NODE_ZORDER    = 0
local CELL_ZORDER    = 1000
local CELL_SCALE = 1.0
local CELL_BIG_SCALE = 1.2
local HELP_DISTANCE = 8

local curSwapBeginRow = -1
local curSwapBeginCol = -12
local isInAnimation = false
local isInTouch = false
local isEnableTouch = true
local step = 0
local time = 0

local dispatcher = cc.Director:getInstance():getEventDispatcher()
local scheduler = cc.Director:getInstance():getScheduler()

function MyBoard:ctor( levelData )
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
    --超过8格和8格以下的情况
    if self.cols <= 8 then
        GAME_CELL_EIGHT_ADD_SCALE = 1.0
        self.offsetX = -math.floor(NODE_PADDING * self.cols / 2) - NODE_PADDING / 2
        self.offsetY = -math.floor(NODE_PADDING * self.rows / 2) - NODE_PADDING / 2
        NODE_PADDING   = 100 * GAME_CELL_STAND_SCALE
        CELL_SCALE = GAME_CELL_STAND_SCALE  
    else
        self.offsetX = -math.floor(NODE_PADDING * 8 / 2) - NODE_PADDING / 2
        self.offsetY = -math.floor(NODE_PADDING * 8 / 2) - NODE_PADDING / 2
        GAME_CELL_EIGHT_ADD_SCALE = 8.0 / self.cols
        CELL_SCALE = GAME_CELL_STAND_SCALE * GAME_CELL_EIGHT_ADD_SCALE 
        NODE_PADDING = 100 * GAME_CELL_STAND_SCALE * GAME_CELL_EIGHT_ADD_SCALE
    end
    for row = 1, self.rows do
        local y = row * NODE_PADDING + self.offsetY
        for col = 1, self.cols do
            local x = col * NODE_PADDING + self.offsetX
            local nodeSprite = display.newSprite("#BoardNode.png", x, y)
            nodeSprite:setOpacity(100)
            nodeSprite:setScale(CELL_SCALE)
            self.batch:addChild(nodeSprite, NODE_ZORDER)
            local node = self.grid[row][col]
            if node ~= Levels.NODE_IS_EMPTY then
                local cell = Cell.new()
                cell.isNeedClean = false
                cell.row = row
                cell.col = col
                self.grid[row][col] = cell
                self.cells[#self.cells + 1] = cell
                self.batch:addChild(cell, CELL_ZORDER)
            end
        end
    end
    self:lined()
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
                        cell_c:setScale( ( CELL_BIG_SCALE * CELL_SCALE - CELL_SCALE ) / 8 +  sc )
                    end
                end
            end
        end
        WAIT_TIME = WAIT_TIME + 1.0 / 60
        time = time + 1.0/60
        if math.abs(time - math.floor(time)) < 0.05  then
            dispatcher:dispatchEvent(TinyEventCustom({name = GAME_SIG_TIME_COUNT ,time = math.floor(time)}))
        end
        if WAIT_TIME > 5.0 then
            WAIT_TIME = 0
            local p1 = cc.p(0,0)
            local p2 = cc.p(0,0)
            local cell2 = nil
            if self.checkRes < 1 then
                return
            end
            if self.checkRes == 1 then
                cell2 = self.grid[self.checkRdCell.row+1][self.checkRdCell.col]
                p1 = cc.p(0,HELP_DISTANCE)
                p2 = cc.p(0,-HELP_DISTANCE)
            elseif self.checkRes == 2 then
                cell2 = self.grid[self.checkRdCell.row-1][self.checkRdCell.col]
                p2 = cc.p(0,HELP_DISTANCE)
                p1 = cc.p(0,-HELP_DISTANCE)
            elseif self.checkRes == 3 then
                cell2 = self.grid[self.checkRdCell.row][self.checkRdCell.col+1]
                p1 = cc.p(HELP_DISTANCE,0)
                p2 = cc.p(-HELP_DISTANCE,0)
            elseif self.checkRes == 4 then
                cell2 = self.grid[self.checkRdCell.row][self.checkRdCell.col-1]
                p2 = cc.p(HELP_DISTANCE,0)
                p1 = cc.p(-HELP_DISTANCE,0)
            end

            if isInTouch and 
                (
                    (self.checkRdCell.row == curSwapBeginRow and self.checkRdCell.col == curSwapBeginCol)
                    or
                    (cell2.row == curSwapBeginRow and cell2.col == curSwapBeginCol)
                    ) 
                then
                return
            end

            self.checkRdCell:runAction(transition.sequence({
                            cc.MoveBy:create(0.4,p1),
                            cc.MoveBy:create(0.4,p2),
                            cc.MoveBy:create(0.4,p1),
                            cc.MoveBy:create(0.4,p2),
                        }))
            cell2:runAction(transition.sequence({
                            cc.MoveBy:create(0.4,p2),
                            cc.MoveBy:create(0.4,p1),
                            cc.MoveBy:create(0.4,p2),
                            cc.MoveBy:create(0.4,p1),
                        }))
        end

    end , 1.0/60 , false)
    self:suffleSheet(self.cells)
    START_TAG = true
end
--关卡完成事件填写处（未定义）
function MyBoard:checkLevelCompleted()
    self:setTouchEnabled(false)
    self:dispatchEvent({name = GAME_SIG_LEVEL_COMPLETED })
end
--(检查全局消除可能，同时检查全局交换可能)
function MyBoard:checkAll()
    WAIT_TIME = 0
    local padding = NODE_PADDING * GAME_CELL_EIGHT_ADD_SCALE 
    local sum = 0
    self.checkRes = 0
    self.checkRdCell = nil
    for _, cell in pairs(self.cells) do
        sum = sum + self:checkCell(cell)
        if sum == 0 and self.checkRes == 0 then
            local res = self:checkRound(cell)
            if res > 0 then
                self.checkRdCell = cell
                self.checkRes = res
            end
        end
    end
    if sum > 0 then
        self.checkRes = 0
        self.checkRdCell = nil
    else
        if self.checkRes > 0 then
            --print(self.checkRdCell . row ,self.checkRdCell . col,self.checkRes )
        else
            self:shuffle(function() end)
        end
    end
    return self:checkNotClean()
end
--check同时管理触摸事件允许
function MyBoard:checkNotClean()
    for i,v in pairs (self.cells) do
        if v.isNeedClean  then
            isEnableTouch = false
            return true
        end
    end
    isEnableTouch = true
    return false
end
-- 检查单个格子周围交换产生的消除可能 返回值
-- -2表示出错
-- -1表示周围无可交换项
-- 1表示上方可换
-- 2表示下方可换
-- 3表示左方可换
-- 4表示右方可换
function MyBoard:checkRound( cell )
    if cell == nil then
        print("erro")
        return -2
    end
    local cell1 = cell
    local cell2 = nil
    local isCan = false
    if cell.row < self.rows and self.grid[cell.row+1][cell.col] then
        cell2 = self.grid[cell.row+1][cell.col]
        self:swap(cell.row, cell.col, cell.row+1, cell.col)
        if self:checkCell(cell1,true) > 0 or self:checkCell(cell2,true) > 0 then
            isCan = true
        end
        self:swap(cell1.row, cell1.col, cell2.row, cell2.col)
        if isCan then
            return 1
        end
    end
    if cell.row > 1 and self.grid[cell.row-1][cell.col] then
        cell2 = self.grid[cell.row-1][cell.col]
        self:swap(cell.row, cell.col, cell.row-1, cell.col)
        if self:checkCell(cell1,true) > 0 or self:checkCell(cell2,true) > 0 then
            isCan = true
        end
        self:swap(cell1.row, cell1.col, cell2.row, cell2.col)
        if isCan then
            return 2
        end
    end
    if cell.col < self.cols and self.grid[cell.row][cell.col+1] then
        cell2 = self.grid[cell.row][cell.col+1]
        self:swap(cell.row, cell.col, cell.row, cell.col+1)
        if self:checkCell(cell1,true)  > 0 or self:checkCell(cell2,true)  > 0 then
            isCan = true
        end
        self:swap(cell1.row, cell1.col, cell2.row, cell2.col)
        if isCan then
            return 3
        end
    end
    if cell.col > 1 and self.grid[cell.row][cell.col-1] then
        cell2 = self.grid[cell.row][cell.col-1]
        self:swap(cell.row, cell.col, cell.row, cell.col-1)
        if self:checkCell(cell1,true) > 0 or self:checkCell(cell2,true) > 0 then
            isCan = true
        end
        self:swap(cell1.row, cell1.col, cell2.row, cell2.col)
        if isCan then
            return 4
        end
    end
    return -1
end
--触摸事件
function MyBoard:onTouch( event , x , y )
    if not isEnableTouch then
        return false
    end
    if event == "began" then
        local row,col = self:getRandC(x, y)
        curSwapBeginRow = row
        curSwapBeginCol = col
        if curSwapBeginRow == -1 or curSwapBeginCol == -1 then
            return false 
        end
        isInTouch = true
        self.grid[curSwapBeginRow][curSwapBeginCol]:setLocalZOrder(CELL_ZORDER+1)
        return true
    end
    if isInTouch and (event == "moved" or event == "ended"  )then
        local padding = NODE_PADDING / 2
        local cell_center = self.grid[curSwapBeginRow][curSwapBeginCol]
        local cx, cy = cell_center:getPosition()
        cx = cx + display.cx
        cy = cy + display.cy
        --锚点归位
        local AnchBack = function()
            isInTouch = false
            local p_a = cell_center:getAnchorPoint()
            local x_a = (0.5 - p_a.x ) *  NODE_PADDING + curSwapBeginCol * NODE_PADDING + self.offsetX
            local y_a = (0.5 - p_a.y) *  NODE_PADDING + curSwapBeginRow * NODE_PADDING + self.offsetY
            cell_center:setAnchorPoint(cc.p(0.5,0.5))
            cell_center:setPosition(cc.p(x_a  , y_a ))
        end
        --动画回到格子定义点
        local AnimBack = function()
            isEnableTouch = false
                cell_center:runAction(
                    transition.sequence({
                    cc.MoveTo:create(SWAP_TIME/2,cc.p(curSwapBeginCol * NODE_PADDING + self.offsetX,curSwapBeginRow * NODE_PADDING + self.offsetY)),
                    cc.CallFunc:create(function()
                          isEnableTouch = true
                    end)
                }))
            cell_center:runAction(cc.ScaleTo:create(SWAP_TIME/2,CELL_SCALE))
            self.grid[curSwapBeginRow][curSwapBeginCol]:setLocalZOrder(CELL_ZORDER)
        end
        if event == "ended" then
            AnchBack()
            AnimBack()
            return
        end

        if x < cx - 2*padding
            or x > cx + 2*padding
            or y < cy - 2*padding
            or y > cy + 2*padding then
            isInTouch = false
            AnchBack()
            local row,col = self:getRandC(x, y)
            --进入十字框以内
            if ((x >= cx - padding
            and x <= cx + padding)
            or (y >= cy - padding
            and y <= cy + padding) )and (row ~= -1 and col ~= -1)  then
                --防止移动超过一格的情况
                if row - curSwapBeginRow > 1 then row = curSwapBeginRow + 1 end
                if curSwapBeginRow - row > 1 then row = curSwapBeginRow - 1 end
                if col -  curSwapBeginCol > 1 then col = curSwapBeginCol + 1 end
                if curSwapBeginCol - col  > 1 then col = curSwapBeginCol - 1 end
                    self:swap(row,col,curSwapBeginRow,curSwapBeginCol,function()
                        if START_TAG then
                            step = step + 1
                            GAME_STEP = GAME_STEP + 1
                            dispatcher:dispatchEvent(TinyEventCustom({name = GAME_SIG_STEP_COUNT , step = GAME_STEP}))
                        end
                        self:checkCell(self.grid[row][col])
                        self:checkCell(self.grid[curSwapBeginRow][curSwapBeginCol])
                        if self:checkNotClean() then
                            WAIT_TIME = 0
                            self:changeSingedCell(true)
                        else
                            self:swap(row,col,curSwapBeginRow,curSwapBeginCol,function()
                                isEnableTouch = true
                            end,0.5)
                        end
                    end
                    )
                cell_center:runAction(cc.ScaleTo:create(SWAP_TIME/2,CELL_SCALE))
            else
                AnimBack()
                return
            end
        else
            x_vec = (cx - x)/ NODE_PADDING * 0.3 + 0.5
            y_vec = (cy - y)/ NODE_PADDING * 0.3 + 0.5
            cell_center:setAnchorPoint(cc.p(x_vec,y_vec))
        end
    end
end
--检查单个格子消除可能 -- 传入的检测格子 ，是否不需要标记删除位（仅返回一个检测值）
function MyBoard:checkCell( cell , isNotClean )
    local isNeedAnim = 0
    local listH = {}
    local listV = {}
    listH [#listH + 1] = cell
    listV [#listV + 1] = cell
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
        listH = {}
    else
        isNeedAnim = 1
        -- print("find a 3 coup H cell")
        if isNotClean then
        else
            for i,v in pairs(listH) do
                if v.Special and v.Special > 0 and v.step ~= step  then
                    v.SpecialExp = true
                    v.isNeedClean = true
                else
                    v.isNeedClean = true
                end
                v.cutOrder = i
            end
        end
    end
    --判断格子的上边的待消除对象
    if cell.row ~= self.rows then
        for j=cell.row+1 , self.rows do
            local cell_up = self:getCell(j,cell.col)
            if cell_up then
                if cell.nodeType == cell_up.nodeType then
                    listV [#listV + 1] = cell_up
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
        local cell_down = self:getCell(i,cell.col)
        if cell_down then
            if cell.nodeType == cell_down.nodeType then
                listV [#listV + 1] = cell_down
            else
                break
            end
        end
    end
    if #listV < 3 then
        listV = {}
    else
        isNeedAnim = 1
        if isNotClean then
        else
            for i,v in pairs(listV) do
                if v.Special and v.Special > 0 and v.step ~= step then
                    
                    v.SpecialExp = true
                    v.isNeedClean = true
                else
                    v.isNeedClean = true
                end
                v.cutOrder = i
            end
        end
    end
    --枚举量 代表
    --1 横向4个
    --2 纵向4个
    --3 5个
    --4 6个消除

    if START_TAG and isNotClean == nil then
        --对应三级奖励
        if #listV == 4 or #listH == 4  then
            local isCan = true
            for i,v in pairs(listV) do
                if v.Special and v.Special  > 0  then
                    isCan = false
                end
            end
            for i,v in pairs(listH) do
                if v.Special and v.Special  > 0 then
                    isCan = false
                end
            end
            if isCan then
                
                cell.step = step
                if #listV == 4 and #listH < 4  then
                    cell.Special = 2
                elseif #listH == 4 and #listV < 4  then
                    cell.Special = 1
                end
                -- print(cell.row,cell.col,step,cell.Special)
            end
        end
        --对应2级奖励
        if #listV == 5 or #listH == 5 then
            local isCan = true
            for i,v in pairs(listV) do
                if v.Special and v.Special  > 0  then
                    v.Special = nil
                end
            end
            for i,v in pairs(listH) do
                if v.Special and v.Special  > 0  then
                    v.Special = nil
                end
            end
            if isCan then
                cell.step = step
                cell.Special = 3
                -- print(cell.row,cell.col,step,cell.Special)
            end
        end
        --对应1级奖励
        if #listV + #listH >= 6 then
            for i,v in pairs(listV) do
                if v.Special and v.Special  > 0  then
                    v.Special = nil
                end
            end
            for i,v in pairs(listH) do
                if v.Special and v.Special  > 0  then
                    v.Special = nil
                end
            end
            cell.step = step
            cell.Special = 4
            -- print(cell.row,cell.col,step,cell.Special)
        end
    end
    return isNeedAnim
end
--处理标记消除项目，掉落新的格子内容
function MyBoard:changeSingedCell( onAnimationComplete , timeScale )
    local DropList = {}
    --统计所有的最高掉落项
    local DropListFinal = {}
    for i,v in pairs(self.cells) do
        if v.isNeedClean then
            
            if v.SpecialExp ==nil and v.Special and v.Special > 0 then
                v.isNeedClean = false
                v:Change()
            else
                local drop_pad = 1
                local row = v.row
                local col = v.col
                local x = col * NODE_PADDING + self.offsetX
                local y = (self.rows + 1)* NODE_PADDING + self.offsetY
                if v.SpecialExp and v.Special and v.Special > 0 then
                    if v.Special == 1 then
                        dispatcher:dispatchEvent(TinyEventCustom({name = GAME_SIG_COMPELETE_FOUR_V ,cell_x = x,cell_y = y,nodeType = v.nodeType}))
                    elseif v.Special == 2 then
                        dispatcher:dispatchEvent(TinyEventCustom({name = GAME_SIG_COMPELETE_FOUR_H ,cell_x = x,cell_y = y,nodeType = v.nodeType}))
                    elseif v.Special == 3 then
                        dispatcher:dispatchEvent(TinyEventCustom({name = GAME_SIG_COMPELETE_FIVE ,cell_x = x,cell_y = y,nodeType = v.nodeType}))
                    elseif v.Special == 4 then
                        dispatcher:dispatchEvent(TinyEventCustom({name = GAME_SIG_COMPELETE_T ,cell_x = x,cell_y = y,nodeType = v.nodeType}))
                    end
                else
                    dispatcher:dispatchEvent(TinyEventCustom({name = GAME_SIG_COMPELETE_NORMAL ,cell_x = x,cell_y = y,nodeType = v.nodeType}))
                end
                
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
                    cell = Cell.new(CELL_ANIM_TIME,CELL_SCALE)
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
                    self.grid[row][col]:setLocalZOrder(CELL_ZORDER + 1)
                    self.grid[row][col]:Explod(CELL_SCALE,self.grid[row][col].cutOrder )
                    self.grid[row][col] = nil
                end
                self.cells[i] = cell
                self.batch:addChild(cell, CELL_ZORDER)
            end
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

    --填补self.grid空缺
    --或执行最后的所有动画步骤
    if onAnimationComplete == nil then
        self:lined()
        if self:checkAll() then
             self:changeSingedCell()
        end 
    else
        local timeSc =  1.0
        if timeScale then
            timeSc = timeScale
        end
        
        for i=1,self.rows do
            for j , v in pairs(DropListFinal) do
                local y = i * NODE_PADDING + self.offsetY
                local x = v.col * NODE_PADDING + self.offsetX
                local cell_t = self.grid[i][v.col]
                if cell_t then
                    local x_t,y_t = cell_t:getPosition()
                    if(math.abs(y_t - y) > NODE_PADDING/2 ) then
                        local rand = math.random(100)/100.0 + 0.4
                        cell_t:runAction(transition.sequence({
                            cc.DelayTime:create(CELL_ANIM_TIME + cell_t.row / self.rows * 0.24  ),
                            cc.ScaleTo:create(0.3*timeSc, CELL_SCALE * 1.13, CELL_SCALE * 0.93 ),
                            cc.ScaleTo:create(0.5*timeSc, CELL_SCALE * 0.95, CELL_SCALE * 1.08 ),
                            cc.ScaleTo:create(0.6*timeSc, CELL_SCALE * 1.055, CELL_SCALE * 0.97 ),
                            cc.ScaleTo:create(0.8*timeSc, CELL_SCALE * 1.0, CELL_SCALE * 1.0 )
                        }))
                        cell_t:runAction(transition.sequence({
                            cc.DelayTime:create((CELL_ANIM_TIME + cell_t.row / self.rows * 0.24)*timeSc  ),
                            cc.EaseElasticOut:create(cc.MoveTo:create((DROP_TIME - 0.24 - 0.24)*timeSc , cc.p(x, y)),rand) 
                        }))
                    end 
                end
            end
        end
        self:runAction(transition.sequence(
        {
            cc.DelayTime:create((CELL_ANIM_TIME + DROP_TIME)*timeSc),
            cc.CallFunc:create(function()
                if START_TAG then
                    step = step + 1
                end
                if self:checkAll() then
                    self:changeSingedCell(true,0.75)
                end
            end)
        }))
    end
end
--复位
function MyBoard:lined( isAnimation , time )
    for row = 1, self.rows do
        local y = row * NODE_PADDING + self.offsetY
        for col = 1, self.cols do
            local x = col * NODE_PADDING + self.offsetX
            cell = self.grid[row][col]
            if isAnimation then
                cell:runAction(cc.MoveTo:create(time,cc.p(x, y)))
            else
                cell:setPosition(x, y)
            end
            cell:setScale(CELL_SCALE)
        end
    end
end
--得到行列对应的格子内容
function MyBoard:getCell( row , col )
    if self.grid[row] then
        return self.grid[row][col]
    end
    return nil
end
--根据坐标点判断格子行列
function MyBoard:getRandC( x , y )
    local padding = NODE_PADDING / 2
    for _, cell in ipairs(self.cells) do
        local cx, cy = cell:getPosition()
        cx = cx + display.cx
        cy = cy + display.cy
        if x >= cx - padding and x <= cx + padding and y >= cy - padding and y <= cy + padding then
            return cell.row , cell.col
        end
    end
    return -1 , -1
end
--表格乱序
function MyBoard:suffleSheet( table )
    math.randomseed(tostring(os.time()):reverse():sub(1, 6))
    for i= 1  , #table -1 do
        temp = table[i]
        local rd =  math.floor(math.random(#table - i + 1)) + i - 1
        table[i] = table[rd]
        table[rd] = temp
    end
end
--交换格子内容
function MyBoard:swap( row1 , col1 , row2 , col2 , callBack , timeScale )
    local swap = function(row1_,col1_,row2_,col2_)
        local temp
        if self:getCell(row1_,col1_) then
            self.grid[row1_][col1_].row = row2
            self.grid[row1_][col1_].col = col2
        end
        if self:getCell(row2_,col2_) then
            self.grid[row2_][col2_].row = row1
            self.grid[row2_][col2_].col = col1
        end
        temp = self.grid[row1_][col1_] 
        self.grid[row1_][col1_] = self.grid[row2_][col2_]
        self.grid[row2_][col2_] = temp
    end

    if callBack == nil then
        swap(row1,col1,row2,col2)
        return
    end

    if self:getCell(row1,col1) == nil or self:getCell(row2,col2) == nil then
        print("have one nil value with the swap function!!!!")
        return
    end

    if not isInAnimation then
        isEnableTouch = false
        isInAnimation = true
        local X1,Y1 = col1 * NODE_PADDING + self.offsetX , row1  * NODE_PADDING + self.offsetY
        local X2,Y2 = col2 * NODE_PADDING + self.offsetX , row2  * NODE_PADDING + self.offsetY
        local moveTime = SWAP_TIME 
        if timeScale then
            moveTime = moveTime * timeScale
        end
        if callBack then
            --改动锚点的渲染前后顺序，移动时前置
            self.grid[row2][col2]:setLocalZOrder(CELL_ZORDER + 1)
            self.grid[row1][col1]:runAction(transition.sequence({
                    cc.MoveTo:create(moveTime, cc.p(X2,Y2)),
                    cc.CallFunc:create(function()
                        --改动锚点的渲染前后顺序，移动完成后回归原本zorder
                        self.grid[row2][col2]:setLocalZOrder(CELL_ZORDER)
                        self:swap(row1,col1,row2,col2)
                        isInAnimation = false
                        callBack()
                    end)
                }))
            self.grid[row2][col2]:runAction(cc.MoveTo:create(moveTime, cc.p(X1,Y1)))
        else
            self.grid[row1][col1]:runAction(cc.MoveTo:create(moveTime, cc.p(X2,Y2)))
            self.grid[row2][col2]:runAction(cc.MoveTo:create(moveTime, cc.p(X1,Y1)))
            swap(row1,col1,row2,col2)
            isInAnimation = false 
        end
    end
end
--全局乱序
function MyBoard:shuffle( callBack )
    local temp = nil
    local big_time = 0.4
    local move_time = 0.6
    self:suffleSheet(self.cells)
    for i=1,self.rows do
        for j=1,self.cols do
            self.cells[self.cols * (i-1)  + j].row = i
            self.cells[self.cols * (i-1)  + j].col = j
            self.grid[i][j] = self.cells[self.cols * (i-1)  + j]
        end
    end

    if callBack then
        isEnableTouch = false
        self:lined(true,big_time+move_time)
        self:runAction(transition.sequence(
        {
            cc.DelayTime:create(big_time + move_time),
            cc.CallFunc:create(function()
                            callBack()
                            if self:checkAll() then
                                self:changeSingedCell(true)
                            end
                        end)
        }))
        self:suffleSheet(self.cells)
    else
        while self:checkAll() do
            self:changeSingedCell()
        end
        self:lined()
    end
end

function MyBoard:onEnter()
    self:setTouchEnabled(true)
end

function MyBoard:onExit()
    START_TAG = false
    GAME_STEP = 0
    step = 0
    WAIT_TIME = 0
    time = 0
    scheduler:unscheduleScriptEntry(self.bigHandel )
    GAME_CELL_EIGHT_ADD_SCALE = 1.0
    NODE_PADDING = 100 * GAME_CELL_STAND_SCALE
    self:removeAllEventListeners()
end

return MyBoard