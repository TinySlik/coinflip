
-- 0 - disable debug info, 1 - less debug info, 2 - verbose debug info
DEBUG = 1

-- display FPS stats on screen
DEBUG_FPS = false

-- dump memory info every 10 seconds
DEBUG_MEM = false

-- load deprecated API
LOAD_DEPRECATED_API = false

-- load shortcodes API
LOAD_SHORTCODES_API = true

-- screen orientation
CONFIG_SCREEN_ORIENTATION = "portrait"

-- design resolution
CONFIG_SCREEN_WIDTH  = 640
CONFIG_SCREEN_HEIGHT = 960

-- auto scale mode
CONFIG_SCREEN_AUTOSCALE = "FIXED_WIDTH"

-- sounds
GAME_SFX = {
    tapButton      = "sfx/TapButtonSound.mp3",
    backButton     = "sfx/BackButtonSound.mp3",
    flipCoin       = "sfx/ConFlipSound.mp3",
    levelCompleted = "sfx/LevelWinSound.mp3",
}

GAME_TEXTURE_DATA_FILENAME  = "AllSprites.plist"
GAME_TEXTURE_IMAGE_FILENAME = "AllSprites.png"

GAME_TEXTURE_DATA_CELLS_FILENAME = "sea_sheet.plist"
GAME_TEXTURE_IMAGE_CELLS_FILENAME = "sea_sheet.png"

GAME_CELL_STAND_SCALE = 0.75

GAME_CELL_EIGHT_ADD_SCALE = 1.0

GAME_CELL_KIND = 6

--消息接受区

--相关三消特殊效果触发信号
--{name,x,y,nodeType}
GAME_SIG_COMPELETE_NORMAL = "GAME_SIG_COMPELETE_NORMAL"
GAME_SIG_COMPELETE_FOUR_H = "GAME_SIG_COMPELETE_FOUR_H"
GAME_SIG_COMPELETE_FOUR_V = "GAME_SIG_COMPELETE_FOUR_V"
GAME_SIG_COMPELETE_FIVE = "GAME_SIG_COMPELETE_FIVE"
GAME_SIG_COMPELETE_T = "GAME_SIG_COMPELETE_T"

--相关三消记分信号
--{name,step}
GAME_SIG_STEP_COUNT = "GAME_SIG_STEP_COUNT"
--{name,time}
GAME_SIG_TIME_COUNT = "GAME_SIG_TIME_COUNT"
--{name,score_deate}
GAME_SIG_SCORE_COUNT = "GAME_SIG_SCORE_COUNT"

--关卡事件信号
--{name}
GAME_SIG_LEVEL_COMPLETED = "GAME_SIG_LEVEL_COMPLETED"
--{name,levelIndex}
GAME_SIG_LEVEL_CHOOSE = "GAME_SIG_LEVEL_CHOOSE"

userDate = {}

userDate.hightScore = 0
userDate.curScore = 0


