-- Sandbox defaults for Boosted Loot — Garage & Police+
if SandboxVars == nil then SandboxVars = {} end
if SandboxVars.BoostedLoot == nil then SandboxVars.BoostedLoot = {} end

local sb = SandboxVars.BoostedLoot

-- master enable
if sb.Enabled == nil then sb.Enabled = true end

-- multipliers (defaults user requested: 5x)
if sb.SledgeMultiplier == nil then sb.SledgeMultiplier = 5 end
if sb.WeaponsMultiplier == nil then sb.WeaponsMultiplier = 5 end
if sb.AmmoMultiplier == nil then sb.AmmoMultiplier = 5 end
if sb.FoodMultiplier == nil then sb.FoodMultiplier = 5 end

-- toggles
if sb.BoostSledge == nil then sb.BoostSledge = true end
if sb.BoostWeapons == nil then sb.BoostWeapons = true end
if sb.BoostAmmo == nil then sb.BoostAmmo = true end
if sb.BoostFood == nil then sb.BoostFood = true end
