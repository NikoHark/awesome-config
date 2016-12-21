-- Lockscreen

local lock = function()
   os.execute("gnome-screensaver-command -l")
end

config.keys.global = awful.util.table.join(
   config.keys.global,
   awful.key({}, "XF86ScreenSaver", lock),
   awful.key({ modkey, }, "Delete", lock))
