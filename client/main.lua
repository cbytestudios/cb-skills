local playerSkills = {}

RegisterNetEvent('cb-skills:setSkills')
AddEventHandler('cb-skills:setSkills', function(skills)
    playerSkills = skills or {}
end)

RegisterNetEvent('cb-skills:setSkill')
AddEventHandler('cb-skills:setSkill', function(skill, data)
    local prev = playerSkills[skill] or { xp = 0, level = 1 }
    playerSkills[skill] = data
    if data.level > prev.level then
        exports.ox_lib:notify({ description = (skill .. ' leveled up! Now level ' .. data.level), type = 'success' })
    elseif data.xp > prev.xp then
        exports.ox_lib:notify({ description = ('Gained ' .. (data.xp - prev.xp) .. ' XP in ' .. skill), type = 'inform' })
    end
end)

-- Allow client scripts to request a local copy of skill data via exports
exports('GetSkillData', function(_playerId, skill)
    -- Ignore the playerId parameter; this returns local player's skill data
    return playerSkills[skill] or { xp = 0, level = 1 }
end)

-- Request skills from server on client spawn
AddEventHandler('playerSpawned', function()
    TriggerServerEvent('cb-skills:loadSkills')
end)

-- Also request skills when resource starts
AddEventHandler('onClientResourceStart', function(resName)
    if resName == GetCurrentResourceName() then
        TriggerServerEvent('cb-skills:loadSkills')
    end
end)
