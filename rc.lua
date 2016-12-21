awful = require("awful")
require("awful.autofocus")
awful.rules = require("awful.rules")
beautiful = require("beautiful")
naughty = require("naughty")
menubar = require("menubar")
wibox = require("wibox")
vicious = require("vicious")
network = require("network.pech")
-- net_widgets = require("net_widgets")

-- Load Debian menu entries
require("debian.menu")

--beautiful.init("/home/niko/.config/awesome/themes/zenburn/theme.lua")
--change this line next line to YOUR CONFIG PATH. My configd looks like:
--configd = "/home/niko/.config/awesome/"

-- Set default terminal
terminal =  "urxvt"

-- Set default text editor defined by $EDITOR or vi
-- Check your shell config for $EDITOR if it exists or "echo $EDITOR"
  local editor = os.getenv("EDITOR") or "atom"

function loadrc(name, mod)
   local success
   local result

   -- Which file? In rc/ or in lib/?
   local path = awful.util.getdir("config") .. "/" ..
      (mod and "lib" or "rc") ..
      "/" .. name .. ".lua"

   -- If the module is already loaded, don't load it again
   if mod and package.loaded[mod] then return package.loaded[mod] end

   -- Execute the RC/module file
   success, result = pcall(function() return dofile(path) end)
   if not success then
      naughty.notify({ title = "Error while loading an RC file",
		       text = "When loading `" .. name ..
			  "`, got the following error:\n" .. result,
		       preset = naughty.config.presets.critical
		     })
      return print("E: error loading RC file '" .. name .. "': " .. result)
   end

   -- Is it a module?
   if mod then
      return package.loaded[mod]
   end

   return result
end

loadrc("errors")		-- errors and debug stuff

-- Create cache directory
os.execute("test -d " .. awful.util.getdir("cache") ..
           " || mkdir -p " .. awful.util.getdir("cache"))

-- Global configuration
modkey = "Mod4"
config = {}
config.orig = {}
config.terminal = "urxvt"
config.homedir = os.getenv("HOME")
config.dir = os.getenv("HOME") .. "/.config/awesome"
config.exec   = awful.util.spawn
config.sexec  = awful.util.spawn_with_shell
config.editor = "atom"--os.getenv("EDITOR") or "editor"
config.editor_cmd = config.terminal .. " -e " .. config.editor
config.layouts = {
   awful.layout.suit.tile,
   awful.layout.suit.tile.bottom,
   awful.layout.suit.fair
}
config.tags = {
  names  = { "1", "2", "3", "4", 5, 6},
  layout = { config.layouts[1], config.layouts[1], config.layouts[1], config.layouts[1], config.layouts[1],
              config.layouts[1]}
}
config.hostname = awful.util.pread('uname -n'):gsub('\n', '')
config.browser = "google-chrome-stable"

config.orig.quit = awesome.quit
awesome.quit = function ()
    local scr = mouse.screen
    awful.prompt.run({prompt = "Quit (type 'yes' to confirm)? "},
    mypromptbox[scr].widget,
    function (t)
        if string.lower(t) == 'yes' then
            config.orig.quit()
        end
    end,
        function (t, p, n)
        return awful.completion.generic(t, p, n, {'no', 'NO', 'yes', 'YES'})
    end)
end


nettimer = timer({ timeout = 360 })
nettimer:connect_signal("timeout", function()
        mynetworklauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                                menu = mynetworkmenu()})
    end)

nettimer:start()

-- Remaining modules
loadrc("xrun")			-- xrun function
loadrc("appearance")		-- theme and appearance settings
loadrc("start")			-- programs to Ron start
loadrc("bindings")		-- keybindings
loadrc("wallpaper")		-- wallpaper settings
loadrc("widgets")		-- widgets configuration
loadrc("xlock")			-- lock screen
loadrc("signals")		-- window manager behaviour
loadrc("rules")			-- window rules
loadrc("quake")			-- quake console

root.keys(config.keys.global)
