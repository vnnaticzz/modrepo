-- Init.lua for CustomizeLootSpawns
-- Applies sandbox multipliers to Distributions (runs once after distributions are merged)

local function getSandboxMultiplier(key, default)
    if SandboxVars and SandboxVars.CustomizeLootSpawns and SandboxVars.CustomizeLootSpawns[key] ~= nil then
        return tonumber(SandboxVars.CustomizeLootSpawns[key]) or default
    end
    if SandboxVars and SandboxVars[key] ~= nil then
        return tonumber(SandboxVars[key]) or default
    end
    return default
end

local function lower(s) return s and tostring(s):lower() or "" end

local function applyMultipliers()
    local sledgeMul = getSandboxMultiplier("Sledgehammer", 5.0)
    local firearmsMul = getSandboxMultiplier("Firearms", 5.0)
    local meleeMul = getSandboxMultiplier("Melee", 5.0)
    local foodMul = getSandboxMultiplier("Food", 5.0)

    local function isSledge(item)
        local n = lower(item)
        return string.find(n, "sledge") ~= nil
    end
    local function isFirearm(item)
        local n = lower(item)
        return string.find(n, "gun") or string.find(n, "pistol") or string.find(n, "rifle") or string.find(n, "shotgun") or string.find(n, "ammo")
    end
    local function isMelee(item)
        local n = lower(item)
        if isSledge(item) then return false end
        return string.find(n, "axe") or string.find(n, "bat") or string.find(n, "machete") or string.find(n, "crowbar") or string.find(n, "club") or string.find(n, "hammer") or string.find(n, "katana") or string.find(n, "knife")
    end
    local function isFood(item)
        local n = lower(item)
        return string.find(n, "food") or string.find(n, "canned") or string.find(n, "can") or string.find(n, "bread") or string.find(n, "meat") or string.find(n, "soup") or string.find(n, "water") or string.find(n, "grain") or string.find(n, "corn")
    end

    for distName, dist in pairs(Distributions) do
        if type(dist) == "table" then
            if dist.items and type(dist.items) == "table" then
                for i = 1, #dist.items, 2 do
                    local item = dist.items[i]
                    local weight = dist.items[i+1]
                    if type(item) == "string" and type(weight) == "number" then
                        if isSledge(item) and sledgeMul ~= 1.0 then
                            dist.items[i+1] = math.max(1, math.floor(weight * sledgeMul))
                        elseif isFirearm(item) and firearmsMul ~= 1.0 then
                            dist.items[i+1] = math.max(1, math.floor(weight * firearmsMul))
                        elseif isMelee(item) and meleeMul ~= 1.0 then
                            dist.items[i+1] = math.max(1, math.floor(weight * meleeMul))
                        elseif isFood(item) and foodMul ~= 1.0 then
                            dist.items[i+1] = math.max(1, math.floor(weight * foodMul))
                        end
                    end
                end
            end
            for k,v in pairs(dist) do
                if type(v) == "table" and v.items and type(v.items) == "table" then
                    for i = 1, #v.items, 2 do
                        local item = v.items[i]
                        local weight = v.items[i+1]
                        if type(item) == "string" and type(weight) == "number" then
                            if isSledge(item) and sledgeMul ~= 1.0 then
                                v.items[i+1] = math.max(1, math.floor(weight * sledgeMul))
                            elseif isFirearm(item) and firearmsMul ~= 1.0 then
                                v.items[i+1] = math.max(1, math.floor(weight * firearmsMul))
                            elseif isMelee(item) and meleeMul ~= 1.0 then
                                v.items[i+1] = math.max(1, math.floor(weight * meleeMul))
                            elseif isFood(item) and foodMul ~= 1.0 then
                                v.items[i+1] = math.max(1, math.floor(weight * foodMul))
                            end
                        end
                    end
                end
            end
        end
    end
end

Events.OnPostDistributionMerge.Add(function()
    local ok, err = pcall(applyMultipliers)
    if not ok then
        print("CustomizeLootSpawns: error applying multipliers: " .. tostring(err))
    else
        print("CustomizeLootSpawns: multipliers applied (Sledge=" .. tostring(getSandboxMultiplier("Sledgehammer",5.0)) ..
              ", Firearms=" .. tostring(getSandboxMultiplier("Firearms",5.0)) ..
              ", Melee=" .. tostring(getSandboxMultiplier("Melee",5.0)) ..
              ", Food=" .. tostring(getSandboxMultiplier("Food",5.0)) .. ")")
    end
end)
