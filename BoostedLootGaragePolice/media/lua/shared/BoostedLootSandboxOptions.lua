-- Register Sandbox options so you can change multipliers in-game (Sandbox -> BoostedLoot)

if SandboxOptions then
    SandboxOptions.RegisterSandboxVar("BoostedLoot", "Enabled", {
        name = "Enable Boosted Loot (Garage & Police+)",
        tip  = "Enable or disable the Boosted Loot mod.",
        default = true,
        type = "Boolean",
    })

    SandboxOptions.RegisterSandboxVar("BoostedLoot", "SledgeMultiplier", {
        name = "Sledgehammer Multiplier (garages/gudang)",
        tip  = "Multiplier for adding/boosting Sledgehammer in garage/warehouse containers.",
        default = 5,
        type = "Number",
        min = 0,
        max = 50,
    })

    SandboxOptions.RegisterSandboxVar("BoostedLoot", "WeaponsMultiplier", {
        name = "Weapons Multiplier (houses & police)",
        tip  = "Multiplier for weapons spawn weights in houses and police locations.",
        default = 5,
        type = "Number",
        min = 0,
        max = 50,
    })

    SandboxOptions.RegisterSandboxVar("BoostedLoot", "AmmoMultiplier", {
        name = "Ammo Multiplier (houses & police)",
        tip  = "Multiplier for ammo spawn weights in houses and police locations.",
        default = 5,
        type = "Number",
        min = 0,
        max = 50,
    })

    SandboxOptions.RegisterSandboxVar("BoostedLoot", "FoodMultiplier", {
        name = "Food Multiplier",
        tip  = "Multiplier for food & drink spawn weights (grocery/kitchen/fridge/restaurants).",
        default = 5,
        type = "Number",
        min = 0,
        max = 50,
    })

    SandboxOptions.RegisterSandboxVar("BoostedLoot", "BoostSledge", {
        name = "Boost Sledgehammer (garages/gudang)",
        tip  = "Toggle Sledgehammer boosting in tool-like containers.",
        default = true,
        type = "Boolean",
    })
    SandboxOptions.RegisterSandboxVar("BoostedLoot", "BoostWeapons", {
        name = "Boost Weapons (houses & police)",
        tip  = "Toggle weapons boosting in houses and police.",
        default = true,
        type = "Boolean",
    })
    SandboxOptions.RegisterSandboxVar("BoostedLoot", "BoostAmmo", {
        name = "Boost Ammo (houses & police)",
        tip  = "Toggle ammo boosting in houses and police.",
        default = true,
        type = "Boolean",
    })
    SandboxOptions.RegisterSandboxVar("BoostedLoot", "BoostFood", {
        name = "Boost Food",
        tip  = "Toggle global food boosting.",
        default = true,
        type = "Boolean",
    })
end
