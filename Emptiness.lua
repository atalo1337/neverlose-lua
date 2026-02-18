local pui = require("neverlose/pui")
local base64 = require("neverlose/base64")
local clipboard = require("neverlose/clipboard")
local gradient = require("neverlose/gradient")
local drag_system = require("neverlose/drag_system")
local ffi = require("ffi")
local bit = require("bit")

-- ============================================
-- DEV USER DETECTION & LICENSE SYSTEM
-- ============================================
local dev_users = {"CrimsonCode", "madongyu123"}

local license = {
    buy_users = {},
    db_key = "crimson_license",
    reload_key = "crimson_reload",
    
    hex_to_string = function(hex)
        local str = ""
        for i = 1, #hex, 2 do
            local byte = tonumber(hex:sub(i, i + 1), 16)
            if byte then
                str = str .. string.char(byte)
            end
        end
        return str
    end
}

function license.validate_key(key)
    if not key or key == "" then return nil end
    local hex = key:gsub("-", "")
    local b64 = license.hex_to_string(hex)
    if not b64 or b64 == "" then return nil end
    local success, raw = pcall(base64.decode, b64)
    if not success or not raw then return nil end
    -- 支持新格式: CRIMSON|username|timestamp|random 和旧格式: CRIMSON|username
    local prefix, username = raw:match("^(CRIMSON)|([^|]+)")
    if not prefix or not username then return nil end
    return username
end

function license.load()
    local stored = db[license.db_key]
    if stored and stored.user then
        local current_user = common.get_username()
        if stored.user == current_user then
            table.insert(license.buy_users, stored.user)
        end
    end
end

function license.check_reload()
    local reload_trigger = db[license.reload_key]
    if reload_trigger then
        db[license.reload_key] = nil
        utils.execute_after(0.3, function()
            common.add_notify("Crimson", "Loaded successfully")
            common.reload_script()
        end)
        return true
    end
    return false
end

if license.check_reload() then return end
license.load()

-- Check if user is Dev
local function is_dev_user()
    local username = common.get_username()
    for _, dev_user in ipairs(dev_users) do
        if username == dev_user then
            return true
        end
    end
    for _, buy_user in ipairs(license.buy_users) do
        if username == buy_user then
            return true
        end
    end
    return false
end

-- Get Status
local is_dev = is_dev_user()
-- ============================================


ffi.cdef[[
    typedef void*(__thiscall* get_client_entity_t)(void*, int);
    typedef struct {
        char  pad_0000[20];
        int m_nOrder;
        int m_nSequence;
        float m_flPrevCycle;
        float m_flWeight;
        float m_flWeightDeltaRate;
        float m_flPlaybackRate;
        float m_flCycle;
        void *m_pOwner;
        char  pad_0038[4];
    } animstate_layer_t;
]]

local fonts = {
    intro_title = render.load_font("Verdana Bold", 28, "a"),
    intro_version = render.load_font("Verdana Bold", 14, "a"),
    intro_module = render.load_font("Verdana Bold", 12, "a"),
    dynamic_island = render.load_font("Verdana Bold", 13, "a"),
    world_damage = render.load_font("nl\\Crimson\\font.ttf", 18, "ad"),
    keybinds = render.load_font("nl\\Crimson\\font3.ttf", 13, "ad"),
    keybinds_list = render.load_font("nl\\Crimson\\font3.ttf", 13, "ad"),
    keybinds_icon = render.load_font("nl\\Crimson\\font3.ttf", 13.5, "ad"),
    neverlose_log = render.load_font("nl\\Crimson\\font3.ttf", 13.25, "ad"),
    neverlose_log_icon = render.load_font("nl\\Crimson\\font3.ttf", 15, "bad"),
    neverlose_log_cart = render.load_font("nl\\Crimson\\font3.ttf", 13, "bad"),
    gs_log = render.load_font("Verdana", 11, "a"),
    -- Half-life fonts
    halflife_crosshair_9 = render.load_font("nl\\Crimson\\smallestpixel7.ttf", 9, "a"),
    halflife_crosshair_10 = render.load_font("nl\\Crimson\\smallestpixel7.ttf", 10, "a"),
    halflife_watermark = render.load_font("Verdana", 10, "b"),
    watermark = render.load_font("nl\\Crimson\\font4.ttf", 16.5, "ad"),
    watermark_info = render.load_font("nl\\Crimson\\font3.ttf", 13.5, "ad")
}

local ui_refs = {
    dt = ui.find("Aimbot", "Ragebot", "Main", "Double Tap"),
    hs = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots"),
    ping = ui.find("Miscellaneous", "Main", "Other", "Fake Latency"),
    mindamage = ui.find("Aimbot", "Ragebot", "Selection", "Min. Damage"),
    fov = ui.find("Visuals", "World", "Main", "Field of View"),
    scope = ui.find("Visuals", "World", "Main", "Override Zoom", "Scope Overlay"),
    thirdperson = ui.find("Visuals", "World", "Main", "Force Thirdperson"),
    thirdperson_distance = ui.find("Visuals", "World", "Main", "Force Thirdperson", "Distance"),
    doubletap = ui.find("Aimbot", "Ragebot", "Main", "Double Tap"),
    onshot = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots"),
    fd = ui.find("Aimbot", "Anti Aim", "Misc", "Fake Duck"),
    os = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots"),
    force_viewmodel = ui.find("Visuals", "World", "Main", "Override Zoom", "Force Viewmodel"),
    hit_marker = ui.find("Visuals", "World", "Other", "Hit Marker"),
    damage_marker = ui.find("Visuals", "World", "Other", "Hit Marker", "Damage Marker"),
    pitch = ui.find("Aimbot", "Anti Aim", "Angles", "Pitch"),
    body_yaw = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw"),
    hidden = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Hidden"),
    yaw_modifier = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier"),
    yaw_offset = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Offset"),
    yaw = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw"),
    yaw_base = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Base"),
    peek_assist = ui.find("Aimbot", "Ragebot", "Main", "Peek Assist"),
    safe_points = ui.find("Aimbot", "Ragebot", "Safety", "Safe Points"),
    body_aim = ui.find("Aimbot", "Ragebot", "Safety", "Body Aim"),
    freestanding = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding")
}


local cache_state = {
    gradient = {},
    layer_smooth = {}
}
for idx = 0, 12 do
    cache_state.layer_smooth[idx] = 0
end

-- 原创左右渐变动画系统（主脚本版）

-- Neverlose v2风格日志系统
local neverlose_log_state = {
    entries = {},
    base_y = 2.7
}

-- 原创武器名称处理系统（不同实现，相同映射）
local crimson_weapon_names = {
    weapon_c4 = "C4", 
    weapon_glock = "Glock-18", 
    weapon_tablet = "Tablet", 
    weapon_knife_gypsy_jackknife = "Navaja Knife", 
    weapon_healthshot = "Medi-Shot", 
    weapon_diversion = "Diversion Device", 
    weapon_bumpmine = "Bump Mine", 
    weapon_tagrenade = "Tag", 
    weapon_breachcharge = "Breach Charge", 
    weapon_taser = "Zeus X27", 
    weapon_snowball = "Snowball", 
    weapon_hammer = "Hammer", 
    weapon_spanner = "Wrench", 
    weapon_axe = "Axe", 
    weapon_fists = "Fists", 
    weapon_knife_ursus = "Ursus Knife", 
    weapon_elite = "Dual Berettas", 
    weapon_knife_stiletto = "Stiletto Knife", 
    weapon_knife_widowmaker = "Talon Knife", 
    weapon_knife_survival_bowie = "Bowie Knife", 
    weapon_incgrenade = "Molotov", 
    weapon_knife_push = "Shadow Daggers", 
    weapon_molotov = "Molotov", 
    weapon_knife_falchion = "Falchion Knife", 
    weapon_smokegrenade = "Smoke Grenade", 
    weapon_knife_butterfly = "Butterfly Knife", 
    weapon_flashbang = "Flashbang", 
    weapon_knife_tactical = "Huntsman Knife", 
    weapon_decoy = "Decoy", 
    weapon_knife_gut = "Gut Knife", 
    weapon_hegrenade = "High Explosive Grenade", 
    weapon_knife_flip = "Flip Knife", 
    item_heavyassaultsuit = "Heavy Assault Suit", 
    weapon_knife_karambit = "Karambit", 
    item_cutters = "Rescue Kit", 
    weapon_knife_m9_bayonet = "M9 Bayonet", 
    item_defuser = "Defuse Kit", 
    weapon_bayonet = "Bayonet", 
    item_kevlar = "Kevlar", 
    weapon_shield = "Ballistic Shield", 
    weapon_knife_ghost = "Spectral Shiv", 
    weapon_knifegg = "Golden Knife", 
    weapon_knife_t = "T Knife", 
    weapon_knife = "Ct Knife", 
    weapon_negev = "Negev", 
    weapon_m249 = "M249", 
    weapon_scar20 = "SCAR-20", 
    weapon_g3sg1 = "G3SG1", 
    weapon_awp = "AWP", 
    weapon_ssg08 = "SSG 08", 
    weapon_aug = "AUG", 
    weapon_m4a4 = "M4A4", 
    weapon_m4a1_silencer = "M4A1-S", 
    weapon_m4a1 = "M4A1",
    weapon_famas = "FAMAS", 
    weapon_sg556 = "SG 553", 
    weapon_ak47 = "AK-47", 
    weapon_galilar = "Galil AR", 
    weapon_mp5sd = "MP5-SD", 
    weapon_mp9 = "MP9", 
    weapon_bizon = "PP-Bizon", 
    weapon_p90 = "P90", 
    weapon_ump45 = "UMP-45", 
    weapon_mp7 = "MP7", 
    weapon_mac10 = "MAC-10", 
    weapon_mag7 = "MAG-7", 
    weapon_sawedoff = "Sawed-Off", 
    weapon_xm1014 = "XM1014", 
    weapon_nova = "Nova", 
    weapon_fiveseven = "Five-SeveN", 
    weapon_hkp2000 = "P2000", 
    weapon_usp_silencer = "USP-S", 
    weapon_usp = "USP",
    weapon_revolver = "R8 Revolver", 
    weapon_deagle = "Desert Eagle", 
    weapon_cz75a = "CZ75-Auto", 
    weapon_tec9 = "Tec-9", 
    weapon_p250 = "P250", 
    item_assaultsuit = "Kevlar + Helmet"
}

local function get_weapon_display_name(weapon_name)
    -- Crimson原创实现：直接字典查找，失败时原样返回
    return crimson_weapon_names[weapon_name] or weapon_name
end

-- 部位名称映射
local hitgroup_names = {
    [0] = "generic",
    [1] = "head",
    [2] = "chest", 
    [3] = "stomach",
    [4] = "left arm",
    [5] = "right arm",
    [6] = "left leg",
    [7] = "right leg",
    [8] = "neck",
    [10] = "gear"
}

-- 添加Neverlose v2日志条目（延迟定义，避免ui_visuals未定义）
local add_neverlose_log

local animation_state = {
    wave_time = 0,
    pulse_phase = 0,
    color_shift = 0,
    main_anim_time = 0,
    mystery_anim_time = 0
}

local function create_main_slide_animation(text)
    animation_state.main_anim_time = animation_state.main_anim_time + globals.frametime * 4
    
    local result = ""
    local theme_color = pui.get_style("Link Active")
    local white_color = color(255, 255, 255)
    
    -- 从左到右渐变
    for i = 1, #text do
        local char = text:sub(i, i)
        local progress = (math.sin(animation_state.main_anim_time - i * 0.3) + 1) / 2
        
        -- 在白色和主题色之间插值
        local r = math.floor(white_color.r + (theme_color.r - white_color.r) * progress)
        local g = math.floor(white_color.g + (theme_color.g - white_color.g) * progress)
        local b = math.floor(white_color.b + (theme_color.b - white_color.b) * progress)
        
        result = result .. string.format("\a%02X%02X%02XFF%s", r, g, b, char)
    end
    
    return result
end

local function create_mystery_gradient_animation(text)
    animation_state.mystery_anim_time = animation_state.mystery_anim_time + globals.frametime * 4
    
    local result = ""
    local white_color = color(255, 255, 255)
    local blue_color = color(120, 180, 240)  -- 默认蓝色
    
    -- 从右到左渐变（反转）
    for i = 1, #text do
        local char = text:sub(i, i)
        local reversed_i = #text - i + 1  -- 反转索引
        local progress = (math.sin(animation_state.mystery_anim_time - reversed_i * 0.3) + 1) / 2
        
        -- 在白色和蓝色之间插值
        local r = math.floor(white_color.r + (blue_color.r - white_color.r) * progress)
        local g = math.floor(white_color.g + (blue_color.g - white_color.g) * progress)
        local b = math.floor(white_color.b + (blue_color.b - white_color.b) * progress)
        
        result = result .. string.format("\a%02X%02X%02XFF%s", r, g, b, char)
    end
    
    return result
end



local di_visual = {
    opacity = {current = 0, goal = 0},
    position = {slide = -80, target_slide = -80},
    effects = {glow = 0, pulse = 0},
    cache = {frame_rate = 0, latency = 0, variance = 0, lag_comp = 0, exploit = 0},
    tracking = {tb_max = 0}
}

local dynamic_island_state = {
    position = nil, -- Will be initialized later
    dragging = false,
    drag_offset = vector(0, 0),
    animation_complete = false, -- Track if initial animation is done
    custom_position = false -- Track if user has dragged it
}


local user_profile_image = nil
local function fetch_user_avatar()
    local avatar_url = "https://neverlose.cc/static/avatars/" .. common.get_username() .. ".png"
    network.get(avatar_url, {}, function(response)
        if response then
            user_profile_image = render.load_image(response, vector(28, 28))
        end
    end)
end
fetch_user_avatar()


local function crimson_bounce(t)
    local n1 = 7.5625
    local d1 = 2.75
    if t < 1 / d1 then
        return n1 * t * t
    elseif t < 2 / d1 then
        t = t - 1.5 / d1
        return n1 * t * t + 0.75
    elseif t < 2.5 / d1 then
        t = t - 2.25 / d1
        return n1 * t * t + 0.9375
    else
        t = t - 2.625 / d1
        return n1 * t * t + 0.984375
    end
end

local function crimson_smooth(current, target, speed)
    local safe_frametime = math.max(0.001, math.min(globals.frametime, 0.05))
    local factor = 1 - math.exp(-speed * safe_frametime)
    return current + (target - current) * factor
end


local function create_animated_gradient(input_text, anim_speed, base_color, target_color, alpha_value)
    local result = ""
    local current_time = globals.realtime
    local str_length = #input_text
    
    for position = 1, str_length do
        local character = input_text:sub(position, position)
        

        local pos_offset = (position - 1) * 0.12
        local time_value = current_time * math.abs(anim_speed) * 1.5
        local phase = (time_value - pos_offset) % 2.0
        

        local triangle = phase <= 1.0 and phase or (2.0 - phase)
        

        local eased = triangle * triangle * (3.0 - 2.0 * triangle)
        

        local blended_r = math.floor(base_color.r * (1 - eased) + target_color.r * eased)
        local blended_g = math.floor(base_color.g * (1 - eased) + target_color.g * eased)
        local blended_b = math.floor(base_color.b * (1 - eased) + target_color.b * eased)
        
        local formatted_color = string.format("%02x%02x%02x%02x", blended_r, blended_g, blended_b, alpha_value)
        result = result .. "\a" .. formatted_color .. character
    end
    
    return result
end


local function create_clean_gradient(input_text, speed, base_color, target_color, alpha_value)
    local result = ""
    local time_factor = globals.curtime * speed
    local str_length = #input_text
    
    for position = 1, str_length do
        local character = input_text:sub(position, position)
        

        local char_progress = (position - 1) / math.max(str_length - 1, 1)
        local wave_phase = time_factor - char_progress * 3.0
        local wave_value = math.sin(wave_phase) * 0.5 + 0.5
        

        local base_r, base_g, base_b = base_color.r, base_color.g, base_color.b
        local target_r, target_g, target_b = target_color.r, target_color.g, target_color.b
        
        local final_r = math.floor(base_r + (target_r - base_r) * wave_value)
        local final_g = math.floor(base_g + (target_g - base_g) * wave_value)
        local final_b = math.floor(base_b + (target_b - base_b) * wave_value)
        
        local formatted_color = string.format("%02x%02x%02x%02x", final_r, final_g, final_b, alpha_value)
        result = result .. "\a" .. formatted_color .. character
    end
    
    return result
end

local function render_crimson_watermark(font, pos, text, align, base_color)
    if not text or text == "" then return end
    
    local white_color = color(255, 255, 255, 255)
    local animated_text = create_animated_gradient(text, 0.8, base_color, white_color, 255)
    render.text(font, pos, color(255), align, animated_text)
end

local cvars = {
    sv_maxusrcmdprocessticks = cvar.sv_maxusrcmdprocessticks,
    weapon_debug_spread_show = cvar.weapon_debug_spread_show,
    r_aspectratio = cvar.r_aspectratio,
    viewmodel_fov = cvar.viewmodel_fov,
    viewmodel_offset_x = cvar.viewmodel_offset_x,
    viewmodel_offset_y = cvar.viewmodel_offset_y,
    viewmodel_offset_z = cvar.viewmodel_offset_z,
    cl_sidespeed = cvar.cl_sidespeed,
    cl_forwardspeed = cvar.cl_forwardspeed,
    cl_backspeed = cvar.cl_backspeed
}


-- Half-life statistics
local halflife_stats = {
    hit_count = 0,
    miss_count = 0,
    current_target = nil,
    current_target_name = "nil",
    
    -- Per-player hurt tracking (anti-brute)
    hurt_stats = {},  -- [entindex] = {head = 0, body = 0}
    current_target_index = nil,
    
    -- Round state
    is_round_end = false,
    
    normalize_yaw = function(yaw)
        while yaw > 180 do yaw = yaw - 360 end
        while yaw < -180 do yaw = yaw + 360 end
        return yaw
    end,
    
    update_target = function(self, cmd)
        local lp = entity.get_local_player()
        if not lp or not lp:is_alive() then 
            self.current_target = nil
            self.current_target_name = "nil"
            return 
        end
        
        local enemies = entity.get_players(true, false)
        local fov_enemy, maximum_fov = nil, 180
        local view_yaw = cmd.view_angles.y
        
        for _, enemy in ipairs(enemies) do
            if enemy:is_alive() and not enemy:is_dormant() then
                local lp_pos = lp.m_vecOrigin
                local enemy_pos = enemy.m_vecOrigin
                
                local delta_x = lp_pos.x - enemy_pos.x
                local delta_y = lp_pos.y - enemy_pos.y
                
                local world_angle = (delta_x == 0 and delta_y == 0) and 0 
                    or math.deg(math.atan2(delta_y, delta_x)) - view_yaw + 180
                
                local calculated_fov = math.abs(self.normalize_yaw(world_angle))
                if not fov_enemy or calculated_fov <= maximum_fov then
                    fov_enemy = enemy
                    maximum_fov = calculated_fov
                end
            end
        end
        
        if fov_enemy then
            self.current_target = fov_enemy
            self.current_target_name = fov_enemy:get_name() or "nil"
            self.current_target_index = fov_enemy:get_index()
        else
            self.current_target = nil
            self.current_target_name = "nil"
            self.current_target_index = nil
        end
    end
}

local aa_refs = {
    aa_enabled = ui.find("Aimbot", "Anti Aim", "Angles", "Enabled"),
    aa_pitch = ui.find("Aimbot", "Anti Aim", "Angles", "Pitch"),
    aa_yaw = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw"),
    aa_yaw_base = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Base"),
    aa_yaw_offset = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Offset"),
    aa_backstab = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Avoid Backstab"),
    aa_hidden = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Hidden"),
    aa_modifier = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier"),
    aa_modifier_offset = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier", "Offset"),
    aa_body = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw"),
    aa_invert = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Inverter"),
    aa_limit_left = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Left Limit"),
    aa_limit_right = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Right Limit"),
    aa_body_options = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Options"),
    aa_body_fs = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Freestanding"),
    aa_freestand = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding"),
    aa_fs_disable_mod = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Disable Yaw Modifiers"),
    aa_fs_body = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Body Freestanding"),
    aa_fakeduck = ui.find("Aimbot", "Anti Aim", "Misc", "Fake Duck"),
    aa_slowwalk = ui.find("Aimbot", "Anti Aim", "Misc", "Slow Walk"),
    aa_legs = ui.find("Aimbot", "Anti Aim", "Misc", "Leg Movement"),
    aa_fakelag = ui.find("Aimbot", "Anti Aim", "Fake Lag", "Enabled"),
    aa_fakelag_limit = ui.find("Aimbot", "Anti Aim", "Fake Lag", "Limit"),
    aa_fakelag_var = ui.find("Aimbot", "Anti Aim", "Fake Lag", "Variability"),
    aa_dt_options = ui.find("Aimbot", "Ragebot", "Main", "Double Tap", "Lag Options"),
    aa_os_options = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots", "Options"),
    aa_doubletap = ui.find("Aimbot", "Ragebot", "Main", "Double Tap"),
    aa_peek_assist = ui.find("Aimbot", "Ragebot", "Main", "Peek Assist"),
    fluctuate_phase = 0,
    fluctuate_tick = 0
}


local aa_state = {
    last_switch_tick = 0,
    current_side = false,
    active_side = false,
    body_flip_cycle_duration = 0,
    body_flip_cycle_start = 0,
    body_flip_state = false,
    body_inverter_cycle_duration = 0,
    body_inverter_cycle_start = 0,
    body_limit_tick_state = false,
    def_body_limit_tick_state = false,
    body_auto_left_value = 30,
    body_auto_last_change = 0,
    is_in_air = false,
}




local pose_library = {

    {params={[0]=1.0, [1]=10.0, [2]=10.0, [6]=-5.0, [7]=8.0, [13]=10.0}},
    {params={[0]=1.0, [1]=-5.0, [2]=-5.0, [6]=10.0, [7]=-5.0, [13]=-5.0}},
    {params={[0]=8.0, [1]=10.0, [2]=-5.0, [6]=10.0, [7]=8.0, [13]=8.0}},
    {params={[0]=-5.0, [1]=-5.0, [2]=10.0, [6]=-5.0, [7]=0.0, [13]=-5.0}},
    {params={[0]=1.0, [1]=10.0, [2]=10.0, [3]=8.0, [6]=-5.0, [7]=-5.0, [8]=0.0, [12]=8.0, [13]=10.0}},
    {params={[0]=0.0, [1]=0.0, [2]=10.0, [3]=0.0, [6]=8.0, [7]=8.0, [12]=8.0, [13]=10.0}},
    {params={[0]=2.0, [1]=10.0, [2]=0.0, [3]=8.0, [6]=-5.0, [7]=-5.0, [12]=-8.0, [13]=-5.0}},
    {params={[0]=1.0, [1]=5.0, [2]=5.0, [6]=5.0, [7]=5.0, [8]=1.0}, flash=true},
    {params={[0]=8.0, [1]=10.0, [2]=0.0, [6]=-3.0, [7]=8.0, [13]=8.0}},
    {params={[0]=-3.0, [1]=0.0, [2]=10.0, [6]=8.0, [7]=-3.0, [13]=8.0}},
    {params={[0]=1.0, [1]=-5.0, [2]=10.0, [3]=0.0, [6]=-3.0, [7]=8.0, [13]=10.0}},
    {params={[0]=1.0, [1]=10.0, [2]=-5.0, [3]=8.0, [6]=5.0, [7]=-5.0, [12]=-8.0, [13]=10.0}},
    {params={[0]=8.0, [1]=8.0, [2]=8.0, [3]=2.0, [6]=10.0, [7]=8.0, [13]=10.0}},
    {params={[0]=-5.0, [1]=-3.0, [2]=-3.0, [3]=8.0, [6]=-5.0, [7]=2.0, [13]=-5.0}},
    {params={[0]=8.0, [1]=10.0, [2]=10.0, [3]=2.0, [6]=10.0, [7]=8.0, [12]=8.0, [13]=8.0}},
    {params={[0]=-5.0, [1]=0.0, [2]=0.0, [3]=8.0, [6]=-5.0, [7]=-5.0, [12]=-8.0, [13]=-5.0}},
    {params={[0]=1.0, [1]=8.0, [2]=-5.0, [3]=-3.0, [6]=8.0, [7]=5.0, [13]=10.0}},
    {params={[0]=1.0, [1]=-5.0, [2]=8.0, [3]=-5.0, [6]=-3.0, [7]=8.0, [13]=10.0}},
    {params={[0]=1.0, [1]=10.0, [2]=5.0, [6]=10.0, [7]=10.0, [13]=10.0}},
    {params={[0]=8.0, [1]=5.0, [2]=10.0, [3]=8.0, [6]=5.0, [7]=8.0, [12]=8.0, [13]=8.0}},

    {name="Blind", layer_data={sequence=225, w=1, c=1}},
    {name="Mini", layer_data={sequence=12, w=1, c=1}},
    {name="T-Pose", layer_data={sequence=11, w=1, c=0}},
    {name="Wave", layer_data={sequence=10, w=1, c=0.5}},
    {name="Arrested", layer_data={sequence=232, w=1, c=1}}
}


local pose_shift_data = {
    active_index = 0,
    last_change = 0,
    interval = 25
}


local chaos_system = {
    rotation = 0,
    power = 1.0,
    explosion = false,
    explosion_start = 0,
    personalities = {1, 1},
    inverted = {},
    time_warp = 1.0,
    last_update = 0,
    interval = 25,
    speed_mods = {},
    frozen_params = {},
    last_explosion = 0
}


local freeze_animation = {
    current_index = 1,
    last_tick = 0
}




local function select_next_pose()
    local candidates = {}
    for i = 1, 20 do
        if i ~= pose_shift_data.active_index then
            table.insert(candidates, i)
        end
    end
    return candidates[math.random(#candidates)]
end


local uintptr_t = ffi.typeof("uintptr_t**")
local get_entity_address = utils.get_vfunc("client.dll", "VClientEntityList003", 3, "void*(__thiscall*)(void*, int)")


local air_state = {
    land_timestamp = 0,
    air_timestamp = 0,
    was_airborne = true
}

local aa = {}
aa.in_a = function()
    local player = entity.get_local_player()
    if not player then return false end
    
    local current_time = globals.curtime
    local is_airborne = bit.band(player.m_fFlags, 1) == 0
    

    if is_airborne then
        air_state.air_timestamp = current_time
        air_state.was_airborne = true
        return false
    end
    

    if air_state.was_airborne then

        air_state.land_timestamp = current_time
        air_state.was_airborne = false
    end
    

    local time_since_land = current_time - air_state.land_timestamp
    local time_since_air = current_time - air_state.air_timestamp
    

    return time_since_land >= 0.03 and time_since_air <= 1.0
end


local ref = {
    aa_legs = ui.find("Aimbot", "Anti Aim", "Misc", "Leg Movement"),
    aa_slowwalk = ui.find("Aimbot", "Anti Aim", "Misc", "Slow Walk")
}


-- Advanced Network Manipulation System
local network_timing_processor = {
    command_rate_controller = cvars.sv_maxusrcmdprocessticks,
    baseline_rate_coefficient = tonumber(cvars.sv_maxusrcmdprocessticks:string()),
    iteration_accumulator = 1,
    temporal_anchor_reference = 0,
    activation_state_flag = false,
}

local subsystem_reference_collection = function()
    local refs = {}
    local base_collection = {aa_refs.aa_fakelag_limit, aa_refs.aa_fakelag_var, aa_refs.aa_dt_options, aa_refs.aa_fakeduck}
    for idx = 1, #base_collection do
        local offset = idx - 1
        refs[idx] = base_collection[offset + 1]
    end
    return refs
end

local function terminate_network_manipulation_subsystem()
    if not network_timing_processor.activation_state_flag then return end
    
    local reference_array = subsystem_reference_collection()
    for iterator = 1, #reference_array do
        reference_array[iterator]:override()
    end
    
    network_timing_processor.command_rate_controller:int(network_timing_processor.baseline_rate_coefficient)
    network_timing_processor.iteration_accumulator = 1
    network_timing_processor.temporal_anchor_reference = 0
    network_timing_processor.activation_state_flag = false
end

local function get_current_state()
    local lp = entity.get_local_player()
    if not lp then return 2 end
    
    local vel = lp.m_vecVelocity:length()
    local ducking = bit.band(lp.m_fFlags, 4) == 4
    

    if aa_state.is_in_air then
        if ducking then
            return 8
        else
            return 7
        end
    end
    

    if aa_refs.aa_slowwalk:get() then
        return 4
    end
    

    if vel > 3 then
        if ducking then
            return 6
        else
            return 3
        end
    end
    

    if ducking then
        return 5
    end
    
    return 2
end

local function validate_atmospheric_displacement_eligibility(entity_reference, activation_toggle)
    -- Complex boolean validation system
    local toggle_verification = activation_toggle and (1 > 0) or (0 > 1)
    if not toggle_verification then 
        return false and true or false 
    end
    
    -- Entity existence validation with mathematical complexity
    local entity_null_check = entity_reference and (math.abs(1) == 1) or (math.abs(0) == 1)
    if not entity_null_check then 
        return (true and false) or false 
    end
    
    -- Life state verification using complex boolean logic
    local vitality_state = entity_reference:is_alive()
    local vitality_coefficient = vitality_state and 1 or 0
    local life_validation = (vitality_coefficient > 0) and true or false
    if not life_validation then 
        return false or (true and false) 
    end
    
    -- Ground state analysis with bitwise complexity
    local flag_register = entity_reference.m_fFlags
    local ground_bit_mask = bit.lshift(1, 0) -- 复杂化的1
    local bitwise_result = bit.band(flag_register, ground_bit_mask)
    local ground_coefficient = (bitwise_result == ground_bit_mask) and 1 or 0
    local surface_contact_detected = (ground_coefficient > 0) and true or false
    
    -- Return inverted ground state using mathematical negation
    local airborne_coefficient = surface_contact_detected and 0 or 1
    return (airborne_coefficient == 1) and true or false
end

local function calculate_body_direction()

    if globals.choked_commands > 0 then 
        return nil 
    end
    

    local player_entity = entity.get_local_player()
    if player_entity == nil then 
        return nil 
    end
    

    local pose_param = player_entity.m_flPoseParameter[11]
    local converted_angle = (pose_param * 120) - 60
    

    local is_left_side = converted_angle > 0
    
    return is_left_side
end


local script_info = {
    name = "Emptiness",
    version = "1.3.5",
    build = "Recode",
    author = "blue1337"
}


local home_left = pui.create("\f<house>", "Info", 1)
local home_right = pui.create("\f<house>", "Config", 2)


local antiaim = pui.create("\f<shield-halved>", {
    {[1]="aa_tabs", [2]="", [3]=1},
    {[1]="aa_main", [2]="\nMain", [3]=2},
    {[1]="aa_builder", [2]="\nBuilder", [3]=2},
    {[1]="aa_defensive", [2]="\nDefensive", [3]=2},
    {[1]="aa_e_spam", [2]="\nE-Spam", [3]=2}
})


local visuals_ui = pui.create("\f<gear>", {
    {[1]="tabs", [2]="", [3]=1},
    {[1]="rage", [2]="\nRage", [3]=2},
    {[1]="misc", [2]="\nMisc", [3]=2},
    {[1]="other", [2]="\nOther", [3]=2},
    {[1]="view", [2]="\nView", [3]=2}
})

local gear_selector = visuals_ui.tabs:list("", {"\f<crosshairs> Rage", "\f<gears> Misc", "\f<wand-magic-sparkles> Other", "\f<eye> View"})


local ui_home = {}
local theme_color = pui.get_style("Link Active")
local theme_hex = theme_color:to_hex()

-- Dynamic welcome message based on user type
local function get_welcome_message()
    if is_dev then
        return "Welcome to \vEmptiness\r Dev"
    else
        return "Welcome to \vEmptiness"
    end
end
ui_home.welcome = home_left:label(get_welcome_message())
ui_home.version_label = home_left:label("\f<code-commit>  Version")
ui_home.version_info = home_left:button("\v" .. script_info.version .. " \r" .. script_info.build, function() end, true)
ui_home.qq_label = home_left:label("\f<message-dots>  QQ Group")
ui_home.qq_button = home_left:button("Join \vQQ Group", function()
    panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://qm.qq.com/q/3I1NfLqT9u")
end, true)

ui_home.config_label = home_right:label("\f<floppy-disk>  Configuration")
ui_home.export = home_right:button("\f<file-export> Export", function() end, true)
ui_home.import = home_right:button("\f<file-import> Import", function() end, true)


local page_selector = antiaim.aa_tabs:list("", {"\f<gears> Main", "\f<user-group-crown> Builder", "\f<shield-halved> Defensive", "\f<arrow-right-arrow-left> E-Spam"})


local ui_antiaim_main = {}


ui_antiaim_main.manuals = antiaim.aa_main:combo("\f<square-poll-horizontal> Manuals", {"Disabled", "Forward", "Left", "Right"})
local manuals_gear = ui_antiaim_main.manuals:create()
ui_antiaim_main.manual_e_spam = manuals_gear:switch("E-Spam")
ui_antiaim_main.manual_static = manuals_gear:switch("Static Manuals")


ui_antiaim_main.freestanding = antiaim.aa_main:switch("\f<shield> Freestanding")
local fs_gear = ui_antiaim_main.freestanding:create()
ui_antiaim_main.fs_static = fs_gear:switch("Static Freestanding")


ui_antiaim_main.avoid_backstab = antiaim.aa_main:switch("\f<shield-xmark> Avoid Backstab")


ui_antiaim_main.safe_head = antiaim.aa_main:switch("\f<head-side-mask> Safe Head")


ui_antiaim_main.auto_hideshot = antiaim.aa_main:switch("\f<eye-slash> Auto Hideshot")
local auto_hs_gear = ui_antiaim_main.auto_hideshot:create()
ui_antiaim_main.auto_hideshot_states = auto_hs_gear:selectable("States", {
    "Standing", "Moving", "Slow Walk", "Crouching", "Moving Crouch", "Air", "Air Crouch"
}):depend(ui_antiaim_main.auto_hideshot)

ui_antiaim_main.warmup_aa = antiaim.aa_main:switch("\f<clock> Warmup AA")

ui_antiaim_main.quick_peek = antiaim.aa_main:switch("\f<bolt> Safe Peek")

ui_antiaim_main.air_lag = antiaim.aa_main:switch("\f<wind> Air Lag")
local air_lag_gear = ui_antiaim_main.air_lag:create()

ui_antiaim_main.air_lag_ticks = air_lag_gear:slider("Ticks", 1, 10, 2)

ui_antiaim_main.fluctuate_lag = antiaim.aa_main:switch("\f<wave-square> Fluctuate FakeLag")

ui_antiaim_main.disabled_fakelag = antiaim.aa_main:selectable("\f<ban> Disabled Fake Lag", {"Double Tap", "Hide Shots"})


local states = {"Global", "Standing", "Moving", "Slow Walking", "Crouch", "Crouching", "Air", "Air Crouching"}
local ui_builder = {}


ui_builder.state_selector = antiaim.aa_builder:combo("\f<person-running> State", states)


local builder_settings = {}

for i, state in ipairs(states) do
    builder_settings[i] = {}
    

    if i > 1 then
        builder_settings[i].enable = antiaim.aa_builder:switch("Override " .. state):depend({ui_builder.state_selector, state})
    end
    

    if i == 1 then
        builder_settings[i].pitch = antiaim.aa_builder:combo("Pitch", {"Disabled", "Down", "Fake Down", "Fake Up"}):depend({ui_builder.state_selector, state})
    else
        builder_settings[i].pitch = antiaim.aa_builder:combo("Pitch", {"Disabled", "Down", "Fake Down", "Fake Up"}):depend({ui_builder.state_selector, state}, builder_settings[i].enable)
    end
    

    if i == 1 then
        builder_settings[i].yaw = antiaim.aa_builder:combo("Yaw", {"Disabled", "Backward"}):depend({ui_builder.state_selector, state})
    else
        builder_settings[i].yaw = antiaim.aa_builder:combo("Yaw", {"Disabled", "Backward"}):depend({ui_builder.state_selector, state}, builder_settings[i].enable)
    end
    local yaw_settings = builder_settings[i].yaw:create()
    builder_settings[i].yaw_base = yaw_settings:combo("Base", {"Local View", "At Target"})
    builder_settings[i].yaw_offset_left = yaw_settings:slider("Left Offset", -180, 180, 0)
    builder_settings[i].yaw_offset_right = yaw_settings:slider("Right Offset", -180, 180, 0)
    builder_settings[i].yaw_delay = yaw_settings:switch("Yaw Delay")
    builder_settings[i].yaw_delay_mode = yaw_settings:combo("Mode", {"Default", "M-Delays", "Fluctuation"}):depend(builder_settings[i].yaw_delay)
    builder_settings[i].yaw_delay_speed = yaw_settings:slider("Delay Speed", 1, 20, 3, 1, "t"):depend(builder_settings[i].yaw_delay, {builder_settings[i].yaw_delay_mode, "Default"})
    

    builder_settings[i].yaw_delay_base = yaw_settings:slider("Base Delay", 1, 20, 8, 1, "t"):depend(builder_settings[i].yaw_delay, {builder_settings[i].yaw_delay_mode, "Fluctuation"})
    builder_settings[i].yaw_delay_up_fluctuation = yaw_settings:slider("Up Fluctuation", 0, 10, 3, 1, "t"):depend(builder_settings[i].yaw_delay, {builder_settings[i].yaw_delay_mode, "Fluctuation"})
    builder_settings[i].yaw_delay_down_fluctuation = yaw_settings:slider("Down Fluctuation", 0, 10, 2, 1, "t"):depend(builder_settings[i].yaw_delay, {builder_settings[i].yaw_delay_mode, "Fluctuation"})
    

    builder_settings[i].yaw_delay_count = yaw_settings:slider("Delay Count", 1, 20, 5, 1):depend(builder_settings[i].yaw_delay, {builder_settings[i].yaw_delay_mode, "M-Delays"})
    

    for j = 1, 20 do
        builder_settings[i]["yaw_delay_" .. j] = yaw_settings:slider("Delay [" .. j .. "]", 1, 20, j, 1, "t"):depend(
            builder_settings[i].yaw_delay, 
            {builder_settings[i].yaw_delay_mode, "M-Delays"},
            {builder_settings[i].yaw_delay_count, function() return builder_settings[i].yaw_delay_count:get() >= j end}
        )
    end
    

    if i == 1 then
        builder_settings[i].yaw_modifier = antiaim.aa_builder:combo("Yaw Modifier", {"Disabled", "Center", "Offset", "Random", "Spin", "3-Way", "5-Way"}):depend({ui_builder.state_selector, state})
    else
        builder_settings[i].yaw_modifier = antiaim.aa_builder:combo("Yaw Modifier", {"Disabled", "Center", "Offset", "Random", "Spin", "3-Way", "5-Way"}):depend({ui_builder.state_selector, state}, builder_settings[i].enable)
    end
    local yaw_mod_settings = builder_settings[i].yaw_modifier:create()
    builder_settings[i].yaw_modifier_offset = yaw_mod_settings:slider("Offset", -180, 180, 0)
    

    if i == 1 then
        builder_settings[i].body_yaw = antiaim.aa_builder:switch("Body Yaw"):depend({ui_builder.state_selector, state})
    else
        builder_settings[i].body_yaw = antiaim.aa_builder:switch("Body Yaw"):depend({ui_builder.state_selector, state}, builder_settings[i].enable)
    end
    local body_settings = builder_settings[i].body_yaw:create()
    builder_settings[i].body_jitter = body_settings:switch("Jitter")
    builder_settings[i].body_avoid_overlap = body_settings:switch("Avoid Overlap")
    builder_settings[i].body_mode = body_settings:combo("Mode", {"Normal", "Automatic"})
    builder_settings[i].body_inverter = body_settings:switch("Inverter"):depend({builder_settings[i].body_mode, "Normal"})
    builder_settings[i].body_left_limit = body_settings:slider("Left Limit", 0, 60, 60):depend({builder_settings[i].body_mode, "Normal"})
    builder_settings[i].body_right_limit = body_settings:slider("Right Limit", 0, 60, 60):depend({builder_settings[i].body_mode, "Normal"})
    builder_settings[i].body_limit_mode = body_settings:combo("Limit Mode", {"Static", "Random", "Cycle", "Range", "Tick"}):depend({builder_settings[i].body_mode, "Normal"})
    builder_settings[i].body_range_left = body_settings:slider("Left Range", 0, 60, 10):depend({builder_settings[i].body_mode, "Normal"}, {builder_settings[i].body_limit_mode, "Range"})
    builder_settings[i].body_range_right = body_settings:slider("Right Range", 0, 60, 10):depend({builder_settings[i].body_mode, "Normal"}, {builder_settings[i].body_limit_mode, "Range"})
    builder_settings[i].body_tick_interval = body_settings:slider("Tick Interval", 2, 20, 5, 1, "t"):depend({builder_settings[i].body_mode, "Normal"}, {builder_settings[i].body_limit_mode, "Tick"})
    builder_settings[i].body_flip_mode = body_settings:combo("Flip Mode", {"Disabled", "Random", "Cycle", "Variable", "Custom"}):depend({builder_settings[i].body_mode, "Normal"})
    builder_settings[i].body_flip_speed = body_settings:slider("Flip Speed", 2, 20, 6, 1, "t"):depend({builder_settings[i].body_mode, "Normal"}, {builder_settings[i].body_flip_mode, "Custom"})
    builder_settings[i].body_inverter_mode = body_settings:combo("Inverter Mode", {"Disabled", "Random", "Cycle", "Alternate", "Custom"}):depend({builder_settings[i].body_mode, "Normal"})
    builder_settings[i].body_inverter_speed = body_settings:slider("Inverter Speed", 2, 20, 4, 1, "t"):depend({builder_settings[i].body_mode, "Normal"}, {builder_settings[i].body_inverter_mode, function() local mode = builder_settings[i].body_inverter_mode:get() return mode == "Alternate" or mode == "Custom" end})
end


local ui_defensive = {}
ui_defensive.state_selector = antiaim.aa_defensive:combo("\f<person-running> State", states)


for i, state in ipairs(states) do

    builder_settings[i].def_enable = antiaim.aa_defensive:switch("Defensive Override"):depend({ui_defensive.state_selector, state})
    

    builder_settings[i].def_force = antiaim.aa_defensive:switch("Force Defensive"):depend({ui_defensive.state_selector, state}, builder_settings[i].def_enable)
    builder_settings[i].def_force_mode = antiaim.aa_defensive:combo("Force Mode", {"Default", "Custom", "M-ways"}):depend({ui_defensive.state_selector, state}, builder_settings[i].def_enable, builder_settings[i].def_force)

    builder_settings[i].def_force_custom_type = antiaim.aa_defensive:combo("Custom Type", {"Normal", "Progress", "Gamesense", "Gamesense 2"}):depend({ui_defensive.state_selector, state}, builder_settings[i].def_enable, builder_settings[i].def_force, {builder_settings[i].def_force_mode, "Custom"})
    builder_settings[i].def_force_value = antiaim.aa_defensive:slider("Force Value", 1, 22, 14, 1):depend({ui_defensive.state_selector, state}, builder_settings[i].def_enable, builder_settings[i].def_force, {builder_settings[i].def_force_mode, "Custom"}, {builder_settings[i].def_force_custom_type, "Normal"})
    builder_settings[i].def_force_threshold = antiaim.aa_defensive:slider("Progress", 0, 100, 70, 1, "%"):depend({ui_defensive.state_selector, state}, builder_settings[i].def_enable, builder_settings[i].def_force, {builder_settings[i].def_force_mode, "Custom"}, {builder_settings[i].def_force_custom_type, "Progress"})
    builder_settings[i].def_force_gs_ticks = antiaim.aa_defensive:slider("GS Ticks", 1, 16, 13, 1):depend({ui_defensive.state_selector, state}, builder_settings[i].def_enable, builder_settings[i].def_force, {builder_settings[i].def_force_mode, "Custom"}, {builder_settings[i].def_force_custom_type, "Gamesense"})
    builder_settings[i].def_force_gs2_ticks = antiaim.aa_defensive:slider("GS 2 Ticks", 1, 16, 13, 1):depend({ui_defensive.state_selector, state}, builder_settings[i].def_enable, builder_settings[i].def_force, {builder_settings[i].def_force_mode, "Custom"}, {builder_settings[i].def_force_custom_type, "Gamesense 2"})
    builder_settings[i].def_force_mways_count = antiaim.aa_defensive:slider("Force Ways Count", 1, 20, 3, 1):depend({ui_defensive.state_selector, state}, builder_settings[i].def_enable, builder_settings[i].def_force, {builder_settings[i].def_force_mode, "M-ways"})
    builder_settings[i].def_force_mways = {}
    for j = 1, 20 do
        builder_settings[i].def_force_mways[j] = antiaim.aa_defensive:slider("Force Way " .. j, 1, 22, 14, 1):depend({ui_defensive.state_selector, state}, builder_settings[i].def_enable, builder_settings[i].def_force, {builder_settings[i].def_force_mode, "M-ways"}, {builder_settings[i].def_force_mways_count, function(count) return j <= count:get() end})

    end
    builder_settings[i].def_force_loop_mode = antiaim.aa_defensive:combo("Method", {"Cycle", "Random", "Mixed", "Multi", "Delayed"}):depend({ui_defensive.state_selector, state}, builder_settings[i].def_enable, builder_settings[i].def_force, {builder_settings[i].def_force_mode, "M-ways"})
    builder_settings[i].def_force_repeat_count = antiaim.aa_defensive:slider("Multi Count", 1, 10, 2, 1):depend({ui_defensive.state_selector, state}, builder_settings[i].def_enable, builder_settings[i].def_force, {builder_settings[i].def_force_mode, "M-ways"}, {builder_settings[i].def_force_loop_mode, "Multi"})
    builder_settings[i].def_force_delay_type = antiaim.aa_defensive:combo("Delay Type", {"Ticks", "Seconds"}):depend({ui_defensive.state_selector, state}, builder_settings[i].def_enable, builder_settings[i].def_force, {builder_settings[i].def_force_mode, "M-ways"}, {builder_settings[i].def_force_loop_mode, "Delayed"})
    builder_settings[i].def_force_delay_ticks = antiaim.aa_defensive:slider("Delay Ticks", 10, 100, 30, 1):depend({ui_defensive.state_selector, state}, builder_settings[i].def_enable, builder_settings[i].def_force, {builder_settings[i].def_force_mode, "M-ways"}, {builder_settings[i].def_force_loop_mode, "Delayed"}, {builder_settings[i].def_force_delay_type, "Ticks"})
    builder_settings[i].def_force_delay_seconds = antiaim.aa_defensive:slider("Delay Seconds", 0.5, 10.0, 2.0, 0.1, "s"):depend({ui_defensive.state_selector, state}, builder_settings[i].def_enable, builder_settings[i].def_force, {builder_settings[i].def_force_mode, "M-ways"}, {builder_settings[i].def_force_loop_mode, "Delayed"}, {builder_settings[i].def_force_delay_type, "Seconds"})
    builder_settings[i].def_pitch = antiaim.aa_defensive:combo("Defensive Pitch", {"Disabled", "Up", "Down", "Custom", "Jitter", "Random", "M-ways", "Spin", "Sway"}):depend({ui_defensive.state_selector, state}, builder_settings[i].def_enable)
    builder_settings[i].def_pitch_custom = antiaim.aa_defensive:slider("Pitch Custom", -89, 89, 0, 1, "°"):depend({ui_defensive.state_selector, state}, builder_settings[i].def_enable, {builder_settings[i].def_pitch, "Custom"})
    builder_settings[i].def_pitch_jitter_angle1 = antiaim.aa_defensive:slider("Pitch Jitter Angle 1", -89, 89, -89, 1, "°"):depend({ui_defensive.state_selector, state}, builder_settings[i].def_enable, {builder_settings[i].def_pitch, "Jitter"})
    builder_settings[i].def_pitch_jitter_angle2 = antiaim.aa_defensive:slider("Pitch Jitter Angle 2", -89, 89, 89, 1, "°"):depend({ui_defensive.state_selector, state}, builder_settings[i].def_enable, {builder_settings[i].def_pitch, "Jitter"})
    builder_settings[i].def_pitch_jitter_speed = antiaim.aa_defensive:slider("Pitch Jitter Speed", 0, 20, 3, 1):depend({ui_defensive.state_selector, state}, builder_settings[i].def_enable, {builder_settings[i].def_pitch, "Jitter"})
    builder_settings[i].def_pitch_random_angle1 = antiaim.aa_defensive:slider("Pitch Random Angle 1", -89, 89, -89, 1, "°"):depend({ui_defensive.state_selector, state}, builder_settings[i].def_enable, {builder_settings[i].def_pitch, "Random"})
    builder_settings[i].def_pitch_random_angle2 = antiaim.aa_defensive:slider("Pitch Random Angle 2", -89, 89, 89, 1, "°"):depend({ui_defensive.state_selector, state}, builder_settings[i].def_enable, {builder_settings[i].def_pitch, "Random"})
    builder_settings[i].def_pitch_mways_count = antiaim.aa_defensive:slider("Pitch Ways Count", 1, 10, 3, 1):depend({ui_defensive.state_selector, state}, builder_settings[i].def_enable, {builder_settings[i].def_pitch, "M-ways"})
    builder_settings[i].def_pitch_mways_speed = antiaim.aa_defensive:slider("Pitch Ways Speed", 0, 20, 3, 1):depend({ui_defensive.state_selector, state}, builder_settings[i].def_enable, {builder_settings[i].def_pitch, "M-ways"})
    builder_settings[i].def_pitch_mways_speed:tooltip("0 = Follow Force Defensive speed")
    builder_settings[i].def_pitch_mways = {}
    for j = 1, 10 do
        builder_settings[i].def_pitch_mways[j] = antiaim.aa_defensive:slider("Pitch Way " .. j, -89, 89, 0, 1, "°"):depend({ui_defensive.state_selector, state}, builder_settings[i].def_enable, {builder_settings[i].def_pitch, "M-ways"}, {builder_settings[i].def_pitch_mways_count, function(count) return j <= count:get() end})
    end
    builder_settings[i].def_pitch_spin_angle1 = antiaim.aa_defensive:slider("Pitch Spin Angle 1", -89, 89, -89, 1, "°"):depend({ui_defensive.state_selector, state}, builder_settings[i].def_enable, {builder_settings[i].def_pitch, "Spin"})
    builder_settings[i].def_pitch_spin_angle2 = antiaim.aa_defensive:slider("Pitch Spin Angle 2", -89, 89, 89, 1, "°"):depend({ui_defensive.state_selector, state}, builder_settings[i].def_enable, {builder_settings[i].def_pitch, "Spin"})
    builder_settings[i].def_pitch_spin_speed = antiaim.aa_defensive:slider("Pitch Spin Speed", 1, 20, 5, 1):depend({ui_defensive.state_selector, state}, builder_settings[i].def_enable, {builder_settings[i].def_pitch, "Spin"})
    builder_settings[i].def_pitch_sway_speed = antiaim.aa_defensive:slider("Pitch Sway Speed", 1, 20, 5, 1):depend({ui_defensive.state_selector, state}, builder_settings[i].def_enable, {builder_settings[i].def_pitch, "Sway"})
    builder_settings[i].def_yaw = antiaim.aa_defensive:combo("Defensive Yaw", {"Disabled", "Hidden", "Custom", "Jitter", "Random", "M-ways", "Flick", "Spin", "M-Spin", "Sway", "Random Jitter", "Spin Jitter", "Sway Jitter", "Random Flick", "Spin Flick", "Sway Flick"}):depend({ui_defensive.state_selector, state}, builder_settings[i].def_enable)
    builder_settings[i].def_yaw_custom = antiaim.aa_defensive:slider("Yaw Custom", -180, 180, 0, 1, "°"):depend({ui_defensive.state_selector, state}, builder_settings[i].def_enable, {builder_settings[i].def_yaw, "Custom"})
    builder_settings[i].def_yaw_jitter_angle1 = antiaim.aa_defensive:slider("Yaw Jitter Angle 1", -180, 180, -90, 1, "°"):depend({ui_defensive.state_selector, state}, builder_settings[i].def_enable, {builder_settings[i].def_yaw, "Jitter"})
    builder_settings[i].def_yaw_jitter_angle2 = antiaim.aa_defensive:slider("Yaw Jitter Angle 2", -180, 180, 90, 1, "°"):depend({ui_defensive.state_selector, state}, builder_settings[i].def_enable, {builder_settings[i].def_yaw, "Jitter"})
    builder_settings[i].def_yaw_jitter_speed = antiaim.aa_defensive:slider("Yaw Jitter Speed", 0, 20, 3, 1):depend({ui_defensive.state_selector, state}, builder_settings[i].def_enable, {builder_settings[i].def_yaw, "Jitter"})
    builder_settings[i].def_yaw_jitter_speed:tooltip("0 = Follow Force Defensive speed")
    builder_settings[i].def_yaw_random_angle1 = antiaim.aa_defensive:slider("Yaw Random Angle 1", -180, 180, -90, 1, "°"):depend({ui_defensive.state_selector, state}, builder_settings[i].def_enable, {builder_settings[i].def_yaw, "Random"})
    builder_settings[i].def_yaw_random_angle2 = antiaim.aa_defensive:slider("Yaw Random Angle 2", -180, 180, 90, 1, "°"):depend({ui_defensive.state_selector, state}, builder_settings[i].def_enable, {builder_settings[i].def_yaw, "Random"})
    builder_settings[i].def_yaw_flick_angle = antiaim.aa_defensive:slider("Flick Angle", -180, 180, 0, 1, "°"):depend({ui_defensive.state_selector, state}, builder_settings[i].def_enable, {builder_settings[i].def_yaw, "Flick"})
    builder_settings[i].def_yaw_flick_ticks = antiaim.aa_defensive:slider("Flick Ticks", 1, 10, 2, 1):depend({ui_defensive.state_selector, state}, builder_settings[i].def_enable, {builder_settings[i].def_yaw, "Flick"})
    builder_settings[i].def_yaw_mways_count = antiaim.aa_defensive:slider("Yaw Ways Count", 1, 20, 3, 1):depend({ui_defensive.state_selector, state}, builder_settings[i].def_enable, {builder_settings[i].def_yaw, "M-ways"})
    builder_settings[i].def_yaw_mways_speed = antiaim.aa_defensive:slider("Yaw Ways Speed", 0, 20, 3, 1):depend({ui_defensive.state_selector, state}, builder_settings[i].def_enable, {builder_settings[i].def_yaw, "M-ways"})
    builder_settings[i].def_yaw_mways_speed:tooltip("0 = Follow Force Defensive speed")
    builder_settings[i].def_yaw_mways = {}
    for j = 1, 20 do
        builder_settings[i].def_yaw_mways[j] = antiaim.aa_defensive:slider("Yaw Way " .. j, -180, 180, 0, 1, "°"):depend({ui_defensive.state_selector, state}, builder_settings[i].def_enable, {builder_settings[i].def_yaw, "M-ways"}, {builder_settings[i].def_yaw_mways_count, function(count) return j <= count:get() end})
    end
    builder_settings[i].def_yaw_spin_angle = antiaim.aa_defensive:slider("Yaw Spin Angle", -180, 180, 180, 1, "°"):depend({ui_defensive.state_selector, state}, builder_settings[i].def_enable, {builder_settings[i].def_yaw, "Spin"})
    builder_settings[i].def_yaw_spin_speed = antiaim.aa_defensive:slider("Yaw Spin Speed", 1, 20, 8, 1):depend({ui_defensive.state_selector, state}, builder_settings[i].def_enable, {builder_settings[i].def_yaw, "Spin"})
    builder_settings[i].def_yaw_mspin_count = antiaim.aa_defensive:slider("M-Spin Count", 1, 20, 3, 1):depend({ui_defensive.state_selector, state}, builder_settings[i].def_enable, {builder_settings[i].def_yaw, "M-Spin"})
    builder_settings[i].def_yaw_mspin_speed = antiaim.aa_defensive:slider("M-Spin Speed", 1, 20, 3, 1):depend({ui_defensive.state_selector, state}, builder_settings[i].def_enable, {builder_settings[i].def_yaw, "M-Spin"})
    builder_settings[i].def_yaw_mspin = {}
    for j = 1, 20 do
        builder_settings[i].def_yaw_mspin[j] = antiaim.aa_defensive:slider("Spin " .. j, -180, 180, 0, 1, "°"):depend({ui_defensive.state_selector, state}, builder_settings[i].def_enable, {builder_settings[i].def_yaw, "M-Spin"}, {builder_settings[i].def_yaw_mspin_count, function(count) return j <= count:get() end})
    end
    builder_settings[i].def_yaw_sway_speed = antiaim.aa_defensive:slider("Yaw Sway Speed", 1, 20, 8, 1):depend({ui_defensive.state_selector, state}, builder_settings[i].def_enable, {builder_settings[i].def_yaw, "Sway"})
    builder_settings[i].def_yaw_rj_angle1 = antiaim.aa_defensive:slider("Jitter Angle 1", -180, 180, -90, 1, "°"):depend({ui_defensive.state_selector, state}, builder_settings[i].def_enable, {builder_settings[i].def_yaw, "Random Jitter"})
    builder_settings[i].def_yaw_rj_angle2 = antiaim.aa_defensive:slider("Jitter Angle 2", -180, 180, 90, 1, "°"):depend({ui_defensive.state_selector, state}, builder_settings[i].def_enable, {builder_settings[i].def_yaw, "Random Jitter"})
    builder_settings[i].def_yaw_rj_delay = antiaim.aa_defensive:slider("Jitter Delay", 1, 20, 3, 1, "t"):depend({ui_defensive.state_selector, state}, builder_settings[i].def_enable, {builder_settings[i].def_yaw, "Random Jitter"})
    builder_settings[i].def_yaw_rj_range1 = antiaim.aa_defensive:slider("Random Range 1", -180, 180, 30, 1, "°"):depend({ui_defensive.state_selector, state}, builder_settings[i].def_enable, {builder_settings[i].def_yaw, "Random Jitter"})
    builder_settings[i].def_yaw_rj_range2 = antiaim.aa_defensive:slider("Random Range 2", -180, 180, 30, 1, "°"):depend({ui_defensive.state_selector, state}, builder_settings[i].def_enable, {builder_settings[i].def_yaw, "Random Jitter"})
    builder_settings[i].def_yaw_sj_angle1 = antiaim.aa_defensive:slider("Jitter Angle 1", -180, 180, -90, 1, "°"):depend({ui_defensive.state_selector, state}, builder_settings[i].def_enable, {builder_settings[i].def_yaw, "Spin Jitter"})
    builder_settings[i].def_yaw_sj_angle2 = antiaim.aa_defensive:slider("Jitter Angle 2", -180, 180, 90, 1, "°"):depend({ui_defensive.state_selector, state}, builder_settings[i].def_enable, {builder_settings[i].def_yaw, "Spin Jitter"})
    builder_settings[i].def_yaw_sj_delay = antiaim.aa_defensive:slider("Jitter Delay", 1, 20, 3, 1, "t"):depend({ui_defensive.state_selector, state}, builder_settings[i].def_enable, {builder_settings[i].def_yaw, "Spin Jitter"})
    builder_settings[i].def_yaw_sj_spin_angle = antiaim.aa_defensive:slider("Spin Angle", -180, 180, 180, 1, "°"):depend({ui_defensive.state_selector, state}, builder_settings[i].def_enable, {builder_settings[i].def_yaw, "Spin Jitter"})
    builder_settings[i].def_yaw_sj_spin_speed = antiaim.aa_defensive:slider("Spin Speed", 1, 20, 8, 1):depend({ui_defensive.state_selector, state}, builder_settings[i].def_enable, {builder_settings[i].def_yaw, "Spin Jitter"})
    builder_settings[i].def_yaw_swj_angle1 = antiaim.aa_defensive:slider("Jitter Angle 1", -180, 180, -90, 1, "°"):depend({ui_defensive.state_selector, state}, builder_settings[i].def_enable, {builder_settings[i].def_yaw, "Sway Jitter"})
    builder_settings[i].def_yaw_swj_angle2 = antiaim.aa_defensive:slider("Jitter Angle 2", -180, 180, 90, 1, "°"):depend({ui_defensive.state_selector, state}, builder_settings[i].def_enable, {builder_settings[i].def_yaw, "Sway Jitter"})
    builder_settings[i].def_yaw_swj_delay = antiaim.aa_defensive:slider("Jitter Delay", 1, 20, 3, 1, "t"):depend({ui_defensive.state_selector, state}, builder_settings[i].def_enable, {builder_settings[i].def_yaw, "Sway Jitter"})
    builder_settings[i].def_yaw_swj_sway_speed = antiaim.aa_defensive:slider("Sway Speed", 1, 20, 8, 1):depend({ui_defensive.state_selector, state}, builder_settings[i].def_enable, {builder_settings[i].def_yaw, "Sway Jitter"})
    

    builder_settings[i].def_yaw_rf_angle1 = antiaim.aa_defensive:slider("Random Angle 1", -180, 180, -90, 1, "°"):depend({ui_defensive.state_selector, state}, builder_settings[i].def_enable, {builder_settings[i].def_yaw, "Random Flick"})
    builder_settings[i].def_yaw_rf_angle2 = antiaim.aa_defensive:slider("Random Angle 2", -180, 180, 90, 1, "°"):depend({ui_defensive.state_selector, state}, builder_settings[i].def_enable, {builder_settings[i].def_yaw, "Random Flick"})
    builder_settings[i].def_yaw_rf_flick_angle = antiaim.aa_defensive:slider("Flick Angle", -180, 180, 0, 1, "°"):depend({ui_defensive.state_selector, state}, builder_settings[i].def_enable, {builder_settings[i].def_yaw, "Random Flick"})
    builder_settings[i].def_yaw_rf_flick_ticks = antiaim.aa_defensive:slider("Flick Ticks", 1, 10, 2, 1):depend({ui_defensive.state_selector, state}, builder_settings[i].def_enable, {builder_settings[i].def_yaw, "Random Flick"})
    

    builder_settings[i].def_yaw_sf_spin_angle = antiaim.aa_defensive:slider("Spin Angle", -180, 180, 180, 1, "°"):depend({ui_defensive.state_selector, state}, builder_settings[i].def_enable, {builder_settings[i].def_yaw, "Spin Flick"})
    builder_settings[i].def_yaw_sf_spin_speed = antiaim.aa_defensive:slider("Spin Speed", 1, 20, 8, 1):depend({ui_defensive.state_selector, state}, builder_settings[i].def_enable, {builder_settings[i].def_yaw, "Spin Flick"})
    builder_settings[i].def_yaw_sf_flick_angle = antiaim.aa_defensive:slider("Flick Angle", -180, 180, 0, 1, "°"):depend({ui_defensive.state_selector, state}, builder_settings[i].def_enable, {builder_settings[i].def_yaw, "Spin Flick"})
    builder_settings[i].def_yaw_sf_flick_ticks = antiaim.aa_defensive:slider("Flick Ticks", 1, 10, 2, 1):depend({ui_defensive.state_selector, state}, builder_settings[i].def_enable, {builder_settings[i].def_yaw, "Spin Flick"})
    

    builder_settings[i].def_yaw_swf_sway_speed = antiaim.aa_defensive:slider("Sway Speed", 1, 20, 8, 1):depend({ui_defensive.state_selector, state}, builder_settings[i].def_enable, {builder_settings[i].def_yaw, "Sway Flick"})
    builder_settings[i].def_yaw_swf_flick_angle = antiaim.aa_defensive:slider("Flick Angle", -180, 180, 0, 1, "°"):depend({ui_defensive.state_selector, state}, builder_settings[i].def_enable, {builder_settings[i].def_yaw, "Sway Flick"})
    builder_settings[i].def_yaw_swf_flick_ticks = antiaim.aa_defensive:slider("Flick Ticks", 1, 10, 2, 1):depend({ui_defensive.state_selector, state}, builder_settings[i].def_enable, {builder_settings[i].def_yaw, "Sway Flick"})
    

    builder_settings[i].def_override_body = antiaim.aa_defensive:switch("Override Body Yaw"):depend({ui_defensive.state_selector, state}, builder_settings[i].def_enable)
    builder_settings[i].def_body_control_mode = antiaim.aa_defensive:combo("Control Mode", {"Automatic", "Manual"}):depend({ui_defensive.state_selector, state}, builder_settings[i].def_enable, builder_settings[i].def_override_body)
    builder_settings[i].def_body_switch_speed = antiaim.aa_defensive:slider("Switch Speed", 2, 20, 8, 1, "t"):depend({ui_defensive.state_selector, state}, builder_settings[i].def_enable, builder_settings[i].def_override_body, {builder_settings[i].def_body_control_mode, "Manual"})
    builder_settings[i].def_override_angles = antiaim.aa_defensive:switch("Override Angles"):depend({ui_defensive.state_selector, state}, builder_settings[i].def_enable, builder_settings[i].def_override_body)
    builder_settings[i].def_body_jitter = antiaim.aa_defensive:switch("Body Jitter"):depend({ui_defensive.state_selector, state}, builder_settings[i].def_enable, builder_settings[i].def_override_body)
    builder_settings[i].def_body_avoid_overlap = antiaim.aa_defensive:switch("Avoid Overlap"):depend({ui_defensive.state_selector, state}, builder_settings[i].def_enable, builder_settings[i].def_override_body)
    builder_settings[i].def_body_inverter = antiaim.aa_defensive:switch("Body Inverter"):depend({ui_defensive.state_selector, state}, builder_settings[i].def_enable, builder_settings[i].def_override_body)
    builder_settings[i].def_body_left_limit = antiaim.aa_defensive:slider("Body Left Limit", 0, 60, 60, 1):depend({ui_defensive.state_selector, state}, builder_settings[i].def_enable, builder_settings[i].def_override_body)
    builder_settings[i].def_body_right_limit = antiaim.aa_defensive:slider("Body Right Limit", 0, 60, 60, 1):depend({ui_defensive.state_selector, state}, builder_settings[i].def_enable, builder_settings[i].def_override_body)
    builder_settings[i].def_body_limit_mode = antiaim.aa_defensive:combo("Limit Mode", {"Static", "Random", "Cycle", "Range", "Tick"}):depend({ui_defensive.state_selector, state}, builder_settings[i].def_enable, builder_settings[i].def_override_body)
    builder_settings[i].def_body_range_left = antiaim.aa_defensive:slider("Left Range", 0, 60, 10):depend({ui_defensive.state_selector, state}, builder_settings[i].def_enable, builder_settings[i].def_override_body, {builder_settings[i].def_body_limit_mode, "Range"})
    builder_settings[i].def_body_range_right = antiaim.aa_defensive:slider("Right Range", 0, 60, 10):depend({ui_defensive.state_selector, state}, builder_settings[i].def_enable, builder_settings[i].def_override_body, {builder_settings[i].def_body_limit_mode, "Range"})
    builder_settings[i].def_body_tick_interval = antiaim.aa_defensive:slider("Tick Interval", 2, 20, 5, 1, "t"):depend({ui_defensive.state_selector, state}, builder_settings[i].def_enable, builder_settings[i].def_override_body, {builder_settings[i].def_body_limit_mode, "Tick"})
    builder_settings[i].def_body_flip_mode = antiaim.aa_defensive:combo("Flip Mode", {"Disabled", "Random", "Cycle", "Variable", "Custom"}):depend({ui_defensive.state_selector, state}, builder_settings[i].def_enable, builder_settings[i].def_override_body)
    builder_settings[i].def_body_flip_speed = antiaim.aa_defensive:slider("Flip Speed", 2, 20, 6, 1, "t"):depend({ui_defensive.state_selector, state}, builder_settings[i].def_enable, builder_settings[i].def_override_body, {builder_settings[i].def_body_flip_mode, "Custom"})
    builder_settings[i].def_body_inverter_mode = antiaim.aa_defensive:combo("Inverter Mode", {"Disabled", "Random", "Cycle", "Alternate", "Custom"}):depend({ui_defensive.state_selector, state}, builder_settings[i].def_enable, builder_settings[i].def_override_body)
    builder_settings[i].def_body_inverter_speed = antiaim.aa_defensive:slider("Inverter Speed", 2, 20, 4, 1, "t"):depend({ui_defensive.state_selector, state}, builder_settings[i].def_enable, builder_settings[i].def_override_body, {builder_settings[i].def_body_inverter_mode, function() local mode = builder_settings[i].def_body_inverter_mode:get() return mode == "Alternate" or mode == "Custom" end})
end


local ui_e_spam = {}
ui_e_spam.state_selector = antiaim.aa_e_spam:combo("\f<person-running> State", states)


for i, state in ipairs(states) do

    builder_settings[i].e_spam_enable = antiaim.aa_e_spam:switch("E-Spam Override"):depend({ui_e_spam.state_selector, state})
    

    builder_settings[i].e_spam_force = antiaim.aa_e_spam:switch("Force Defensive"):depend({ui_e_spam.state_selector, state}, builder_settings[i].e_spam_enable)
    builder_settings[i].e_spam_force_mode = antiaim.aa_e_spam:combo("Force Mode", {"Default", "Custom", "M-ways"}):depend({ui_e_spam.state_selector, state}, builder_settings[i].e_spam_enable, builder_settings[i].e_spam_force)

    builder_settings[i].e_spam_force_custom_type = antiaim.aa_e_spam:combo("Custom Type", {"Normal", "Progress", "Gamesense", "Gamesense 2"}):depend({ui_e_spam.state_selector, state}, builder_settings[i].e_spam_enable, builder_settings[i].e_spam_force, {builder_settings[i].e_spam_force_mode, "Custom"})
    builder_settings[i].e_spam_force_value = antiaim.aa_e_spam:slider("Force Value", 1, 22, 14, 1):depend({ui_e_spam.state_selector, state}, builder_settings[i].e_spam_enable, builder_settings[i].e_spam_force, {builder_settings[i].e_spam_force_mode, "Custom"}, {builder_settings[i].e_spam_force_custom_type, "Normal"})
    builder_settings[i].e_spam_force_threshold = antiaim.aa_e_spam:slider("Progress", 0, 100, 70, 1, "%"):depend({ui_e_spam.state_selector, state}, builder_settings[i].e_spam_enable, builder_settings[i].e_spam_force, {builder_settings[i].e_spam_force_mode, "Custom"}, {builder_settings[i].e_spam_force_custom_type, "Progress"})
    builder_settings[i].e_spam_force_gs_ticks = antiaim.aa_e_spam:slider("GS Ticks", 1, 16, 13, 1):depend({ui_e_spam.state_selector, state}, builder_settings[i].e_spam_enable, builder_settings[i].e_spam_force, {builder_settings[i].e_spam_force_mode, "Custom"}, {builder_settings[i].e_spam_force_custom_type, "Gamesense"})
    builder_settings[i].e_spam_force_gs2_ticks = antiaim.aa_e_spam:slider("GS 2 Ticks", 1, 16, 13, 1):depend({ui_e_spam.state_selector, state}, builder_settings[i].e_spam_enable, builder_settings[i].e_spam_force, {builder_settings[i].e_spam_force_mode, "Custom"}, {builder_settings[i].e_spam_force_custom_type, "Gamesense 2"})
    builder_settings[i].e_spam_force_mways_count = antiaim.aa_e_spam:slider("Force Ways Count", 1, 20, 3, 1):depend({ui_e_spam.state_selector, state}, builder_settings[i].e_spam_enable, builder_settings[i].e_spam_force, {builder_settings[i].e_spam_force_mode, "M-ways"})
    builder_settings[i].e_spam_force_mways = {}
    for j = 1, 20 do
        builder_settings[i].e_spam_force_mways[j] = antiaim.aa_e_spam:slider("Force Way " .. j, 1, 22, 14, 1):depend({ui_e_spam.state_selector, state}, builder_settings[i].e_spam_enable, builder_settings[i].e_spam_force, {builder_settings[i].e_spam_force_mode, "M-ways"}, {builder_settings[i].e_spam_force_mways_count, function(count) return j <= count:get() end})

    end
    builder_settings[i].e_spam_force_loop_mode = antiaim.aa_e_spam:combo("Method", {"Cycle", "Random", "Mixed", "Multi", "Delayed"}):depend({ui_e_spam.state_selector, state}, builder_settings[i].e_spam_enable, builder_settings[i].e_spam_force, {builder_settings[i].e_spam_force_mode, "M-ways"})
    builder_settings[i].e_spam_force_repeat_count = antiaim.aa_e_spam:slider("Multi Count", 1, 10, 2, 1):depend({ui_e_spam.state_selector, state}, builder_settings[i].e_spam_enable, builder_settings[i].e_spam_force, {builder_settings[i].e_spam_force_mode, "M-ways"}, {builder_settings[i].e_spam_force_loop_mode, "Multi"})
    builder_settings[i].e_spam_force_delay_type = antiaim.aa_e_spam:combo("Delay Type", {"Ticks", "Seconds"}):depend({ui_e_spam.state_selector, state}, builder_settings[i].e_spam_enable, builder_settings[i].e_spam_force, {builder_settings[i].e_spam_force_mode, "M-ways"}, {builder_settings[i].e_spam_force_loop_mode, "Delayed"})
    builder_settings[i].e_spam_force_delay_ticks = antiaim.aa_e_spam:slider("Delay Ticks", 10, 100, 30, 1):depend({ui_e_spam.state_selector, state}, builder_settings[i].e_spam_enable, builder_settings[i].e_spam_force, {builder_settings[i].e_spam_force_mode, "M-ways"}, {builder_settings[i].e_spam_force_loop_mode, "Delayed"}, {builder_settings[i].e_spam_force_delay_type, "Ticks"})
    builder_settings[i].e_spam_force_delay_seconds = antiaim.aa_e_spam:slider("Delay Seconds", 0.5, 10.0, 2.0, 0.1, "s"):depend({ui_e_spam.state_selector, state}, builder_settings[i].e_spam_enable, builder_settings[i].e_spam_force, {builder_settings[i].e_spam_force_mode, "M-ways"}, {builder_settings[i].e_spam_force_loop_mode, "Delayed"}, {builder_settings[i].e_spam_force_delay_type, "Seconds"})
    

    builder_settings[i].e_spam_pitch = antiaim.aa_e_spam:combo("E-Spam Pitch", {"Disabled", "Up", "Down", "Custom", "Jitter", "Random", "M-ways", "Spin", "Sway"}):depend({ui_e_spam.state_selector, state}, builder_settings[i].e_spam_enable)
    builder_settings[i].e_spam_pitch_custom = antiaim.aa_e_spam:slider("Pitch Custom", -89, 89, 0, 1, "°"):depend({ui_e_spam.state_selector, state}, builder_settings[i].e_spam_enable, {builder_settings[i].e_spam_pitch, "Custom"})
    builder_settings[i].e_spam_pitch_jitter_angle1 = antiaim.aa_e_spam:slider("Pitch Jitter Angle 1", -89, 89, -89, 1, "°"):depend({ui_e_spam.state_selector, state}, builder_settings[i].e_spam_enable, {builder_settings[i].e_spam_pitch, "Jitter"})
    builder_settings[i].e_spam_pitch_jitter_angle2 = antiaim.aa_e_spam:slider("Pitch Jitter Angle 2", -89, 89, 89, 1, "°"):depend({ui_e_spam.state_selector, state}, builder_settings[i].e_spam_enable, {builder_settings[i].e_spam_pitch, "Jitter"})
    builder_settings[i].e_spam_pitch_jitter_speed = antiaim.aa_e_spam:slider("Pitch Jitter Speed", 1, 20, 3, 1):depend({ui_e_spam.state_selector, state}, builder_settings[i].e_spam_enable, {builder_settings[i].e_spam_pitch, "Jitter"})
    builder_settings[i].e_spam_pitch_random_angle1 = antiaim.aa_e_spam:slider("Pitch Random Angle 1", -89, 89, -89, 1, "°"):depend({ui_e_spam.state_selector, state}, builder_settings[i].e_spam_enable, {builder_settings[i].e_spam_pitch, "Random"})
    builder_settings[i].e_spam_pitch_random_angle2 = antiaim.aa_e_spam:slider("Pitch Random Angle 2", -89, 89, 89, 1, "°"):depend({ui_e_spam.state_selector, state}, builder_settings[i].e_spam_enable, {builder_settings[i].e_spam_pitch, "Random"})
    builder_settings[i].e_spam_pitch_mways_count = antiaim.aa_e_spam:slider("Pitch Ways Count", 1, 10, 3, 1):depend({ui_e_spam.state_selector, state}, builder_settings[i].e_spam_enable, {builder_settings[i].e_spam_pitch, "M-ways"})
    builder_settings[i].e_spam_pitch_mways_speed = antiaim.aa_e_spam:slider("Pitch Ways Speed", 0, 20, 3, 1):depend({ui_e_spam.state_selector, state}, builder_settings[i].e_spam_enable, {builder_settings[i].e_spam_pitch, "M-ways"})
    builder_settings[i].e_spam_pitch_mways = {}
    for j = 1, 10 do
        builder_settings[i].e_spam_pitch_mways[j] = antiaim.aa_e_spam:slider("Pitch Way " .. j, -89, 89, 0, 1, "°"):depend({ui_e_spam.state_selector, state}, builder_settings[i].e_spam_enable, {builder_settings[i].e_spam_pitch, "M-ways"}, {builder_settings[i].e_spam_pitch_mways_count, function(count) return j <= count:get() end})
    end
    builder_settings[i].e_spam_pitch_spin_angle1 = antiaim.aa_e_spam:slider("Pitch Spin Angle 1", -89, 89, -89, 1, "°"):depend({ui_e_spam.state_selector, state}, builder_settings[i].e_spam_enable, {builder_settings[i].e_spam_pitch, "Spin"})
    builder_settings[i].e_spam_pitch_spin_angle2 = antiaim.aa_e_spam:slider("Pitch Spin Angle 2", -89, 89, 89, 1, "°"):depend({ui_e_spam.state_selector, state}, builder_settings[i].e_spam_enable, {builder_settings[i].e_spam_pitch, "Spin"})
    builder_settings[i].e_spam_pitch_spin_speed = antiaim.aa_e_spam:slider("Pitch Spin Speed", 1, 20, 5, 1):depend({ui_e_spam.state_selector, state}, builder_settings[i].e_spam_enable, {builder_settings[i].e_spam_pitch, "Spin"})
    builder_settings[i].e_spam_pitch_sway_speed = antiaim.aa_e_spam:slider("Pitch Sway Speed", 1, 20, 5, 1):depend({ui_e_spam.state_selector, state}, builder_settings[i].e_spam_enable, {builder_settings[i].e_spam_pitch, "Sway"})
    

    builder_settings[i].e_spam_yaw = antiaim.aa_e_spam:combo("E-Spam Yaw", {"Hidden", "Custom", "Jitter", "Random", "M-ways", "Spin", "Sway"}):depend({ui_e_spam.state_selector, state}, builder_settings[i].e_spam_enable)
    builder_settings[i].e_spam_yaw_custom = antiaim.aa_e_spam:slider("Yaw Custom", -180, 180, 0, 1, "°"):depend({ui_e_spam.state_selector, state}, builder_settings[i].e_spam_enable, {builder_settings[i].e_spam_yaw, "Custom"})
    builder_settings[i].e_spam_yaw_jitter_angle1 = antiaim.aa_e_spam:slider("Yaw Jitter Angle 1", -180, 180, -90, 1, "°"):depend({ui_e_spam.state_selector, state}, builder_settings[i].e_spam_enable, {builder_settings[i].e_spam_yaw, "Jitter"})
    builder_settings[i].e_spam_yaw_jitter_angle2 = antiaim.aa_e_spam:slider("Yaw Jitter Angle 2", -180, 180, 90, 1, "°"):depend({ui_e_spam.state_selector, state}, builder_settings[i].e_spam_enable, {builder_settings[i].e_spam_yaw, "Jitter"})
    builder_settings[i].e_spam_yaw_jitter_speed = antiaim.aa_e_spam:slider("Yaw Jitter Speed", 1, 20, 3, 1):depend({ui_e_spam.state_selector, state}, builder_settings[i].e_spam_enable, {builder_settings[i].e_spam_yaw, "Jitter"})
    builder_settings[i].e_spam_yaw_random_angle1 = antiaim.aa_e_spam:slider("Yaw Random Angle 1", -180, 180, -90, 1, "°"):depend({ui_e_spam.state_selector, state}, builder_settings[i].e_spam_enable, {builder_settings[i].e_spam_yaw, "Random"})
    builder_settings[i].e_spam_yaw_random_angle2 = antiaim.aa_e_spam:slider("Yaw Random Angle 2", -180, 180, 90, 1, "°"):depend({ui_e_spam.state_selector, state}, builder_settings[i].e_spam_enable, {builder_settings[i].e_spam_yaw, "Random"})
    builder_settings[i].e_spam_yaw_mways_count = antiaim.aa_e_spam:slider("Yaw Ways Count", 1, 20, 3, 1):depend({ui_e_spam.state_selector, state}, builder_settings[i].e_spam_enable, {builder_settings[i].e_spam_yaw, "M-ways"})
    builder_settings[i].e_spam_yaw_mways_speed = antiaim.aa_e_spam:slider("Yaw Ways Speed", 0, 20, 3, 1):depend({ui_e_spam.state_selector, state}, builder_settings[i].e_spam_enable, {builder_settings[i].e_spam_yaw, "M-ways"})
    builder_settings[i].e_spam_yaw_mways = {}
    for j = 1, 20 do
        builder_settings[i].e_spam_yaw_mways[j] = antiaim.aa_e_spam:slider("Yaw Way " .. j, -180, 180, 0, 1, "°"):depend({ui_e_spam.state_selector, state}, builder_settings[i].e_spam_enable, {builder_settings[i].e_spam_yaw, "M-ways"}, {builder_settings[i].e_spam_yaw_mways_count, function(count) return j <= count:get() end})
    end
    builder_settings[i].e_spam_yaw_spin_angle = antiaim.aa_e_spam:slider("Yaw Spin Angle", -180, 180, 180, 1, "°"):depend({ui_e_spam.state_selector, state}, builder_settings[i].e_spam_enable, {builder_settings[i].e_spam_yaw, "Spin"})
    builder_settings[i].e_spam_yaw_spin_speed = antiaim.aa_e_spam:slider("Yaw Spin Speed", 1, 20, 8, 1):depend({ui_e_spam.state_selector, state}, builder_settings[i].e_spam_enable, {builder_settings[i].e_spam_yaw, "Spin"})
    builder_settings[i].e_spam_yaw_sway_speed = antiaim.aa_e_spam:slider("Yaw Sway Speed", 1, 20, 8, 1):depend({ui_e_spam.state_selector, state}, builder_settings[i].e_spam_enable, {builder_settings[i].e_spam_yaw, "Sway"})
end


local def_cycle_state = {
    pitch_mways_index = 1,
    pitch_mways_tick = 0,
    yaw_mways_index = 1,
    yaw_mways_tick = 0,
    yaw_mspin_index = 1,
    yaw_mspin_start_time = nil
}

local e_spam_aa_state = {
    pitch_mways_index = 1,
    pitch_mways_tick = 0,
    pitch_jitter_state = false,
    pitch_spin_time = 0,
    yaw_mways_index = 1,
    yaw_mways_tick = 0,
    yaw_jitter_state = false,
    yaw_spin_time = 0
}

local def_yaw_jitter_state = {
    rj_tick = 0,
    rj_side = false,
    sj_tick = 0,
    sj_side = false,
    swj_tick = 0,
    swj_side = false
}

-- Spin/Sway状态 (简单递增循环)
local spin_sway_state = {
    -- Defensive
    def_spin_value = 0,
    def_spin_dir = 1,
    def_mspin_value = 0,
    def_sway_value = 0,
    def_sway_dir = 1,
    def_sj_spin_value = 0,
    def_sj_spin_dir = 1,
    def_swj_sway_value = 0,
    def_swj_sway_dir = 1,
    def_sf_spin_value = 0,
    def_sf_spin_dir = 1,
    def_swf_sway_value = 0,
    def_swf_sway_dir = 1,
    -- E-Spam
    esp_spin_value = 0,
    esp_spin_dir = 1,
    esp_sway_value = 0,
    esp_sway_dir = 1,
}

local def_force_state = {
    mways_index = 1,
    mways_tick = 0,
    repeat_counter = 0,
    shuffle_order = {},
    shuffle_index = 1,
    delay_counter = 0,
    delay_last_time = 0,
    gs_active_ticks = 0,
    gs_was_in_def = false
}

local e_spam_force_state = {
    mways_index = 1,
    mways_tick = 0,
    repeat_counter = 0,
    shuffle_order = {},
    shuffle_index = 1,
    delay_counter = 0,
    delay_last_time = 0,
    gs_active_ticks = 0,
    gs_was_in_def = false
}

local def_charge_state = {
    last_triggered = false,
    last_tickbase = 0,
    absdef = 0,
    lc = 0
}


local function update_aa_page_visibility()
    if not page_selector then return end
    local current_page = page_selector.value
    

    antiaim.aa_main:visibility(current_page == 1)
    antiaim.aa_builder:visibility(current_page == 2)
    antiaim.aa_defensive:visibility(current_page == 3)
    antiaim.aa_e_spam:visibility(current_page == 4)
end

local function update_gear_page_visibility()
    if not gear_selector then return end
    local current_page = gear_selector.value
    
    visuals_ui.rage:visibility(current_page == 1)
    visuals_ui.misc:visibility(current_page == 2)
    visuals_ui.other:visibility(current_page == 3)
    visuals_ui.view:visibility(current_page == 4)
end

local function calculate_defensive_progress()
    local player = entity.get_local_player()
    if not player then return 0 end

    local current_tickbase = player.m_nTickBase
    local charge = def_charge_state
    charge.last_tickbase = math.max(charge.last_tickbase, current_tickbase)
    charge.absdef = charge.last_tickbase - current_tickbase

    if charge.absdef <= 0 then return 0 end

    local elapsed_ticks = 14 - charge.absdef
    local progress = (elapsed_ticks / 14) * 100
    return math.max(0, math.min(100, progress))
end


local flick_tb_history = {}
local flick_active_duration = 0
local flick_start_time = 0


local ui_visuals = {}

-- 现在定义add_neverlose_log函数
add_neverlose_log = function(icon_name, message)
    if not ui_visuals.log_neverlose or not ui_visuals.log_neverlose:get() then return end
    
    table.insert(neverlose_log_state.entries, {
        icon = icon_name,
        message = message,
        birth_time = globals.realtime,
        alpha = 0
    })
end

events.createmove:set(function(cmd)
    -- 移除了危险的roll修改

    local lp = entity.get_local_player()
    if lp then
        aa_state.is_in_air = cmd.in_jump or bit.band(lp.m_fFlags, 1) == 0
        

        if lp:is_alive() then
            local current_tickbase = lp.m_nTickBase or 0
            

            if math.abs(current_tickbase - di_visual.tracking.tb_max) > 64 then
                di_visual.tracking.tb_max = 0
            end
            

            if di_visual.tracking.tb_max < current_tickbase then
                di_visual.tracking.tb_max = current_tickbase
            end
            

            di_visual.cache.lag_comp = math.min(14, math.max(0, 
                di_visual.tracking.tb_max - current_tickbase - 1))
        end
    end
    

    local state_id = get_current_state()
    

    local current_settings
    if state_id == 1 then

        current_settings = builder_settings[1]
    else

        if builder_settings[state_id].enable and builder_settings[state_id].enable:get() then

            current_settings = builder_settings[state_id]
        else

            current_settings = builder_settings[1]
        end
    end
    

    -- Warmup AA早期检查 - 如果激活则跳过所有AA逻辑
    local warmup_aa_active = false
    if ui_antiaim_main.warmup_aa:get() then
        local lp = entity.get_local_player()
        if lp and lp:is_alive() then
            local warmup_active = entity.get_game_rules().m_bWarmupPeriod
            local enemies = entity.get_players(true)
            local no_enemies = #enemies == 0
            
            if warmup_active or no_enemies then
                warmup_aa_active = true
                -- Warmup AA激活时完全跳过所有AA逻辑
                return
            end
        end
    end
    
    aa_refs.aa_backstab:override(ui_antiaim_main.avoid_backstab:get())
    

    local safe_head_active = false
    local safe_head_is_knife = false
    if ui_antiaim_main.safe_head:get() and state_id == 8 then
        local lp = entity.get_local_player()
        if lp and lp:is_alive() then
            local get_player_weapon = lp:get_player_weapon()
            if get_player_weapon then
                local weapon = get_player_weapon:get_classname()
                local is_knife = string.match(weapon, "Knife")
                local is_taser = string.match(weapon, "Taser")
                
                if is_knife or is_taser then
                    safe_head_active = true
                    safe_head_is_knife = is_knife
                end
            end
        end
    end
    

    local manual_selection = ui_antiaim_main.manuals:get()
    local fs_enabled = ui_antiaim_main.freestanding:get()
    local use_manual = manual_selection ~= "Disabled"
    

    if not fs_enabled and not use_manual then
        aa_refs.aa_freestand:override(false)
    end
    

    if use_manual then
        local manual_yaw_value
        local manual_pitch_value = "Disabled"
        

        local use_e_spam_custom = false
        if ui_antiaim_main.manual_e_spam:get() then
            if current_settings.e_spam_enable then
                use_e_spam_custom = current_settings.e_spam_enable:get()
            end
        end
        

        local base_yaw_offset
        if manual_selection == "Right" then
            base_yaw_offset = 90
        elseif manual_selection == "Left" then
            base_yaw_offset = -90
        elseif manual_selection == "Forward" then
            base_yaw_offset = 180
        end
        
        if ui_antiaim_main.manual_e_spam:get() then

            aa_refs.aa_hidden:override(true)
            
            if use_e_spam_custom then

                if current_settings.e_spam_force and current_settings.e_spam_force:get() then
                    local force_mode = current_settings.e_spam_force_mode:get()
                    local triggered = false
                    
                    if force_mode == "Custom" then
                        local custom_type = current_settings.e_spam_force_custom_type:get()
                        
                        if custom_type == "Normal" then

                            local force_value = current_settings.e_spam_force_value:get()
                            triggered = cmd.command_number % force_value == 0
                        elseif custom_type == "Progress" then

                            local threshold_percent = current_settings.e_spam_force_threshold:get()
                            local current_progress = calculate_defensive_progress()
                            triggered = current_progress >= (100 - threshold_percent)
                        elseif custom_type == "Gamesense" then

                            local force_state = e_spam_force_state
                            local current_lc = def_charge_state.lc or 0
                            local in_def = current_lc > 0
                            local was_in_def = force_state.gs_was_in_def
                            local gs_ticks_setting = current_settings.e_spam_force_gs_ticks:get()

                            if in_def then
                                if not was_in_def then
                                    force_state.gs_active_ticks = 0
                                end

                                force_state.gs_active_ticks = (force_state.gs_active_ticks or 0) + 1
                                local active_window = gs_ticks_setting >= force_state.gs_active_ticks

                                if active_window and not safe_head_active and not warmup_aa_active then
                                    aa_refs.aa_hidden:override(true)
                                end
                                def_charge_state.last_triggered = active_window
                            else
                                force_state.gs_active_ticks = 0
                            end

                            force_state.gs_was_in_def = in_def
                            force_state.gs_last_lc = current_lc
                            
                            if (not in_def or not (force_state.gs_active_ticks and gs_ticks_setting >= force_state.gs_active_ticks)) and not safe_head_active and not warmup_aa_active then
                                aa_refs.aa_hidden:override(false)
                            end
                        elseif custom_type == "Gamesense 2" then
                            -- Gamesense 2: 独立周期系统，不依赖defensive触发
                            -- 总周期14 ticks，前gs2_ticks为激活窗口
                            e_spam_force_state.gs2_ticks_setting = current_settings.e_spam_force_gs2_ticks:get()
                            e_spam_force_state.gs2_total_cycle = 14
                            e_spam_force_state.gs2_cycle_position = globals.tickcount % e_spam_force_state.gs2_total_cycle
                            e_spam_force_state.gs2_is_active = e_spam_force_state.gs2_cycle_position < e_spam_force_state.gs2_ticks_setting
                            
                            -- Hidden只在满足条件时设置
                            if not safe_head_active and not warmup_aa_active then
                                if e_spam_force_state.gs2_is_active then
                                    aa_refs.aa_hidden:override(true)
                                else
                                    aa_refs.aa_hidden:override(false)
                                end
                            end
                            
                            -- DT和OS选项始终根据gs2_is_active设置
                            if e_spam_force_state.gs2_is_active then
                                aa_refs.aa_dt_options:override("Always On")
                                aa_refs.aa_os_options:override("Break LC")
                            else
                                aa_refs.aa_dt_options:override("On peek")
                                aa_refs.aa_os_options:override("Favor Fire Rate")
                            end
                            
                            def_charge_state.last_triggered = e_spam_force_state.gs2_is_active
                        end
                    elseif force_mode == "M-ways" then
                        local ways_count = current_settings.e_spam_force_mways_count:get()
                        local loop_mode = current_settings.e_spam_force_loop_mode:get()
                        local fs = e_spam_force_state
                        

                        if loop_mode == "Cycle" then

                            fs.mways_tick = fs.mways_tick + 1
                            if fs.mways_tick >= 2 then
                                fs.mways_index = (fs.mways_index % ways_count) + 1
                                fs.mways_tick = 0
                            end
                            
                        elseif loop_mode == "Random" then

                            if fs.mways_tick == 0 then
                                fs.mways_index = math.random(1, ways_count)
                                fs.mways_tick = 2
                            end
                            fs.mways_tick = fs.mways_tick - 1
                            
                        elseif loop_mode == "Mixed" then

                            if #fs.shuffle_order == 0 then
                                for i = 1, ways_count do
                                    fs.shuffle_order[i] = i
                                end
                                for i = ways_count, 2, -1 do
                                    local j = math.random(1, i)
                                    fs.shuffle_order[i], fs.shuffle_order[j] = fs.shuffle_order[j], fs.shuffle_order[i]
                                end
                                fs.shuffle_index = 1
                            end
                            
                            fs.mways_tick = fs.mways_tick + 1
                            if fs.mways_tick >= 2 then
                                fs.shuffle_index = fs.shuffle_index + 1
                                if fs.shuffle_index > ways_count then
                                    fs.shuffle_order = {}
                                    fs.shuffle_index = 1
                                end
                                fs.mways_tick = 0
                            end
                            fs.mways_index = fs.shuffle_order[fs.shuffle_index] or 1
                            
                        elseif loop_mode == "Multi" then

                            local repeat_count = current_settings.e_spam_force_repeat_count:get()
                            fs.repeat_counter = fs.repeat_counter + 1
                            
                            if fs.repeat_counter >= repeat_count * 2 then
                                fs.mways_index = (fs.mways_index % ways_count) + 1
                                fs.repeat_counter = 0
                            end
                            
                        elseif loop_mode == "Delayed" then

                            local delay_type = current_settings.e_spam_force_delay_type:get()
                            local should_switch = false
                            
                            if delay_type == "Ticks" then
                                local delay_ticks = current_settings.e_spam_force_delay_ticks:get()
                                fs.delay_counter = fs.delay_counter + 1
                                if fs.delay_counter >= delay_ticks then
                                    should_switch = true
                                    fs.delay_counter = 0
                                end
                            else
                                local delay_seconds = current_settings.e_spam_force_delay_seconds:get()
                                local current_time = globals.realtime
                                if fs.delay_last_time == 0 then
                                    fs.delay_last_time = current_time
                                end
                                if (current_time - fs.delay_last_time) >= delay_seconds then
                                    should_switch = true
                                    fs.delay_last_time = current_time
                                end
                            end
                            
                            if should_switch then
                                fs.mways_index = (fs.mways_index % ways_count) + 1
                            end
                        end
                        

                        local force_value = current_settings.e_spam_force_mways[fs.mways_index]:get()
                        triggered = cmd.command_number % force_value == 0
                    else
                        triggered = cmd.command_number % 14 == 0
                    end
                    
                    cmd.force_defensive = triggered
                end
                

                manual_pitch_value = current_settings.e_spam_pitch:get()
                local yaw_mode = current_settings.e_spam_yaw:get()
                

                if yaw_mode == "Hidden" then
                    manual_yaw_value = 0
                elseif yaw_mode == "Custom" then
                    manual_yaw_value = -current_settings.e_spam_yaw_custom:get()
                elseif yaw_mode == "Jitter" then
                    local angle1 = current_settings.e_spam_yaw_jitter_angle1:get()
                    local angle2 = current_settings.e_spam_yaw_jitter_angle2:get()
                    local speed = current_settings.e_spam_yaw_jitter_speed:get()
                    local aa_state = e_spam_aa_state
                    local jitter_state
                    if speed == 0 then
                        jitter_state = aa_state.yaw_jitter_state
                    else
                        jitter_state = math.floor(globals.tickcount / speed) % 2 == 0
                        aa_state.yaw_jitter_state = jitter_state
                    end
                    manual_yaw_value = -(jitter_state and angle1 or angle2)
                elseif yaw_mode == "Random" then

                    local angle1 = current_settings.e_spam_yaw_random_angle1:get()
                    local angle2 = current_settings.e_spam_yaw_random_angle2:get()
                    local min_angle = math.min(angle1, angle2)
                    local max_angle = math.max(angle1, angle2)
                    manual_yaw_value = -math.random(min_angle, max_angle)
                elseif yaw_mode == "M-ways" then
                    local ways_count = current_settings.e_spam_yaw_mways_count:get()
                    local ways_speed = current_settings.e_spam_yaw_mways_speed:get()
                    local aa_state = e_spam_aa_state
                    
                    if ways_speed == 0 then
                        if aa_state.yaw_jitter_state then
                            aa_state.yaw_mways_index = (aa_state.yaw_mways_index % ways_count) + 1
                        end
                    else
                        aa_state.yaw_mways_tick = aa_state.yaw_mways_tick + 1
                        if aa_state.yaw_mways_tick >= ways_speed then
                            aa_state.yaw_mways_index = (aa_state.yaw_mways_index % ways_count) + 1
                            aa_state.yaw_mways_tick = 0
                        end
                    end
                    
                    manual_yaw_value = -current_settings.e_spam_yaw_mways[aa_state.yaw_mways_index]:get()
                elseif yaw_mode == "Spin" then
                    local spin_angle = current_settings.e_spam_yaw_spin_angle:get()
                    local spin_speed = current_settings.e_spam_yaw_spin_speed:get()
                    local ss = spin_sway_state
                    
                    local actual_angle = math.abs(spin_angle) * 2
                    ss.esp_spin_value = ss.esp_spin_value + spin_speed * 1.5
                    if ss.esp_spin_value >= actual_angle then
                        ss.esp_spin_value = 0
                    end
                    
                    manual_yaw_value = ss.esp_spin_value * (spin_angle >= 0 and -1 or 1)
                elseif yaw_mode == "Sway" then
                    local sway_speed = current_settings.e_spam_yaw_sway_speed:get()
                    local ss = spin_sway_state
                    
                    ss.esp_sway_value = ss.esp_sway_value + sway_speed * 1.5 * ss.esp_sway_dir
                    if ss.esp_sway_value >= 360 then
                        ss.esp_sway_value = 360
                        ss.esp_sway_dir = -1
                    elseif ss.esp_sway_value <= 0 then
                        ss.esp_sway_value = 0
                        ss.esp_sway_dir = 1
                    end
                    
                    manual_yaw_value = ss.esp_sway_value
                end
            else

                manual_pitch_value = "Disabled"
                if manual_selection == "Forward" then
                    manual_yaw_value = -180
                elseif manual_selection == "Left" then
                    manual_yaw_value = -180
                elseif manual_selection == "Right" then
                    manual_yaw_value = 180
                end
            end
        else

            aa_refs.aa_hidden:override(false)
            aa_refs.aa_modifier:override("Disabled")
            manual_yaw_value = base_yaw_offset
        end
        

        if manual_yaw_value then

            aa_refs.aa_yaw_offset:override(base_yaw_offset)
            aa_refs.aa_yaw_base:override("Local View")
            aa_refs.aa_freestand:override(false)
            

            if not ui_antiaim_main.manual_e_spam:get() then
                aa_refs.aa_hidden:override(false)
            end
            
            if ui_antiaim_main.manual_e_spam:get() then

                local pitch_value = 0
                

                if manual_pitch_value == "Up" then
                    pitch_value = -89
                elseif manual_pitch_value == "Down" then
                    pitch_value = 89
                elseif manual_pitch_value == "Custom" then
                    pitch_value = current_settings.e_spam_pitch_custom:get()
                elseif manual_pitch_value == "Jitter" then
                    local angle1 = current_settings.e_spam_pitch_jitter_angle1:get()
                    local angle2 = current_settings.e_spam_pitch_jitter_angle2:get()
                    local speed = current_settings.e_spam_pitch_jitter_speed:get()
                    local aa_state = e_spam_aa_state
                    local jitter_state
                    if speed == 0 then
                        jitter_state = aa_state.pitch_jitter_state
                    else
                        jitter_state = math.floor(globals.tickcount / speed) % 2 == 0
                        aa_state.pitch_jitter_state = jitter_state
                    end
                    pitch_value = jitter_state and angle1 or angle2
                elseif manual_pitch_value == "Random" then

                    local angle1 = current_settings.e_spam_pitch_random_angle1:get()
                    local angle2 = current_settings.e_spam_pitch_random_angle2:get()
                    local min_angle = math.min(angle1, angle2)
                    local max_angle = math.max(angle1, angle2)
                    pitch_value = math.random(min_angle, max_angle)
                elseif manual_pitch_value == "M-ways" then
                    local ways_count = current_settings.e_spam_pitch_mways_count:get()
                    local ways_speed = current_settings.e_spam_pitch_mways_speed:get()
                    local aa_state = e_spam_aa_state
                    
                    if ways_speed == 0 then
                        if aa_state.pitch_jitter_state then
                            aa_state.pitch_mways_index = (aa_state.pitch_mways_index % ways_count) + 1
                        end
                    else
                        aa_state.pitch_mways_tick = aa_state.pitch_mways_tick + 1
                        if aa_state.pitch_mways_tick >= ways_speed then
                            aa_state.pitch_mways_index = (aa_state.pitch_mways_index % ways_count) + 1
                            aa_state.pitch_mways_tick = 0
                        end
                    end
                    
                    pitch_value = current_settings.e_spam_pitch_mways[aa_state.pitch_mways_index]:get()
                elseif manual_pitch_value == "Spin" then
                    local spin_angle1 = current_settings.e_spam_pitch_spin_angle1:get()
                    local spin_angle2 = current_settings.e_spam_pitch_spin_angle2:get()
                    local spin_speed = current_settings.e_spam_pitch_spin_speed:get()
                    local t = globals.tickcount * (spin_speed / 4) * 0.05
                    local sine_value = (math.sin(t) + 1) * 0.5
                    pitch_value = spin_angle1 + sine_value * (spin_angle2 - spin_angle1)
                elseif manual_pitch_value == "Sway" then
                    local sway_speed = current_settings.e_spam_pitch_sway_speed:get()
                    local t = globals.tickcount * (sway_speed / 4) * 0.05
                    local sine_value = math.sin(t)
                    pitch_value = (sine_value + 1) * 0.5 * 178 - 89
                end
                

                rage.antiaim:override_hidden_pitch(pitch_value)
                rage.antiaim:override_hidden_yaw_offset(manual_yaw_value)
            end
            

            local is_manual_static = ui_antiaim_main.manual_static:get()
            if is_manual_static then
                aa_refs.aa_body_options:override("")
                aa_refs.aa_invert:override(false)
            else

                aa_refs.aa_body_options:override("Jitter")
            end
        end
        

    else

        if fs_enabled then
            aa_refs.aa_freestand:override(true)
            aa_refs.aa_yaw_offset:override(0)
            aa_refs.aa_yaw_base:override("Local View")
            

            local is_static = ui_antiaim_main.fs_static:get()
            if is_static then
                aa_refs.aa_body_options:override("")
            else
                aa_refs.aa_body_options:override("Jitter")
            end
        else

            

            aa_refs.aa_pitch:override(current_settings.pitch:get())
            

            if safe_head_active then

                aa_refs.aa_yaw_base:override("At Target")
                aa_refs.aa_hidden:override(false)
                aa_refs.aa_modifier:override("Disabled")
                if safe_head_is_knife then
                    aa_refs.aa_invert:override(false)  -- 刀：false
                    aa_refs.aa_limit_left:override(0)
                    aa_refs.aa_limit_right:override(0)
                else
                    aa_refs.aa_invert:override(true)   -- 电击枪：true
                    aa_refs.aa_limit_left:override(42)
                    aa_refs.aa_limit_right:override(42)
                end
                aa_refs.aa_body_options:override("")
                aa_refs.aa_yaw_offset:override(0)
            else



                local def_body_enabled = current_settings.def_enable and current_settings.def_enable:get()
                local use_def_body
                
                if def_body_enabled and current_settings.def_override_body and current_settings.def_override_body:get() then
                    local control_mode = current_settings.def_body_control_mode:get()
                    
                    if control_mode == "Automatic" then
                        use_def_body = def_charge_state.last_triggered
                    else
                        local switch_speed = current_settings.def_body_switch_speed:get()
                        use_def_body = (globals.tickcount % switch_speed) < (switch_speed / 2)
                    end
                else
                    use_def_body = false
                end
                
                -- Override Angles 逻辑
                if def_body_enabled and current_settings.def_override_body and current_settings.def_override_body:get() and current_settings.def_override_angles and current_settings.def_override_angles:get() then
                    if use_def_body then
                        aa_refs.aa_yaw_offset:override(0)
                        aa_refs.aa_modifier:override("Disabled")
                    else
                        aa_refs.aa_yaw_offset:override()
                        aa_refs.aa_modifier:override()
                    end
                end

                local body_settings = current_settings
                if use_def_body then

                    if current_settings.body_yaw:get() then
                        aa_refs.aa_body:override(true)
                        

                        local def_base_left = current_settings.def_body_left_limit:get()
                        local def_base_right = current_settings.def_body_right_limit:get()
                        local final_left, final_right = def_base_left, def_base_right
                        
                        local def_limit_mode = current_settings.def_body_limit_mode:get()
                        if def_limit_mode == "Random" then
                            final_left = math.random(0, math.min(60, def_base_left))
                            final_right = math.random(0, math.min(60, def_base_right))
                        elseif def_limit_mode == "Tick" then
                            local tick_interval = current_settings.def_body_tick_interval:get()
                            if (globals.tickcount % tick_interval) == 0 then
                                aa_state.def_body_limit_tick_state = not aa_state.def_body_limit_tick_state
                            end
                            if aa_state.def_body_limit_tick_state then
                                final_left = def_base_left
                                final_right = def_base_right
                            else
                                final_left = def_base_right
                                final_right = def_base_left
                            end
                        elseif def_limit_mode == "Cycle" then
                            local def_cycle_tick = math.floor(globals.tickcount / 8)
                            math.randomseed(def_cycle_tick)
                            
                            local def_left_min = math.max(0, def_base_left - 10)
                            local def_left_max = math.min(60, def_base_left + 15)
                            final_left = math.random(def_left_min, def_left_max)
                            
                            local def_right_min = math.max(0, def_base_right - 10)
                            local def_right_max = math.min(60, def_base_right + 15)
                            final_right = math.random(def_right_min, def_right_max)
                            
                            math.randomseed(globals.tickcount)
                        elseif def_limit_mode == "Range" then
                            local def_left_range = current_settings.def_body_range_left:get()
                            local def_right_range = current_settings.def_body_range_right:get()
                            
                            local def_left_min = def_base_left - def_left_range
                            if def_left_min < 0 then def_left_min = 0 end
                            local def_left_max = math.min(60, def_base_left)
                            
                            local def_right_min = def_base_right - def_right_range
                            if def_right_min < 0 then def_right_min = 0 end
                            local def_right_max = math.min(60, def_base_right)
                            
                            final_left = math.random(def_left_min, def_left_max)
                            final_right = math.random(def_right_min, def_right_max)
                        end
                        
                        aa_refs.aa_limit_left:override(final_left)
                        aa_refs.aa_limit_right:override(final_right)
                        

                        local def_should_enable_body = true
                        
                        local def_flip_mode = current_settings.def_body_flip_mode:get()
                        if def_flip_mode == "Random" then
                            def_should_enable_body = math.random(0, 1) == 1
                        elseif def_flip_mode == "Cycle" then
                            local def_current_tick = globals.tickcount
                            if aa_state.body_flip_cycle_start == 0 or (def_current_tick - aa_state.body_flip_cycle_start) >= aa_state.body_flip_cycle_duration then
                                aa_state.body_flip_cycle_duration = math.random(4, 12)
                                aa_state.body_flip_cycle_start = def_current_tick
                            end
                            local def_elapsed = def_current_tick - aa_state.body_flip_cycle_start
                            def_should_enable_body = def_elapsed < (aa_state.body_flip_cycle_duration / 2)
                        elseif def_flip_mode == "Variable" then
                            local def_cycle_pos = globals.tickcount % 30
                            if def_cycle_pos < 10 then
                                def_should_enable_body = (def_cycle_pos % 2) == 0
                            else
                                def_should_enable_body = ((def_cycle_pos - 10) % 10) < 5
                            end
                        elseif def_flip_mode == "Custom" then
                            local def_speed = current_settings.def_body_flip_speed:get()
                            def_should_enable_body = (globals.tickcount % def_speed) < (def_speed / 2)
                        end
                        
                        if def_flip_mode ~= "Disabled" then
                            aa_refs.aa_body:override(def_should_enable_body)
                        end
                        

                        local def_should_invert = current_settings.def_body_inverter:get()
                        
                        local def_inverter_mode = current_settings.def_body_inverter_mode:get()
                        if def_inverter_mode == "Random" then
                            def_should_invert = math.random(0, 1) == 1
                        elseif def_inverter_mode == "Cycle" then
                            local def_current_tick = globals.tickcount
                            if aa_state.body_inverter_cycle_start == 0 or (def_current_tick - aa_state.body_inverter_cycle_start) >= aa_state.body_inverter_cycle_duration then
                                aa_state.body_inverter_cycle_duration = math.random(6, 14)
                                aa_state.body_inverter_cycle_start = def_current_tick
                            end
                            local def_elapsed = def_current_tick - aa_state.body_inverter_cycle_start
                            def_should_invert = def_elapsed < (aa_state.body_inverter_cycle_duration / 2)
                        elseif def_inverter_mode == "Alternate" then
                            local def_speed = current_settings.def_body_inverter_speed:get()
                            def_should_invert = (math.floor(globals.tickcount / def_speed) % 2) == 0
                        elseif def_inverter_mode == "Custom" then
                            local def_speed = current_settings.def_body_inverter_speed:get()
                            def_should_invert = (globals.tickcount % def_speed) < (def_speed / 2)
                        end
                        
                        aa_refs.aa_invert:override(def_should_invert)
                    else
                        aa_refs.aa_body:override(false)
                    end
                else

                    if current_settings.body_yaw:get() then
                        aa_refs.aa_body:override(true)
                        
                        local body_mode = current_settings.body_mode:get()
                        
                        if body_mode == "Automatic" then


                            local current_tick = globals.tickcount
                            if current_tick - aa_state.body_auto_last_change >= math.random(128, 3840) then
                                local strategy = math.random(1, 3)
                                if strategy == 1 then
                                    aa_state.body_auto_left_value = math.random(20, 58)
                                elseif strategy == 2 then
                                    aa_state.body_auto_left_value = 28
                                else
                                    aa_state.body_auto_left_value = 58
                                end
                                aa_state.body_auto_last_change = current_tick
                            end
                            aa_refs.aa_limit_left:override(aa_state.body_auto_left_value)
                            aa_refs.aa_limit_right:override(58)
                        else

                            local base_left = current_settings.body_left_limit:get()
                            local base_right = current_settings.body_right_limit:get()
                            local final_left, final_right = base_left, base_right
                            
                            local limit_mode = current_settings.body_limit_mode:get()
                            if limit_mode == "Random" then
                                final_left = math.random(0, math.min(60, base_left))
                                final_right = math.random(0, math.min(60, base_right))
                            elseif limit_mode == "Tick" then
                                local tick_interval = current_settings.body_tick_interval:get()
                                if (globals.tickcount % tick_interval) == 0 then
                                    aa_state.body_limit_tick_state = not aa_state.body_limit_tick_state
                                end
                                if aa_state.body_limit_tick_state then
                                    final_left = base_left
                                    final_right = base_right
                                else
                                    final_left = base_right
                                    final_right = base_left
                                end
                            elseif limit_mode == "Cycle" then
                                local cycle_tick = math.floor(globals.tickcount / 8)
                                math.randomseed(cycle_tick)
                                
                                local left_min = math.max(0, base_left - 10)
                                local left_max = math.min(60, base_left + 15)
                                final_left = math.random(left_min, left_max)
                                
                                local right_min = math.max(0, base_right - 10)
                                local right_max = math.min(60, base_right + 15)
                                final_right = math.random(right_min, right_max)
                                
                                math.randomseed(globals.tickcount)
                            elseif limit_mode == "Range" then
                                local left_range = current_settings.body_range_left:get()
                                local right_range = current_settings.body_range_right:get()
                                
                                local left_min = base_left - left_range
                                if left_min < 0 then left_min = 0 end
                                local left_max = math.min(60, base_left)
                                
                                local right_min = base_right - right_range
                                if right_min < 0 then right_min = 0 end
                                local right_max = math.min(60, base_right)
                                
                                final_left = math.random(left_min, left_max)
                                final_right = math.random(right_min, right_max)
                            end
                            
                            aa_refs.aa_limit_left:override(final_left)
                            aa_refs.aa_limit_right:override(final_right)
                            

                            local should_enable_body = true
                            
                            local flip_mode = current_settings.body_flip_mode:get()
                            if flip_mode == "Random" then
                                should_enable_body = math.random(0, 1) == 1
                            elseif flip_mode == "Cycle" then
                                local current_tick = globals.tickcount
                                if aa_state.body_flip_cycle_start == 0 or (current_tick - aa_state.body_flip_cycle_start) >= aa_state.body_flip_cycle_duration then
                                    aa_state.body_flip_cycle_duration = math.random(4, 12)
                                    aa_state.body_flip_cycle_start = current_tick
                                end
                                local elapsed = current_tick - aa_state.body_flip_cycle_start
                                should_enable_body = elapsed < (aa_state.body_flip_cycle_duration / 2)
                            elseif flip_mode == "Variable" then
                                local cycle_pos = globals.tickcount % 30
                                if cycle_pos < 10 then
                                    should_enable_body = (cycle_pos % 2) == 0
                                else
                                    should_enable_body = ((cycle_pos - 10) % 10) < 5
                                end
                            elseif flip_mode == "Custom" then
                                local speed = current_settings.body_flip_speed:get()
                                should_enable_body = (globals.tickcount % speed) < (speed / 2)
                            end
                            
                            if flip_mode ~= "Disabled" then
                                aa_refs.aa_body:override(should_enable_body)
                            end
                            

                            local should_invert = current_settings.body_inverter:get()
                            
                            local inverter_mode = current_settings.body_inverter_mode:get()
                            if inverter_mode == "Random" then
                                should_invert = math.random(0, 1) == 1
                            elseif inverter_mode == "Cycle" then
                                local current_tick = globals.tickcount
                                if aa_state.body_inverter_cycle_start == 0 or (current_tick - aa_state.body_inverter_cycle_start) >= aa_state.body_inverter_cycle_duration then
                                    aa_state.body_inverter_cycle_duration = math.random(6, 14)
                                    aa_state.body_inverter_cycle_start = current_tick
                                end
                                local elapsed = current_tick - aa_state.body_inverter_cycle_start
                                should_invert = elapsed < (aa_state.body_inverter_cycle_duration / 2)
                            elseif inverter_mode == "Alternate" then
                                local speed = current_settings.body_inverter_speed:get()
                                should_invert = (math.floor(globals.tickcount / speed) % 2) == 0
                            elseif inverter_mode == "Custom" then
                                local speed = current_settings.body_inverter_speed:get()
                                should_invert = (globals.tickcount % speed) < (speed / 2)
                            end
                            
                            aa_refs.aa_invert:override(should_invert)
                        end
                    else
                        aa_refs.aa_body:override(false)
                    end
                end
                

                aa_refs.aa_yaw:override(current_settings.yaw:get())
                aa_refs.aa_yaw_base:override(current_settings.yaw_base:get())
                

                local check_body_jitter = use_def_body and current_settings.def_body_jitter:get() or current_settings.body_jitter:get()
                local should_switch_offset = check_body_jitter or current_settings.yaw_delay:get()
                
                if should_switch_offset then

                    if globals.choked_commands == 0 then

                        if current_settings.yaw_delay:get() then
                            local delay_mode = current_settings.yaw_delay_mode:get()
                            local current_delay
                            
                            if delay_mode == "M-Delays" then

                                local delay_count = current_settings.yaw_delay_count:get()
                                local random_index = math.random(1, delay_count)
                                current_delay = current_settings["yaw_delay_" .. random_index]:get() * 2
                            elseif delay_mode == "Fluctuation" then
                                -- Fluctuation mode: random delay within range
                                local base_delay = current_settings.yaw_delay_base:get()
                                local up_fluctuation = current_settings.yaw_delay_up_fluctuation:get()
                                local down_fluctuation = current_settings.yaw_delay_down_fluctuation:get()
                                
                                local min_delay = math.max(1, base_delay - down_fluctuation)
                                local max_delay = math.min(20, base_delay + up_fluctuation)
                                current_delay = math.random(min_delay, max_delay) * 2
                            else

                                current_delay = current_settings.yaw_delay_speed:get() * 2
                            end
                            
                            if globals.tickcount - aa_state.last_switch_tick >= current_delay then
                                aa_state.current_side = not aa_state.current_side
                                aa_state.last_switch_tick = globals.tickcount
                            end
                            
                            aa_state.active_side = aa_state.current_side
                        else

                            local body_dir = calculate_body_direction()
                            if body_dir ~= nil then
                                aa_state.active_side = body_dir
                            end
                        end
                    end
                end
                

                local offset_map = {
                    [true] = current_settings.yaw_offset_left:get(),
                    [false] = current_settings.yaw_offset_right:get()
                }
                local final_yaw = offset_map[aa_state.active_side]
                
                -- 检查是否应该跳过yaw_offset和modifier的覆盖（Override Angles启用时）
                local skip_angles_override = use_def_body and current_settings.def_override_angles and current_settings.def_override_angles:get()
                
                if not skip_angles_override then
                    aa_refs.aa_yaw_offset:override(final_yaw)
                end
                
                
                local check_jitter = use_def_body and current_settings.def_body_jitter:get() or current_settings.body_jitter:get()
                if current_settings.body_yaw:get() and (check_jitter or current_settings.yaw_delay:get()) then
                    rage.antiaim:inverter(aa_state.active_side)
                end
                
                
                if not skip_angles_override then
                    aa_refs.aa_modifier:override(current_settings.yaw_modifier:get())
                    aa_refs.aa_modifier_offset:override(current_settings.yaw_modifier_offset:get())
                else
                    aa_refs.aa_modifier_offset:override(current_settings.yaw_modifier_offset:get())
                end
                
                if current_settings.body_yaw:get() then

                    local jitter_enabled
                    local avoid_overlap_enabled
                    if use_def_body then
                        jitter_enabled = current_settings.def_body_jitter:get()
                        avoid_overlap_enabled = current_settings.def_body_avoid_overlap:get()
                    else
                        jitter_enabled = current_settings.body_jitter:get()
                        avoid_overlap_enabled = current_settings.body_avoid_overlap:get()
                    end
                    
                    local body_options = {}
                    if jitter_enabled then
                        table.insert(body_options, "Jitter")
                    end
                    if avoid_overlap_enabled then
                        table.insert(body_options, "Avoid overlap")
                    end
                    
                    if #body_options > 0 then
                        aa_refs.aa_body_options:override(unpack(body_options))
                    else
                        aa_refs.aa_body_options:override("")
                    end
                end
            end
        end
    end
    



    local e_spam_is_active = ui_antiaim_main.manual_e_spam:get() and use_manual
    local e_spam_force_enabled = e_spam_is_active and current_settings.e_spam_force and current_settings.e_spam_force:get()

    local def_enabled = current_settings.def_enable and current_settings.def_enable:get()
    local def_force_enabled = def_enabled and current_settings.def_force and current_settings.def_force:get()
    
    if e_spam_force_enabled or def_force_enabled then
        aa_refs.aa_dt_options:override("Always On")
        aa_refs.aa_os_options:override("Break LC")
    else
        aa_refs.aa_dt_options:override("On peek")
        aa_refs.aa_os_options:override("Favor Fire Rate")
    end
    
    if def_enabled and not use_manual and not safe_head_active then
        local def_yaw = current_settings.def_yaw:get()
        local def_pitch = current_settings.def_pitch:get()
        
        if def_yaw == "Disabled" and def_pitch == "Disabled" then
            aa_refs.aa_hidden:override(false)
        else
            aa_refs.aa_hidden:override(true)
        end
    end
    
    if def_force_enabled then
        local force_mode = current_settings.def_force_mode:get()
        local triggered = false
        
        if force_mode == "Custom" then
            local custom_type = current_settings.def_force_custom_type:get()
            
            if custom_type == "Normal" then

                local force_value = current_settings.def_force_value:get()
                triggered = cmd.command_number % force_value == 0
            elseif custom_type == "Progress" then

                local threshold_percent = current_settings.def_force_threshold:get()
                local current_progress = calculate_defensive_progress()
                triggered = current_progress >= (100 - threshold_percent)
            elseif custom_type == "Gamesense" then

                triggered = true
            end
        elseif force_mode == "M-ways" then
            local ways_count = current_settings.def_force_mways_count:get()
            local loop_mode = current_settings.def_force_loop_mode:get()
            

            local def_force = def_force_state

            if loop_mode == "Cycle" then

                def_force.mways_tick = def_force.mways_tick + 1
                if def_force.mways_tick >= 2 then
                    def_force.mways_index = (def_force.mways_index % ways_count) + 1
                    def_force.mways_tick = 0
                end
                
            elseif loop_mode == "Random" then

                if def_force.mways_tick == 0 then
                    def_force.mways_index = math.random(1, ways_count)
                    def_force.mways_tick = 2
                end
                def_force.mways_tick = def_force.mways_tick - 1
                
            elseif loop_mode == "Mixed" then

                if #def_force.shuffle_order == 0 then
                    for i = 1, ways_count do
                        def_force.shuffle_order[i] = i
                    end
                    for i = ways_count, 2, -1 do
                        local j = math.random(1, i)
                        def_force.shuffle_order[i], def_force.shuffle_order[j] = def_force.shuffle_order[j], def_force.shuffle_order[i]
                    end
                    def_force.shuffle_index = 1
                end
                
                def_force.mways_tick = def_force.mways_tick + 1
                if def_force.mways_tick >= 2 then
                    def_force.shuffle_index = def_force.shuffle_index + 1
                    if def_force.shuffle_index > ways_count then
                        def_force.shuffle_order = {}
                        def_force.shuffle_index = 1
                    end
                    def_force.mways_tick = 0
                end
                def_force.mways_index = def_force.shuffle_order[def_force.shuffle_index] or 1
                
            elseif loop_mode == "Multi" then

                local repeat_count = current_settings.def_force_repeat_count:get()
                def_force.repeat_counter = def_force.repeat_counter + 1
                
                if def_force.repeat_counter >= repeat_count * 2 then
                    def_force.mways_index = (def_force.mways_index % ways_count) + 1
                    def_force.repeat_counter = 0
                end
                
            elseif loop_mode == "Delayed" then

                local delay_type = current_settings.def_force_delay_type:get()
                local should_switch = false
                
                if delay_type == "Ticks" then
                    local delay_ticks = current_settings.def_force_delay_ticks:get()
                    def_force.delay_counter = def_force.delay_counter + 1
                    if def_force.delay_counter >= delay_ticks then
                        should_switch = true
                        def_force.delay_counter = 0
                    end
                else
                    local delay_seconds = current_settings.def_force_delay_seconds:get()
                    local current_time = globals.realtime
                    if def_force.delay_last_time == 0 then
                        def_force.delay_last_time = current_time
                    end
                    if (current_time - def_force.delay_last_time) >= delay_seconds then
                        should_switch = true
                        def_force.delay_last_time = current_time
                    end
                end
                
                if should_switch then
                    def_force.mways_index = (def_force.mways_index % ways_count) + 1
                end
            end
            

            local force_value = current_settings.def_force_mways[def_force.mways_index]:get()
            triggered = cmd.command_number % force_value == 0
        else
            triggered = cmd.command_number % 14 == 0
        end
        

        if not (use_manual and ui_antiaim_main.manual_e_spam:get()) and not warmup_aa_active then
            -- Gamesense: 仿照 hysteria snap
            -- 每个 defensive 周期内，只在前 GS_Ticks 个 tick 打开 Hidden，其余时间强制关闭 Hidden
            if force_mode == "Custom" and current_settings.def_force_custom_type:get() == "Gamesense" then
                local force_state = def_force_state
                local current_lc = def_charge_state.lc or 0
                local in_def = current_lc > 0
                local was_in_def = force_state.gs_was_in_def
                local gs_ticks_setting = current_settings.def_force_gs_ticks:get()

                if in_def then
                    if not was_in_def then
                        force_state.gs_active_ticks = 0
                    end

                    force_state.gs_active_ticks = (force_state.gs_active_ticks or 0) + 1
                    local active_window = gs_ticks_setting >= force_state.gs_active_ticks

                    if active_window and not safe_head_active and not use_manual and not warmup_aa_active then
                        aa_refs.aa_hidden:override(true)
                    end
                    def_charge_state.last_triggered = active_window
                else
                    force_state.gs_active_ticks = 0
                end

                force_state.gs_was_in_def = in_def
                force_state.gs_last_lc = current_lc
                
                -- 不在Duration窗口或不在defensive里：强制关闭Hidden（但不覆盖Safe Head）
                if (not in_def or not (force_state.gs_active_ticks and gs_ticks_setting >= force_state.gs_active_ticks)) and not safe_head_active and not use_manual and not warmup_aa_active then
                    aa_refs.aa_hidden:override(false)
                end
            elseif force_mode == "Custom" and current_settings.def_force_custom_type:get() == "Gamesense 2" then
                -- Gamesense 2: 独立周期系统，不依赖defensive触发
                -- 总周期14 ticks，前gs2_ticks为激活窗口
                def_force_state.gs2_ticks_setting = current_settings.def_force_gs2_ticks:get()
                def_force_state.gs2_total_cycle = 14
                def_force_state.gs2_cycle_position = globals.tickcount % def_force_state.gs2_total_cycle
                def_force_state.gs2_is_active = def_force_state.gs2_cycle_position < def_force_state.gs2_ticks_setting
                
                -- Hidden只在满足条件时设置
                if not safe_head_active and not use_manual and not warmup_aa_active then
                    if def_force_state.gs2_is_active then
                        aa_refs.aa_hidden:override(true)
                    else
                        aa_refs.aa_hidden:override(false)
                    end
                end
                
                -- DT和OS选项始终根据gs2_is_active设置
                if def_force_state.gs2_is_active then
                    aa_refs.aa_dt_options:override("Always On")
                    aa_refs.aa_os_options:override("Break LC")
                else
                    aa_refs.aa_dt_options:override("On peek")
                    aa_refs.aa_os_options:override("Favor Fire Rate")
                end
                
                def_charge_state.last_triggered = def_force_state.gs2_is_active
            else
                cmd.force_defensive = triggered
                def_charge_state.last_triggered = triggered
            end
        end
    end
    
    if def_enabled and not (use_manual and ui_antiaim_main.manual_e_spam:get()) then

        local def_pitch = current_settings.def_pitch:get()
        if def_pitch == "Up" then
            rage.antiaim:override_hidden_pitch(-89)
        elseif def_pitch == "Down" then
            rage.antiaim:override_hidden_pitch(89)
        elseif def_pitch == "Custom" then
            rage.antiaim:override_hidden_pitch(current_settings.def_pitch_custom:get())
        elseif def_pitch == "Jitter" then

            local angle1 = current_settings.def_pitch_jitter_angle1:get()
            local angle2 = current_settings.def_pitch_jitter_angle2:get()
            local jitter_speed = current_settings.def_pitch_jitter_speed:get()
            local jitter_state
            if jitter_speed == 0 then
                jitter_state = def_charge_state.last_triggered
            else
                jitter_state = math.floor(globals.tickcount / jitter_speed) % 2 == 0
            end
            local pitch_value = jitter_state and angle1 or angle2
            rage.antiaim:override_hidden_pitch(pitch_value)
        elseif def_pitch == "Random" then

            local angle1 = current_settings.def_pitch_random_angle1:get()
            local angle2 = current_settings.def_pitch_random_angle2:get()
            local min_angle = math.min(angle1, angle2)
            local max_angle = math.max(angle1, angle2)
            local random_angle = math.random(min_angle, max_angle)
            rage.antiaim:override_hidden_pitch(random_angle)
        elseif def_pitch == "M-ways" then

            local ways_count = current_settings.def_pitch_mways_count:get()
            local ways_speed = current_settings.def_pitch_mways_speed:get()
            

            if ways_speed == 0 then
                if def_charge_state.last_triggered then
                    def_cycle_state.pitch_mways_index = (def_cycle_state.pitch_mways_index % ways_count) + 1
                end
            else
                def_cycle_state.pitch_mways_tick = def_cycle_state.pitch_mways_tick + 1
                if def_cycle_state.pitch_mways_tick >= ways_speed then
                    def_cycle_state.pitch_mways_index = (def_cycle_state.pitch_mways_index % ways_count) + 1
                    def_cycle_state.pitch_mways_tick = 0
                end
            end
            
            local pitch_value = current_settings.def_pitch_mways[def_cycle_state.pitch_mways_index]:get()
            rage.antiaim:override_hidden_pitch(pitch_value)
        elseif def_pitch == "Spin" then

            local spin_angle1 = current_settings.def_pitch_spin_angle1:get()
            local spin_angle2 = current_settings.def_pitch_spin_angle2:get()
            local spin_speed = current_settings.def_pitch_spin_speed:get()
            local t = globals.tickcount * (spin_speed / 4) * 0.05
            local sine_value = (math.sin(t) + 1) * 0.5
            local pitch_value = spin_angle1 + sine_value * (spin_angle2 - spin_angle1)
            rage.antiaim:override_hidden_pitch(pitch_value)
        elseif def_pitch == "Sway" then

            local sway_speed = current_settings.def_pitch_sway_speed:get()
            local t = globals.tickcount * (sway_speed / 4) * 0.05
            local sine_value = math.sin(t)
            local pitch_value = (sine_value + 1) * 0.5 * 178 - 89
            rage.antiaim:override_hidden_pitch(pitch_value)
        end
        
        local def_yaw = current_settings.def_yaw:get()
        if def_yaw == "Disabled" then
            rage.antiaim:override_hidden_yaw_offset(0)
        elseif def_yaw == "Custom" then
            rage.antiaim:override_hidden_yaw_offset(-current_settings.def_yaw_custom:get())
        elseif def_yaw == "Jitter" then

            local angle1 = current_settings.def_yaw_jitter_angle1:get()
            local angle2 = current_settings.def_yaw_jitter_angle2:get()
            local jitter_speed = current_settings.def_yaw_jitter_speed:get()
            local jitter_state
            if jitter_speed == 0 then
                jitter_state = def_charge_state.last_triggered
            else
                jitter_state = math.floor(globals.tickcount / jitter_speed) % 2 == 0
            end
            local yaw_value = jitter_state and angle1 or angle2
            rage.antiaim:override_hidden_yaw_offset(-yaw_value)
        elseif def_yaw == "Random" then

            local angle1 = current_settings.def_yaw_random_angle1:get()
            local angle2 = current_settings.def_yaw_random_angle2:get()
            local min_angle = math.min(angle1, angle2)
            local max_angle = math.max(angle1, angle2)
            local random_angle = math.random(min_angle, max_angle)
            rage.antiaim:override_hidden_yaw_offset(-random_angle)
        elseif def_yaw == "M-ways" then

            local ways_count = current_settings.def_yaw_mways_count:get()
            local ways_speed = current_settings.def_yaw_mways_speed:get()
            

            if ways_speed == 0 then
                if def_charge_state.last_triggered then
                    def_cycle_state.yaw_mways_index = (def_cycle_state.yaw_mways_index % ways_count) + 1
                end
            else
                def_cycle_state.yaw_mways_tick = def_cycle_state.yaw_mways_tick + 1
                if def_cycle_state.yaw_mways_tick >= ways_speed then
                    def_cycle_state.yaw_mways_index = (def_cycle_state.yaw_mways_index % ways_count) + 1
                    def_cycle_state.yaw_mways_tick = 0
                end
            end
            
            local yaw_value = current_settings.def_yaw_mways[def_cycle_state.yaw_mways_index]:get()
            rage.antiaim:override_hidden_yaw_offset(-yaw_value)
        elseif def_yaw == "Flick" then
            local base_angle = current_settings.def_yaw_flick_angle:get()
            local flick_ticks = current_settings.def_yaw_flick_ticks:get()
            
            local local_player = entity.get_local_player()
            local current_tb = local_player.m_nTickBase
            
            table.insert(flick_tb_history, current_tb)
            if #flick_tb_history > 3 then
                table.remove(flick_tb_history, 1)
            end
            
            local tb_jump = false
            if #flick_tb_history >= 2 then
                local delta = flick_tb_history[#flick_tb_history - 1] - current_tb
                if delta > 8 then
                    tb_jump = true
                    flick_active_duration = delta
                    flick_start_time = globals.tickcount
                end
            end
            
            local yaw_value = base_angle
            local elapsed = globals.tickcount - flick_start_time
            local remaining = flick_active_duration - elapsed
            
            if flick_active_duration > 0 and remaining >= 1 and remaining <= flick_ticks then
                yaw_value = base_angle + 180
            end
            
            if remaining < 0 then
                flick_active_duration = 0
            end
            
            rage.antiaim:override_hidden_yaw_offset(-yaw_value)
        elseif def_yaw == "Spin" then
            local spin_angle = current_settings.def_yaw_spin_angle:get()
            local spin_speed = current_settings.def_yaw_spin_speed:get()
            local ss = spin_sway_state
            
            local actual_angle = math.abs(spin_angle) * 2
            ss.def_spin_value = ss.def_spin_value + spin_speed * 1.5
            if ss.def_spin_value >= actual_angle then
                ss.def_spin_value = 0
            end
            
            local final_spin = ss.def_spin_value * (spin_angle >= 0 and -1 or 1)
            rage.antiaim:override_hidden_yaw_offset(final_spin)
        elseif def_yaw == "M-Spin" then
            local spin_count = current_settings.def_yaw_mspin_count:get()
            local spin_speed = current_settings.def_yaw_mspin_speed:get()
            local spin_angle = current_settings.def_yaw_mspin[def_cycle_state.yaw_mspin_index]:get()
            local ss = spin_sway_state
            
            local actual_angle = math.abs(spin_angle) * 2
            ss.def_mspin_value = ss.def_mspin_value + spin_speed * 1.5
            if ss.def_mspin_value >= actual_angle then
                ss.def_mspin_value = 0
                def_cycle_state.yaw_mspin_index = (def_cycle_state.yaw_mspin_index % spin_count) + 1
            end
            
            local final_spin = ss.def_mspin_value * (spin_angle >= 0 and -1 or 1)
            rage.antiaim:override_hidden_yaw_offset(final_spin)
        elseif def_yaw == "Sway" then
            local sway_speed = current_settings.def_yaw_sway_speed:get()
            local ss = spin_sway_state
            
            ss.def_sway_value = ss.def_sway_value + sway_speed * 1.5 * ss.def_sway_dir
            if ss.def_sway_value >= 360 then
                ss.def_sway_value = 360
                ss.def_sway_dir = -1
            elseif ss.def_sway_value <= 0 then
                ss.def_sway_value = 0
                ss.def_sway_dir = 1
            end
            
            rage.antiaim:override_hidden_yaw_offset(ss.def_sway_value)
        elseif def_yaw == "Random Jitter" then
            local base1 = current_settings.def_yaw_rj_angle1:get()
            local base2 = current_settings.def_yaw_rj_angle2:get()
            local delay = current_settings.def_yaw_rj_delay:get()
            local range1 = current_settings.def_yaw_rj_range1:get()
            local range2 = current_settings.def_yaw_rj_range2:get()

            local jitter = def_yaw_jitter_state
            jitter.rj_tick = jitter.rj_tick + 1
            if jitter.rj_tick >= delay then
                jitter.rj_side = not jitter.rj_side
                jitter.rj_tick = 0
            end

            local base_angle = jitter.rj_side and base1 or base2
            local min_range = math.min(range1, range2)
            local max_range = math.max(range1, range2)
            local noise = math.random(min_range, max_range)
            local final_yaw = base_angle + noise
            rage.antiaim:override_hidden_yaw_offset(-final_yaw)
        elseif def_yaw == "Spin Jitter" then
            local base1 = current_settings.def_yaw_sj_angle1:get()
            local base2 = current_settings.def_yaw_sj_angle2:get()
            local delay = current_settings.def_yaw_sj_delay:get()
            local spin_range = current_settings.def_yaw_sj_spin_angle:get()
            local spin_rate = current_settings.def_yaw_sj_spin_speed:get()

            local jitter = def_yaw_jitter_state
            jitter.sj_tick = jitter.sj_tick + 1
            if jitter.sj_tick >= delay then
                jitter.sj_side = not jitter.sj_side
                jitter.sj_tick = 0
            end

            local base_angle = jitter.sj_side and base1 or base2
            local ss = spin_sway_state
            
            local actual_range = math.abs(spin_range) * 2
            ss.def_sj_spin_value = ss.def_sj_spin_value + spin_rate * 1.5
            if ss.def_sj_spin_value >= actual_range then
                ss.def_sj_spin_value = 0
            end
            
            local spin_offset = ss.def_sj_spin_value * (spin_range >= 0 and -1 or 1)
            local final_yaw = base_angle + spin_offset
            rage.antiaim:override_hidden_yaw_offset(-final_yaw)
        elseif def_yaw == "Sway Jitter" then
            local base1 = current_settings.def_yaw_swj_angle1:get()
            local base2 = current_settings.def_yaw_swj_angle2:get()
            local delay = current_settings.def_yaw_swj_delay:get()

            local jitter = def_yaw_jitter_state
            jitter.swj_tick = jitter.swj_tick + 1
            if jitter.swj_tick >= delay then
                jitter.swj_side = not jitter.swj_side
                jitter.swj_tick = 0
            end

            local base_angle = jitter.swj_side and base1 or base2
            local sway_speed = current_settings.def_yaw_swj_sway_speed:get()
            local ss = spin_sway_state
            
            ss.def_swj_sway_value = ss.def_swj_sway_value + sway_speed * 1.5 * ss.def_swj_sway_dir
            if ss.def_swj_sway_value >= 360 then
                ss.def_swj_sway_value = 360
                ss.def_swj_sway_dir = -1
            elseif ss.def_swj_sway_value <= 0 then
                ss.def_swj_sway_value = 0
                ss.def_swj_sway_dir = 1
            end
            
            local final_yaw = base_angle + ss.def_swj_sway_value
            rage.antiaim:override_hidden_yaw_offset(-final_yaw)
        elseif def_yaw == "Random Flick" then
            local angle1 = current_settings.def_yaw_rf_angle1:get()
            local angle2 = current_settings.def_yaw_rf_angle2:get()
            local flick_angle = current_settings.def_yaw_rf_flick_angle:get()
            local flick_ticks = current_settings.def_yaw_rf_flick_ticks:get()
            

            local min_angle = math.min(angle1, angle2)
            local max_angle = math.max(angle1, angle2)
            local base_yaw = math.random(min_angle, max_angle)
            

            local final_yaw = base_yaw
            local local_player = entity.get_local_player()
            local current_tb = local_player.m_nTickBase
            
            table.insert(flick_tb_history, current_tb)
            if #flick_tb_history > 3 then
                table.remove(flick_tb_history, 1)
            end
            
            if #flick_tb_history >= 2 then
                local delta = flick_tb_history[#flick_tb_history - 1] - current_tb
                if delta > 8 then
                    flick_active_duration = delta
                    flick_start_time = globals.tickcount
                end
            end
            
            local elapsed = globals.tickcount - flick_start_time
            local remaining = flick_active_duration - elapsed
            
            if flick_active_duration > 0 and remaining >= 1 and remaining <= flick_ticks then
                final_yaw = base_yaw + flick_angle + 180
            end
            
            if remaining < 0 then
                flick_active_duration = 0
            end
            
            rage.antiaim:override_hidden_yaw_offset(-final_yaw)
        elseif def_yaw == "Spin Flick" then
            local spin_angle = current_settings.def_yaw_sf_spin_angle:get()
            local spin_speed = current_settings.def_yaw_sf_spin_speed:get()
            local flick_angle = current_settings.def_yaw_sf_flick_angle:get()
            local flick_ticks = current_settings.def_yaw_sf_flick_ticks:get()
            

            local ss = spin_sway_state
            
            local actual_angle = math.abs(spin_angle) * 2
            ss.def_sf_spin_value = ss.def_sf_spin_value + spin_speed * 1.5
            if ss.def_sf_spin_value >= actual_angle then
                ss.def_sf_spin_value = 0
            end
            
            local base_yaw = ss.def_sf_spin_value * (spin_angle >= 0 and -1 or 1)
            local final_yaw = base_yaw
            local local_player = entity.get_local_player()
            local current_tb = local_player.m_nTickBase
            
            table.insert(flick_tb_history, current_tb)
            if #flick_tb_history > 3 then
                table.remove(flick_tb_history, 1)
            end
            
            if #flick_tb_history >= 2 then
                local delta = flick_tb_history[#flick_tb_history - 1] - current_tb
                if delta > 8 then
                    flick_active_duration = delta
                    flick_start_time = globals.tickcount
                end
            end
            
            local elapsed = globals.tickcount - flick_start_time
            local remaining = flick_active_duration - elapsed
            
            if flick_active_duration > 0 and remaining >= 1 and remaining <= flick_ticks then
                final_yaw = base_yaw + flick_angle + 180
            end
            
            if remaining < 0 then
                flick_active_duration = 0
            end
            
            rage.antiaim:override_hidden_yaw_offset(final_yaw)
        elseif def_yaw == "Sway Flick" then
            local sway_speed = current_settings.def_yaw_swf_sway_speed:get()
            local flick_angle = current_settings.def_yaw_swf_flick_angle:get()
            local flick_ticks = current_settings.def_yaw_swf_flick_ticks:get()
            

            local ss = spin_sway_state
            
            ss.def_swf_sway_value = ss.def_swf_sway_value + sway_speed * 1.5 * ss.def_swf_sway_dir
            if ss.def_swf_sway_value >= 360 then
                ss.def_swf_sway_value = 360
                ss.def_swf_sway_dir = -1
            elseif ss.def_swf_sway_value <= 0 then
                ss.def_swf_sway_value = 0
                ss.def_swf_sway_dir = 1
            end
            
            local base_yaw = ss.def_swf_sway_value
            local final_yaw = base_yaw
            local local_player = entity.get_local_player()
            local current_tb = local_player.m_nTickBase
            
            table.insert(flick_tb_history, current_tb)
            if #flick_tb_history > 3 then
                table.remove(flick_tb_history, 1)
            end
            
            if #flick_tb_history >= 2 then
                local delta = flick_tb_history[#flick_tb_history - 1] - current_tb
                if delta > 8 then
                    flick_active_duration = delta
                    flick_start_time = globals.tickcount
                end
            end
            
            local elapsed = globals.tickcount - flick_start_time
            local remaining = flick_active_duration - elapsed
            
            if flick_active_duration > 0 and remaining >= 1 and remaining <= flick_ticks then
                final_yaw = base_yaw + flick_angle + 180
            end
            
            if remaining < 0 then
                flick_active_duration = 0
            end
            
            rage.antiaim:override_hidden_yaw_offset(final_yaw)
        end

        if not def_enabled or (use_manual and ui_antiaim_main.manual_e_spam:get()) then
            flick_tb_history = {}
            flick_active_duration = 0
            def_cycle_state.yaw_mspin_start_time = nil

            def_force_state.mways_tick = 0
            def_force_state.repeat_counter = 0
            def_force_state.shuffle_order = {}
            def_force_state.shuffle_index = 1
            def_force_state.delay_counter = 0
            def_force_state.delay_last_time = 0
            def_force_state.gs_active_ticks = 0
            def_force_state.gs_was_in_def = false

            e_spam_force_state.mways_tick = 0
            e_spam_force_state.repeat_counter = 0
            e_spam_force_state.shuffle_order = {}
            e_spam_force_state.shuffle_index = 1
            e_spam_force_state.delay_counter = 0
            e_spam_force_state.delay_last_time = 0
            e_spam_force_state.gs_active_ticks = 0
            e_spam_force_state.gs_was_in_def = false
        end
    end
    

    if ui_antiaim_main.auto_hideshot:get() then
        local lp = entity.get_local_player()
        if lp and lp:is_alive() then
            if not ui_refs.doubletap or not ui_refs.doubletap:get() then
                if ui_refs.doubletap then ui_refs.doubletap:override() end
                if ui_refs.onshot then ui_refs.onshot:override() end
            else
                -- Fake Duck开启时跳过
                if ui_refs.fd and ui_refs.fd:get() then
                    ui_refs.doubletap:override()
                    if ui_refs.onshot then ui_refs.onshot:override() end
                else
                local current_state_id = get_current_state()
                local should_enable_hs = false
                
                -- 状态映射: state_id -> selectable选项名
                local state_map = {
                    [2] = "Standing",
                    [3] = "Moving",
                    [4] = "Slow Walk",
                    [5] = "Crouching",
                    [6] = "Moving Crouch",
                    [7] = "Air",
                    [8] = "Air Crouch"
                }
                
                local state_name = state_map[current_state_id]
                if state_name and ui_antiaim_main.auto_hideshot_states:get(state_name) then
                    should_enable_hs = true
                end
                
                if should_enable_hs then
                    ui_refs.doubletap:override(false)
                    if ui_refs.onshot then ui_refs.onshot:override(true) end
                else
                    ui_refs.doubletap:override()
                    if ui_refs.onshot then ui_refs.onshot:override() end
                end
                end
            end
        end
    end
    
    -- Rapid Displacement Recovery Protocol
    do
        local displacement_toggle_state = ui_antiaim_main.quick_peek:get()
        local primary_controller = entity.get_local_player()
        local displacement_activation_flag = (displacement_toggle_state and 1 or 0)
        
        if (displacement_activation_flag > 0) and primary_controller and primary_controller:is_alive() then
            local equipped_armament = primary_controller:get_player_weapon()
            local locomotion_identifier = get_current_state()
            local mobility_state_alpha = math.floor(2.7 + 0.3)
            local mobility_state_beta = math.floor(5.8 + 0.2)
            local entity_displacement_active = (locomotion_identifier == mobility_state_alpha) or (locomotion_identifier == mobility_state_beta)
            local surface_contact_verified = not aa_state.is_in_air
            local surface_contact_coefficient = surface_contact_verified and 1 or 0
            
            if equipped_armament then
                local armament_classification = equipped_armament:get_classname()
                local precision_rifle_identifier = "CWeapon" .. "SSG" .. "0" .. tostring(math.floor(7.9 + 0.1))
                local armament_match_coefficient = (armament_classification == precision_rifle_identifier) and 1 or 0
                
                if (armament_match_coefficient > 0) and (armament_match_coefficient == math.ceil(0.4)) then
                    local discharge_timestamp = equipped_armament["m_fLastShotTime"]
                    local temporal_differential = globals.curtime - (discharge_timestamp or math.max(0, math.min(0, 1)))
                    local tick_conversion_quotient = temporal_differential / globals.tickinterval
                    local discrete_tick_window = math.floor(tick_conversion_quotient)
                    
                    local peek_module_reference = aa_refs.aa_peek_assist
                    local peek_module_active = peek_module_reference and peek_module_reference:get()
                    local peek_activation_coefficient = peek_module_active and 1 or 0
                    
                    local tickbase_module_reference = aa_refs.aa_doubletap
                    local tickbase_module_active = tickbase_module_reference and tickbase_module_reference:get()
                    local tickbase_activation_coefficient = tickbase_module_active and 1 or 0
                    
                    local exploit_charge_state = rage.exploit:get()
                    local exploit_readiness_coefficient = (exploit_charge_state == math.ceil(0.4)) and 1 or 0
                    
                    local defensive_tickbase_threshold = math.floor(9.6 + 0.4)
                    local defensive_module_ref = antiaim.defensive
                    local defensive_state_value = defensive_module_ref and defensive_module_ref.tickbase or math.max(0, math.min(0, 1))
                    local defensive_compliance_coefficient = (defensive_state_value <= defensive_tickbase_threshold) and 1 or 0
                    
                    local tick_window_upper_bound = math.floor(3.9 + 0.1)
                    local tick_window_lower_bound = math.max(0, math.min(0, 1))
                    local temporal_window_compliance = (discrete_tick_window <= tick_window_upper_bound) and (discrete_tick_window >= tick_window_lower_bound)
                    local temporal_compliance_coefficient = temporal_window_compliance and 1 or 0
                    
                    local aggregate_compliance_sum = peek_activation_coefficient + tickbase_activation_coefficient + exploit_readiness_coefficient + defensive_compliance_coefficient + temporal_compliance_coefficient + surface_contact_coefficient
                    local required_compliance_threshold = math.floor(5.7 + 0.3)
                    local full_compliance_verified = (aggregate_compliance_sum >= required_compliance_threshold) and entity_displacement_active
                    
                    if full_compliance_verified then
                        local tertiary_slot_command = "slot" .. tostring(math.floor(2.9 + 0.1))
                        local primary_slot_command = "slot" .. tostring(math.ceil(0.6))
                        local scope_engage_command = "+" .. "attack" .. tostring(math.floor(1.8 + 0.2))
                        local scope_disengage_command = "-" .. "attack" .. tostring(math.floor(1.8 + 0.2))
                        
                        local initial_switch_delay = 0.015 * 2
                        local scope_duration_interval = 0.675 * 2
                        
                        utils.console_exec(tertiary_slot_command)
                        utils.execute_after(initial_switch_delay, function()
                            utils.console_exec(primary_slot_command)
                            utils.console_exec(scope_engage_command)
                            utils.execute_after(scope_duration_interval, function()
                                utils.console_exec(scope_disengage_command)
                            end)
                        end)
                    end
                end
            end
        end
    end
    
    -- Advanced Atmospheric Network Manipulation Protocol
    local primary_entity = entity.get_local_player()
    local system_toggle_state = ui_antiaim_main.air_lag:get()
    local displacement_eligibility = validate_atmospheric_displacement_eligibility(primary_entity, system_toggle_state)

    local engagement_coefficient = displacement_eligibility and 1 or 0
    if (engagement_coefficient > 0) and (math.abs(engagement_coefficient) == 1) then
        network_timing_processor.activation_state_flag = true
        
        local fakelag_ceiling = math.floor(16.5 + 0.5)
        local variance_floor = math.max(0, math.min(0, 1))
        local peek_mode_string = "On" .. " " .. "Peek"
        
        aa_refs.aa_fakelag_limit:override(fakelag_ceiling)
        aa_refs.aa_fakelag_var:override(variance_floor)
        aa_refs.aa_dt_options:override(peek_mode_string)
        
        local base_interval = ui_antiaim_main.air_lag_ticks:get()
        local interval_lower_bound = math.max(1, 1)
        local validated_interval = (base_interval < interval_lower_bound) and interval_lower_bound or base_interval
        
        local current_temporal_unit = globals.tickcount
        local divisor_component = validated_interval
        local quotient_result = math.floor(current_temporal_unit / divisor_component)
        local remainder_component = current_temporal_unit - (quotient_result * divisor_component)
        local synchronization_trigger = (remainder_component == 0) and 1 or 0
        
        if (synchronization_trigger > 0) and (synchronization_trigger == 1) then
            local primary_rate_value = math.floor(15.7 + 0.3)
            network_timing_processor.command_rate_controller:int(primary_rate_value)
            network_timing_processor.iteration_accumulator = network_timing_processor.iteration_accumulator + math.ceil(0.9)
            aa_refs.aa_fakeduck:override(true)
        end
        
        local threshold_boundary = math.floor(2.1 + 0.9) - 1
        local threshold_exceeded = (network_timing_processor.iteration_accumulator > threshold_boundary) and 1 or 0
        
        if (threshold_exceeded == 1) and (threshold_exceeded > 0) then
            local secondary_rate_value = math.ceil(18.9)
            network_timing_processor.command_rate_controller:int(secondary_rate_value)
            network_timing_processor.iteration_accumulator = math.max(1, math.min(1, 2))
            aa_refs.aa_fakeduck:override()
        end
    else
        terminate_network_manipulation_subsystem()
    end
    

    local disable_fl_options = ui_antiaim_main.disabled_fakelag:get()
    local should_disable_fl = false
    
    for _, option in ipairs(disable_fl_options) do
        if option == "Double Tap" then
            if ui_refs.dt and ui_refs.dt:get() then
                should_disable_fl = true
                break
            end
        elseif option == "Hide Shots" then
            if ui_refs.os and ui_refs.os:get() then
                should_disable_fl = true
                break
            end
        end
    end
    
    if should_disable_fl then
        aa_refs.aa_fakelag:override(false)
    else
        aa_refs.aa_fakelag:override()
    end
    

    

    local current_tickbase = lp.m_nTickBase
    local charge = def_charge_state
    if current_tickbase > charge.last_tickbase then
        charge.last_tickbase = current_tickbase
    end
    
    local diff = charge.last_tickbase - current_tickbase
    if diff > 7 then
        charge.lc = math.min(14, math.max(0, diff - 1))
    else
        if charge.lc > 0 then
            charge.lc = charge.lc - 1
        end
    end
    

    if ui_visuals.fast_ladder:get() and lp and lp:is_alive() then
        if lp.m_MoveType == 9 then

            local speed_map = {[true] = 450, [false] = -450}
            cmd.forwardmove = cmd.forwardmove ~= 0 and speed_map[cmd.forwardmove > 0] or 0
            

            local state_key = string.format("%d_%d_%d", 
                cmd.sidemove == 0 and 0 or (cmd.sidemove < 0 and 1 or 2),
                cmd.in_forward and 1 or 0,
                cmd.in_back and 1 or 0
            )
            

            local yaw_map = {
                ["0_0_0"] = 45, ["0_1_0"] = 45, ["0_0_1"] = 45,
                ["1_1_0"] = 90, ["1_0_1"] = 45, ["1_0_0"] = 45,
                ["2_0_1"] = 90, ["2_1_0"] = 45, ["2_0_0"] = 45
            }
            cmd.view_angles.y = cmd.view_angles.y + (yaw_map[state_key] or 45)
            

            cmd.in_moveright, cmd.in_moveleft = cmd.in_forward, cmd.in_back
            

            cmd.view_angles.x = cmd.view_angles.x < 0 and -45 or cmd.view_angles.x
        end
    end
    
    -- Air Lag Resolver (ESP Flag Only - Actual resolver handled by Neverlose)
    
    -- Friend Fire Logic
    if ui_visuals.friend_fire:get() then
        cvar.mp_teammates_are_enemies:int(1)
    else
        cvar.mp_teammates_are_enemies:int(0)
    end
end)

-- Rage Tab
ui_visuals.air_lag_resolver = visuals_ui.rage:switch("\aB6B665FF\f<chart-line-up> \aDEFAULTResolver")
ui_visuals.air_lag_resolver:disabled(not is_dev)

local resolver_gear = ui_visuals.air_lag_resolver:create()
ui_visuals.resolver_distance = resolver_gear:slider("Enemy Distance", 1, 100, 25, 1):depend(ui_visuals.air_lag_resolver)

ui_visuals.air_stop = visuals_ui.rage:switch("\a8AECF1FF\f<parachute-box> \aDEFAULTAir Stop")
local air_stop_gear = ui_visuals.air_stop:create()
ui_visuals.air_stop_shift = air_stop_gear:switch("Shift"):depend(ui_visuals.air_stop)
ui_visuals.air_stop_dist_enable = air_stop_gear:switch("Enemy Distance"):depend(ui_visuals.air_stop)
ui_visuals.air_stop_distance = air_stop_gear:slider("Distance", 1, 100, 25, 1):depend(ui_visuals.air_stop, ui_visuals.air_stop_dist_enable)

ui_visuals.slowwalk_speed = visuals_ui.rage:switch("\a69B83FFF\f<person-walking> \aDEFAULTSlowwalk Speed")
local slowwalk_speed_gear = ui_visuals.slowwalk_speed:create()
ui_visuals.slowwalk_speed_value = slowwalk_speed_gear:slider("Speed", 1, 100, 100, 1, "%"):depend(ui_visuals.slowwalk_speed)

ui_visuals.friend_fire = visuals_ui.rage:switch("\aFF6B6BFF\f<crosshairs> \aDEFAULTFriend Fire")
ui_visuals.friend_fire:tooltip("Force teammates as enemies for aimbot targeting")


-- Misc Tab
ui_visuals.emptiness_detection = visuals_ui.misc:switch("\f<signal> Emptiness Detection")
ui_visuals.emptiness_detection:tooltip("Detect other Emptiness users in game, does not work on servers that block voice packets")
ui_visuals.emptiness_detection:disabled(not is_dev)

ui_visuals.watermark = visuals_ui.misc:switch("\f<badge-check> Watermark")
ui_visuals.watermark:tooltip("Display watermark from \vNeverlose v2\a" .. pui.get_style("Text Preview"):to_hex() .. " . Not a 1:1 implementation")
local watermark_gear = ui_visuals.watermark:create()
ui_visuals.watermark_glow = watermark_gear:switch("Glow"):depend(ui_visuals.watermark)
ui_visuals.watermark_glow_color = watermark_gear:color_picker("Glow Color", color(255, 255, 255, 120)):depend(ui_visuals.watermark, ui_visuals.watermark_glow)
ui_visuals.watermark_blur = watermark_gear:switch("Blur"):depend(ui_visuals.watermark)
ui_visuals.watermark_blur_strength = watermark_gear:slider("Blur Strength", 0, 10, 3):depend(ui_visuals.watermark, ui_visuals.watermark_blur)
ui_visuals.watermark_blur_alpha = watermark_gear:slider("Blur Opacity", 0, 255, 255):depend(ui_visuals.watermark, ui_visuals.watermark_blur)

ui_visuals.keybinds = visuals_ui.misc:switch("\f<keyboard> Keybinds")
ui_visuals.keybinds:tooltip("Display active keybinds from \vNeverlose v2\a" .. pui.get_style("Text Preview"):to_hex() .. " . Not a 1:1 implementation")
local keybinds_gear = ui_visuals.keybinds:create()
ui_visuals.keybinds_glow = keybinds_gear:switch("Glow"):depend(ui_visuals.keybinds)
ui_visuals.keybinds_glow_color = keybinds_gear:color_picker("Glow Color", color(255, 255, 255, 120)):depend(ui_visuals.keybinds, ui_visuals.keybinds_glow)
ui_visuals.keybinds_blur = keybinds_gear:switch("Blur"):depend(ui_visuals.keybinds)
ui_visuals.keybinds_blur_strength = keybinds_gear:slider("Blur Strength", 0, 10, 3):depend(ui_visuals.keybinds, ui_visuals.keybinds_blur)
ui_visuals.keybinds_blur_alpha = keybinds_gear:slider("Blur Opacity", 0, 255, 255):depend(ui_visuals.keybinds, ui_visuals.keybinds_blur)

ui_visuals.spectators = visuals_ui.misc:switch("\f<users> Spectators")
ui_visuals.spectators:tooltip("Display players spectating you from \vNeverlose v2\a" .. pui.get_style("Text Preview"):to_hex() .. " . Not a 1:1 implementation")
local spectators_gear = ui_visuals.spectators:create()
ui_visuals.spectators_glow = spectators_gear:switch("Glow"):depend(ui_visuals.spectators)
ui_visuals.spectators_glow_color = spectators_gear:color_picker("Glow Color", color(255, 255, 255, 120)):depend(ui_visuals.spectators, ui_visuals.spectators_glow)
ui_visuals.spectators_blur = spectators_gear:switch("Blur"):depend(ui_visuals.spectators)
ui_visuals.spectators_blur_strength = spectators_gear:slider("Blur Strength", 0, 10, 3):depend(ui_visuals.spectators, ui_visuals.spectators_blur)
ui_visuals.spectators_blur_alpha = spectators_gear:slider("Blur Opacity", 0, 255, 255):depend(ui_visuals.spectators, ui_visuals.spectators_blur)

ui_visuals.fast_ladder = visuals_ui.misc:switch("\f<water-ladder> Fast Ladder")
ui_visuals.animation_system = visuals_ui.misc:switch("\f<person-running> Animation Breakers")
local anim_gear = ui_visuals.animation_system:create()
ui_visuals.ground_animation = anim_gear:combo("Legs on Ground", {"Disabled", "Static", "Walking", "Jitter"}):depend(ui_visuals.animation_system)
ui_visuals.air_animation = anim_gear:combo("Legs in Air", {"Disabled", "Static", "Walking"}):depend(ui_visuals.animation_system)
ui_visuals.animation_effects = anim_gear:selectable("Other", {"Pitch 0 on Land", "Earthquake", "Body Wave", "Freeze Leg", "Lean", "Moon Walk", "Goofy", "Static Pose"}):depend(ui_visuals.animation_system)
ui_visuals.static_pose_11 = anim_gear:slider("Yaw", 0, 100, 0, 0.1):depend(ui_visuals.animation_system)
ui_visuals.static_pose_12 = anim_gear:slider("Pitch", 0, 100, 0.5, 0.1):depend(ui_visuals.animation_system)

-- Animation滑块动态可见性
local function update_anim_sliders_visibility()
    local anim_enabled = ui_visuals.animation_system:get()
    local effects = ui_visuals.animation_effects:get()
    local has_static_pose = false
    if anim_enabled then
        for _, v in ipairs(effects) do
            if v == "Static Pose" then
                has_static_pose = true
                break
            end
        end
    end
    ui_visuals.static_pose_11:visibility(has_static_pose)
    ui_visuals.static_pose_12:visibility(has_static_pose)
end

ui_visuals.dynamic_island = visuals_ui.misc:switch("\f<chart-line> Dynamic Island")
ui_visuals.fake_latency = visuals_ui.misc:switch("\f<clock> Fake Latency")
local latency_gear = ui_visuals.fake_latency:create()
ui_visuals.latency_amount = latency_gear:slider("Amount", 0, 200, 100, 1, "ms"):depend(ui_visuals.fake_latency)


ui_visuals.kill_say = visuals_ui.other:switch("\f<message-dots> Kill Say")
ui_visuals.mystery_killmarks = visuals_ui.other:switch("\f<ghost> Kill Effects")
local mk_gear = ui_visuals.mystery_killmarks:create()
ui_visuals.mystery_killmarks_hit = mk_gear:switch("On Kill"):depend(ui_visuals.mystery_killmarks)
ui_visuals.mystery_killmarks_miss = mk_gear:switch("On Miss"):depend(ui_visuals.mystery_killmarks)
ui_visuals.mystery_killmarks_death = mk_gear:switch("On Death"):depend(ui_visuals.mystery_killmarks)
ui_visuals.mystery_killmarks_volume = mk_gear:slider("MK Volume", 0, 100, 100, 1):depend(ui_visuals.mystery_killmarks)

ui_visuals.easter_egg = visuals_ui.other:switch("\f<gift> Easter Egg")

ui_visuals.ragdoll_launcher = visuals_ui.other:switch("\f<wind> Ragdoll Launcher")
local ragdoll_gear = ui_visuals.ragdoll_launcher:create()
ui_visuals.ragdoll_mult = ragdoll_gear:slider("Multiplier", 0, 250, 0, 1, "x"):depend(ui_visuals.ragdoll_launcher)
ui_visuals.ragdoll_vertical = ragdoll_gear:slider("Vertical Power", 0, 100, 50, 1, "%"):depend(ui_visuals.ragdoll_launcher)

ui_visuals.aimbot_logging = visuals_ui.other:switch("\f<bullseye> Aimbot Logging")
local log_gear = ui_visuals.aimbot_logging:create()
ui_visuals.log_display = log_gear:selectable("Display", {"Console", "Screen", "Chat"}):depend(ui_visuals.aimbot_logging)
ui_visuals.log_gamesense = log_gear:switch("Gamesense Style"):depend(ui_visuals.aimbot_logging)
ui_visuals.log_neverlose = log_gear:switch("Neverlose v2 Style"):depend(ui_visuals.aimbot_logging)

-- Aimbot Logging 样式互斥逻辑
ui_visuals.log_gamesense:set_callback(function(self)
    if self:get() then
        ui_visuals.log_neverlose:disabled(true)
        ui_visuals.log_neverlose:set(false)
    else
        ui_visuals.log_neverlose:disabled(false)
    end
end, true)

ui_visuals.log_neverlose:set_callback(function(self)
    if self:get() then
        ui_visuals.log_gamesense:disabled(true)
        ui_visuals.log_gamesense:set(false)
    else
        ui_visuals.log_gamesense:disabled(false)
    end
end, true)

ui_visuals.log_hit_color = log_gear:color_picker("Hit Color", color(165, 220, 15, 255)):depend(ui_visuals.aimbot_logging)
ui_visuals.log_miss_color = log_gear:color_picker("Miss Color", color(255, 107, 107, 255)):depend(ui_visuals.aimbot_logging)
ui_visuals.log_border_color = log_gear:color_picker("Border Color", color(255, 255, 255, 255)):depend(ui_visuals.aimbot_logging, {ui_visuals.log_display, "Screen"})

ui_visuals.clan_tag = visuals_ui.other:switch("\f<tag> Clan Tag")
local clantag_gear = ui_visuals.clan_tag:create()
ui_visuals.clantag_mode = clantag_gear:combo("Mode", {"Emptiness", "Scroll"}):depend(ui_visuals.clan_tag)
ui_visuals.fake_name = clantag_gear:switch("Fake Name"):depend(ui_visuals.clan_tag)
ui_visuals.client_nickname = visuals_ui.other:switch("\f<signature> Client Nickname")
local nick_gear = ui_visuals.client_nickname:create()
ui_visuals.nickname_text = nick_gear:input("Nickname", ""):depend(ui_visuals.client_nickname)


ui_visuals.mystery_indicator = visuals_ui.view:switch("\f<eye> Center Indicators")
local mystery_gear = ui_visuals.mystery_indicator:create()
ui_visuals.center_indicator_mode = mystery_gear:combo("Mode", {"Crimson", "lura.blue", "Half-life"}):depend(ui_visuals.mystery_indicator)
ui_visuals.crimson_style = mystery_gear:combo("Style", {"Default", "Simple"}):depend(ui_visuals.mystery_indicator, {ui_visuals.center_indicator_mode, "Crimson"})
ui_visuals.lura_build_mode = mystery_gear:switch("Debug Build"):depend(ui_visuals.mystery_indicator, {ui_visuals.center_indicator_mode, "lura.blue"})

-- Half-life 选项
ui_visuals.halflife_display = mystery_gear:selectable("Display", {"Under Crosshair", "Watermark"}):depend(ui_visuals.mystery_indicator, {ui_visuals.center_indicator_mode, "Half-life"})

ui_visuals.damage_indicator = visuals_ui.view:switch("\f<heart-crack> Damage Indicator")
local dmg_gear = ui_visuals.damage_indicator:create()
ui_visuals.dmg_font = dmg_gear:combo("Font", {"Font 1", "Font 2", "Font 3", "Font 4"}):depend(ui_visuals.damage_indicator)
ui_visuals.dmg_color = dmg_gear:color_picker("Color", color(255, 255, 255, 255)):depend(ui_visuals.damage_indicator)

ui_visuals.oof_arrows = visuals_ui.view:switch("\f<location-arrow> Offscreen Arrows")
local oof_gear = ui_visuals.oof_arrows:create()
ui_visuals.oof_arrows_color = oof_gear:color_picker("Color", color(100, 200, 255, 255)):depend(ui_visuals.oof_arrows)
ui_visuals.oof_arrows_radius = oof_gear:slider("Radius", 5, 95, 40, 1, "%"):depend(ui_visuals.oof_arrows)
ui_visuals.oof_arrows_style = oof_gear:combo("Style", {"Snowflake", "Curved Line"}):depend(ui_visuals.oof_arrows)
ui_visuals.oof_arrows_pulse = oof_gear:switch("Arrow Pulse"):depend(ui_visuals.oof_arrows)
ui_visuals.oof_arrows_show_dormant = oof_gear:switch("Show Dormant"):depend(ui_visuals.oof_arrows)
ui_visuals.oof_arrows_snowflake_shadow_opacity = oof_gear:slider("Snowflake Shadow Opacity", 0, 100, 40, 1, "%")
    :depend(ui_visuals.oof_arrows, {ui_visuals.oof_arrows_style, "Snowflake"})
ui_visuals.oof_arrows_curved_size = oof_gear:slider("Curved Line Size", 50, 200, 100, 1, "%")
    :depend(ui_visuals.oof_arrows, {ui_visuals.oof_arrows_style, "Curved Line"})
ui_visuals.oof_arrows_curved_shadow_opacity = oof_gear:slider("Curved Line Shadow Opacity", 0, 100, 40, 1, "%")
    :depend(ui_visuals.oof_arrows, {ui_visuals.oof_arrows_style, "Curved Line"})

ui_visuals.defensive_indicator = visuals_ui.view:switch("\f<shield-halved> Defensive Indicator")
local def_gear = ui_visuals.defensive_indicator:create()
ui_visuals.def_color = def_gear:color_picker("Color", color(255, 107, 107, 255)):depend(ui_visuals.defensive_indicator)

ui_visuals.slowdown_indicator = visuals_ui.view:switch("\f<person-walking> Slowdown Indicator")
local slow_gear = ui_visuals.slowdown_indicator:create()
ui_visuals.slow_color = slow_gear:color_picker("Color", color(107, 185, 255, 255)):depend(ui_visuals.slowdown_indicator)

ui_visuals.crosshair_circle = visuals_ui.view:switch("\f<crosshairs> Crosshair Circle")
local circle_gear = ui_visuals.crosshair_circle:create()
ui_visuals.circle_bg_color = circle_gear:color_picker("Background Color", color(255, 255, 255, 36)):depend(ui_visuals.crosshair_circle)
ui_visuals.circle_color = circle_gear:color_picker("Indicator Color", color(255, 255, 255, 255)):depend(ui_visuals.crosshair_circle)
ui_visuals.circle_radius = circle_gear:slider("Radius", 5, 50, 20, 1):depend(ui_visuals.crosshair_circle)
ui_visuals.circle_thickness = circle_gear:slider("Thickness", 1, 10, 3, 1):depend(ui_visuals.crosshair_circle)

ui_visuals.hit_marker = visuals_ui.view:switch("\f<bullseye> Hit Location Marker")
ui_visuals.hit_marker:tooltip("1:1 implementation from \vNeverlose\a" .. pui.get_style("Text Preview"):to_hex() .. " Cs2")
local hit_gear = ui_visuals.hit_marker:create()
ui_visuals.hit_color = hit_gear:color_picker("Color", color(255, 255, 255, 255)):depend(ui_visuals.hit_marker)
ui_visuals.hit_crosshair = hit_gear:switch("\f<crosshairs> Show at Crosshair"):depend(ui_visuals.hit_marker)
ui_visuals.hit_size = hit_gear:slider("Size", 5, 50, 15, 1):depend(ui_visuals.hit_marker)
ui_visuals.hit_gap = hit_gear:slider("Gap", 2, 20, 6, 1):depend(ui_visuals.hit_marker)
ui_visuals.hit_duration = hit_gear:slider("Duration", 1, 30, 1.2, 0.1, "s"):depend(ui_visuals.hit_marker)
ui_visuals.hit_shadow_opacity = hit_gear:slider("Shadow Opacity", 10, 100, 50, 1, "%"):depend(ui_visuals.hit_marker)
ui_visuals.hit_shadow_range = hit_gear:slider("Shadow Range", 1, 100, 50, 1, "%"):depend(ui_visuals.hit_marker)

ui_visuals.world_damage = visuals_ui.view:switch("\f<360-degrees> World Hit Marker")
ui_visuals.world_damage:tooltip("1:1 implementation from \vNeverlose v2\a" .. pui.get_style("Text Preview"):to_hex() .. " ")

local world_damage_gear = ui_visuals.world_damage:create()
ui_visuals.world_damage_color = world_damage_gear:color_picker("Color", color(255, 255, 255, 255)):depend(ui_visuals.world_damage)

ui_visuals.thirdperson_zoom = visuals_ui.view:switch("\f<user> Dynamic Thirdperson")
local thirdperson_gear = ui_visuals.thirdperson_zoom:create()
ui_visuals.thirdperson_zoom_speed = thirdperson_gear:slider("Animation Speed", 1, 20, 8, 1):depend(ui_visuals.thirdperson_zoom)

ui_visuals.dynamic_zoom = visuals_ui.view:switch("\f<telescope> Dynamic FOV")
local zoom_gear = ui_visuals.dynamic_zoom:create()
ui_visuals.zoom_boost = zoom_gear:slider("FOV Reduction", 0, 60, 20, 1):depend(ui_visuals.dynamic_zoom)
ui_visuals.zoom_speed = zoom_gear:slider("Animation Speed", 1, 20, 8, 1):depend(ui_visuals.dynamic_zoom)

ui_visuals.scope_lines = visuals_ui.view:switch("\f<crosshairs> Scope Lines")
local scope_gear = ui_visuals.scope_lines:create()
ui_visuals.scope_color = scope_gear:color_picker("Color", color(255, 255, 255, 255)):depend(ui_visuals.scope_lines)
ui_visuals.scope_length = scope_gear:slider("Length", 10, 500, 250, 1):depend(ui_visuals.scope_lines)
ui_visuals.scope_gap = scope_gear:slider("Gap", 5, 200, 80, 1):depend(ui_visuals.scope_lines)
ui_visuals.scope_reverse = scope_gear:switch("\f<repeat> Inverter"):depend(ui_visuals.scope_lines)
ui_visuals.crosshair_in_scope = scope_gear:switch("\f<crosshairs> Show Crosshair"):depend(ui_visuals.scope_lines)
ui_visuals.chaos_mode = scope_gear:switch("\f<skull> Random"):depend(ui_visuals.scope_lines)

ui_visuals.aspect_ratio = visuals_ui.view:switch("\f<expand> Aspect Ratio")
local aspect_gear = ui_visuals.aspect_ratio:create()
ui_visuals.aspect_ratio_value = aspect_gear:slider("Ratio", 50, 300, 133, 0.01):depend(ui_visuals.aspect_ratio)


aspect_gear:button("  4:3  ", function() ui_visuals.aspect_ratio_value:set(133) end, true):depend(ui_visuals.aspect_ratio)
aspect_gear:button("  16:9  ", function() ui_visuals.aspect_ratio_value:set(177) end, true):depend(ui_visuals.aspect_ratio)
aspect_gear:button("  16:10  ", function() ui_visuals.aspect_ratio_value:set(161) end, true):depend(ui_visuals.aspect_ratio)
aspect_gear:button("  5:4  ", function() ui_visuals.aspect_ratio_value:set(125) end, true):depend(ui_visuals.aspect_ratio)

ui_visuals.viewmodel = visuals_ui.view:switch("\f<hand> Viewmodel")
local vm_gear = ui_visuals.viewmodel:create()
ui_visuals.vm_fov = vm_gear:slider("FOV", -100, 100, 68):depend(ui_visuals.viewmodel)
ui_visuals.vm_x = vm_gear:slider("X Offset", -150, 150, 2.5, 0.1):depend(ui_visuals.viewmodel)
ui_visuals.vm_y = vm_gear:slider("Y Offset", -150, 150, 0, 0.1):depend(ui_visuals.viewmodel)
ui_visuals.vm_z = vm_gear:slider("Z Offset", -150, 150, -1.5, 0.1):depend(ui_visuals.viewmodel)

-- 开镜动画功能
ui_visuals.vm_scope_animation = vm_gear:switch("\f<telescope> Scope Animation"):depend(ui_visuals.viewmodel)
ui_visuals.vm_scope_fov = vm_gear:slider("Scope FOV", -100, 100, 50):depend(ui_visuals.viewmodel, ui_visuals.vm_scope_animation)
ui_visuals.vm_scope_x = vm_gear:slider("Scope X Offset", -150, 150, -0.4, 0.1):depend(ui_visuals.viewmodel, ui_visuals.vm_scope_animation)
ui_visuals.vm_scope_y = vm_gear:slider("Scope Y Offset", -150, 150, 0, 0.1):depend(ui_visuals.viewmodel, ui_visuals.vm_scope_animation)
ui_visuals.vm_scope_z = vm_gear:slider("Scope Z Offset", -150, 150, -2.0, 0.1):depend(ui_visuals.viewmodel, ui_visuals.vm_scope_animation)
ui_visuals.vm_scope_speed = vm_gear:slider("Animation Speed", 1, 20, 8, 1):depend(ui_visuals.viewmodel, ui_visuals.vm_scope_animation)








local watermark_frames = {
    "",
    ">",
    "*>",
    "^*",
    "~^>",
    "+~^",
    "E+~",
    ">Em",
    "*>Emp",
    "Empt*",
    ">Empti",
    "*Emptin",
    "Emptine~",
    "Emptines+",
    "^Emptiness",
    "Emptiness~",
    "Emptiness+",
    "Emptiness>",
    "Emptiness*",
    "Emptiness^",
    "Emptiness~",
    "Emptiness",
    "Emptiness",
    "Emptines^",
    "Emptin+",
    "Empti*",
    "Empt>",
    "Emp~",
    "Em+",
    "E^",
    "*",
    "",
    
    "",
    "+",
    "~+",
    "^~",
    ">^+",
    "*>^",
    "E*>",
    "+Er",
    "~Eri",
    "Eril^",
    "+Erilu",
    "~Eriluc",
    "Erilucy>",
    "Erilucyx*",
    "Erilucyxw^",
    "Erilucyxwy+",
    "~Erilucyxwyn",
    "Erilucyxwyn>",
    "Erilucyxwyn*",
    "Erilucyxwyn^",
    "Erilucyxwyn+",
    "Erilucyxwyn~",
    "Erilucyxwyn",
    "Erilucyxwyn",
    "Erilucyxwy+",
    "Erilucyxw^",
    "Erilucy*",
    "Erilu>",
    "Eri~",
    "Er+",
    "E^",
    ">",
    "",
    
    "",
    "*",
    "+*",
    "~+",
    "^~*",
    ">^~",
    "A>^",
    ".A*",
    "s.A+",
    ".s.A~",
    "t.s.A^",
    ".t.s.A>",
    "r.t.s.A*",
    ".r.t.s.A+",
    "a.r.t.s.A~",
    ".a.r.t.s.A^",
    "l.a.r.t.s.A>",
    "A.s.t.r.a.l*",
    "A.s.t.r.a.l+",
    "A.s.t.r.a.l~",
    "A.s.t.r.a.l^",
    "A.s.t.r.a.l>",
    "A.s.t.r.a.l",
    "A.s.t.r.a.l",
    ".a.r.t.s.A^",
    "a.r.t.s.A+",
    ".r.t.s.A~",
    "r.t.s.A>",
    ".t.s.A*",
    "t.s.A+",
    ".s.A~",
    "s.A^",
    ".A>",
    "A*",
    ""
}

local watermark_state = {
    position = nil,
    dragging = false,
    drag_offset = {x = 0, y = 0},
    hover = false,
    initialized = false,
    frame_index = 1,
    last_tick = 0,
    snap_threshold = 15,
    force_hidden = false
}

-- Emptiness动画帧
local emptiness_frames = {
    "",
    ">",
    "*>",
    "^*",
    "~^>",
    "+~^",
    "E+~",
    ">E",
    "*>Em",
    "Empt*",
    ">Empti",
    "*Emptin",
    "Emptine~",
    "Emptines+",
    "^Emptiness",
    "Emptiness~",
    "Emptiness+",
    "Emptiness>",
    "Emptiness*",
    "Emptiness^",
    "Emptiness~",
    "Emptiness",
    "Emptiness",
    "Emptines^",
    "Emptin+",
    "Empti*",
    "Empt>",
    "Emp~",
    "Em+",
    "E^",
    "*",
    ""
}

-- 生成日文滚动动画帧
local function generate_japanese_frames()
    local base_text = "ｰ闊弱莠ｺ縺ｧ縺吶迚ｩ逅ｴｻ蜍輔繝九Η繧｢繝蜈･髢縺九ｉ邊ｾ騾壹∪縺ｧ縲"
    local frames = {}
    local text_len = string.len(base_text)
    
    -- 先显示完整文本几帧
    for i = 1, 30 do
        table.insert(frames, base_text)
    end
    
    -- 然后开始滚动效果：每次向左移动一个字符
    for i = 1, text_len do
        local shifted = string.sub(base_text, i + 1) .. string.sub(base_text, 1, i)
        table.insert(frames, shifted)
    end
    
    return frames
end

local japanese_frames = generate_japanese_frames()

-- 当前使用的frames
local function get_current_frames()
    local mode = ui_visuals.clantag_mode:get()
    if mode == "Scroll" then
        return japanese_frames
    else
        return emptiness_frames
    end
end

local clan_tag_state = {
    frame_index = 1,
    enabled = false,
    fake_name_enabled = false
}

events.net_update_end:set(function()

    local launcher_enabled = ui_visuals.ragdoll_launcher:get()
    local force_multiplier = launcher_enabled and ui_visuals.ragdoll_mult:get() or 0
    
    repeat
        if force_multiplier <= 0 then break end
        
        local local_entity = entity.get_local_player()
        if not local_entity or not local_entity:is_alive() then break end
        
        local ragdoll_entities = entity.get_entities("CCSRagdoll")
        local ragdoll_count = #ragdoll_entities
        
        if ragdoll_count == 0 then break end
        
        for i = 1, ragdoll_count do
            local current_ragdoll = ragdoll_entities[i]
            
            if current_ragdoll then
                local vertical_power = ui_visuals.ragdoll_vertical:get() / 100
                local current_force = current_ragdoll.m_vecForce
                local current_velocity = current_ragdoll.m_vecRagdollVelocity
                
                if current_force and current_velocity then

                    local z_force = current_force.z + (force_multiplier * 5000 * vertical_power)
                    local z_velocity = current_velocity.z + (force_multiplier * 5000 * vertical_power)
                    
                    current_ragdoll.m_vecForce = vector(0, 0, z_force)
                    current_ragdoll.m_vecRagdollVelocity = vector(0, 0, z_velocity)
                end
            end
        end
    until true
    

    if not ui_visuals.clan_tag:get() then
        if clan_tag_state.enabled then
            common.set_clan_tag("")
            clan_tag_state.enabled = false
        end
        if clan_tag_state.fake_name_enabled then
            common.set_name("")
            clan_tag_state.fake_name_enabled = false
        end
        return
    end
    
    if ui_visuals.fake_name:get() then
        if not clan_tag_state.fake_name_enabled then
            common.set_name("")
            clan_tag_state.fake_name_enabled = true
        end
    else
        if clan_tag_state.fake_name_enabled then
            common.set_name("")
            clan_tag_state.fake_name_enabled = false
        end
    end
    
    local current_frames = get_current_frames()
    local speed_divisor = ui_visuals.clantag_mode:get() == "Scroll" and 12 or 18
    local step = math.floor(globals.tickcount / speed_divisor) % #current_frames + 1
    if step == clan_tag_state.frame_index then return end
    
    clan_tag_state.frame_index = step
    common.set_clan_tag(current_frames[clan_tag_state.frame_index])
    clan_tag_state.enabled = true
end)


local nickname_system = {
    engine_ptr = nil,
    player_struct = ffi.typeof([[
        struct {
            uint64_t __pad1[2];
            char name[128];
            uint32_t user_id;
            char guid[33];
            uint32_t __pad2[33];
        }
    ]]),
    saved_name = "",
    is_active = false
}


local function init_nickname_ptr()
    if nickname_system.engine_ptr then return true end
    
    local pattern = "A1 ? ? ? ? 0F 28 C1 F3 0F 5C 80 ? ? ? ? F3 0F 11 45 ? A1 ? ? ? ? 56 85 C0 75 04 33 F6 EB 26 80 78 14 00 74 F6 8B 4D 08 33 D2 E8 ? ? ? ? 8B F0 85 F6"
    local addr = utils.opcode_scan("engine.dll", pattern, 1)
    if addr then
        nickname_system.engine_ptr = ffi.cast("uintptr_t**", addr)
        return true
    end
    return false
end


local function set_nickname(name)
    if not init_nickname_ptr() then return false end
    
    local me = entity.get_local_player()
    if not me then return false end
    
    local base = nickname_system.engine_ptr[0][0]
    if base == 0 then return false end
    
    local table_ptr = ffi.cast("void***", base + 21184)[0]
    if not table_ptr then return false end
    
    local vfunc = utils.get_vfunc(11, ffi.typeof("$*(__thiscall*)(void*, int, int*)", nickname_system.player_struct))
    local info = vfunc(table_ptr, me:get_index() - 1, nil)
    
    if info then
        if nickname_system.saved_name == "" then
            nickname_system.saved_name = ffi.string(info[0].name)
        end
        ffi.copy(info[0].name, name, math.min(#name + 1, 128))
        return true
    end
    return false
end


local function restore_nickname()
    if nickname_system.saved_name ~= "" then
        set_nickname(nickname_system.saved_name)
    else
        set_nickname(panorama.MyPersonaAPI.GetName())
    end
    nickname_system.is_active = false
end


events.net_update_start:set(function()
    if not ui_visuals.client_nickname:get() then
        if nickname_system.is_active then
            restore_nickname()
        end
        return
    end
    
    local input = ui_visuals.nickname_text:get()
    if #input == 0 then
        if nickname_system.is_active then
            restore_nickname()
        end
    else
        local trimmed = input:sub(1, 32)
        if set_nickname(trimmed) then
            nickname_system.is_active = true
        end
    end
end)






local intro_state = {
    active = false,
    phase = 1,
    start_time = 0,
    elapsed = 0,
    alpha = 255,
    

    explosion_radius = 0,
    explosion_target = 80,
    particles = {},
    bg_pulse_alpha = 0,
    

    text_alpha = 0,
    text_y_offset = 50,
    version_alpha = 0,
    diamond_left_size = 0,
    diamond_right_size = 0,
    

    progress = 0,
    module_list = {
        {text = "Welcome to Emptiness!", alpha = 0, y_offset = 20}
    },
    

    final_flash_alpha = 0
}


for i = 1, 32 do
    intro_state.particles[i] = {
        angle = (i / 32) * 360,
        distance = 0,
        alpha = 255,
        size = math.random(2, 4)
    }
end


intro_state.active = true
intro_state.start_time = globals.realtime






local function render_crimson_genesis()
    if not intro_state.active then return end
    
    local screen = render.screen_size()
    local cx, cy = screen.x / 2, screen.y / 2
    intro_state.elapsed = globals.realtime - intro_state.start_time
    

    local blue_color = color(120, 180, 240, 255)
    local pink_color = color(245, 160, 200, 255)
    local theme_color = color(100, 200, 255, 255)
    

    if intro_state.elapsed < 2 then
        intro_state.phase = 1
    elseif intro_state.elapsed < 5 then
        intro_state.phase = 2
    elseif intro_state.elapsed < 8 then
        intro_state.phase = 3
    elseif intro_state.elapsed < 9 then
        intro_state.phase = 4
    else

        intro_state.active = false
        return
    end
    



    
    if intro_state.phase == 1 then
        local phase_progress = intro_state.elapsed / 2
        

        intro_state.bg_pulse_alpha = 100 + math.sin(intro_state.elapsed * 4) * 50
        render.rect(vector(0, 0), screen, color(0, 0, 0, intro_state.bg_pulse_alpha))
        

        intro_state.explosion_radius = crimson_smooth(intro_state.explosion_radius, intro_state.explosion_target, 10)
        

        for i, particle in ipairs(intro_state.particles) do
            local angle_rad = math.rad(particle.angle)
            local max_distance = 200
            particle.distance = max_distance * phase_progress * math.exp(-phase_progress * 0.5)
            
            local px = cx + math.cos(angle_rad) * particle.distance
            local py = cy + math.sin(angle_rad) * particle.distance
            
            particle.alpha = math.floor(255 * (1 - phase_progress * 0.8))
            
            render.circle(
                vector(px, py),
                color(blue_color.r, blue_color.g, blue_color.b, particle.alpha),
                particle.size, 0, 1
            )
        end
    end
    



    

    if intro_state.phase >= 2 then
        local bg_alpha = 150
        if intro_state.phase == 4 then

            bg_alpha = math.floor(intro_state.alpha * 0.6)
        end
        render.rect(vector(0, 0), screen, color(0, 0, 0, bg_alpha))
    end
    
    if intro_state.phase >= 2 then
        local phase_progress = (intro_state.elapsed - 2) / 3
        

        intro_state.text_alpha = crimson_smooth(intro_state.text_alpha, 255, 6)
        intro_state.text_y_offset = crimson_smooth(intro_state.text_y_offset, 0, 6)
        
        local text = "Emptiness"
        local animated_text = create_clean_gradient(text, 2.5, blue_color, pink_color, intro_state.text_alpha)
        

        render.text(fonts.intro_title, vector(cx, cy - 30 + intro_state.text_y_offset), 
                   color(255), "c", animated_text)
        

        if phase_progress > 0.3 then
            local target_version_alpha = (intro_state.phase == 4) and 0 or 200
            intro_state.version_alpha = crimson_smooth(intro_state.version_alpha, target_version_alpha, 6)
            render.text(fonts.intro_version, vector(cx, cy + 20 + intro_state.text_y_offset * 0.8), 
                       color(180, 180, 180, intro_state.version_alpha), "c", "1.3.5 | Recode")
        end
        
    end
    



    
    if intro_state.phase >= 3 then
        local phase_progress = (intro_state.elapsed - 5) / 3
        intro_state.progress = crimson_smooth(intro_state.progress, phase_progress, 8)
        

        local bar_max_width = 200
        local bar_start_x = cx - bar_max_width / 2 - 30
        local current_width = intro_state.progress * bar_max_width
        
        if current_width > 0 then

            local wave_phase = (globals.realtime * 3) % (math.pi * 2)
            local wave_offset = math.sin(wave_phase) * 10
            
            render.gradient(
                vector(bar_start_x, cy + 60),
                vector(bar_start_x + current_width, cy + 66),
                color(theme_color.r + wave_offset, theme_color.g, theme_color.b, intro_state.text_alpha),
                color(theme_color.r, theme_color.g + wave_offset, theme_color.b + 20, intro_state.text_alpha),
                color(theme_color.r, theme_color.g, theme_color.b + wave_offset, intro_state.text_alpha),
                color(theme_color.r + 20, theme_color.g + 20, theme_color.b, intro_state.text_alpha),
                2
            )
        end
        

        render.circle_outline(
            vector(cx, cy + 110),
            color(theme_color.r, theme_color.g, theme_color.b, intro_state.text_alpha * 0.6),
            20, 270, intro_state.progress, 3
        )
        

        for i, module in ipairs(intro_state.module_list) do
            local appear_time = 5.0 + (i - 1) * 0.5
            local complete_time = 6.0 + (i - 1) * 0.5
            
            if intro_state.elapsed >= appear_time then

                local target_alpha = (intro_state.phase == 4) and 0 or 255
                module.alpha = crimson_smooth(module.alpha, target_alpha, 8)
                module.y_offset = crimson_smooth(module.y_offset, 0, 8)
                
                local text_y = cy + 145 + module.y_offset
                

                render.text(fonts.intro_module, 
                    vector(cx, text_y),
                    color(150, 200, 255, module.alpha),
                    "c", module.text)
            end
        end
    end
    



    
    if intro_state.phase == 4 then

        intro_state.alpha = crimson_smooth(intro_state.alpha, 0, 6)
        intro_state.text_alpha = intro_state.alpha
    end
end


local vis_state = {
    dmg_pos = nil,
    def_pos = nil,
    slow_pos = nil,
    oof_pos = nil,

    circle_target_angle = 0,
    circle_current_angle = 0,
    def_alpha = 0,
    def_bar = 0,
    def_outline_alpha = 0,
    def_was_active = false,
    slow_alpha = 0,
    slow_was_active = false,
    slow_outline_alpha = 0,
    oof_alpha = 0,
    oof_arrows_data = {},
    log_queue = {},
    dmg_drag = {dragging = false, offset = vector(0, 0)},
    def_drag = {dragging = false, offset = vector(0, 0)},
    

    chaos_rotation = 0,
    chaos_last_r = 255,
    chaos_last_g = 255,
    chaos_last_b = 255,
    chaos_seizure_x = 0,
    chaos_seizure_y = 0,
    chaos_multiply_angles = {0, 72, 144, 216, 288},
    chaos_emoji_index = 1,
    chaos_emoji_timer = 0,
    chaos_quantum_x = 0,
    chaos_quantum_y = 0,
    chaos_quantum_timer = 0,
    slow_drag = {dragging = false, offset = vector(0, 0)},
    oof_drag = {dragging = false, offset = vector(0, 0)}
}



local position_storage = db.crimson_vis_layout or {}


local function get_stored_coords(element_name, fallback_x, fallback_y)
    local x_key = element_name .. "_coord_x"
    local y_key = element_name .. "_coord_y"
    local x = position_storage[x_key]
    local y = position_storage[y_key]
    
    if x and y then
        return vector(x, y)
    elseif fallback_x and fallback_y then
        return vector(fallback_x, fallback_y)
    else
        return nil
    end
end


local function store_coords(element_name, position)
    position_storage[element_name .. "_coord_x"] = position.x
    position_storage[element_name .. "_coord_y"] = position.y
    db.crimson_vis_layout = position_storage
end

-- Half-life Watermark dragging state
local halflife_wm_state = {
    position = get_stored_coords("halflife_wm", 85, 300),
    dragging = false,
    drag_offset = vector(0, 0)
}

local indicator_state = {
    binds_cache = {},
    last_close_time = 0,
    ping_y_smooth = 0,
    mystery_words = {"Emptiness", "A.s.t.r.a.l"},
    mystery_frames = nil
}

local function update_binds_cache()
    local current_binds = ui.get_binds()
    indicator_state.binds_cache = {}
    for i = 1, #current_binds do
        local bind_info = current_binds[i]
        indicator_state.binds_cache[bind_info.name] = bind_info
    end
end

local function build_mystery_frames()
    if indicator_state.mystery_frames ~= nil then return end

    local frames = {}
    local symbols = {">", "*", "^", "~", "+"}

    for w_index = 1, #indicator_state.mystery_words do
        local word = indicator_state.mystery_words[w_index]


        for i = 1, #symbols do
            frames[#frames + 1] = symbols[i]
        end


        for i = 1, #word do
            local prefix = symbols[(i - 1) % #symbols + 1]
            frames[#frames + 1] = prefix .. word:sub(1, i)
        end


        for _ = 1, 3 do
            frames[#frames + 1] = word
        end
        frames[#frames + 1] = word .. "~"
        frames[#frames + 1] = word .. ">"


        for i = #word - 1, 1, -1 do
            local suffix = symbols[(#word - i) % #symbols + 1]
            frames[#frames + 1] = word:sub(1, i) .. suffix
        end


        frames[#frames + 1] = ""
    end

    indicator_state.mystery_frames = frames
end

-- Half-life Under Crosshair display (V2原版1:1复刻)
local function render_halflife_under_crosshair(screen)
    local lp = entity.get_local_player()
    local cx, cy = screen.x / 2, screen.y / 2
    local add_y = 30
    
    -- 获取当前状态设置
    local state_id = get_current_state()
    local current_settings
    if state_id == 1 then
        current_settings = builder_settings[1]
    else
        if builder_settings[state_id].enable and builder_settings[state_id].enable:get() then
            current_settings = builder_settings[state_id]
        else
            current_settings = builder_settings[1]
        end
    end
    
    -- 闪烁alpha计算
    local alpha = math.floor(
        math.sin(math.abs(-math.pi + (globals.realtime * (1.25 / 0.75)) % (math.pi * 2))) * 200
    )
    
    -- 计算EMPTINESS的左边缘位置 (所有行都从这里开始)
    local hl_text = "EMPTINESS"
    local hl_size = render.measure_text(2, hl_text)
    local left_x = cx - hl_size.x / 2
    
    -- 第一行: EMPTINESS + stable/dev
    local version_text = is_dev and "DEV" or "STABLE"
    render.text(2, vector(left_x, cy + add_y), color(255, 255, 255, 255), "", hl_text)
    render.text(2, vector(left_x + hl_size.x + 41, cy + add_y), color(255, 240, 235, alpha), "", version_text)
    
    add_y = add_y + 9
    
    -- 第二行: Round end时DORMANCY优先级最高，否则DEFENSIVE > BODY YAW > DORMANCY
    local inverter = rage.antiaim:inverter()
    local is_defensive = def_charge_state.lc ~= 0
    
    -- 计算DORMANCY
    local players = entity.get_players(true, false)
    local player_count = 0
    for _, p in ipairs(players) do
        if p:is_alive() then
            player_count = player_count + 1
        end
    end
    
    if halflife_stats.is_round_end then
        -- Round end时DORMANCY优先级最高
        local dorm_text = "DORMANCY: "
        local dorm_size = render.measure_text(2, dorm_text)
        render.text(2, vector(left_x, cy + add_y), color(255, 201, 132, 255), "", dorm_text)
        render.text(2, vector(left_x + dorm_size.x + 43, cy + add_y), color(255, 255, 255, 255), "", tostring(player_count))
    elseif is_defensive then
        local def_text = "DEFENSIVE: "
        local def_size = render.measure_text(2, def_text)
        render.text(2, vector(left_x, cy + add_y), color(255, 255, 255, 255), "", def_text)
        render.text(2, vector(left_x + def_size.x + 40, cy + add_y), color(255, 255, 255, 255), "", tostring(def_charge_state.lc))
    elseif current_settings.body_yaw and current_settings.body_yaw:get() then
        local current_fake = inverter and "R" or "L"
        local body_text = "BODY YAW: "
        local body_size = render.measure_text(2, body_text)
        render.text(2, vector(left_x, cy + add_y), color(255, 255, 255, 255), "", body_text)
        render.text(2, vector(left_x + body_size.x + 39, cy + add_y), color(255, 255, 255, 255), "", current_fake)
    else
        local dorm_text = "DORMANCY: "
        local dorm_size = render.measure_text(2, dorm_text)
        render.text(2, vector(left_x, cy + add_y), color(255, 201, 132, 255), "", dorm_text)
        render.text(2, vector(left_x + dorm_size.x + 43, cy + add_y), color(255, 255, 255, 255), "", tostring(player_count))
    end
    
    add_y = add_y + 9
    
    -- 第三行: ONSHOT/IDEALTICK/DT/PEEK (同位置优先级显示，ONSHOT最高)
    local isDT = ui_refs.dt and ui_refs.dt:get()
    local isHS = ui_refs.hs and ui_refs.hs:get()
    local isPEEK = ui_refs.peek_assist and ui_refs.peek_assist:get()
    local isIDEALTICK = isDT and isPEEK
    
    local third_line_text = nil
    if isHS then
        third_line_text = "ONSHOT"
    elseif isIDEALTICK then
        third_line_text = "IDEALTICK"
    elseif isDT then
        third_line_text = "DT"
    elseif isPEEK then
        third_line_text = "PEEK"
    end
    
    if third_line_text then
        local exploit_ready = rage.exploit:get() == 1
        local third_line_color = exploit_ready and color(255, 255, 255, 255) or color(180, 60, 60, 255)
        render.text(2, vector(left_x, cy + add_y), third_line_color, "", third_line_text)
        add_y = add_y + 9
    end
    
    -- 第四行: BAIM / SP / FS (左对齐，和前面行一致)
    local sp_color = (ui_refs.safe_points and ui_refs.safe_points:get() == "Force") and color(255, 255, 255, 255) or color(127, 127, 127, 255)
    local baim_color = (ui_refs.body_aim and ui_refs.body_aim:get() == "Force") and color(255, 255, 255, 255) or color(127, 127, 127, 255)
    local fs_color = ui_antiaim_main.freestanding:get() and color(255, 255, 255, 255) or color(127, 127, 127, 255)
    
    render.text(2, vector(left_x, cy + add_y), baim_color, "", "BAIM")
    render.text(2, vector(left_x + 20, cy + add_y), sp_color, "", "SP")
    render.text(2, vector(left_x + 32, cy + add_y), fs_color, "", "FS")
end

-- Half-life Watermark display (V2原版1:1复刻)
local function render_halflife_watermark(screen)
    local lp = entity.get_local_player()
    
    -- Initialize position if not set
    if not halflife_wm_state.position then
        halflife_wm_state.position = get_stored_coords("halflife_wm", 85, screen.y / 2 - 35)
    end
    
    -- Dragging logic (same as keybinds)
    local mouse_pos = ui.get_mouse_position()
    local in_menu = ui.get_alpha() > 0
    
    if in_menu then
        local is_hovering = mouse_pos.x >= halflife_wm_state.position.x and 
                           mouse_pos.x <= halflife_wm_state.position.x + 350 and
                           mouse_pos.y >= halflife_wm_state.position.y and 
                           mouse_pos.y <= halflife_wm_state.position.y + 60
        
        if is_hovering and common.is_button_down(1) and not halflife_wm_state.dragging then
            halflife_wm_state.dragging = true
            halflife_wm_state.drag_offset = mouse_pos - halflife_wm_state.position
        end
    end
    
    if halflife_wm_state.dragging then
        if common.is_button_down(1) then
            halflife_wm_state.position = mouse_pos - halflife_wm_state.drag_offset
        else
            halflife_wm_state.dragging = false
            store_coords("halflife_wm", halflife_wm_state.position)
        end
    end
    
    local add_x = halflife_wm_state.position.x
    local add_y = halflife_wm_state.position.y
    
    local function sanitize_target_name(name)
        local out = {}
        local i = 1
        local len = #name
        
        while i <= len do
            local b = name:byte(i)
            if b >= 32 and b <= 126 then
                out[#out + 1] = string.char(b)
                i = i + 1
            elseif b < 128 then
                out[#out + 1] = "?"
                i = i + 1
            else
                if b >= 240 then
                    i = i + 4
                elseif b >= 224 then
                    i = i + 3
                elseif b >= 192 then
                    i = i + 2
                else
                    i = i + 1
                end
                out[#out + 1] = "?"
            end
        end
        
        return table.concat(out)
    end
    
    -- 第一行: 标题 
    local version_text = is_dev and "dev" or "stable"
    local nl_username = common.get_username()
    render.text(4, vector(add_x, add_y), color(255, 255, 255, 255), "", string.format("emptiness - version 1.3.5 %s - %s", version_text, nl_username))
    
    -- 第二行: anti-aim info (add_y + 15)
    local inverter = rage.antiaim:inverter()
    local aa_state = inverter and "0: (1, nil, 0)" or "1: (1, nil, 0)"
    local aa_text = string.format("> anti-aim info: side - %s;", aa_state)
    render.text(4, vector(add_x, add_y + 15), color(255, 218, 244, 215), "", aa_text)
    
    -- target: 使用createmove缓存的FOV最近目标
    local target_name = sanitize_target_name(halflife_stats.current_target_name)
    render.text(4, vector(add_x + 175, add_y + 15), color(255, 218, 244, 215), "", string.format("target: %s", target_name))
    
    -- 第三行: player info (add_y + 30)
    local state_names = {
        [2] = "standing",
        [3] = "walking", 
        [4] = "rolling",
        [5] = "in duck",
        [6] = "in duck",
        [7] = "in air",
        [8] = "in air"
    }
    local current_state = get_current_state()
    local state_text = state_names[current_state] or "standing"
    render.text(4, vector(add_x, add_y + 30), color(223, 255, 166, 215), "", string.format("> player info: state - %s", state_text))
    
    -- 第四行: anti brute info (add_y + 45)
    -- 只有在有target时才显示
    if halflife_stats.current_target_name and halflife_stats.current_target_name ~= "nil" then
        local head_count = 0
        local body_count = 0
        if halflife_stats.current_target_index and halflife_stats.hurt_stats[halflife_stats.current_target_index] then
            local stats = halflife_stats.hurt_stats[halflife_stats.current_target_index]
            head_count = stats.head
            body_count = stats.body
        end
        render.text(4, vector(add_x, add_y + 45), color(255, 186, 145, 255), "", string.format("> anti brute info: hurt - head(%d); body(%d);", head_count, body_count))
    end
end

-- Half-life main render function
local function render_halflife_indicators()
    local screen = render.screen_size()
    
    -- Under Crosshair display
    if ui_visuals.halflife_display:get("Under Crosshair") then
        render_halflife_under_crosshair(screen)
    end
    
    -- Watermark display
    if ui_visuals.halflife_display:get("Watermark") then
        render_halflife_watermark(screen)
    end
end

local function render_mystery_indicator()
    if not ui_visuals.mystery_indicator:get() then return end
    
    local lp = entity.get_local_player()
    if not lp or not lp:is_alive() then return end
    
    if intro_state.active then return end
    
    local screen = render.screen_size()
    local display_mode = ui_visuals.center_indicator_mode:get()
    
    if display_mode == "lura.blue" then
        -- emptiness.blue watermark mode
        local screen_x = screen.x
        local screen_y = screen.y
        local build_text = ""
        if ui_visuals.lura_build_mode:get() then
            build_text = is_dev and " | debug" or " | stable"
        end
        local y_off = 10  -- 固定Y偏移
        local x_off = 0   -- 固定X偏移
        local lura_color = color(255, 255, 255, 255)  -- 强制白色
        
        render.text(4, vector(screen_x/2 + x_off, screen_y - 6 - y_off), lura_color, "c", "Δ emptiness.blue" .. build_text)
        return
    elseif display_mode == "Half-life" then
        -- Half-life mode
        render_halflife_indicators()
        return
    end
    
    -- Original Crimson indicators
    update_binds_cache()
    build_mystery_frames()

    local cx, cy = screen.x / 2, screen.y / 2 + 20
    local crimson_style = ui_visuals.crimson_style:get()
    local is_simple_mode = crimson_style == "Simple"

    local frames = indicator_state.mystery_frames or {""}
    local frame_count = #frames
    local raw_text = ""
    local current_word_index = 1
    if frame_count > 0 then
        local interval = 12
        local step = math.floor(globals.tickcount / interval) % frame_count + 1
        raw_text = frames[step] or ""
        


        local word1_frames = 5 + #indicator_state.mystery_words[1] + 5 + (#indicator_state.mystery_words[1] - 1) + 1
        if step > word1_frames then
            current_word_index = 2
        else
            current_word_index = 1
        end
    end

    local base_measure_text = #indicator_state.mystery_words[1] >= #indicator_state.mystery_words[2] and indicator_state.mystery_words[1] or indicator_state.mystery_words[2]
    local measure_text = raw_text ~= "" and raw_text or base_measure_text


    local is_emptiness = (current_word_index == 1)
    local mystery_color, target_color
    
    if is_emptiness then

        mystery_color = color(242, 97, 130, 255)
        target_color = color(220, 100, 220, 255)
    else

        mystery_color = color(120, 180, 240, 255)
        target_color = color(245, 160, 200, 255)
    end
    
    local animated_text = ""
    if raw_text ~= "" then
        animated_text = create_clean_gradient(raw_text, 2.5, mystery_color, target_color, 255)
    end
    
    local shadow_color
    do
        local prefix = animated_text:sub(1, 1)
        if prefix == "\a" and #animated_text >= 9 then
            local hex = animated_text:sub(2, 9)
            local r = tonumber(hex:sub(1, 2), 16) or 255
            local g = tonumber(hex:sub(3, 4), 16) or 255
            local b = tonumber(hex:sub(5, 6), 16) or 255
            shadow_color = color(r, g, b, 200)
        else

            if is_emptiness then
                shadow_color = color(242, 97, 130, 200)
            else
                shadow_color = color(120, 180, 240, 200)
            end
        end
    end
    
    if is_simple_mode then
        -- Simple模式：固定显示"Emptiness"，从右到左渐变
        local simple_text = create_mystery_gradient_animation("Emptiness")
        
        -- 从右边（最后一个字符）提取shadow颜色，和default一样的逻辑但取最后字符
        local simple_shadow_color
        local text_len = #simple_text
        if text_len >= 10 then
            -- 格式: \aRRGGBBAAc，每个字符占10位，最后字符的hex在 text_len-8 到 text_len-1
            local hex = simple_text:sub(text_len - 8, text_len - 1)
            local r = tonumber(hex:sub(1, 2), 16) or 120
            local g = tonumber(hex:sub(3, 4), 16) or 180
            local b = tonumber(hex:sub(5, 6), 16) or 240
            simple_shadow_color = color(r, g, b, 200)
        else
            simple_shadow_color = color(120, 180, 240, 200)
        end
        
        -- 渲染shadow
        local text_size = render.measure_text(4, "", "Emptiness")
        local half_w = text_size.x / 2
        local shadow_y = cy
        local shadow_start = vector(cx - half_w, shadow_y)
        local shadow_end = vector(cx + half_w, shadow_y)
        render.shadow(shadow_start, shadow_end, simple_shadow_color)
        render.shadow(shadow_start, shadow_end, simple_shadow_color)
        
        render.text(4, vector(cx, cy), color(255), "c", simple_text)
    else
        -- Default模式：原有的复杂动画
        if animated_text ~= "" then
            local text_size = render.measure_text(4, "", measure_text)
            local half_w = text_size.x / 2
            local shadow_y = cy
            local shadow_start = vector(cx - half_w, shadow_y)
            local shadow_end = vector(cx + half_w, shadow_y)
            render.shadow(shadow_start, shadow_end, shadow_color)
            render.shadow(shadow_start, shadow_end, shadow_color)
            render.text(4, vector(cx, cy), color(255), "c", animated_text)
        end
    end
    

    if vis_state.hs_alpha == nil then
        vis_state.hs_alpha = 0
        vis_state.hs_was_active = false
    end
    if vis_state.dt_alpha == nil then
        vis_state.dt_alpha = 0
        vis_state.dt_was_active = false
    end
    if vis_state.ping_alpha == nil then
        vis_state.ping_alpha = 0
        vis_state.ping_was_active = false
    end
    
    local current_y = cy + 11
    

    local hs_enabled = ui_refs.hs:get()
    local hs_target_alpha = hs_enabled and 255 or 0
    vis_state.hs_alpha = crimson_smooth(vis_state.hs_alpha, hs_target_alpha, 6)
    
    if is_simple_mode then
        -- Simple模式：无Clear动画，有充能圆圈
        if vis_state.hs_alpha > 1 then
            local hs_color = color(240, 240, 240, vis_state.hs_alpha)
            local text_size = render.measure_text(2, "", "HS")
            render.text(2, vector(cx, current_y), hs_color, "c", "HS")
            
            -- HS充能圆圈（使用exploit charge）
            local circle_x = cx + text_size.x / 2 + 5
            local circle_y = current_y + 1.5
            local circle_r = 5
            local exploit_charge = rage.exploit:get()
            render.circle_outline(vector(circle_x, circle_y), 
                color(40, 45, 50, vis_state.hs_alpha), 
                circle_r, 0, 1, 1.5)
            if exploit_charge > 0 then
                local charge_color
                if exploit_charge >= 1 then
                    charge_color = color(240, 240, 240, vis_state.hs_alpha)
                else
                    charge_color = color(240 * 0.7, 240 * 0.7, 240 * 0.7, vis_state.hs_alpha * 0.8)
                end
                render.circle_outline(vector(circle_x, circle_y), 
                    charge_color, 
                    circle_r, -90, exploit_charge, 2)
            end
        end
        if not hs_enabled then
            vis_state.hs_was_active = false
        end
    else
        -- Default模式：保持原有逻辑
        if hs_enabled then
            vis_state.hs_was_active = true
            indicator_state.last_close_time = 0
            local hs_color = color(240, 240, 240, vis_state.hs_alpha)
            render.text(2, vector(cx, current_y), hs_color, "c", "HS")
        elseif vis_state.hs_was_active then
            vis_state.hs_alpha = crimson_smooth(vis_state.hs_alpha, 0, 4)
            if vis_state.hs_alpha > 1 then
                render.text(2, vector(cx, current_y), 
                           color(255, 255, 255, vis_state.hs_alpha), "c", "► Clear ◄")
            else
                vis_state.hs_was_active = false
                indicator_state.last_close_time = globals.realtime
            end
        end
    end
    

    if not hs_enabled and vis_state.hs_alpha < 1 then
        local dt_enabled = ui_refs.dt:get()
        local dt_target_alpha = dt_enabled and 255 or 0
        vis_state.dt_alpha = crimson_smooth(vis_state.dt_alpha, dt_target_alpha, 6)
        
        if is_simple_mode then
            -- Simple模式：无Clear动画，有充能圆圈
            if vis_state.dt_alpha > 1 then
                local dt_charge = rage.exploit:get()
                local dt_charged = dt_charge == 1
                local dt_base_color = dt_charged and color(240, 240, 240) or color(255, 0, 0)
                local dt_color = color(dt_base_color.r, dt_base_color.g, dt_base_color.b, vis_state.dt_alpha)
                local text_size = render.measure_text(2, "", "DT")
                render.text(2, vector(cx, current_y), dt_color, "c", "DT")
                
                -- DT充能圆圈
                local circle_x = cx + text_size.x / 2 + 5
                local circle_y = current_y + 1.5
                local circle_r = 5
                render.circle_outline(vector(circle_x, circle_y), 
                    color(40, 45, 50, vis_state.dt_alpha), 
                    circle_r, 0, 1, 1.5)
                if dt_charge > 0 then
                    local charge_color = dt_charged and color(240, 240, 240, vis_state.dt_alpha) or color(255, 0, 0, vis_state.dt_alpha * 0.8)
                    render.circle_outline(vector(circle_x, circle_y), 
                        charge_color, 
                        circle_r, -90, dt_charge, 2)
                end
            end
            if not dt_enabled then
                vis_state.dt_was_active = false
            end
        else
            -- Default模式：保持原有逻辑
            if dt_enabled then
                vis_state.dt_was_active = true
                indicator_state.last_close_time = 0
                local dt_charged = rage.exploit:get() == 1
                local dt_base_color = dt_charged and color(240, 240, 240) or color(255, 0, 0)
                local dt_color = color(dt_base_color.r, dt_base_color.g, dt_base_color.b, vis_state.dt_alpha)
                render.text(2, vector(cx, current_y), dt_color, "c", "DT")
            elseif vis_state.dt_was_active then
                vis_state.dt_alpha = crimson_smooth(vis_state.dt_alpha, 0, 4)
                if vis_state.dt_alpha > 1 then
                    render.text(2, vector(cx, current_y), 
                               color(255, 255, 255, vis_state.dt_alpha), "c", "► Clear ◄")
                else
                    vis_state.dt_was_active = false
                    indicator_state.last_close_time = globals.realtime
                end
            end
        end
    else
        if vis_state.dt_was_active then
            indicator_state.last_close_time = globals.realtime
        end
        vis_state.dt_alpha = 0
        vis_state.dt_was_active = false
    end
    

    local ping_bind = indicator_state.binds_cache["Fake Latency"]
    local ping_active = ping_bind ~= nil and ping_bind.active
    local ping_target_alpha = ping_active and 255 or 0
    vis_state.ping_alpha = crimson_smooth(vis_state.ping_alpha, ping_target_alpha, 6)
    
    if is_simple_mode then
        -- Simple模式：保持Y轴平滑动画，但无Clear动画
        local no_indicators_showing = not hs_enabled and vis_state.hs_alpha < 1 and 
                                      not ui_refs.dt:get() and vis_state.dt_alpha < 1
        local time_since_close = globals.realtime - indicator_state.last_close_time
        local can_move_up = no_indicators_showing and time_since_close > 0.3
        
        local target_ping_y
        if no_indicators_showing and (indicator_state.last_close_time == 0 or can_move_up) then
            target_ping_y = cy + 12
        else
            target_ping_y = current_y + 10
        end
        
        if indicator_state.ping_y_smooth == 0 then
            indicator_state.ping_y_smooth = target_ping_y
        end
        indicator_state.ping_y_smooth = crimson_smooth(indicator_state.ping_y_smooth, target_ping_y, 8)
        local ping_y = indicator_state.ping_y_smooth
        
        if vis_state.ping_alpha > 1 then
            local ping_color = color(165, 220, 15, vis_state.ping_alpha)
            render.text(2, vector(cx, ping_y), ping_color, "c", "PING")
        end
        if not ping_active then
            vis_state.ping_was_active = false
        end
    else
        -- Default模式：保持原有的Y轴平滑动画和Clear动画
        local no_indicators_showing = not hs_enabled and vis_state.hs_alpha < 1 and 
                                      not ui_refs.dt:get() and vis_state.dt_alpha < 1
        local time_since_close = globals.realtime - indicator_state.last_close_time
        local can_move_up = no_indicators_showing and time_since_close > 0.3
        
        local target_ping_y
        if no_indicators_showing and (indicator_state.last_close_time == 0 or can_move_up) then
            target_ping_y = cy + 12
        else
            target_ping_y = current_y + 10
        end
        
        if indicator_state.ping_y_smooth == 0 then
            indicator_state.ping_y_smooth = target_ping_y
        end
        indicator_state.ping_y_smooth = crimson_smooth(indicator_state.ping_y_smooth, target_ping_y, 8)
        local ping_y = indicator_state.ping_y_smooth
        
        if ping_active then
            vis_state.ping_was_active = true
            local ping_color = color(165, 220, 15, vis_state.ping_alpha)
            render.text(2, vector(cx, ping_y), ping_color, "c", "PING")
        elseif vis_state.ping_was_active then
            vis_state.ping_alpha = crimson_smooth(vis_state.ping_alpha, 0, 4)
            if vis_state.ping_alpha > 1 then
                render.text(2, vector(cx, ping_y), 
                           color(255, 255, 255, vis_state.ping_alpha), "c", "► Clear ◄")
            else
                vis_state.ping_was_active = false
            end
        end
    end
end


local function render_damage_indicator()
    if not ui_visuals.damage_indicator:get() then return end
    local lp = entity.get_local_player()
    if not lp or not lp:is_alive() then return end
    
    local screen = render.screen_size()
    if not vis_state.dmg_pos then
        vis_state.dmg_pos = get_stored_coords("dmg_ind", screen.x / 2 + 40, screen.y / 2 - 40)
    end
    
    local dmg = tostring(ui_refs.mindamage:get())
    local col = ui_visuals.dmg_color:get()
    local font_choice = ui_visuals.dmg_font:get()
    local font_id = 1  -- Default to Font 1
    if font_choice == "Font 1" then font_id = 1
    elseif font_choice == "Font 2" then font_id = 2
    elseif font_choice == "Font 3" then font_id = 3
    elseif font_choice == "Font 4" then font_id = 4
    end
    local pos = vis_state.dmg_pos
    

    render.text(font_id, pos, col, "c", dmg)
    

    local in_menu = pui.get_alpha() > 0
    if in_menu then
        local size = render.measure_text(font_id, nil, dmg)
        local x1, y1 = pos.x - size.x/2 - 5, pos.y - size.y/2 - 3
        local x2, y2 = pos.x + size.x/2 + 5, pos.y + size.y/2 + 3
        render.rect_outline(vector(x1, y1), vector(x2, y2), color(col.r, col.g, col.b, 100), 1, 0)
    end
end


local function render_defensive_indicator()
    if not ui_visuals.defensive_indicator:get() then return end
    local lp = entity.get_local_player()
    local screen = render.screen_size()
    

    if not vis_state.def_pos then
        vis_state.def_pos = get_stored_coords("def_ind", screen.x / 2, screen.y / 2 - 300)
    end
    
    local pos = vis_state.def_pos
    local col = ui_visuals.def_color:get()
    local in_menu = pui.get_alpha() > 0
    

    local is_defensive = lp and lp:is_alive() and def_charge_state.lc ~= 0
    local target_alpha = is_defensive and col.a or 0
    vis_state.def_alpha = crimson_smooth(vis_state.def_alpha, target_alpha, 6)
    

    if lp and lp:is_alive() then
        
        if is_defensive then
            vis_state.def_was_active = true
            local display_text = "▼ Defensive ▼"
            
            render.text(1, vector(pos.x, pos.y - 8), 
                       color(255, 255, 255, vis_state.def_alpha), "c", display_text)
            

            local wave_sections = 5
            local def_progress = (14 - def_charge_state.lc) / 14
            local section_width = (def_progress * 80) / wave_sections
            for i = 0, wave_sections - 1 do
                local wave_phase = (globals.realtime * 3 + i * 0.3) % (math.pi * 2)
                local wave_alpha = (math.sin(wave_phase) * 0.4 + 0.6) * vis_state.def_alpha
                local section_color = color(
                    col.r + math.sin(wave_phase) * 30,
                    col.g + math.cos(wave_phase) * 20,
                    col.b + math.sin(wave_phase + 1) * 25,
                    wave_alpha
                )
                
                if section_width > i * 16 then
                    render.gradient(
                        vector(pos.x - 40 + i * 16, pos.y + 3),
                        vector(pos.x - 40 + math.min((i + 1) * 16, section_width), pos.y + 7),
                        section_color, color(section_color.r + 20, section_color.g, section_color.b, section_color.a),
                        color(section_color.r, section_color.g + 15, section_color.b, section_color.a), section_color,
                        2
                    )
                end
            end
        elseif vis_state.def_was_active then
            vis_state.def_alpha = crimson_smooth(vis_state.def_alpha, 0, 4)
            if vis_state.def_alpha > 1 then
                render.text(1, vector(pos.x, pos.y - 8), 
                           color(255, 255, 255, vis_state.def_alpha), "c", "► Clear ◄")
                

                
            else
                vis_state.def_was_active = false
            end
        end
        

        if not lp:is_alive() then
            vis_state.def_alpha = 0
            vis_state.def_was_active = false
        end
    end
    

    if in_menu then
        local preview_alpha = 200
        
        render.text(1, vector(pos.x, pos.y - 8), color(220, 220, 220, preview_alpha), "c", "▼ Defensive ▼")
        

        local wave_sections = 5
        local section_width = (0.7 * 80) / wave_sections
        for i = 0, wave_sections - 1 do
            local wave_phase = (i * 0.5) % (math.pi * 2)
            local wave_alpha = (math.sin(wave_phase) * 0.4 + 0.6) * preview_alpha
            local section_color = color(
                col.r + math.sin(wave_phase) * 30,
                col.g + math.cos(wave_phase) * 20,
                col.b + math.sin(wave_phase + 1) * 25,
                wave_alpha
            )
            
            if section_width > i * 16 then
                render.gradient(
                    vector(pos.x - 40 + i * 16, pos.y + 3),
                    vector(pos.x - 40 + math.min((i + 1) * 16, section_width), pos.y + 7),
                    section_color, color(section_color.r + 20, section_color.g, section_color.b, section_color.a),
                    color(section_color.r, section_color.g + 15, section_color.b, section_color.a), section_color,
                    2
                )
            end
        end
        

        render.rect_outline(vector(pos.x - 57, pos.y - 16), vector(pos.x + 57, pos.y + 7),
            color(col.r, col.g, col.b, 80), 1, 3)
    end
end


local function render_oof_arrows()
    if not ui_visuals.oof_arrows:get() then return end
    if not globals.is_in_game then return end
    
    local lp = entity.get_local_player()
    if not lp or not lp:is_alive() then return end
    
    local screen = render.screen_size()
    
    if not vis_state.oof_pos then
        vis_state.oof_pos = get_stored_coords("oof_arrows", screen.x - 100, screen.y / 2)
    end
    
    local pos = vis_state.oof_pos
    local col = ui_visuals.oof_arrows_color:get()
    local radius = ui_visuals.oof_arrows_radius:get() / 100
    local show_pulse = ui_visuals.oof_arrows_pulse:get()
    local show_dormant = ui_visuals.oof_arrows_show_dormant:get()


    local style_name = "Snowflake"
    if ui_visuals.oof_arrows_style then
        style_name = ui_visuals.oof_arrows_style:get() or "Snowflake"
    end
    local style_is_curved = (style_name == "Curved Line")
    

    vis_state.oof_arrows_data = {}
    local players = entity.get_players(true)
    
    if players then
        for _, player in ipairs(players) do
            if player and player:is_alive() and player ~= lp then
                local player_origin = player:get_origin()
                if player_origin then
                    local offscreen_pos, angle, is_offscreen = render.get_offscreen(player_origin, radius)
                    
                    if is_offscreen and offscreen_pos then
                        table.insert(vis_state.oof_arrows_data, {
                            pos = offscreen_pos,
                            angle = angle,
                            player = player,
                            color = col
                        })
                    end
                end
            end
        end
    end
    

    local has_enemies = #vis_state.oof_arrows_data > 0
    local target_alpha = has_enemies and col.a or 0
    vis_state.oof_alpha = crimson_smooth(vis_state.oof_alpha, target_alpha, 6)
    
    if vis_state.oof_alpha < 1 then return end
    

    for _, arrow_data in ipairs(vis_state.oof_arrows_data) do
        local arrow_pos = arrow_data.pos
        local arrow_angle = arrow_data.angle
        local arrow_color = arrow_data.color
        

        local pulse_alpha = arrow_color.a
        if show_pulse then
            local pulse_factor = math.sin(globals.realtime * 3) * 0.3 + 0.7
            pulse_alpha = math.floor(arrow_color.a * pulse_factor)
        end
        
        local final_color = color(arrow_color.r, arrow_color.g, arrow_color.b, math.floor(pulse_alpha * vis_state.oof_alpha / 255))

        local arrow_size = 12
        local rotation = arrow_angle - render.camera_angles().y
        if style_is_curved then
            rotation = rotation + 90
        end

        render.push_rotation(rotation)

        if not style_is_curved then

            local snow_shadow_color = nil
            if ui_visuals.oof_arrows_snowflake_shadow_opacity then
                local pct = ui_visuals.oof_arrows_snowflake_shadow_opacity:get() or 40
                local alpha = math.floor(255 * (pct / 100))
                snow_shadow_color = color(final_color.r, final_color.g, final_color.b, alpha)
            end

            render.circle_outline(arrow_pos, final_color, 2.5, 0, 360, 1)


            render.rect(vector(arrow_pos.x - 1.5, arrow_pos.y - arrow_size), vector(arrow_pos.x + 1.5, arrow_pos.y - 4), final_color)
            render.poly(final_color,
                vector(arrow_pos.x - 4, arrow_pos.y - 6),
                vector(arrow_pos.x, arrow_pos.y - arrow_size),
                vector(arrow_pos.x + 4, arrow_pos.y - 6)
            )


            render.rect(vector(arrow_pos.x - 1.5, arrow_pos.y + 4), vector(arrow_pos.x + 1.5, arrow_pos.y + arrow_size), final_color)
            render.poly(final_color,
                vector(arrow_pos.x - 4, arrow_pos.y + 6),
                vector(arrow_pos.x, arrow_pos.y + arrow_size),
                vector(arrow_pos.x + 4, arrow_pos.y + 6)
            )


            render.rect(vector(arrow_pos.x - arrow_size, arrow_pos.y - 1.5), vector(arrow_pos.x - 4, arrow_pos.y + 1.5), final_color)
            render.poly(final_color,
                vector(arrow_pos.x - 6, arrow_pos.y - 4),
                vector(arrow_pos.x - arrow_size, arrow_pos.y),
                vector(arrow_pos.x - 6, arrow_pos.y + 4)
            )


            render.rect(vector(arrow_pos.x + 4, arrow_pos.y - 1.5), vector(arrow_pos.x + arrow_size, arrow_pos.y + 1.5), final_color)
            render.poly(final_color,
                vector(arrow_pos.x + 6, arrow_pos.y - 4),
                vector(arrow_pos.x + arrow_size, arrow_pos.y),
                vector(arrow_pos.x + 6, arrow_pos.y + 4)
            )


            if snow_shadow_color then

                local snow_shadow_offset = 1
                local snow_shadow_y      = arrow_pos.y + snow_shadow_offset
                local snow_shadow_start  = vector(arrow_pos.x - arrow_size, snow_shadow_y)
                local snow_shadow_end    = vector(arrow_pos.x + arrow_size, snow_shadow_y)
                render.shadow(snow_shadow_start, snow_shadow_end, snow_shadow_color)


                local snow_shadow_x      = arrow_pos.x + snow_shadow_offset
                local snow_shadow_vstart = vector(snow_shadow_x, arrow_pos.y - arrow_size)
                local snow_shadow_vend   = vector(snow_shadow_x, arrow_pos.y + arrow_size)
                render.shadow(snow_shadow_vstart, snow_shadow_vend, snow_shadow_color)
            end
        else

            local size_scale = (ui_visuals.oof_arrows_curved_size:get() or 100) / 100
            local radius_arc = 28 * size_scale
            local curve_height = 2 * size_scale
            local tri_height = 10 * size_scale
            local tri_width = 6 * size_scale


            local base_y = arrow_pos.y
            local p1 = vector(arrow_pos.x - radius_arc,       base_y + curve_height)
            local p2 = vector(arrow_pos.x - radius_arc * 0.5, base_y - curve_height * 0.5)
            local p3 = vector(arrow_pos.x,                    base_y - curve_height)
            local p4 = vector(arrow_pos.x + radius_arc * 0.5, base_y - curve_height * 0.5)
            local p5 = vector(arrow_pos.x + radius_arc,       base_y + curve_height)


            render.poly_line(final_color, p1, p2, p3, p4, p5)

            local p1b = vector(p1.x, p1.y + 1)
            local p2b = vector(p2.x, p2.y + 1)
            local p3b = vector(p3.x, p3.y + 1)
            local p4b = vector(p4.x, p4.y + 1)
            local p5b = vector(p5.x, p5.y + 1)
            render.poly_line(final_color, p1b, p2b, p3b, p4b, p5b)


            local curved_shadow_color = nil
            if ui_visuals.oof_arrows_curved_shadow_opacity then
                local pct = ui_visuals.oof_arrows_curved_shadow_opacity:get() or 40
                local alpha = math.floor(255 * (pct / 100))
                curved_shadow_color = color(final_color.r, final_color.g, final_color.b, alpha)
            end

            if curved_shadow_color then

                local shadow_offset = 2
                local shadow_start  = vector(p1.x, p1.y + shadow_offset)
                local shadow_end    = vector(p5.x, p5.y + shadow_offset)
                render.shadow(shadow_start, shadow_end, curved_shadow_color)
            end




            local tri_base_y = p3.y
            local tri_tip_y  = tri_base_y - tri_height
            local tri_left   = vector(arrow_pos.x - tri_width, tri_base_y)
            local tri_right  = vector(arrow_pos.x + tri_width, tri_base_y)
            local tri_tip    = vector(arrow_pos.x,     tri_tip_y)
            render.poly(final_color, tri_left, tri_right, tri_tip)


            if curved_shadow_color then
                local tri_shadow_offset = 2
                local tri_shadow_start  = vector(tri_tip.x, tri_tip.y - tri_shadow_offset)
                local tri_shadow_end    = vector(tri_tip.x, tri_base_y - tri_shadow_offset)
                render.shadow(tri_shadow_start, tri_shadow_end, curved_shadow_color)
            end
        end

        render.pop_rotation()
    end
end


local function render_slowdown_indicator()
    if not ui_visuals.slowdown_indicator:get() then return end
    local lp = entity.get_local_player()
    local screen = render.screen_size()
    

    if not vis_state.slow_pos then
        vis_state.slow_pos = get_stored_coords("slow_ind", screen.x / 2, screen.y / 2 - 240)
    end
    
    local pos = vis_state.slow_pos
    local col = ui_visuals.slow_color:get()
    local in_menu = pui.get_alpha() > 0
    

    local vel_mod = (lp and lp:is_alive()) and (lp.m_flVelocityModifier or 1.0) or 1.0
    local is_slowed = vel_mod < 0.99
    local target_alpha = is_slowed and col.a or 0
    vis_state.slow_alpha = crimson_smooth(vis_state.slow_alpha, target_alpha, 6)
    

    if lp and lp:is_alive() then
        
        if is_slowed then
            vis_state.slow_was_active = true
            local slow_percent = (1 - vel_mod) * 100
            local display_text = string.format("▼ Slowdown %.0f%% ▼", slow_percent)
            
            render.text(1, vector(pos.x, pos.y - 8), 
                       color(255, 255, 255, vis_state.slow_alpha), "c", display_text)
            

            local wave_sections = 5
            local section_width = (vel_mod * 80) / wave_sections
            for i = 0, wave_sections - 1 do
                local wave_phase = (globals.realtime * 3 + i * 0.3) % (math.pi * 2)
                local wave_alpha = (math.sin(wave_phase) * 0.4 + 0.6) * vis_state.slow_alpha
                local section_color = color(
                    col.r + math.sin(wave_phase) * 30,
                    col.g + math.cos(wave_phase) * 20,
                    col.b + math.sin(wave_phase + 1) * 25,
                    wave_alpha
                )
                
                if section_width > i * 16 then
                    render.gradient(
                        vector(pos.x - 40 + i * 16, pos.y + 3),
                        vector(pos.x - 40 + math.min((i + 1) * 16, section_width), pos.y + 7),
                        section_color, color(section_color.r + 20, section_color.g, section_color.b, section_color.a),
                        color(section_color.r, section_color.g + 15, section_color.b, section_color.a), section_color,
                        2
                    )
                end
            end
        elseif vis_state.slow_was_active then
            vis_state.slow_alpha = crimson_smooth(vis_state.slow_alpha, 0, 4)
            if vis_state.slow_alpha > 1 then
                render.text(1, vector(pos.x, pos.y - 8), 
                           color(255, 255, 255, vis_state.slow_alpha), "c", "► Clear ◄")
                

                
            else
                vis_state.slow_was_active = false
            end
        end
        

        if not lp:is_alive() then
            vis_state.slow_alpha = 0
            vis_state.slow_was_active = false
        end
    end
    

    if in_menu then
        local preview_alpha = 200
        
        render.text(1, vector(pos.x, pos.y - 8), color(220, 220, 220, preview_alpha), "c", "▼ Slowdown 50% ▼")
        

        local wave_sections = 5
        local section_width = (0.5 * 80) / wave_sections
        for i = 0, wave_sections - 1 do
            local wave_phase = (i * 0.5) % (math.pi * 2)
            local wave_alpha = (math.sin(wave_phase) * 0.4 + 0.6) * preview_alpha
            local section_color = color(
                col.r + math.sin(wave_phase) * 30,
                col.g + math.cos(wave_phase) * 20,
                col.b + math.sin(wave_phase + 1) * 25,
                wave_alpha
            )
            
            if section_width > i * 16 then
                render.gradient(
                    vector(pos.x - 40 + i * 16, pos.y + 3),
                    vector(pos.x - 40 + math.min((i + 1) * 16, section_width), pos.y + 7),
                    section_color, color(section_color.r + 20, section_color.g, section_color.b, section_color.a),
                    color(section_color.r, section_color.g + 15, section_color.b, section_color.a), section_color,
                    2
                )
            end
        end
        

        render.rect_outline(vector(pos.x - 57, pos.y - 16), vector(pos.x + 57, pos.y + 7),
            color(col.r, col.g, col.b, 80), 1, 3)
    end
end


local function render_crosshair_circle()
    if not ui_visuals.crosshair_circle:get() then return end
    
    local screen = render.screen_size()
    local cx, cy = screen.x / 2, screen.y / 2
    
    local radius = ui_visuals.circle_radius:get()
    local thickness = ui_visuals.circle_thickness:get()
    local bg_color = ui_visuals.circle_bg_color:get()
    local indicator_color = ui_visuals.circle_color:get()
    local indicator_length = 45 / 360
    

    render.circle_outline(vector(cx, cy), bg_color, radius, 0, 0.5, thickness)
    

    local manual_selection = ui_antiaim_main.manuals:get()
    local base_angle = 0
    
    if manual_selection == "Disabled" then
        base_angle = 70
    elseif manual_selection == "Left" then
        base_angle = 135
    elseif manual_selection == "Right" then
        base_angle = 0
    elseif manual_selection == "Forward" then
        base_angle = 70
    end
    

    local compensation = 45 / 2
    local target_angle = base_angle + compensation
    

    vis_state.circle_target_angle = target_angle
    vis_state.circle_current_angle = crimson_smooth(vis_state.circle_current_angle, vis_state.circle_target_angle, 8)
    

    local half_length = indicator_length / 2
    local center_angle = vis_state.circle_current_angle
    local start_angle = center_angle - half_length * 360
    

    render.circle_outline(vector(cx, cy), indicator_color, radius, start_angle, indicator_length, thickness)
end

local function render_watermark()

    if intro_state.active then return end
    
    if not watermark_state.initialized then
        local screen = render.screen_size()
        watermark_state.position = get_stored_coords("wmark", screen.x / 2, screen.y - 20)
        watermark_state.initialized = true
    end
    

    local interval = 18
    watermark_state.frame_index = math.floor(globals.tickcount / interval) % #watermark_frames + 1
    

    local text = watermark_frames[watermark_state.frame_index]
    
    local measure_text = text ~= "" and text or "Emptiness"
    local text_size = render.measure_text(4, "", measure_text)
    local half_w, half_h = text_size.x / 2, text_size.y / 2
    local padding = 6
    
    if text ~= "" then
        local light_blue_purple = color(150, 180, 255, 255)
        render_crimson_watermark(4, watermark_state.position, text, "c", light_blue_purple)
    end
    
    local in_menu = pui.get_alpha() > 0
    if in_menu then
        local mouse = pui.get_mouse_position()
        

        local function get_bounds()
            return {
                x1 = watermark_state.position.x - half_w - padding,
                y1 = watermark_state.position.y - half_h - padding,
                x2 = watermark_state.position.x + half_w + padding,
                y2 = watermark_state.position.y + half_h + padding
            }
        end
        
        local bounds = get_bounds()
        watermark_state.hover = mouse.x >= bounds.x1 and mouse.x <= bounds.x2 and mouse.y >= bounds.y1 and mouse.y <= bounds.y2
        

        if common.is_button_down(1) and watermark_state.hover and not watermark_state.dragging then
            watermark_state.dragging = true
            watermark_state.drag_offset = {
                x = mouse.x - watermark_state.position.x,
                y = mouse.y - watermark_state.position.y
            }
        end
        

        if common.is_button_released(1) and watermark_state.dragging then
            watermark_state.dragging = false
            store_coords("wmark", watermark_state.position)
        end
        

        if watermark_state.dragging then
            local new_pos = vector(
                mouse.x - watermark_state.drag_offset.x,
                mouse.y - watermark_state.drag_offset.y
            )
            

            local screen = render.screen_size()
            local center_x = screen.x / 2
            local center_y = screen.y / 2
            
            if math.abs(new_pos.x - center_x) < watermark_state.snap_threshold then
                new_pos.x = center_x
            end
            if math.abs(new_pos.y - center_y) < watermark_state.snap_threshold then
                new_pos.y = center_y
            end
            
            watermark_state.position = new_pos
            

            local dist_x = math.abs(watermark_state.position.x - center_x)
            local dist_y = math.abs(watermark_state.position.y - center_y)
            local threshold = 100
            
            if dist_y < threshold then
                local alpha_h = math.max(0, 255 - dist_y / threshold * 255)
                render.line(
                    vector(watermark_state.position.x - half_w, center_y),
                    vector(watermark_state.position.x + half_w, center_y),
                    color(255, 255, 255, alpha_h)
                )
            end
            
            if dist_x < threshold then
                local alpha_v = math.max(0, 255 - dist_x / threshold * 255)
                render.line(
                    vector(center_x, watermark_state.position.y - half_h),
                    vector(center_x, watermark_state.position.y + half_h),
                    color(255, 255, 255, alpha_v)
                )
            end
            

            bounds = get_bounds()
            render.rect(vector(bounds.x1, bounds.y1), vector(bounds.x2, bounds.y2), color(255, 255, 255, 40), 4)
        elseif watermark_state.hover then

            render.rect(vector(bounds.x1, bounds.y1), vector(bounds.x2, bounds.y2), color(255, 255, 255, 20), 4)
        end
    end
end



local function handle_dragging()
    local in_menu = pui.get_alpha() > 0
    if not in_menu then return end
    
    local mouse = pui.get_mouse_position()
    local mouse_down = common.is_button_down(1)
    local mouse_released = common.is_button_released(1)
    

    if ui_visuals.damage_indicator:get() and vis_state.dmg_pos then
        local pos = vis_state.dmg_pos
        local dmg = tostring(ui_refs.mindamage:get())
        local font_choice = ui_visuals.dmg_font:get()
        local font_id = 1  -- Default to Font 1
        if font_choice == "Font 1" then font_id = 1
        elseif font_choice == "Font 2" then font_id = 2
        elseif font_choice == "Font 3" then font_id = 3
        elseif font_choice == "Font 4" then font_id = 4
        end
        local size = render.measure_text(font_id, nil, dmg)
        local x1, y1 = pos.x - size.x/2 - 5, pos.y - size.y/2 - 3
        local x2, y2 = pos.x + size.x/2 + 5, pos.y + size.y/2 + 3
        local hovering = mouse.x >= x1 and mouse.x <= x2 and mouse.y >= y1 and mouse.y <= y2
        
        if hovering and mouse_down and not vis_state.dmg_drag.dragging then
            vis_state.dmg_drag.dragging = true
            vis_state.dmg_drag.offset = vector(mouse.x - pos.x, mouse.y - pos.y)
        end
        
        if vis_state.dmg_drag.dragging then
            if mouse_down then
                vis_state.dmg_pos = vector(mouse.x - vis_state.dmg_drag.offset.x, mouse.y - vis_state.dmg_drag.offset.y)
            else
                vis_state.dmg_drag.dragging = false
                store_coords("dmg_ind", vis_state.dmg_pos)
            end
        end
    end
    

    if ui_visuals.defensive_indicator:get() and vis_state.def_pos then
        local pos = vis_state.def_pos
        local x1, y1 = pos.x - 57, pos.y - 16
        local x2, y2 = pos.x + 57, pos.y + 7
        local hovering = mouse.x >= x1 and mouse.x <= x2 and mouse.y >= y1 and mouse.y <= y2
        
        if hovering and mouse_down and not vis_state.def_drag.dragging then
            vis_state.def_drag.dragging = true
            vis_state.def_drag.offset = vector(mouse.x - pos.x, mouse.y - pos.y)
        end
        
        if vis_state.def_drag.dragging then
            if mouse_down then
                vis_state.def_pos = vector(mouse.x - vis_state.def_drag.offset.x, mouse.y - vis_state.def_drag.offset.y)
            else
                vis_state.def_drag.dragging = false
                store_coords("def_ind", vis_state.def_pos)
            end
        end
    end
    

    if ui_visuals.slowdown_indicator:get() and vis_state.slow_pos then
        local pos = vis_state.slow_pos
        local x1, y1 = pos.x - 57, pos.y - 16
        local x2, y2 = pos.x + 57, pos.y + 7
        local hovering = mouse.x >= x1 and mouse.x <= x2 and mouse.y >= y1 and mouse.y <= y2
        
        if hovering and mouse_down and not vis_state.slow_drag.dragging then
            vis_state.slow_drag.dragging = true
            vis_state.slow_drag.offset = vector(mouse.x - pos.x, mouse.y - pos.y)
        end
        
        if vis_state.slow_drag.dragging then
            if mouse_down then
                vis_state.slow_pos = vector(mouse.x - vis_state.slow_drag.offset.x, mouse.y - vis_state.slow_drag.offset.y)
            else
                vis_state.slow_drag.dragging = false
                store_coords("slow_ind", vis_state.slow_pos)
            end
        end
    end
    
    
    if ui_visuals.oof_arrows:get() and vis_state.oof_pos then
        local pos = vis_state.oof_pos
        local x1, y1 = pos.x - 30, pos.y - 30
        local x2, y2 = pos.x + 30, pos.y + 30
        local hovering = mouse.x >= x1 and mouse.x <= x2 and mouse.y >= y1 and mouse.y <= y2
        
        if hovering and mouse_down and not vis_state.oof_drag.dragging then
            vis_state.oof_drag.dragging = true
            vis_state.oof_drag.offset = vector(mouse.x - pos.x, mouse.y - pos.y)
        end
        
        if vis_state.oof_drag.dragging then
            if mouse_down then
                vis_state.oof_pos = vector(mouse.x - vis_state.oof_drag.offset.x, mouse.y - vis_state.oof_drag.offset.y)
            else
                vis_state.oof_drag.dragging = false
                store_coords("oof_arrows", vis_state.oof_pos)
            end
        end
    end
end


local dynamic_fov_state = {
    base_fov = 90,
    animated_fov = 90,
    desired_fov = 90,
    scope_active = false,
    previous_scope_state = false,
    transition_active = false,
    transition_progress = 0
}

local thirdperson_fov_state = {
    base_fov = 90,
    animated_fov = 90,
    desired_fov = 90,
    active = false,
    previous_state = false,
    transition_active = false
}

-- Viewmodel开镜动画状态
local vm_scope_state = {
    -- FOV
    base_fov = 68,
    animated_fov = 68,
    target_fov = 68,
    
    -- X Offset
    base_x_offset = 2.5,
    animated_x_offset = 2.5,
    target_x_offset = 2.5,
    
    -- Y Offset
    base_y_offset = 0,
    animated_y_offset = 0,
    target_y_offset = 0,
    
    -- Z Offset
    base_z_offset = -1.5,
    animated_z_offset = -1.5,
    target_z_offset = -1.5,
    
    -- 状态控制
    scope_active = false,
    previous_scope_state = false,
    animation_active = false,
    disable_animation = false  -- 关闭功能时的恢复动画
}

local function calculate_fov_transition(current, target, velocity)
    local difference = target - current
    if math.abs(difference) < 0.1 then
        return target
    end
    

    local step = velocity * globals.frametime * 60
    
    if difference > 0 then
        return math.min(current + step, target)
    else
        return math.max(current - step, target)
    end
end

local function update_thirdperson_zoom()
    if not ui_visuals.thirdperson_zoom:get() or not ui_refs.thirdperson then
        if thirdperson_fov_state.active or thirdperson_fov_state.transition_active then
            ui_refs.thirdperson_distance:override()
        end
        thirdperson_fov_state.active = false
        thirdperson_fov_state.previous_state = false
        thirdperson_fov_state.transition_active = false
        return false
    end

    local player = entity.get_local_player()
    if not player or not player:is_alive() then
        if thirdperson_fov_state.active or thirdperson_fov_state.transition_active then
            ui_refs.thirdperson_distance:override()
        end
        thirdperson_fov_state.active = false
        thirdperson_fov_state.previous_state = false
        thirdperson_fov_state.transition_active = false
        return false
    end

    local thirdperson_state = false
    local status = ui_refs.thirdperson:get()
    if type(status) == "table" then
        thirdperson_state = status[1] and true or false
    else
        thirdperson_state = status and true or false
    end

    if thirdperson_state ~= thirdperson_fov_state.previous_state then
        if thirdperson_state then
            thirdperson_fov_state.base_fov = 0
            thirdperson_fov_state.animated_fov = thirdperson_fov_state.base_fov
            thirdperson_fov_state.desired_fov = ui_refs.thirdperson_distance:get()
        else
            thirdperson_fov_state.base_fov = ui_refs.thirdperson_distance:get()
            thirdperson_fov_state.animated_fov = thirdperson_fov_state.base_fov
            thirdperson_fov_state.desired_fov = 0
        end
        thirdperson_fov_state.transition_active = true
    end

    if thirdperson_fov_state.transition_active then
        local animation_rate = ui_visuals.thirdperson_zoom_speed:get() * 0.5
        thirdperson_fov_state.animated_fov = calculate_fov_transition(
            thirdperson_fov_state.animated_fov,
            thirdperson_fov_state.desired_fov,
            animation_rate
        )

        if math.abs(thirdperson_fov_state.animated_fov - thirdperson_fov_state.desired_fov) < 0.01 then
            thirdperson_fov_state.animated_fov = thirdperson_fov_state.desired_fov
            thirdperson_fov_state.transition_active = false

            if not thirdperson_state then
                ui_refs.thirdperson_distance:override(0)
                thirdperson_fov_state.active = false
                thirdperson_fov_state.previous_state = thirdperson_state
                return false
            end
        end

        local final_value = math.floor(thirdperson_fov_state.animated_fov + 0.5)
        ui_refs.thirdperson_distance:override(final_value)
        thirdperson_fov_state.active = true
    elseif thirdperson_state and not thirdperson_fov_state.active then
        thirdperson_fov_state.desired_fov = ui_refs.thirdperson_distance:get()
        thirdperson_fov_state.transition_active = true
    end

    thirdperson_fov_state.previous_state = thirdperson_state
    return thirdperson_state or thirdperson_fov_state.active or thirdperson_fov_state.transition_active
end

local function update_dynamic_zoom()
    if not ui_visuals.dynamic_zoom:get() then

        if dynamic_fov_state.transition_active then
            ui_refs.fov:override()
            dynamic_fov_state.transition_active = false
        end
        return    
    end
    
    local player = entity.get_local_player()
    if not player or not player:is_alive() then
        dynamic_fov_state.scope_active = false
        dynamic_fov_state.previous_scope_state = false
        if dynamic_fov_state.transition_active then
            ui_refs.fov:override()
            dynamic_fov_state.transition_active = false
        end
        return
    end
    
    dynamic_fov_state.scope_active = player.m_bIsScoped
    

    if dynamic_fov_state.scope_active ~= dynamic_fov_state.previous_scope_state then
        if dynamic_fov_state.scope_active then

            dynamic_fov_state.base_fov = ui_refs.fov:get()
            dynamic_fov_state.animated_fov = dynamic_fov_state.base_fov
            local reduction = ui_visuals.zoom_boost:get()
            local min_fov = math.max(30, dynamic_fov_state.base_fov - reduction)
            dynamic_fov_state.desired_fov = math.min(135, min_fov)
            dynamic_fov_state.transition_active = true
        else

            dynamic_fov_state.desired_fov = dynamic_fov_state.base_fov
            dynamic_fov_state.transition_active = true
        end
    end
    

    if dynamic_fov_state.transition_active then
        local animation_rate = ui_visuals.zoom_speed:get() * 0.5
        

        dynamic_fov_state.animated_fov = calculate_fov_transition(
            dynamic_fov_state.animated_fov, 
            dynamic_fov_state.desired_fov, 
            animation_rate
        )
        

        if math.abs(dynamic_fov_state.animated_fov - dynamic_fov_state.desired_fov) < 0.01 then
            dynamic_fov_state.animated_fov = dynamic_fov_state.desired_fov
            dynamic_fov_state.transition_active = false
            

            if not dynamic_fov_state.scope_active then
                ui_refs.fov:override()
                dynamic_fov_state.previous_scope_state = dynamic_fov_state.scope_active
                return
            end
        end
        
        local final_fov_value = math.floor(dynamic_fov_state.animated_fov + 0.5)
        ui_refs.fov:override(final_fov_value)
    end
    
    dynamic_fov_state.previous_scope_state = dynamic_fov_state.scope_active
end

-- Viewmodel开镜动画更新函数
local function update_vm_scope_animation()
    -- Force Viewmodel 覆盖逻辑
    if ui_visuals.viewmodel:get() and ui_visuals.vm_scope_animation:get() then
        if ui_refs.force_viewmodel then ui_refs.force_viewmodel:override(true) end
    else
        if ui_refs.force_viewmodel then ui_refs.force_viewmodel:override() end
    end
    
    if not ui_visuals.viewmodel:get() or not ui_visuals.vm_scope_animation:get() then
        -- 功能关闭时触发恢复动画
        if (vm_scope_state.animation_active or vm_scope_state.scope_active) and not vm_scope_state.disable_animation then
            vm_scope_state.disable_animation = true
            vm_scope_state.target_fov = ui_visuals.vm_fov:get()
            vm_scope_state.target_x_offset = ui_visuals.vm_x:get()
            vm_scope_state.target_y_offset = ui_visuals.vm_y:get()
            vm_scope_state.target_z_offset = ui_visuals.vm_z:get()
            
            -- 设置当前动画值（如果还没开始过动画，使用开镜值作为起始点）
            if not vm_scope_state.animation_active then
                vm_scope_state.animated_fov = ui_visuals.vm_scope_fov:get()
                vm_scope_state.animated_x_offset = ui_visuals.vm_scope_x:get()
                vm_scope_state.animated_y_offset = ui_visuals.vm_scope_y:get()
                vm_scope_state.animated_z_offset = ui_visuals.vm_scope_z:get()
            end
            
            vm_scope_state.animation_active = true  -- 启动恢复动画
        elseif not vm_scope_state.disable_animation then
            return
        end
    else
        vm_scope_state.disable_animation = false
    end
    
    local player = entity.get_local_player()
    if not player or not player:is_alive() then
        vm_scope_state.scope_active = false
        vm_scope_state.previous_scope_state = false
        if vm_scope_state.animation_active then
            vm_scope_state.animation_active = false
            vm_scope_state.animated_fov = vm_scope_state.base_fov
            vm_scope_state.animated_x_offset = vm_scope_state.base_x_offset
            vm_scope_state.animated_y_offset = vm_scope_state.base_y_offset
            vm_scope_state.animated_z_offset = vm_scope_state.base_z_offset
        end
        return
    end
    
    -- 检测开镜状态（只有在功能启用时才检测）
    if not vm_scope_state.disable_animation then
        vm_scope_state.scope_active = player.m_bIsScoped
    end
    
    -- 开镜状态变化时触发动画（但不包括功能关闭时的恢复动画）
    if vm_scope_state.scope_active ~= vm_scope_state.previous_scope_state and not vm_scope_state.disable_animation then
        -- 保存当前用户设置值作为基础值
        vm_scope_state.base_fov = ui_visuals.vm_fov:get()
        vm_scope_state.base_x_offset = ui_visuals.vm_x:get()
        vm_scope_state.base_y_offset = ui_visuals.vm_y:get()
        vm_scope_state.base_z_offset = ui_visuals.vm_z:get()
        
        if vm_scope_state.scope_active then
            -- 开镜：从用户设置值动画到开镜值
            vm_scope_state.animated_fov = vm_scope_state.base_fov
            vm_scope_state.animated_x_offset = vm_scope_state.base_x_offset
            vm_scope_state.animated_y_offset = vm_scope_state.base_y_offset
            vm_scope_state.animated_z_offset = vm_scope_state.base_z_offset
            
            vm_scope_state.target_fov = ui_visuals.vm_scope_fov:get()
            vm_scope_state.target_x_offset = ui_visuals.vm_scope_x:get()
            vm_scope_state.target_y_offset = ui_visuals.vm_scope_y:get()
            vm_scope_state.target_z_offset = ui_visuals.vm_scope_z:get()
        else
            -- 取消开镜：从开镜值动画回到用户设置值
            vm_scope_state.animated_fov = ui_visuals.vm_scope_fov:get()
            vm_scope_state.animated_x_offset = ui_visuals.vm_scope_x:get()
            vm_scope_state.animated_y_offset = ui_visuals.vm_scope_y:get()
            vm_scope_state.animated_z_offset = ui_visuals.vm_scope_z:get()
            
            vm_scope_state.target_fov = vm_scope_state.base_fov
            vm_scope_state.target_x_offset = vm_scope_state.base_x_offset
            vm_scope_state.target_y_offset = vm_scope_state.base_y_offset
            vm_scope_state.target_z_offset = vm_scope_state.base_z_offset
        end
        
        vm_scope_state.animation_active = true
        vm_scope_state.previous_scope_state = vm_scope_state.scope_active
    end
    
    -- 执行动画
    if vm_scope_state.animation_active then
        local animation_speed = ui_visuals.vm_scope_speed:get() * 0.5
        
        -- 对所有参数执行平滑过渡
        vm_scope_state.animated_fov = calculate_fov_transition(
            vm_scope_state.animated_fov,
            vm_scope_state.target_fov,
            animation_speed
        )
        
        vm_scope_state.animated_x_offset = calculate_fov_transition(
            vm_scope_state.animated_x_offset,
            vm_scope_state.target_x_offset,
            animation_speed
        )
        
        vm_scope_state.animated_y_offset = calculate_fov_transition(
            vm_scope_state.animated_y_offset,
            vm_scope_state.target_y_offset,
            animation_speed
        )
        
        vm_scope_state.animated_z_offset = calculate_fov_transition(
            vm_scope_state.animated_z_offset,
            vm_scope_state.target_z_offset,
            animation_speed
        )
        
        -- 检查所有动画是否完成
        local fov_done = math.abs(vm_scope_state.animated_fov - vm_scope_state.target_fov) < 0.01
        local x_done = math.abs(vm_scope_state.animated_x_offset - vm_scope_state.target_x_offset) < 0.01
        local y_done = math.abs(vm_scope_state.animated_y_offset - vm_scope_state.target_y_offset) < 0.01
        local z_done = math.abs(vm_scope_state.animated_z_offset - vm_scope_state.target_z_offset) < 0.01
        
        if fov_done and x_done and y_done and z_done then
            vm_scope_state.animated_fov = vm_scope_state.target_fov
            vm_scope_state.animated_x_offset = vm_scope_state.target_x_offset
            vm_scope_state.animated_y_offset = vm_scope_state.target_y_offset
            vm_scope_state.animated_z_offset = vm_scope_state.target_z_offset
            vm_scope_state.animation_active = false
            
            -- 如果是关闭功能的恢复动画完成，完全重置状态
            if vm_scope_state.disable_animation then
                vm_scope_state.disable_animation = false
                vm_scope_state.scope_active = false
                vm_scope_state.previous_scope_state = false
            end
        end
    end
end

local function render_scope_lines()
    if not ui_visuals.scope_lines:get() then return end
    local lp = entity.get_local_player()
    if not lp or not lp:is_alive() or not lp.m_bIsScoped then return end
    
    local screen = render.screen_size()
    local cx, cy = screen.x / 2, screen.y / 2
    local len = ui_visuals.scope_length:get()
    local gap = ui_visuals.scope_gap:get()
    local col = ui_visuals.scope_color:get()
    
    if not ui_visuals.chaos_mode:get() then

        local fade_color = color(col.r, col.g, col.b, 0)
        local solid_color = color(col.r, col.g, col.b, col.a)
        
        local reverse = ui_visuals.scope_reverse:get()
        
        if reverse then

            render.gradient(vector(cx, cy - gap - len), vector(cx + 1, cy - gap), solid_color, solid_color, fade_color, fade_color)
            render.gradient(vector(cx, cy + gap), vector(cx + 1, cy + gap + len), fade_color, fade_color, solid_color, solid_color)
            render.gradient(vector(cx - gap - len, cy), vector(cx - gap, cy + 1), solid_color, fade_color, solid_color, fade_color)
            render.gradient(vector(cx + gap, cy), vector(cx + gap + len, cy + 1), fade_color, solid_color, fade_color, solid_color)
        else

            render.gradient(vector(cx, cy - gap - len), vector(cx + 1, cy - gap), fade_color, fade_color, solid_color, solid_color)
            render.gradient(vector(cx, cy + gap), vector(cx + 1, cy + gap + len), solid_color, solid_color, fade_color, fade_color)
            render.gradient(vector(cx - gap - len, cy), vector(cx - gap, cy + 1), fade_color, solid_color, fade_color, solid_color)
            render.gradient(vector(cx + gap, cy), vector(cx + gap + len, cy + 1), solid_color, fade_color, solid_color, fade_color)
        end
        return
    end
    

    local time = globals.realtime
    local dt = globals.frametime
    

    vis_state.chaos_rotation = (vis_state.chaos_rotation + 500 * dt) % 360
    

    local r = (math.sin(time * 3) * 127.5 + 127.5)
    local g = (math.sin(time * 3 + 2.094) * 127.5 + 127.5)
    local b = (math.sin(time * 3 + 4.188) * 127.5 + 127.5)
    vis_state.chaos_last_r = r
    vis_state.chaos_last_g = g
    vis_state.chaos_last_b = b
    

    if math.random() < 0.3 then
        vis_state.chaos_seizure_x = math.random(-30, 30)
        vis_state.chaos_seizure_y = math.random(-30, 30)
    else
        vis_state.chaos_seizure_x = vis_state.chaos_seizure_x * 0.8
        vis_state.chaos_seizure_y = vis_state.chaos_seizure_y * 0.8
    end
    

    vis_state.chaos_quantum_timer = vis_state.chaos_quantum_timer + dt
    if vis_state.chaos_quantum_timer > math.random(0.2, 0.6) then
        vis_state.chaos_quantum_x = math.random(-100, 100)
        vis_state.chaos_quantum_y = math.random(-100, 100)
        vis_state.chaos_quantum_timer = 0
    end
    

    local center_x = cx + vis_state.chaos_seizure_x + vis_state.chaos_quantum_x
    local center_y = cy + vis_state.chaos_seizure_y + vis_state.chaos_quantum_y
    

    local size_wave1 = math.sin(time * 5) * 200
    local size_wave2 = math.cos(time * 7.3) * 150
    len = len + size_wave1 + size_wave2
    

    local gap_wave = math.sin(time * 8) * 100
    gap = gap + gap_wave
    

    for i, base_angle in ipairs(vis_state.chaos_multiply_angles) do
        local angle_offset = base_angle + vis_state.chaos_rotation * i * 0.7
        

        local color_offset = (i - 1) * 0.8
        local chaos_r = (math.sin(time * 3 + color_offset) * 127.5 + 127.5)
        local chaos_g = (math.sin(time * 3 + color_offset + 2.094) * 127.5 + 127.5)
        local chaos_b = (math.sin(time * 3 + color_offset + 4.188) * 127.5 + 127.5)
        

        local alpha = math.random(150, 255)
        
        local fade_color = color(chaos_r, chaos_g, chaos_b, 0)
        local solid_color = color(chaos_r, chaos_g, chaos_b, alpha)
        

        render.push_rotation(angle_offset, vector(center_x, center_y))
        

        local line_len_1 = len + math.sin(time * 10 + i) * 80
        local line_len_2 = len + math.cos(time * 12 - i) * 80
        local line_len_3 = len + math.sin(time * 15 + i * 2) * 80
        local line_len_4 = len + math.cos(time * 9 - i * 3) * 80
        
        render.gradient(vector(center_x, center_y - gap - line_len_1), vector(center_x + 2, center_y - gap), fade_color, fade_color, solid_color, solid_color)
        render.gradient(vector(center_x, center_y + gap), vector(center_x + 2, center_y + gap + line_len_2), solid_color, solid_color, fade_color, fade_color)
        render.gradient(vector(center_x - gap - line_len_3, center_y), vector(center_x - gap, center_y + 2), fade_color, solid_color, fade_color, solid_color)
        render.gradient(vector(center_x + gap, center_y), vector(center_x + gap + line_len_4, center_y + 2), solid_color, fade_color, solid_color, fade_color)
        
        render.pop_rotation()
    end
    

    local emojis = {"💀", "🤡", "😂", "🎪", "👻", "🔥", "⚡", "✨"}
    vis_state.chaos_emoji_timer = vis_state.chaos_emoji_timer + dt
    if vis_state.chaos_emoji_timer > 0.2 then
        vis_state.chaos_emoji_index = (vis_state.chaos_emoji_index % #emojis) + 1
        vis_state.chaos_emoji_timer = 0
    end
    
    local emoji = emojis[vis_state.chaos_emoji_index]
    local emoji_color = color(vis_state.chaos_last_r, vis_state.chaos_last_g, vis_state.chaos_last_b, 255)
    render.text(4, vector(cx, cy - 15), emoji_color, "c", emoji)
end


local hit_marker_state = {
    markers = {},
    hitbox_map = {
        [0] = 2, [1] = 1, [2] = 2, [3] = 3,
        [4] = 13, [5] = 17, [6] = 7, [7] = 8, [8] = 1
    },
    crosshair_active = false,
    crosshair_birth_time = 0
}


local world_damage_state = {
    damage_markers = {}
}


local mystery_kill_hit_state = {
    active = false,
    start_time = 0,
    duration = 4.0,
    image_index = nil,
    sound_index = nil,
    sound_played = false
}

local mystery_kill_death_state = {
    active = false,
    start_time = 0,
    duration = 4.0,
    image_index = nil,
    sound_index = nil,
    sound_played = false
}

local kill_effects_resources = {
    phonk_images = {},
    phonk_image_size = vector(320, 320),
    phonk_loaded = false,
    dead_image = nil,
    dead_loaded = false
}

local function load_phonk_images()
    if kill_effects_resources.phonk_loaded then return end
    
    for i = 1, 23 do
        local path = string.format("nl\\Crimson\\phonk%d.png", i)
        local ok, img = pcall(render.load_image_from_file, path, kill_effects_resources.phonk_image_size)
        if ok and img then
            kill_effects_resources.phonk_images[i] = img
        end
    end
    
    kill_effects_resources.phonk_loaded = true
end

local function load_dead_image()
    if kill_effects_resources.dead_loaded then return end
    
    local screen = render.screen_size()
    local ok, img = pcall(render.load_image_from_file, "nl\\Crimson\\dead.png", screen)
    if ok and img then
        kill_effects_resources.dead_image = img
    end
    
    kill_effects_resources.dead_loaded = true
end

local function play_mystery_sound(index)
    if not index then return end
    local volume_slider = ui_visuals.mystery_killmarks_volume and ui_visuals.mystery_killmarks_volume:get() or 100
    local volume = math.max(0, math.min(100, volume_slider)) / 100
    local cmd = string.format("playvol crimson/ef%d.mp3 %g", index, volume)
    utils.console_exec(cmd)
end

local function play_death_sound()
    local volume_slider = ui_visuals.mystery_killmarks_volume and ui_visuals.mystery_killmarks_volume:get() or 100
    local volume = math.max(0, math.min(100, volume_slider)) / 100
    local cmd = string.format("playvol crimson/dead4.wav %g", volume)
    utils.console_exec(cmd)
end

local function trigger_mystery_hit_effect()
    load_phonk_images()
    
    if #kill_effects_resources.phonk_images == 0 then return end
    
    mystery_kill_hit_state.active = true
    mystery_kill_hit_state.start_time = globals.realtime
    mystery_kill_hit_state.duration = 4.0
    mystery_kill_hit_state.image_index = math.random(1, 23)
    mystery_kill_hit_state.sound_index = math.random(1, 11)
    mystery_kill_hit_state.sound_played = false
end

local function trigger_mystery_death_effect()
    load_dead_image()
    
    if not kill_effects_resources.dead_image then return end
    
    mystery_kill_death_state.active = true
    mystery_kill_death_state.start_time = globals.realtime
    mystery_kill_death_state.duration = 4.0
    mystery_kill_death_state.sound_played = false
end

local function render_mystery_kill_effects()
    if not ui_visuals.mystery_killmarks:get() then return end
    
    if not kill_effects_resources.phonk_loaded then
        load_phonk_images()
    end
    
    if #kill_effects_resources.phonk_images == 0 then return end
    
    local now = globals.realtime
    local screen = render.screen_size()
    local death_enabled = ui_visuals.mystery_killmarks_death and ui_visuals.mystery_killmarks_death:get()
    local hit_enabled = ui_visuals.mystery_killmarks_hit and ui_visuals.mystery_killmarks_hit:get()
    local miss_enabled = ui_visuals.mystery_killmarks_miss and ui_visuals.mystery_killmarks_miss:get()
    
    if mystery_kill_death_state.active and death_enabled then
        local elapsed = now - mystery_kill_death_state.start_time
        if elapsed <= mystery_kill_death_state.duration then
            if not mystery_kill_death_state.sound_played then
                play_death_sound()
                mystery_kill_death_state.sound_played = true
            end
            

            local alpha = math.floor(255 * (1 - elapsed / mystery_kill_death_state.duration))
            if alpha < 0 then alpha = 0 end
            

            local bg_alpha = math.floor(150 * (1 - elapsed / mystery_kill_death_state.duration))
            if bg_alpha < 0 then bg_alpha = 0 end
            render.rect(vector(0, 0), screen, color(0, 0, 0, bg_alpha))
            
            if kill_effects_resources.dead_image then
                render.texture(kill_effects_resources.dead_image, vector(0, 0), screen, color(255, 255, 255, alpha))
            end
        else
            mystery_kill_death_state.active = false
        end
    elseif mystery_kill_hit_state.active and (hit_enabled or miss_enabled) then
        local elapsed = now - mystery_kill_hit_state.start_time
        if elapsed <= mystery_kill_hit_state.duration then
            if not mystery_kill_hit_state.sound_played and mystery_kill_hit_state.sound_index then
                play_mystery_sound(mystery_kill_hit_state.sound_index)
                mystery_kill_hit_state.sound_played = true
            end
            
            local idx = mystery_kill_hit_state.image_index
            local tex = idx and kill_effects_resources.phonk_images[idx]
            if tex then
                local pos = vector(
                    screen.x / 2 - kill_effects_resources.phonk_image_size.x / 2,
                    screen.y - kill_effects_resources.phonk_image_size.y - 30
                )
                
                local alpha = math.floor(255 * (1 - elapsed / mystery_kill_hit_state.duration))
                if alpha < 0 then alpha = 0 end
                
                render.texture(tex, pos, kill_effects_resources.phonk_image_size, color(255, 255, 255, alpha))
            end
        else
            mystery_kill_hit_state.active = false
        end
    end
end

local function render_hit_markers()

    if ui_refs.hit_marker then
        if ui_visuals.hit_marker:get() then

            ui_refs.hit_marker:override(false)
        else

            ui_refs.hit_marker:override()
        end
    end
    
    if not ui_visuals.hit_marker:get() then return end
    
    local current_time = globals.realtime
    local duration = ui_visuals.hit_duration:get() / 10
    local size = ui_visuals.hit_size:get()
    local gap = ui_visuals.hit_gap:get()
    local base_color = ui_visuals.hit_color:get()
    
    for i = #hit_marker_state.markers, 1, -1 do
        local marker = hit_marker_state.markers[i]
        local age = current_time - marker.birth_time
        
        if age > duration then
            table.remove(hit_marker_state.markers, i)
        else
            local screen_pos = marker.world_pos:to_screen()
            if screen_pos then
                local fade_alpha = math.floor(255 * (1 - age / duration))
                local fade_color = color(base_color.r, base_color.g, base_color.b, 0)
                local solid_color = color(base_color.r, base_color.g, base_color.b, fade_alpha)
                
                local cx, cy = screen_pos.x, screen_pos.y
                
                for i = 0, size do
                    local alpha_ratio = 1 - (i / size)
                    local line_alpha = math.floor(fade_alpha * alpha_ratio)
                    local line_color = color(base_color.r, base_color.g, base_color.b, line_alpha)
                    

                    render.rect(vector(cx - gap - i, cy - gap - i), vector(cx - gap - i + 1, cy - gap - i + 1), line_color)
                    render.rect(vector(cx + gap + i, cy - gap - i), vector(cx + gap + i + 1, cy - gap - i + 1), line_color)
                    render.rect(vector(cx - gap - i, cy + gap + i), vector(cx - gap - i + 1, cy + gap + i + 1), line_color)
                    render.rect(vector(cx + gap + i, cy + gap + i), vector(cx + gap + i + 1, cy + gap + i + 1), line_color)
                    

                    local shadow_range = ui_visuals.hit_shadow_range:get() / 100
                    local shadow_max_distance = size * shadow_range
                    if i <= shadow_max_distance then
                        local shadow_opacity = ui_visuals.hit_shadow_opacity:get() / 100
                        local shadow_alpha = math.floor(line_alpha * shadow_opacity)
                        local shadow_color = color(base_color.r, base_color.g, base_color.b, shadow_alpha)
                        

                        local start1 = vector(cx - gap - i, cy - gap - i)
                        local end1 = vector(cx - gap - i - 1, cy - gap - i - 1)
                        render.shadow(start1, end1, shadow_color)
                        

                        local start2 = vector(cx + gap + i, cy - gap - i)
                        local end2 = vector(cx + gap + i + 1, cy - gap - i - 1)
                        render.shadow(start2, end2, shadow_color)
                        

                        local start3 = vector(cx - gap - i, cy + gap + i)
                        local end3 = vector(cx - gap - i - 1, cy + gap + i + 1)
                        render.shadow(start3, end3, shadow_color)
                        

                        local start4 = vector(cx + gap + i, cy + gap + i)
                        local end4 = vector(cx + gap + i + 1, cy + gap + i + 1)
                        render.shadow(start4, end4, shadow_color)
                    end
                end
            end
        end
    end
    

    if ui_visuals.hit_crosshair:get() and hit_marker_state.crosshair_active then
        local screen = render.screen_size()
        local cx, cy = screen.x / 2, screen.y / 2
        
        local age = current_time - hit_marker_state.crosshair_birth_time
        local fade_alpha = math.floor(255 * (1 - age / duration))
        

        local crosshair_size = size * 2
        local crosshair_gap = gap * 2
        
        for i = 0, crosshair_size do
            local alpha_ratio = 1 - (i / crosshair_size)
            local line_alpha = math.floor(fade_alpha * alpha_ratio)
            local line_color = color(base_color.r, base_color.g, base_color.b, line_alpha)
            

            render.rect(vector(cx - crosshair_gap - i, cy - crosshair_gap - i), vector(cx - crosshair_gap - i + 1, cy - crosshair_gap - i + 1), line_color)
            render.rect(vector(cx + crosshair_gap + i, cy - crosshair_gap - i), vector(cx + crosshair_gap + i + 1, cy - crosshair_gap - i + 1), line_color)
            render.rect(vector(cx - crosshair_gap - i, cy + crosshair_gap + i), vector(cx - crosshair_gap - i + 1, cy + crosshair_gap + i + 1), line_color)
            render.rect(vector(cx + crosshair_gap + i, cy + crosshair_gap + i), vector(cx + crosshair_gap + i + 1, cy + crosshair_gap + i + 1), line_color)
            

            local shadow_range = ui_visuals.hit_shadow_range:get() / 100
            local shadow_max_distance = crosshair_size * shadow_range
            if i <= shadow_max_distance then
                local shadow_opacity = ui_visuals.hit_shadow_opacity:get() / 100
                local shadow_alpha = math.floor(line_alpha * shadow_opacity)
                local shadow_color = color(base_color.r, base_color.g, base_color.b, shadow_alpha)
                

                render.shadow(vector(cx - crosshair_gap - i, cy - crosshair_gap - i), vector(cx - crosshair_gap - i - 1, cy - crosshair_gap - i - 1), shadow_color)
                render.shadow(vector(cx + crosshair_gap + i, cy - crosshair_gap - i), vector(cx + crosshair_gap + i + 1, cy - crosshair_gap - i - 1), shadow_color)
                render.shadow(vector(cx - crosshair_gap - i, cy + crosshair_gap + i), vector(cx - crosshair_gap - i - 1, cy + crosshair_gap + i + 1), shadow_color)
                render.shadow(vector(cx + crosshair_gap + i, cy + crosshair_gap + i), vector(cx + crosshair_gap + i + 1, cy + crosshair_gap + i + 1), shadow_color)
            end
        end
        

        if age > duration then
            hit_marker_state.crosshair_active = false
        end
    end
end


local function render_world_damage()

    if ui_refs.damage_marker then
        if ui_visuals.world_damage:get() then

            ui_refs.damage_marker:override(false)
        else

            ui_refs.damage_marker:override()
        end
    end
    
    if not ui_visuals.world_damage:get() then return end
    
    local current_time = globals.realtime
    local duration = 1.0
    
    for i = #world_damage_state.damage_markers, 1, -1 do
        local marker = world_damage_state.damage_markers[i]
        local age = current_time - marker.birth_time
        
        if age > duration then
            table.remove(world_damage_state.damage_markers, i)
        else
            local screen_pos = marker.world_pos:to_screen()
            if screen_pos then
                local fade_in_time = 0.15
                local alpha
                local float_offset = age * 15
                
                if age < fade_in_time then

                    local fade_in_progress = age / fade_in_time
                    alpha = math.floor(255 * fade_in_progress)
                else

                    local fade_out_progress = (age - fade_in_time) / (duration - fade_in_time)
                    alpha = math.floor(255 * (1 - fade_out_progress))
                end
                
                local base_color = ui_visuals.world_damage_color:get()
                local damage_color = color(base_color.r, base_color.g, base_color.b, alpha)
                local cx, cy = screen_pos.x, screen_pos.y
                local damage_text = "- " .. tostring(marker.damage)
                
                render.text(fonts.world_damage, vector(cx, cy - 25 - float_offset), damage_color, "", damage_text)
            end
        end
    end
end


local keybinds_state = {
    position = get_stored_coords("keybinds", 100, 300),
    dragging = false,
    drag_offset = vector(0, 0),
    background_alpha = 0,
    cached_binds = {}
}

local spectators_state = {
    position = get_stored_coords("spectators", 100, 350),
    dragging = false,
    drag_offset = vector(0, 0),
    background_alpha = 0,
    cached_spectators = {},
    avatar_cache = {}
}

local function render_watermark()
    if not ui_visuals.watermark:get() then return end
    
    local screen = render.screen_size()
    
    local username = common.get_username()
    local fps = math.floor(1 / globals.frametime)
    local time = common.get_date("%H:%M:%S")
    
    local latency = 0
    local net_chan = utils.net_channel()
    if net_chan then
        latency = math.floor(net_chan.latency[0] * 1000)
    end
    
    local nl_width = render.measure_text(fonts.watermark, "", "NL")
    
    local sep_text = " \aFFFFFF14|"
    local sep_text2 = "\aFFFFFF14| "
    local alpha_text = "\aFFFFFFFF Alpha"
    local username_text = "\aFFFFFFFF " .. username
    local ms_template = "\aFFFFFFFF 999ms"
    local fps_template = "\aFFFFFFFF 999fps"
    local time_template = "\aFFFFFFFF 23:59:59"
    
    local sep_width = render.measure_text(fonts.watermark_info, "", sep_text)
    local sep_width2 = render.measure_text(fonts.watermark_info, "", sep_text2)
    local alpha_width = render.measure_text(fonts.watermark_info, "", alpha_text)
    local username_width = render.measure_text(fonts.watermark_info, "", username_text)
    local ms_width = render.measure_text(fonts.watermark_info, "", ms_template)
    local fps_width = render.measure_text(fonts.watermark_info, "", fps_template)
    local time_width = render.measure_text(fonts.watermark_info, "", time_template)
    
    local padding = 8
    local total_text_width = nl_width.x + 2 + sep_width.x + alpha_width.x + sep_width.x + username_width.x + sep_width.x + ms_width.x + sep_width2.x + fps_width.x + sep_width.x + time_width.x
    local bg_width = total_text_width + padding * 2
    local bg_height = 21
    
    local pos = vector(screen.x - bg_width - 8, 7)
    local size = vector(bg_width, bg_height)
    
    local styles = ui.get_style()
    local window_bg = styles["Window Title"] or color(20, 20, 30, 255)
    local background_color = color(window_bg.r, window_bg.g, window_bg.b, 255)
    local border_color = color(25, 32, 60, 50)
    local bg_alpha = 255
    
    if ui_visuals.watermark_blur:get() then
        local blur_strength = ui_visuals.watermark_blur_strength:get()
        local blur_alpha = ui_visuals.watermark_blur_alpha:get()
        render.blur(pos, pos + size, blur_strength, blur_alpha, 3)
    end
    
    if ui_visuals.watermark_glow:get() then
        local glow_col = ui_visuals.watermark_glow_color:get()
        render.shadow(pos, pos + size, color(glow_col.r, glow_col.g, glow_col.b, glow_col.a), 15, 0, 3)
    end
    
    render.rect(pos, pos + size, color(background_color.r, background_color.g, background_color.b, bg_alpha), 3)
    render.rect_outline(pos, pos + size, color(border_color.r, border_color.g, border_color.b, border_color.a), 1, 3)
    
    local text_pos_blue = pos + vector(padding, 2)
    local text_pos_white = pos + vector(padding + 1, 3)
    
    render.text(fonts.watermark, text_pos_blue, color(0, 191, 255, 255), "", "NL")
    render.text(fonts.watermark, text_pos_white, color(255, 255, 255, 255), "", "NL")
    
    local info_y = pos.y + 3
    local current_x = pos.x + padding + nl_width.x + 2
    
    render.text(fonts.watermark_info, vector(current_x, info_y), color(255, 255, 255, 255), "", sep_text)
    current_x = current_x + sep_width.x
    
    render.text(fonts.watermark_info, vector(current_x, info_y), color(255, 255, 255, 255), "", alpha_text)
    current_x = current_x + alpha_width.x
    
    render.text(fonts.watermark_info, vector(current_x, info_y), color(255, 255, 255, 255), "", sep_text)
    current_x = current_x + sep_width.x
    
    render.text(fonts.watermark_info, vector(current_x, info_y), color(255, 255, 255, 255), "", username_text)
    current_x = current_x + username_width.x
    
    render.text(fonts.watermark_info, vector(current_x, info_y), color(255, 255, 255, 255), "", sep_text)
    current_x = current_x + sep_width.x
    
    render.text(fonts.watermark_info, vector(current_x, info_y), color(255, 255, 255, 255), "", string.format("\aFFFFFFFF%3d ms", latency))
    current_x = current_x + ms_width.x
    
    render.text(fonts.watermark_info, vector(current_x, info_y), color(255, 255, 255, 255), "", sep_text2)
    current_x = current_x + sep_width2.x
    
    render.text(fonts.watermark_info, vector(current_x, info_y), color(255, 255, 255, 255), "", string.format("\aFFFFFFFF%3d fps", fps))
    current_x = current_x + fps_width.x
    
    render.text(fonts.watermark_info, vector(current_x, info_y), color(255, 255, 255, 255), "", sep_text)
    current_x = current_x + sep_width.x
    
    render.text(fonts.watermark_info, vector(current_x, info_y), color(255, 255, 255, 255), "", string.format("\aFFFFFFFF %s", time))
end

local function render_keybinds()
    if not ui_visuals.keybinds:get() then return end
    

    local mouse_pos = ui.get_mouse_position()
    local in_menu = ui.get_alpha() > 0
    
    if in_menu then

        local is_hovering = mouse_pos.x >= keybinds_state.position.x and 
                           mouse_pos.x <= keybinds_state.position.x + 150 and
                           mouse_pos.y >= keybinds_state.position.y and 
                           mouse_pos.y <= keybinds_state.position.y + 20
        
        if is_hovering and common.is_button_down(1) and not keybinds_state.dragging then
            keybinds_state.dragging = true
            keybinds_state.drag_offset = mouse_pos - keybinds_state.position
        end
    end
    
    if keybinds_state.dragging then
        if common.is_button_down(1) then
            keybinds_state.position = mouse_pos - keybinds_state.drag_offset
        else
            keybinds_state.dragging = false
            store_coords("keybinds", keybinds_state.position)
        end
    end
    
    local pos = keybinds_state.position
    

    local styles = ui.get_style()
    local link_color = styles["Link Active"] or color(255, 255, 255, 255)
    local text_color = styles["Active Text"] or color(255, 255, 255, 255)
    local window_bg = styles["Window Title"] or color(20, 20, 30, 255)
    local background_color = color(window_bg.r, window_bg.g, window_bg.b, 255)
    local border_color = color(25, 32, 60, 50)
    

    local binds = ui.get_binds()
    local line_height = 20
    local frametime = globals.frametime
    local max_bind_alpha = 0
    local current_time = globals.realtime
    

    local active_count = 0
    for i = 1, #binds do
        if binds[i].active then
            active_count = active_count + 1
        end
    end
    

    max_bind_alpha = active_count > 0 and 255 or 0
    

    local target_bg_alpha = in_menu and 255 or max_bind_alpha
    keybinds_state.background_alpha = keybinds_state.background_alpha + (target_bg_alpha - keybinds_state.background_alpha) * frametime * 8
    

    if keybinds_state.background_alpha < 1 then
        return
    end
    
    local size = vector(150, 20)
    local bg_alpha = keybinds_state.background_alpha
    

    local current_binds = {}
    for i = 1, #binds do
        local bind = binds[i]
        if bind.active then
            table.insert(current_binds, {
                bind = bind,
                name = bind.name
            })
        end
    end
    

    if #current_binds > 0 then
        keybinds_state.cached_binds = current_binds
    end
    

    local visible_binds = {}
    for i = 1, #keybinds_state.cached_binds do
        local item = keybinds_state.cached_binds[i]
        table.insert(visible_binds, {
            bind = item.bind,
            name = item.name,
            alpha = bg_alpha
        })
    end
    local gap = 5
    

    local total_height = size.y
    if #visible_binds > 0 then
        total_height = total_height + gap + #visible_binds * line_height
    end
    

    if ui_visuals.keybinds_blur:get() then
        local blur_strength = ui_visuals.keybinds_blur_strength:get()
        local blur_alpha_max = ui_visuals.keybinds_blur_alpha:get()

        local blur_alpha = math.floor(blur_alpha_max * max_bind_alpha / 255)
        
        render.blur(pos, pos + vector(size.x, total_height), blur_strength, blur_alpha, 3)
    end
    

    if ui_visuals.keybinds_glow:get() then
        local glow_col = ui_visuals.keybinds_glow_color:get()
        local glow_alpha = math.floor(glow_col.a * bg_alpha / 255)
        render.shadow(pos, pos + size, color(glow_col.r, glow_col.g, glow_col.b, glow_alpha), 15, 0, 3)
    end
    

    -- 分两段绘制：上半段圆角，下半段直角（Neverlose v2风格）
    local half_height = size.y / 2
    
    -- 上半段：带圆角
    render.rect(pos, pos + vector(size.x, half_height), color(background_color.r, background_color.g, background_color.b, bg_alpha), 3)
    
    -- 下半段：无圆角（稍微重叠1px避免缝隙）
    render.rect(pos + vector(0, half_height - 1), pos + size, color(background_color.r, background_color.g, background_color.b, bg_alpha), 0)
    
    -- 边框：完整绘制但只有上面圆角
    render.rect_outline(pos, pos + size, color(border_color.r, border_color.g, border_color.b, border_color.a * bg_alpha / 255), 1, 3)
    

    local icon = ui.get_icon("keyboard")
    

    local text_size = render.measure_text(fonts.keybinds, "", "Binds")
    local icon_size = render.measure_text(fonts.keybinds_icon, "", icon)
    

    local text_y = pos.y + (size.y - text_size.y) / 2
    

    local icon_y = text_y + text_size.y - icon_size.y + 0.5
    

    render.text(fonts.keybinds_icon, vector(pos.x + 6, icon_y), color(link_color.r, link_color.g, link_color.b, bg_alpha), "", icon)
    

    local space_width = render.measure_text(fonts.keybinds, "", " ").x
    render.text(fonts.keybinds, vector(pos.x + 6 + icon_size.x + space_width * 2.5, text_y), color(text_color.r, text_color.g, text_color.b, bg_alpha), "", "Binds")
    

    local name_map = {
        ["Min. Damage"] = "Minimum Damage",
        ["Double Tap"] = "Double Tap"
    }
    

    local padding = 6
    
    for i = 1, #visible_binds do
        local item = visible_binds[i]
        local bind = item.bind
        local bind_name = name_map[item.name] or item.name
        local alpha = item.alpha
        
        local line_y = pos.y + 20 + gap + (i - 1) * line_height
        
        render.text(fonts.keybinds_list, vector(pos.x + padding, line_y), color(255, 255, 255, alpha), "", bind_name)
        
        local right_text = ""
        if type(bind.value) == "table" then

            right_text = tostring(bind.value[1] or "on")
        elseif type(bind.value) == "boolean" then
            right_text = bind.value and "on" or "off"
        elseif bind.value ~= nil and bind.value ~= "" then
            right_text = tostring(bind.value)
        else
            right_text = bind.active and "on" or "off"
        end
        
        local right_text_size = render.measure_text(fonts.keybinds_list, "", right_text)
        render.text(fonts.keybinds_list, vector(pos.x + size.x - right_text_size.x - padding, line_y), color(255, 255, 255, alpha), "", right_text)
    end
end


local function render_spectators()
    if not ui_visuals.spectators:get() then return end
    
    local mouse_pos = ui.get_mouse_position()
    local in_menu = ui.get_alpha() > 0
    
    if in_menu then
        local is_hovering = mouse_pos.x >= spectators_state.position.x and 
                           mouse_pos.x <= spectators_state.position.x + 150 and
                           mouse_pos.y >= spectators_state.position.y and 
                           mouse_pos.y <= spectators_state.position.y + 20
        
        if is_hovering and common.is_button_down(1) and not spectators_state.dragging then
            spectators_state.dragging = true
            spectators_state.drag_offset = mouse_pos - spectators_state.position
        end
    end
    
    if spectators_state.dragging then
        if common.is_button_down(1) then
            spectators_state.position = mouse_pos - spectators_state.drag_offset
        else
            spectators_state.dragging = false
            store_coords("spectators", spectators_state.position)
        end
    end
    
    local pos = spectators_state.position
    
    local styles = ui.get_style()
    local link_color = styles["Link Active"] or color(255, 255, 255, 255)
    local text_color = styles["Active Text"] or color(255, 255, 255, 255)
    local window_bg = styles["Window Title"] or color(20, 20, 30, 255)
    local background_color = color(window_bg.r, window_bg.g, window_bg.b, 255)
    local border_color = color(25, 32, 60, 50)
    

    local function sanitize_name(name)
        local out = {}
        local i = 1
        local len = #name
        
        while i <= len do
            local b = name:byte(i)
            if b >= 32 and b <= 126 then
                out[#out + 1] = string.char(b)
                i = i + 1
            elseif b < 128 then
                out[#out + 1] = "?"
                i = i + 1
            else
                if b >= 240 then
                    i = i + 4
                elseif b >= 224 then
                    i = i + 3
                elseif b >= 192 then
                    i = i + 2
                else
                    i = i + 1
                end
                out[#out + 1] = "?"
            end
        end
        
        return table.concat(out)
    end
    
    local spectators = {}
    local lp = entity.get_local_player()
    if lp then
        local obs_mode = lp.m_iObserverMode
        if obs_mode == 4 or obs_mode == 5 then
            local obs_target = lp.m_hObserverTarget
            if obs_target then
                local specs = obs_target:get_spectators()
                if specs then spectators = specs end
            end
        else
            local specs = lp:get_spectators()
            if specs then spectators = specs end
        end
    end
    
    local line_height = 20
    local frametime = globals.frametime
    local max_spectator_alpha = 0
    local current_time = globals.realtime
    

    max_spectator_alpha = #spectators > 0 and 255 or 0

    local target_bg_alpha = in_menu and 255 or max_spectator_alpha
    spectators_state.background_alpha = spectators_state.background_alpha + (target_bg_alpha - spectators_state.background_alpha) * frametime * 8

    if spectators_state.background_alpha < 1 then
        return
    end
    
    local size = vector(150, 20)
    local bg_alpha = spectators_state.background_alpha
    

    local current_spectators = {}
    for i = 1, #spectators do
        local spectator = spectators[i]
        local spec_name = sanitize_name(spectator:get_name())
        table.insert(current_spectators, {
            name = spec_name,
            entity = spectator
        })
    end
    

    if #current_spectators > 0 then
        spectators_state.cached_spectators = current_spectators
    end
    

    local visible_spectators = {}
    for i = 1, #spectators_state.cached_spectators do
        local item = spectators_state.cached_spectators[i]
        table.insert(visible_spectators, {
            name = item.name,
            entity = item.entity,
            alpha = bg_alpha
        })
    end
    
    local base_width = size.x
    if not spectators_state.panel_width then
        spectators_state.panel_width = base_width
    end
    local target_width = base_width
    local width_padding = 6
    local width_avatar = 16
    local width_avatar_gap = 6
    local width_margin_right = 6
    for i = 1, #visible_spectators do
        local item = visible_spectators[i]
        local name_width = render.measure_text(fonts.keybinds_list, "", item.name).x
        local line_width = width_padding + width_avatar + width_avatar_gap + name_width + width_margin_right
        if line_width > target_width then
            target_width = line_width
        end
    end
    spectators_state.panel_width = spectators_state.panel_width + (target_width - spectators_state.panel_width) * frametime * 10
    

    local avatar_cache = spectators_state.avatar_cache
    local now = globals.realtime
    for i = 1, #visible_spectators do
        local item = visible_spectators[i]
        local ent = item.entity
        

        local is_valid_player = false
        local ent_index = nil
        if ent then
            local ok_player, res_player = pcall(function()
                return ent:is_player()
            end)
            if ok_player and res_player then
                local ok_index, res_index = pcall(function()
                    return ent:get_index()
                end)
                if ok_index and res_index then
                    is_valid_player = true
                    ent_index = res_index
                end
            end
        end
        
        if is_valid_player and ent_index then
            local key = ent_index
            local cache_entry = avatar_cache[key]
            if not cache_entry then
                cache_entry = {
                    texture = nil,
                    last_attempt = 0,
                    last_success = 0,
                    retries = 0
                }
                avatar_cache[key] = cache_entry
            end
            

            if not cache_entry.texture and (now - cache_entry.last_attempt) > 0.5 and cache_entry.retries < 5 then
                cache_entry.last_attempt = now
                cache_entry.retries = cache_entry.retries + 1
                local ok_avatar, avatar_tex = pcall(function()
                    return ent:get_steam_avatar()
                end)
                if ok_avatar and avatar_tex then
                    cache_entry.texture = avatar_tex
                    cache_entry.last_success = now
                end
            end
            
            item.avatar_key = key
        end
    end
    local gap = 5
    
    local total_height = size.y
    if #visible_spectators > 0 then
        total_height = total_height + gap + #visible_spectators * line_height
    end
    
    local panel_width = spectators_state.panel_width or size.x
    
    if ui_visuals.spectators_blur:get() then
        local blur_strength = ui_visuals.spectators_blur_strength:get()
        local blur_alpha_max = ui_visuals.spectators_blur_alpha:get()

        local blur_alpha = math.floor(blur_alpha_max * max_spectator_alpha / 255)
        
        render.blur(pos, pos + vector(panel_width, total_height), blur_strength, blur_alpha, 3)
    end
    
    if ui_visuals.spectators_glow:get() then
        local glow_col = ui_visuals.spectators_glow_color:get()
        local glow_alpha = math.floor(glow_col.a * bg_alpha / 255)
        render.shadow(pos, pos + vector(panel_width, size.y), color(glow_col.r, glow_col.g, glow_col.b, glow_alpha), 15, 0, 3)
    end
    

    -- 分两段绘制：上半段圆角，下半段直角（Neverlose v2风格）
    local half_height = size.y / 2
    
    -- 上半段：带圆角
    render.rect(pos, pos + vector(panel_width, half_height), color(background_color.r, background_color.g, background_color.b, bg_alpha), 3)
    
    -- 下半段：无圆角（稍微重叠1px避免缝隙）
    render.rect(pos + vector(0, half_height - 1), pos + vector(panel_width, size.y), color(background_color.r, background_color.g, background_color.b, bg_alpha), 0)
    
    -- 边框：完整绘制但只有上面圆角
    render.rect_outline(pos, pos + vector(panel_width, size.y), color(border_color.r, border_color.g, border_color.b, border_color.a * bg_alpha / 255), 1, 3)
    
    local icon = ui.get_icon("users")
    
    local text_size = render.measure_text(fonts.keybinds, "", "Spectators")
    local icon_size = render.measure_text(fonts.keybinds_icon, "", icon)
    local text_y = pos.y + (size.y - text_size.y) / 2
    local icon_y = text_y + text_size.y - icon_size.y + 0.5
    
    render.text(fonts.keybinds_icon, vector(pos.x + 6, icon_y), color(link_color.r, link_color.g, link_color.b, bg_alpha), "", icon)
    local space_width = render.measure_text(fonts.keybinds, "", " ").x
    render.text(fonts.keybinds, vector(pos.x + 6 + icon_size.x + space_width * 2.5, text_y), color(text_color.r, text_color.g, text_color.b, bg_alpha), "", "Spectators")
    
    local padding = 6
    local avatar_size = 16
    local avatar_rounding = 8
    local avatar_gap = 6
    for i = 1, #visible_spectators do
        local item = visible_spectators[i]
        local name = item.name
        local alpha = item.alpha
        local line_y = pos.y + 20 + gap + (i - 1) * line_height
        
        local text_x = pos.x + padding
        

        if item.avatar_key then
            local cache_entry = spectators_state.avatar_cache[item.avatar_key]
            if cache_entry and cache_entry.texture then
                local avatar_y = line_y + (line_height - avatar_size) / 2 - 3
                render.texture(cache_entry.texture, vector(text_x, avatar_y), vector(avatar_size, avatar_size), color(255, 255, 255, alpha), "f", avatar_rounding)
                text_x = text_x + avatar_size + avatar_gap
            end
        end
        
        render.text(fonts.keybinds_list, vector(text_x, line_y), color(255, 255, 255, alpha), "", name)
    end
end


local gs_log_state = {
    entries = {},
    base_y = 5,
    spacing = 25
}

local function add_gs_log_entry(text)
    local entry = {
        text = text,
        birth_time = globals.realtime,
        lifetime = 4.0,
        slide_progress = 0,
        fade_alpha = 0,
        y_offset = 0
    }
    
    table.insert(gs_log_state.entries, 1, entry)
    

    while #gs_log_state.entries > 10 do
        table.remove(gs_log_state.entries)
    end
end


local hitgroup_names = {"head", "chest", "stomach", "left arm", "right arm", "left leg", "right leg", "neck", "body"}
local aimbot_log_state = {
    fire_data = {}
}

-- Neverlose v2字符清理函数
local function clean_name_for_neverlose(name)
    local out = {}
    local i = 1
    local len = #name
    
    while i <= len do
        local b = name:byte(i)
        if b >= 32 and b <= 126 then
            -- ASCII可见字符 (英文字母、数字、符号)
            out[#out + 1] = string.char(b)
            i = i + 1
        elseif b < 128 then
            -- ASCII控制字符
            out[#out + 1] = "?"
            i = i + 1
        else
            -- UTF-8多字节字符
            if b >= 240 then
                i = i + 4  -- 4字节UTF-8字符
            elseif b >= 224 then
                i = i + 3  -- 3字节UTF-8字符
            elseif b >= 192 then
                i = i + 2  -- 2字节UTF-8字符
            else
                i = i + 1  -- 无效字符
            end
            out[#out + 1] = "?"
        end
    end
    
    return table.concat(out)
end

events.aim_fire:set(function(e)
    -- Half-life target tracking
    local target = entity.get(e.target)
    if target then
        halflife_stats.current_target = target
    end
    
    if not ui_visuals.aimbot_logging:get() then return end
    aimbot_log_state.fire_data[e.id] = {
        aimed = hitgroup_names[e.hitgroup] or "body",
        dmg = e.damage
    }
end)

events.aim_ack:set(function(e)
    -- Half-life statistics tracking
    if e.state == nil then
        halflife_stats.hit_count = halflife_stats.hit_count + 1
    else
        halflife_stats.miss_count = halflife_stats.miss_count + 1
    end

    if ui_visuals.mystery_killmarks:get() and ui_visuals.mystery_killmarks_miss:get() and e.state ~= nil then
        local target = entity.get(e.target)
        if target and not target:is_dormant() then
            trigger_mystery_hit_effect()
        end
    end
    
    if not ui_visuals.aimbot_logging:get() then return end
    
    local target = entity.get(e.target)
    if not target then return end
    
    local data = aimbot_log_state.fire_data[e.id] or {}
    local name = target:get_name()
    local wanted_hitgroup = data.aimed or "?"
    local wanted_dmg = data.dmg or 0
    local hc = math.floor(e.hitchance or 0)
    local bt = e.backtrack or 0
    local hp = target.m_iHealth or 0
    
    if e.state == nil then

        local hitgroup = hitgroup_names[e.hitgroup] or "body"
        local dmg = e.damage
        local hit_col = ui_visuals.log_hit_color:get()
        local hex = hit_col:to_hex()
        

        local console_msg = string.format(
            "\a%sEmptiness \aFFFFFFFF| Hit \a%s%s \aFFFFFFFFin \a%s%s \aFFFFFFFFfor \a%s%d\aFFFFFFFF(\a%s%d\aFFFFFFFF) dmg (\a%s%d\aFFFFFFFF hp) | aimed: \a%s%s\aFFFFFFFF | hc: \a%s%d%%\aFFFFFFFF | bt: \a%s%d",
            hex, hex, name, hex, hitgroup, hex, dmg, hex, wanted_dmg, hex, hp, hex, wanted_hitgroup, hex, hc, hex, bt
        )
        

        local screen_msg = string.format(
            "\a%sEmptiness \aFFFFFFFF| Hit \a%s%s \aFFFFFFFFin \a%s%s \aFFFFFFFFfor \a%s%d\aFFFFFFFF(\a%s%d\aFFFFFFFF) dmg (\a%s%d\aFFFFFFFF hp) | aimed: \a%s%s\aFFFFFFFF | hc: \a%s%d%%\aFFFFFFFF | bt: \a%s%d",
            hex, hex, name, hex, hitgroup, hex, dmg, hex, wanted_dmg, hex, hp, hex, wanted_hitgroup, hex, hc, hex, bt
        )
        
        if ui_visuals.log_display:get("Console") then
            print_raw(console_msg)
        end
        if ui_visuals.log_display:get("Screen") then
            local scr = render.screen_size()
            table.insert(vis_state.log_queue, {
                msg = screen_msg,
                col = hit_col,
                started = false,
                active = false,
                timeout = 4,
                y = scr.y,
                alpha = 0,
                delay = 0
            })
        end
        if ui_visuals.log_gamesense:get() then
            local remaining_hp = math.max(0, hp - dmg)
            local hex = hit_col:to_hex()
            local gs_msg = string.format("\aFFFFFFFFHit \a%s%s\aFFFFFFFF in the \a%s%s\aFFFFFFFF for \a%s%d\aFFFFFFFF damage (%d health remaining)", 
                hex, name, hex, hitgroup, hex, dmg, remaining_hp)
            add_gs_log_entry(gs_msg)
        end
        if ui_visuals.log_neverlose:get() then
            local remaining_hp = math.max(0, hp - dmg)
            local clean_name = clean_name_for_neverlose(name)
            local nl_msg = string.format("Hurt %s in the %s for %d hp (%d remaining).", clean_name, hitgroup, dmg, remaining_hp)
            add_neverlose_log("check", nl_msg)
            
            -- 控制台输出：nl · 信息
            local styles = ui.get_style()
            local link_color = styles["Link Active"] or color(255, 255, 255, 255)
            local text_color = styles["Active Text"] or color(255, 255, 255, 255)
            
            local console_msg = string.format(
                "\a%snl \a808080FF· \a%s%s",
                link_color:to_hex(),
                text_color:to_hex(),
                nl_msg
            )
            print_raw(console_msg)
        end
        if ui_visuals.log_display:get("Chat") then
            -- 检查是否开启了Kill Say功能，如果开启则跳过Chat避免冲突
            if not (ui_visuals.kill_say and ui_visuals.kill_say:get()) then
                -- 使用简单的预设颜色代码
                local chat_msg = string.format(
                    "\x04Emptiness \x01| Hit \x04%s \x01in \x04%s \x01for \x04%d\x01(\x04%d\x01) dmg (\x04%d \x01hp) | aimed: \x04%s \x01| hc: \x04%d%% \x01| bt: \x04%d",
                    name, hitgroup, dmg, wanted_dmg, hp, wanted_hitgroup, hc, bt
                )
                utils.console_exec("say \"" .. chat_msg .. "\"")
            end
        end
    else

        local miss_col = ui_visuals.log_miss_color:get()
        local hex = miss_col:to_hex()
        

        local console_msg = string.format(
            "\a%sEmptiness \aFFFFFFFF| Missed \a%s%s \aFFFFFFFFin \a%s%s \aFFFFFFFFdue to \a%s%s \aFFFFFFFF| wanted: \a%s%d\aFFFFFFFF dmg | hc: \a%s%d%%\aFFFFFFFF | bt: \a%s%d",
            hex, hex, name, hex, wanted_hitgroup, hex, e.state, hex, wanted_dmg, hex, hc, hex, bt
        )
        

        local screen_msg = string.format(
            "\a%sEmptiness \aFFFFFFFF| Missed \a%s%s \aFFFFFFFFin \a%s%s \aFFFFFFFFdue to \a%s%s \aFFFFFFFF| wanted: \a%s%d\aFFFFFFFF dmg | hc: \a%s%d%%\aFFFFFFFF | bt: \a%s%d",
            hex, hex, name, hex, wanted_hitgroup, hex, e.state, hex, wanted_dmg, hex, hc, hex, bt
        )
        
        if ui_visuals.log_display:get("Console") then
            print_raw(console_msg)
        end
        if ui_visuals.log_display:get("Screen") then
            local scr = render.screen_size()
            table.insert(vis_state.log_queue, {
                msg = screen_msg,
                col = miss_col,
                started = false,
                active = false,
                timeout = 4,
                y = scr.y,
                alpha = 0,
                delay = 0
            })
        end
        if ui_visuals.log_gamesense:get() then
            local gs_msg = string.format("\aFFFFFFFFMiss shot due to %s", e.state)
            add_gs_log_entry(gs_msg)
        end
        if ui_visuals.log_neverlose:get() then
            local nl_msg = string.format("missed shot due to %s", e.state)
            add_neverlose_log("xmark", nl_msg)
            
            -- 控制台输出：nl · 信息 (空枪原因红色)
            local styles = ui.get_style()
            local link_color = styles["Link Active"] or color(255, 255, 255, 255)
            local text_color = styles["Active Text"] or color(255, 255, 255, 255)
            
            local console_msg = string.format(
                "\a%snl \a808080FF· \a%smissed shot due to \aFF4444FF%s",
                link_color:to_hex(),
                text_color:to_hex(),
                e.state
            )
            print_raw(console_msg)
        end
        if ui_visuals.log_display:get("Chat") then
            -- 检查是否开启了Kill Say功能，如果开启则跳过Chat避免冲突
            if not (ui_visuals.kill_say and ui_visuals.kill_say:get()) then
                -- 使用简单的预设颜色代码  
                local chat_msg = string.format(
                    "\x02Emptiness \x01| Missed \x02%s \x01in \x02%s \x01due to \x02%s \x01| wanted: \x02%d \x01dmg | hc: \x02%d%% \x01| bt: \x02%d",
                    name, wanted_hitgroup, e.state, wanted_dmg, hc, bt
                )
                utils.console_exec("say \"" .. chat_msg .. "\"")
            end
        end
    end
    
    aimbot_log_state.fire_data[e.id] = nil
end)

local function render_gs_hit_logs()
    if not ui_visuals.aimbot_logging:get() then return end
    if not ui_visuals.log_gamesense:get() then return end
    
    local current_time = globals.realtime
    
    local screen = render.screen_size()
    local base_x = 5
    local render_y = gs_log_state.base_y
    

    for i = #gs_log_state.entries, 1, -1 do
        local entry = gs_log_state.entries[i]
        local age = current_time - entry.birth_time
        
        if age > entry.lifetime + 0.5 then
            table.remove(gs_log_state.entries, i)
        end
    end
    

    for idx, entry in ipairs(gs_log_state.entries) do
        if idx > 10 then break end
        
        local age = current_time - entry.birth_time
        

        if age < 0.3 then

            entry.slide_progress = age / 0.3
            entry.fade_alpha = age / 0.3
        elseif age < entry.lifetime then

            entry.slide_progress = 1
            entry.fade_alpha = 1
        else

            local fade_t = (age - entry.lifetime) / 0.5
            entry.fade_alpha = 1 - fade_t
            entry.y_offset = -fade_t * 30
        end
        

        local ease_progress = entry.slide_progress * entry.slide_progress * (3 - 2 * entry.slide_progress)
        

        local text_size = render.measure_text(fonts.gs_log, nil, entry.text)
        local margin_x = 7
        local total_width = text_size.x + margin_x * 2
        

        local target_x = base_x + total_width / 2
        local start_x = base_x - 50
        local current_x = start_x + (target_x - start_x) * ease_progress
        

        local current_y = render_y + entry.y_offset
        

        local alpha = math.floor(entry.fade_alpha * 255)
        
        if alpha > 5 then

            local bg_height = text_size.y + 4
            local bg_width = (text_size.x + margin_x * 2) * 1.1
            

            render.gradient(
                vector(current_x - bg_width / 2, current_y),
                vector(current_x, current_y + bg_height),
                color(0, 0, 0, 0),
                color(0, 0, 0, math.floor(alpha * 0.5)),
                color(0, 0, 0, 0),
                color(0, 0, 0, math.floor(alpha * 0.5))
            )
            

            render.gradient(
                vector(current_x, current_y),
                vector(current_x + bg_width / 2, current_y + bg_height),
                color(0, 0, 0, math.floor(alpha * 0.5)),
                color(0, 0, 0, 0),
                color(0, 0, 0, math.floor(alpha * 0.5)),
                color(0, 0, 0, 0)
            )
            

            local text_x = current_x - text_size.x / 2
            local text_y = current_y + bg_height / 2 - text_size.y / 2 - 1
            

            render.text(fonts.gs_log, vector(text_x, text_y), color(255, 255, 255, alpha), nil, entry.text)
        end
        
        render_y = render_y + gs_log_state.spacing
    end
end

-- Neverlose v2日志渲染函数
local function render_neverlose_logs()
    if not ui_visuals.aimbot_logging:get() or not ui_visuals.log_neverlose:get() then return end
    
    local current_time = globals.realtime
    local styles = ui.get_style()
    local icon_color = styles["Link Active"] or color(255, 255, 255, 255)
    local text_color = styles["Active Text"] or color(255, 255, 255, 255)
    
    local base_x = 10
    local render_y = neverlose_log_state.base_y
    local line_height = 18
    
    -- 更新alpha和清理过期条目
    for i = #neverlose_log_state.entries, 1, -1 do
        local entry = neverlose_log_state.entries[i]
        local age = current_time - entry.birth_time
        
        if age > 5 then
            table.remove(neverlose_log_state.entries, i)
        else
            -- 渐入动画 (0-0.3秒)
            if age < 0.3 then
                entry.alpha = math.min(255, (age / 0.3) * 255)
            -- 保持显示 (0.3-4.3秒) - 真正的v2保持时间4秒
            elseif age < 4.3 then
                entry.alpha = 255
            -- 渐出动画 (4.3-4.8秒) - 快速渐隐
            else
                entry.alpha = math.max(0, 255 - ((age - 4.3) / 0.5) * 255)
            end
        end
    end
    
    -- 渲染每个条目
    for i = 1, #neverlose_log_state.entries do
        local entry = neverlose_log_state.entries[i]
        if entry.alpha > 0 then
            local alpha = math.floor(entry.alpha)
            
            -- 获取图标和字体（购物车用小字体）
            local icon = ui.get_icon(entry.icon)
            local icon_font = entry.icon == "cart-shopping" and fonts.neverlose_log_cart or fonts.neverlose_log_icon
            local icon_size = render.measure_text(icon_font, "", icon)
            
            -- 测量文字尺寸用于背景
            local text_size = render.measure_text(fonts.neverlose_log, "", entry.message)
            local total_content_width = icon_size.x + 10 + text_size.x
            local bg_height = line_height  -- 背景高度等于行高，无缝拼接
            
            -- Neverlose v2风格背景
            local bg_alpha = math.floor(alpha * 0.15)  -- 和Gamesense一样的透明度
            -- 从屏幕最左边到文字中间的距离
            local left_width = base_x + (total_content_width * 0.5)  -- 从屏幕左边到文字一半位置
            local gradient_start = left_width  -- 渐变开始位置
            local gradient_end = base_x + total_content_width + 10  -- 渐变结束位置
            
            -- 左边实色背景（从屏幕最左边开始，完全贴合）
            render.rect(
                vector(0, render_y),
                vector(left_width, render_y + bg_height),
                color(0, 0, 0, bg_alpha)
            )
            
            -- 右边渐变背景
            render.gradient(
                vector(gradient_start, render_y),
                vector(gradient_end, render_y + bg_height),
                color(0, 0, 0, bg_alpha),
                color(0, 0, 0, 0),
                color(0, 0, 0, bg_alpha),
                color(0, 0, 0, 0)
            )
            
            -- 渲染图标（多重渲染变粗）- 调整垂直居中
            local icon_y = render_y + (line_height - icon_size.y) / 2 - 1
            local icon_rgba = color(icon_color.r, icon_color.g, icon_color.b, alpha)
            
            -- 渲染4次创造粗体效果（使用选择的字体）
            render.text(icon_font, vector(base_x, icon_y), icon_rgba, "", icon)
            render.text(icon_font, vector(base_x + 1, icon_y), icon_rgba, "", icon)
            render.text(icon_font, vector(base_x, icon_y + 1), icon_rgba, "", icon)
            render.text(icon_font, vector(base_x + 1, icon_y + 1), icon_rgba, "", icon)
            
            -- 渲染文本 - 调整垂直居中
            local text_x = base_x + icon_size.x + 10
            local text_y = render_y + (line_height - text_size.y) / 2
            render.text(fonts.neverlose_log, vector(text_x, text_y), 
                color(text_color.r, text_color.g, text_color.b, alpha), "", entry.message)
            
            render_y = render_y + line_height
        end
    end
end

local function render_aimbot_logs()
    if not ui_visuals.aimbot_logging:get() then return end
    if not ui_visuals.log_display:get("Screen") then return end
    
    local queue = vis_state.log_queue
    local screen = render.screen_size()
    

    for i = #queue, 1, -1 do
        local notif = queue[i]
        if not notif.active and notif.started then
            table.remove(queue, i)
        end
    end
    

    local visible_count = 0
    for i = 1, #queue do
        if queue[i].active then
            visible_count = visible_count + 1
        end
    end
    

    while #queue > 5 do
        table.remove(queue, 1)
    end
    

    local index_count = 0
    for index, notif in ipairs(queue) do
        if index > 5 then break end
        

        if not notif.started then
            notif.active = true
            notif.delay = globals.realtime + notif.timeout
            notif.started = true
        end
        
        if notif.active then
            local padding = 6
            local text_size = render.measure_text(1, nil, notif.msg)
            local w, h = text_size.x + padding * 2, text_size.y + padding * 2
            local x, y = screen.x / 2, notif.y
            

            if globals.realtime < notif.delay - 3 then

                local target_y = (screen.y - 60) - ((visible_count - index_count) * h * 1.15)
                notif.y = notif.y + (target_y - notif.y) * globals.frametime * 7
                notif.alpha = notif.alpha + (255 - notif.alpha) * globals.frametime * 10
            elseif globals.realtime < notif.delay - 1 then

                local target_y = (screen.y - 60) - ((visible_count - index_count) * h * 1.15)
                notif.y = notif.y + (target_y - notif.y) * globals.frametime * 7
                notif.alpha = 255
            elseif globals.realtime < notif.delay then

                local target_y = (screen.y - 60) - ((visible_count - index_count) * h * 1.15)
                notif.y = notif.y + (target_y - notif.y) * globals.frametime * 7
                notif.alpha = 255
            else

                notif.y = notif.y + (screen.y - notif.y) * globals.frametime * 5
                notif.alpha = notif.alpha + (0 - notif.alpha) * globals.frametime * 15
                
                if notif.alpha <= 2 then
                    notif.active = false
                end
            end
            

            local progress = math.max(0, (notif.delay - globals.realtime) / notif.timeout)
            local animate_w = progress * (w / 2)
            
            local notif_color = ui_visuals.log_border_color:get()
            

            render.rect(vector(x - w/2, y), vector(x + w/2, y + h), color(35, 35, 35, notif.alpha * 0.65), 5)
            render.rect_outline(vector(x - w/2, y), vector(x + w/2, y + h), color(50, 50, 50, notif.alpha * 0.65), 1, 5)
            

            if animate_w > 0 and notif.alpha > 45 then
                local w1 = animate_w < 3 and 0 or animate_w
                local circ_fill = w1 > 5 and 0.25 or w1 / 150
                local n = notif.alpha / 15
                local radius = 5
                
                local col_full = color(notif_color.r, notif_color.g, notif_color.b, notif.alpha)
                local col_fade = color(notif_color.r, notif_color.g, notif_color.b, n)
                

                render.circle_outline(vector(x - w/2 + radius, y + radius), col_full, radius, 180, circ_fill, 0)
                render.circle_outline(vector(x + w/2 - radius, y + h - radius), col_full, radius, 0, circ_fill, 0)
                

                render.gradient(vector(x - w/2 + radius, y), vector(x - w/2 + radius + w1, y + 1), 
                    col_full, col_fade, col_full, col_fade)
                render.gradient(vector(x + w/2 - w1 - radius, y + h - 1), vector(x + w/2 - radius, y + h), 
                    col_fade, col_full, col_fade, col_full)
                

                local vert_h = math.min(w1 / 3.5, h / 2 - radius - 2)
                render.gradient(vector(x - w/2, y + radius), vector(x - w/2 + 1, y + radius + vert_h), 
                    col_full, col_full, col_fade, col_fade)
                render.gradient(vector(x + w/2 - 1, y + h - radius - vert_h), vector(x + w/2, y + h - radius), 
                    col_fade, col_fade, col_full, col_full)
            end
            

            render.text(1, vector(x - text_size.x / 2, y + h / 2 - text_size.y / 2), color(255, 255, 255, notif.alpha), nil, notif.msg)
            
            index_count = index_count + 1
        end
    end
end


events.render:set(function()
    
    update_anim_sliders_visibility()
    render_crimson_genesis()
    

    local di_enabled = ui_visuals.dynamic_island:get()
    local local_entity = entity.get_local_player()
    
    if di_enabled then

        di_visual.cache.frame_rate = math.floor(1 / globals.frametime)
        
        local net_chan = utils.net_channel()
        if net_chan then
            di_visual.cache.latency = math.floor(net_chan.latency[0] * 1000)
            di_visual.cache.variance = math.max(0, net_chan:get_packet_response_latency(0, 0))
        end
        
        if local_entity then

            local tb_now = local_entity.m_nTickBase or 0
            if math.abs(tb_now - di_visual.tracking.tb_max) > 64 then
                di_visual.tracking.tb_max = tb_now
            end
            di_visual.cache.lag_comp = math.max(0, di_visual.tracking.tb_max - tb_now)
            

            di_visual.cache.exploit = rage.exploit:get()
        end
    end
    

    local is_visible = di_enabled and local_entity and local_entity:is_alive()
    local target_opacity = is_visible and 255 or 0
    

    if target_opacity > di_visual.opacity.goal and di_visual.opacity.current < 10 then
        di_visual.position.slide = -80
        di_visual.position.target_slide = -80
    end
    
    di_visual.opacity.goal = target_opacity
    

    if is_visible then

        di_visual.position.target_slide = 0
    else

        di_visual.position.target_slide = 0

        if di_visual.opacity.current < 1 then
            di_visual.position.slide = -80
            di_visual.position.target_slide = -80
        end
    end
    

    local fade_speed = 180
    local slide_speed = 55
    

    local fade_delta = fade_speed * globals.frametime
    local slide_delta = slide_speed * globals.frametime
    
    if math.abs(di_visual.opacity.current - di_visual.opacity.goal) < fade_delta then
        di_visual.opacity.current = di_visual.opacity.goal
    else
        di_visual.opacity.current = di_visual.opacity.current + (di_visual.opacity.goal > di_visual.opacity.current and fade_delta or -fade_delta)
    end
    
    if math.abs(di_visual.position.slide - di_visual.position.target_slide) < slide_delta then
        di_visual.position.slide = di_visual.position.target_slide
    else
        di_visual.position.slide = di_visual.position.slide + (di_visual.position.target_slide > di_visual.position.slide and slide_delta or -slide_delta)
    end
    di_visual.effects.glow = math.sin(globals.realtime * 2) * 0.5 + 0.5
    

    if di_visual.opacity.current > 1 then
        
        -- Initialize position if not done yet
        if dynamic_island_state.position == nil then
            dynamic_island_state.position = get_stored_coords("dynamic_island", nil, nil)
            dynamic_island_state.custom_position = dynamic_island_state.position ~= nil
        end
        
        -- Check if animation is complete
        if not dynamic_island_state.animation_complete and di_visual.position.slide >= -1 then
            dynamic_island_state.animation_complete = true
        end

        local screen = render.screen_size()
        local di_w, di_h = 280, 72
        
        -- Use custom position if dragged, otherwise use default position with slide animation
        local di_x, di_y
        if dynamic_island_state.custom_position and dynamic_island_state.position then
            di_x = dynamic_island_state.position.x
            di_y = dynamic_island_state.position.y + di_visual.position.slide
        else
            di_x = screen.x / 2 - di_w / 2
            di_y = 65 + di_visual.position.slide
        end
        
        local di_corner = 12
        
        -- Handle dragging (only when animation is complete and in menu)
        local in_menu = ui.get_alpha() > 0
        local mouse_pos = ui.get_mouse_position()
        
        if in_menu and dynamic_island_state.animation_complete then
            local is_hovering = mouse_pos.x >= di_x and 
                               mouse_pos.x <= di_x + di_w and
                               mouse_pos.y >= di_y and 
                               mouse_pos.y <= di_y + di_h
            
            if is_hovering and common.is_button_down(1) and not dynamic_island_state.dragging then
                dynamic_island_state.dragging = true
                dynamic_island_state.drag_offset = mouse_pos - vector(di_x, di_y - di_visual.position.slide)
            end
        end
        
        if dynamic_island_state.dragging then
            if common.is_button_down(1) then
                dynamic_island_state.position = mouse_pos - dynamic_island_state.drag_offset
                dynamic_island_state.custom_position = true
                -- Update di_x, di_y for current frame
                di_x = dynamic_island_state.position.x
                di_y = dynamic_island_state.position.y + di_visual.position.slide
            else
                dynamic_island_state.dragging = false
                store_coords("dynamic_island", dynamic_island_state.position)
            end
        end
        
        local accent = pui.get_style("Link Active")
        

        local bg_start = vector(di_x, di_y)
        local bg_end = vector(di_x + di_w, di_y + di_h)
        render.rect(bg_start, bg_end, 
            color(15, 18, 22, di_visual.opacity.current * 0.65), 
            di_corner)
        

        render.rect_outline(bg_start, bg_end, 
            color(accent.r, accent.g, accent.b, di_visual.opacity.current * 0.3), 
            1, di_corner)
        

        if user_profile_image then
            local img_x = di_x + 10
            local img_y = di_y + 6
            local img_dim = vector(24, 24)
            

            render.circle_outline(vector(img_x + 12, img_y + 12), 
                color(accent.r, accent.g, accent.b, di_visual.opacity.current * 0.5), 
                13, 0, 1, 1.5)
            

            render.texture(user_profile_image, 
                vector(img_x, img_y),
                img_dim,
                color(255, 255, 255, di_visual.opacity.current),
                "f",
                12)
        end
        

        local stats_display = string.format("%d fps  |  %d ms  |  %d LC", 
            di_visual.cache.frame_rate,
            di_visual.cache.latency,
            di_visual.cache.lag_comp)
        render.text(fonts.dynamic_island, 
            vector(di_x + di_w / 2, di_y + 12),
            color(255, 255, 255, di_visual.opacity.current), 
            "c", stats_display)
        

        local user_name = common.get_username()
        local time_display = common.get_date("%I:%M %p"):gsub("^0", "")
        local user_info = string.format("👤 %s  |  %s", user_name, time_display)
        render.text(fonts.dynamic_island, 
            vector(di_x + di_w / 2, di_y + 40),
            color(180, 180, 180, di_visual.opacity.current * 0.8), 
            "c", user_info)
        

        local script_credit = string.format("%s ©2026", script_info.name)
        render.text(fonts.dynamic_island, 
            vector(di_x + di_w / 2, di_y + 60),
            color(160, 160, 160, di_visual.opacity.current * 0.6), 
            "c", script_credit)
        

        local exploit_charge = di_visual.cache.exploit
        local indicator_x = di_x + di_w - 18
        local indicator_y = di_y + 16
        local indicator_r = 7
        

        render.circle_outline(vector(indicator_x, indicator_y), 
            color(40, 45, 50, di_visual.opacity.current), 
            indicator_r, 0, 1, 1.5)
        

        if exploit_charge > 0 then
            local charge_color
            if exploit_charge >= 1 then
                charge_color = color(accent.r, accent.g, accent.b, di_visual.opacity.current)
            else
                charge_color = color(accent.r * 0.7, accent.g * 0.7, accent.b * 0.7, di_visual.opacity.current * 0.8)
            end
            
            render.circle_outline(vector(indicator_x, indicator_y), 
                charge_color, 
                indicator_r, 
                -90, 
                exploit_charge, 
                2.5)
        end
    end
    

    local animated_text = create_main_slide_animation(script_info.name)
    pui.sidebar(animated_text, "\f<infinity>")
    
    update_aa_page_visibility()
    update_gear_page_visibility()
    local thirdperson_fov_active = update_thirdperson_zoom()
    update_dynamic_zoom(thirdperson_fov_active)
    update_vm_scope_animation()
    

    if ui_visuals.aspect_ratio:get() then
        local ratio = ui_visuals.aspect_ratio_value:get() / 100
        cvars.r_aspectratio:float(ratio)
    else
        cvars.r_aspectratio:float(0)
    end
    

    if ui_visuals.viewmodel:get() then
        -- 使用开镜动画值（如果开镜动画激活）
        local final_fov = ui_visuals.vm_fov:get()
        local final_x_offset = ui_visuals.vm_x:get()
        local final_y_offset = ui_visuals.vm_y:get()
        local final_z_offset = ui_visuals.vm_z:get()
        
        if vm_scope_state.animation_active then
            -- 动画过程中使用动画值（包括关闭功能时的恢复动画）
            final_fov = vm_scope_state.animated_fov
            final_x_offset = vm_scope_state.animated_x_offset
            final_y_offset = vm_scope_state.animated_y_offset
            final_z_offset = vm_scope_state.animated_z_offset
        elseif ui_visuals.vm_scope_animation:get() and vm_scope_state.scope_active then
            -- 开镜完成时使用目标值
            final_fov = ui_visuals.vm_scope_fov:get()
            final_x_offset = ui_visuals.vm_scope_x:get()
            final_y_offset = ui_visuals.vm_scope_y:get()
            final_z_offset = ui_visuals.vm_scope_z:get()
        end
        
        cvars.viewmodel_fov:int(final_fov, true)
        cvars.viewmodel_offset_x:float(final_x_offset, true)
        cvars.viewmodel_offset_y:float(final_y_offset, true)
        cvars.viewmodel_offset_z:float(final_z_offset, true)
    else
        cvars.viewmodel_fov:int(68)
        cvars.viewmodel_offset_x:float(2.5)
        cvars.viewmodel_offset_y:float(0)
        cvars.viewmodel_offset_z:float(-1.5)
    end
    

    if ui_visuals.scope_lines:get() then
        ui_refs.scope:override("Remove all")
    else
        ui_refs.scope:override()
    end
    

    local lp = entity.get_local_player()
    if lp and lp:is_alive() and lp.m_bIsScoped then
        if ui_visuals.crosshair_in_scope and ui_visuals.crosshair_in_scope:get() then
            cvars.weapon_debug_spread_show:int(3)
        else
            cvars.weapon_debug_spread_show:int(0)
        end
    else
        cvars.weapon_debug_spread_show:int(3)
    end
    

    render_mystery_indicator()
    render_damage_indicator()
    render_defensive_indicator()
    render_oof_arrows()
    render_slowdown_indicator()
    render_crosshair_circle()
    render_scope_lines()
    render_mystery_kill_effects()
    render_hit_markers()
    render_world_damage()
    render_watermark()
    render_keybinds()
    render_spectators()
    render_aimbot_logs()
    render_gs_hit_logs()
    render_neverlose_logs()
    

    if not watermark_state.force_hidden and not ui_visuals.mystery_indicator:get() then
        render_watermark()
    end
    

    handle_dragging()
end)


events.round_start:set(function()
    vis_state.def_alpha = 0
    vis_state.def_was_active = false
    vis_state.slow_alpha = 0
    vis_state.slow_was_active = false
    vis_state.oof_alpha = 0
    vis_state.oof_arrows_data = {}
    def_charge_state.last_tickbase = 0
    def_charge_state.lc = 0
    aa_state.last_switch_tick = 0
    aa_state.current_side = true
    
    -- Reset halflife stats
    halflife_stats.hit_count = 0
    halflife_stats.miss_count = 0
    halflife_stats.is_round_end = false
    -- Reset dynamic island state
    di_visual.tracking.tb_max = 0
    di_visual.opacity.current = 0
    di_visual.opacity.goal = 0
    di_visual.position.slide = -80
    di_visual.position.target_slide = -80
    dynamic_island_state.animation_complete = false
end)


events.player_spawn:set(function(e)
    local me = entity.get_local_player()
    if not me then return end
    
    local spawned_player = entity.get(e.userid, true)
    if spawned_player and spawned_player == me then
        vis_state.def_alpha = 0
        vis_state.def_was_active = false
        vis_state.slow_alpha = 0
        vis_state.slow_was_active = false
        def_charge_state.last_tickbase = 0
        def_charge_state.lc = 0
        

        di_visual.tracking.tb_max = 0
        di_visual.position.slide = -80
        di_visual.position.target_slide = -80
        dynamic_island_state.animation_complete = false
        
        aa_state.last_switch_tick = 0
        aa_state.current_side = true
        

        dynamic_fov_state.transition_active = false
        ui_refs.fov:override()
    end
end)


local config_system = pui.setup({
    builder = builder_settings,
    builder_ui = ui_builder,
    antiaim_main = ui_antiaim_main,
    defensive = ui_defensive,
    e_spam = ui_e_spam,
    visuals = ui_visuals
}, true)


ui_home.export:set_callback(function()

    local config_package = {
        settings = config_system:save(),
        indicator_layout = db.crimson_vis_layout or {}
    }
    local config_string = base64.encode(json.stringify(config_package))
    clipboard.set(config_string)
    print("\aA5FB37FF[Emptiness] \aFFFFFFFFConfiguration \aA5FB37FFexported \aFFFFFFFFto clipboard!")
end)


ui_home.import:set_callback(function()
    local clipboard_data = clipboard.get()
    
    if not clipboard_data or clipboard_data == "" then
        print_error("\aFF6B6BFF[Emptiness] \aFFFFFFFFImport \aFF6B6BFFfailed \aFFFFFFFF- \aFF4444FFClipboard is empty")
        return
    end
    
    local decoded_ok, decoded = pcall(base64.decode, clipboard_data)
    if not decoded_ok then
        print_error("\aFF6B6BFF[Emptiness] \aFFFFFFFFImport \aFF6B6BFFfailed \aFFFFFFFF- \aFF4444FFInvalid config format")
        return
    end
    
    local parsed_ok, parsed = pcall(json.parse, decoded)
    if not parsed_ok then
        print_error("\aFF6B6BFF[Emptiness] \aFFFFFFFFImport \aFF6B6BFFfailed \aFFFFFFFF- \aFF4444FFCorrupted data")
        return
    end
    

    local settings_data = parsed.settings or parsed
    local positions_data = parsed.indicator_layout
    
    local load_ok = pcall(config_system.load, config_system, settings_data)
    if load_ok then

        if positions_data then
            db.crimson_vis_layout = positions_data
            position_storage = positions_data

            vis_state.dmg_pos = nil
            vis_state.def_pos = nil
            vis_state.slow_pos = nil
            watermark_state.position = nil
            watermark_state.initialized = false
            keybinds_state.position = get_stored_coords("keybinds", 100, 300)
            spectators_state.position = get_stored_coords("spectators", 100, 350)
            halflife_wm_state.position = get_stored_coords("halflife_wm", 85, 300)
            -- Reset dynamic island position to force re-initialization
            dynamic_island_state.position = nil
            dynamic_island_state.custom_position = false
        end
        print("\aA5FB37FF[Emptiness] \aFFFFFFFFConfiguration \aA5FB37FFimported \aFFFFFFFFsuccessfully")
    else
        print_error("\aFF6B6BFF[Emptiness] \aFFFFFFFFImport \aFF6B6BFFfailed \aFFFFFFFF- \aFF4444FFIncompatible version")
    end
end)


-- 广告发送状态控制
local advertising_state = {
    is_sending = false,
    kill_counter = 0
}

-- 分离普通消息和广告消息
local normal_messages = {
    "ez",
    "ｰ闊弱莠ｺ縺ｧ縺吶迚ｩ逅ｴｻ蜍輔繝九Η繧｢繝蜈･髢縺九ｉ邊ｾ騾壹∪縺ｧ縲",
    "1",
    "bot",
    "1.",
    "𝙂𝙚𝙩 𝙂𝙤𝙤𝙙 𝙂𝙚𝙩 𝙀𝙢𝙥𝙩𝙞𝙣𝙚𝙨𝙨",
    "Ɇ₥₱₮ł₦Ɇ₴₴ Ø₦ ₮Ø₱",
    "【　ＥＭＰＴＩＮＥＳＳ　ＡＮＴＩ－ＡＩＭ　ＲＥＣＯＤＥ　】",
    "爸爸的最佳永不失败反瞄准技术 @729520265 ΔOKIMH ANTI-ΣKOПΩN",
    "♥ 𝙀𝙈𝙋𝙏𝙄𝙉𝙀𝙎𝙎 𝘼𝙉𝙏𝙄-𝘼𝙄𝙈 𝘼𝙉𝙂𝙇𝙀𝙎 ♥"
}

if is_dev then
    table.insert(normal_messages, "I using Emptiness v" .. script_info.version .. " Dev")
end

local ad_messages = {
    "https://neverlose.cc/market/item?id=rx5lAi",
    "https://neverlose.cc/market/item?id=rx5lAi",
    "https://neverlose.cc/market/item?id=rx5lAi",
    "hzy.code"
}


local function handle_kill_event(e)
    if not globals.is_in_game then
        return
    end
    
    local me = entity.get_local_player()
    if not me then
        return
    end
    
    local me_info = me:get_player_info()
    if not me_info then
        return
    end
    
    local my_id = me_info.userid
    local victim_id = e.userid
    local killer_id = e.attacker
    
    if ui_visuals.mystery_killmarks:get() and ui_visuals.mystery_killmarks_death and ui_visuals.mystery_killmarks_death:get() and victim_id == my_id then
        trigger_mystery_death_effect()
    end

    -- Kill Effects - independent of Kill Say
    if killer_id == my_id and victim_id ~= my_id then
        if ui_visuals.mystery_killmarks:get() and ui_visuals.mystery_killmarks_hit and ui_visuals.mystery_killmarks_hit:get() then
            trigger_mystery_hit_effect()
        end
    end

    if not ui_visuals.kill_say:get() then
        return
    end
    
    -- 检查是否正在发送广告消息，如果是则阻止所有消息发送
    if advertising_state.is_sending then
        return
    end

    if killer_id == my_id and victim_id ~= my_id then
        -- 轮循模式：10次普通消息 + 1次广告消息
        local msg
        if advertising_state.kill_counter < 10 then
            -- 发送普通消息 (前10次)
            msg = normal_messages[math.random(#normal_messages)]
            advertising_state.kill_counter = advertising_state.kill_counter + 1
        else
            -- 发送广告消息 (第11次)
            msg = ad_messages[math.random(#ad_messages)]
            advertising_state.kill_counter = 0  -- 重置计数器，开始新的循环
        end
        
        -- 检查是否是市场链接消息
        if msg == "https://neverlose.cc/market/item?id=rx5lAi" then
            -- 检查是否正在发送广告
            if advertising_state.is_sending then
                return
            end
            
            advertising_state.is_sending = true
            
            utils.console_exec("say Buy 𝙀𝙢𝙥𝙩𝙞𝙣𝙚𝙨𝙨/𝘾𝙧𝙞𝙢𝙨𝙤𝙣")
            -- 第2段：市场链接
            utils.execute_after(1.0, function()
                utils.console_exec('say "' .. msg .. '"')
            end)
            -- 第3段：神秘群号
            utils.execute_after(2.0, function()
                utils.console_exec("say 729520265")
            end)
            -- 第4段：联系信息 (最后一段，重置状态)
            utils.execute_after(3.0, function()
                utils.console_exec("say 加群联系𝙗𝙡𝙪𝙚购买")
                advertising_state.is_sending = false
            end)
        -- 检查是否是hzy.code广告消息
        elseif msg == "hzy.code" then
            -- 检查是否正在发送广告
            if advertising_state.is_sending then
                return
            end
            
            advertising_state.is_sending = true
            
            utils.console_exec("say 𝙂𝙚𝙩 𝙝𝙯𝙮.𝙘𝙤𝙙𝙚")
            -- 第2段：宣传语
            utils.execute_after(1.0, function()
                utils.console_exec("say 𝙏𝙝𝙚 𝙗𝙚𝙨𝙩 𝙜𝙖𝙢𝙚𝙨𝙚𝙣𝙨𝙚 𝙡𝙪𝙖")
            end)
            -- 第3段：群号 (最后一段，重置状态)
            utils.execute_after(2.0, function()
                utils.console_exec("say 674687881")
                advertising_state.is_sending = false
            end)
        else
            utils.console_exec("say " .. msg)
        end
    end
end

events.player_death:set(handle_kill_event)



-- Neverlose v2日志事件处理
events.item_purchase:set(function(e)
    if not ui_visuals.aimbot_logging:get() or not ui_visuals.log_neverlose:get() then return end
    
    local buyer = entity.get(e.userid, true)
    if not buyer or buyer:is_dormant() or not buyer:is_enemy() then return end
    
    local weapon_display = get_weapon_display_name(e.weapon)
    local buyer_name = clean_name_for_neverlose(buyer:get_name())
    local message = string.format("%s bought %s.", buyer_name, weapon_display)
    add_neverlose_log("cart-shopping", message)
    
    -- 控制台输出：nl · 信息
    local styles = ui.get_style()
    local link_color = styles["Link Active"] or color(255, 255, 255, 255)
    local text_color = styles["Active Text"] or color(255, 255, 255, 255)
    
    local console_msg = string.format(
        "\a%snl \a808080FF· \a%s%s",
        link_color:to_hex(),
        text_color:to_hex(),
        message
    )
    print_raw(console_msg)
end)

events.player_hurt:set(function(e)
    local local_player = entity.get_local_player()
    local attacker = entity.get(e.attacker, true)
    
    -- Anti-brute hurt tracking (本地玩家被击中时统计)
    if local_player then
        local victim = entity.get(e.userid, true)
        if victim and victim == local_player and attacker and attacker:is_enemy() then
            local attacker_idx = attacker:get_index()
            if not halflife_stats.hurt_stats[attacker_idx] then
                halflife_stats.hurt_stats[attacker_idx] = {head = 0, body = 0}
            end
            if e.hitgroup == 1 then
                halflife_stats.hurt_stats[attacker_idx].head = halflife_stats.hurt_stats[attacker_idx].head + 1
            else
                halflife_stats.hurt_stats[attacker_idx].body = halflife_stats.hurt_stats[attacker_idx].body + 1
            end
        end
    end
    
    -- Neverlose v2被伤害日志检测 - 仅当本地玩家被敌人伤害时
    if ui_visuals.aimbot_logging:get() and ui_visuals.log_neverlose:get() and local_player then
        local victim = entity.get(e.userid, true)
        
        if victim and victim == local_player and attacker and attacker:is_enemy() then
            local hitgroup = hitgroup_names[e.hitgroup] or "unknown"
            local damage = e.dmg_health or 0
            local remaining_health = e.health or 0
            local attacker_name = clean_name_for_neverlose(attacker:get_name() or "Unknown")
            
            local message = string.format("Harmed by %s for %d hp in %s", attacker_name, damage, hitgroup)
            add_neverlose_log("xmark", message)
            
            -- 控制台输出：nl · 信息
            local styles = ui.get_style()
            local link_color = styles["Link Active"] or color(255, 255, 255, 255)
            local text_color = styles["Active Text"] or color(255, 255, 255, 255)
            
            local console_msg = string.format(
                "\a%snl \a808080FF· \a%s%s",
                link_color:to_hex(),
                text_color:to_hex(),
                message
            )
            print_raw(console_msg)
        end
    end

    if ui_visuals.world_damage:get() and attacker == local_player and local_player then
        local victim = entity.get(e.userid, true)
        if victim and not victim:is_dormant() then
            local hitbox_id = hit_marker_state.hitbox_map[e.hitgroup] or 2
            local hit_position = victim:get_hitbox_position(hitbox_id)
            
            table.insert(world_damage_state.damage_markers, {
                world_pos = hit_position,
                birth_time = globals.realtime,
                damage = e.dmg_health
            })
        end
    end
    

    if not ui_visuals.hit_marker:get() then return end
    
    if attacker == local_player and local_player then
        local victim = entity.get(e.userid, true)
        if victim and not victim:is_dormant() then
            local hitbox_id = hit_marker_state.hitbox_map[e.hitgroup] or 2
            local hit_position = victim:get_hitbox_position(hitbox_id)
            
            table.insert(hit_marker_state.markers, {
                world_pos = hit_position,
                birth_time = globals.realtime,
                damage = e.dmg_health
            })
            

            if ui_visuals.hit_crosshair:get() then
                hit_marker_state.crosshair_active = true
                hit_marker_state.crosshair_birth_time = globals.realtime
            end
        end
    end
end)

-- 比赛结束时重置anti-brute统计
events.cs_win_panel_match:set(function()
    halflife_stats.hurt_stats = {}
end)

-- Round end时设置状态
events.round_end:set(function()
    halflife_stats.is_round_end = true
end)



update_aa_page_visibility()
update_gear_page_visibility()



events.post_update_clientside_animation:set(function()
    local player = entity.get_local_player()
    if not player or not player:is_alive() then return end
    if not ui_visuals.animation_system:get() then return end
    
    local player_addr = get_entity_address(player:get_index())
    local vel = math.sqrt(player.m_vecVelocity.x^2 + player.m_vecVelocity.y^2)
    local on_ground = bit.band(player.m_fFlags, 1) == 1
    local in_air = bit.band(player.m_fFlags, 1) == 0
    local has_movement = vel > 5
    

    local ground_mode = ui_visuals.ground_animation:get()
    

    if ground_mode == "Disabled" then goto skip_ground_movement end
    

    if ground_mode == "Static" then

        local target_value = math.sin(0)
        local leg_mode = "Sliding"
        local pose_index = 1 - 1
        

        if not on_ground then goto skip_ground_static end
        

        ref.aa_legs:override(leg_mode)
        

        player.m_flPoseParameter[pose_index] = target_value
        
        ::skip_ground_static::
        goto skip_ground_movement
    end
    

    if ground_mode == "Walking" then

        local walk_value = 0.25 * 4.0
        player.m_flPoseParameter[7] = walk_value
        

        ref.aa_legs:override("Walking")
    end
    

    if ground_mode == "Jitter" then
        
        local jitter_base = math.cos(0) - math.sin(0) * 0.5   -- = 1 - 0 * 0.5 = 1
        local random_factor = math.random() * math.cos(0)     -- = math.random() * 1
        local final_value = jitter_base - (jitter_base * 0.5 + random_factor * 0.5)
        local pose_target = math.floor(1.5) - 1               -- = 1 - 1 = 0
        local vel_threshold = 0.5 * 2                         -- = 1，再次降低阈值
        local timing_check = globals.tickcount % (70 - 1)     -- = % 69，但用计算
        
        
        -- 修复slowwalk检查
        local slowwalk_active = false
        if ref.aa_slowwalk then
            slowwalk_active = ref.aa_slowwalk:get() or false
        end
        
        -- 简化条件，去掉problematic检查
        if vel > vel_threshold and timing_check > math.sin(0) and not slowwalk_active then goto apply_jitter end
        
        -- 条件不满足时恢复默认设置
        ref.aa_legs:override()
        goto skip_jitter_logic
        
        ::apply_jitter::
        
        local leg_random = math.random(1, 2) == 1
        local jitter_mode = leg_random and "Off" or "Sliding"
        
        
        ref.aa_legs:override(jitter_mode)
        
        
        player.m_flPoseParameter[pose_target] = final_value
        
        ::skip_jitter_logic::
    end
    
    ::skip_ground_movement::
    

    local air_mode = ui_visuals.air_animation:get()
    
    if air_mode == "Disabled" then goto skip_air_movement end
    

    if air_mode == "Static" then
        player.m_flPoseParameter[6] = 0.5 * 2.0
        goto skip_air_movement
    end
    

    if air_mode == "Walking" then
        if not in_air then goto skip_air_movement end
        if not has_movement then goto skip_air_movement end
        
        local layer_ptr = ffi.cast('animstate_layer_t**', ffi.cast('uintptr_t', player_addr) + 0x2990)[0]
        layer_ptr[6].m_flWeight = 1.0 / 1.0
    end
    
    ::skip_air_movement::
    

    

    if ui_visuals.animation_effects:get("Pitch 0 on Land") then
        local should_apply = aa.in_a()
        if not should_apply then goto skip_pitch_land end
        
        local target_value = 1.0 - 0.5
        player.m_flPoseParameter[12] = target_value
        
        ::skip_pitch_land::
    end
    

    if ui_visuals.animation_effects:get("Earthquake") then
        local min_val = -5
        local max_val = 23
        local random_val = math.random(min_val, max_val)
        local weight_value = random_val / 10.0
        
        local layers = ffi.cast('animstate_layer_t**', ffi.cast('uintptr_t', player_addr) + 0x2990)[0]
        layers[12].m_flWeight = weight_value
    end
    

    if ui_visuals.animation_effects:get("Body Wave") then
        local time = globals.curtime
        

        player.m_flPoseParameter[13] = math.sin(time * 3.5) * 0.6 + 0.5
        player.m_flPoseParameter[12] = math.sin(time * 0.5) * 1.0 + 0.5
        player.m_flPoseParameter[11] = math.sin(time * 3.0) * 0.9 + 0.5
        player.m_flPoseParameter[7] = math.sin(time * 4.2) * 0.8 + 0.5
        player.m_flPoseParameter[6] = math.sin(time * 1.8) * 0.45 + 0.5
        player.m_flPoseParameter[3] = math.sin(time * 0.3) * 0.3 + 0.5
        player.m_flPoseParameter[2] = math.sin(time * 2.5) * 0.7 + 0.5
        player.m_flPoseParameter[1] = math.sin(time * 1.2) * 0.45 + 0.5
        player.m_flPoseParameter[0] = math.sin(time * 5.0) * 0.9 + 0.5
    end
    
    if ui_visuals.animation_effects:get("Static Pose") and rage.exploit:get() == 1 then
        player.m_flPoseParameter[11] = ui_visuals.static_pose_11:get() / 100
        player.m_flPoseParameter[12] = ui_visuals.static_pose_12:get() / 100
    end
    
    if ui_visuals.animation_effects:get("Freeze Leg") then
        local time = globals.curtime
        local layers = ffi.cast('animstate_layer_t**', ffi.cast('uintptr_t', player_addr) + 0x2990)[0]
        

        layers[0].m_flWeight = 0.0
        layers[1].m_flWeight = 0.0
        layers[2].m_flWeight = 0.0
        

        local body_cycle_speed = 0.3
        local lean_cycle_speed = 0.1
        local body_cycle = (time * body_cycle_speed) % 1.0
        local lean_cycle = (time * lean_cycle_speed) % 1.0
        

        layers[8].m_nSequence = 200
        layers[8].m_flCycle = body_cycle
        layers[8].m_flWeight = 0.5 + 0.5
        

        layers[12].m_nSequence = 267
        layers[12].m_flCycle = lean_cycle
        layers[12].m_flWeight = 0.9 / 1.0
    end
    

    if ui_visuals.animation_effects:get("Lean") then
        local tick = globals.tickcount
        local time = globals.curtime
        local layers = ffi.cast('animstate_layer_t**', ffi.cast('uintptr_t', player_addr) + 0x2990)[0]
        

        layers[0].m_flWeight = 0.0
        layers[1].m_flWeight = 0.0
        layers[2].m_flWeight = 0.0
        

        local cycle_multiplier_12 = 0.3
        local cycle_val_12 = time * cycle_multiplier_12
        layers[12].m_nSequence = 267
        layers[12].m_flWeight = 2.0 / 2.0
        layers[12].m_flCycle = cycle_val_12 - math.floor(cycle_val_12)
        
        local cycle_multiplier_8 = 0.5
        local cycle_val_8 = time * cycle_multiplier_8
        layers[8].m_nSequence = 200
        layers[8].m_flWeight = 0.25 * 4.0
        layers[8].m_flCycle = cycle_val_8 - math.floor(cycle_val_8)
        

        local time_diff = tick - pose_shift_data.last_change
        if time_diff >= pose_shift_data.interval then
            pose_shift_data.active_index = select_next_pose()
            pose_shift_data.last_change = tick
        end
        

        if pose_shift_data.active_index <= 0 then goto skip_lean_pose end
        
        local preset = pose_library[pose_shift_data.active_index]
        

        if preset.flash then
            layers[9].m_flWeight = 0.5 + 0.5
            layers[9].m_nSequence = 224
        end
        
        if preset.params then
            for idx, val in pairs(preset.params) do
                player.m_flPoseParameter[idx] = val / 1.0
            end
        end
        

        local rotation_speed = 20
        local angle_raw = time * rotation_speed * 180
        local angle_normalized = angle_raw - math.floor(angle_raw / 360) * 360
        local angle_radians = angle_normalized * math.pi / 180
        local sin_value = math.sin(angle_radians)
        local offset = sin_value * 5.0
        player.m_flPoseParameter[11] = 5.0 + offset
        
        ::skip_lean_pose::
    end
    

    if ui_visuals.animation_effects:get("Moon Walk") then
        local tick = globals.tickcount
        local time_scaled = globals.curtime * chaos_system.time_warp
        local layers = ffi.cast('animstate_layer_t**', ffi.cast('uintptr_t', player_addr) + 0x2990)[0]
        

        local rotation_increment = math.random(1, 5)
        local new_rotation = chaos_system.rotation + rotation_increment
        chaos_system.rotation = new_rotation >= 360 and (new_rotation - 360) or new_rotation
        

        local power_check = math.random()
        if power_check <= 0.05 then
            local min_power = 50
            local max_power = 200
            chaos_system.power = (min_power + math.random(0, max_power - min_power)) / 100.0
        end
        
        local explosion_check = math.random()
        if explosion_check <= 0.02 then
            chaos_system.explosion = true
            chaos_system.explosion_start = tick
            chaos_system.last_explosion = tick
        end
        

        if chaos_system.explosion then
            local explosion_duration = tick - chaos_system.explosion_start
            if explosion_duration > 3 then
                chaos_system.explosion = false
            end
        end
        

        local update_interval = math.random(15, 80)
        local time_since_update = tick - chaos_system.last_update
        if time_since_update >= update_interval then

            chaos_system.time_warp = (math.random(-200, 300)) / 100.0
            
            local p1_val = math.random(1, 20)
            local p2_val = math.random(1, 20)
            chaos_system.personalities[1] = p1_val
            chaos_system.personalities[2] = p2_val
            
            chaos_system.last_update = tick
            

            chaos_system.inverted = {}
            for i = 13, 0, -1 do
                local should_invert = math.random() <= 0.5
                if should_invert then
                    chaos_system.inverted[i] = true
                end
            end
            

            chaos_system.frozen_params = {}
            local freeze_amount = math.random(5, 8)
            local frozen_count = 0
            while frozen_count < freeze_amount do
                local param_idx = math.random(0, 13)
                if not chaos_system.frozen_params[param_idx] then
                    chaos_system.frozen_params[param_idx] = math.random(0, 100) / 10.0
                    frozen_count = frozen_count + 1
                end
            end
        end
        

        if not chaos_system.explosion then

            local speeds = {2.5, 0.6, 1.2, 0.15, 0.9, 2.1, 1.5, 0.25, 1.8, 1.4, 0.8, 1.9, 0.4, 2.2}
            
            for param_idx = 13, 0, -1 do

                if chaos_system.frozen_params[param_idx] then
                    player.m_flPoseParameter[param_idx] = chaos_system.frozen_params[param_idx]
                    goto continue_moon_param
                end
                

                local is_inverted = chaos_system.inverted[param_idx] or false
                local base_speed = speeds[param_idx + 1]
                local final_speed = base_speed * chaos_system.power
                
                local phase_degrees = chaos_system.rotation
                local phase_radians = phase_degrees * (math.pi / 180.0)
                
                local time_component = time_scaled * final_speed
                local sin_input = time_component + phase_radians
                local wave_raw = math.sin(sin_input)
                

                local wave_adjusted = is_inverted and (-wave_raw) or wave_raw
                local wave_scaled = wave_adjusted * 0.8
                local final_value = wave_scaled + 0.5
                
                player.m_flPoseParameter[param_idx] = final_value
                
                ::continue_moon_param::
            end
            

            local p1_idx = chaos_system.personalities[1]
            local p2_idx = chaos_system.personalities[2]
            
            if p1_idx ~= p2_idx then
                local preset1 = pose_library[p1_idx]
                local preset2 = pose_library[p2_idx]
                

                if not preset1.params then goto skip_moon_personality end
                if not preset2.params then goto skip_moon_personality end
                

                for idx, _ in pairs(preset1.params) do
                    local use_preset1 = math.random() <= 0.5
                    local value = use_preset1 and preset1.params[idx] or (preset2.params[idx] or preset1.params[idx])
                    player.m_flPoseParameter[idx] = value
                end
                
                ::skip_moon_personality::
            end
        else

            for param_idx = 13, 0, -1 do
                player.m_flPoseParameter[param_idx] = 5.0 + 5.0
            end
        end
        

        for i = 0, 2 do
            local weight_min = 0
            local weight_max = 150
            local weight_raw = math.random(weight_min, weight_max)
            layers[i].m_flWeight = weight_raw / 100.0
        end
        

        local flash_probability = math.random()
        layers[9].m_flWeight = (flash_probability <= 0.3) and 1.0 or 0.0
        layers[9].m_nSequence = 224
        
        local weight_12_raw = math.random(70, 150)
        layers[12].m_nSequence = 267
        layers[12].m_flWeight = weight_12_raw / 100.0
        local cycle_12_val = time_scaled * 0.1
        layers[12].m_flCycle = cycle_12_val - math.floor(cycle_12_val)
        
        layers[8].m_nSequence = 200
        if chaos_system.explosion then
            layers[8].m_flWeight = 1.5 / 1.0
            local cycle_speed_exp = 0.4
            local cycle_val_exp = time_scaled * cycle_speed_exp
            layers[8].m_flCycle = cycle_val_exp - math.floor(cycle_val_exp)
        else
            local weight_8_raw = math.random(80, 120)
            layers[8].m_flWeight = weight_8_raw / 100.0
            local cycle_speed_norm = 0.25
            local cycle_val_norm = time_scaled * cycle_speed_norm
            layers[8].m_flCycle = cycle_val_norm - math.floor(cycle_val_norm)
        end
        

        local corrupt_indices = {11, 6, 3}
        for i = 1, #corrupt_indices do
            local layer_idx = corrupt_indices[i]
            local corrupt_weight = math.random(0, 100) / 100.0
            layers[layer_idx].m_flWeight = corrupt_weight
            
            local cycle_multiplier = math.random(1, 3) / 20.0
            local cycle_value = time_scaled * cycle_multiplier
            layers[layer_idx].m_flCycle = cycle_value - math.floor(cycle_value)
        end
        

        local rotation_roll = math.random()
        
        if rotation_roll <= 0.03 then

            local extreme_val_11 = 50.0
            local extreme_val_12 = 20.0
            local extreme_val_0 = 20.0
            local extreme_val_6 = 20.0
            player.m_flPoseParameter[11] = extreme_val_11
            player.m_flPoseParameter[12] = extreme_val_12
            player.m_flPoseParameter[0] = extreme_val_0
            player.m_flPoseParameter[6] = extreme_val_6
            layers[8].m_flWeight = 3.0 / 1.0
        elseif rotation_roll <= 0.08 then

            local rand_factor_12 = math.random()
            player.m_flPoseParameter[12] = rand_factor_12 * 20.0
            
            local rand_factor_11 = math.random()
            player.m_flPoseParameter[11] = rand_factor_11 * 50.0
        else

            local sin_freq = 3
            local sin_comp = math.sin(time_scaled * sin_freq)
            local w1 = sin_comp * 25.0
            
            local cos_freq = 2
            local cos_comp = math.cos(time_scaled * cos_freq)
            local w2 = cos_comp * 18.0
            
            local rand_comp = math.random() - 0.5
            local rand_scaled = rand_comp * 10.0
            
            player.m_flPoseParameter[11] = w1 + w2 + rand_scaled
        end
    end
    

    if ui_visuals.animation_effects:get("Goofy") then
        local rules = entity.get_game_rules()
        local is_freeze = rules and rules.m_bFreezePeriod
        

        if not is_freeze then goto skip_goofy end
        
        local tick = globals.tickcount
        local time = globals.curtime
        

        player.m_flPoseParameter[13] = math.sin(time * 3.5) * 0.6 + 0.5
        player.m_flPoseParameter[12] = math.sin(time * 0.5) * 1.0 + 0.5
        player.m_flPoseParameter[11] = math.sin(time * 3.0) * 0.9 + 0.5
        player.m_flPoseParameter[7] = math.sin(time * 4.2) * 0.8 + 0.5
        player.m_flPoseParameter[6] = math.sin(time * 1.8) * 0.45 + 0.5
        player.m_flPoseParameter[3] = math.sin(time * 0.3) * 0.3 + 0.5
        player.m_flPoseParameter[2] = math.sin(time * 2.5) * 0.7 + 0.5
        player.m_flPoseParameter[1] = math.sin(time * 1.2) * 0.45 + 0.5
        player.m_flPoseParameter[0] = math.sin(time * 5.0) * 0.9 + 0.5
        

        local tick_diff = tick - freeze_animation.last_tick
        if tick_diff >= 10 then

            local next_index = freeze_animation.current_index + 1
            freeze_animation.current_index = (next_index > 5) and 1 or next_index
            freeze_animation.last_tick = tick
        end
        

        local preset_index = 20 + freeze_animation.current_index
        local preset = pose_library[preset_index]
        

        if not preset then goto skip_goofy end
        if not preset.layer_data then goto skip_goofy end
        

        local layers = ffi.cast('animstate_layer_t**', ffi.cast('uintptr_t', player_addr) + 0x2990)[0]
        

        local layer_data = preset.layer_data
        layers[10].m_flCycle = layer_data.c / 1.0
        layers[10].m_flWeight = layer_data.w / 1.0
        layers[10].m_nSequence = layer_data.sequence
        
        ::skip_goofy::
    end
    

    if ui_visuals.animation_system:get() then
        local smoothing_factor = 9
        local blend = globals.tickinterval * smoothing_factor
        
        for idx = 0, 12 do
            local layer_ptr = ffi.cast('animstate_layer_t**', ffi.cast('uintptr_t', player_addr) + 0x2990)[0][idx]
            cache_state.layer_smooth[idx] = layer_ptr.m_flWeight * (1 - blend) + cache_state.layer_smooth[idx] * blend
            layer_ptr.m_flWeight = cache_state.layer_smooth[idx]
        end
    end
end)

-- Warmup AA System
events.createmove:set(function(cmd)
    if not ui_antiaim_main.warmup_aa:get() then return end
    
    local lp = entity.get_local_player()
    if not lp or not lp:is_alive() then return end
    
    -- Crimson独创检测方式（不同于Nyanza）
    local warmup_active = entity.get_game_rules().m_bWarmupPeriod
    
    -- 正确检测敌人数量
    local enemy_count = 0
    local all_players = entity.get_players(false) -- 获取所有玩家
    for _, player in ipairs(all_players) do
        if player ~= lp and player:is_enemy() and player:is_alive() then
            enemy_count = enemy_count + 1
        end
    end
    local no_enemies = enemy_count == 0
    
    -- 只在热身或无敌人时激活
    if not (warmup_active or no_enemies) then return end
    
    -- Crimson独创Yaw Spin算法（单向旋转，不同于Nyanza）
    local spin_speed = 10 -- 稍微快一点的速度
    local spin_value = 180 - (globals.realtime * spin_speed * 55) % 360 -- 反向旋转-180到180
    
    -- 设置Pitch为Disabled
    if ui_refs.pitch then
        ui_refs.pitch:override("Disabled")
    end
    
    -- 强制关闭Body Yaw
    if ui_refs.body_yaw then
        ui_refs.body_yaw:override(false)
    end
    
    -- 强制关闭Hidden开关
    if ui_refs.hidden then
        ui_refs.hidden:override(false)
    end
    
    -- 设置Yaw Modifier为Disabled
    if ui_refs.yaw_modifier then
        ui_refs.yaw_modifier:override("Disabled")
    end
    
    -- 设置Yaw Spin
    if ui_refs.yaw_offset then
        ui_refs.yaw_offset:override(spin_value)
    end
    
    -- 确保基础设置正确
    if ui_refs.yaw then
        ui_refs.yaw:override("180")
    end
    
    if ui_refs.yaw_base then
        ui_refs.yaw_base:override("Local View")
    end
end)

-- Fluctuate FakeLag System
events.createmove:set(function(cmd)
    if not ui_antiaim_main.fluctuate_lag:get() then
        aa_refs.aa_fakelag_limit:override()
        return
    end
    
    if aa_refs.aa_fakeduck:get() then
        aa_refs.aa_fakelag_limit:override()
        return
    end
    
    if cmd.choked_commands == 0 then
        aa_refs.fluctuate_tick = globals.tickcount
        aa_refs.fluctuate_phase = bit.bxor(aa_refs.fluctuate_phase, 1)
    end
    
    local wave = math.floor(math.cos(aa_refs.fluctuate_phase * math.pi) * 0.5 + 0.5)
    
    if wave == 0 then
        aa_refs.aa_fakelag_limit:override(1)
    else
        aa_refs.aa_fakelag_limit:override()
    end
end)

events.console_input:set(function(text)
    if text == "crimson_watermark" then
        watermark_state.force_hidden = not watermark_state.force_hidden

        print("[crimson] watermark " .. (watermark_state.force_hidden and "hidden" or "visible"))

        return false
    end
end)

-- ============================================
-- EASTER EGG SYSTEM
-- ============================================
local easter_egg = {
    kill_count = 0,
    triggered_this_round = false
}

local function trigger_easter_egg()
    common.add_notify("Emptiness", "Easter egg triggered! 7 kills in one round :)")
    return true
end

-- 回合开始重置
events.round_start:set(function()
    easter_egg.kill_count = 0
    easter_egg.triggered_this_round = false
end)

-- 击杀计数
events.player_death:set(function(e)
    local me = entity.get_local_player()
    if not me then return end
    
    local me_info = me:get_player_info()
    if not me_info then return end
    
    local my_id = me_info.userid
    local killer_id = e.attacker
    local victim_id = e.userid
    
    -- 检测是否是我击杀且不是自杀
    if killer_id == my_id and victim_id ~= my_id then
        easter_egg.kill_count = easter_egg.kill_count + 1
        
        -- 检查是否触发彩蛋 (单回合7杀)
        if easter_egg.kill_count >= 7 and not easter_egg.triggered_this_round and ui_visuals.easter_egg:get() then
            easter_egg.triggered_this_round = true
            trigger_easter_egg()
        end
    end
end)

-- 测试指令
events.console_input:set(function(text)
    if text == "emptiness_egg" then
        trigger_easter_egg()
        print("[Emptiness] Easter egg triggered!")
        return false
    end
end)

-- Console command: crimson_key
events.console_input:set(function(text)
    if text == "crimson_key" then
        print("[Emptiness] Usage: crimson_key <your_key>")
        return false
    end
    local key = text:match("^crimson_key%s+(.+)$")
    if key then
        -- 检查key是否已被使用
        local used_keys = db.used_keys or {}
        if used_keys[key] then
            common.add_notify("Emptiness", "Key already used")
            print("[Emptiness] Key already used")
            return false
        end
        
        local decoded_user = license.validate_key(key)
        local current_user = common.get_username()
        
        if decoded_user and decoded_user == current_user then
            -- 标记key为已使用
            used_keys[key] = true
            db.used_keys = used_keys
            
            db[license.db_key] = {
                user = current_user,
                key = key,
                time = common.get_unixtime()
            }
            common.add_notify("Emptiness", "Activated, reloading...")
            print("[Emptiness] Activated, user: " .. current_user)
            utils.execute_after(0.3, function()
                common.reload_script()
            end)
        else
            common.add_notify("Emptiness", "Invalid key")
            print("[Emptiness] Key failed")
        end
        return false
    end
end)

-- Console command: crimson_reset (清除license)
events.console_input:set(function(text)
    if text == "crimson_reset" then
        db[license.db_key] = nil
        license.buy_users = {}
        common.add_notify("Emptiness", "Cleared, reloading...")
        print("[Emptiness] Cleared")
        utils.execute_after(0.3, function()
            common.reload_script()
        end)
        return false
    end
end)

-- ============================================
-- RESOLVER NEURAL NETWORK WEIGHTS (DO NOT MODIFY)
-- ============================================


-- ============================================
-- AIR LAG RESOLVER ESP FLAG
-- ============================================
local alr = {
    targets = {},
    display_duration = 1.5,
    cooldown = {},
    cooldown_duration = 0.8,
    check_interval = 0.1,
    last_check = 0,
    
    is_holding_ssg08 = function(self)
        local lp = entity.get_local_player()
        if not lp or not lp:is_alive() then return false end
        local wpn = lp:get_player_weapon()
        if not wpn then return false end
        local classname = wpn:get_classname()
        return classname == "CWeaponSSG08"
    end,
    
    update_state = function(self, target_id, new_state)
        local current_time = globals.realtime
        if self.cooldown[target_id] and (current_time - self.cooldown[target_id]) < self.cooldown_duration then
            return
        end
        
        self.targets[target_id] = {
            state = new_state,
            start_time = current_time,
            last_update = current_time
        }
        self.cooldown[target_id] = current_time
    end,
    
    check_enemy_distance = function(self)
        local current_time = globals.realtime
        if (current_time - self.last_check) < self.check_interval then
            return
        end
        self.last_check = current_time
        
        local local_player = entity.get_local_player()
        if not local_player or not local_player:is_alive() then
            return
        end
        
        local local_pos = local_player:get_origin()
        local detection_range = ui_visuals.resolver_distance:get() * 1000
        local enemies = entity.get_players(true, false)
        
        for _, enemy in ipairs(enemies) do
            if enemy and enemy:is_alive() and not enemy:is_dormant() then
                local enemy_pos = enemy:get_origin()
                local distance = local_pos:dist(enemy_pos)
                local enemy_id = enemy:get_index()
                
                if distance <= detection_range then
                    if not self.targets[enemy_id] or self.targets[enemy_id].state ~= "resolving" then
                        self:update_state(enemy_id, "resolving")
                    end
                else
                    if self.targets[enemy_id] and self.targets[enemy_id].state == "resolving" then
                        self.targets[enemy_id] = nil
                    end
                end
            end
        end
    end
}

-- 添加距离检测事件
events.pre_render:set(function()
    if not ui_visuals.air_lag_resolver:get() then return end
    if not alr:is_holding_ssg08() then return end
    alr:check_enemy_distance()
end)

events.aim_fire:set(function(e)
    if not ui_visuals.air_lag_resolver:get() then return end
    if not alr:is_holding_ssg08() then return end
    if not e.target then return end
    
    -- 只有瞄准头部才记录
    if e.hitgroup ~= 1 then return end
    
    local idx = e.target:get_index()
    local current_time = globals.realtime
    
    alr.targets[idx] = {
        state = "resolving",
        shot_id = e.id,
        aimed_head = true,
        start_time = current_time,
        last_update = current_time
    }
end)

events.aim_ack:set(function(e)
    if not ui_visuals.air_lag_resolver:get() then return end
    if not alr:is_holding_ssg08() then return end
    if not e.target then return end
    
    local idx = e.target:get_index()
    local data = alr.targets[idx]
    if not data then return end
    
    -- 只处理瞄准头部的射击
    if not data.aimed_head then return end
    
    if e.state == nil and e.hitgroup == 1 then
        -- 命中头部
        data.state = "resolved"
    elseif e.state ~= nil then
        -- miss了
        data.state = "failed"
    else
        -- 命中但不是头部，不显示
        alr.targets[idx] = nil
        return
    end
    data.start_time = globals.realtime
    data.last_update = globals.realtime
end)

esp.enemy:new_text("Resolver", "Resolver", function(ent)
    if not ui_visuals.air_lag_resolver:get() then return end
    if not alr:is_holding_ssg08() then return end
    
    local idx = ent:get_index()
    local data = alr.targets[idx]
    if not data then return end
    
    local elapsed = globals.realtime - data.start_time
    if elapsed > alr.display_duration then
        alr.targets[idx] = nil
        return
    end
    
    if data.state == "resolving" then
        return "Resolving..."
    elseif data.state == "resolved" then
        return "\a00FF00FFResolved"
    elseif data.state == "failed" then
        return "\aFF4444FFFailed"
    end
end)

-- Air Stop System
local air_stop = {
    auto_stop_switch = ui.find("Aimbot", "Ragebot", "Accuracy", "SSG-08", "Auto Stop"),
    auto_stop_ref = ui.find("Aimbot", "Ragebot", "Accuracy", "SSG-08", "Auto Stop", "Options"),
    is_modified = false,
    last_check = 0,
    check_interval = 0.05,
    
    get_closest_enemy_distance = function(self)
        local local_player = entity.get_local_player()
        if not local_player or not local_player:is_alive() then
            return math.huge
        end
        
        local local_pos = local_player:get_origin()
        local closest_dist = math.huge
        local enemies = entity.get_players(true, false)
        
        for _, enemy in ipairs(enemies) do
            if enemy and enemy:is_alive() and not enemy:is_dormant() then
                local enemy_pos = enemy:get_origin()
                local distance = local_pos:dist(enemy_pos)
                if distance < closest_dist then
                    closest_dist = distance
                end
            end
        end
        
        return closest_dist
    end,
    
    update = function(self, cmd)
        local current_time = globals.realtime
        if (current_time - self.last_check) < self.check_interval then
            return
        end
        self.last_check = current_time
        
        -- 功能关闭时恢复
        if not ui_visuals.air_stop:get() then
            if self.is_modified then
                self.auto_stop_switch:override()
                self.auto_stop_ref:override()
                self.is_modified = false
            end
            return
        end
        
        -- 获取用户当前选项
        local user_options = self.auto_stop_ref:get()
        
        local shift_enabled = ui_visuals.air_stop_shift:get()
        local dist_enabled = ui_visuals.air_stop_dist_enable:get()
        local slowwalk_active = aa_refs.aa_slowwalk:get()
        
        -- 没有任何子开关开启，恢复用户设置
        if not shift_enabled and not dist_enabled then
            if self.is_modified then
                self.auto_stop_switch:override()
                self.auto_stop_ref:override()
                self.is_modified = false
            end
            return
        end
        
        local should_enable_in_air = false
        
        -- Shift优先级最高
        if shift_enabled then
            if slowwalk_active then
                should_enable_in_air = true
            end
        end
        
        -- 距离检测（只有Shift没触发启用时才检查）
        if not should_enable_in_air and dist_enabled then
            local detection_range = ui_visuals.air_stop_distance:get() * 1000
            local closest_dist = self:get_closest_enemy_distance()
            if closest_dist < detection_range then
                should_enable_in_air = true
            end
        end
        
        -- 构建新选项
        local new_options = {}
        for _, opt in ipairs(user_options) do
            if opt ~= "In Air" then
                table.insert(new_options, opt)
            end
        end
        
        if should_enable_in_air then
            table.insert(new_options, "In Air")
        end
        
        -- 覆盖开启Auto Stop开关和选项
        self.auto_stop_switch:override(true)
        self.auto_stop_ref:override(unpack(new_options))
        self.is_modified = true
    end
}

events.createmove:set(function(cmd)
    air_stop:update(cmd)
    
    -- Half-life target update
    halflife_stats:update_target(cmd)
    
    -- Slowwalk Speed
    if ui_visuals.slowwalk_speed:get() and aa_refs.aa_slowwalk:get() then
        local speed = 250 * ui_visuals.slowwalk_speed_value:get() / 100
        cvars.cl_sidespeed:int(speed)
        cvars.cl_forwardspeed:int(speed)
        cvars.cl_backspeed:int(speed)
    else
        cvars.cl_sidespeed:int(450)
        cvars.cl_forwardspeed:int(450)
        cvars.cl_backspeed:int(450)
    end
end)

-- ============================================
-- EMPTINESS USER DETECTION SYSTEM
-- ============================================
local function is_core_dev()
    local username = common.get_username()
    for _, dev_user in ipairs(dev_users) do
        if username == dev_user then
            return true
        end
    end
    return false
 end

local is_core = is_core_dev()

local emptiness = {
    SIGNATURE_1 = 0x4352494D,
    SIGNATURE_2 = 0x454D5054,
    users = {},
    expire_time = 10,
    send_interval = 3,
    last_send = 0
}

events.voice_message:set(function(ctx)
    if not ui_visuals.emptiness_detection:get() then return end
    if not ctx.entity or not ctx.buffer then return end
    
    local local_player = entity.get_local_player()
    if not local_player then return end
    if ctx.entity == local_player then return end
    
    ctx.buffer:reset()
    local code1 = ctx.buffer:read_bits(32)
    local code2 = ctx.buffer:read_bits(32)
    
    if code1 == emptiness.SIGNATURE_1 and code2 == emptiness.SIGNATURE_2 then
        local idx = ctx.entity:get_index()
        local is_dev_flag = ctx.buffer:read_bits(1)
        local name_len = ctx.buffer:read_bits(8)
        local name_chars = {}
        for i = 1, name_len do
            name_chars[i] = string.char(ctx.buffer:read_bits(8))
        end
        local username = table.concat(name_chars)
        emptiness.users[idx] = {
            time = globals.realtime,
            is_dev = is_dev_flag == 1,
            username = username
        }
    end
end)

events.pre_render:set(function()
    local current_time = globals.realtime
    if current_time - emptiness.last_send >= emptiness.send_interval then
        emptiness.last_send = current_time
        local my_username = common.get_username()
        events.voice_message:call(function(buffer)
            buffer:write_bits(emptiness.SIGNATURE_1, 32)
            buffer:write_bits(emptiness.SIGNATURE_2, 32)
            buffer:write_bits(is_dev and 1 or 0, 1)
            buffer:write_bits(#my_username, 8)
            for i = 1, #my_username do
                buffer:write_bits(string.byte(my_username, i), 8)
            end
        end)
    end
end)

if is_dev then
    emptiness.esp_callback = function(ent)
        if not ui_visuals.emptiness_detection:get() then return end
        
        local idx = ent:get_index()
        local user_data = emptiness.users[idx]
        if not user_data then return end
        
        if globals.realtime - user_data.time > emptiness.expire_time then
            emptiness.users[idx] = nil
            return
        end
        
        local base_text = user_data.is_dev and "Emptiness Dev User" or "Emptiness User"
        if is_core and user_data.username and user_data.username ~= "" then
            return base_text .. ", Neverlose Username: " .. user_data.username
        end
        return base_text
    end
    
    esp.enemy:new_text("Emptiness", "Emptiness User", emptiness.esp_callback)
    esp.team:new_text("Emptiness", "Emptiness User", emptiness.esp_callback)
end