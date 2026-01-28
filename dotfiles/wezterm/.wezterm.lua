local wezterm = require("wezterm")
local config = wezterm.config_builder()

local home = os.getenv("HOME")
local background_folder = home .. "/Pictures/Wallpapers"

local bg_image = home .. "/Pictures/Wallpapers/random_wallpaper.png"
local brightness = 0.05
local opacity = 0.8

local function get_random_bg(folder)
    local files = wezterm.read_dir(folder)
    local images = {}
    if files then
        for _, file in ipairs(files) do
            -- Chỉ lấy file ảnh
            if file:match("%.png$") or file:match("%.jpg$") or file:match("%.jpeg$") then
                table.insert(images, file)
            end
        end
    end
    if #images > 0 then
        return images[math.random(#images)]
    end
    return nil
end

local function update_appearance(window)
    window:set_config_overrides({
        font = wezterm.font("JetBrains Mono Nerd Font", { weight = "Medium", stretch = "Expanded" }),
        font_size = 14,
        background = {
            {
                source = { File = bg_image },
                width = 'Cover',
                height = 'Cover',
                opacity = opacity,
                horizontal_align = 'Center',
                vertical_align = 'Middle',
                hsb = { brightness = brightness },
            },
        },
    })
end

config.font = wezterm.font("JetBrains Mono Nerd Font", { weight = "Medium", stretch = "Expanded" })
config.font_size = 14
config.color_scheme = "Tokyo Night"
config.window_decorations = "NONE"
config.enable_tab_bar = false
config.window_padding = { left = 15, right = 15, top = 15, bottom = 15 }

config.background = {
    {
        source = { File = bg_image },
        width = 'Cover',
        height = 'Cover',
        opacity = opacity,
        horizontal_align = 'Center',
        vertical_align = 'Middle',
        hsb = { brightness = brightness },
    },
}

config.keys = {
    {
        key = "b",
        mods = "CTRL|SHIFT",
        action = wezterm.action_callback(function(window)
            local new_bg = get_random_bg(background_folder)
            if new_bg then
                bg_image = new_bg
                update_appearance(window)
                wezterm.log_info("New bg: " .. bg_image)
            end
        end),
    },
    {
        key = ">",
        mods = "CTRL|SHIFT",
        action = wezterm.action_callback(function(window)
            brightness = math.min(brightness + 0.05, 1.0)
            update_appearance(window)
        end),
    },
    {
        key = "<",
        mods = "CTRL|SHIFT",
        action = wezterm.action_callback(function(window)
            brightness = math.max(brightness - 0.05, 0.0)
            update_appearance(window)
        end),
    },
    {
        key = 'Backspace',
        mods = 'CTRL',
        action = wezterm.action.SendString '\x17',
    },
}

config.default_cursor_style = "BlinkingUnderline"
config.max_fps = 180

return config