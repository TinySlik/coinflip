local Levels = {}

Levels.NODE_IS_WHITE  = 1
Levels.NODE_IS_BLACK  = 0
Levels.NODE_IS_EMPTY  = "X"
Levels.NODE_IS_SOLID    = --[[00000001]] 1
Levels.NODE_IS_NORMAL   = --[[00000000]] 0
Levels.NODE_IS_ICE1     = --[[00000010]] 2
Levels.NODE_IS_ICE2     = --[[00000100]] 4
Levels.NODE_IS_ICE3     = --[[00000110]] 6
Levels.NODE_IS_ICE4     = --[[00001000]] 8
Levels.NODE_IS_ICE5     = --[[00001010]] 10
Levels.NODE_IS_ICE6     = --[[00001100]] 14
Levels.NODE_IS_ICE7     = --[[00001110]] 16
Levels.NODE_IS_COLF     = --[[00001001]] 9

Levels.NODE_IS_UP_B     = --[[10000000]] 128
Levels.NODE_IS_DOWN_B   = --[[01000000]] 64
Levels.NODE_IS_LEFT_B   = --[[00100000]] 32
Levels.NODE_IS_RIGHT_B  = --[[00010000]] 16
Levels.NODE_IS_BOUND    = --[[11110000]] 240

Levels.NODE_IS_LINK_U   = --[[01110000]] 112
Levels.NODE_IS_LINK_D   = --[[10110000]] 156

Levels.NODE_IS_EXTEND   = --[[11111111]] 255

local levelsData = {}

levelsData[1] = {
    rows = 8,
    cols = 8,
    grid = {
        {1, 1, 1, 1, 0, 1, 1, 0},
        {1, 1, 0, 1, 0, 1, 1, 0},
        {1, 0, 0, 0, 0, 1, 1, 0},
        {1, 1, 0, 1, 0, 1, 1, 0},
        {1, 1, 0, 1, 0, 1, 1, 0},
        {1, 1, 0, 1, 0, 1, 1, 0},
        {1, 1, 0, 1, 0, 1, 1, 0},
        {1, 1, 0, 1, 0, 1, 1, 0},
    }
}

levelsData[2] = {
    rows = 10,
    cols = 10,
    grid = {
        {1, 1, 1, 1, 0, 1, 1, 1, 0, 1},
        {1, 1, 0, 1, 0, 1, 1, 1, 0, 1},
        {1, 0, 0, 0, 0, 1, 1, 1, 0, 1},
        {1, 1, 0, 1, 0, 1, 1, 1, 0, 1},
        {1, 1, 0, 1, 0, 1, 1, 1, 0, 1},
        {1, 1, 0, 1, 0, 1, 1, 1, 0, 1},
        {1, 1, 0, 1, 0, 1, 1, 1, 0, 1},
        {1, 1, 0, 1, 0, 1, 1, 1, 0, 1},
        {1, 1, 0, 1, 0, 1, 1, 1, 0, 1},
        {1, 1, 0, 1, 0, 1, 1, 1, 0, 1},
    }
}

levelsData[3] = {
    rows = 4,
    cols = 4,
    grid = {
        {1, 0, 1, 1},
        {0, 0, 1, 1},
        {1, 1, 0, 0},
        {1, 1, 0, 1}
    }
}

levelsData[4] = {
    rows = 4,
    cols = 4,
    grid = {
        {0, 0, 0, 0},
        {0, 1, 1, 0},
        {0, 1, 1, 0},
        {0, 0, 0, 0}
    }
}

levelsData[5] = {
    rows = 4,
    cols = 4,
    grid = {
        {1, 0, 0, 1},
        {0, 0, 0, 0},
        {0, 0, 0, 0},
        {1, 0, 0, 1}
    }
}

levelsData[6] = {
    rows = 4,
    cols = 4,
    grid = {
        {1, 0, 0, 1},
        {0, 1, 1, 0},
        {0, 1, 1, 0},
        {1, 0, 0, 1}
    }
}

levelsData[7] = {
    rows = 4,
    cols = 4,
    grid = {
        {0, 1, 1, 1},
        {1, 0, 1, 1},
        {1, 1, 0, 1},
        {1, 1, 1, 0}
    }
}

levelsData[8] = {
    rows = 4,
    cols = 4,
    grid = {
        {0, 1, 0, 1},
        {1, 0, 0, 0},
        {0, 0, 0, 1},
        {1, 0, 1, 0}
    }
}

levelsData[9] = {
    rows = 4,
    cols = 4,
    grid = {
        {1, 0, 1, 0},
        {1, 0, 1, 0},
        {0, 0, 1, 0},
        {1, 0, 0, 1}
    }
}

levelsData[10] = {
    rows = 4,
    cols = 4,
    grid = {
        {1, 0, 1, 1},
        {1, 1, 0, 0},
        {0, 0, 1, 1},
        {1, 1, 0, 1}
    }
}

