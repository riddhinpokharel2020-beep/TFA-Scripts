-- Throw Food For Animals | Luna GUI for the auto farm
-- Needs the auto-farm script (ThrowFoodForAnimals_AutoFarm) to be running; it edits getgenv().TFA_Config live.

local cfg = getgenv().TFA_Config
if not cfg then
    warn("[TFA GUI] run ThrowFoodForAnimals_AutoFarm first")
    return
end

local Luna = loadstring(game:HttpGet("https://raw.githubusercontent.com/Nebula-Softworks/Luna-Interface-Suite/master/source.lua", true))()

local Window = Luna:CreateWindow({
    Name = "Throw Food For Animals",
    Subtitle = "Auto Farm",
    LogoID = nil,
    LoadingEnabled = false,
    LoadingTitle = "Throw Food For Animals",
    LoadingSubtitle = "Auto Farm",
    ConfigSettings = {
        RootFolder = nil,
        ConfigFolder = "TFA AutoFarm",
    },
    KeySystem = false,
})

----------------------------------------------------------------------
-- Farm tab
----------------------------------------------------------------------
local Farm = Window:CreateTab({
    Name = "Farm",
    Icon = "agriculture",
    ImageSource = "Material",
    ShowTitle = true,
})

local function toggle(tab, name, key, desc, flag)
    tab:CreateToggle({
        Name = name,
        Description = desc,
        CurrentValue = cfg[key],
        Callback = function(v) cfg[key] = v end,
    }, flag)
end

Farm:CreateSection("Main")
toggle(Farm, "Auto Throw",     "AutoThrow",    "Throws food and taps the meter at the peak (PERFECT)", "AutoThrow")
toggle(Farm, "Auto Train",     "AutoTrain",    "Trains on the pull-up bar for Throw Power",            "AutoTrain")
toggle(Farm, "Auto Tap Bonus", "AutoTapBonus", "Claims the tap-bonus bubbles while training",          "AutoTapBonus")
toggle(Farm, "Auto Sell",      "AutoSell",     "Sells everything in your backpack",                    "AutoSell")

Farm:CreateSection("Shop")
toggle(Farm, "Auto Buy Food",      "AutoBuyFood",      "Buys the next food when you can afford it", "AutoBuyFood")
toggle(Farm, "Auto Upgrade Stand", "AutoUpgradeStand", "Upgrades the stand when you can afford it", "AutoUpgradeStand")
toggle(Farm, "Auto Equip Best",    "AutoEquipBest",    "Equips your best animals on the plot",      "AutoEquipBest")
toggle(Farm, "Auto Claim Free",    "AutoClaimFree",    "Free shop reward and offline earnings",     "AutoClaimFree")

----------------------------------------------------------------------
-- Timing tab
----------------------------------------------------------------------
local Timing = Window:CreateTab({
    Name = "Timing",
    Icon = "timer",
    ImageSource = "Material",
    ShowTitle = true,
})

Timing:CreateSection("Throw / train cycle")
Timing:CreateSlider({
    Name = "Train seconds",
    Range = {10, 300},
    Increment = 5,
    CurrentValue = cfg.TrainSeconds,
    Callback = function(v) cfg.TrainSeconds = v end,
}, "TrainSeconds")
Timing:CreateSlider({
    Name = "Throws per cycle",
    Range = {1, 50},
    Increment = 1,
    CurrentValue = cfg.ThrowsPerCycle,
    Callback = function(v) cfg.ThrowsPerCycle = v end,
}, "ThrowsPerCycle")

Timing:CreateSection("Intervals")
Timing:CreateSlider({
    Name = "Sell interval (s)",
    Range = {5, 60},
    Increment = 1,
    CurrentValue = cfg.SellInterval,
    Callback = function(v) cfg.SellInterval = v end,
}, "SellInterval")
Timing:CreateSlider({
    Name = "Shop interval (s)",
    Range = {5, 60},
    Increment = 1,
    CurrentValue = cfg.ShopInterval,
    Callback = function(v) cfg.ShopInterval = v end,
}, "ShopInterval")

Timing:CreateSection("Meter")
Timing:CreateSlider({
    Name = "Meter offset (s)",
    Range = {-0.1, 0.1},
    Increment = 0.01,
    CurrentValue = cfg.MeterOffset,
    Callback = function(v) cfg.MeterOffset = v end,
}, "MeterOffset")

----------------------------------------------------------------------
-- Misc tab
----------------------------------------------------------------------
local Misc = Window:CreateTab({
    Name = "Misc",
    Icon = "settings",
    ImageSource = "Material",
    ShowTitle = true,
})

Misc:CreateButton({
    Name = "Sell all now",
    Description = nil,
    Callback = function()
        local Remotes = require(game:GetService("ReplicatedStorage").Shared.Remotes)
        local ok, r = pcall(Remotes.Invoke, "Plot_SellAll")
        Luna:Notification({
            Title = "Sell all",
            Icon = "paid",
            ImageSource = "Material",
            Content = (ok and type(r) == "table" and r.Ok) and ("Sold " .. tostring(r.Count or 0) .. " animals") or "Nothing to sell",
        })
    end,
})

Misc:CreateButton({
    Name = "Stop farm",
    Description = "Stops every loop (the GUI stays open)",
    Callback = function()
        if getgenv().TFA_Stop then pcall(getgenv().TFA_Stop) end
        Luna:Notification({
            Title = "Auto farm",
            Icon = "stop",
            ImageSource = "Material",
            Content = "Farm stopped. Re-run the farm script to start it again.",
        })
    end,
})

Misc:CreateSection("Theme")
Window:CreateTab({ Name = "Theme", Icon = "palette", ImageSource = "Material", ShowTitle = true }):BuildThemeSection()

Luna:Notification({
    Title = "Throw Food For Animals",
    Icon = "notifications_active",
    ImageSource = "Material",
    Content = "Aal Hub loaded.",
})
