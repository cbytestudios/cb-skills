Config = {}

-- Skills Configuration
Config.Skills = {
    mining = {
        xpPerAction = 10,
        levelThresholds = {
            [1] = 0,
            [2] = 100,
            [3] = 300,
            [4] = 600,
            [5] = 1000,
        },
        maxLevel = 5,
        levelBonuses = {
            [1] = {yieldMultiplier = 1.0, timeReducer = 0},
            [2] = {yieldMultiplier = 1.1, timeReducer = 1000},
            [3] = {yieldMultiplier = 1.2, timeReducer = 2000},
            [4] = {yieldMultiplier = 1.3, timeReducer = 3000},
            [5] = {yieldMultiplier = 1.5, timeReducer = 5000},
        }
    },
    smelting = {
        xpPerAction = 15,
        levelThresholds = {
            [1] = 0,
            [2] = 150,
            [3] = 400,
            [4] = 800,
            [5] = 1200,
        },
        maxLevel = 5,
        levelBonuses = {
            [1] = {yieldMultiplier = 1.0, timeReducer = 0},
            [2] = {yieldMultiplier = 1.1, timeReducer = 1000},
            [3] = {yieldMultiplier = 1.2, timeReducer = 2000},
            [4] = {yieldMultiplier = 1.3, timeReducer = 3000},
            [5] = {yieldMultiplier = 1.5, timeReducer = 5000},
        }
    },
    prospecting = {
        xpPerAction = 12,
        levelThresholds = {
            [1] = 0,
            [2] = 120,
            [3] = 350,
            [4] = 700,
            [5] = 1100,
        },
        maxLevel = 5,
        levelBonuses = {
            [1] = {yieldMultiplier = 1.0, timeReducer = 0},
            [2] = {yieldMultiplier = 1.1, timeReducer = 1000},
            [3] = {yieldMultiplier = 1.2, timeReducer = 2000},
            [4] = {yieldMultiplier = 1.3, timeReducer = 3000},
            [5] = {yieldMultiplier = 1.5, timeReducer = 5000},
        }
    },
    crafting = {
        xpPerAction = 20,
        levelThresholds = {
            [1] = 0,
            [2] = 200,
            [3] = 500,
            [4] = 900,
            [5] = 1500,
        },
        maxLevel = 5,
        levelBonuses = {
            [1] = {yieldMultiplier = 1.0, timeReducer = 0},
            [2] = {yieldMultiplier = 1.1, timeReducer = 1000},
            [3] = {yieldMultiplier = 1.2, timeReducer = 2000},
            [4] = {yieldMultiplier = 1.3, timeReducer = 3000},
            [5] = {yieldMultiplier = 1.5, timeReducer = 5000},
        }
    },
    -- Add more skills here
}

-- Notify Function
Config.Notify = function(src, msg, type)
    TriggerClientEvent('RSGCore:Notify', src, msg, type or 'primary')
end

Config.SaveInterval = 300000 -- 5 minutes in ms