levelsData[11] = {
    rows = 4,
    cols = 4,
    grid = {
        {0, 1, 1, 0},
        {1, 0, 0, 1},
        {1, 0, 0, 1},
        {0, 1, 1, 0}
    }
}

levelsData[12] = {
    rows = 4,
    cols = 4,
    grid = {
        {0, 1, 1, 0},
        {0, 0, 0, 0},
        {1, 1, 1, 1},
        {0, 0, 0, 0}
    }
}

levelsData[13] = {
    rows = 4,
    cols = 4,
    grid = {
        {0, 1, 1, 0},
        {0, 0, 0, 0},
        {0, 0, 0, 0},
        {0, 1, 1, 0}
    }
}

levelsData[14] = {
    rows = 4,
    cols = 4,
    grid = {
        {1, 0, 1, 1},
        {0, 1, 0, 1},
        {1, 0, 1, 0},
        {1, 1, 0, 1}
    }
}

levelsData[15] = {
    rows = 4,
    cols = 4,
    grid = {
        {0, 1, 0, 1},
        {1, 0, 0, 0},
        {1, 0, 0, 0},
        {0, 1, 0, 1}
    }
}

levelsData[16] = {
    rows = 4,
    cols = 4,
    grid = {
        {0, 1, 1, 0},
        {1, 1, 1, 1},
        {1, 1, 1, 1},
        {0, 1, 1, 0}
    }
}

levelsData[17] = {
    rows = 4,
    cols = 4,
    grid = {
        {0, 1, 1, 1},
        {0, 1, 0, 0},
        {0, 0, 1, 0},
        {1, 1, 1, 0}
    }
}

levelsData[18] = {
    rows = 4,
    cols = 4,
    grid = {
        {0, 0, 0, 1},
        {0, 0, 1, 0},
        {0, 1, 0, 0},
        {1, 0, 0, 0}
    }
}

levelsData[19] = {
    rows = 4,
    cols = 4,
    grid = {
        {0, 1, 0, 0},
        {0, 1, 1, 0},
        {0, 0, 1, 1},
        {0, 0, 0, 0}
    }
}

levelsData[20] = {
    rows = 4,
    cols = 4,
    grid = {
        {0, 0, 0, 0},
        {0, 0, 0, 0},
        {0, 0, 0, 0},
        {0, 0, 0, 0}
    }
}

levelsData[21] = {
    rows = 4,
    cols = 5,
    grid = {
        {0, 0, 0, 0, 1},
        {1, 1, 0, 0, 0},
        {0, 0, 0, 1, 1},
        {1, 0, 0, 0, 0}
    }
}

levelsData[22] = {
    rows = 4,
    cols = 5,
    grid = {
        {0, 0, 1, 0, 1},
        {1, 1, 1, 0, 1},
        {1, 0, 1, 1, 1},
        {1, 0, 1, 0, 0}
    }
}

levelsData[23] = {
    rows = 4,
    cols = 5,
    grid = {
        {1, 1, 0, 0, 1},
        {0, 0, 1, 0, 1},
        {1, 0, 1, 0, 0},
        {1, 0, 0, 1, 1}
    }
}

levelsData[24] = {
    rows = 4,
    cols = 5,
    grid = {
        {1, 1, 1, 0, 1},
        {0, 1, 0, 1, 1},
        {1, 1, 1, 1, 0},
        {1, 0, 1, 1, 1}
    }
}

levelsData[25] = {
    rows = 4,
    cols = 5,
    grid = {
        {1, 1, 1, 1, 1},
        {1, 0, 1, 1, 1},
        {1, 1, 1, 1, 1},
        {1, 1, 1, 1, 1}
    }
}

levelsData[26] = {
    rows = 4,
    cols = 5,
    grid = {
        {0, 1, 1, 1, 0},
        {1, 0, 1, 0, 1},
        {1, 1, 1, 1, 1},
        {0, 0, 1, 0, 0}
    }
}

levelsData[27] = {
    rows = 4,
    cols = 5,
    grid = {
        {0, 1, 1, 1, 1},
        {0, 0, 0, 1, 1},
        {1, 1, 0, 0, 0},
        {1, 1, 1, 1, 0}
    }
}

levelsData[28] = {
    rows = 4,
    cols = 5,
    grid = {
        {0, 1, 0, 0, 1},
        {0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0},
        {0, 1, 0, 0, 1}
    }
}

levelsData[29] = {
    rows = 4,
    cols = 5,
    grid = {
        {0, 1, 0, 0, 1},
        {1, 1, 1, 1, 0},
        {1, 1, 1, 1, 0},
        {0, 1, 0, 0, 1}
    }
}

levelsData[30] = {
    rows = 4,
    cols = 5,
    grid = {
        {1, 1, 1, 1, 1},
        {1, 1, 0, 0, 1},
        {1, 0, 0, 1, 1},
        {1, 1, 1, 1, 1}
    }
}

