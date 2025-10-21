local RSGCore = exports['rsg-core']:GetCoreObject()
local MySQL = exports.oxmysql

-- Create table if it doesn't exist
Citizen.CreateThread(function()
    exports.oxmysql:executeSync([[
        CREATE TABLE IF NOT EXISTS `skills_data` (
            `citizenid` VARCHAR(50) NOT NULL,
            `skill` VARCHAR(50) NOT NULL,
            `xp` INT DEFAULT 0,
            `level` INT DEFAULT 1,
            PRIMARY KEY (`citizenid`, `skill`)
        )
    ]], {})
    print('Skills table checked/created')
end)

-- Export to get skill data (use metadata if available)
exports('GetSkillData', function(source, skill)
    local Player = RSGCore.Functions.GetPlayer(source)
    if not Player or not Config.Skills[skill] then
        return { xp = 0, level = 1 }
    end
    local xp = Player.PlayerData.metadata[skill .. '_xp'] or 0
    local level = Player.PlayerData.metadata[skill .. '_level'] or 1
    if xp == 0 and level == 1 then
        local citizenid = Player.PlayerData.citizenid
        local result = exports.oxmysql:fetchSync('SELECT xp, level FROM skills_data WHERE citizenid = :citizenid AND skill = :skill', {
            citizenid = citizenid,
            skill = skill
        })
        if result[1] then
            xp = result[1].xp
            level = result[1].level
        else
            exports.oxmysql:executeSync('INSERT INTO skills_data (citizenid, skill, xp, level) VALUES (:citizenid, :skill, :xp, :level) ON DUPLICATE KEY UPDATE xp = VALUES(xp), level = VALUES(level)', {
                citizenid = citizenid,
                skill = skill,
                xp = 0,
                level = 1
            })
        end
        Player.Functions.SetMetaData(skill .. '_xp', xp)
        Player.Functions.SetMetaData(skill .. '_level', level)
    end
    return { xp = xp, level = level }
end)

-- Export to add XP (update metadata only)
exports('AddSkillXP', function(source, skill, amount)
    if not Config.Skills[skill] then
        Config.Notify(source, 'Invalid skill: ' .. skill, 'error')
        return
    end
    local Player = RSGCore.Functions.GetPlayer(source)
    local currentXP = Player.PlayerData.metadata[skill .. '_xp'] or 0
    local currentLevel = Player.PlayerData.metadata[skill .. '_level'] or 1
    
    currentXP = currentXP + amount
    local newLevel = currentLevel
    for level, thresh in pairs(Config.Skills[skill].levelThresholds) do
        if currentXP >= thresh and level > newLevel then
            newLevel = level
        end
    end
    if newLevel > Config.Skills[skill].maxLevel then newLevel = Config.Skills[skill].maxLevel end
    
    Player.Functions.SetMetaData(skill .. '_xp', currentXP)
    Player.Functions.SetMetaData(skill .. '_level', newLevel)
    
    TriggerClientEvent('cb-skills:setSkill', source, skill, { xp = currentXP, level = newLevel })
    if newLevel > currentLevel then
        Config.Notify(source, skill .. ' Level up! Now level ' .. newLevel, 'success')
    end
end)

-- Load skills on player join and start periodic save
RegisterNetEvent('cb-skills:loadSkills')
AddEventHandler('cb-skills:loadSkills', function()
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    if not Player then return end
    local citizenid = Player.PlayerData.citizenid
    local skills = {}
    
    local result = exports.oxmysql:fetchSync('SELECT skill, xp, level FROM skills_data WHERE citizenid = :citizenid', {
        citizenid = citizenid
    })
    
    for skill, _ in pairs(Config.Skills) do
        skills[skill] = { xp = 0, level = 1 }
        for _, row in ipairs(result) do
            if row.skill == skill then
                skills[skill] = { xp = row.xp, level = row.level }
                break
            end
        end
        Player.Functions.SetMetaData(skill .. '_xp', skills[skill].xp)
        Player.Functions.SetMetaData(skill .. '_level', skills[skill].level)
        if skills[skill].xp == 0 and skills[skill].level == 1 then
            exports.oxmysql:executeSync('INSERT INTO skills_data (citizenid, skill, xp, level) VALUES (:citizenid, :skill, :xp, :level) ON DUPLICATE KEY UPDATE xp = VALUES(xp), level = VALUES(level)', {
                citizenid = citizenid,
                skill = skill,
                xp = 0,
                level = 1
            })
        end
    end
    
    TriggerClientEvent('cb-skills:setSkills', src, skills)
    
    -- Start periodic save for this player
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(Config.SaveInterval)
            if Player then
                SavePlayerSkills(src)
            else
                break
            end
        end
    end)
end)

-- Function to save skills to DB
local function SavePlayerSkills(source)
    local Player = RSGCore.Functions.GetPlayer(source)
    if Player then
        local citizenid = Player.PlayerData.citizenid
        for skill, _ in pairs(Config.Skills) do
            local xp = Player.PlayerData.metadata[skill .. '_xp'] or 0
            local level = Player.PlayerData.metadata[skill .. '_level'] or 1
            exports.oxmysql:executeSync('INSERT INTO skills_data (citizenid, skill, xp, level) VALUES (:citizenid, :skill, :xp, :level) ON DUPLICATE KEY UPDATE xp = :xp, level = :level', {
                citizenid = citizenid,
                skill = skill,
                xp = xp,
                level = level
            })
        end
    end
end

-- Save on player logout
AddEventHandler('playerDropped', function()
    local src = source
    SavePlayerSkills(src)
end)

-- Trigger skill loading on player spawn
AddEventHandler('RSGCore:Server:PlayerLoaded', function(player)
    TriggerClientEvent('cb-skills:loadSkills', player.PlayerData.source)
end)