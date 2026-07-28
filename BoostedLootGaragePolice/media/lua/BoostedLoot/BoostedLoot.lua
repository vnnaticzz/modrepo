-- Boosted Loot — Garage & Police+ (applies after distributions merge)
-- Applies:
--  - Sledgehammer boost in garage/tool/warehouse-like containers
--  - Weapons & Ammo boost in house-related and police containers
--  - Food & drink boost in grocery/kitchen/fridge/restaurant containers

local function isString(s) return type(s) == "string" end

local function containsAny(s, tbl)
    if not s then return false end
    s = s:lower()
    for _,v in ipairs(tbl) do
        if s:find(v) then return true end
    end
    return false
end

-- predicates for item names (simple heuristics based on your build's names)
local weaponPatterns = {"pistol","revolver","shotgun","rifle","assault","varmint","assaultrifle","doublebarrel","msr","js14","js3t","assaultrifle"}
local ammoPatterns = {"clip","bullets","9mm","556","308","shotgunshell","shells","box","cartridge"}
local foodPatterns = {"canned","tinned","crisps","ramen","bread","apple","beefjerky","cookie","chocolate","granola","pop","soda","water","juice","milk","tinned","beef","burger","pizza","tinned"}
local toolPatterns = {"hammer","crowbar","sledge","wrench","pipe","multitool","handdrill","saw","shovel","axe","machete"}

local function isWeaponItem(name) return isString(name) and containsAny(name, weaponPatterns) end
local function isAmmoItem(name)   return isString(name) and containsAny(name, ammoPatterns) end
local function isFoodItem(name)   return isString(name) and containsAny(name, foodPatterns) end
local function isToolLikeItem(name) return isString(name) and containsAny(name, toolPatterns) end

-- key-based detection for containers:
local houseKeyPatterns = {"house","home","kitchen","bedroom","living","motel","motelroom","house_kitchen","bed","wardrobe","closet","cabinet"}
local policeKeyPatterns = {"police","cop","station","lockers","police"}
local garageKeyPatterns = {"garage","mechanic","garagestorage","tool","workshop","shed","storage","warehouse","armysurplus","armysurplustorage","toolstore"}

local function keyMatches(key, patterns)
    if not key then return false end
    if type(key) ~= "string" then return false end
    return containsAny(key, patterns)
end

-- Multiply matching items inside an items table (name, weight, name, weight, ...)
local function multiplyItemsInList(list, predicate, mult)
    if not list or type(list) ~= "table" then return end
    for i = 1, #list, 2 do
        local name = list[i]
        local weight = list[i+1]
        if isString(name) and type(weight) == "number" and predicate(name) then
            list[i+1] = weight * mult
        end
    end
end

-- Recursively traverse a distribution subtable
local function traverseAndApply(dist, predicate, mult, key)
    if type(dist) ~= "table" then return end
    for k,v in pairs(dist) do
        if k == "items" and type(v) == "table" then
            multiplyItemsInList(v, predicate, mult)
        elseif type(v) == "table" then
            traverseAndApply(v, predicate, mult, key)
        end
    end
end

-- Add Sledgehammer to tool-like containers (only add if the container already has tools)
local function addSledgeIfToolContainer(dist, sledgeWeight)
    if type(dist) ~= "table" then return end
    for k,v in pairs(dist) do
        if type(v) == "table" and type(v.items) == "table" then
            local hasTool = false
            for i = 1, #v.items, 2 do
                local item = v.items[i]
                if isToolLikeItem(item) then hasTool = true; break end
            end
            if hasTool then
                -- check not already present
                local present = false
                for i = 1, #v.items, 2 do
                    local item = v.items[i]
                    if item == "Sledgehammer" or item == "Base.Sledgehammer" or item == "Sledgehammer2" then present = true; break end
                end
                if not present then
                    table.insert(v.items, "Sledgehammer")
                    table.insert(v.items, sledgeWeight)
                    table.insert(v.items, "Base.Sledgehammer")
                    table.insert(v.items, sledgeWeight)
                end
            end
        end
        if type(v) == "table" then
            addSledgeIfToolContainer(v, sledgeWeight)
        end
    end
end

-- Apply boosts after distributions merged
local function applyBoosts()
    if not Distributions then
        print("BoostedLoot: no Distributions table found.")
        return
    end

    local root = SuburbsDistributions or Distributions[1]
    if not root then
        print("BoostedLoot: no distribution root.")
        return
    end

    local sb = SandboxVars and SandboxVars.BoostedLoot or {}
    local enabled = (sb.Enabled == nil) and true or sb.Enabled
    if not enabled then
        print("BoostedLoot: disabled via SandboxVars.")
        return
    end

    local sledgeMult = tonumber(sb.SledgeMultiplier or 5) or 5
    local weaponsMult = tonumber(sb.WeaponsMultiplier or 5) or 5
    local ammoMult = tonumber(sb.AmmoMultiplier or 5) or 5
    local foodMult = tonumber(sb.FoodMultiplier or 5) or 5

    local boostSledge = (sb.BoostSledge == nil) and true or sb.BoostSledge
    local boostWeapons = (sb.BoostWeapons == nil) and true or sb.BoostWeapons
    local boostAmmo = (sb.BoostAmmo == nil) and true or sb.BoostAmmo
    local boostFood = (sb.BoostFood == nil) and true or sb.BoostFood

    -- Iterate root children (top-level distribution keys)
    for distKey, distVal in pairs(root) do
        if type(distVal) == "table" then
            local key = tostring(distKey):lower()

            -- 1) Sledgehammer in garages/gudang/tool-like: if key matches or content suggests tools
            if boostSledge then
                if keyMatches(key, garageKeyPatterns) then
                    -- add sledge with weight base * multiplier (base weight 4)
                    local w = 4 * sledgeMult
                    -- ensure we add to this subtable only
                    if type(distVal.items) == "table" then
                        -- add directly to this items list
                        local present = false
                        for i=1,#distVal.items,2 do
                            if distVal.items[i] == "Sledgehammer" or distVal.items[i] == "Base.Sledgehammer" then present = true; break end
                        end
                        if not present then
                            table.insert(distVal.items, "Sledgehammer")
                            table.insert(distVal.items, w)
                            table.insert(distVal.items, "Base.Sledgehammer")
                            table.insert(distVal.items, w)
                        end
                    end
                else
                    -- still attempt to detect tool-like containers by item contents and add sledge there too
                    if boostSledge then
                        addSledgeIfToolContainer({[distKey]=distVal}, 4 * sledgeMult)
                    end
                end
            end

            -- 2) Weapons & ammo boost for house-related and police keys
            if boostWeapons or boostAmmo then
                if keyMatches(key, houseKeyPatterns) or keyMatches(key, policeKeyPatterns) then
                    if boostWeapons then
                        traverseAndApply(distVal, isWeaponItem, weaponsMult, key)
                    end
                    if boostAmmo then
                        traverseAndApply(distVal, isAmmoItem, ammoMult, key)
                    end
                end
            end

            -- 3) Food boost: apply to food-related containers (grocery/kitchen/fridge/restaurant) — but also to general food entries
            if boostFood then
                if keyMatches(key, {"grocery","supermarket","grocery","fridge","kitchen","restaurant","diner","lunch","takeout","produce","food","pantry","store"}) then
                    traverseAndApply(distVal, isFoodItem, foodMult, key)
                else
                    -- also scan and if the items table contains food, boost those food items
                    if type(distVal.items) == "table" then
                        -- quick check if items list has any food
                        local hasFood = false
                        for i=1,#distVal.items,2 do
                            if isFoodItem(distVal.items[i]) then hasFood = true; break end
                        end
                        if hasFood then
                            traverseAndApply(distVal, isFoodItem, foodMult, key)
                        end
                    end
                end
            end
        end
    end

    print("BoostedLoot: applied Sledge/Weapons/Ammo/Food boosts.")
end

Events.OnDistributionMerge.Add(function()
    -- run after the game merges distributions (ensures compatibility with other mods)
    applyBoosts()
end)