levelsData[31] = {
    rows = 4,
    cols = 5,
    grid = {
        {1, 0, 0, 0, 1},
        {0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0},
        {1, 0, 0, 0, 1}
    }
}

levelsData[32] = {
    rows = 4,
    cols = 5,
    grid = {
        {0, 0, 1, 0, 0},
        {1, 1, 1, 0, 0},
        {0, 0, 1, 1, 1},
        {0, 0, 1, 0, 0}
    }
}

levelsData[33] = {
    rows = 4,
    cols = 5,
    grid = {
        {0, 0, 1, 1, 0},
        {0, 0, 0, 0, 1},
        {1, 0, 0, 0, 0},
        {0, 1, 1, 0, 0}
    }
}

levelsData[34] = {
    rows = 4,
    cols = 5,
    grid = {
        {0, 0, 0, 0, 0},
        {0, 0, 1, 0, 0},
        {0, 0, 1, 0, 0},
        {0, 0, 0, 0, 0}
    }
}

levelsData[35] = {
    rows = 4,
    cols = 5,
    grid = {
        {0, 0, 1, 0, 0},
        {1, 1, 0, 1, 1},
        {1, 1, 0, 1, 1},
        {0, 0, 1, 0, 0}
    }
}

levelsData[36] = {
    rows = 4,
    cols = 5,
    grid = {
        {0, 0, 0, 0, 1},
        {0, 0, 0, 1, 0},
        {0, 1, 0, 0, 0},
        {1, 0, 0, 0, 0}
    }
}

levelsData[37] = {
    rows = 4,
    cols = 5,
    grid = {
        {1, 1, 0, 1, 0},
        {0, 0, 0, 0, 1},
        {1, 0, 0, 0, 0},
        {0, 1, 0, 1, 1}
    }
}

levelsData[38] = {
    rows = 4,
    cols = 5,
    grid = {
        {1, 0, 1, 1, 0},
        {1, 0, 0, 0, 0},
        {0, 0, 0, 0, 1},
        {0, 1, 1, 0, 1}
    }
}

levelsData[39] = {
    rows = 4,
    cols = 5,
    grid = {
        {0, 1, 0, 1, 0},
        {0, 0, 0, 0, 0},
        {0, 1, 0, 0, 1},
        {0, 0, 0, 0, 0}
    }
}

levelsData[40] = {
    rows = 4,
    cols = 5,
    grid = {
        {0, 0, 1, 0, 0},
        {0, 1, 0, 1, 0},
        {0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0}
    }
}

levelsData[41] = {
    rows = 5,
    cols = 5,
    grid = {
        {1, 1, 1, 1, 0},
        {1, 1, 0, 0, 1},
        {1, 0, 1, 0, 1},
        {1, 0, 0, 1, 1},
        {0, 1, 1, 1, 1}
    }
}

levelsData[42] = {
    rows = 5,
    cols = 5,
    grid = {
        {1, 1, 0, 0, 1},
        {1, 0, 1, 0, 1},
        {0, 0, 0, 0, 0},
        {1, 0, 1, 0, 1},
        {1, 0, 0, 1, 1}
    }
}

levelsData[43] = {
    rows = 5,
    cols = 5,
    grid = {
        {0, 1, 1, 1, 0},
        {1, 0, 0, 0, 1},
        {1, 0, 0, 0, 1},
        {1, 0, 0, 0, 1},
        {0, 1, 1, 1, 0}
    }
}

levelsData[44] = {
    rows = 5,
    cols = 5,
    grid = {
        {1, 0, 0, 1, 0},
        {0, 1, 1, 1, 1},
        {0, 1, 0, 1, 0},
        {1, 1, 1, 1, 0},
        {0, 1, 0, 0, 1}
    }
}

levelsData[45] = {
    rows = 5,
    cols = 5,
    grid = {
        {0, 1, 0, 1, 0},
        {1, 0, 1, 1, 1},
        {0, 1, 0, 0, 1},
        {1, 1, 0, 0, 1},
        {0, 1, 1, 1, 0}
    }
}

levelsData[46] = {
    rows = 5,
    cols = 5,
    grid = {
        {0, 1, 0, 1, 0},
        {0, 1, 1, 1, 0},
        {1, 0, 0, 0, 1},
        {0, 1, 1, 1, 0},
        {0, 1, 0, 1, 0}
    }
}

levelsData[47] = {
    rows = 5,
    cols = 5,
    grid = {
        {0, 0, 0, 1, 1},
        {0, 1, 0, 1, 1},
        {0, 0, 1, 0, 0},
        {1, 1, 0, 1, 0},
        {1, 1, 0, 0, 0}
    }
}


function Levels.numLevels()
    return #levelsData
end

function Levels.get(levelIndex)
    assert(levelIndex >= 1 and levelIndex <= #levelsData, string.format("levelsData.get() - invalid levelIndex %s", tostring(levelIndex)))
    return clone(levelsData[levelIndex])
end

return Levels