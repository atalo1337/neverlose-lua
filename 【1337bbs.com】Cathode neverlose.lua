--by dotmemory
local l_pui_0 = require("neverlose/pui");
local l_clipboard_0 = require("neverlose/clipboard");
local _ = require("neverlose/images");
local l_aim_0 = require("neverlose/anti_aim");
local l_base64_0 = require("neverlose/base64");
local l_gradient_0 = require("neverlose/gradient");
local l_renderer_0 = require("neverlose/b_renderer");
local l_smoothy_0 = require("neverlose/smoothy");
local _ = render.screen_size();
local function v9()

end;
local v10 = {
    anim_list = {}
};
local v11 = {};
local v12 = {};
local v13 = {};
local v14 = render.load_image_from_file("materials/panorama/images/icons/ui/warning.svg", vector(35, 35));
local v15 = {
    rage = {
        enable = ui.find("Aimbot", "Ragebot", "Main", "Enabled"), 
        peek = ui.find("Aimbot", "Ragebot", "Main", "Peek Assist"), 
        hs = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots"), 
        hs_op = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots", "Options"), 
        dt = ui.find("Aimbot", "Ragebot", "Main", "Double Tap"), 
        dt_lag = ui.find("Aimbot", "Ragebot", "Main", "Double Tap", "Lag Options"), 
        dt_lag_limit = ui.find("Aimbot", "Ragebot", "Main", "Double Tap", "Fake Lag Limit"), 
        dt_tp = ui.find("Aimbot", "Ragebot", "Main", "Double Tap", "Immediate Teleport"), 
        dt_qs = ui.find("Aimbot", "Ragebot", "Main", "Double Tap", "Quick-Switch"), 
        fd = ui.find("Aimbot", "Anti Aim", "Misc", "Fake Duck"), 
        bhop = ui.find("Miscellaneous", "Main", "Movement", "Bunny Hop"), 
        hitbox = ui.find("Aimbot", "Ragebot", "Selection", "Hitboxes"), 
        s_head_scale = ui.find("Aimbot", "Ragebot", "Selection", "SSG-08", "Multipoint", "Head Scale"), 
        body_muilt = ui.find("Aimbot", "Ragebot", "Selection", "Multipoint", "Body Scale"), 
        dmg = ui.find("Aimbot", "Ragebot", "Selection", "Min. Damage"), 
        hc = ui.find("Aimbot", "Ragebot", "Selection", "Hit Chance"), 
        sp = ui.find("Aimbot", "Ragebot", "Safety", "Safe Points"), 
        sp_en = ui.find("Aimbot", "Ragebot", "Safety", "Ensure Hitbox Safety"), 
        latency = ui.find("Miscellaneous", "Main", "Other", "Fake Latency"), 
        backtrack = ui.find("Aimbot", "Ragebot", "Main", "Enabled", "Extended Backtrack")
    }, 
    aa = {
        enable = ui.find("Aimbot", "Anti Aim", "Angles", "Enabled"), 
        pitch = ui.find("Aimbot", "Anti Aim", "Angles", "Pitch"), 
        yaw = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw"), 
        yaw_base = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Base"), 
        yaw_offset = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Offset"), 
        backstab = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Avoid Backstab"), 
        hidden = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Hidden"), 
        yaw_jitter = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier"), 
        yj_offset = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier", "Offset"), 
        body_yaw = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw"), 
        by_invert = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Inverter"), 
        by_l = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Left Limit"), 
        by_r = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Right Limit"), 
        by_option = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Options"), 
        by_fs = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Freestanding"), 
        fs = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding"), 
        fs_body = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Body Freestanding"), 
        fs_disable = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Disable Yaw Modifiers"), 
        slow = ui.find("Aimbot", "Anti Aim", "Misc", "Slow Walk"), 
        leg = ui.find("Aimbot", "Anti Aim", "Misc", "Leg Movement"), 
        fl_enable = ui.find("Aimbot", "Anti Aim", "Fake Lag", "Enabled"), 
        fl_var = ui.find("Aimbot", "Anti Aim", "Fake Lag", "Variability"), 
        fl_limit = ui.find("Aimbot", "Anti Aim", "Fake Lag", "Limit")
    }, 
    visual = {
        scope = ui.find("Visuals", "World", "Main", "Override Zoom", "Scope Overlay")
    }
};
math.e = 2.71828;
math.gratio = 1.6180339887;
math.clamp = function(v16, v17, v18)
    return math.min(math.max(v16, v17), v18);
end;
math.lerp = function(v19, v20, v21)
    return v19 + v21 * (v20 - v19);
end;
math.lerpx = function(v22, v23, v24)
    return v23 * (1 - v22) + v24 * v22;
end;
math.lerpy = function(v25, v26, v27)
    return v25 + (v26 - v25) * (v27 * globals.frametime);
end;
math.lerpz = function(v28, v29, v30, v31)
    return v30 * v28 / v31 + v29;
end;
math.round = function(v32)
    return math.floor(v32 + 0.5);
end;
math.rotate_point = function(v33, v34, v35, v36)
    return math.cos(math.rad(v35)) * v36 + v33, math.sin(math.rad(v35)) * v36 + v34;
end;
math.exploit = function()
    local v37 = entity.get_local_player();
    if not v37 then
        return;
    else
        return globals.tickcount > v37.m_nTickBase;
    end;
end;
math.defensive_state = function()
    -- upvalues: v15 (ref)
    local v38 = entity.get_local_player();
    if not v38 or not v38:is_alive() then
        return;
    elseif v15.rage.dt:get() or v15.rage.hs:get() or v15.rage.dt:get_override() or v15.rage.hs:get_override() then
        if v15.rage.dt_lag:get_override() == "Always On" or v15.rage.hs_op:get_override() == "Break LC" then
            return math.exploit() and "\a30FF00FFSafe+" or "\aFF0000FFUnsafe-";
        else
            return "Off";
        end;
    else
        return "Off";
    end;
end;
v10.math_clamp = function(v39, v40, v41)
    return math.min(v41, math.max(v40, v39));
end;
v10.math_lerp = function(v42, v43, _)
    -- upvalues: v10 (ref)
    local v45 = v10.math_clamp(globals.frametime * 7.875, 0, 1);
    if type(v42) == "userdata" then
        local l_r_0 = v42.r;
        local l_g_0 = v42.g;
        local l_b_0 = v42.b;
        local l_a_0 = v42.a;
        local l_r_1 = v43.r;
        local l_g_1 = v43.g;
        local l_b_1 = v43.b;
        local l_a_1 = v43.a;
        l_r_0 = v10.math_lerp(l_r_0, l_r_1, v45);
        l_g_0 = v10.math_lerp(l_g_0, l_g_1, v45);
        l_b_0 = v10.math_lerp(l_b_0, l_b_1, v45);
        l_a_0 = v10.math_lerp(l_a_0, l_a_1, v45);
        return color(l_r_0, l_g_0, l_b_0, l_a_0);
    else
        local v54 = (v43 - v42) * v45 + v42;
        if v43 == 0 and v54 < 0.01 and v54 > -0.01 then
            v54 = 0;
        end;
        if v43 == 1 and v54 < 1.01 and v54 > 0.99 then
            v54 = 1;
        end;
        return v54;
    end;
end;
v10.anim_new = function(v55, v56, v57, v58)
    -- upvalues: v10 (ref)
    if not v10.anim_list[v55] then
        v10.anim_list[v55] = {
            number = 0, 
            call_frame = true, 
            color = color(0, 0, 0, 0)
        };
    end;
    if v57 == nil then
        v10.anim_list[v55].call_frame = true;
    end;
    if not v58 then
        v58 = 0.01;
    end;
    if type(v56) == "userdata" then
        local v59 = v10.math_lerp(v10.anim_list[v55].color, v56, v58);
        v10.anim_list[v55].color = v59;
        return v59;
    else
        local v60 = v10.math_lerp(v10.anim_list[v55].number, v56, v58);
        v10.anim_list[v55].number = v60;
        return v60;
    end;
end;
local v61 = {
    [1] = {
        [1] = "global", 
        [2] = "Global", 
        [3] = "G"
    }, 
    [2] = {
        [1] = "stand", 
        [2] = "Standing", 
        [3] = "S"
    }, 
    [3] = {
        [1] = "moving", 
        [2] = "Moving", 
        [3] = "R"
    }, 
    [4] = {
        [1] = "slow", 
        [2] = "Slow", 
        [3] = "W"
    }, 
    [5] = {
        [1] = "air", 
        [2] = "In air", 
        [3] = "A"
    }, 
    [6] = {
        [1] = "airduck", 
        [2] = "Air crouching", 
        [3] = "AC"
    }, 
    [7] = {
        [1] = "airknife", 
        [2] = "Air knife", 
        [3] = "AK"
    }, 
    [8] = {
        [1] = "airtaser", 
        [2] = "Air taser", 
        [3] = "AT"
    }, 
    [9] = {
        [1] = "ctcrouch", 
        [2] = "CT Crouching", 
        [3] = "CTD"
    }, 
    [10] = {
        [1] = "tcrouch", 
        [2] = "T Crouching", 
        [3] = "TD"
    }, 
    [11] = {
        [1] = "sneak", 
        [2] = "Sneaking", 
        [3] = "DW"
    }, 
    [12] = {
        [1] = "fake lag", 
        [2] = "Fake Lag", 
        [3] = "FL"
    }, 
    [13] = {
        [1] = "fake duck", 
        [2] = "Fake Duck", 
        [3] = "FD"
    }, 
    [14] = {
        [1] = "revolver", 
        [2] = "Revolver", 
        [3] = "RP"
    }
};
local v62 = {
    [1] = "Global", 
    [2] = "Standing", 
    [3] = "Moving", 
    [4] = "Slow", 
    [5] = "In air", 
    [6] = "Air crouching", 
    [7] = "Air knife", 
    [8] = "Air taser", 
    [9] = "CT Crouching", 
    [10] = "T Crouching", 
    [11] = "Sneaking", 
    [12] = "Fake Lag", 
    [13] = "Fake Duck", 
    [14] = "Revolver"
};
local v63 = {
    [0] = "generic", 
    [1] = "head", 
    [2] = "chest", 
    [3] = "stomach", 
    [4] = "left arm", 
    [5] = "right arm", 
    [6] = "left leg", 
    [7] = "right leg", 
    [8] = "neck", 
    [9] = "generic", 
    [10] = "gear"
};
local v64 = {};
local v65 = {
    core = {
        c_fl = 0, 
        ran = 0
    }, 
    tick = {
        last_delay = 0, 
        wait_dt = 0, 
        old = 0, 
        current = 0, 
        random = 0, 
        current_2 = 0
    }, 
    packet = {
        delay_times_2 = 0, 
        delay_times = 0, 
        delay_tick = 0, 
        side_tick = 0, 
        last = 0, 
        sent = 0, 
        lp = 0, 
        shift_ticks = 0
    }, 
    aa = {
        manual_enable = false, 
        last_delay_side = false, 
        sanya = 0, 
        yaw_value = 0, 
        pitch_value = 0, 
        spin_switch = false, 
        spin_value = 0, 
        inverter_override = 0, 
        switch_delay = false, 
        delay_side_lr = 0, 
        side_l_r = 0, 
        side = false
    }, 
    nade = {
        until_drop = 0, 
        timer = 0
    }, 
    flag = {
        inverter_override_ticks = 0, 
        isfl_off = false, 
        fd_reset = false, 
        tick_false = 0, 
        tick_switch = false
    }, 
    player = {
        weapon_switch = 0, 
        status = "nil", 
        origin = vector()
    }, 
    ui = {
        watermark_pos = 17
    }, 
    pair = {
        phase = 0, 
        cached = 0, 
        toggle = false
    }, 
    cycle = {
        frame = 0, 
        index = 1, 
        current = "3-Way", 
        counts = {
            [1] = 4, 
            [2] = 2
        }
    }, 
    sanya = {
        phase = 0, 
        high = 0, 
        low = 0
    }, 
    delay_ctrl = {
        side = 0, 
        last_tick = 0
    }, 
    alt = {
        use_high = true, 
        next_time_2 = 0, 
        use_high_2 = true, 
        next_time = 0
    }, 
    beta = {
        index = 0, 
        counts = {
            [1] = 5, 
            [2] = 5, 
            [3] = 10
        }
    }, 
    flick = {
        counter = 0, 
        explo1 = 0
    }, 
    flu = {
        idx = 0
    }, 
    torpedo = {
        side_delay = 0, 
        switch = false, 
        counter = 0, 
        side = false
    }
};
local v66 = {
    jitter = {
        y_rj = 0, 
        p_rj = 0
    }, 
    side = {
        pitch = 0, 
        yaw = 0, 
        switch_yaw = 0, 
        switch_pitch = 0
    }, 
    switch = {
        yaw = 0, 
        main = 0
    }, 
    cmd = {
        num = 0
    }, 
    clamp = {
        y_clamp = 0, 
        p_clamp = 0
    }, 
    tick = {
        left = 0, 
        max = 0
    }, 
    cmd_tick = {
        cmd_num = 0, 
        left = 0, 
        max = 0
    }, 
    yaw = {
        value = 0, 
        spin_value = 0, 
        last_def_yaw = 0
    }, 
    pitch = {
        value = 0, 
        spin_value = 0, 
        last_def_pitch = 0
    }, 
    tickcount = {
        old_pitch = 1, 
        switch_jitter_yaw = 0, 
        switch_jitter_pitch = 0, 
        current_yaw = 0, 
        current_pitch = 0, 
        old_yaw = 1
    }, 
    flick = {
        random_fluctuation = 0, 
        idx = 0
    }, 
    random = {
        value = 0, 
        switch = false
    }
};
events.level_init:set(function()
    -- upvalues: v65 (ref)
    v65.nade.until_drop = globals.curtime;
end);
local v67 = {
    byaw_r = 1, 
    byaw_v = 0, 
    yaw_r = 1, 
    yaw_v = 0, 
    choke = 0, 
    fyaw_r = 0, 
    fyaw_v = 0
};
local v68 = {
    landtick = 1, 
    state = "nil", 
    last_press = 0, 
    yaw_dir = "Disable", 
    is_ok = false
};
local v69 = {};
local v70 = {};
v69 = v70;
local v71 = {
    high1 = true, 
    next1 = 0, 
    high2 = true, 
    next2 = 0
};
local l_random_int_0 = utils.random_int;
do
    local l_v70_0, l_v71_0, l_l_random_int_0_0 = v70, v71, l_random_int_0;
    l_v70_0.flip = function(v76, v77, v78, v79, v80, v81)
        -- upvalues: l_v71_0 (ref), l_l_random_int_0_0 (ref)
        local l_curtime_0 = globals.curtime;
        local v83 = v81 == 2 and "next2" or "next1";
        local v84 = v81 == 2 and "high2" or "high1";
        if l_v71_0[v83] <= l_curtime_0 then
            l_v71_0[v84] = not l_v71_0[v84];
            l_v71_0[v83] = l_curtime_0 + v80;
        end;
        return l_v71_0[v84] and l_l_random_int_0_0(v76, v77) or l_l_random_int_0_0(v78, v79);
    end;
    l_v70_0.jitter = function(v85, v86, v87, v88, v89, v90, v91)
        -- upvalues: l_l_random_int_0_0 (ref), l_v70_0 (ref)
        if v91 and globals.tickcount % l_l_random_int_0_0(15, 20) > 1 then
            return v85 and v86 or v87;
        else
            return l_v70_0.flip(v86, v87, v88, v89, v90, 2);
        end;
    end;
end;
v70 = 0.083333336;
v71 = {
    to_foot = function(v92)
        -- upvalues: v70 (ref)
        return v92 * v70;
    end, 
    clamp_value = function(v93, v94, v95)
        if v95 < v94 then
            local l_v95_0 = v95;
            v95 = v94;
            v94 = l_v95_0;
        end;
        return math.max(math.min(v93, v95), v94);
    end, 
    normalize_angle = function(v97)
        while v97 > 180 do
            v97 = v97 - 360;
        end;
        while v97 < -180 do
            v97 = v97 + 360;
        end;
        return v97;
    end, 
    get_threat_dist = function(v98, v99)
        return ((v98:get_origin() - v99:get_origin()):length());
    end, 
    get_original = function(v100)
        return tonumber(v100:string());
    end, 
    choke_yaw = function(v101, v102)
        -- upvalues: v67 (ref)
        if globals.tickcount - v67.yaw_v > 1 and globals.choked_commands == 1 then
            v67.yaw_r = v67.yaw_r == 1 and 0 or 1;
            v67.yaw_v = globals.tickcount;
        end;
        local v103 = entity.get_local_player();
        local _ = math.floor(math.min(60, v103.m_flPoseParameter[11] * 120 - 60)) > 0;
        return v67.yaw_r >= 1 and v101 or v102;
    end, 
    safe_load = function(v105, v106, v107)
        local l_status_0, l_result_0 = pcall(render.load_font, v105, v106, v107);
        if not l_status_0 then
            print(("[Font] load %s failed, using default"):format(v105));
            return render.load_font("Arial", 10, "a");
        else
            return l_result_0;
        end;
    end, 
    custom_random = function(v110, v111, v112, v113, v114)
        -- upvalues: v69 (ref)
        return v69.flip(v110, v111, v112, v113, v114, 1);
    end, 
    custom_jitter = function(v115, v116, v117, v118, v119)
        -- upvalues: v69 (ref), v66 (ref)
        return v69.jitter(v66.side.pitch, v115, v116, v117, v118, v119, false);
    end, 
    custom_jitter_yaw = function(v120, v121, v122, v123, v124, v125)
        -- upvalues: v69 (ref), v66 (ref)
        return v69.jitter(v66.side.pitch, v120, v121, v122, v123, v124, v125);
    end, 
    rgba_to_hex = function(v126, v127, v128, v129)
        return string.format("%02x%02x%02x%02x", math.floor(v126), math.floor(v127), math.floor(v128), math.floor(v129));
    end, 
    alpha_to_textformat = function(v130, v131, v132, v133)
        assert(v130 >= 0, "num must be >= 0");
        local v134 = {};
        for v135 = 0, v130 do
            local v136 = (v132[v135] or "FFFFFF") .. v133;
            local v137 = v131[v135] or "";
            v134[#v134 + 1] = ("\a%s%s"):format(v136, v137);
        end;
        return table.unpack(v134);
    end, 
    gradient_text = function(v138, v139, v140, v141, v142, v143, v144, v145, v146)
        local v147 = "";
        local v148 = #v146 - 1;
        local v149 = (v142 - v138) / v148;
        local v150 = (v143 - v139) / v148;
        local v151 = (v144 - v140) / v148;
        local v152 = (v145 - v141) / v148;
        for v153 = 1, v148 + 1 do
            v147 = v147 .. ("\a%02x%02x%02x%02x%s"):format(v138, v139, v140, v141, v146:sub(v153, v153));
            v138 = v138 + v149;
            v139 = v139 + v150;
            v140 = v140 + v151;
            v141 = v141 + v152;
        end;
        return v147;
    end, 
    a_to_hex = function(v154)
        return string.format("%02x", math.floor(v154));
    end, 
    rect_outline = function(v155, v156, v157, v158, v159, v160, v161, v162, v163)
        local v164 = color(v159, v160, v161, v162);
        render.rect(vector(v155, v156), vector(v155 + v157, v156 + v163), v164);
        render.rect(vector(v155, v156 + v163), vector(v155 + v163, v156 + v158), v164);
        render.rect(vector(v155 + v157 - v163, v156 + v163), vector(v155 + v157, v156 + v158), v164);
        render.rect(vector(v155 + v163, v156 + v158 - v163), vector(v155 + v157 - v163, v156 + v158), v164);
    end, 
    rectangle_outline_render = function(v165, v166, v167, v168, v169, v170, v171, v172, v173)
        if not v173 then
            v173 = 1;
        end;
        local v174 = color(v169, v170, v171, v172);
        render.rect(vector(v165, v166), vector(v165 + v167, v166 + v173), v174);
        render.rect(vector(v165, v166 + v168 - v173), vector(v165 + v167, v166 + v168), v174);
        render.rect(vector(v165, v166 + v173), vector(v165 + v173, v166 + v168 - v173), v174);
        render.rect(vector(v165 + v167 - v173, v166 + v173), vector(v165 + v167, v166 + v168 - v173), v174);
    end, 
    remap = function(v175, v176, v177, v178, v179, v180)
        if not v178 then
            v178 = 0;
        end;
        if not v179 then
            v179 = 1;
        end;
        local v181 = (v175 - v178) / (v179 - v178);
        if v180 ~= false then
            v181 = math.min(1, math.max(0, v181));
        end;
        return v176 + (v177 - v176) * v181;
    end, 
    rgb_health_based = function(v182)
        return 248 - 124 * v182, 195 * v182, 13;
    end, 
    bytes_to_hex = function(v183)
        return (v183:gsub(".", function(v184)
            return ("%02X"):format(v184:byte());
        end));
    end, 
    is_bind_active = function(v185)
        for _, v187 in ipairs(ui.get_binds()) do
            if v187.reference:id() == v185 and v187.active then
                return true;
            end;
        end;
        return false;
    end, 
    dropGrenade = function(v188, v189)
        utils.execute_after(v189, function()
            -- upvalues: v188 (ref)
            utils.console_exec(v188);
        end);
    end, 
    get_left_right = function()
        -- upvalues: v15 (ref)
        local _ = "";
        local v191 = v15.aa.by_invert:get_override();
        local _ = entity.get_local_player();
        local v193 = v15.aa.by_l:get_override();
        local v194 = v15.aa.by_r:get_override();
        if v193 ~= 0 or v194 ~= 0 then
            return v191 and "Right" or "Left";
        else
            return "Middle";
        end;
    end, 
    check_charge = function()
        -- upvalues: v15 (ref)
        local l_m_nTickBase_0 = entity.get_local_player().m_nTickBase;
        local v196 = utils.net_channel().latency[1] * 1000;
        return math.floor(l_m_nTickBase_0 - globals.tickcount - 3 - to_ticks(v196) * 0.5 + 0.5 * (v196 * 10)) <= -14 + (v15.rage.dt_lag_limit:get() - 1) + 3;
    end, 
    ambani_rect = function(v197, v198, v199)
        render.rect(vector(v197 - 8, v198 - 5), vector(v199 + 8, v198 + 27), color(30, 30, 30, 255), 5, true);
        render.rect(vector(v197 - 7, v198 - 4), vector(v199 + 7, v198 + 26), color(10, 10, 10, 255), 5, true);
        render.rect(vector(v197 - 6, v198 - 3), vector(v199 + 6, v198 + 25), color(30, 30, 30, 255), 5, true);
        render.rect(vector(v197 - 6, v198 - 3), vector(v199 + 6, v198 + 8), color(129, 119, 181, 255), 5, true);
        render.rect(vector(v197 - 5, v198 - 2), vector(v199 + 5, v198 + 24), color(15, 15, 15, 255), 5, true);
    end, 
    split = function(v200, v201)
        if v201 == nil then
            v201 = "%s";
        end;
        local v202 = {};
        for v203 in string.gmatch(v200, "([^" .. v201 .. "]+)") do
            table.insert(v202, v203);
        end;
        return v202;
    end
};
v71.color_text = function(v204, v205, v206, v207, v208)
    -- upvalues: v71 (ref)
    local v209 = "\a" .. color(v205, v206, v207, v208):to_hex();
    local v210 = "\a" .. color(255, 255, 255, v208):to_hex();
    local v211 = "";
    for v212, v213 in ipairs(v71.split(v204, "$")) do
        v211 = v211 .. (v212 % 2 == (v204:sub(1, 1) == "$" and 0 or 1) and v210 or v209) .. v213;
    end;
    return v211;
end;
v71.RectangleOutline = function(v214, v215, v216, v217, v218, v219, v220, v221, v222)
    local v223 = type(v220) == "userdata" and v220 or color(v220[1], v220[2], v220[3], v220[4]);
    if v223.a <= 0 or v219 <= 0 then
        return;
    else
        local v224 = math.min(v216 / 2, v217 / 2, v218 or 0);
        local v225 = v221 or {
            [1] = true, 
            [2] = true, 
            [3] = true, 
            [4] = true, 
            [5] = true, 
            [6] = true
        };
        if v224 == 0 then
            render.rect(vector(v214, v215), vector(v214 + v216, v215 + v219), v223);
            render.rect(vector(v214, v215 + v217 - v219), vector(v214 + v216, v215 + v217), v223);
            render.rect(vector(v214, v215), vector(v214 + v219, v215 + v217), v223);
            render.rect(vector(v214 + v216 - v219, v215), vector(v214 + v216, v215 + v217), v223);
            return;
        else
            local v226 = v222 or 0.25;
            local v227 = v226 / 0.25;
            if v225[1] then
                render.rect(vector(v214 + v224, v215), vector(v214 + v216 - v224, v215 + v219), v223);
            end;
            if v225[2] then
                render.rect(vector(v214 + v224, v215 + v217 - v219), vector(v214 + v216 - v224, v215 + v217), v223);
            end;
            if v225[3] or v225[1] then
                render.circle_outline(vector(v214 + v224, v215 + v224), v223, v224, 180, v226, v219);
            end;
            if v225[4] or v225[2] then
                render.circle_outline(vector(v214 + v224, v215 + v217 - v224), v223, v224, 90 + (1 - v227) * 90, v226, v219);
            end;
            if v225[5] or v225[1] then
                render.circle_outline(vector(v214 + v216 - v224, v215 + v224), v223, v224, -90 + (1 - v227) * 90, v226, v219);
            end;
            if v225[6] or v225[2] then
                render.circle_outline(vector(v214 + v216 - v224, v215 + v217 - v224), v223, v224, 0, v226, v219);
            end;
            if v225[3] or v225[4] then
                render.rect(vector(v214, v215 + v224), vector(v214 + v219, v215 + v217 - v224), v223);
            end;
            if v225[5] or v225[6] then
                render.rect(vector(v214 + v216 - v219, v215 + v224), vector(v214 + v216, v215 + v217 - v224), v223);
            end;
            return;
        end;
    end;
end;
v71.RenderGlowOutline = function(v228, v229, v230, v231, v232, v233, v234, v235, v236)
    -- upvalues: v71 (ref)
    local v237 = v234.a or v234[4] or 0;
    if v237 <= 0 then
        return;
    else
        for v238 = 0, v232 do
            local v239 = v238 / v232;
            if v237 * v239 > 5 then
                local v240 = v237 * v239 * v239;
                if v240 > 0 then
                    local v241 = type(v234) == "userdata" and color(v234.r, v234.g, v234.b, v240) or color(v234[1], v234[2], v234[3], v240);
                    v71.RectangleOutline(v228 + (v238 - v232), v229 + (v238 - v232), v230 - (v238 - v232 - 1) * 2, v231 + 2 - (v238 - v232) * 2, v233 + (v232 - v238 + 1), 1, v241, v235, v236);
                end;
            end;
        end;
        return;
    end;
end;
v71.RenderGlowOutlineRectangle = function(v242, v243, v244, v245, v246, v247, v248, v249, v250)
    -- upvalues: l_renderer_0 (ref), v71 (ref)
    if v249 then
        local v251 = v248.Background[4] or 255;
        l_renderer_0.blur(vector(v242, v243), vector(v244, v245), v251 / 255, v251 / 255);
    elseif not v249 then
        v71.RenderRoundRectangle(v242, v243, v244, v245, v246, v248.Background);
    end;
    v71.RectangleOutline(v242 - 1, v243 - 1, v244 + 2, v245 + 2, v246, 1, v248.Outline, v249, v250);
    if v247 > 0 then
        v71.RenderGlowOutline(v242 - 2, v243 - 1, v244 + 2, v245, v247, v246, v248.Glow or {
            [1] = v248.Outline[1], 
            [2] = v248.Outline[2], 
            [3] = v248.Outline[3], 
            [4] = 100 * (v248.Outline[4] / 255)
        }, v249, v250);
    end;
end;
v71.roundNumber = function(v252)
    return math.floor(v252 + 0.5);
end;
v71.interpolate = function(v253, v254, v255, v256, v257)
    if not v253 then
        v253 = math.lerpz;
    end;
    if v256 <= 0 or v257 <= v256 then
        return v255;
    else
        local v258 = v253(v256, v254, v255 - v254, v257);
        if math.abs(v255 - v258) < 0.001 then
            v258 = v255;
        else
            local v259 = v258 % 1;
            if v259 < 0.001 then
                v258 = math.floor(v258);
            elseif v259 > 0.999 then
                v258 = math.ceil(v258);
            end;
        end;
        return v258;
    end;
end;
v71.interp = function(v260, v261, v262, v263)
    -- upvalues: v71 (ref)
    if type(v261) == "boolean" then
        v261 = v261 and 1 or 0;
    end;
    return v71.interpolate(v263, v260, v261, globals.frametime, v262);
end;
v71.lerpToggle = function(v264, v265, v266, v267, v268)
    -- upvalues: v13 (ref), v71 (ref)
    local v269 = v265 and v267 or v266;
    local v270 = v13[v264] or v269;
    v270 = v71.interp(v270, v269, v268 or 0.15);
    v13[v264] = v270;
    return v270;
end;
v71.Manual_Glow = function(v271, v272, v273, v274, v275, v276, v277)
    local v278 = math.ceil(v271);
    local v279 = math.ceil(v272);
    local v280 = math.ceil(v273);
    local v281 = math.ceil(v274);
    local l_r_2 = v275.r;
    local l_g_2 = v275.g;
    local l_b_2 = v275.b;
    local l_a_2 = v275.a;
    local v286 = math.max(1, math.floor(v276 * 2));
    for v287 = 0, v286 do
        local v288 = (1 - v287 / v286) ^ 2;
        local v289 = math.floor(l_a_2 * v288);
        if v289 > 0 then
            render.rect_outline(vector(v278 - v287, v279 - v287), vector(v280 + v287, v281 + v287), color(l_r_2, l_g_2, l_b_2, v289), 1, v277 + v287);
        end;
    end;
end;
l_random_int_0 = (function()
    local l_status_1, l_result_1 = pcall(render.load_image, network.get("https://fs-im-kefu.7moor-fs1.com/ly/4d2c3f00-7d4c-11e5-af15-41bf63ae4ea0/1727094534624/Background-Texture-4x4.png"), vector(4, 4));
    if l_status_1 and l_result_1 then
        return l_result_1;
    else
        return false;
    end;
end)();
local function v305(v292, v293, v294, v295, v296, v297)
    -- upvalues: l_random_int_0 (ref), v71 (ref)
    local v298 = {
        x = v292 + 6, 
        y = v293 + (v297 and 10 or 6), 
        w = v294 - 12, 
        h = v295 - (v297 and 16 or 12)
    };
    render.texture(l_random_int_0, vector(v298.x - 1, v298.y - 1), vector(v298.w + 1, v298.h + 1), color(255, 255, 255, 255 * v296), "r");
    v71.rect_outline(v292, v293, v294, v295, 12, 12, 12, 255 * v296, 1);
    v71.rect_outline(v292 + 1, v293 + 1, v294 - 2, v295 - 2, 60, 60, 60, 255 * v296, 1);
    v71.rect_outline(v292 + 2, v293 + 2, v294 - 4, v295 - 4, 40, 40, 40, 255 * v296, 3);
    v71.rect_outline(v292 + 5, v293 + 5, v294 - 10, v295 - 10, 60, 60, 60, 255 * v296, 1);
    if v297 then
        v71.rect_outline(v292 + 6, v293 + 6, v294 - 12, 4, 12, 12, 12, 255 * v296, 1);
        render.rect(vector(v292 + 7, v293 + 8), vector(v292 + 7 + v294 - 14, v293 + 9), color(3, 2, 13, 255 * v296));
        local v299 = math.floor(v294 / 2) - 12;
        local v300 = v294 - v299 - 12;
        local v301 = {
            [1] = 255, 
            [2] = 128
        };
        for v302 = 1, 2 do
            local v303 = v301[v302] * v296;
            local v304 = v293 + v302 + 5;
            render.gradient(vector(v292 + 6, v304), vector(v292 + 6 + v299, v304 + 1), color(55, 177, 218, v303), color(201, 84, 192, v303), color(55, 177, 218, v303), color(201, 84, 192, v303));
            render.gradient(vector(v292 + v299 + 6, v304), vector(v292 + v299 + 6 + v300, v304 + 1), color(201, 84, 192, v303), color(204, 227, 54, v303), color(201, 84, 192, v303), color(204, 227, 54, v303));
        end;
    end;
    return v298;
end;
local v306 = {
    verdana_op = {
        name = "Verdana", 
        flags = "a", 
        size = 20
    }, 
    verdana_nl = {
        name = "Verdana Bold", 
        flags = "au", 
        size = 20
    }, 
    big = {
        name = "Verdana", 
        flags = "ad", 
        size = vector(20, 13.5, 0)
    }, 
    verdana_arrow_chimera = {
        name = "Verdana", 
        flags = "ao", 
        size = 50
    }, 
    museo = {
        name = "museo500", 
        flags = "ad", 
        size = 12
    }, 
    verdana_samp = {
        name = "Verdana Bold", 
        flags = "ad", 
        size = 30
    }, 
    gabriola = {
        name = "Gabriola", 
        flags = "a", 
        size = 34
    }, 
    seoge_s = {
        name = "Segoe Script", 
        flags = "a", 
        size = 37
    }, 
    comic = {
        name = "Comic Sans MS", 
        flags = "a", 
        size = 30
    }, 
    gs_ind = {
        name = "C:\\Windows\\Fonts\\calibrib.ttf", 
        flags = "a", 
        size = vector(44, 29.5, 0.2)
    }, 
    pixel = {
        name = "Smallest Pixel-7", 
        flags = "aou", 
        size = 9
    }, 
    medium = {
        name = "C:\\Windows\\Fonts\\calibrib.ttf", 
        flags = "a", 
        size = vector(14, 9.5, 0)
    }
};
local v307 = {};
for v308, v309 in pairs(v306) do
    v307[v308] = v71.safe_load(v309.name, v309.size, v309.flags);
end;
v307.manual = (function()
    -- upvalues: v307 (ref)
    local function v315(v310, v311, v312)
        -- upvalues: v307 (ref)
        local l_status_2, l_result_2 = pcall(render.load_font, v310, v311, v312);
        return l_status_2 and l_result_2 or v307.pixel;
    end;
    return {
        verdana_default = v315("Verdana", 36, "a"), 
        verdana_de_disable = v315("Verdana", 30, "a"), 
        verdana_3_de = v315("Verdana", 50, "ao"), 
        verdana_3_de_dis = v315("Verdana", 50, "a"), 
        verdana_2_de = v315("Verdana", 34, "a"), 
        verdana_new = v315("Verdana", 24, "a"), 
        verdana_2_de_dis = v315("Verdana", 40, "a"), 
        gabriola = v315("Gabriola", 40, "a"), 
        segoe = v315("Segoe Script", 46, "a"), 
        verdana_default_o = v315("Verdana", 36, "ao"), 
        verdana_new_o = v315("Verdana", 24, "ao"), 
        verdana_2_de_o = v315("Verdana", 34, "ao")
    };
end)();
local v319 = (function()
    local v316 = {
        use_high = true, 
        next_time = 0
    };
    return function(v317)
        -- upvalues: v316 (ref)
        local l_curtime_1 = globals.curtime;
        if v316.next_time <= l_curtime_1 then
            v316.use_high = not v316.use_high;
            v316.next_time = l_curtime_1 + v317;
        end;
        if v316.use_high then
            return utils.random_int(46, 60);
        else
            return utils.random_int(20, 40);
        end;
    end;
end)();
local function v321(v320)
    -- upvalues: v65 (ref)
    if entity.get_local_player() == nil then
        return;
    else
        if v320.choked_commands == 0 then
            v65.packet.sent = v65.packet.sent + 1;
        end;
        return;
    end;
end;
events.createmove:set(function(v322)
    -- upvalues: v321 (ref)
    v321(v322);
end);
local v323 = nil;
v323 = {};
local v324 = {};
do
    local l_v324_0 = v324;
    v323.get = function(v326)
        -- upvalues: l_v324_0 (ref)
        local v327 = l_v324_0[v326];
        if v327 == nil then
            v327 = ui.get_icon(v326);
            l_v324_0[v326] = v327;
        end;
        return v327;
    end;
end;
v324 = nil;
local function v329()
    -- upvalues: l_pui_0 (ref)
    if l_pui_0.get_alpha() <= 0 then
        return;
    else
        local _ = l_pui_0.get_style();
        l_pui_0.sidebar("\240\157\151\176\240\157\151\174\240\157\152\129\240\157\151\181\240\157\151\188\240\157\151\177\240\157\151\178" .. "", "code-simple");
        return;
    end;
end;
events.render(v329);
v329 = nil;
v329 = {};
local v330 = v323.get("house-chimney");
v329.tab = {
    content = {
        [1] = "\f<graduation-cap>  Home", 
        [2] = "\f<user-gear>  Config"
    }, 
    main = l_pui_0.create(v330, "\v" .. v323.get("house-chimney") .. "\r  Home", 1), 
    sub_info = l_pui_0.create(v330, "\v" .. v323.get("landmark") .. "\r  Info", 2), 
    link = l_pui_0.create(v330, "\v" .. v323.get("link") .. "\r  Link", 1), 
    config_sub = l_pui_0.create(v330, "\v" .. v323.get("gear") .. "\r  Config", 2), 
    preset = l_pui_0.create(v330, "\v" .. v323.get("file-import") .. "\r  Preset", 1)
};
v329.page = v329.tab.main:list("", v329.tab.content);
local l_sub_info_0 = v329.tab.sub_info;
local l_link_0 = v329.tab.link;
local l_config_sub_0 = v329.tab.config_sub;
v329.info = {
    name_label = l_sub_info_0:label("\v" .. v323.get("user") .. "  \rUser  "), 
    user_name = l_sub_info_0:button("\v" .. common.get_username(), v9, true), 
    time_title = l_sub_info_0:label("\v" .. v323.get("calendar") .. "  \rLast Update  "), 
    time = l_sub_info_0:button("\v" .. "25/07/15", v9, true), 
    version_title = l_sub_info_0:label("\v" .. v323.get("code-branch") .. "  \rBuild  "), 
    version = l_sub_info_0:button("\v" .. "Recode", v9, true), 
    discord_server = l_link_0:button("     \a5662F6FF\f<discord>\r  Join Us    ", function()
        panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://discord.gg/bnNGeQEZ24");
    end, true), 
    author_cfg = l_link_0:button("\v" .. "     \f<gear>\r  Author Config    ", function()
        panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://neverlose.cc/market/item?id=U0YssN");
    end, true), 
    elyzo = l_link_0:label("           -- Try This Really Good Script --       "), 
    code = l_link_0:button("\v" .. "                            \f<link-horizontal>\r  Elyzo                                   ", function()
        panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://neverlose.cc/market/item?id=NC1NDY");
    end, true)
};
l_pui_0.traverse(v329.info, function(v334, _)
    -- upvalues: v329 (ref)
    v334:depend({
        [1] = nil, 
        [2] = 1, 
        [1] = v329.page
    });
end);
v330 = {};
l_sub_info_0 = {};
l_link_0 = nil;
l_config_sub_0 = v323.get("shield");
l_link_0 = {
    tab = {
        option = {
            [1] = "\f<link-horizontal>  \240\157\151\154\240\157\151\178\240\157\151\187\240\157\151\178\240\157\151\191\240\157\151\174\240\157\151\185", 
            [2] = "\f<planet-ringed>  \240\157\151\148\240\157\151\187\240\157\152\129\240\157\151\182-\240\157\151\148\240\157\151\182\240\157\151\186", 
            [3] = "\f<person-walking-dashed-line-arrow-right> \240\157\151\153\240\157\151\174\240\157\151\184\240\157\151\178 \240\157\151\159\240\157\151\174\240\157\151\180"
        }, 
        selectab = l_pui_0.create(l_config_sub_0, "\n\n", 1), 
        main = l_pui_0.create(l_config_sub_0, "\n\n\n", 2), 
        sub = l_pui_0.create(l_config_sub_0, "\n\n\n\n\n\n", 1), 
        cnd_list = l_pui_0.create(l_config_sub_0, "", 2), 
        build = l_pui_0.create(l_config_sub_0, "", 2), 
        yawbase = l_pui_0.create(l_config_sub_0, "\n\n\n\n\n", 2), 
        modifier = l_pui_0.create(l_config_sub_0, "\n\n\n\n\n\n\n", 1), 
        desync = l_pui_0.create(l_config_sub_0, "\n\n\n\n\n\n\n\n\n\n\n\n", 1), 
        mode = l_pui_0.create(l_config_sub_0, "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n", 2), 
        fakelag = l_pui_0.create(l_config_sub_0, "\n\n\n\n\n\n\n\n\n", 2), 
        shot = l_pui_0.create(l_config_sub_0, "\n\n\n\n\n\n\n\n", 1)
    }
};
local l_selectab_0 = l_link_0.tab.selectab;
local l_main_0 = l_link_0.tab.main;
local l_sub_0 = l_link_0.tab.sub;
local l_cnd_list_0 = l_link_0.tab.cnd_list;
local l_fakelag_0 = l_link_0.tab.fakelag;
local l_shot_0 = l_link_0.tab.shot;
l_link_0.general = {
    master = l_selectab_0:switch("\226\128\162  \240\157\151\160\240\157\151\174\240\157\152\128\240\157\152\129\240\157\151\178\240\157\151\191 \240\157\151\166\240\157\152\132\240\157\151\182\240\157\152\129\240\157\151\176\240\157\151\181"), 
    page = l_selectab_0:list("", l_link_0.tab.option)
};
l_link_0.fakelag_enable = {
    enable = l_fakelag_0:switch("\226\128\162  \240\157\151\153\240\157\151\174\240\157\151\184\240\157\151\178 \240\157\151\159\240\157\151\174\240\157\151\180"), 
    onshot = l_shot_0:switch("On Shot")
};
l_link_0.fakelag = {
    mode = l_fakelag_0:combo("Mode", {
        [1] = "Neverlose", 
        [2] = "Fluctuate", 
        [3] = "Random", 
        [4] = "Cycle"
    }), 
    limit = l_fakelag_0:slider("Limit", 1, 17, 1), 
    min = l_fakelag_0:slider("Min", 1, 17, 1), 
    max = l_fakelag_0:slider("Max", 1, 17, 1), 
    step = l_fakelag_0:slider("Step", 1, 100, 1), 
    force = l_fakelag_0:switch("Force Packet"), 
    nade = l_fakelag_0:switch("Throw Nade Optimize"), 
    disable = l_fakelag_0:switch("Disable FL on Exploits")
};
l_link_0.fakelag_shot = {
    shot_optimzed = l_shot_0:selectable("Optimize", {
        [1] = "Reset Desync", 
        [2] = "Reset FL", 
        [3] = "Choke", 
        [4] = "Send_Packet"
    }), 
    shot_peek = l_shot_0:switch("[Desync] Only Peek"), 
    shot_peek_choke = l_shot_0:switch("[Choke] Only Peek")
};
l_link_0.set = {
    freestand = l_main_0:switch("Freestanding"), 
    manual = l_main_0:combo("Manual", {
        [1] = "Disabled", 
        [2] = "Left", 
        [3] = "Right", 
        [4] = "Forward"
    }), 
    safehead = l_main_0:switch("Safe Head"), 
    fastladder = l_main_0:switch("Fast Ladder"), 
    aimtick = l_main_0:switch("Decrease Hold Aim Tick"), 
    fdspeed = l_main_0:switch("Unlock FD Speed"), 
    autohs = l_main_0:switch("Scout Auto OS"), 
    airlag = l_main_0:switch("Airlag"), 
    recharge = l_main_0:switch("DT Force Recharge"), 
    slowspeed = l_main_0:switch("Custom Slow Walk Speed"), 
    revolver = l_main_0:switch("Force Revolver State")
};
l_link_0.all_set = {
    at_target = l_sub_0:switch("At Target"), 
    avoid = l_sub_0:switch("Avoid Backstab")
};
l_link_0.gear = {
    fs_op = l_link_0.set.freestand:create(), 
    manual_op = l_link_0.set.manual:create(), 
    safehead_op = l_link_0.set.safehead:create(), 
    airlag_op = l_link_0.set.airlag:create(), 
    slowspeed_op = l_link_0.set.slowspeed:create()
};
l_link_0.condition = {
    cnd_list = l_cnd_list_0:combo("\226\128\162  \240\157\151\150\240\157\151\188\240\157\151\187\240\157\151\177\240\157\151\182\240\157\152\129\240\157\151\182\240\157\151\188\240\157\151\187", v62)
};
l_link_0.safe_head = {
    above = l_link_0.gear.safehead_op:selectable("Options", "Above Enemy")
};
l_link_0.set_sub = {
    fs_op = l_link_0.gear.fs_op:listable("", {
        [1] = "Disable Defensive", 
        [2] = "Force Static"
    }), 
    manual_op = l_link_0.gear.manual_op:listable("", {
        [1] = "Disable Defensive", 
        [2] = "Force Static", 
        [3] = "Local View"
    }), 
    airlag_op = l_link_0.gear.airlag_op:switch("On Enemy Visiable"), 
    airlag_tick = l_link_0.gear.airlag_op:slider("Tick", 4, 35, 8, nil, " t."), 
    slowspeed_op = l_link_0.gear.slowspeed_op:slider("Speed", 1, 450, 20)
};
for _, v343 in pairs(v61) do
    local v344 = v343[1];
    local v345 = v343[2];
    local v346 = v343[3];
    local l_macros_0 = l_pui_0.macros;
    local v348 = "_p";
    local v349 = {};
    l_macros_0[v348] = "\n" .. v346;
    v330[v344] = v349;
    l_macros_0 = v330[v344];
    v348 = l_link_0.tab.build;
    v349 = l_link_0.tab.yawbase;
    local l_modifier_0 = l_link_0.tab.modifier;
    local l_desync_0 = l_link_0.tab.desync;
    local _ = l_link_0.tab.mode;
    if v344 ~= "global" then
        l_macros_0.enable = v348:switch("Enabled " .. "\v" .. v345 .. "\r Condition");
    end;
    l_macros_0.pitch = v349:combo("Pitch", {
        [1] = "Down", 
        [2] = "Disabled", 
        [3] = "Fake Down", 
        [4] = "Fake Up"
    });
    l_macros_0.yaw_target = v349:slider("Offset", -180, 180, 0, nil, "\194\176");
    l_macros_0.yaw_mode = v349:combo("Yaw Mode", {
        [1] = "Jitter", 
        [2] = "Choke"
    });
    l_macros_0.yaw_mode_gear = l_macros_0.yaw_mode:create();
    l_macros_0.yaw_fluctate_enable = l_macros_0.yaw_mode_gear:switch("Fluctuate Yaw");
    l_macros_0.yaw_fluctate = l_macros_0.yaw_mode_gear:slider("Yaw", -180, 180, 0, nil, "\194\176");
    l_macros_0.yaw_offset = v349:slider("Base", -180, 180, 0, nil, "\194\176");
    l_macros_0.yaw_left = v349:slider("Left", -180, 180, 0, nil, "\194\176");
    l_macros_0.yaw_right = v349:slider("Right", -180, 180, 0, nil, "\194\176");
    l_macros_0.modifier_mode = v349:combo("Modifier Mode", {
        [1] = "Disabled", 
        [2] = "Jitter", 
        [3] = "Sway Jitter", 
        [4] = "Sanya", 
        [5] = "Torpedo"
    });
    l_macros_0.modifier_mode_offset = v349:slider("Amount", -180, 180, 0, nil, "\194\176");
    l_macros_0.modifier_mode_gear = l_macros_0.modifier_mode:create();
    l_macros_0.modifier_sway_speed = l_macros_0.modifier_mode_gear:slider("Speed", 1, 10, 0, nil, " t");
    l_macros_0.modifier_random = v349:switch("Randomize");
    l_macros_0.modifier_random_mode = v349:combo("Mode", {
        [1] = "Default", 
        [2] = "Min-Max"
    });
    l_macros_0.modifier_random_default = v349:slider("Default", -180, 180, 0, nil, "\194\176");
    l_macros_0.modifier_random_min = v349:slider("Min", -180, 180, 0, nil, "\194\176");
    l_macros_0.modifier_random_max = v349:slider("Max", -180, 180, 0, nil, "\194\176");
    l_macros_0.modifier_torpedo_random = l_macros_0.modifier_mode_gear:switch("Randomize Speed");
    l_macros_0.modifier_torpedo_speed_1 = l_macros_0.modifier_mode_gear:slider("Yaw Speed #1", 2, 10, 2);
    l_macros_0.modifier_torpedo_speed_2 = l_macros_0.modifier_mode_gear:slider("Yaw Speed #2", 2, 10, 2);
    l_macros_0.modifier_torpedo_lagcomp = l_macros_0.modifier_mode_gear:switch("Disabled\194\160on\194\160Lag-Comp");
    l_macros_0.modifier_sanya_switcher = l_macros_0.modifier_mode_gear:switch("Inverter");
    l_macros_0.modifier_sanya_speed = l_macros_0.modifier_mode_gear:slider("Switch Speed", 2, 10, 4);
    l_macros_0.delay_base = l_macros_0.modifier_mode_gear:combo("Delay Base", {
        [1] = "Neverlose", 
        [2] = "Inverter", 
        [3] = "Limit"
    });
    l_macros_0.delay_mode = l_macros_0.modifier_mode_gear:combo("Delay Mode", {
        [1] = "Static", 
        [2] = "Jitter", 
        [3] = "Random", 
        [4] = "Random Jitter", 
        [5] = "Fluctuate", 
        [6] = "Cycle", 
        [7] = "Random Trigger", 
        [8] = "Custom"
    });
    l_macros_0.delay_sections = l_macros_0.modifier_mode_gear:slider("Sections", 1, 10, 1);
    l_macros_0.delay_custom_tbl = {};
    for v353 = 1, 10 do
        l_macros_0.delay_custom_tbl[v353] = l_macros_0.modifier_mode_gear:slider("[" .. v353 .. "] Tick", 1, 30, 1, nil, " t."):depend({
            [1] = nil, 
            [2] = nil, 
            [3] = 11, 
            [1] = l_macros_0.delay_sections, 
            [2] = v353
        });
    end;
    l_macros_0.delay_custom_tick = l_macros_0.modifier_mode_gear:slider("Switch Speed", 2, 45, 2, nil, " t.");
    l_macros_0.delay_custom_random = l_macros_0.modifier_mode_gear:switch("Random Order");
    l_macros_0.delay_static_tick = l_macros_0.modifier_mode_gear:slider("Static", 1, 35, 1, nil, " t.");
    l_macros_0.delay_min_tick = l_macros_0.modifier_mode_gear:slider("Min Tick", 1, 35, 1, nil, " t.");
    l_macros_0.delay_max_tick = l_macros_0.modifier_mode_gear:slider("Max Tick", 1, 35, 1, nil, " t.");
    l_macros_0.delay_jittertick_repeat = l_macros_0.modifier_mode_gear:slider("Repeat", 10, 100, 0, nil, " f.");
    l_macros_0.delay_cycle_speed = l_macros_0.modifier_mode_gear:slider("Speed", 1, 40, 0, nil, " t.");
    l_macros_0.desync = v349:combo("Desync", {
        [1] = "Disabled", 
        [2] = "Static", 
        [3] = "Jitter"
    });
    l_macros_0.desync_gear = l_macros_0.desync:create();
    l_macros_0.desync_period = l_macros_0.desync_gear:switch("Period jitter");
    l_macros_0.desync_anti_bru = l_macros_0.desync_gear:switch("Avoid Overlap");
    l_macros_0.desync_switch_fs = l_macros_0.desync_gear:switch("Switch Freestanding");
    l_macros_0.desync_invert = l_macros_0.desync_gear:switch("Inverter");
    l_macros_0.desync_anglemode = l_macros_0.desync_gear:combo("Angle Mode", {
        [1] = "Disabled", 
        [2] = "Ambani", 
        [3] = "Random", 
        [4] = "Dynamic", 
        [5] = "Switch"
    });
    l_macros_0.desync_switch_logic = l_macros_0.desync_gear:combo("Logic", {
        [1] = "Delay", 
        [2] = "Defensive"
    });
    l_macros_0.desync_left = v349:slider("Left Limit", 0, 60, 0, nil, "\194\176");
    l_macros_0.desync_right = v349:slider("Right Limit", 0, 60, 0, nil, "\194\176");
    l_macros_0.defensive = l_modifier_0:switch("Defensive");
    l_macros_0.defensive_gear = l_macros_0.defensive:create();
    l_macros_0.defensive_onpeek = l_macros_0.defensive_gear:switch("On Peek");
    l_macros_0.defensive_use_mode = l_modifier_0:combo("Defensive Mode", {
        [1] = "Normal", 
        [2] = "Ambani Flick"
    });
    l_macros_0.defensive_mode = l_modifier_0:combo("LC Mode", {
        [1] = "Neverlose", 
        [2] = "Flick", 
        [3] = "Custom", 
        [4] = "Limit"
    });
    l_macros_0.defensive_mode_gear = l_macros_0.defensive_mode:create();
    l_macros_0.defensive_mode_check = l_macros_0.defensive_mode_gear:combo("Check Mode", {
        [1] = "Tickbase", 
        [2] = "Command Num"
    });
    l_macros_0.defensive_flick_trigger = l_macros_0.defensive_mode_gear:combo("Mode", {
        [1] = "Simple", 
        [2] = "Advance"
    });
    l_macros_0.defensive_flick_tick_mode = l_macros_0.defensive_mode_gear:combo("Tick Mode", {
        [1] = "Static", 
        [2] = "Random", 
        [3] = "Random Static", 
        [4] = "Random Trigger", 
        [5] = "Random Jitter", 
        [6] = "Jitter", 
        [7] = "Cycle", 
        [8] = "Beta"
    });
    l_macros_0.defensive_flick_tick_min = l_macros_0.defensive_mode_gear:slider("Min.", 1, 22, 8, nil, " t.");
    l_macros_0.defensive_flick_tick_max = l_macros_0.defensive_mode_gear:slider("Max.", 1, 22, 8, nil, " t.");
    l_macros_0.defensive_mode_min = l_macros_0.defensive_mode_gear:slider("Min .", 0, 15, 0, nil, " t.");
    l_macros_0.defensive_mode_max = l_macros_0.defensive_mode_gear:slider("Max .", 0, 15, 0, nil, " t.");
    l_macros_0.defensive_flick_cycle_speed = l_macros_0.defensive_mode_gear:slider("Speed", 1, 40, 0, nil, " t.");
    l_macros_0.defensive_flick_jitter_repeat = l_macros_0.defensive_mode_gear:slider("Repeat", 10, 100, 0, nil, " f.");
    l_macros_0.defensive_mode_tick = l_macros_0.defensive_mode_gear:slider("Trigger", 1, 22, 8, nil, " t.");
    l_macros_0.defensive_flick_packets = l_macros_0.defensive_mode_gear:slider("Packets", 0, 22, 11);
    l_macros_0.defensive_flick_hidden = l_macros_0.defensive_mode_gear:switch("Hidden");
    l_macros_0.defensive_flick_limit = l_macros_0.defensive_mode_gear:switch("Limit");
    l_macros_0.defensive_flick_desync_release = l_macros_0.defensive_mode_gear:switch("\aFF0000FFRelease Desync");
    l_macros_0.defensive_flick_desync_mode = l_macros_0.defensive_mode_gear:combo("Mode", {
        [1] = "Follow", 
        [2] = "Invert"
    });
    l_macros_0.defensive_flick_desync_release:depend({
        [1] = nil, 
        [2] = "Neverlose", 
        [3] = true, 
        [1] = l_macros_0.defensive_mode
    });
    l_macros_0.defensive_flick_desync_mode:depend({
        [1] = nil, 
        [2] = "Neverlose", 
        [3] = true, 
        [1] = l_macros_0.defensive_mode
    }, {
        [1] = nil, 
        [2] = true, 
        [1] = l_macros_0.defensive_flick_desync_release
    });
    l_macros_0.defensive_pitch = l_desync_0:combo("Pitch", {
        [1] = "Disabled", 
        [2] = "Static", 
        [3] = "Jitter", 
        [4] = "Random", 
        [5] = "Spin", 
        [6] = "Wraith", 
        [7] = "Random Jitter", 
        [8] = "Cycle Spin", 
        [9] = "Switch Random", 
        [10] = "Switch Jitter", 
        [11] = "Random Static", 
        [12] = "LC End", 
        [13] = "89-Random", 
        [14] = "Wave"
    });
    l_macros_0.defensive_pitch_static = l_desync_0:slider("Static", -89, 89, 0, nil, "\194\176");
    l_macros_0.defensive_pitch_min = l_desync_0:slider("Min .", -89, 89, 0, nil, "\194\176");
    l_macros_0.defensive_pitch_max = l_desync_0:slider("Max .", -89, 89, 0, nil, "\194\176");
    l_macros_0.defensive_pitch_min_2 = l_desync_0:slider("Min 2.", -89, 89, 0, nil, "\194\176");
    l_macros_0.defensive_pitch_max_2 = l_desync_0:slider("Max 2.", -89, 89, 0, nil, "\194\176");
    l_macros_0.defensive_pitch_switch = l_desync_0:slider("Switch", 1, 14, 1, nil, " t.");
    l_macros_0.defensive_pitch_speed = l_desync_0:slider("Speed", 1, 45, 0, nil, " t.");
    l_macros_0.defensive_pitch_wave_period = l_desync_0:slider("Period ", 5, 100, 30, nil, " ms");
    l_macros_0.defensive_pitch_wave_type = l_desync_0:combo("Type", {
        [1] = "Triangle", 
        [2] = "Sine", 
        [3] = "Saw"
    });
    l_macros_0.defensive_pitch_wave_invert = l_desync_0:switch("Invert Direction", false);
    l_macros_0.defensive_pitch_jitter_speed = l_desync_0:slider("Delay", 1, 50, 0, nil, " t.");
    l_macros_0.defensive_yaw = l_desync_0:combo("Yaw", {
        [1] = "Disabled", 
        [2] = "Static", 
        [3] = "Hidden", 
        [4] = "Jitter", 
        [5] = "Spin", 
        [6] = "Wraith", 
        [7] = "Random", 
        [8] = "Random Jitter", 
        [9] = "Spin Jitter", 
        [10] = "Cycle Spin", 
        [11] = "Switch Random", 
        [12] = "Flick", 
        [13] = "Switch Jitter", 
        [14] = "Adaptive", 
        [15] = "Random Static", 
        [16] = "LC End", 
        [17] = "180-Random", 
        [18] = "90 Random", 
        [19] = "Random Offset", 
        [20] = "Clock"
    });
    l_macros_0.defensive_yaw_gear = l_macros_0.defensive_yaw:create();
    l_macros_0.defensive_yaw_flick = l_macros_0.defensive_yaw_gear:switch("Use Flick Switch");
    l_macros_0.defensive_yaw_static = l_desync_0:slider("Static", -180, 180, 0, nil, "\194\176");
    l_macros_0.defensive_yaw_min = l_desync_0:slider("Min .", -180, 180, 0, nil, "\194\176");
    l_macros_0.defensive_yaw_max = l_desync_0:slider("Max .", -180, 180, 0, nil, "\194\176");
    l_macros_0.defensive_yaw_min_2 = l_desync_0:slider("Min 2.", -180, 180, 0, nil, "\194\176");
    l_macros_0.defensive_yaw_max_2 = l_desync_0:slider("Max 2.", -180, 180, 0, nil, "\194\176");
    l_macros_0.defensive_yaw_adaptive = l_desync_0:slider("Value", 0, 180, 0, nil, "\194\176");
    l_macros_0.defensive_yaw_switch = l_desync_0:slider("Switch", 1, 14, 1, nil, " t.");
    l_macros_0.defensive_yaw_full = l_desync_0:slider("Full", 0, 360, 0, nil, "\194\176");
    l_macros_0.defensive_yaw_cycle_invert = l_macros_0.defensive_yaw_gear:switch("Cycle Invert");
    l_macros_0.defensive_yaw_speed = l_desync_0:slider("Speed", 1, 45, 0, nil, " t.");
    l_macros_0.defensive_yaw_jitter_speed = l_desync_0:slider("Delay", 1, 50, 0, nil, " t.");
    l_macros_0.defensive_yaw_clock_step_size = l_desync_0:slider("Step Size", 1, 90, 30);
    l_macros_0.defensive_yaw_clock_jitter = l_desync_0:slider("Jitter Amplitude", 0, 90, 30);
    l_macros_0.defensive_yaw_clock_base = l_desync_0:slider("Baseline Yaw", -180, 180, 0, nil, "\194\176");
    l_macros_0.defensive_yaw_clock_dir = l_desync_0:combo("Direction", {
        [1] = "Clockwise", 
        [2] = "Counter-Clockwise"
    });
    l_macros_0.defensive_manual_flick_pitch = l_desync_0:combo("Pitch", {
        [1] = "Disabled", 
        [2] = "Fake Down", 
        [3] = "Fake Up"
    });
    l_macros_0.defensive_manual_flick_speed = l_desync_0:slider("Speed", 2, 10, 4);
    l_macros_0.defensive_manual_flick_mode = l_desync_0:combo("Mode", {
        [1] = "Static", 
        [2] = "Jitter", 
        [3] = "Sway", 
        [4] = "Spin"
    });
    l_macros_0.defensive_manual_flick_offset_1 = l_desync_0:slider("Yaw#1", -180, 180, 0);
    l_macros_0.defensive_manual_flick_offset_2 = l_desync_0:slider("Yaw#2", -180, 180, 0);
    l_macros_0.defensive_manual_flick_spin_speed = l_desync_0:slider("Speed", 1, 5, 1);
    if v344 == "fake lag" or v344 == "fake duck" or v344 == "revolver" then
        l_macros_0.defensive:disabled(true);
    end;
    l_macros_0.defensive_manual_flick_pitch:depend({
        [1] = nil, 
        [2] = true, 
        [1] = l_macros_0.defensive
    }, {
        [1] = nil, 
        [2] = "Ambani Flick", 
        [1] = l_macros_0.defensive_use_mode
    });
    l_macros_0.defensive_manual_flick_speed:depend({
        [1] = nil, 
        [2] = true, 
        [1] = l_macros_0.defensive
    }, {
        [1] = nil, 
        [2] = "Ambani Flick", 
        [1] = l_macros_0.defensive_use_mode
    });
    l_macros_0.defensive_manual_flick_mode:depend({
        [1] = nil, 
        [2] = true, 
        [1] = l_macros_0.defensive
    }, {
        [1] = nil, 
        [2] = "Ambani Flick", 
        [1] = l_macros_0.defensive_use_mode
    });
    l_macros_0.defensive_manual_flick_offset_1:depend({
        [1] = nil, 
        [2] = true, 
        [1] = l_macros_0.defensive
    }, {
        [1] = nil, 
        [2] = "Ambani Flick", 
        [1] = l_macros_0.defensive_use_mode
    });
    l_macros_0.defensive_manual_flick_offset_2:depend({
        [1] = nil, 
        [2] = true, 
        [1] = l_macros_0.defensive
    }, {
        [1] = nil, 
        [2] = "Ambani Flick", 
        [1] = l_macros_0.defensive_use_mode
    }, {
        [1] = nil, 
        [2] = "Jitter", 
        [1] = l_macros_0.defensive_manual_flick_mode
    });
    l_macros_0.defensive_manual_flick_spin_speed:depend({
        [1] = nil, 
        [2] = true, 
        [1] = l_macros_0.defensive
    }, {
        [1] = nil, 
        [2] = "Ambani Flick", 
        [1] = l_macros_0.defensive_use_mode
    }, {
        [1] = nil, 
        [2] = "Spin", 
        [1] = l_macros_0.defensive_manual_flick_mode
    });
    l_macros_0.defensive_use_mode:depend({
        [1] = nil, 
        [2] = true, 
        [1] = l_macros_0.defensive
    });
    l_macros_0.defensive_mode_gear:depend({
        [1] = nil, 
        [2] = "Neverlose", 
        [3] = true, 
        [1] = l_macros_0.defensive_mode
    }, {
        [1] = nil, 
        [2] = "Normal", 
        [1] = l_macros_0.defensive_use_mode
    });
    l_macros_0.defensive_mode_check:depend({
        [1] = nil, 
        [2] = "Custom", 
        [3] = "Limit", 
        [1] = l_macros_0.defensive_mode
    }, {
        [1] = nil, 
        [2] = "Normal", 
        [1] = l_macros_0.defensive_use_mode
    });
    l_macros_0.defensive_mode_min:depend({
        [1] = nil, 
        [2] = "Custom", 
        [3] = "Limit", 
        [1] = l_macros_0.defensive_mode
    }, {
        [1] = nil, 
        [2] = "Normal", 
        [1] = l_macros_0.defensive_use_mode
    });
    l_macros_0.defensive_mode_max:depend({
        [1] = nil, 
        [2] = "Custom", 
        [3] = "Limit", 
        [1] = l_macros_0.defensive_mode
    }, {
        [1] = nil, 
        [2] = "Normal", 
        [1] = l_macros_0.defensive_use_mode
    });
    l_macros_0.defensive_mode_tick:depend({
        [1] = nil, 
        [2] = "Flick", 
        [1] = l_macros_0.defensive_mode
    }, {
        [1] = nil, 
        [2] = "Static", 
        [3] = false, 
        [1] = l_macros_0.defensive_flick_tick_mode
    }, {
        [1] = nil, 
        [2] = "Normal", 
        [1] = l_macros_0.defensive_use_mode
    });
    l_macros_0.defensive_flick_trigger:depend({
        [1] = nil, 
        [2] = "Flick", 
        [1] = l_macros_0.defensive_mode
    }, {
        [1] = nil, 
        [2] = "Normal", 
        [1] = l_macros_0.defensive_use_mode
    });
    l_macros_0.defensive_flick_cycle_speed:depend({
        [1] = nil, 
        [2] = "Flick", 
        [1] = l_macros_0.defensive_mode
    }, {
        [1] = nil, 
        [2] = "Cycle", 
        [1] = l_macros_0.defensive_flick_tick_mode
    }, {
        [1] = nil, 
        [2] = "Normal", 
        [1] = l_macros_0.defensive_use_mode
    });
    l_macros_0.defensive_flick_jitter_repeat:depend({
        [1] = nil, 
        [2] = "Flick", 
        [1] = l_macros_0.defensive_mode
    }, {
        [1] = nil, 
        [2] = "Jitter", 
        [1] = l_macros_0.defensive_flick_tick_mode
    }, {
        [1] = nil, 
        [2] = "Normal", 
        [1] = l_macros_0.defensive_use_mode
    });
    l_macros_0.defensive_flick_hidden:depend({
        [1] = nil, 
        [2] = "Flick", 
        [3] = "Custom", 
        [4] = "Limit", 
        [1] = l_macros_0.defensive_mode
    }, {
        [1] = nil, 
        [2] = "Normal", 
        [1] = l_macros_0.defensive_use_mode
    });
    l_macros_0.defensive_flick_limit:depend({
        [1] = nil, 
        [2] = "Flick", 
        [3] = "Custom", 
        [1] = l_macros_0.defensive_mode
    }, {
        [1] = nil, 
        [2] = "Normal", 
        [1] = l_macros_0.defensive_use_mode
    });
    l_macros_0.defensive_flick_tick_mode:depend({
        [1] = nil, 
        [2] = "Flick", 
        [1] = l_macros_0.defensive_mode
    }, {
        [1] = nil, 
        [2] = "Normal", 
        [1] = l_macros_0.defensive_use_mode
    });
    l_macros_0.defensive_flick_tick_min:depend({
        [1] = nil, 
        [2] = "Flick", 
        [1] = l_macros_0.defensive_mode
    }, {
        [1] = nil, 
        [2] = "Random Jitter", 
        [3] = "Random", 
        [4] = "Random Static", 
        [5] = "Random Trigger", 
        [6] = "Jitter", 
        [7] = "Cycle", 
        [1] = l_macros_0.defensive_flick_tick_mode
    }, {
        [1] = nil, 
        [2] = "Normal", 
        [1] = l_macros_0.defensive_use_mode
    });
    l_macros_0.defensive_flick_tick_max:depend({
        [1] = nil, 
        [2] = "Flick", 
        [1] = l_macros_0.defensive_mode
    }, {
        [1] = nil, 
        [2] = "Random Jitter", 
        [3] = "Random", 
        [4] = "Random Static", 
        [5] = "Random Trigger", 
        [6] = "Jitter", 
        [7] = "Cycle", 
        [1] = l_macros_0.defensive_flick_tick_mode
    }, {
        [1] = nil, 
        [2] = "Normal", 
        [1] = l_macros_0.defensive_use_mode
    });
    l_macros_0.defensive_onpeek:depend({
        [1] = nil, 
        [2] = true, 
        [1] = l_macros_0.defensive
    }, {
        [1] = nil, 
        [2] = "Normal", 
        [1] = l_macros_0.defensive_use_mode
    });
    l_macros_0.defensive_mode:depend({
        [1] = nil, 
        [2] = true, 
        [1] = l_macros_0.defensive
    }, {
        [1] = nil, 
        [2] = "Normal", 
        [1] = l_macros_0.defensive_use_mode
    });
    l_macros_0.defensive_pitch:depend({
        [1] = nil, 
        [2] = true, 
        [1] = l_macros_0.defensive
    }, {
        [1] = nil, 
        [2] = "Normal", 
        [1] = l_macros_0.defensive_use_mode
    });
    l_macros_0.defensive_pitch_static:depend({
        [1] = nil, 
        [2] = true, 
        [1] = l_macros_0.defensive
    }, {
        [1] = nil, 
        [2] = "Static", 
        [3] = false, 
        [1] = l_macros_0.defensive_pitch
    }, {
        [1] = nil, 
        [2] = "Normal", 
        [1] = l_macros_0.defensive_use_mode
    });
    l_macros_0.defensive_pitch_min:depend({
        [1] = nil, 
        [2] = true, 
        [1] = l_macros_0.defensive
    }, {
        [1] = nil, 
        [2] = "Jitter", 
        [3] = "Random", 
        [4] = "Random Jitter", 
        [5] = "Spin", 
        [6] = "Wraith", 
        [7] = "Cycle Spin", 
        [8] = "Switch Random", 
        [9] = "Switch Jitter", 
        [10] = "Random Static", 
        [11] = "LC End", 
        [12] = "Wave", 
        [1] = l_macros_0.defensive_pitch
    }, {
        [1] = nil, 
        [2] = "Normal", 
        [1] = l_macros_0.defensive_use_mode
    });
    l_macros_0.defensive_pitch_max:depend({
        [1] = nil, 
        [2] = true, 
        [1] = l_macros_0.defensive
    }, {
        [1] = nil, 
        [2] = "Jitter", 
        [3] = "Random", 
        [4] = "Random Jitter", 
        [5] = "Spin", 
        [6] = "Wraith", 
        [7] = "Cycle Spin", 
        [8] = "Switch Random", 
        [9] = "Switch Jitter", 
        [10] = "Random Static", 
        [11] = "LC End", 
        [12] = "Wave", 
        [1] = l_macros_0.defensive_pitch
    }, {
        [1] = nil, 
        [2] = "Normal", 
        [1] = l_macros_0.defensive_use_mode
    });
    l_macros_0.defensive_pitch_min_2:depend({
        [1] = nil, 
        [2] = true, 
        [1] = l_macros_0.defensive
    }, {
        [1] = nil, 
        [2] = "Switch Random", 
        [3] = "Switch Jitter", 
        [1] = l_macros_0.defensive_pitch
    }, {
        [1] = nil, 
        [2] = "Normal", 
        [1] = l_macros_0.defensive_use_mode
    });
    l_macros_0.defensive_pitch_max_2:depend({
        [1] = nil, 
        [2] = true, 
        [1] = l_macros_0.defensive
    }, {
        [1] = nil, 
        [2] = "Switch Random", 
        [3] = "Switch Jitter", 
        [1] = l_macros_0.defensive_pitch
    }, {
        [1] = nil, 
        [2] = "Normal", 
        [1] = l_macros_0.defensive_use_mode
    });
    l_macros_0.defensive_pitch_switch:depend({
        [1] = nil, 
        [2] = true, 
        [1] = l_macros_0.defensive
    }, {
        [1] = nil, 
        [2] = "Switch Random", 
        [3] = "Switch Jitter", 
        [1] = l_macros_0.defensive_pitch
    }, {
        [1] = nil, 
        [2] = "Normal", 
        [1] = l_macros_0.defensive_use_mode
    });
    l_macros_0.defensive_pitch_speed:depend({
        [1] = nil, 
        [2] = true, 
        [1] = l_macros_0.defensive
    }, {
        [1] = nil, 
        [2] = "Spin", 
        [3] = "Wraith", 
        [1] = l_macros_0.defensive_pitch
    }, {
        [1] = nil, 
        [2] = "Normal", 
        [1] = l_macros_0.defensive_use_mode
    });
    l_macros_0.defensive_pitch_jitter_speed:depend({
        [1] = nil, 
        [2] = true, 
        [1] = l_macros_0.defensive
    }, {
        [1] = nil, 
        [2] = "Jitter", 
        [3] = "Cycle Spin", 
        [1] = l_macros_0.defensive_pitch
    }, {
        [1] = nil, 
        [2] = "Normal", 
        [1] = l_macros_0.defensive_use_mode
    });
    l_macros_0.defensive_pitch_wave_period:depend({
        [1] = nil, 
        [2] = true, 
        [1] = l_macros_0.defensive
    }, {
        [1] = nil, 
        [2] = "Wave", 
        [1] = l_macros_0.defensive_pitch
    }, {
        [1] = nil, 
        [2] = "Normal", 
        [1] = l_macros_0.defensive_use_mode
    });
    l_macros_0.defensive_pitch_wave_type:depend({
        [1] = nil, 
        [2] = true, 
        [1] = l_macros_0.defensive
    }, {
        [1] = nil, 
        [2] = "Wave", 
        [1] = l_macros_0.defensive_pitch
    }, {
        [1] = nil, 
        [2] = "Normal", 
        [1] = l_macros_0.defensive_use_mode
    });
    l_macros_0.defensive_pitch_wave_invert:depend({
        [1] = nil, 
        [2] = true, 
        [1] = l_macros_0.defensive
    }, {
        [1] = nil, 
        [2] = "Wave", 
        [1] = l_macros_0.defensive_pitch
    }, {
        [1] = nil, 
        [2] = "Normal", 
        [1] = l_macros_0.defensive_use_mode
    });
    l_macros_0.defensive_yaw:depend({
        [1] = nil, 
        [2] = true, 
        [1] = l_macros_0.defensive
    }, {
        [1] = nil, 
        [2] = "Normal", 
        [1] = l_macros_0.defensive_use_mode
    });
    l_macros_0.defensive_yaw_flick:depend({
        [1] = nil, 
        [2] = "Switch Jitter", 
        [3] = "Adaptive", 
        [1] = l_macros_0.defensive_yaw
    }, {
        [1] = nil, 
        [2] = "Normal", 
        [1] = l_macros_0.defensive_use_mode
    });
    l_macros_0.defensive_yaw_static:depend({
        [1] = nil, 
        [2] = true, 
        [1] = l_macros_0.defensive
    }, {
        [1] = nil, 
        [2] = "Static", 
        [1] = l_macros_0.defensive_yaw
    }, {
        [1] = nil, 
        [2] = "Normal", 
        [1] = l_macros_0.defensive_use_mode
    });
    l_macros_0.defensive_yaw_min:depend({
        [1] = nil, 
        [2] = true, 
        [1] = l_macros_0.defensive
    }, {
        [1] = nil, 
        [2] = "Jitter", 
        [3] = "Random", 
        [4] = "Spin", 
        [5] = "Wraith", 
        [6] = "Switch Random", 
        [7] = "Flick", 
        [8] = "Switch Jitter", 
        [9] = "Random Static", 
        [10] = "LC End", 
        [1] = l_macros_0.defensive_yaw
    }, {
        [1] = nil, 
        [2] = "Normal", 
        [1] = l_macros_0.defensive_use_mode
    });
    l_macros_0.defensive_yaw_max:depend({
        [1] = nil, 
        [2] = true, 
        [1] = l_macros_0.defensive
    }, {
        [1] = nil, 
        [2] = "Jitter", 
        [3] = "Random", 
        [4] = "Spin", 
        [5] = "Wraith", 
        [6] = "Switch Random", 
        [7] = "Flick", 
        [8] = "Switch Jitter", 
        [9] = "Random Static", 
        [10] = "LC End", 
        [1] = l_macros_0.defensive_yaw
    }, {
        [1] = nil, 
        [2] = "Normal", 
        [1] = l_macros_0.defensive_use_mode
    });
    l_macros_0.defensive_yaw_min_2:depend({
        [1] = nil, 
        [2] = true, 
        [1] = l_macros_0.defensive
    }, {
        [1] = nil, 
        [2] = "Switch Random", 
        [3] = "Switch Jitter", 
        [1] = l_macros_0.defensive_yaw
    }, {
        [1] = nil, 
        [2] = "Normal", 
        [1] = l_macros_0.defensive_use_mode
    });
    l_macros_0.defensive_yaw_max_2:depend({
        [1] = nil, 
        [2] = true, 
        [1] = l_macros_0.defensive
    }, {
        [1] = nil, 
        [2] = "Switch Random", 
        [3] = "Switch Jitter", 
        [1] = l_macros_0.defensive_yaw
    }, {
        [1] = nil, 
        [2] = "Normal", 
        [1] = l_macros_0.defensive_use_mode
    });
    l_macros_0.defensive_yaw_switch:depend({
        [1] = nil, 
        [2] = true, 
        [1] = l_macros_0.defensive
    }, {
        [1] = nil, 
        [2] = "Switch Random", 
        [3] = "Switch Jitter", 
        [1] = l_macros_0.defensive_yaw
    }, {
        [1] = nil, 
        [2] = false, 
        [1] = l_macros_0.defensive_yaw_flick
    }, {
        [1] = nil, 
        [2] = "Normal", 
        [1] = l_macros_0.defensive_use_mode
    });
    l_macros_0.defensive_yaw_full:depend({
        [1] = nil, 
        [2] = true, 
        [1] = l_macros_0.defensive
    }, {
        [1] = nil, 
        [2] = "Random Jitter", 
        [3] = "Spin Jitter", 
        [4] = "Cycle Spin", 
        [5] = "90 Random", 
        [6] = "Random Offset", 
        [1] = l_macros_0.defensive_yaw
    }, {
        [1] = nil, 
        [2] = "Normal", 
        [1] = l_macros_0.defensive_use_mode
    });
    l_macros_0.defensive_yaw_cycle_invert:depend({
        [1] = nil, 
        [2] = "Cycle Spin", 
        [1] = l_macros_0.defensive_yaw
    }, {
        [1] = nil, 
        [2] = "Normal", 
        [1] = l_macros_0.defensive_use_mode
    });
    l_macros_0.defensive_yaw_speed:depend({
        [1] = nil, 
        [2] = true, 
        [1] = l_macros_0.defensive
    }, {
        [1] = nil, 
        [2] = "Spin", 
        [3] = "Wraith", 
        [4] = "Spin Jitter", 
        [5] = "90 Random", 
        [6] = "Random Offset", 
        [7] = "Clock", 
        [1] = l_macros_0.defensive_yaw
    }, {
        [1] = nil, 
        [2] = "Normal", 
        [1] = l_macros_0.defensive_use_mode
    });
    l_macros_0.defensive_yaw_adaptive:depend({
        [1] = nil, 
        [2] = true, 
        [1] = l_macros_0.defensive
    }, {
        [1] = nil, 
        [2] = "Adaptive", 
        [1] = l_macros_0.defensive_yaw
    }, {
        [1] = nil, 
        [2] = "Normal", 
        [1] = l_macros_0.defensive_use_mode
    });
    l_macros_0.defensive_yaw_jitter_speed:depend({
        [1] = nil, 
        [2] = true, 
        [1] = l_macros_0.defensive
    }, {
        [1] = nil, 
        [2] = "Jitter", 
        [3] = "Cycle Spin", 
        [1] = l_macros_0.defensive_yaw
    }, {
        [1] = nil, 
        [2] = "Normal", 
        [1] = l_macros_0.defensive_use_mode
    });
    l_macros_0.defensive_yaw_clock_step_size:depend({
        [1] = nil, 
        [2] = true, 
        [1] = l_macros_0.defensive
    }, {
        [1] = nil, 
        [2] = "Clock", 
        [1] = l_macros_0.defensive_yaw
    }, {
        [1] = nil, 
        [2] = "Normal", 
        [1] = l_macros_0.defensive_use_mode
    });
    l_macros_0.defensive_yaw_clock_jitter:depend({
        [1] = nil, 
        [2] = true, 
        [1] = l_macros_0.defensive
    }, {
        [1] = nil, 
        [2] = "Clock", 
        [1] = l_macros_0.defensive_yaw
    }, {
        [1] = nil, 
        [2] = "Normal", 
        [1] = l_macros_0.defensive_use_mode
    });
    l_macros_0.defensive_yaw_clock_base:depend({
        [1] = nil, 
        [2] = true, 
        [1] = l_macros_0.defensive
    }, {
        [1] = nil, 
        [2] = "Clock", 
        [1] = l_macros_0.defensive_yaw
    }, {
        [1] = nil, 
        [2] = "Normal", 
        [1] = l_macros_0.defensive_use_mode
    });
    l_macros_0.defensive_yaw_clock_dir:depend({
        [1] = nil, 
        [2] = true, 
        [1] = l_macros_0.defensive
    }, {
        [1] = nil, 
        [2] = "Clock", 
        [1] = l_macros_0.defensive_yaw
    }, {
        [1] = nil, 
        [2] = "Normal", 
        [1] = l_macros_0.defensive_use_mode
    });
    l_macros_0.yaw_offset:depend({
        [1] = nil, 
        [2] = "Offset", 
        [1] = l_macros_0.yaw_mode
    });
    l_macros_0.yaw_fluctate_enable:depend({
        [1] = nil, 
        [2] = "Jitter", 
        [1] = l_macros_0.yaw_mode
    });
    l_macros_0.yaw_fluctate:depend({
        [1] = nil, 
        [2] = "Jitter", 
        [1] = l_macros_0.yaw_mode
    }, {
        [1] = nil, 
        [2] = true, 
        [1] = l_macros_0.yaw_fluctate_enable
    });
    l_macros_0.yaw_left:depend({
        [1] = nil, 
        [2] = "Offset", 
        [3] = true, 
        [1] = l_macros_0.yaw_mode
    });
    l_macros_0.yaw_right:depend({
        [1] = nil, 
        [2] = "Offset", 
        [3] = true, 
        [1] = l_macros_0.yaw_mode
    });
    l_macros_0.modifier_mode_offset:depend({
        [1] = nil, 
        [2] = "Sanya", 
        [3] = "Sway Jitter", 
        [4] = "Jitter", 
        [1] = l_macros_0.modifier_mode
    });
    l_macros_0.modifier_mode_gear:depend({
        [1] = nil, 
        [2] = "Disabled", 
        [3] = true, 
        [1] = l_macros_0.modifier_mode
    });
    l_macros_0.modifier_sway_speed:depend({
        [1] = nil, 
        [2] = "Sway Jitter", 
        [3] = false, 
        [1] = l_macros_0.modifier_mode
    });
    l_macros_0.modifier_random:depend({
        [1] = nil, 
        [2] = "Jitter", 
        [3] = "Sanya", 
        [1] = l_macros_0.modifier_mode
    });
    l_macros_0.modifier_random_mode:depend({
        [1] = nil, 
        [2] = true, 
        [1] = l_macros_0.modifier_random
    }, {
        [1] = nil, 
        [2] = "Jitter", 
        [3] = "Sanya", 
        [1] = l_macros_0.modifier_mode
    });
    l_macros_0.modifier_random_default:depend({
        [1] = nil, 
        [2] = "Jitter", 
        [3] = "Sanya", 
        [1] = l_macros_0.modifier_mode
    }, {
        [1] = nil, 
        [2] = true, 
        [1] = l_macros_0.modifier_random
    }, {
        [1] = nil, 
        [2] = "Default", 
        [1] = l_macros_0.modifier_random_mode
    });
    l_macros_0.modifier_random_min:depend({
        [1] = nil, 
        [2] = "Jitter", 
        [3] = "Sanya", 
        [1] = l_macros_0.modifier_mode
    }, {
        [1] = nil, 
        [2] = true, 
        [1] = l_macros_0.modifier_random
    }, {
        [1] = nil, 
        [2] = "Min-Max", 
        [1] = l_macros_0.modifier_random_mode
    });
    l_macros_0.modifier_random_max:depend({
        [1] = nil, 
        [2] = "Jitter", 
        [3] = "Sanya", 
        [1] = l_macros_0.modifier_mode
    }, {
        [1] = nil, 
        [2] = true, 
        [1] = l_macros_0.modifier_random
    }, {
        [1] = nil, 
        [2] = "Min-Max", 
        [1] = l_macros_0.modifier_random_mode
    });
    l_macros_0.modifier_sanya_switcher:depend({
        [1] = nil, 
        [2] = "Sanya", 
        [1] = l_macros_0.modifier_mode
    });
    l_macros_0.modifier_sanya_speed:depend({
        [1] = nil, 
        [2] = "Sanya", 
        [1] = l_macros_0.modifier_mode
    });
    l_macros_0.modifier_torpedo_random:depend({
        [1] = nil, 
        [2] = "Torpedo", 
        [1] = l_macros_0.modifier_mode
    });
    l_macros_0.modifier_torpedo_speed_1:depend({
        [1] = nil, 
        [2] = "Torpedo", 
        [1] = l_macros_0.modifier_mode
    });
    l_macros_0.modifier_torpedo_speed_2:depend({
        [1] = nil, 
        [2] = "Torpedo", 
        [1] = l_macros_0.modifier_mode
    }, {
        [1] = nil, 
        [2] = true, 
        [1] = l_macros_0.modifier_torpedo_random
    });
    l_macros_0.modifier_torpedo_lagcomp:depend({
        [1] = nil, 
        [2] = "Torpedo", 
        [1] = l_macros_0.modifier_mode
    });
    l_macros_0.desync_gear:depend({
        [1] = nil, 
        [2] = "Disabled", 
        [3] = true, 
        [1] = l_macros_0.desync
    });
    l_macros_0.desync_left:depend({
        [1] = nil, 
        [2] = "Disabled", 
        [3] = true, 
        [1] = l_macros_0.desync
    }, {
        [1] = nil, 
        [2] = "Disabled", 
        [3] = "Random", 
        [1] = l_macros_0.desync_anglemode
    });
    l_macros_0.desync_right:depend({
        [1] = nil, 
        [2] = "Disabled", 
        [3] = true, 
        [1] = l_macros_0.desync
    }, {
        [1] = nil, 
        [2] = "Disabled", 
        [3] = "Random", 
        [1] = l_macros_0.desync_anglemode
    });
    l_macros_0.desync_switch_logic:depend({
        [1] = nil, 
        [2] = "Disabled", 
        [3] = true, 
        [1] = l_macros_0.desync
    }, {
        [1] = nil, 
        [2] = "Switch", 
        [1] = l_macros_0.desync_anglemode
    });
    l_macros_0.desync_invert:depend({
        [1] = nil, 
        [2] = "Static", 
        [1] = l_macros_0.desync
    });
    l_macros_0.desync_period:depend({
        [1] = nil, 
        [2] = "Jitter", 
        [1] = l_macros_0.desync
    });
    l_macros_0.modifier_mode_gear:depend({
        [1] = nil, 
        [2] = "Disabled", 
        [3] = true, 
        [1] = l_macros_0.modifier_mode
    });
    l_macros_0.delay_base:depend({
        [1] = nil, 
        [2] = "Sanya", 
        [3] = "Jitter", 
        [1] = l_macros_0.modifier_mode
    });
    l_macros_0.delay_mode:depend({
        [1] = nil, 
        [2] = "Sanya", 
        [3] = "Jitter", 
        [1] = l_macros_0.modifier_mode
    });
    l_macros_0.delay_static_tick:depend({
        [1] = nil, 
        [2] = "Sanya", 
        [3] = "Jitter", 
        [1] = l_macros_0.modifier_mode
    }, {
        [1] = nil, 
        [2] = "Static", 
        [3] = false, 
        [1] = l_macros_0.delay_mode
    });
    l_macros_0.delay_min_tick:depend({
        [1] = nil, 
        [2] = "Sanya", 
        [3] = "Jitter", 
        [1] = l_macros_0.modifier_mode
    }, {
        [1] = nil, 
        [2] = "Jitter", 
        [3] = "Random", 
        [4] = "Random Jitter", 
        [5] = "Fluctuate", 
        [6] = "Cycle", 
        [7] = "Random Trigger", 
        [1] = l_macros_0.delay_mode
    });
    l_macros_0.delay_max_tick:depend({
        [1] = nil, 
        [2] = "Sanya", 
        [3] = "Jitter", 
        [1] = l_macros_0.modifier_mode
    }, {
        [1] = nil, 
        [2] = "Jitter", 
        [3] = "Random", 
        [4] = "Random Jitter", 
        [5] = "Fluctuate", 
        [6] = "Cycle", 
        [7] = "Random Trigger", 
        [1] = l_macros_0.delay_mode
    });
    l_macros_0.delay_jittertick_repeat:depend({
        [1] = nil, 
        [2] = "Sanya", 
        [3] = "Jitter", 
        [1] = l_macros_0.modifier_mode
    }, {
        [1] = nil, 
        [2] = "Jitter", 
        [3] = false, 
        [1] = l_macros_0.delay_mode
    });
    l_macros_0.delay_cycle_speed:depend({
        [1] = nil, 
        [2] = "Sanya", 
        [3] = "Jitter", 
        [1] = l_macros_0.modifier_mode
    }, {
        [1] = nil, 
        [2] = "Cycle", 
        [3] = false, 
        [1] = l_macros_0.delay_mode
    });
    l_macros_0.delay_sections:depend({
        [1] = nil, 
        [2] = "Custom", 
        [1] = l_macros_0.delay_mode
    });
    for v354 = 1, 8 do
        l_macros_0.delay_custom_tbl[v354]:depend({
            [1] = nil, 
            [2] = "Custom", 
            [1] = l_macros_0.delay_mode
        });
    end;
    l_macros_0.delay_custom_tick:depend({
        [1] = nil, 
        [2] = "Custom", 
        [1] = l_macros_0.delay_mode
    });
    l_macros_0.delay_custom_random:depend({
        [1] = nil, 
        [2] = "Custom", 
        [1] = l_macros_0.delay_mode
    });
    l_macros_0.defensive_mode:tooltip("Defensive Mode: \n\n'\vNeverlose\r' - Is Neverlose Original LC Mode. \n\n'\vFlick\r' - Traditional Defensive Fake Flick LC Mode, Tick value 7 is the most common. \n\n'\vCustom\r' - This LC Mode will allow you to decide how long the defensive tick should be when enabled. It is recommended that the second value is always 15. \n\n'\vLimit\r' - This LC Mode will limit the length of your Defensive. The lower the Tick, the shorter the time you can perform Defensive AA.");
    l_macros_0.defensive_flick_desync_release:tooltip("\aFF0000FFUnsafe! \rPlease use with discretion!");
    do
        local l_v345_0, l_l_macros_0_0 = v345, l_macros_0;
        l_pui_0.traverse(l_l_macros_0_0, function(v357, v358)
            -- upvalues: l_link_0 (ref), l_v345_0 (ref), l_l_macros_0_0 (ref)
            v357:depend({
                [1] = nil, 
                [2] = true, 
                [1] = l_link_0.general.master
            }, {
                [1] = nil, 
                [2] = 2, 
                [1] = l_link_0.general.page
            }, {
                [1] = l_link_0.condition.cnd_list, 
                [2] = l_v345_0
            }, v358[#v358] ~= "enable" and l_l_macros_0_0.enable or nil);
        end);
        l_pui_0.macros._p = nil;
    end;
end;
l_link_0.safe_head.above:depend({
    [1] = nil, 
    [2] = true, 
    [1] = l_link_0.set.safehead
});
l_link_0.general.page:depend({
    [1] = nil, 
    [2] = true, 
    [1] = l_link_0.general.master
});
l_link_0.condition.cnd_list:depend({
    [1] = nil, 
    [2] = true, 
    [1] = l_link_0.general.master
}, {
    [1] = nil, 
    [2] = 2, 
    [1] = l_link_0.general.page
});
l_link_0.fakelag_enable.onshot:depend({
    [1] = nil, 
    [2] = true, 
    [1] = l_link_0.general.master
}, {
    [1] = nil, 
    [2] = 3, 
    [1] = l_link_0.general.page
}, {
    [1] = nil, 
    [2] = true, 
    [1] = l_link_0.fakelag_enable.enable
});
l_link_0.fakelag_shot.shot_peek:depend({
    [1] = nil, 
    [2] = true, 
    [1] = l_link_0.general.master
}, {
    [1] = nil, 
    [2] = 3, 
    [1] = l_link_0.general.page
}, {
    [1] = nil, 
    [2] = true, 
    [1] = l_link_0.fakelag_enable.enable
}, {
    [1] = nil, 
    [2] = true, 
    [1] = l_link_0.fakelag_enable.onshot
}, {
    [1] = nil, 
    [2] = "Reset Desync", 
    [1] = l_link_0.fakelag_shot.shot_optimzed
});
l_link_0.fakelag_shot.shot_peek_choke:depend({
    [1] = nil, 
    [2] = true, 
    [1] = l_link_0.general.master
}, {
    [1] = nil, 
    [2] = 3, 
    [1] = l_link_0.general.page
}, {
    [1] = nil, 
    [2] = true, 
    [1] = l_link_0.fakelag_enable.enable
}, {
    [1] = nil, 
    [2] = true, 
    [1] = l_link_0.fakelag_enable.onshot
}, {
    [1] = nil, 
    [2] = "Choke", 
    [1] = l_link_0.fakelag_shot.shot_optimzed
});
l_link_0.fakelag.limit:depend({
    [1] = nil, 
    [2] = true, 
    [1] = l_link_0.general.master
}, {
    [1] = nil, 
    [2] = 3, 
    [1] = l_link_0.general.page
}, {
    [1] = nil, 
    [2] = true, 
    [1] = l_link_0.fakelag_enable.enable
}, {
    [1] = nil, 
    [2] = "Neverlose", 
    [3] = "Fluctuate", 
    [1] = l_link_0.fakelag.mode
});
l_link_0.fakelag.min:depend({
    [1] = nil, 
    [2] = true, 
    [1] = l_link_0.general.master
}, {
    [1] = nil, 
    [2] = 3, 
    [1] = l_link_0.general.page
}, {
    [1] = nil, 
    [2] = true, 
    [1] = l_link_0.fakelag_enable.enable
}, {
    [1] = nil, 
    [2] = "Random", 
    [3] = "Cycle", 
    [1] = l_link_0.fakelag.mode
});
l_link_0.fakelag.max:depend({
    [1] = nil, 
    [2] = true, 
    [1] = l_link_0.general.master
}, {
    [1] = nil, 
    [2] = 3, 
    [1] = l_link_0.general.page
}, {
    [1] = nil, 
    [2] = true, 
    [1] = l_link_0.fakelag_enable.enable
}, {
    [1] = nil, 
    [2] = "Random", 
    [3] = "Cycle", 
    [1] = l_link_0.fakelag.mode
});
l_link_0.fakelag.step:depend({
    [1] = nil, 
    [2] = true, 
    [1] = l_link_0.general.master
}, {
    [1] = nil, 
    [2] = 3, 
    [1] = l_link_0.general.page
}, {
    [1] = nil, 
    [2] = true, 
    [1] = l_link_0.fakelag_enable.enable
}, {
    [1] = nil, 
    [2] = "Cycle", 
    [1] = l_link_0.fakelag.mode
});
l_pui_0.traverse(l_link_0.set, function(v359, _)
    -- upvalues: l_link_0 (ref)
    v359:depend({
        [1] = nil, 
        [2] = true, 
        [1] = l_link_0.general.master
    }, {
        [1] = nil, 
        [2] = 1, 
        [1] = l_link_0.general.page
    });
end);
l_pui_0.traverse(l_link_0.all_set, function(v361, _)
    -- upvalues: l_link_0 (ref)
    v361:depend({
        [1] = nil, 
        [2] = true, 
        [1] = l_link_0.general.master
    }, {
        [1] = nil, 
        [2] = 1, 
        [1] = l_link_0.general.page
    });
end);
l_pui_0.traverse(l_link_0.fakelag_enable, function(v363, _)
    -- upvalues: l_link_0 (ref)
    v363:depend({
        [1] = nil, 
        [2] = true, 
        [1] = l_link_0.general.master
    }, {
        [1] = nil, 
        [2] = 3, 
        [1] = l_link_0.general.page
    });
end);
l_pui_0.traverse(l_link_0.fakelag, function(v365, _)
    -- upvalues: l_link_0 (ref)
    v365:depend({
        [1] = nil, 
        [2] = true, 
        [1] = l_link_0.general.master
    }, {
        [1] = nil, 
        [2] = 3, 
        [1] = l_link_0.general.page
    }, {
        [1] = nil, 
        [2] = true, 
        [1] = l_link_0.fakelag_enable.enable
    });
end);
l_pui_0.traverse(l_link_0.fakelag_shot, function(v367, _)
    -- upvalues: l_link_0 (ref)
    v367:depend({
        [1] = nil, 
        [2] = true, 
        [1] = l_link_0.general.master
    }, {
        [1] = nil, 
        [2] = 3, 
        [1] = l_link_0.general.page
    }, {
        [1] = nil, 
        [2] = true, 
        [1] = l_link_0.fakelag_enable.enable
    }, {
        [1] = nil, 
        [2] = true, 
        [1] = l_link_0.fakelag_enable.onshot
    });
end);
l_config_sub_0 = nil;
l_selectab_0 = v323.get("layer-group");
l_config_sub_0 = {
    tab = {
        option = {
            [1] = "\f<list-ul>  \240\157\151\160\240\157\151\182\240\157\152\128\240\157\151\176", 
            [2] = "\f<mountain-sun>  \240\157\151\169\240\157\151\182\240\157\152\128\240\157\152\130\240\157\151\174\240\157\151\185"
        }, 
        main = l_pui_0.create(l_selectab_0, "\n\n", 1), 
        misc = l_pui_0.create(l_selectab_0, "\n\n\n\n\n", 2), 
        misc_sub = l_pui_0.create(l_selectab_0, "\n\n\n\n\n\n\n", 1), 
        visual = l_pui_0.create(l_selectab_0, "\n\n\n\n\n\n", 2), 
        visual_sub = l_pui_0.create(l_selectab_0, "\n\n\n\n\n\n\n\n", 1), 
        dormant = l_pui_0.create(l_selectab_0, "\n\n\n\n\n\n\n\n\n\n", 2)
    }
};
l_main_0 = l_config_sub_0.tab.misc;
l_sub_0 = l_config_sub_0.tab.visual;
l_cnd_list_0 = l_config_sub_0.tab.visual_sub;
l_fakelag_0 = l_config_sub_0.tab.misc_sub;
l_shot_0 = l_config_sub_0.tab.dormant;
l_config_sub_0.page = l_config_sub_0.tab.main:list("", l_config_sub_0.tab.option);
l_config_sub_0.misc = {
    dropnade = l_main_0:switch("Drop Nades"), 
    supertoss = l_main_0:switch("Supertoss"), 
    clantag = l_main_0:switch("Clan tag"), 
    autoweapon = l_main_0:switch("Auto Taser/Pistol"), 
    fakeping = l_main_0:switch("Unlock Fake Ping"), 
    animation = l_main_0:switch("Animation Breaker"), 
    chat = l_main_0:switch("Chat Hider"), 
    useless = l_main_0:switch("Optimized Cvars")
};
l_config_sub_0.visual = {
    aspect = l_sub_0:slider("Aspect Ratio", 0, 200, 0, nil, "%"), 
    viewmodel = l_sub_0:switch("Viewmodel Changer"), 
    world = l_sub_0:switch("World Hit Marker"), 
    damage = l_sub_0:switch("Damage Marker"), 
    logger = l_sub_0:switch("Logger"), 
    center = l_cnd_list_0:switch("Center Indicator"), 
    dmg_ind = l_cnd_list_0:switch("Damage Indicator"), 
    manual = l_cnd_list_0:switch("Manual Arrow"), 
    slowdown = l_cnd_list_0:switch("Slow Down Warning"), 
    scope = l_sub_0:switch("Scope Overlay"), 
    grenade = l_sub_0:switch("Grenade Radius"), 
    panel = l_sub_0:switch("Debug Panel")
};
l_config_sub_0.rage = {
    tips = l_fakelag_0:label("\aB6B665FF" .. v323.get("triangle-exclamation") .. "\r  Works only on Scout\239\188\129"), 
    lethal = l_fakelag_0:switch("Lethal Baim"), 
    predict = l_shot_0:switch("\aB6B665FFPredict"), 
    dynamic = l_fakelag_0:switch("Dynamic Head Scale"), 
    backtrack = l_fakelag_0:switch("Auto Disable Extend Backtrack")
};
l_config_sub_0.rage_gear = {
    lethal_gear = l_config_sub_0.rage.lethal:create(), 
    dynamic_gear = l_config_sub_0.rage.dynamic:create()
};
l_config_sub_0.rage_lethal = {
    mode = l_config_sub_0.rage_gear.lethal_gear:combo("Mode", {
        [1] = "Auto", 
        [2] = "Manual"
    })
};
l_config_sub_0.rage_lethal_sub_1 = {
    exclude = l_config_sub_0.rage_gear.lethal_gear:switch("Exclude Chest"), 
    enemyhp = l_config_sub_0.rage_gear.lethal_gear:slider("Enemy HP", 55, 92, 0, nil, "hp"), 
    accuracy = l_config_sub_0.rage_gear.lethal_gear:combo("Accuracy", {
        [1] = "Max", 
        [2] = "High", 
        [3] = "Medium", 
        [4] = "Low"
    })
};
l_config_sub_0.rage_lethal_sub = {
    hitbox = l_config_sub_0.rage_gear.lethal_gear:selectable("Hitbox", {
        [1] = "Chest", 
        [2] = "Stomach", 
        [3] = "Legs", 
        [4] = "Arms", 
        [5] = "Feet"
    }), 
    dmg = l_config_sub_0.rage_gear.lethal_gear:slider("Damage", 1, 130, 0), 
    hc = l_config_sub_0.rage_gear.lethal_gear:slider("Hit Chance", 1, 100, 0), 
    scale = l_config_sub_0.rage_gear.lethal_gear:slider("Baim Scale", 0, 100, 0), 
    enemy_hp = l_config_sub_0.rage_gear.lethal_gear:slider("Target HP", 1, 92, 0, nil, "hp")
};
l_config_sub_0.visual_gear = {
    viewmodel_gear = l_config_sub_0.visual.viewmodel:create(), 
    world_gear = l_config_sub_0.visual.world:create(), 
    damage_gear = l_config_sub_0.visual.damage:create(), 
    logger_gear = l_config_sub_0.visual.logger:create(), 
    center_gear = l_config_sub_0.visual.center:create(), 
    dmg_ind_gear = l_config_sub_0.visual.dmg_ind:create(), 
    manual_gear = l_config_sub_0.visual.manual:create(), 
    slowdown_gear = l_config_sub_0.visual.slowdown:create(), 
    scope_gear = l_config_sub_0.visual.scope:create(), 
    radius_gear = l_config_sub_0.visual.grenade:create()
};
l_config_sub_0.visual_slow = {
    style = l_config_sub_0.visual_gear.slowdown_gear:combo("Style", {
        [1] = "Bar", 
        [2] = "Line"
    })
};
l_config_sub_0.visual_radius = {
    smoke = l_config_sub_0.visual_gear.radius_gear:switch("Smoke", false, {
        color(130, 130, 255)
    }), 
    molotov = l_config_sub_0.visual_gear.radius_gear:switch("Molotov", false, {
        color(245, 90, 90)
    })
};
l_config_sub_0.visual_damage_ind = {
    color = l_config_sub_0.visual_gear.dmg_ind_gear:color_picker("Color"), 
    type = l_config_sub_0.visual_gear.dmg_ind_gear:combo("Style", {
        [1] = "Bold", 
        [2] = "Big", 
        [3] = "Medium", 
        [4] = "Pixel"
    })
};
l_config_sub_0.visual_center = {
    style = l_config_sub_0.visual_gear.center_gear:combo("Style", {
        [1] = "Lotus", 
        [2] = "Melancholia", 
        [3] = "Outlaw"
    })
};
l_config_sub_0.visual_manual = {
    style = l_config_sub_0.visual_gear.manual_gear:combo("Type", {
        [1] = "< >", 
        [2] = "\226\157\176 \226\157\177", 
        [3] = "\226\128\185 \226\128\186", 
        [4] = "\226\157\174 \226\157\175", 
        [5] = "New"
    }), 
    x = l_config_sub_0.visual_gear.manual_gear:slider("X", 20, 200, 95), 
    y = l_config_sub_0.visual_gear.manual_gear:slider("Y", -200, 200, 0), 
    len = l_config_sub_0.visual_gear.manual_gear:slider("Len", 2, 20, 6), 
    gap = l_config_sub_0.visual_gear.manual_gear:slider("Gap", 2, 20, 6), 
    color = l_config_sub_0.visual_gear.manual_gear:color_picker("Color")
};
l_config_sub_0.visual_center_sub = {
    color = l_config_sub_0.visual_gear.center_gear:color_picker("Color", {
        Left = {
            color(154, 226, 250, 255)
        }, 
        ["Left Alt"] = {
            color(109, 213, 250, 255)
        }, 
        Right = {
            color(255, 255, 255, 220)
        }, 
        ["Right Alt"] = {
            color(253, 163, 180, 220)
        }
    }), 
    color_2 = l_config_sub_0.visual_gear.center_gear:color_picker("Color_Main"), 
    show_text = l_config_sub_0.visual_gear.center_gear:switch("Show Text")
};
l_config_sub_0.visual_viewmodel_sub = {
    fov = l_config_sub_0.visual_gear.viewmodel_gear:slider("FOV", 0, 150, 60), 
    x = l_config_sub_0.visual_gear.viewmodel_gear:slider("X", -250, 250, 1, 0.01), 
    y = l_config_sub_0.visual_gear.viewmodel_gear:slider("Y", -250, 250, 1, 0.01), 
    z = l_config_sub_0.visual_gear.viewmodel_gear:slider("Z", -250, 250, 1, 0.01), 
    hand = l_config_sub_0.visual_gear.viewmodel_gear:combo("Switch Hand", {
        [1] = "Right", 
        [2] = "Left"
    }), 
    knfie_l = l_config_sub_0.visual_gear.viewmodel_gear:switch("Left Knife"), 
    knfie_r = l_config_sub_0.visual_gear.viewmodel_gear:switch("Right Knife")
};
l_config_sub_0.visual_world_sub = {
    start_pos = l_config_sub_0.visual_gear.world_gear:slider("Start", 0, 20, 0), 
    end_pos = l_config_sub_0.visual_gear.world_gear:slider("End", 0, 20, 0), 
    fade = l_config_sub_0.visual_gear.world_gear:slider("Fade", 0, 200, 0, 0.1), 
    speed = l_config_sub_0.visual_gear.world_gear:slider("Speed", 1, 70, 1), 
    wait = l_config_sub_0.visual_gear.world_gear:slider("Wait", 0, 200, 0, 0.1), 
    color = l_config_sub_0.visual_gear.world_gear:color_picker("Color")
};
l_config_sub_0.visual_logger_sub = {
    position = l_config_sub_0.visual_gear.logger_gear:selectable("Position", {
        [1] = "Top", 
        [2] = "Screen", 
        [3] = "Console"
    }), 
    top_style = l_config_sub_0.visual_gear.logger_gear:combo("Top Style", {
        [1] = "Neverlose", 
        [2] = "Print_Dev"
    }), 
    style = l_config_sub_0.visual_gear.logger_gear:combo("Style", {
        [1] = "Trashhode", 
        [2] = "Glow Text", 
        [3] = "Cycle", 
        [4] = "Old", 
        [5] = "Skeet", 
        [6] = "Ambani"
    }), 
    round = l_config_sub_0.visual_gear.logger_gear:switch("Round Notify")
};
l_config_sub_0.visual_logger_sub_2 = {
    glow_log = l_config_sub_0.visual_gear.logger_gear:slider("Glow", 10, 100, 20), 
    round_log = l_config_sub_0.visual_gear.logger_gear:slider("Round", 2, 15, 8), 
    strength_log = l_config_sub_0.visual_gear.logger_gear:slider("Strength", 0, 10, 0, 0.1), 
    space_log = l_config_sub_0.visual_gear.logger_gear:slider("Space", 35, 60, 35)
};
l_config_sub_0.visual_logger_color = {
    color_1 = l_config_sub_0.visual_gear.logger_gear:color_picker("Color_Cycle", {
        Notify = {
            color(139, 165, 255, 255)
        }, 
        Accent = {
            color(133, 111, 255, 255)
        }, 
        Second = {
            color(255, 154, 154, 255)
        }, 
        Background = {
            color(8, 3, 4, 255)
        }
    }), 
    color_2 = l_config_sub_0.visual_gear.logger_gear:color_picker("Color_Old", {
        Hit = {
            color(139, 165, 255, 255)
        }, 
        Background = {
            color(133, 111, 255, 255)
        }, 
        Miss = {
            color(139, 165, 255, 255)
        }
    }), 
    color_3 = l_config_sub_0.visual_gear.logger_gear:color_picker("Color_Glow", {
        Hit = {
            color(255, 154, 154, 255)
        }, 
        Miss = {
            color(255, 154, 154, 255)
        }
    }), 
    color_4 = l_config_sub_0.visual_gear.logger_gear:color_picker("Color_Trashhode", {
        Hit = {
            color(139, 165, 255, 255)
        }, 
        Miss = {
            color(255, 154, 154, 255)
        }
    })
};
l_config_sub_0.visual_damage_sub = {
    type = l_config_sub_0.visual_gear.damage_gear:combo("Type", {
        [1] = "Neverlose", 
        [2] = "Onetap", 
        [3] = "Seoge", 
        [4] = "Gabriola", 
        [5] = "Comic"
    }), 
    height = l_config_sub_0.visual_gear.damage_gear:slider("Height", -100, 100, 0), 
    width = l_config_sub_0.visual_gear.damage_gear:slider("Width", -100, 100, 0), 
    fade = l_config_sub_0.visual_gear.damage_gear:slider("Fade", 0, 200, 0, 0.1), 
    wait = l_config_sub_0.visual_gear.damage_gear:slider("Wait", 0, 200, 0, 0.1), 
    speed = l_config_sub_0.visual_gear.damage_gear:slider("Speed", 1, 70, 1), 
    color = l_config_sub_0.visual_gear.damage_gear:color_picker("Color", {
        Body = {
            color(255, 255, 255, 255)
        }, 
        Head = {
            color(255, 0, 0, 255)
        }
    })
};
l_config_sub_0.visual_scope = {
    pos = l_config_sub_0.visual_gear.scope_gear:slider("Position", 0, 500, 105), 
    offset = l_config_sub_0.visual_gear.scope_gear:slider("Offset", 0, 500, 10), 
    rotate = l_config_sub_0.visual_gear.scope_gear:switch("Rotate"), 
    color = l_config_sub_0.visual_gear.scope_gear:color_picker("Color")
};
l_config_sub_0.misc_gear = {
    nade_gear = l_config_sub_0.misc.dropnade:create(), 
    auto_gear = l_config_sub_0.misc.autoweapon:create(), 
    fakeping_gear = l_config_sub_0.misc.fakeping:create(), 
    animation_gear = l_config_sub_0.misc.animation:create()
};
l_config_sub_0.misc_sub = {
    nade_select = l_config_sub_0.misc_gear.nade_gear:selectable("Nade", {
        [1] = "Smoke", 
        [2] = "Molotov", 
        [3] = "Grenade"
    }), 
    nade_key = l_config_sub_0.misc_gear.nade_gear:hotkey("Key"), 
    ping_slider = l_config_sub_0.misc_gear.fakeping_gear:slider("Ping", 0, 200, 0, nil, "ms")
};
l_config_sub_0.misc_animation_sub = {
    onground = l_config_sub_0.misc_gear.animation_gear:combo("On Ground", {
        [1] = "Disabled", 
        [2] = "Jitter", 
        [3] = "Static", 
        [4] = "Moonwalk"
    }), 
    speed_1 = l_config_sub_0.misc_gear.animation_gear:slider("Offset#1", 1, 100, 80), 
    speed_2 = l_config_sub_0.misc_gear.animation_gear:slider("Offset#2", 1, 100, 80), 
    inair = l_config_sub_0.misc_gear.animation_gear:combo("In Air", {
        [1] = "Disabled", 
        [2] = "Static", 
        [3] = "Moonwalk"
    }), 
    misc = l_config_sub_0.misc_gear.animation_gear:selectable("Misc", {
        [1] = "Static Slow Walk", 
        [2] = "Earthquake", 
        [3] = "Pitch Zero"
    })
};
l_config_sub_0.dormant = {
    enable = l_shot_0:switch("Dormant Aimbot")
};
l_config_sub_0.dormant_gear = {
    gear = l_config_sub_0.dormant.enable:create()
};
l_config_sub_0.dormant_sub = {
    log = l_config_sub_0.dormant_gear.gear:switch("Dormant Logs"), 
    hitbox = l_config_sub_0.dormant_gear.gear:selectable("Hitboxs", {
        [1] = "Head", 
        [2] = "Chest", 
        [3] = "Stomach", 
        [4] = "Arms", 
        [5] = "Legs", 
        [6] = "Feet"
    }), 
    mindmg = l_config_sub_0.dormant_gear.gear:slider("Min. Damage", 0, 100, 1, nil, function(v369)
        if v369 == 0 then
            return "Rage";
        else
            return;
        end;
    end), 
    hc = l_config_sub_0.dormant_gear.gear:slider("Hit Chance", 1, 100, 70), 
    alpha = l_config_sub_0.dormant_gear.gear:slider("Alpha Modifier", 1, 1000, 300, 0.001), 
    autostop = l_config_sub_0.dormant_gear.gear:switch("Auto Stop")
};
l_config_sub_0.misc.chat:tooltip("This feature will hide your chat box");
l_config_sub_0.rage.lethal:tooltip("\vPlease note \r: \nthat this feature may not work when there are many enemies/enemy esp just appeared, so it is recommended to enable it in 11/22/55 matches");
l_config_sub_0.rage.dynamic:tooltip("This feature will dynamically adjust the head edge based on your speed");
l_config_sub_0.rage.predict:tooltip("\vPlease note \r: \nThis feature makes your game smoother by dynamically adjusting game interpolation based on latency, affecting how fast you see other players peek, \aFF0000FFand can severely reduce your FPS!");
l_config_sub_0.misc_gear.nade_gear:depend({
    [1] = nil, 
    [2] = true, 
    [1] = l_config_sub_0.misc.dropnade
});
l_config_sub_0.misc_gear.fakeping_gear:depend({
    [1] = nil, 
    [2] = true, 
    [1] = l_config_sub_0.misc.fakeping
});
l_config_sub_0.visual_logger_sub.top_style:depend({
    [1] = nil, 
    [2] = "Top", 
    [1] = l_config_sub_0.visual_logger_sub.position
});
l_config_sub_0.visual_logger_sub.style:depend({
    [1] = nil, 
    [2] = "Screen", 
    [1] = l_config_sub_0.visual_logger_sub.position
});
l_config_sub_0.visual_logger_sub.round:depend({
    [1] = nil, 
    [2] = "Console", 
    [1] = l_config_sub_0.visual_logger_sub.position
});
l_config_sub_0.visual_logger_color.color_1:depend({
    [1] = nil, 
    [2] = "Screen", 
    [1] = l_config_sub_0.visual_logger_sub.position
}, {
    [1] = nil, 
    [2] = "Cycle", 
    [1] = l_config_sub_0.visual_logger_sub.style
});
l_config_sub_0.visual_logger_color.color_2:depend({
    [1] = nil, 
    [2] = "Screen", 
    [1] = l_config_sub_0.visual_logger_sub.position
}, {
    [1] = nil, 
    [2] = "Old", 
    [1] = l_config_sub_0.visual_logger_sub.style
});
l_config_sub_0.visual_logger_color.color_3:depend({
    [1] = nil, 
    [2] = "Screen", 
    [1] = l_config_sub_0.visual_logger_sub.position
}, {
    [1] = nil, 
    [2] = "Glow Text", 
    [1] = l_config_sub_0.visual_logger_sub.style
});
l_config_sub_0.visual_logger_color.color_4:depend({
    [1] = nil, 
    [2] = "Screen", 
    [1] = l_config_sub_0.visual_logger_sub.position
}, {
    [1] = nil, 
    [2] = "Trashhode", 
    [1] = l_config_sub_0.visual_logger_sub.style
});
l_config_sub_0.rage_gear.lethal_gear:depend({
    [1] = nil, 
    [2] = true, 
    [1] = l_config_sub_0.rage.lethal
});
l_config_sub_0.misc_animation_sub.speed_1:depend({
    [1] = nil, 
    [2] = "Jitter", 
    [1] = l_config_sub_0.misc_animation_sub.onground
});
l_config_sub_0.misc_animation_sub.speed_2:depend({
    [1] = nil, 
    [2] = "Jitter", 
    [1] = l_config_sub_0.misc_animation_sub.onground
});
l_config_sub_0.visual_center.style:depend({
    [1] = nil, 
    [2] = true, 
    [1] = l_config_sub_0.visual.center
});
l_config_sub_0.visual_center_sub.color:depend({
    [1] = nil, 
    [2] = true, 
    [1] = l_config_sub_0.visual.center
}, {
    [1] = nil, 
    [2] = "Lotus", 
    [1] = l_config_sub_0.visual_center.style
});
l_config_sub_0.visual_center_sub.show_text:depend({
    [1] = nil, 
    [2] = true, 
    [1] = l_config_sub_0.visual.center
}, {
    [1] = nil, 
    [2] = "Lotus", 
    [1] = l_config_sub_0.visual_center.style
});
l_config_sub_0.visual_center_sub.color_2:depend({
    [1] = nil, 
    [2] = true, 
    [1] = l_config_sub_0.visual.center
}, {
    [1] = nil, 
    [2] = "Outlaw", 
    [1] = l_config_sub_0.visual_center.style
});
l_config_sub_0.visual_gear.manual_gear:depend({
    [1] = nil, 
    [2] = true, 
    [1] = l_config_sub_0.visual.manual
});
l_config_sub_0.visual_gear.world_gear:depend({
    [1] = nil, 
    [2] = true, 
    [1] = l_config_sub_0.visual.world
});
l_config_sub_0.visual_gear.damage_gear:depend({
    [1] = nil, 
    [2] = true, 
    [1] = l_config_sub_0.visual.damage
});
l_config_sub_0.visual_gear.logger_gear:depend({
    [1] = nil, 
    [2] = true, 
    [1] = l_config_sub_0.visual.logger
});
l_config_sub_0.visual_gear.dmg_ind_gear:depend({
    [1] = nil, 
    [2] = true, 
    [1] = l_config_sub_0.visual.dmg_ind
});
l_config_sub_0.visual_radius.smoke:depend({
    [1] = nil, 
    [2] = true, 
    [1] = l_config_sub_0.visual.grenade
});
l_config_sub_0.visual_radius.molotov:depend({
    [1] = nil, 
    [2] = true, 
    [1] = l_config_sub_0.visual.grenade
});
l_config_sub_0.visual_manual.len:depend({
    [1] = nil, 
    [2] = "New", 
    [3] = false, 
    [1] = l_config_sub_0.visual_manual.style
});
l_config_sub_0.visual_manual.gap:depend({
    [1] = nil, 
    [2] = "New", 
    [3] = false, 
    [1] = l_config_sub_0.visual_manual.style
});
l_config_sub_0.dormant.enable:depend({
    [1] = nil, 
    [2] = 1, 
    [1] = l_config_sub_0.page
});
l_config_sub_0.dormant.enable:disabled(true);
l_config_sub_0.misc.autoweapon:disabled(true);
l_config_sub_0.visual_slow.style:depend({
    [1] = nil, 
    [2] = true, 
    [1] = l_config_sub_0.visual.slowdown
});
l_config_sub_0.visual_viewmodel_sub.knfie_l:depend({
    [1] = nil, 
    [2] = "Right", 
    [1] = l_config_sub_0.visual_viewmodel_sub.hand
});
l_config_sub_0.visual_viewmodel_sub.knfie_r:depend({
    [1] = nil, 
    [2] = "Left", 
    [1] = l_config_sub_0.visual_viewmodel_sub.hand
});
l_pui_0.traverse(l_config_sub_0.rage, function(v370, _)
    -- upvalues: l_config_sub_0 (ref)
    v370:depend({
        [1] = nil, 
        [2] = 1, 
        [1] = l_config_sub_0.page
    });
end);
l_pui_0.traverse(l_config_sub_0.visual, function(v372, _)
    -- upvalues: l_config_sub_0 (ref)
    v372:depend({
        [1] = nil, 
        [2] = 2, 
        [1] = l_config_sub_0.page
    });
end);
l_pui_0.traverse(l_config_sub_0.visual_viewmodel_sub, function(v374, _)
    -- upvalues: l_config_sub_0 (ref)
    v374:depend({
        [1] = nil, 
        [2] = true, 
        [1] = l_config_sub_0.visual.viewmodel
    });
end);
l_pui_0.traverse(l_config_sub_0.misc, function(v376, _)
    -- upvalues: l_config_sub_0 (ref)
    v376:depend({
        [1] = nil, 
        [2] = 1, 
        [1] = l_config_sub_0.page
    });
end);
l_pui_0.traverse(l_config_sub_0.visual_logger_sub_2, function(v378, _)
    -- upvalues: l_config_sub_0 (ref)
    v378:depend({
        [1] = nil, 
        [2] = "Screen", 
        [1] = l_config_sub_0.visual_logger_sub.position
    }, {
        [1] = nil, 
        [2] = "Old", 
        [1] = l_config_sub_0.visual_logger_sub.style
    });
end);
l_pui_0.traverse(l_config_sub_0.rage_lethal_sub_1, function(v380, _)
    -- upvalues: l_config_sub_0 (ref)
    v380:depend({
        [1] = nil, 
        [2] = "Auto", 
        [1] = l_config_sub_0.rage_lethal.mode
    });
end);
l_pui_0.traverse(l_config_sub_0.rage_lethal_sub, function(v382, _)
    -- upvalues: l_config_sub_0 (ref)
    v382:depend({
        [1] = nil, 
        [2] = "Manual", 
        [1] = l_config_sub_0.rage_lethal.mode
    });
end);
l_pui_0.traverse(l_config_sub_0.visual_scope, function(v384, _)
    -- upvalues: l_config_sub_0 (ref)
    v384:depend({
        [1] = nil, 
        [2] = true, 
        [1] = l_config_sub_0.visual.scope
    });
end);
l_selectab_0 = (function()
    -- upvalues: l_config_sub_0 (ref), v71 (ref)
    local v386 = {};
    local v387 = {
        callback_registered = false, 
        maximum_count = 12
    };
    local _ = ui.get_style("{Link Active}");
    v387.register_callback = function(v389)
        -- upvalues: v386 (ref), l_config_sub_0 (ref), v71 (ref)
        if v389.callback_registered then
            return;
        else
            events.render:set(function()
                -- upvalues: v386 (ref), l_config_sub_0 (ref), v71 (ref), v389 (ref)
                local v390 = {
                    [1] = render.screen_size().x, 
                    [2] = render.screen_size().y
                };
                local _ = {
                    [1] = 0, 
                    [2] = 0, 
                    [3] = 0
                };
                local v392 = 1;
                local l_v386_0 = v386;
                for v394 = #l_v386_0, 1, -1 do
                    local v395 = l_v386_0[v394];
                    if v395.type == false then
                        v395.time = v395.time - globals.frametime;
                        local v396 = 255;
                        local v397 = 0;
                        local v398 = 0;
                        local v399 = 150;
                        local v400 = 0.5;
                        if v395.time < 0 then
                            table.remove(v386, v394);
                        else
                            local v401 = v395.def_time - v395.time;
                            local v402 = v401 > 1 and 1 or v401;
                            if v395.time < 1 or v402 < 1 then
                                v397 = (v402 < 1 and v402 or v395.time) / 1;
                                v398 = (v402 < 1 and v402 or v395.time) / 1;
                                v396 = v397 * 255;
                                v399 = v397 * 150;
                                v400 = v397 * 0.5;
                                if v397 < 0.2 then
                                    v392 = v392 + 8 * (1 - v397 / 0.2);
                                end;
                            end;
                            local v403 = {
                                [1] = render.measure_text(1, "", "[Trashhode.Dev]  ").x
                            };
                            local v404 = {
                                [1] = render.measure_text(1, "", v395.text_calc).x
                            };
                            local v405 = {
                                math.floor(render.measure_text(1, "", "[Trashhode.Dev]  " .. v395.text_calc).x * 1.03)
                            };
                            local v406 = {
                                [1] = v390[1] / 2 - v405[1] / 2 + 3, 
                                [2] = v390[2] - v390[2] / 100 * 13.4 + v392 + 30
                            };
                            local v407 = v405[1] + 2;
                            local v408 = 22;
                            local v409 = vector(v406[1] - 1, v406[2] - 20);
                            local v410 = vector(v409.x + v407, v409.y + v408);
                            local v411 = l_config_sub_0.visual_logger_color.color_1:get("Notify")[1];
                            local _ = l_config_sub_0.visual_logger_color.color_1:get("Main")[1];
                            local _ = l_config_sub_0.visual_logger_color.color_1:get("Second")[1];
                            local v414 = l_config_sub_0.visual_logger_color.color_1:get("Background")[1];
                            local l_r_3 = v411.r;
                            local l_g_3 = v411.g;
                            local l_b_3 = v411.b;
                            local _ = v411.a;
                            local _ = render.screen_size().x;
                            local _ = render.screen_size().y;
                            local v421 = v396 > 255 and 255 or v396;
                            render.rect(v409, v410, color(v414.r, v414.g, v414.b, v421));
                            render.circle(vector(v406[1] - 1, v406[2] - 8.3), color(v414.r, v414.g, v414.b, v421), 12, 180, 0.5);
                            render.circle(vector(v406[1] + v405[1] + 1, v406[2] - 8.3), color(v414.r, v414.g, v414.b, v421), 12, 0, 0.5);
                            render.circle_outline(vector(v406[1] - 1, v406[2] - 8.3), color(l_r_3, l_g_3, l_b_3, v396 > 200 and 200 or v396), 13, 90, v400, 2);
                            render.circle_outline(vector(v406[1] + v405[1] + 1, v406[2] - 8.3), color(l_r_3, l_g_3, l_b_3, v396 > 200 and 200 or v396), 13, -90, v400, 2);
                            render.line(vector(v406[1] + v405[1] + 1, v406[2] + 3), vector(v406[1] + 149 - v399, v406[2] + 3), color(l_r_3, l_g_3, l_b_3, v421));
                            render.line(vector(v406[1] + v405[1] + 1, v406[2] + 3), vector(v406[1] + 149 - v399, v406[2] + 3), color(l_r_3, l_g_3, l_b_3, v421));
                            render.line(vector(v406[1] - 1, v406[2] - 21), vector(v406[1] - 149 + v405[1] + v399, v406[2] - 21), color(l_r_3, l_g_3, l_b_3, v421));
                            render.line(vector(v406[1] - 1, v406[2] - 21), vector(v406[1] - 149 + v405[1] + v399, v406[2] - 21), color(l_r_3, l_g_3, l_b_3, v421));
                            local v422 = "\a" .. v71.rgba_to_hex(l_r_3, l_g_3, l_b_3, v421) .. "[Trashhode.Dev]  ";
                            render.text(1, vector(v406[1] + v405[1] / 2 - v404[1] / 2, v406[2] - 9), color(l_r_3, l_g_3, l_b_3, v396), "c", v422);
                            render.text(1, vector(v406[1] + v405[1] / 2 + v403[1] / 2, v406[2] - 9), color(255, 255, 255, v396), "c", v395.text_calc);
                            v392 = v392 - 33;
                        end;
                    else
                        v395.time = v395.time - globals.frametime;
                        local v423 = 255;
                        local v424 = 0;
                        local v425 = 0;
                        local v426 = 150;
                        local v427 = 0.5;
                        if v395.time < 0 then
                            table.remove(v386, v394);
                        else
                            local v428 = v395.def_time - v395.time;
                            local v429 = v428 > 1 and 1 or v428;
                            if v395.time < 1 or v429 < 1 then
                                v424 = (v429 < 1 and v429 or v395.time) / 1;
                                v425 = (v429 < 1 and v429 or v395.time) / 1;
                                v423 = v424 * 255;
                                v426 = v424 * 150;
                                v427 = v424 * 0.5;
                                if v424 < 0.2 then
                                    v392 = v392 + 8 * (1 - v424 / 0.2);
                                end;
                            end;
                            local v430 = v423 > 255 and 255 or v423;
                            local v431 = {
                                [1] = render.measure_text(1, "", "[Trashhode.Recode]  ").x
                            };
                            local v432 = {
                                [1] = render.measure_text(1, "", v395.text_calc).x
                            };
                            local v433 = {
                                math.floor(render.measure_text(1, "", "[Trashhode.Recode]  " .. v395.text_calc).x * 1.03)
                            };
                            local v434 = {
                                [1] = v390[1] / 2 - v433[1] / 2 + 3, 
                                [2] = v390[2] - v390[2] / 100 * 13.4 + v392 + 30
                            };
                            local v435 = v433[1] + 2;
                            local v436 = 24;
                            local v437 = vector(v434[1] - 1, v434[2] - 21);
                            local v438 = vector(v437.x + v435, v437.y + v436);
                            local v439 = l_config_sub_0.visual_logger_color.color_1:get("Notify")[1];
                            local v440 = l_config_sub_0.visual_logger_color.color_1:get("Accent")[1];
                            local v441 = {
                                [1] = v440.r, 
                                [2] = v440.g, 
                                [3] = v440.b, 
                                [4] = v440.a
                            };
                            local v442 = l_config_sub_0.visual_logger_color.color_1:get("Second")[1];
                            local v443 = {
                                [1] = v442.r, 
                                [2] = v442.g, 
                                [3] = v442.b, 
                                [4] = v442.a
                            };
                            local v444 = l_config_sub_0.visual_logger_color.color_1:get("Background")[1];
                            local l_r_4 = v439.r;
                            local l_g_4 = v439.g;
                            local l_b_4 = v439.b;
                            local _ = v439.a;
                            render.rect(v437, v438, color(v444.r, v444.g, v444.b, v430));
                            render.circle(vector(v434[1], v434[2] - 9), color(v444.r, v444.g, v444.b, v430), 12.5, 90, 0.5);
                            render.circle(vector(v434[1] + v433[1], v434[2] - 9), color(v444.r, v444.g, v444.b, v430), 12.5, 270, 0.5);
                            render.circle_outline(vector(v434[1] - 1, v434[2] - 9), color(l_r_4, l_g_4, l_b_4, v423 > 210 and 210 or v423), 14.5, 90, v427, 2.5);
                            render.circle_outline(vector(v434[1] + v433[1] + 1, v434[2] - 9), color(l_r_4, l_g_4, l_b_4, v423 > 210 and 210 or v423), 14.5, -90, v427, 2.5);
                            render.rect(vector(v434[1] - 2, v434[2] - 23), vector(v434[1] - 149 + v433[1] + v426, v434[2] - 21), color(l_r_4, l_g_4, l_b_4, v430));
                            render.rect(vector(v434[1] + v433[1] + 1, v434[2] + 3), vector(v434[1] + 149 - v426, v434[2] + 5), color(l_r_4, l_g_4, l_b_4, v430), 0, true);
                            local v449 = v71.gradient_text(v441[1], v441[2], v441[3], v423, v443[1], v443[2], v443[3], v423, "[Trashhode.Recode]  ");
                            render.text(1, vector(v434[1] + v433[1] / 2 - v432[1] / 2, v434[2] - 9), color(l_r_4, l_g_4, l_b_4, v423), "c", v449);
                            local l_text_format_num_0 = v395.text_format_num;
                            local l_text_format_text_0 = v395.text_format_text;
                            local l_text_format_color_0 = v395.text_format_color;
                            local v453 = v71.a_to_hex(v423);
                            local v454 = string.format(v395.text_format, v71.alpha_to_textformat(l_text_format_num_0, l_text_format_text_0, l_text_format_color_0, v453));
                            render.text(1, vector(v434[1] + v433[1] / 2 + v431[1] / 2, v434[2] - 9), color(255, 255, 255, v423), "c", v454);
                            v392 = v392 - 33;
                        end;
                    end;
                end;
                v389.callback_registered = true;
            end);
            return;
        end;
    end;
    v387.paint = function(v455, v456, v457, v458, v459, v460, v461, v462)
        -- upvalues: v386 (ref)
        local v463 = tonumber(v456) + 1;
        for v464 = v455.maximum_count, 2, -1 do
            v386[v464] = v386[v464 - 1];
        end;
        v386[1] = {
            time = v463, 
            def_time = v463, 
            text_calc = v457, 
            type = v458, 
            text_format = v459, 
            text_format_num = v460, 
            text_format_text = v461, 
            text_format_color = v462
        };
        v455:register_callback();
    end;
    return v387;
end)();
l_main_0 = (function()
    -- upvalues: v305 (ref)
    return {
        callback_registered = false, 
        maximum_count = 5, 
        data2 = {}, 
        stored_callbacks = function(v465)
            -- upvalues: v305 (ref)
            if v465.callback_registered then
                return;
            else
                events.render:set(function()
                    -- upvalues: v465 (ref), v305 (ref)
                    local v466 = {
                        [1] = render.screen_size().x, 
                        [2] = render.screen_size().y
                    };
                    local v467 = 5;
                    local l_data2_0 = v465.data2;
                    for v469 = #l_data2_0, 1, -1 do
                        v465.data2[v469].time = v465.data2[v469].time - globals.frametime;
                        local _ = 255;
                        local v471 = 0;
                        local v472 = l_data2_0[v469];
                        if v472.time < 0 then
                            table.remove(v465.data2, v469);
                        else
                            local v473 = v472.def_time - v472.time;
                            local v474 = v473 > 1 and 1 or v473;
                            if v472.time < 0.5 or v474 < 0.5 then
                                v471 = (v474 < 1 and v474 or v472.time) / 0.5;
                                if v471 < 0.2 then
                                    v467 = v467 + 15 * (1 - v471 / 0.2);
                                end;
                            end;
                            local v475 = render.measure_text(1, nil, v472.draw);
                            local v476 = {
                                [1] = v475.x, 
                                [2] = v475.y
                            };
                            local v477 = {
                                [1] = v466[1] / 2 - v476[1] / 2 + 3, 
                                [2] = v466[2] - v466[2] / 100 * 17.4 + v467
                            };
                            v305(v477[1] - 4, v477[2] - 20, v476[1] + 26, v476[2] + 24, 1, true);
                            render.text(1, vector(v477[1] + v476[1] / 2 + 7, v477[2] - 2), color(255, 255, 255, 255), "c", v472.draw);
                            v467 = v467 - 45;
                        end;
                    end;
                    v465.callback_registered = true;
                end);
                return;
            end;
        end, 
        paint = function(v478, v479, v480)
            local v481 = tonumber(v479) + 1;
            for v482 = v478.maximum_count, 2, -1 do
                v478.data2[v482] = v478.data2[v482 - 1];
            end;
            v478.data2[1] = {
                time = v481, 
                def_time = v481, 
                draw = v480
            };
            v478:stored_callbacks();
        end
    };
end)();
l_sub_0 = function(v483, v484)
    return v484 .. v483 .. "\aDEFAULT";
end;
l_cnd_list_0 = {};
l_fakelag_0 = {};
l_shot_0 = {};
local v485 = {};
local v486 = {};
local v489 = (function()
    local l_status_3, l_result_3 = pcall(render.load_font, "Poppins Bold", vector(14, 11), "a");
    return l_status_3 and l_result_3 or 4;
end)();
local v490 = {
    c4 = "Bombed", 
    inferno = "Burned", 
    molotov = "Harmed", 
    hegrenade = "Naded", 
    flashbang = "Harmed", 
    incgrenade = "Harmed", 
    smokegrenade = "Harmed", 
    knife = "Knifed", 
    decoy = "Decoyed"
};
local function v493(v491, v492)
    -- upvalues: v485 (ref)
    table.insert(v485, {
        width = 0, 
        anim_mod = 0, 
        circle = 0, 
        color2 = 0, 
        w = 0, 
        str_a = 0, 
        height = 0, 
        color = 0, 
        text = v491, 
        time = v492 or 5, 
        anim_time = globals.curtime
    });
end;
v486.old_notify = function(_)
    -- upvalues: l_shot_0 (ref), l_config_sub_0 (ref)
    local v495 = 0;
    for v496, v497 in ipairs(l_shot_0) do
        if v497.time + 2 > globals.realtime then
            v497.alpha = math.lerp(v497.alpha, 255, 0.085);
        end;
        local v498 = tostring(v497.text);
        local v499 = render.screen_size();
        local l_x_1 = v499.x;
        local l_y_1 = v499.y;
        local v502 = render.measure_text(1, "", v498).x / 2;
        local v503 = l_config_sub_0.visual_logger_sub_2.round_log:get();
        local v504 = l_config_sub_0.visual_logger_sub_2.strength_log:get();
        local v505 = l_config_sub_0.visual_logger_sub_2.space_log:get();
        local v506 = l_config_sub_0.visual_logger_sub_2.glow_log:get();
        local v507 = l_config_sub_0.visual_logger_color.color_2:get("Background")[1];
        local v508 = color(v507.r, v507.g, v507.b, v497.alpha * 0.8 - v507.a);
        local v509 = v497.glow or l_config_sub_0.visual_logger_color.color_2:get("Glow")[1];
        local v510 = color(v509.r, v509.g, v509.b, v497.alpha);
        local v511 = vector(l_x_1 / 2 - v502 - 10, l_y_1 / 1.22 - v495 - 6);
        local v512 = vector(l_x_1 / 2 + v502 - 1, l_y_1 / 1.22 - v495 + 20);
        render.blur(v511, v512, v504, v497.alpha, v503);
        render.rect(v511, v512, v508, v503);
        render.shadow(v511, v512, v510, v506, 0, v503);
        render.text(4, vector(l_x_1 / 2 - v502, l_y_1 / 1.22 - v495), color(255, 255, 255, v497.alpha), nil, v498);
        v495 = v495 + v505 * v497.alpha / 255;
        if v497.time + 5 < globals.realtime then
            v497.alpha = math.lerp(v497.alpha, 0, 0.095);
        end;
        if v497.alpha < 1 or #l_shot_0 > 5 then
            table.remove(l_shot_0, v496);
        end;
    end;
end;
v486.text_notify = function(_)
    -- upvalues: l_fakelag_0 (ref), l_config_sub_0 (ref)
    local v514 = 0;
    for v515, v516 in ipairs(l_fakelag_0) do
        if v516.time + 5 > globals.realtime then
            v516.alpha = math.lerp(v516.alpha, 255, 0.085);
        else
            v516.alpha = math.lerp(v516.alpha, 0, 0.095);
        end;
        local v517 = tostring(v516.text);
        local v518 = render.measure_text(1, "", v517).x / 2;
        local v519 = render.screen_size();
        local l_x_2 = v519.x;
        local l_y_2 = v519.y;
        local v522 = v516.glow or l_config_sub_0.visual_logger_color.color_3:get("Glow")[1];
        render.shadow(vector(l_x_2 / 2 - v518 - 8, l_y_2 / 1.24 - v514 + 26), vector(l_x_2 / 2 + v518 - 1, l_y_2 / 1.24 - v514 + 26), color(v522.r, v522.g, v522.b, v516.alpha), 35, -1, 0);
        render.text(1, vector(l_x_2 / 2 - v518, l_y_2 / 1.218 - v514), color(255, 255, 255, v516.alpha), nil, v517);
        v514 = v514 + 20 * v516.alpha / 255;
        if v516.alpha < 1 or #l_fakelag_0 > 8 then
            table.remove(l_fakelag_0, v515);
        end;
    end;
end;
v486.clear = function(_)
    -- upvalues: l_cnd_list_0 (ref)
    l_cnd_list_0 = {};
end;
local v524 = {};
v486.createNotification = function(_, v526, v527)
    -- upvalues: l_config_sub_0 (ref), v524 (ref)
    if not l_config_sub_0.visual.logger:get() or l_config_sub_0.visual_logger_sub.style:get() ~= "Trashhode" then
        return;
    else
        local v528 = {
            alpha = 0, 
            life = 5, 
            msg = v527, 
            col = v526
        };
        table.insert(v524, 1, v528);
        return;
    end;
end;
v486.hitboxName = function(_, v530)
    -- upvalues: v63 (ref)
    return v63[v530] or "\230\147\141\228\189\160\229\166\136NL,\228\189\160\229\143\136\230\137\147\228\184\173\228\187\128\228\185\136\231\142\169\230\132\143\228\186\134?";
end;
v486.renderNotifications = function(_)
    -- upvalues: l_config_sub_0 (ref), v524 (ref), v71 (ref), v489 (ref)
    if not l_config_sub_0.visual_logger_sub.position:get("Screen") or not l_config_sub_0.visual.logger:get() or l_config_sub_0.visual_logger_sub.style:get() ~= "Trashhode" then
        return;
    else
        local l_frametime_0 = globals.frametime;
        local v533 = #v524;
        for v534 = v533, 1, -1 do
            local v535 = v524[v534];
            local v536 = v535.life > 0 and v533 - v534 < 5;
            v535.alpha = v71.interp(v535.alpha, v536, 0.05);
            if v536 then
                v535.life = v535.life - l_frametime_0;
            elseif v535.alpha <= 0 then
                table.remove(v524, v533);
            end;
        end;
        local v537 = render.screen_size() * 0.5;
        v537.y = v537.y * 1.47;
        local v538 = "          Trashhode";
        local v539 = render.measure_text(v489, nil, v538);
        for _, v541 in ipairs(v524) do
            local l_alpha_0 = v541.alpha;
            local l_col_0 = v541.col;
            local v544 = v541.msg:sub(1, v71.roundNumber(#v541.msg * l_alpha_0));
            local v545 = render.measure_text(v489, nil, v544) + vector(10.5, 6.5) * 3.5;
            v545.x = v545.x + v539.x + 4;
            local v546 = v537 - v545 * 0.5;
            local v547 = v546 + vector(10.5, 11.5);
            local v548 = v547 + vector(v539.x + 4, 0);
            local v549 = v546 + v545;
            v71.Manual_Glow(v546.x, v546.y, v549.x, v549.y, color(l_col_0.r, l_col_0.g, l_col_0.b, 128 * l_alpha_0), 15, 17);
            render.rect(v546, v549, color(18, 18, 18, 255 * l_alpha_0), 17);
            render.text(v489, v547, color(l_col_0.r, l_col_0.g, l_col_0.b, 255 * l_alpha_0), nil, v538);
            render.text(v489, v548, color(200, 200, 200, 255 * l_alpha_0), nil, v544);
            v537.y = v537.y + v71.roundNumber((v545.y + 25) * l_alpha_0);
        end;
        return;
    end;
end;
v486.handleHit = function(v550, v551)
    -- upvalues: l_sub_0 (ref), l_config_sub_0 (ref)
    local l_target_0 = v551.target;
    if not l_target_0 then
        return;
    else
        local v553 = v550:hitboxName(v551.hitgroup);
        local v554 = v550:hitboxName(v551.wanted_hitgroup);
        local v555 = "\a96C83CFF";
        local v556 = "\aFFCA00FF";
        local v557 = v553 == v554;
        local v558 = l_sub_0(v553, v557 and v555 or v556);
        local v559 = l_sub_0(v554, v557 and v555 or v556);
        local v560 = l_config_sub_0.visual_logger_color.color_4:get("Hit")[1];
        local v561 = l_target_0:is_alive() and "\a96C83CFFHit\aDEFAULT" or "\a96C83CFFKilled\aDEFAULT";
        local v562 = l_target_0:get_name();
        local l_hitchance_0 = v551.hitchance;
        local l_damage_0 = v551.damage;
        local _ = v551.wanted_damage;
        local l_backtrack_0 = v551.backtrack;
        local l_m_iHealth_0 = l_target_0.m_iHealth;
        local v568 = l_m_iHealth_0 <= 0 and "dead" or l_m_iHealth_0 .. " remaining";
        v550:createNotification(v560, (string.format("    \aABABAB42|    \aDEFAULT %s %s in %s for \a96C83CFF%s\aDEFAULT damage " .. "hc: \a96C83CFF%d\aDEFAULT %% bt: \a96C83CFF%d\aDEFAULT t remain: %s " .. "wanted hitbox: %s", v561, v562, v558, l_damage_0, l_hitchance_0, l_backtrack_0, v568, v559)));
        return;
    end;
end;
v486.handleMiss = function(v569, v570)
    -- upvalues: l_config_sub_0 (ref)
    local l_target_1 = v570.target;
    if not l_target_1 then
        return;
    else
        local v572 = l_config_sub_0.visual_logger_color.color_4:get("Miss")[1];
        local v573 = l_target_1:get_name();
        local l_hitchance_1 = v570.hitchance;
        local v575 = v569:hitboxName(v570.wanted_hitgroup);
        local l_backtrack_1 = v570.backtrack;
        local v577 = v570.state or "resolver";
        v569:createNotification(v572, (string.format("    \aABABAB42|    \aDEFAULT  \aFF5959FFMissed\aDEFAULT %s's %s due to " .. "\aFF5959FF%s\aDEFAULT hc: \aFF5959FF%d %% \aDEFAULTbt: \aFF5959FF%d t", v573, v575, v577, l_hitchance_1, l_backtrack_1)));
        return;
    end;
end;
v486.handleAimAcknowledgement = function(v578, v579)
    if v579.state == nil then
        v578:handleHit(v579);
    else
        v578:handleMiss(v579);
    end;
end;
v486.handlePlayerHurt = function(v580, v581)
    -- upvalues: v490 (ref), l_config_sub_0 (ref)
    local v582 = entity.get_local_player();
    local v583 = entity.get(v581.userid, true);
    if entity.get(v581.attacker, true) ~= v582 or v583 == v582 then
        return;
    else
        local v584 = v490[v581.weapon];
        if not v584 then
            return;
        else
            v580:createNotification(l_config_sub_0.visual_logger_color.color_4:get("Hit")[1], (string.format("\aABABAB42    |    \aDEFAULT %s %s for \a96C83CFF%s\aDEFAULT damage", v584, v583:get_name(), v581.dmg_health)));
            return;
        end;
    end;
end;
v486.on_player_hurt = function(v585, v586)
    -- upvalues: l_config_sub_0 (ref)
    if l_config_sub_0.visual_logger_sub.style:get() == "Trashhode" then
        v585:handlePlayerHurt(v586);
    end;
end;
v486.on_aim_ack = function(v587, v588)
    -- upvalues: l_config_sub_0 (ref)
    if l_config_sub_0.visual_logger_sub.style:get() == "Trashhode" then
        v587:handleAimAcknowledgement(v588);
    end;
end;
v486.on_render = function(v589)
    v589:renderScrollingText();
    v589:renderNotifications();
    v589:text_notify();
    v589:old_notify();
end;
v486.renderScrollingText = function(_)
    -- upvalues: v485 (ref), v71 (ref)
    local _ = globals.curtime;
    local v592 = 1.5 * globals.frametime;
    local v593 = 8;
    local v594 = render.screen_size();
    local v595 = 255;
    local v596 = 255;
    local v597 = 255;
    local v598 = 255;
    local v599 = 255;
    for v600, v601 in ipairs(v485) do
        v601.time = v601.time - globals.frametime;
        if v600 > 8 then
            table.remove(v485, 1);
        end;
        if v601.time <= 0 then
            table.remove(v485, v600);
        end;
        local v602 = v71.color_text(v601.text, 150, 150, 255, 255 * v601.color2);
        local v603 = render.measure_text(1, "[Trashhode] ", "cb", v602) - 123;
        local v604 = vector(v594.x / 2);
        local v605 = vector(v594.y / 2 + 192);
        local v606 = v603.x + 5;
        if v601.time > 5 then
            v601.color = math.lerp(v601.color, v598, 2 * globals.frametime);
            v601.color2 = math.lerp(v601.color2, v599, v592);
            v601.width = math.lerp(v601.width, 163, v592);
            v601.anim_mod = math.lerp(v601.anim_mod, v601.time, v592);
            v601.circle = math.lerp(v601.circle, 0.64, v592);
            v601.str_a = v601.str_a + v592 * 2;
            if v601.str_a > 0.99 then
                v601.start = 1;
            end;
            v601.height = math.lerp(v601.height, 200, 1 * globals.frametime);
            v601.w = math.lerp(v601.w, v603.x + 8, v601.anim_mod);
        end;
        if v601.time < 0.4 then
            v601.color = math.lerp(v601.color, -v598, 1 * globals.frametime);
            v601.color2 = math.lerp(v601.color2, -v599, 1 * globals.frametime);
            v601.anim_mod = math.lerp(v601.anim_mod, -v601.time - 5, v592);
            v601.width = math.lerp(v601.width, -163, v592);
            v601.height = math.lerp(v601.height, -100, v592);
            v601.circle = math.lerp(v601.circle, -0.64, v592);
            v601.str_a = v601.str_a - (v601.w < 20 and v592 * 3 or v592);
            if v601.str_a < 0.01 then
                v601.str_a = 0;
            end;
            local v607 = v601.anim_mod * -1 + 1;
            v601.w = math.lerp(v601.w, 5, v607);
        end;
        if v601.time > 4 and v601.anim_mod <= 0 then
            table.remove(v485, v600);
        end;
        local v608 = "[Trashhode] ";
        v593 = v593 + 35 + v601.anim_mod;
        v604 = v604 - v606 / 2;
        v605 = v605 / 10 * 13.4 - v593;
        v71.ambani_rect(v604.x - 52, v605.y + v594.y - v601.height - 11, v604.x + v603.x + 61, v605.y + v594.y - v601.height + 8, v601.color, color(150, 150, 255, v601.color - 70), color(30, 30, 30, v601.color - 50));
        render.text(4, vector(v604.x - 48 + v603.x - v603.x + render.measure_text(1, v608, nil).x, v605.y + v594.y - v601.height - 6), color(v595, v596, v597, v601.color), nil, v602);
    end;
end;
v64[#v64 + 1] = v486;
local v675 = {
    global_set = function()
        -- upvalues: v15 (ref), l_link_0 (ref)
        v15.aa.enable:override(true);
        v15.aa.backstab:override(l_link_0.all_set.avoid:get());
        if l_link_0.set.manual:get() ~= "Disabled" and l_link_0.set_sub.manual_op:get("Local View") then
            v15.aa.yaw_base:override("Local View");
        elseif l_link_0.all_set.at_target:get() then
            v15.aa.yaw_base:override("At Target");
        else
            v15.aa.yaw_base:override("Local View");
        end;
        v15.aa.yaw:override("Backward");
    end, 
    cycle_delay_tick = function(v609, v610, v611)
        local v612 = (v610 + v609) / 2 + (v610 - v609) / 2 * math.sin(globals.curtime * (v611 * 0.2));
        return (math.floor(v612 + 0.5));
    end, 
    get_state = function()
        -- upvalues: v15 (ref), l_link_0 (ref), v68 (ref)
        if not globals.is_connected then
            return;
        else
            local v613 = entity.get_local_player();
            if not v613 or not v613:is_alive() then
                return;
            else
                local v614 = v613:get_player_weapon();
                if v614 == nil then
                    state = "global";
                    return;
                else
                    local l_m_vecVelocity_0 = v613.m_vecVelocity;
                    local l_x_3 = l_m_vecVelocity_0.x;
                    local l_y_3 = l_m_vecVelocity_0.y;
                    local v618 = math.floor((l_x_3 * l_x_3 + l_y_3 * l_y_3) ^ 0.5 + 0.5);
                    local l_m_fFlags_0 = v613.m_fFlags;
                    local v620 = bit.band(l_m_fFlags_0, 1) == 0;
                    local v621 = v618 < 2;
                    local l_m_flDuckAmount_0 = v613.m_flDuckAmount;
                    local v623 = v15.aa.slow:get();
                    local _ = {
                        [1] = l_x_3, 
                        [2] = l_y_3, 
                        [3] = l_m_vecVelocity_0.z
                    };
                    local l_m_iTeamNum_0 = v613.m_iTeamNum;
                    local l_weapon_name_0 = v614:get_weapon_info().weapon_name;
                    local v627 = v614:get_weapon_index();
                    if not l_weapon_name_0 or l_weapon_name_0 == "" then
                        return;
                    else
                        local v628 = l_weapon_name_0 == "weapon_knife";
                        local v629 = l_weapon_name_0 == "weapon_taser";
                        local v630 = v627 == 64;
                        local v631 = l_link_0.set.revolver:get();
                        if v620 then
                            v68.landtick = 1;
                        else
                            v68.landtick = v68.landtick + 1;
                        end;
                        local v632 = "";
                        if not v15.rage.dt:get() and not v15.rage.hs:get() then
                            v632 = v15.rage.fd:get() and "fake duck" or "fake lag";
                        elseif v630 and v631 then
                            v632 = "revolver";
                        elseif v68.landtick < 10 and l_m_flDuckAmount_0 > 0 then
                            v632 = v628 and "airknife" or v629 and "airtaser" or "airduck";
                        elseif v68.landtick < 10 then
                            v632 = "air";
                        elseif l_m_flDuckAmount_0 > 0 then
                            if v618 <= 2 then
                                v632 = l_m_iTeamNum_0 == 2 and "tcrouch" or "ctcrouch";
                            else
                                v632 = "sneak";
                            end;
                        elseif v15.rage.fd:get() then
                            v632 = l_m_iTeamNum_0 == 2 and "tcrouch" or "ctcrouch";
                        else
                            v632 = v623 and "slow" or v621 and "stand" or "moving";
                        end;
                        return v632;
                    end;
                end;
            end;
        end;
    end, 
    get_pitch_spin = function(v633, v634, v635, v636)
        local v637 = math.min(v634, v635);
        local v638 = math.max(v634, v635);
        if v633 < v638 then
            v633 = v633 + v636 - 0.4;
        elseif v638 <= v633 then
            v633 = v637;
        end;
        return (math.clamp(v633, -89, 89));
    end, 
    get_yaw_spin = function(v639, v640, v641, v642)
        local v643 = math.min(v640, v641);
        local v644 = math.max(v640, v641);
        if v639 < v644 then
            v639 = v639 + v642 - 0.4;
        elseif v644 <= v639 then
            v639 = v643;
        end;
        return (math.clamp(v639, -180, 180));
    end, 
    random_jitter = function(v645)
        local v646 = math.random(0, 1) == 0 and 1 or -1;
        local v647 = math.random(v645 * -0.25, v645 * 0.25);
        return v646 * 90 + v647;
    end, 
    get_pitch_cycle_spin = function(v648, v649, v650)
        return (v649 + v648) / 2 + (v649 - v648) / 2 * math.sin(globals.curtime * (v650 * 0.2));
    end, 
    get_yaw_cycle_spin = function(v651)
        local v652 = v651.defensive_yaw_full:get();
        local v653 = v651.defensive_yaw_jitter_speed:get();
        local v654 = math.sin(globals.curtime * (v653 * 0.2)) * 0.5 + 0.5;
        local v655 = v651.defensive_yaw_cycle_invert:get();
        local v656 = nil;
        if v655 then
            v656 = math.lerp(v652 * -0.5, v652 * 0.5, v654);
        else
            v656 = 180 + math.lerp(v652 * -0.5, v652 * 0.5, v654);
        end;
        return v656;
    end, 
    spin_jitter = function(v657, v658)
        local v659 = v657.defensive_yaw_full:get();
        local v660 = v657.defensive_yaw_speed:get();
        local v661 = v658 and 1 or -1;
        local v662 = math.lerp(v659 * -0.5, v659 * 0.5, globals.curtime * (v660 * 0.1) % 1);
        return v661 * 90 + v662;
    end, 
    adaptive_yaw = function(v663)
        -- upvalues: v71 (ref), v15 (ref)
        local v664 = v71.get_left_right();
        local v665 = v663.defensive_yaw_adaptive:get();
        local v666 = v15.aa.yaw_offset:get_override();
        if v664 == "Middle" or v664 == nil then
            return globals.tickcount % math.random(14, 20) > 1 and -100 or 100;
        else
            local v667 = -v665 + v666;
            local v668 = v665 + v666;
            if v663.defensive_yaw_flick:get() then
                return globals.tickcount % math.random(15, 20) > 1 and v667 or v668;
            else
                return v664 == "Left" and v667 or v668;
            end;
        end;
    end, 
    random_static_yaw = function(v669)
        -- upvalues: v66 (ref)
        if not math.exploit() then
            v66.yaw.last_def_yaw = utils.random_int(v669.defensive_yaw_min:get(), v669.defensive_yaw_max:get());
        end;
        return v66.yaw.last_def_yaw;
    end, 
    random_static_pitch = function(v670)
        -- upvalues: v66 (ref)
        if not math.exploit() then
            v66.pitch.last_def_pitch = utils.random_int(v670.defensive_pitch_min:get(), v670.defensive_pitch_max:get());
        end;
        return v66.pitch.last_def_pitch;
    end, 
    random_static_tick = function(v671)
        -- upvalues: v65 (ref)
        local v672 = v671.defensive_flick_tick_min:get();
        local v673 = v671.defensive_flick_tick_max:get();
        if not math.exploit() then
            v65.tick.random = utils.random_int(math.max(v672, v673), math.min(v672, v673));
        end;
        return v65.tick.random;
    end, 
    flick_beta = function()
        -- upvalues: v65 (ref)
        local l_beta_0 = v65.beta;
        l_beta_0.index = l_beta_0.index % #l_beta_0.counts + 1;
        return l_beta_0.counts[l_beta_0.index];
    end
};
local v687 = {
    get_defensive_tickbase = function(_)
        -- upvalues: v66 (ref)
        local l_m_nTickBase_1 = entity.get_local_player().m_nTickBase;
        if math.abs(l_m_nTickBase_1 - v66.tick.max) > 64 then
            v66.tick.max = 0;
        end;
        if v66.tick.max < l_m_nTickBase_1 then
            v66.tick.max = l_m_nTickBase_1;
        elseif l_m_nTickBase_1 < v66.tick.max then
            v66.tick.left = math.min(14, math.max(0, v66.tick.max - l_m_nTickBase_1 - 1));
        end;
    end, 
    get_defensive_command_run = function(_, v679)
        -- upvalues: v66 (ref)
        v66.cmd_tick.cmd_num = v679.command_number;
    end, 
    get_defensive_command = function(v680, v681)
        -- upvalues: v66 (ref)
        local v682 = entity.get_local_player();
        if v682 == nil then
            return;
        elseif not v682.is_alive then
            return;
        else
            v680:get_defensive_command_run(v681);
            if v681.command_number == v66.cmd_tick.cmd_num then
                v66.cmd_tick.cmd_num = nil;
                local l_m_nTickBase_2 = v682.m_nTickBase;
                if math.abs(l_m_nTickBase_2 - v66.cmd_tick.max) > 64 then
                    v66.cmd_tick.max = 0;
                end;
                if v66.cmd_tick.max ~= nil then
                    v66.cmd_tick.left = math.abs(l_m_nTickBase_2 - v66.cmd_tick.max);
                end;
                v66.cmd_tick.max = math.max(l_m_nTickBase_2, v66.cmd_tick.max or 0);
            end;
            return;
        end;
    end, 
    on_createmove = function(v684)
        v684:get_defensive_tickbase();
    end, 
    on_createmove_run = function(v685, v686)
        v685:get_defensive_command(v686);
    end
};
v64[#v64 + 1] = v687;
local function v688()
    -- upvalues: v15 (ref)
    v15.aa.yaw_offset:override(0);
    v15.aa.yaw_jitter:override("Disabled");
    v15.aa.yj_offset:override(0);
    v15.aa.by_option:override("");
    v15.aa.by_l:override(0);
    v15.aa.by_r:override(0);
end;
local v906 = {
    yaw_dir = "Disabled", 
    period_jitter = function(_, v690)
        -- upvalues: v65 (ref)
        local v691 = false;
        local v692 = entity.get_local_player();
        if v690.desync:get() == "Jitter" then
            if v690.desync_period:get() then
                v691 = math.floor(math.min(60, v692.m_flPoseParameter[11] * 120 - 60)) > 0;
            else
                v691 = v690.delay_base:get() ~= "Neverlose" and v65.aa.switch_delay;
            end;
        end;
        return v691;
    end, 
    get_sanya_offset = function(_, v694)
        -- upvalues: v65 (ref)
        local v695 = v694.modifier_mode_offset:get();
        if v695 == 0 then
            return 0;
        else
            local v696 = math.ceil(math.abs(v695) / 2);
            v65.sanya.phase = v65.sanya.phase % 2 + 1;
            return v65.sanya.phase == 1 and -v696 or v696;
        end;
    end, 
    sanya = function(_)
        -- upvalues: v65 (ref)
        local l_cycle_0 = v65.cycle;
        l_cycle_0.frame = l_cycle_0.frame + 1;
        if l_cycle_0.counts[l_cycle_0.index] < l_cycle_0.frame then
            l_cycle_0.frame = 1;
            l_cycle_0.index = l_cycle_0.index % #l_cycle_0.counts + 1;
            l_cycle_0.current = l_cycle_0.current == "3-Way" and "Random" or "3-Way";
        end;
        return l_cycle_0.current;
    end, 
    get_pair_add = function(_, v700)
        -- upvalues: v65 (ref)
        if not v700.yaw_fluctate_enable:get() then
            return 0;
        else
            local v701 = v700.yaw_fluctate:get();
            if globals.choked_commands == 0 then
                v65.flu.idx = (v65.flu.idx or 0) + 1;
                v65.flu.random_fluctuation = math.random(0, v701);
                if v65.flu.idx % 4 == 0 then
                    v65.flu.random_fluctuation = v65.flu.random_fluctuation * -1;
                end;
            end;
            return v65.flu.random_fluctuation;
        end;
    end, 
    prepare = function(_)
        -- upvalues: l_link_0 (ref)
        local v703 = entity.get_local_player();
        local v704 = v703:get_player_weapon();
        if not v703 or not v703:is_alive() or v704 == nil or v703.m_MoveType == 9 or not l_link_0.general.master:get() then
            return false;
        else
            return true;
        end;
    end, 
    update_switch = function(_, v706, v707)
        -- upvalues: v66 (ref)
        local _ = globals.choked_commands;
        local _ = globals.tickcount;
        v707.tick.current = v707.tick.current + 1;
        if v707.tick.current > v706.delay_jittertick_repeat:get() then
            v707.tick.current = 0;
            v707.packet.delay_times = not v707.packet.delay_times;
        end;
        v707.tick.current_2 = v707.tick.current_2 + 1;
        if v707.tick.current_2 > v706.defensive_flick_jitter_repeat:get() then
            v707.tick.current_2 = 0;
            v707.packet.delay_times_2 = not v707.packet.delay_times_2;
        end;
        v66.tickcount.current_pitch = v66.tickcount.current_pitch + 1;
        if v66.tickcount.current_pitch > v706.defensive_pitch_jitter_speed:get() then
            v66.tickcount.current_pitch = 0;
            v66.side.switch_pitch = not v66.side.switch_pitch;
        end;
        v66.tickcount.current_yaw = v66.tickcount.current_yaw + 1;
        if v66.tickcount.current_yaw > v706.defensive_yaw_jitter_speed:get() then
            v66.tickcount.current_yaw = 0;
            v66.side.switch_yaw = not v66.side.switch_yaw;
        end;
        v66.tickcount.switch_jitter_pitch = v66.tickcount.switch_jitter_pitch + 1;
        if v66.tickcount.switch_jitter_pitch > 1 then
            v66.tickcount.switch_jitter_pitch = 0;
            v66.side.pitch = not v66.side.pitch;
        end;
    end, 
    update_offset_clock = function(v710, v711)
        -- upvalues: v65 (ref)
        local v712 = v710:get_delay_tick(v711, v65);
        local l_tickcount_1 = globals.tickcount;
        if v65.packet.last + v712 < l_tickcount_1 then
            if globals.choked_commands == 0 then
                v65.aa.switch_delay = not v65.aa.switch_delay;
                v65.packet.last = l_tickcount_1;
            end;
        elseif l_tickcount_1 < v65.packet.last then
            v65.packet.last = l_tickcount_1;
        end;
        return v65.aa.switch_delay;
    end, 
    read_config = function(_)
        -- upvalues: v675 (ref), v330 (ref)
        local v715 = v675.get_state();
        if v715 == nil or v715 == "" then
            v715 = "stand";
        end;
        local v716 = v330[v715];
        local v717 = v716.enable:get() and v716 or v330.global;
        return v717, {
            yaw = v717.yaw_mode:get(), 
            modifier = v717.modifier_mode:get(), 
            desync = v717.desync:get(), 
            defensive_mode = v717.defensive_mode:get()
        };
    end, 
    update_flick_tick = function(_, v719)
        -- upvalues: v65 (ref), v675 (ref)
        local v720 = v719.defensive_flick_tick_mode:get();
        local v721 = v719.defensive_flick_tick_min:get();
        local v722 = v719.defensive_flick_tick_max:get();
        if v720 == "Static" then
            return v719.defensive_mode_tick:get();
        elseif v720 == "Jitter" then
            return v65.packet.delay_times_2 and v721 or v722;
        elseif v720 == "Random" then
            return utils.random_int(math.min(v721, v722), math.max(v721, v722));
        elseif v720 == "Random Jitter" then
            return math.random(2) == 1 and v721 or v722;
        elseif v720 == "Random Trigger" then
            return globals.tickcount % math.random(15, 20) > 1 and v722 or v721;
        elseif v720 == "Random Static" then
            return v675.random_static_tick(v719);
        elseif v720 == "Cycle" then
            return (v675.cycle_delay_tick(v721, v722, v719.defensive_flick_cycle_speed:get()));
        elseif v720 == "Beta" then
            return v675.flick_beta();
        else
            return;
        end;
    end, 
    get_delay_tick = function(_, v724, v725)
        -- upvalues: v675 (ref)
        local v726 = v724.delay_mode:get();
        local v727 = v724.delay_min_tick:get();
        local v728 = v724.delay_max_tick:get();
        if v724.modifier_mode:get() == "Sanya" or v724.modifier_mode:get() == "Jitter" then
            if v726 == "Static" then
                return v724.delay_static_tick:get();
            elseif v726 == "Jitter" then
                return v725.packet.delay_times and v727 or v728;
            elseif v726 == "Random" then
                return utils.random_int(math.min(v727, v728), math.max(v727, v728));
            elseif v726 == "Random Jitter" then
                return math.random(2) == 1 and v727 or v728;
            elseif v726 == "Cycle" then
                return (v675.cycle_delay_tick(v727, v728, v724.delay_cycle_speed:get()));
            elseif v726 == "Fluctuate" then
                return globals.tickcount % 17 == 0 and v727 or v728;
            elseif v726 == "Random Trigger" then
                return globals.tickcount % math.random(15, 20) > 1 and v728 or v727;
            elseif v726 == "Custom" then
                v725.delay_ctrl.index = v725.delay_ctrl.index or 1;
                v725.delay_ctrl.last_tick = v725.delay_ctrl.last_tick or globals.tickcount;
                local v729 = v724.delay_sections:get();
                local v730 = v724.delay_custom_tick:get();
                local v731 = v724.delay_custom_random:get();
                if v730 <= globals.tickcount - v725.delay_ctrl.last_tick then
                    v725.delay_ctrl.last_tick = globals.tickcount;
                    if v731 then
                        local v732 = math.random(1, v729);
                        if v729 > 1 then
                            while v732 == v725.delay_ctrl.index do
                                v732 = math.random(1, v729);
                            end;
                        end;
                        v725.delay_ctrl.index = v732;
                    else
                        v725.delay_ctrl.index = v725.delay_ctrl.index % v729 + 1;
                    end;
                end;
                return (v724.delay_custom_tbl[v725.delay_ctrl.index]:get());
            else
                return;
            end;
        else
            return 1;
        end;
    end, 
    get_defensive_pitch = function(_, v734)
        -- upvalues: v66 (ref), v675 (ref), v71 (ref), v65 (ref)
        local v735 = v734.defensive_pitch_speed:get();
        local v736 = v734.defensive_pitch_jitter_speed:get();
        local v737 = v734.defensive_pitch_min:get();
        local v738 = v734.defensive_pitch_max:get();
        local v739 = v734.defensive_pitch_static:get();
        local v740 = v734.defensive_pitch:get();
        if v740 == "Disabled" then
            return 89;
        elseif v740 == "Static" then
            return v739;
        elseif v740 == "Jitter" then
            return v66.side.switch_pitch and v738 or v737;
        elseif v740 == "Random" then
            return utils.random_float(v737, v738);
        elseif v740 == "Spin" then
            v66.pitch.spin_value = v675.get_pitch_spin(v66.pitch.spin_value, v737, v738, v735);
            return math.min(math.max(v66.pitch.spin_value));
        elseif v740 == "Wraith" then
            return v71.clamp_value(v71.normalize_angle(v65.aa.pitch_value), v737, v738);
        elseif v740 == "Random Jitter" then
            return math.random(2) == 1 and v737 or v738;
        elseif v740 == "Cycle Spin" then
            return v675.get_pitch_cycle_spin(v737, v738, v736);
        elseif v740 == "Switch Random" then
            return v71.custom_random(v737, v738, v734.defensive_pitch_min_2:get(), v734.defensive_pitch_max_2:get(), v734.defensive_pitch_switch:get() / 10);
        elseif v740 == "Switch Jitter" then
            return v71.custom_jitter(v737, v738, v734.defensive_pitch_min_2:get(), v734.defensive_pitch_max_2:get(), v734.defensive_pitch_switch:get() / 10);
        elseif v740 == "Random Static" then
            return v675.random_static_pitch(v734);
        elseif v740 == "LC End" then
            return math.exploit() and v738 or v737;
        elseif v740 == "89-Random" then
            return 44 - utils.random_int(-89, 89);
        elseif v740 == "Wave" then
            local v741 = v734.defensive_pitch_wave_period:get() / 100;
            local v742 = v734.defensive_pitch_wave_type:get();
            local v743 = v734.defensive_pitch_wave_invert:get();
            local v744 = globals.realtime % v741 / v741;
            if v742 == "Triangle" then
                v744 = math.abs(v744 * 2 - 1);
            elseif v742 == "Sine" then
                v744 = (1 - math.cos(v744 * math.pi * 2)) * 0.5;
            elseif v742 == "Saw" then
                v744 = (1 - math.cos(v744 * math.pi * 2)) * 0.788;
            end;
            if v743 then
                v744 = 1 - v744;
            end;
            return v737 + (v738 - v737) * v744;
        else
            return;
        end;
    end, 
    get_defensive_yaw = function(_, v746, v747)
        -- upvalues: v66 (ref), v675 (ref), v71 (ref), v65 (ref)
        local v748 = v746.defensive_yaw_full:get();
        local v749 = v746.defensive_yaw_speed:get();
        local _ = v746.defensive_yaw_jitter_speed:get();
        local v751 = v746.defensive_yaw_min:get();
        local v752 = v746.defensive_yaw_max:get();
        local v753 = v746.defensive_yaw_static:get();
        local v754 = v746.defensive_yaw:get();
        if v754 == "Hidden" then
            return;
        elseif v754 == "Disabled" then
            return 0;
        elseif v754 == "Static" then
            return v753;
        elseif v754 == "Jitter" then
            return v66.side.switch_yaw and v752 or v751;
        elseif v754 == "Spin" then
            v66.yaw.spin_value = v675.get_yaw_spin(v66.yaw.spin_value, v751, v752, v749);
            return math.min(math.max(v66.yaw.spin_value));
        elseif v754 == "Wraith" then
            return v71.clamp_value(v71.normalize_angle(v65.aa.spin_value), v751, v752);
        elseif v754 == "Random" then
            return utils.random_int(v751, v752);
        elseif v754 == "Random Jitter" then
            return v675.random_jitter(v748);
        elseif v754 == "Spin Jitter" then
            return v675.spin_jitter(v746, v66.side.switch_yaw);
        elseif v754 == "Cycle Spin" then
            return v675.get_yaw_cycle_spin(v746);
        elseif v754 == "Switch Random" then
            return v71.custom_random(v751, v752, v746.defensive_yaw_min_2:get(), v746.defensive_yaw_max_2:get(), v746.defensive_yaw_switch:get() / 10);
        elseif v754 == "Flick" then
            local v755 = globals.tickcount % math.random(16, 20) > 1 and v752 or v751;
            return v747.sidemove == 450 and v755 or -v755;
        elseif v754 == "Switch Jitter" then
            return v71.custom_jitter_yaw(v751, v752, v746.defensive_yaw_min_2:get(), v746.defensive_yaw_max_2:get(), v746.defensive_yaw_switch:get() / 10, v746.defensive_yaw_flick:get());
        elseif v754 == "Adaptive" then
            return v675.adaptive_yaw(v746);
        elseif v754 == "Random Static" then
            return v675.random_static_yaw(v746);
        elseif v754 == "LC End" then
            return math.exploit() and v752 or v751;
        elseif v754 == "180-Random" then
            return 180 - utils.random_int(-90, 90);
        elseif v754 == "90 Random" then
            local v756 = v749 * 2;
            if globals.tickcount % v756 == v756 - 1 then
                v66.random.switch = not v66.random.switch;
            end;
            v66.random.value = v66.random.switch and math.random(90, 80) - math.random(v748, v748 / 2) or v66.random.value - math.random(90, 80) - math.random(-v748, -v748 / 2);
            return v66.random.value;
        elseif v754 == "Random Offset" then
            local v757 = v749 * 5;
            if globals.tickcount % v757 == v757 - 1 then
                v66.random.switch = not v66.random.switch;
            end;
            return v66.random.switch and -math.random(v748, -v748) or 359;
        elseif v754 == "Clock" then
            local v758 = v746.defensive_yaw_clock_step_size:get();
            local v759 = v746.defensive_yaw_clock_dir:get() == "Clockwise" and 1 or -1;
            local v760 = v746.defensive_yaw_clock_jitter:get();
            local v761 = v746.defensive_yaw_clock_base:get();
            local v762 = globals.realtime * (v749 * 80) * v759 % 360;
            if v758 >= 1 then
                v762 = math.floor(v762 / v758 + 0.5) * v758;
            end;
            if v760 > 0 then
                v762 = v762 + utils.random_float(-v760, v760);
            end;
            return (math.normalize_yaw(v761 + v762));
        else
            return;
        end;
    end, 
    update_body_angle = function(_, v764)
        -- upvalues: v319 (ref), v65 (ref)
        local v765 = v764.desync_anglemode:get();
        local v766 = 0;
        local v767 = 0;
        if v765 == "Ambani" then
            local v768 = utils.random_int(46, 60);
            v767 = utils.random_int(46, 60);
            v766 = v768;
        elseif v765 == "Random" then
            local v769 = utils.random_int(5, v764.desync_left:get());
            v767 = utils.random_int(9, v764.desync_right:get());
            v766 = v769;
        elseif v765 == "Dynamic" then
            local v770 = v319(0.35);
            local l_v770_0 = v770;
            v767 = v770;
            v766 = l_v770_0;
        elseif v765 == "Disabled" then
            local v772 = v764.desync_left:get();
            v767 = v764.desync_right:get();
            v766 = v772;
        elseif v765 == "Switch" then
            if v764.desync_switch_logic:get() == "Delay" then
                local v773 = v65.aa.switch_delay and 57 or 30;
                v767 = v65.aa.switch_delay and 57 or 30;
                v766 = v773;
            else
                local v774 = math.exploit() and 57 or 30;
                v767 = math.exploit() and 57 or 30;
                v766 = v774;
            end;
        end;
        local l_switch_delay_0 = v65.aa.switch_delay;
        if v764.delay_base:get() == "Limit" and (v764.desync:get() == "Jitter" or v764.desync:get() == "Tick") and (v764.modifier_mode:get() == "Jitter" or v764.modifier_mode:get() == "Sanya") then
            if l_switch_delay_0 then
                local v776 = math.abs(v766);
                v767 = -math.abs(v767);
                v766 = v776;
            else
                local v777 = -math.abs(v766);
                v767 = math.abs(v767);
                v766 = v777;
            end;
        end;
        return v766, v767;
    end, 
    update_body = function(v778, v779)
        -- upvalues: v65 (ref)
        local v780 = v779.desync:get();
        local v781 = v779.desync_anti_bru:get();
        local v782 = "";
        local v783 = false;
        local v784 = false;
        if v780 == "Disabled" then
            v783 = false;
            v784 = false;
        else
            v782 = v781 and "Avoid Overlap" or "";
            v784 = true;
            if v780 == "Static" then
                v783 = v779.desync_invert:get();
            end;
            if v780 == "Jitter" then
                v783 = v778:period_jitter(v779);
                if v779.delay_base:get() == "Neverlose" then
                    v782 = "Jitter";
                    rage.antiaim:inverter(v65.aa.switch_delay and true or false);
                else
                    v782 = "";
                end;
            end;
        end;
        return v782, v783, v784;
    end, 
    safehead = function(_)
        -- upvalues: v675 (ref), l_link_0 (ref), v71 (ref)
        local v786 = nil;
        local v787 = entity.get_local_player();
        if not v787 or not v787:is_alive() then
            return;
        elseif v787:get_player_weapon() == nil then
            return;
        else
            local v788 = entity.get_threat();
            if v788 == nil then
                v786 = false;
            else
                local v789 = v787:get_origin() - v788:get_origin();
                local v790 = v675.get_state();
                local v791 = l_link_0.set.safehead:get() and l_link_0.safe_head.above:get("Above Enemy");
                local v792 = v71.to_foot(v789:length());
                if v789.z > 80 and v790 ~= "slow" and v790 ~= "moving" and v790 ~= "ctcrouch" and v790 ~= "tcrouch" and v790 ~= "sneak" and v791 and v792 < 55 then
                    v786 = true;
                else
                    v786 = false;
                end;
            end;
            return v786;
        end;
    end, 
    compute_tank = function(v793, _, v795, v796)
        -- upvalues: v15 (ref), v65 (ref), v71 (ref)
        v15.aa.pitch:override(v795.pitch:get());
        if globals.choked_commands == 0 then
            v65.aa.side_l_r = v65.aa.side_l_r == 1 and 0 or 1;
            v65.aa.sanya = v65.aa.sanya + 1;
            v65.torpedo.counter = v65.torpedo.counter + 1;
            v65.torpedo.side_delay = v65.torpedo.side_delay + 1;
            if v65.torpedo.side_delay >= math.random(1, 9) then
                v65.torpedo.side_delay = 0;
                v65.torpedo.side = v65.torpedo.side == 1 and 0 or 1;
            end;
        end;
        local l_m_flNextAttack_0 = entity.get_local_player().m_flNextAttack;
        local v798 = entity.get_local_player():get_player_weapon();
        if v798 == nil then
            return;
        else
            local l_m_flNextPrimaryAttack_0 = v798.m_flNextPrimaryAttack;
            local v802 = ({
                Choke = function()
                    -- upvalues: v71 (ref), v795 (ref)
                    return v71.choke_yaw(v795.yaw_left:get(), v795.yaw_right:get());
                end, 
                Jitter = function()
                    -- upvalues: v65 (ref), v795 (ref), v793 (ref)
                    local v800 = v65.aa.switch_delay and v795.yaw_left:get() or v795.yaw_right:get();
                    local v801 = v793:get_pair_add(v795);
                    if v801 == nil then
                        v801 = 0;
                    end;
                    return (math.clamp(v800 + v801, -180, 180));
                end
            })[v796.yaw]();
            local v818 = {
                Disabled = function()
                    return "Disabled", 0, 0;
                end, 
                ["Sway Jitter"] = function()
                    -- upvalues: v795 (ref)
                    return "Center", globals.tickcount % v795.modifier_sway_speed:get() >= 2 and v795.modifier_mode_offset:get() or -v795.modifier_mode_offset:get(), 0;
                end, 
                Sanya = function()
                    -- upvalues: v795 (ref), v65 (ref)
                    local v803 = v795.modifier_sanya_switcher:get();
                    local v804 = v795.modifier_sanya_speed:get();
                    local v805;
                    if v803 then
                        v805 = v65.aa.sanya % v804 == 0 and "Random" or "3-way";
                    else
                        v805 = v65.aa.sanya % v804 == 0 and "5-way" or "Random";
                    end;
                    return v805, v795.modifier_mode_offset:get() / 2, v65.aa.switch_delay and v795.modifier_mode_offset:get() / 2 or -v795.modifier_mode_offset:get() / 2 + 1;
                end, 
                Jitter = function()
                    -- upvalues: v65 (ref), v795 (ref)
                    return "Disabled", 0, v65.aa.switch_delay and v795.modifier_mode_offset:get() / 2 or -v795.modifier_mode_offset:get() / 2;
                end, 
                Torpedo = function()
                    -- upvalues: v795 (ref), v15 (ref), l_m_flNextPrimaryAttack_0 (ref), l_m_flNextAttack_0 (ref), v65 (ref)
                    local v806 = v795.yaw_left:get();
                    local v807 = v795.yaw_right:get();
                    local v808 = v795.modifier_torpedo_random:get();
                    local v809 = v795.modifier_torpedo_speed_1:get();
                    local v810 = v795.modifier_torpedo_speed_2:get();
                    local v811 = v795.modifier_torpedo_lagcomp:get();
                    local v812 = "Disabled";
                    local v813 = 0;
                    local _ = 0;
                    local v815 = math.random(-4, 3);
                    if v808 then
                        v809 = math.random(v809, v810);
                    end;
                    local v816 = v15.rage.dt:get() and math.max(l_m_flNextPrimaryAttack_0, l_m_flNextAttack_0) <= globals.curtime or v15.rage.hs:get();
                    if v65.torpedo.counter % v809 == 0 or v811 and not v816 then
                        rage.exploit:allow_defensive(true);
                        v813 = v815;
                        v65.torpedo.switch = false;
                    else
                        if v65.torpedo.counter % (v809 - math.random(-1, 1)) == 0 then
                            v65.torpedo.switch = not v65.torpedo.switch;
                        end;
                        local v817 = v65.torpedo.switch and v807 or v806;
                        v813 = v65.torpedo.side and v817 - v815 or v817;
                    end;
                    return v812, 0, v813;
                end
            };
            if v793:safehead() then
                v15.aa.yaw_offset:override(0);
                v15.aa.yaw_jitter:override("Disabled");
                v15.aa.yj_offset:override(0);
                v15.aa.body_yaw:override(true);
                v15.aa.by_option:override("");
                v15.aa.by_invert:override(false);
                v15.aa.by_l:override(0);
                v15.aa.by_r:override(0);
            else
                local v819 = 0;
                local v820 = v818[v796.modifier];
                if v820 then
                    local v821, v822, v823 = v820(v793, v795);
                    if v821 then
                        v15.aa.yaw_jitter:override(v821);
                    end;
                    if v822 then
                        v15.aa.yj_offset:override(v822);
                    end;
                    v819 = v823 or 0;
                end;
                local v824 = v795.yaw_target:get();
                local v825 = math.clamp(v824 + v802 + v819, -180, 180);
                local v826, v827 = v793:update_body_angle(v795);
                if v795.modifier_random:get() and v796.modifier ~= "Disabled" then
                    local v828 = 0;
                    if v795.modifier_random_mode:get() == "Default" then
                        local v829 = v795.modifier_random_default:get();
                        v828 = utils.random_int(-v829, v829);
                    elseif v795.modifier_random_mode:get() == "Min-Max" then
                        local v830 = v795.modifier_random_min:get();
                        local v831 = v795.modifier_random_max:get();
                        v828 = utils.random_int(v830, v831);
                    end;
                    v825 = math.clamp(v825 + v828, -180, 180);
                end;
                v15.aa.yaw_offset:override(v825);
                local v832, v833, v834 = v793:update_body(v795);
                v15.aa.body_yaw:override(v834);
                v15.aa.by_option:override(v832);
                if v796.modifier ~= "Torpedo" then
                    v15.aa.by_invert:override(v833);
                else
                    v15.aa.by_invert:override(v65.torpedo.switch);
                end;
                v15.aa.by_l:override(v826);
                v15.aa.by_r:override(v827);
                if v795.desync_switch_fs:get() then
                    v15.aa.by_fs:override(v65.aa.side_l_r == 1 and "Peek Real" or "Peek Fake");
                else
                    v15.aa.by_fs:override(nil);
                end;
            end;
            return;
        end;
    end, 
    hide_head_disable = function(_, v836)
        -- upvalues: l_link_0 (ref)
        if not v836.defensive:get() then
            return false, false, false;
        else
            local v837 = l_link_0.set.freestand:get() and l_link_0.set_sub.fs_op:get("Disable Defensive");
            local v838 = l_link_0.set.manual:get() ~= "Disabled" and l_link_0.set_sub.manual_op:get("Disable Defensive");
            local v839 = v836.defensive_onpeek:get();
            local v840 = entity.get_threat(true);
            return v837, v838, v839 and not v840;
        end;
    end, 
    flick_advance = function(_, _, v843)
        -- upvalues: v66 (ref)
        local v844 = 2 + (v843 - 1) * 2;
        v66.flick.idx = v66.flick.idx % v844 + 1;
        return not (v66.flick.idx > 2);
    end, 
    flick_ambani = function(_, v846)
        -- upvalues: v65 (ref)
        if globals.choked_commands == 0 then
            v65.flick.counter = v65.flick.counter + 1;
        end;
        if globals.choked_commands == 0 and v65.flick.counter % 2 == 0 then
            v65.flick.exploit = not v65.flick.exploit;
        end;
        if v65.flick.counter % v846 == 0 then
            return true;
        else
            return false;
        end;
    end, 
    force_defensive = function(v847, v848, v849, v850)
        -- upvalues: v66 (ref), v15 (ref), v65 (ref)
        local v851 = entity.get_local_player():get_player_weapon();
        if not v851 then
            return;
        elseif v851:get_name() == "R8 Revolver" then
            return;
        else
            local v863 = {
                Neverlose = function()
                    return false, true;
                end, 
                Flick = function()
                    -- upvalues: v847 (ref), v848 (ref), v849 (ref)
                    local v852 = v847:update_flick_tick(v848);
                    local v853 = false;
                    if v848.defensive_flick_trigger:get() == "Simple" then
                        v853 = v849.command_number % v852 == 0;
                    else
                        v853 = v847:flick_advance(v848, v852);
                    end;
                    return v853, true;
                end, 
                Custom = function()
                    -- upvalues: v848 (ref), v66 (ref)
                    local v854 = v848.defensive_mode_min:get();
                    local v855 = v848.defensive_mode_max:get();
                    local v856 = v848.defensive_mode_check:get();
                    local v857 = nil;
                    if v856 == "Tickbase" then
                        v857 = v66.tick.left;
                    elseif v856 == "Command Num" then
                        v857 = v66.cmd_tick.left;
                    end;
                    if not v857 then
                        return false, true;
                    else
                        local v858 = v854 <= v857 and v857 <= v855;
                        return not v858, v858;
                    end;
                end, 
                Limit = function()
                    -- upvalues: v848 (ref), v66 (ref)
                    local v859 = v848.defensive_mode_min:get();
                    local v860 = v848.defensive_mode_max:get();
                    local v861 = v848.defensive_mode_check:get();
                    local v862 = nil;
                    if v861 == "Tickbase" then
                        v862 = v66.tick.left;
                    elseif v861 == "Command Num" then
                        v862 = v66.cmd_tick.left;
                    end;
                    if not v862 then
                        return false, true;
                    else
                        return false, v859 <= v862 and v862 <= v860;
                    end;
                end
            };
            if not v848.defensive:get() then
                v15.rage.dt_lag:override("Disabled");
                v15.rage.hs_op:override("Favor Fire Rate");
                v849.force_defensive = false;
                v15.aa.hidden:override(false);
                return;
            else
                local v864, v865, v866 = v847:hide_head_disable(v848);
                local v867 = v847:safehead();
                v15.rage.dt_lag:override("Always On");
                v15.rage.hs_op:override("Break LC");
                if v864 or v865 then
                    v849.force_defensive = false;
                    v15.aa.hidden:override(false);
                    return;
                elseif v866 then
                    v849.force_defensive = false;
                    v15.aa.hidden:override(false);
                    v15.rage.dt_lag:override("On Peek");
                    v15.rage.hs_op:override("Favor Fire Rate");
                    return;
                elseif v867 then
                    v849.force_defensive = false;
                    v15.aa.hidden:override(false);
                    return;
                else
                    if v848.defensive_use_mode:get() == "Normal" then
                        local v868 = v863[v850.defensive_mode];
                        if v868 then
                            local v869, v870 = v868(v848);
                            v849.force_defensive = v869;
                            if v850.defensive_mode ~= "Neverlose" then
                                v849.send_packet = v849.command_number % v848.defensive_flick_packets:get() == 0;
                            end;
                            if v850.defensive_mode ~= "Neverlose" then
                                if v848.defensive_flick_desync_release:get() then
                                    local v871 = v848.defensive_flick_desync_mode:get();
                                    if v850.defensive_mode ~= "Flick" then
                                        if v871 == "Follow" then
                                            v15.aa.body_yaw:override(v870);
                                        else
                                            v15.aa.body_yaw:override(not v870);
                                        end;
                                    elseif v871 == "Follow" then
                                        v15.aa.body_yaw:override(not v869);
                                    else
                                        v15.aa.body_yaw:override(v869);
                                    end;
                                end;
                                if v848.defensive_flick_hidden:get() then
                                    if v850.defensive_mode ~= "Flick" then
                                        v15.aa.hidden:override(true);
                                    else
                                        v15.aa.hidden:override(not v869);
                                    end;
                                else
                                    v15.aa.hidden:override(v870);
                                end;
                            else
                                v15.aa.hidden:override(v870);
                            end;
                            if v850.defensive_mode ~= "Neverlose" and v848.defensive_flick_limit:get() then
                                if math.exploit() then
                                    if v850.defensive_mode == "Flick" then
                                        v15.aa.by_invert:override(false);
                                    else
                                        v15.aa.by_invert:override(true);
                                    end;
                                elseif v850.defensive_mode == "Flick" then
                                    v15.aa.by_invert:override(true);
                                else
                                    v15.aa.by_invert:override(false);
                                end;
                            end;
                            v847:defensive_yaw_pitch(v848, v849);
                        end;
                    else
                        local v872 = v848.defensive_manual_flick_offset_1:get();
                        local v873 = v848.defensive_manual_flick_offset_2:get();
                        local v874 = v848.defensive_manual_flick_pitch:get();
                        local v875 = v848.defensive_manual_flick_speed:get();
                        local v876 = v848.defensive_manual_flick_mode:get();
                        local v877 = v848.defensive_manual_flick_spin_speed:get();
                        local v878, v879 = v847:update_body_angle(v848);
                        local v880 = v847:flick_ambani(v875);
                        v849.force_defensive = v880;
                        if v880 then
                            v15.rage.dt_lag:override("always on");
                            v15.aa.hidden:override(true);
                            v15.aa.yaw_offset:override(0);
                            v15.aa.yaw_jitter:override("disabled");
                            v15.aa.yj_offset:override(0);
                            v15.aa.by_l:override(59);
                            v15.aa.by_r:override(59);
                            v15.aa.by_invert:override(false);
                            v15.aa.pitch:override("down");
                        else
                            v15.rage.dt_lag:override("always on");
                            v15.aa.hidden:override(false);
                            if v876 == "Jitter" then
                                v15.aa.yaw_offset:override(v65.flick.exploit and v872 or v873);
                                v15.aa.by_invert:override(v65.flick.exploit);
                            elseif v876 == "Spin" then
                                local v881 = globals.tickcount * 2 ^ v877 % 360;
                                if v881 > 170 and v881 < 190 then
                                    v881 = 200;
                                end;
                                v15.aa.yaw_offset:override(v881);
                                v15.aa.by_invert:override(false);
                            elseif v876 == "Sway" then
                                v15.aa.yaw_offset:override(30 + globals.tickcount * 4 % v872);
                            else
                                v15.aa.yaw_offset:override(v872);
                                v15.aa.by_invert:override(false);
                            end;
                            v15.aa.pitch:override(v874);
                            v15.aa.yaw_jitter:override("disabled");
                            v15.aa.yj_offset:override(0);
                            v15.aa.by_l:override(v878);
                            v15.aa.by_r:override(v879);
                        end;
                    end;
                    return;
                end;
            end;
        end;
    end, 
    defensive_yaw_pitch = function(v882, v883, v884)
        local v885 = v882:get_defensive_pitch(v883);
        local v886 = v882:get_defensive_yaw(v883, v884);
        rage.antiaim:override_hidden_pitch(v885);
        if v886 == nil then
            return;
        else
            rage.antiaim:override_hidden_yaw_offset(v886);
            return;
        end;
    end, 
    manual_antiaim = function(v887, _)
        -- upvalues: l_link_0 (ref), v15 (ref), v68 (ref), v65 (ref), v688 (ref)
        local v889 = l_link_0.set.freestand:get();
        local v890 = l_link_0.set.freestand:get() and l_link_0.set_sub.fs_op:get("Force Static");
        if v889 and v887.yaw_dir == "Disabled" then
            v15.aa.fs:override(true);
        else
            v15.aa.fs:override(false);
        end;
        local v891 = l_link_0.set.manual:get();
        local v892 = v891 ~= "Disabled" and l_link_0.set_sub.manual_op:get("Force Static");
        local v893 = l_link_0.set_sub.manual_op:get("Local View");
        v887.yaw_dir = v891;
        v68.yaw_dir = v891;
        v65.aa.manual_enable = v891 ~= "Disabled";
        if v893 then
            v15.aa.yaw_base:override("Local View");
        end;
        if v890 or v892 then
            v688();
        end;
        if v891 == "Disabled" then
            return;
        else
            if v891 == "Left" then
                v15.aa.yaw_offset:override(-90);
            elseif v891 == "Right" then
                v15.aa.yaw_offset:override(90);
            elseif v891 == "Forward" then
                v15.aa.yaw_offset:override(-180);
            end;
            return;
        end;
    end, 
    main = function(v894, v895)
        -- upvalues: v65 (ref), v675 (ref)
        if not v894:prepare() then
            return;
        else
            local v896, v897 = v894:read_config();
            v894:update_switch(v896, v65);
            v894:update_offset_clock(v896);
            v894:compute_tank(v895, v896, v897);
            v894:manual_antiaim(v895);
            v675.global_set();
            v894:force_defensive(v896, v895, v897);
            return;
        end;
    end, 
    end_tick = function(_, v899)
        -- upvalues: v65 (ref)
        v65.aa.pitch_value = v65.aa.pitch_value + v899.defensive_pitch_speed:get();
        if v65.aa.pitch_value >= 1080 then
            v65.aa.pitch_value = 0;
        end;
        v65.aa.spin_value = v65.aa.spin_value + v899.defensive_yaw_speed:get();
        if v65.aa.spin_value >= 1080 then
            v65.aa.spin_value = 0;
        end;
    end, 
    end_tick_run = function(v900)
        if not v900:prepare() then
            return;
        else
            local v901, _ = v900:read_config();
            v900:end_tick(v901);
            return;
        end;
    end, 
    on_net_update_end = function(v903)
        v903:end_tick_run();
    end, 
    on_createmove = function(v904, v905)
        v904:main(v905);
    end
};
v64[#v64 + 1] = v906;
local v907 = {
    weapon_glock = true, 
    weapon_negev = true, 
    weapon_xm1014 = true, 
    weapon_tec9 = true, 
    weapon_p250 = true, 
    weapon_mp7 = true, 
    weapon_ak47 = true, 
    weapon_galilar = true, 
    weapon_elite = true, 
    weapon_sawedoff = true, 
    weapon_deagle = true, 
    weapon_m249 = true, 
    weapon_ump45 = true, 
    weapon_p90 = true, 
    weapon_bizon = true, 
    weapon_mac10 = true, 
    weapon_nova = true, 
    weapon_sg556 = true
};
local v952 = {
    prepare = function(_)
        -- upvalues: l_link_0 (ref)
        if not l_link_0.general.master:get() then
            return;
        else
            local v909 = entity.get_local_player();
            if not v909 then
                return;
            elseif not v909:is_alive() then
                return;
            else
                local v910 = v909:get_player_weapon();
                if not v910 then
                    return;
                else
                    return v909, v910, v910:get_weapon_info().weapon_name or "nil";
                end;
            end;
        end;
    end, 
    autohs = function(_, _, _, v914)
        -- upvalues: v15 (ref), l_link_0 (ref), v675 (ref)
        if v914 ~= "weapon_ssg08" or v15.rage.fd:get() then
            v15.rage.hs:override(nil);
            v15.rage.dt:override(nil);
            return;
        else
            if l_link_0.set.autohs:get() then
                if v15.rage.dt:get() then
                    if v15.rage.peek:get() then
                        v15.rage.hs:override(nil);
                        v15.rage.dt:override(nil);
                        return nil;
                    else
                        state = v675.get_state();
                        if state == "ctcrouch" or state == "tcrouch" or state == "sneak" or state == "slow" or state == "stand" then
                            v15.rage.hs:override(true);
                            v15.rage.dt:override(false);
                        else
                            v15.rage.hs:override(nil);
                            v15.rage.dt:override(nil);
                        end;
                    end;
                else
                    v15.rage.hs:override(nil);
                    v15.rage.dt:override(nil);
                end;
            else
                v15.rage.hs:override(nil);
                v15.rage.dt:override(nil);
            end;
            return;
        end;
    end, 
    unlock_fd_speed = function(_, v916, v917)
        -- upvalues: v15 (ref), l_link_0 (ref)
        if not v15.rage.fd:get() then
            return;
        elseif not l_link_0.set.fdspeed:get() then
            return;
        elseif not v917 or not v917:is_alive() then
            return;
        else
            local l_m_vecVelocity_1 = v917.m_vecVelocity;
            if math.abs(l_m_vecVelocity_1.x) > 10 or math.abs(l_m_vecVelocity_1.y) > 10 then
                local v919 = vector(v916.forwardmove, v916.sidemove);
                if v919:length() > 0 then
                    v919:normalize();
                    v916.forwardmove = v919.x * 150;
                    v916.sidemove = v919.y * 150;
                end;
            end;
            return;
        end;
    end, 
    fast_ladder = function(_, v921, v922)
        -- upvalues: l_link_0 (ref)
        if not l_link_0.set.fastladder:get() then
            return;
        else
            if v922.m_MoveType == 9 then
                v921.view_angles.y = math.floor(v921.view_angles.y + 0.5);
                if v921.forwardmove > 0 then
                    if v921.view_angles.x < 45 then
                        v921.view_angles.x = 89;
                        v921.in_moveright = 1;
                        v921.in_moveleft = 0;
                        v921.in_forward = 0;
                        v921.in_back = 1;
                        if v921.sidemove == 0 then
                            v921.view_angles.y = v921.view_angles.y + 90;
                        end;
                        if v921.sidemove < 0 then
                            v921.view_angles.y = v921.view_angles.y + 150;
                        end;
                        if v921.sidemove > 0 then
                            v921.view_angles.y = v921.view_angles.y + 30;
                        end;
                    end;
                elseif v921.forwardmove < 0 then
                    v921.view_angles.x = 89;
                    v921.in_moveleft = 1;
                    v921.in_moveright = 0;
                    v921.in_forward = 1;
                    v921.in_back = 0;
                    if v921.sidemove == 0 then
                        v921.view_angles.y = v921.view_angles.y + 90;
                    end;
                    if v921.sidemove > 0 then
                        v921.view_angles.y = v921.view_angles.y + 150;
                    end;
                    if v921.sidemove < 0 then
                        v921.view_angles.y = v921.view_angles.y + 30;
                    end;
                end;
            end;
            return;
        end;
    end, 
    airlag = function(_)
        -- upvalues: v675 (ref), l_link_0 (ref)
        local v924 = v675.get_state();
        local v925 = l_link_0.set_sub.airlag_op:get();
        local v926 = l_link_0.set_sub.airlag_tick:get();
        if l_link_0.set.airlag:get() and (v924 == "air" or v924 == "airduck" or v924 == "airtaser" or v924 == "airknife") then
            if v925 then
                if entity.get_threat(true) then
                    if globals.tickcount % v926 == 0 then
                        rage.exploit:force_teleport();
                    else
                        rage.exploit:force_charge();
                    end;
                end;
            elseif globals.tickcount % v926 == 0 then
                rage.exploit:force_teleport();
            else
                rage.exploit:force_charge();
            end;
        end;
    end, 
    dt_charge = function(_, v928)
        -- upvalues: l_link_0 (ref), v15 (ref)
        if not v928 then
            return;
        else
            if l_link_0.set.recharge:get() and entity.get_threat(true) then
                local v929 = v928.m_nTickBase - globals.tickcount;
                local v930 = v15.rage.dt:get() and not v15.rage.fd:get();
                local l_m_hActiveWeapon_0 = v928.m_hActiveWeapon;
                if l_m_hActiveWeapon_0 == nil then
                    return;
                else
                    local l_weapon_name_1 = l_m_hActiveWeapon_0:get_weapon_info().weapon_name;
                    if l_weapon_name_1 == nil or l_weapon_name_1 == "weapon_knife" then
                        return;
                    else
                        local l_m_fLastShotTime_0 = l_m_hActiveWeapon_0.m_fLastShotTime;
                        if l_m_fLastShotTime_0 == nil then
                            return;
                        else
                            local v934 = globals.curtime - l_m_fLastShotTime_0 <= 0.5;
                            if v929 > 0 and v930 then
                                if not v934 then
                                    rage.exploit:force_charge();
                                end;
                            else
                                v15.rage.enable:override(true);
                            end;
                        end;
                    end;
                end;
            end;
            return;
        end;
    end, 
    slow_speed = function(_, v936)
        -- upvalues: l_link_0 (ref)
        local v937 = vector(v936.forwardmove, 0, v936.sidemove);
        v937:normalize();
        v937 = v937:scale(l_link_0.set_sub.slowspeed_op:get());
        if l_link_0.set.slowspeed:get() then
            v936.forwardmove = v937.x;
            v936.sidemove = v937.z;
        end;
    end, 
    perfomance_boost = function(_)
        -- upvalues: l_config_sub_0 (ref)
        if l_config_sub_0.misc.useless:get() then
            cvar.cl_disable_ragdolls:int(1, true);
            cvar.dsp_slow_cpu:int(1, true);
            cvar.r_drawparticles:int(1, true);
            cvar.func_break_max_pieces:int(0, true);
            cvar.mat_queue_mode:int(2, true);
            cvar.muzzleflash_light:int(0, true);
            cvar.mat_hdr_enabled:int(0, true);
            cvar.r_eyemove:int(0, true);
            cvar.r_eyegloss:int(0, true);
            cvar.fps_max:int(0, true);
        end;
    end, 
    auto_backtrack = function(_, v940)
        -- upvalues: l_config_sub_0 (ref), v15 (ref), v907 (ref)
        if not l_config_sub_0.rage.backtrack:get() then
            v15.rage.backtrack:override();
            return;
        else
            if v907[v940] then
                v15.rage.backtrack:override(false);
            else
                v15.rage.backtrack:override();
            end;
            return;
        end;
    end, 
    on_render = function(v941)
        v941:perfomance_boost();
    end, 
    on_createmove = function(v942, v943)
        local v944, v945, v946 = v942:prepare();
        v942:autohs(v944, v945, v946);
        v942:fast_ladder(v943, v944);
        v942:airlag();
        v942:dt_charge(v944);
        v942:slow_speed(v943);
        v942:auto_backtrack(v946);
    end, 
    on_createmove_run = function(v947, v948)
        local v949, _, _ = v947:prepare();
        v947:unlock_fd_speed(v948, v949);
    end
};
l_link_0.set.aimtick:set_callback(function(v953)
    cvar.sv_maxusrcmdprocessticks_holdaim:int(v953:get() and 0 or 1);
end);
l_config_sub_0.misc.chat:set_callback(function(v954)
    cvar.cl_chatfilters:int(v954:get() and 0 or 1);
end);
v64[#v64 + 1] = v952;
local v959 = {
    aspect_ratio = function(_)
        -- upvalues: l_config_sub_0 (ref)
        local v956 = l_config_sub_0.visual.aspect:get();
        if v956 == 0 then
            cvar.r_aspectratio:float(0);
            return;
        else
            local v957 = v956 / 100;
            cvar.r_aspectratio:float(v957);
            return;
        end;
    end, 
    on_render = function(v958)
        v958:aspect_ratio();
    end
};
v64[#v64 + 1] = v959;
local v960 = 0.3;
local v961 = 12;
local function v963(v962)
    return math.floor(v962 / globals.tickinterval + 0.5);
end;
local function v966(v964, v965)
    return (string.rep(" ", 15) .. v964 .. string.rep(" ", 30)):sub(v965 + 1, v965 + 16);
end;
local function v972(v967)
    -- upvalues: v961 (ref), v963 (ref), v960 (ref), v966 (ref)
    local v968 = utils.net_channel();
    if not v968 then
        return "";
    else
        local v969 = 15 + #v967 + v961;
        local v970 = globals.tickcount + v963(v968.latency[0] + 0.321);
        local v971 = math.floor(v970 / v963(v960) % v969);
        if 15 + #v967 < v971 then
            v971 = 15 + #v967;
        end;
        return v966(v967, v971);
    end;
end;
local v981 = {
    last = "", 
    set = function(v973, v974)
        if v974 ~= v973.last then
            common.set_clan_tag(v974);
            v973.last = v974;
        end;
    end, 
    on_render = function(v975)
        -- upvalues: l_config_sub_0 (ref), v972 (ref)
        if not l_config_sub_0.misc.clantag:get() then
            return;
        elseif not entity.get_local_player() then
            return;
        else
            local v976 = common.get_username();
            local v977 = "Trashhode-Recode";
            local _ = nil;
            if v976 == "entropy-tech" then
                v977 = "Trashhode-Coder";
            elseif v976 == "L0u14" then
                v977 = "Trashhode-OWNER";
            end;
            local v979 = v972(v977);
            local v980 = entity.get_game_rules();
            if v980 and (v980.m_gamePhase == 5 or v980.m_timeUntilNextPhaseStarts ~= 0) then
                v979 = v977;
            end;
            v975:set(v979);
            return;
        end;
    end
};
l_config_sub_0.misc.clantag:set_callback(function(v982)
    if not v982:get() then
        common.set_clan_tag("\000");
    end;
end);
events.pre_render:set(function()
    -- upvalues: v981 (ref)
    v981:on_render();
end);
local v1007 = {
    before_hp = 0, 
    draw_screen = function(v983)
        -- upvalues: l_config_sub_0 (ref), l_shot_0 (ref), l_fakelag_0 (ref), v323 (ref), l_main_0 (ref), l_selectab_0 (ref), v493 (ref)
        if not (l_config_sub_0.visual_logger_sub.position:get("Screen") and l_config_sub_0.visual.logger:get()) then
            l_shot_0 = {};
            l_fakelag_0 = {};
            return;
        else
            local v984 = l_config_sub_0.visual_logger_sub.style:get();
            if v983.state == "correction" then
                v983.state = "resolver";
            end;
            local v985 = l_config_sub_0.visual_logger_color.color_3:get("Hit")[1];
            local v986 = l_config_sub_0.visual_logger_color.color_3:get("Miss")[1];
            local v987 = l_config_sub_0.visual_logger_color.color_2:get("Hit")[1];
            local v988 = l_config_sub_0.visual_logger_color.color_2:get("Miss")[1];
            if v984 == "Old" then
                if v983.state == nil then
                    table.insert(l_shot_0, {
                        alpha = 0, 
                        text = ("  " .. v323.get("crosshairs-simple") .. "   \a96C83CFFHit \aDEFAULT %s in the \a96C83CFF %s \aDEFAULT for \a96C83CFF%d\aDEFAULT  "):format(v983.target:get_name(), v983.hitbox, v983.damage), 
                        time = globals.realtime, 
                        glow = v987
                    });
                else
                    table.insert(l_shot_0, {
                        alpha = 0, 
                        text = ("  \aFF5959FF" .. v323.get("circle-xmark") .. "   Missed \aDEFAULT shot at %s's \aFF5959FF%s\aDEFAULT due to \aFF5959FF%s\aDEFAULT  (hc: \aFF5959FF%.f\aDEFAULT)  "):format(v983.target:get_name(), v983.wanted_hitbox, v983.state, v983.hitchance), 
                        time = globals.realtime, 
                        glow = v988
                    });
                end;
            elseif v984 == "Skeet" then
                if v983.state == nil then
                    local v989 = string.format(" \a96C83CFFHit \aDEFAULT%s's \a96C83CFF%s\aDEFAULT for \a96C83CFF%d\aDEFAULT hp hc: %s (aim: %s wanted dmg: %s bt: \a96C83CFF%s\aDEFAULT)", v983.target:get_name(), v983.hitbox, v983.damage, v983.hitchance, v983.wanted_hitbox, v983.wanted_damage, v983.wanted_backtrack);
                    l_main_0:paint(3, v989);
                else
                    local v990 = string.format("\aFF5959FFMissed\aDEFAULT %s's %s due to \aFF5959FF%s\aDEFAULT hc:\aFF5959FF %s\aDEFAULT (wanted dmg: %s bt: %s)", v983.target:get_name(), v983.wanted_hitbox, v983.state, v983.hitchance, v983.wanted_damage, v983.wanted_backtrack);
                    l_main_0:paint(3, v990);
                end;
            elseif v984 == "Glow Text" then
                if v983.state == nil then
                    table.insert(l_fakelag_0, {
                        alpha = 0, 
                        text = (v323.get("crosshairs-simple") .. "  \a96C83CFFHit \aDEFAULT %s in the \a96C83CFF %s \aDEFAULT for \a96C83CFF%d\aDEFAULT "):format(v983.target:get_name(), v983.hitbox, v983.damage), 
                        glow = v985, 
                        time = globals.realtime
                    });
                else
                    table.insert(l_fakelag_0, {
                        alpha = 0, 
                        text = ("\aFF5959FF" .. v323.get("circle-xmark") .. "   Missed \aDEFAULT shot at %s's \aFF5959FF%s\aDEFAULT due to \aFF5959FF%s\aDEFAULT  (hc: \aFF5959FF%.f\aDEFAULT)"):format(v983.target:get_name(), v983.wanted_hitbox, v983.state, v983.hitchance), 
                        glow = v986, 
                        time = globals.realtime
                    });
                end;
            elseif v984 == "Cycle" then
                if v983.state == nil then
                    local v991 = "(" .. (v983.before_hp <= 0 and "dead" or v983.before_hp .. " remaining") .. ")";
                    local v992 = string.format("Hit %s's %s for %s dmg [hp: %s hc: %s bt: %s]", v983.target:get_name(), v983.hitbox, v983.damage, v991, v983.hitchance, v983.wanted_backtrack);
                    l_selectab_0:paint(5, v992, true, "%s%s%s%s%s%s%s%s%s%s%s%s", 11, {
                        [0] = "Hit ", 
                        [1] = nil, 
                        [2] = nil, 
                        [3] = " for ", 
                        [4] = nil, 
                        [5] = " dmg [hp: ", 
                        [6] = nil, 
                        [7] = " hc: ", 
                        [8] = nil, 
                        [9] = " bt: ", 
                        [10] = nil, 
                        [11] = "]", 
                        [1] = v983.target:get_name() .. "'s ", 
                        [2] = v983.hitbox, 
                        [4] = v983.damage, 
                        [6] = v991, 
                        [8] = v983.hitchance, 
                        [10] = tostring(v983.wanted_backtrack)
                    }, {
                        [0] = "96C83C", 
                        [1] = "ffffff", 
                        [2] = "96C83C", 
                        [3] = "ffffff", 
                        [4] = "96C83C", 
                        [5] = "ffffff", 
                        [6] = "ffffff", 
                        [7] = "ffffff", 
                        [8] = "FFF295", 
                        [9] = "ffffff", 
                        [10] = "ffffff", 
                        [11] = "ffffff"
                    });
                else
                    local v993 = string.format("Missed %s's %s due to %s [dmg: %s hc: %s bt: %s]", v983.target:get_name(), v983.wanted_hitbox, v983.state, v983.wanted_damage, v983.hitchance, v983.wanted_backtrack);
                    l_selectab_0:paint(5, v993, true, "%s %s %s %s%s%s%s%s%s%s%s%s", 11, {
                        [1] = "Missed", 
                        [2] = nil, 
                        [3] = nil, 
                        [4] = " due to ", 
                        [5] = nil, 
                        [6] = " [dmg: ", 
                        [7] = nil, 
                        [8] = " hc: ", 
                        [9] = nil, 
                        [10] = " bt: ", 
                        [2] = v983.target:get_name() .. "'s", 
                        [3] = v983.wanted_hitbox, 
                        [5] = v983.state, 
                        [7] = v983.wanted_damage, 
                        [9] = v983.hitchance, 
                        [11] = v983.wanted_backtrack .. "]"
                    }, {
                        [1] = "FF5959", 
                        [2] = "ffffff", 
                        [3] = "FF5959", 
                        [4] = "ffffff", 
                        [5] = "FF5959", 
                        [6] = "ffffff", 
                        [7] = "ffffff", 
                        [8] = "ffffff", 
                        [9] = "ffffff", 
                        [10] = "ffffff", 
                        [11] = "ffffff"
                    });
                end;
            elseif v984 == "Ambani" then
                if v983.state == nil then
                    local v994 = "(" .. (v983.before_hp <= 0 and "dead" or v983.before_hp .. " remaining") .. ")";
                    v493(("$[Trashhode]$   Hit $%s$'s $%s$ for $%d(" .. string.format("%.f", v983.damage) .. ")$ damage (hp: $" .. v994 .. "$) (bt: $%s$)"):format(v983.target:get_name(), v983.hitbox, v983.damage, v983.wanted_backtrack), 6);
                else
                    v493(("$[Trashhode]$   Missed shot in $%s$ in the $%s$ due to $%s$ (hc: $%.f$) (damage: $%.f$) (bt: $%.f$)"):format(v983.target:get_name(), v983.wanted_hitbox, v983.state, v983.hitchance, v983.wanted_damage, v983.wanted_backtrack), 6);
                end;
            end;
            return;
        end;
    end, 
    draw_console = function(v995)
        -- upvalues: l_config_sub_0 (ref), l_sub_0 (ref)
        if not l_config_sub_0.visual.logger:get() or not l_config_sub_0.visual_logger_sub.position:get("Console") then
            return;
        else
            local v996 = "(" .. (v995.before_hp <= 0 and "dead" or v995.before_hp .. " remaining") .. ")";
            local v997 = v995.wanted_backtrack * math.floor(globals.tickinterval * 1000 + 0.5);
            if v995.state == "correction" then
                v995.state = "resolver";
            end;
            if v995.state == nil then
                local v998 = "\a96C83CFF";
                local v999 = "\aFFCA00FF";
                local v1000 = v995.hitbox == v995.wanted_hitbox;
                local v1001 = l_sub_0(v995.hitbox, v1000 and v998 or v999);
                local v1002 = l_sub_0(v995.wanted_hitbox, v1000 and v998 or v999);
                print_raw(("\a96C83CFF[Trashhode] Hit \aD5D5D5FF%s in the \a96C83CFF%s\aDEFAULT for %d(" .. string.format("%.f", v995.wanted_damage) .. ") damage " .. v996 .. " (aimed: \a96C83CFF" .. v1002 .. "\aDEFAULT) (hc: \a96C83CFF" .. string.format("%.f", v995.hitchance) .. "\aD5D5D5FF) (bt: \a96C83CFF%st\aDEFAULT \226\137\136 \a96C83CFF%s\aDEFAULTms)"):format(v995.target:get_name(), v1001, v995.damage, v995.wanted_backtrack, v997));
            else
                print_raw(("\aFF5959FF[Trashhode] Missed \aD5D5D5FFshot in %s in the %s due to " .. "\aFF5959FF" .. v995.state .. "\aD5D5D5FF (bt: " .. v995.wanted_backtrack .. " = " .. v997 .. " ms) (hc: \aFF5959FF" .. string.format("%.f", v995.hitchance) .. "\aD5D5D5FF) (damage: " .. string.format("%.f", v995.wanted_damage) .. ")"):format(v995.target:get_name(), "\aFF5959FF" .. v995.wanted_hitbox .. "\aD5D5D5FF"));
            end;
            return;
        end;
    end, 
    draw_top = function(v1003)
        -- upvalues: l_config_sub_0 (ref)
        if not l_config_sub_0.visual.logger:get() or not l_config_sub_0.visual_logger_sub.position:get("Top") then
            return;
        else
            local v1004 = "(" .. (v1003.before_hp <= 0 and "dead" or v1003.before_hp .. " remaining") .. ")";
            if v1003.state == "correction" then
                v1003.state = "resolver";
            end;
            if l_config_sub_0.visual_logger_sub.top_style:get() == "Print_Dev" then
                if v1003.state == nil then
                    print_dev(("\a96C83CFF[+] Hit \aD5D5D5FF %s in the \a96C83CFF%s\aDEFAULT for %d(" .. string.format("%.f", v1003.wanted_damage) .. ") damage " .. v1004 .. " (aimed: \a96C83CFF" .. v1003.wanted_hitbox .. "\aDEFAULT) (hc: \a96C83CFF" .. string.format("%.f", v1003.hitchance) .. "\aD5D5D5FF) (bt: \a96C83CFF%s\aDEFAULT)"):format(v1003.target:get_name(), v1003.hitbox, v1003.damage, v1003.wanted_backtrack));
                else
                    print_dev(("\aFF5959FF[-] Missed \aD5D5D5FFshot in %s in the %s due to \aFF5959FF" .. v1003.state .. "\aD5D5D5FF (bt: " .. v1003.wanted_backtrack .. ") (hc: \aFF5959FF" .. string.format("%.f", v1003.hitchance) .. "\aD5D5D5FF) (damage: " .. string.format("%.f", v1003.wanted_damage) .. ")"):format(v1003.target:get_name(), "\aFF5959FF" .. v1003.wanted_hitbox .. "\aD5D5D5FF"));
                end;
            elseif l_config_sub_0.visual_logger_sub.top_style:get() == "Neverlose" then
                if v1003.state == nil then
                    common.add_event(("\a96C83CFFHit \aD5D5D5FF %s in the \a96C83CFF%s\aDEFAULT for %d"):format(v1003.target:get_name(), v1003.hitbox, v1003.damage), "check");
                else
                    common.add_event(("\aFF5959FFMissed \aD5D5D5FFshot in %s in the %s due to \aFF5959FF" .. v1003.state .. ""):format(v1003.target:get_name(), "\aFF5959FF" .. v1003.wanted_hitbox .. "\aD5D5D5FF"), "xmark");
                end;
            end;
            return;
        end;
    end, 
    on_aim_ack = function(v1005, v1006)
        -- upvalues: v63 (ref)
        v1005.shot_id = v1006.id;
        v1005.hitchance = math.floor(v1006.hitchance + 0.5);
        v1005.hitbox = v63[v1006.hitgroup];
        v1005.damage = v1006.damage;
        v1005.spread = v1006.spread;
        v1005.wanted_backtrack = v1006.backtrack;
        v1005.before_hp = v1006.target.m_iHealth;
        v1005.wanted_damage = v1006.wanted_damage;
        v1005.wanted_hitbox = v63[v1006.wanted_hitgroup];
        v1005.state = v1006.state;
        v1005.target = v1006.target;
        v1005:draw_screen();
        v1005:draw_console();
        v1005:draw_top();
    end
};
v64[#v64 + 1] = v1007;
local function v1008()
    return entity.get_game_rules();
end;
local function v1010()
    -- upvalues: v1008 (ref)
    local v1009 = v1008();
    if not v1009 then
        return 0;
    else
        return v1009.m_totalRoundsPlayed or 0;
    end;
end;
local function v1012()
    local v1011 = cvar.mp_maxrounds:int();
    if v1011 == 0 then
        v1011 = 30;
    end;
    return v1011;
end;
local _ = {
    [1] = nil, 
    [2] = nil, 
    [3] = nil, 
    [4] = nil, 
    [5] = nil, 
    [6] = nil, 
    [7] = "C4 exploded", 
    [8] = "C4 defused", 
    [9] = "CT eliminated", 
    [10] = "T eliminated", 
    [11] = nil, 
    [12] = nil, 
    [13] = nil, 
    [14] = nil, 
    [15] = "Time expired"
};
events.round_start:set(function(_)
    -- upvalues: l_config_sub_0 (ref), v1010 (ref), v1012 (ref)
    if not l_config_sub_0.visual_logger_sub.round:get() then
        return;
    else
        print_raw(string.format("\a74a6a9ff[LOG]\aDEFAULT  --------------  ROUND %d / %d START  --------------", v1010(), v1012()));
        return;
    end;
end);
local v1015 = {
    ["< >"] = {
        glyph = {
            [1] = "<", 
            [2] = ">"
        }, 
        font_n = {
            [1] = v307.manual.verdana_default, 
            [2] = v307.manual.verdana_default
        }, 
        font_o = {
            [1] = v307.manual.verdana_default_o, 
            [2] = v307.manual.verdana_default_o
        }
    }, 
    ["\226\128\185 \226\128\186"] = {
        glyph = {
            [1] = "\226\128\185", 
            [2] = "\226\128\186"
        }, 
        font_n = {
            [1] = v307.manual.verdana_3_de_dis, 
            [2] = v307.manual.verdana_3_de_dis
        }, 
        font_o = {
            [1] = v307.manual.verdana_3_de, 
            [2] = v307.manual.verdana_3_de
        }
    }, 
    ["\226\157\176 \226\157\177"] = {
        glyph = {
            [1] = "\226\157\176", 
            [2] = "\226\157\177"
        }, 
        font_n = {
            [1] = v307.manual.verdana_new, 
            [2] = v307.manual.verdana_new
        }, 
        font_o = {
            [1] = v307.manual.verdana_new_o, 
            [2] = v307.manual.verdana_new_o
        }
    }, 
    ["\226\157\174 \226\157\175"] = {
        glyph = {
            [1] = "\226\157\174", 
            [2] = "\226\157\175"
        }, 
        font_n = {
            [1] = v307.manual.verdana_2_de, 
            [2] = v307.manual.verdana_2_de
        }, 
        font_o = {
            [1] = v307.manual.verdana_2_de_o, 
            [2] = v307.manual.verdana_2_de_o
        }
    }
};
local v1112 = {
    length = 0, 
    offset = {
        [1] = 0, 
        [2] = 0, 
        [3] = 0
    }, 
    left = {
        [1] = 0, 
        [2] = 0, 
        [3] = 0
    }, 
    right = {
        [1] = 0, 
        [2] = 0, 
        [3] = 0
    }, 
    left_offset = {
        [1] = 4, 
        [2] = 255, 
        [3] = 0
    }, 
    right_offset = {
        [1] = -4, 
        [2] = 0, 
        [3] = 255
    }, 
    offset_final = {
        [1] = 0, 
        [2] = 0, 
        [3] = 0
    }, 
    offsets = {
        [1] = 0, 
        [2] = 0, 
        [3] = 0, 
        [4] = 0, 
        [5] = 0, 
        [6] = 0
    }, 
    alpha = {
        [1] = 0, 
        [2] = 0, 
        [3] = 0, 
        [4] = 0, 
        [5] = 0, 
        [6] = 0
    }, 
    exp = {
        [1] = 0, 
        [2] = 0, 
        [3] = 0, 
        [4] = 0, 
        [5] = 0, 
        [6] = 0
    }, 
    exp_cache = {
        [1] = 0, 
        [2] = 0, 
        [3] = 0, 
        [4] = 0, 
        [5] = 0, 
        [6] = 0
    }, 
    text = {
        [1] = "HIDE", 
        [2] = "DT", 
        [3] = "PEEK", 
        [4] = "FD", 
        [5] = "DMG", 
        [6] = "HC"
    }, 
    line = {
        [1] = 0, 
        [2] = 0
    }, 
    manual_left = {
        [1] = 0, 
        [2] = 0
    }, 
    manual_right = {
        [1] = 0, 
        [2] = 0
    }, 
    prepare = function(_)
        -- upvalues: l_config_sub_0 (ref)
        local v1017 = entity.get_local_player();
        if not v1017 or not v1017:is_alive() then
            return;
        elseif not v1017:get_player_weapon() then
            return;
        elseif not l_config_sub_0.visual.center:get() then
            return;
        else
            return true, v1017;
        end;
    end, 
    draw_lotus = function(v1018)
        -- upvalues: l_aim_0 (ref), l_config_sub_0 (ref), v15 (ref), v71 (ref)
        local v1019 = l_aim_0.get_desync_delta();
        local v1020 = math.floor(100 * l_aim_0.get_overlap(rotation));
        local v1021 = l_config_sub_0.visual_center_sub.color:get("Left")[1];
        local v1022 = l_config_sub_0.visual_center_sub.color:get("Left Alt")[1];
        local v1023 = l_config_sub_0.visual_center_sub.color:get("Right")[1];
        local v1024 = l_config_sub_0.visual_center_sub.color:get("Right Alt")[1];
        local v1025 = v15.rage.hs:get() or v15.rage.hs:get_override();
        local v1026 = v15.rage.dt:get() or v15.rage.dt:get_override();
        local v1027 = v15.rage.peek:get();
        local v1028 = v15.rage.fd:get();
        local v1029 = false;
        local v1030 = false;
        for _, v1032 in ipairs(ui.get_binds()) do
            local v1033 = v1032.reference:id();
            if v1033 == 3865218783 and v1032.active then
                v1029 = true;
            end;
            if v1033 == 3953823531 and v1032.active then
                v1030 = true;
            end;
        end;
        local v1034 = {
            key = {
                [1] = v1025, 
                [2] = v1026, 
                [3] = v1027, 
                [4] = v1028, 
                [5] = v1029, 
                [6] = v1030
            }
        };
        local v1035 = {
            [1] = render.screen_size().x, 
            [2] = render.screen_size().y
        };
        local v1036 = {
            left = {
                [1] = v1021.r, 
                [2] = v1021.g, 
                [3] = v1021.b
            }, 
            right = {
                [1] = v1023.r, 
                [2] = v1023.g, 
                [3] = v1023.b
            }, 
            left_alt = {
                [1] = v1022.r, 
                [2] = v1022.g, 
                [3] = v1022.b
            }, 
            right_alt = {
                [1] = v1024.r, 
                [2] = v1024.g, 
                [3] = v1024.b
            }
        };
        for v1037 = 1, #v1018.offset do
            if v1019 >= 45 then
                v1018.offset[v1037] = math.lerpy(v1018.offset[v1037], v1018.left_offset[v1037], 6);
            elseif v1019 <= 45 then
                v1018.offset[v1037] = math.lerpy(v1018.offset[v1037], v1018.right_offset[v1037], 6);
            else
                v1018.offset[v1037] = math.lerpy(v1018.offset[v1037], v1018.offset_final[v1037], 6);
            end;
        end;
        local v1038 = v1035[1] / 2 + v1018.offset[1];
        local v1039 = v1035[2] / 2;
        for v1040 = 1, 3 do
            v1018.left[v1040] = math.lerpy(v1018.left[v1040], v1020 > 32 and v1036.left[v1040] or v1036.left_alt[v1040], 6);
            v1018.right[v1040] = math.lerpy(v1018.right[v1040], v1020 > 32 and v1036.right[v1040] or v1036.right_alt[v1040], 6);
        end;
        local v1041 = l_config_sub_0.visual_center_sub.show_text:get();
        local v1042 = v71.gradient_text(v1018.left[1], v1018.left[2], v1018.left[3], 255, v1018.right[1], v1018.right[2], v1018.right[3], 255, "Trashhode-Dev*");
        if v1041 then
            render.text(4, vector(v1038 + 3, v1039 + 35), color(255, 255, 255, 255), "c", v1042);
        end;
        v1018.length = math.lerpy(v1018.length, math.floor(58 - l_aim_0.get_overlap(true) * 58), 6);
        render.rect(vector(v1038 - 26, v1039 + 42), vector(v1038 - 26 + 55, v1039 + 45), color(17, 17, 17, 190));
        local v1043 = v1038 + 3 - 30;
        local v1044 = v1039 + 42;
        render.gradient(vector(v1043, v1044), vector(v1043 + v1018.length, v1044 + 3), color(v1018.left[1], v1018.left[2], v1018.left[3], 255), color(v1018.right[1], v1018.right[2], v1018.right[3], 255), color(v1018.left[1], v1018.left[2], v1018.left[3], 255), color(v1018.right[1], v1018.right[2], v1018.right[3], 255));
        local v1045 = v71.gradient_text(v1018.left[1], v1018.left[2], v1018.left[3], v1020 < 32 and 255 or 230, v1018.right[1], v1018.right[2], v1018.right[3], v1020 < 32 and 255 or 150, "LAP                                     FAKE");
        render.text(2, vector(v1038 - 31, v1039 + 45), color(255, 255, 255, 255), nil, v1045);
        local v1046 = 0;
        for v1047 = 1, #v1034.key do
            v1018.offsets[v1047] = math.lerpy(v1018.offsets[v1047], v1034.key[v1047] and 80 or 0, 6);
            v1018.alpha[v1047] = math.lerpy(v1018.alpha[v1047], v1034.key[v1047] and 255 or 0, 6);
            v1018.exp[v1047] = math.lerpy(v1018.exp[v1047], v1034.key[v1047] and 10 or 0, 6);
            v1018.exp_cache[v1047] = v1047 == 1 and 0 or v1047 == 2 and v1018.exp[1] or v1047 == 3 and v1018.exp[1] + v1018.exp[2] or v1047 == 4 and v1018.exp[1] + v1018.exp[2] + v1018.exp[3] or v1047 == 5 and v1018.exp[1] + v1018.exp[2] + v1018.exp[3] + v1018.exp[4] or v1047 == 6 and v1018.exp[1] + v1018.exp[2] + v1018.exp[3] + v1018.exp[4] + v1018.exp[5];
            render.text(2, vector(v1038 + 3 + 60 + 4, v1039 + 20 + 80 - v1018.offsets[v1047] + v1018.exp_cache[v1047]), color(255, 255, 255, v1018.alpha[v1047]), nil, v1018.text[v1047]);
            v1046 = v1018.exp_cache[v1047] + v1018.exp[6];
        end;
        if v1046 >= 1 then
            v1018.line[1] = math.lerpy(v1018.line[1], 50, 6);
            v1018.line[2] = math.lerpy(v1018.line[2], 50, 6);
        else
            v1018.line[1] = math.lerpy(v1018.line[1], 0, 6);
            v1018.line[2] = math.lerpy(v1018.line[2], 0, 6);
        end;
        local v1048 = v1038 + 3 + 55 + 4;
        local v1049 = v1039 + 20;
        if v1018.line[1] > 0 then
            local v1050 = color(255, 255, 255, v1018.line[2]);
            render.gradient(vector(v1048, v1049), vector(v1048 + 1, v1049 + v1018.line[1]), v1050, v1050, v1050, v1050);
        end;
        if v1046 > 0 then
            local v1051 = color(255, 255, 255, 255);
            render.gradient(vector(v1048, v1049), vector(v1048 + 1, v1049 + v1046), v1051, v1051, v1051, v1051);
        end;
    end, 
    draw_melancholy = function(v1052, v1053)
        -- upvalues: l_config_sub_0 (ref), v10 (ref), v15 (ref)
        local v1054 = render.screen_size();
        local v1055 = v1054.x / 2;
        local v1056 = v1054.y / 2;
        local v1057 = v1053.m_flPoseParameter[11] * 120 - 60;
        local v1058 = math.abs(v1057);
        local v1059 = v1057 > 0 and 1 or -1;
        local v1060 = l_config_sub_0.visual_center_sub.color:get("Left")[1];
        local _ = l_config_sub_0.visual_center_sub.color:get("Right")[1];
        local v1062 = v1059 == 1 and v1060 or color(255, 255, 255);
        local v1063 = v1059 == -1 and v1060 or color(255, 255, 255);
        local v1064 = v10.anim_new("mel_show", 1);
        local v1065 = v10.anim_new("mel_scope_x", v1053.m_bIsScoped and 40 or 0, nil, 0.2);
        local v1066 = v10.anim_new("mel_pc", v1062);
        local v1067 = v10.anim_new("mel_tn", v1063);
        local v1068 = 0.7;
        v1052._mel_alpha = v1052._mel_alpha or 255;
        v1052._mel_alpha_dir = v1052._mel_alpha_dir or -1;
        v1052._mel_alpha = v1052._mel_alpha + v1052._mel_alpha_dir * v1068;
        if v1052._mel_alpha <= 0 then
            local v1069 = 0;
            v1052._mel_alpha_dir = 1;
            v1052._mel_alpha = v1069;
        end;
        if v1052._mel_alpha >= 255 then
            local v1070 = 255;
            v1052._mel_alpha_dir = -1;
            v1052._mel_alpha = v1070;
        end;
        local v1071 = 22 * v1064;
        local l_x_4 = render.measure_text(2, nil, "[DEV]").x;
        render.text(2, vector(v1055 - l_x_4 / 2 + v1065, v1056 + v1071), color(255, 255, 255, math.min(v1052._mel_alpha, v1064 * 255)), nil, "[DEV]");
        v1071 = v1071 + 9;
        local l_x_5 = render.measure_text(2, nil, "Trashhode.RECODE").x;
        local l_x_6 = render.measure_text(2, nil, "Trashhode").x;
        render.text(2, vector(v1055 - l_x_5 / 2 + v1065, v1056 + v1071), v1066, nil, "Trashhode");
        render.text(2, vector(v1055 - l_x_5 / 2 + l_x_6 - 2 + v1065, v1056 + v1071), v1067, nil, ".RECODE");
        local v1075 = v1055 - l_x_5 / 2 + v1065;
        local v1076 = v1056 + v1071;
        local v1077 = 8;
        local v1078 = -3;
        local v1079 = color(v1066.r, v1066.g, v1066.b, 80);
        render.shadow(vector(v1075 - v1078, v1076 - v1078), vector(v1075 + l_x_5 + v1078, v1076 + v1077 + v1078), v1079, 40, 0, 3);
        v1071 = v1071 + 9;
        v1075 = l_x_5 - 2;
        v1076 = 65;
        v1077 = 5;
        v1078 = v1055 - v1076 / 2 + v1065;
        v1079 = v1056 + v1071 + 1;
        local v1080 = color(25, 25, 25, math.floor(v1064 * 179));
        render.rect(vector(v1078, v1079), vector(v1078 + v1076, v1079 + v1077), v1080);
        render.rect_outline(vector(v1078, v1079), vector(v1078 + v1076, v1079 + v1077 + 1), v1080);
        local v1081 = 13 + v1058 / 1.23;
        local v1082 = color(v1060.r, v1060.g, v1060.b, math.floor(255 * v1064));
        local v1083 = color(v1060.r, v1060.g, v1060.b, math.floor(77 * v1064));
        render.gradient(vector(v1078 + 1, v1079 + 1), vector(v1078 + 1 + v1081, v1079 + v1077 - 1), v1082, v1083, v1082, v1083);
        v1071 = v1071 + 7;
        local v1084 = {
            DMG = false, 
            PING = false, 
            RAPID = v15.rage.dt:get(), 
            ["OS-AA"] = v15.rage.hs:get(), 
            SAFE = v15.rage.sp:get() == "Force", 
            BAIM = v15.rage.hitbox:get_override() ~= nil, 
            DUCK = v15.rage.fd:get()
        };
        for _, v1086 in ipairs(ui.get_binds()) do
            local v1087 = v1086.reference:id();
            if v1087 == 3865218783 and v1086.active then
                v1084.DMG = true;
            end;
            if v1087 == 2884419457 and v1086.active then
                v1084.PING = true;
            end;
        end;
        for v1088, v1089 in pairs(v1084) do
            local v1090 = v10.anim_new("mel_k_" .. v1088, v1089 and 1 or 0, nil, 0.18);
            if v1090 > 0.01 then
                local v1091 = nil;
                if v1088 == "RAPID" then
                    v1091 = math.exploit() and color(212, 212, 212, math.floor(v1090 * 255 * v1064)) or color(255, 0, 0, math.floor(v1090 * 255 * v1064));
                elseif v1088 == "OS-AA" then
                    v1091 = color(130, 194, 18, math.floor(v1090 * 255 * v1064));
                else
                    v1091 = color(212, 212, 212, math.floor(v1090 * 255 * v1064));
                end;
                local l_x_7 = render.measure_text(2, nil, v1088).x;
                render.text(2, vector(v1055 - l_x_7 / 2 + v1065, v1056 + v1071), v1091, nil, v1088);
                v1071 = v1071 + 9;
            end;
        end;
    end, 
    draw_acatel = function(_)
        -- upvalues: v71 (ref), v15 (ref), v307 (ref)
        local l_x_8 = render.screen_size().x;
        local l_y_4 = render.screen_size().y;
        local v1096 = v71.get_left_right();
        local v1097 = false;
        for _, v1099 in ipairs(ui.get_binds()) do
            if v1099.reference:id() == 3865218783 and v1099.active then
                v1097 = true;
            end;
        end;
        local v1100 = 10;
        local v1101 = v15.rage.dt:get() or v15.rage.dt:get_override();
        local v1102 = v15.rage.hs:get() or v15.rage.hs:get_override();
        local v1103 = v15.rage.hs_op:get() == "Break LC" or v15.rage.dt_lag:get() == "Always On";
        local v1104 = render.measure_text(v307.pixel, nil, "Trashhode ");
        render.text(v307.pixel, vector(l_x_8 / 2, l_y_4 / 2 + v1100), color(255, 255, 255, 255), nil, "Trashhode  ");
        render.text(v307.pixel, vector(l_x_8 / 2 + v1104.x - 2, l_y_4 / 2 + v1100), color(255, 130, 130, 255), nil, "RECODE");
        v1100 = v1100 + 9;
        local v1105 = "";
        local v1106 = color(0, 0, 0, 0);
        if v1101 or v1102 then
            if v1103 then
                if math.exploit() then
                    v1105 = "Safe+ ";
                    v1106 = color(255, 50, 50, 255);
                else
                    v1105 = "Unsafe- ";
                    v1106 = color(255, 117, 107, 255);
                end;
            end;
        else
            v1105 = "Fake Lag";
            v1106 = color(255, 117, 107, 255);
        end;
        local _ = render.measure_text(v307.pixel, nil, v1105);
        render.text(v307.pixel, vector(l_x_8 / 2, l_y_4 / 2 + v1100), v1106, nil, v1105);
        v1100 = v1100 + 9;
        local v1108 = render.measure_text(v307.pixel, nil, "AA-SIDE: ");
        render.text(v307.pixel, vector(l_x_8 / 2, l_y_4 / 2 + v1100), color(130, 130, 255, 255), nil, "AA-SIDE:");
        render.text(v307.pixel, vector(l_x_8 / 2 + v1108.x, l_y_4 / 2 + v1100), color(255, 255, 255, 255), nil, v1096);
        v1100 = v1100 + 9;
    end, 
    on_render = function(v1109)
        -- upvalues: l_config_sub_0 (ref)
        local v1110, v1111 = v1109:prepare();
        if not v1110 then
            return;
        else
            if l_config_sub_0.visual_center.style:get() == "Lotus" then
                v1109:draw_lotus();
            elseif l_config_sub_0.visual_center.style:get() == "Melancholia" then
                v1109:draw_melancholy(v1111);
            end;
            return;
        end;
    end
};
v64[#v64 + 1] = v1112;
local v1113 = {
    alpha = 0, 
    fade = 1
};
local function v1117(v1114, v1115, v1116)
    if v1116 < 0.5 then
        return v1114 + (v1115 - v1114) * (2 * v1116 * v1116);
    else
        v1116 = v1116 * 2 - 1;
        return v1114 + (v1115 - v1114) * (1 - v1116 * (2 - v1116)) / 2;
    end;
end;
local function v1169()
    -- upvalues: l_config_sub_0 (ref), v1113 (ref), v1117 (ref), v71 (ref), v65 (ref), v68 (ref), v15 (ref)
    if not l_config_sub_0.visual.center:get() then
        return;
    elseif l_config_sub_0.visual_center.style:get() ~= "Outlaw" then
        return;
    else
        local v1118 = entity.get_local_player();
        if not v1118 or not v1118:is_alive() then
            return;
        else
            local v1119 = color();
            local l_to_hex_0 = v1119.to_hex;
            local l_alpha_modulate_0 = v1119.alpha_modulate;
            local l_frametime_1 = globals.frametime;
            local v1123 = render.screen_size();
            local v1124 = v1123.x * 0.5;
            local v1125 = v1123.y * 0.5;
            local v1126 = v1118:get_player_weapon();
            if v1126 == nil then
                return;
            else
                local v1127 = v1126 and v1126:get_weapon_info();
                local v1128 = v1127 and v1127.weapon_type == 9 and 0.5 or 1;
                local v1129 = 30;
                local _ = color(248, 153, 153);
                v1113.fade = v1117(v1113.fade, v1128, l_frametime_1 * v1129);
                v1113.alpha = v71.lerpToggle("xh_ind_alpha", true, v1113.alpha, 1, 0.1) * v1113.fade;
                if v1113.alpha < 0.02 then
                    return;
                else
                    local v1131 = 255 * v1113.alpha;
                    local l_m_bIsScoped_0 = v1118.m_bIsScoped;
                    local v1133 = v71.lerpToggle("xh_scope_adj", l_m_bIsScoped_0, 0, 1, 0.02);
                    local v1134 = 35;
                    local v1135 = 2;
                    local v1136 = color(248, 153, 153, v1131);
                    local v1137 = l_config_sub_0.visual_center_sub.color_2:get();
                    local v1138 = v1137:clone():alpha_modulate(v1131);
                    local v1139 = v1124 + 2;
                    local v1140 = v1125 + v1134;
                    local v1141 = v1136:alpha_modulate(v1131):to_hex();
                    local v1142 = string.format("Trashhode  \a%s[+]", v1141);
                    local v1143 = render.measure_text(v1135, nil, v1142).x * 0.5;
                    render.text(v1135, vector(v1139 + (v1143 + 7) * v1133, v1140), v1138, "c", v1142);
                    v1140 = v1140 + 8;
                    local v1144 = "";
                    local l_manual_enable_0 = v65.aa.manual_enable;
                    local l_yaw_dir_0 = v68.yaw_dir;
                    local v1147 = l_manual_enable_0 and l_yaw_dir_0 == "Left";
                    local v1148 = l_manual_enable_0 and l_yaw_dir_0 == "Right";
                    local v1149 = v71.get_left_right();
                    v1144 = v1149 == "Left" and "L" or v1149 == "Right" and "R" or v1147 and "L" or v1148 and "R" or "M";
                    local v1150 = string.format("SIDE:  \a%s%s", l_to_hex_0(v1137), v1144);
                    local v1151 = render.measure_text(v1135, nil, v1150).x * 0.5;
                    render.text(v1135, vector(v1139 + (v1151 + 7) * v1133 - v1151, v1140 - 6), v1136, nil, v1150);
                    v1140 = v1140 + 9;
                    local v1152 = v15.rage.dt:get() or v15.rage.dt:get_override();
                    local v1153 = v15.rage.hs:get() or v15.rage.hs:get_override();
                    local v1154 = false;
                    local v1155 = false;
                    local v1156 = false;
                    local v1157 = false;
                    local v1158 = v15.rage.fd:get();
                    for _, v1160 in ipairs(ui.get_binds()) do
                        local v1161 = v1160.reference:id();
                        if v1161 == 3865218783 and v1160.active then
                            v1154 = true;
                        end;
                        if v1161 == 2884419457 and v1160.active then
                            v1157 = true;
                        end;
                    end;
                    local v1162 = {
                        [1] = {
                            [1] = "RAPID", 
                            [2] = color(212), 
                            [3] = v1152
                        }, 
                        [2] = {
                            [1] = "OS-AA", 
                            [2] = color(130, 194, 18), 
                            [3] = v1153
                        }, 
                        [3] = {
                            [1] = "DMG", 
                            [2] = color(212), 
                            [3] = v1154
                        }, 
                        [4] = {
                            [1] = "SAFE", 
                            [2] = color(212), 
                            [3] = v1155
                        }, 
                        [5] = {
                            [1] = "BAIM", 
                            [2] = color(212), 
                            [3] = v1156
                        }, 
                        [6] = {
                            [1] = "PING", 
                            [2] = color(130, 194, 18), 
                            [3] = v1157
                        }, 
                        [7] = {
                            [1] = "DUCK", 
                            [2] = color(212), 
                            [3] = v1158
                        }
                    };
                    for v1163 = 1, #v1162 do
                        local v1164, v1165, v1166 = unpack(v1162[v1163]);
                        if v1164 == "RAPID" then
                            v1165 = rage.exploit:get() == 1 and color(212, 212, 212) or color(255, 0, 0);
                        end;
                        local v1167 = v71.lerpToggle("xh_bind_" .. v1164, v1166, 0, 1, 0.036);
                        if v1167 > 0.02 then
                            local v1168 = (render.measure_text(v1135, nil, v1164).x * 0.5 + 7) * v1133;
                            render.text(v1135, vector(v1139 + v1168, v1140), l_alpha_modulate_0(v1165, v1131 * v1167), "c", v1164);
                            v1140 = v1140 + 8 * v1167;
                        end;
                    end;
                    return;
                end;
            end;
        end;
    end;
end;
events.render:set(v1169);
local v1198 = {
    main = function(_)
        -- upvalues: l_config_sub_0 (ref), v65 (ref), v68 (ref), v10 (ref), v1015 (ref)
        local v1171 = entity.get_local_player();
        if not v1171 or not v1171:is_alive() then
            return;
        elseif not l_config_sub_0.visual.manual:get() then
            return;
        else
            local v1172 = l_config_sub_0.visual_manual.style:get();
            local v1173 = l_config_sub_0.visual_manual.x:get();
            local v1174 = l_config_sub_0.visual_manual.y:get();
            local v1175 = l_config_sub_0.visual_manual.color:get();
            local l_manual_enable_1 = v65.aa.manual_enable;
            local l_yaw_dir_1 = v68.yaw_dir;
            local v1178 = l_manual_enable_1 and l_yaw_dir_1 == "Left";
            local v1179 = l_manual_enable_1 and l_yaw_dir_1 == "Right";
            local v1180 = v10.anim_new("man_l", 1, nil, 0.5);
            local v1181 = v10.anim_new("man_r", 1, nil, 0.5);
            local v1182 = render.screen_size();
            local v1183 = v1182.x * 0.5;
            local v1184 = v1182.y * 0.5;
            local v1185 = v1015[v1172];
            if not v1185 then
                return;
            else
                local function v1195(v1186, v1187)
                    -- upvalues: v1178 (ref), v1179 (ref), v1175 (ref), v1185 (ref), v1183 (ref), v1173 (ref), v1184 (ref), v1174 (ref)
                    local v1188 = v1186 == "L";
                    local v1189 = v1188 and v1178 or not v1188 and v1179;
                    local v1190 = v1189 and color(255, 255, 255, 255) or v1175;
                    local v1191 = v1189 and 1 or 0.35;
                    local v1192 = color(v1190.r, v1190.g, v1190.b, math.floor(v1190.a * v1187 * v1191));
                    local v1193 = v1188 and 1 or 2;
                    local v1194 = v1189 and v1185.font_o[v1193] or v1185.font_n[v1193];
                    render.text(v1194, vector(v1183 + (v1188 and -v1173 or v1173), v1184 - v1174), v1192, "c", v1185.glyph[v1193]);
                end;
                v1195("L", v1180);
                v1195("R", v1181);
                return;
            end;
        end;
    end, 
    unlock_ping = function(_)
        -- upvalues: l_config_sub_0 (ref), v15 (ref)
        if not l_config_sub_0.misc.fakeping:get() then
            v15.rage.latency:override(nil);
            return;
        else
            cvar.sv_maxunlag:float(0.4);
            v15.rage.latency:override(l_config_sub_0.misc_sub.ping_slider:get());
            return;
        end;
    end, 
    on_render = function(v1197)
        v1197:main();
        v1197:unlock_ping();
    end
};
v64[#v64 + 1] = v1198;
events.render:set(function()
    -- upvalues: l_config_sub_0 (ref), v65 (ref), v68 (ref), v71 (ref)
    local v1199 = entity.get_local_player();
    if not v1199 or not v1199:is_alive() then
        return;
    else
        local v1200 = l_config_sub_0.visual_manual.x:get();
        local v1201 = l_config_sub_0.visual_manual.color:get();
        local l_manual_enable_2 = v65.aa.manual_enable;
        local l_yaw_dir_2 = v68.yaw_dir;
        local v1204 = l_manual_enable_2 and l_yaw_dir_2 == "Left";
        local v1205 = l_manual_enable_2 and l_yaw_dir_2 == "Right";
        local v1206 = l_config_sub_0.visual_manual.len:get();
        local v1207 = l_config_sub_0.visual_manual.gap:get();
        local v1208 = v71.lerpToggle("Manual Arrows -> Scope", not v1199.m_bIsScoped, 0.5, 1, 0.035);
        local v1209 = l_config_sub_0.visual_manual.style:get() == "New";
        local v1210 = v71.lerpToggle("ManualArrowsEnabled", v1209, 0, 1, 0.025);
        if v1210 == 0 then
            return;
        else
            local v1211 = v71.lerpToggle("ManualArrowLeft", v1204, 0.5, 1, 0.025);
            local v1212 = v71.lerpToggle("ManualArrowRight", v1205, 0.5, 1, 0.035);
            v1211 = v1211 * v1210 * v1208 * 255;
            v1212 = v1212 * v1210 * v1208 * 255;
            if v1211 < 1 and v1212 < 1 then
                return;
            else
                local v1213 = render.screen_size();
                local v1214 = v1213.x * 0.5;
                local v1215 = v1213.y * l_config_sub_0.visual_manual.y:get() / 200;
                if v1211 > 1 then
                    v1201.a = v1211;
                    render.line(vector(v1214 - v1200, v1215 - v1207), vector(v1214 - v1200 - v1206, v1215), v1201);
                    render.line(vector(v1214 - v1200 + 1, v1215 - v1207), vector(v1214 - v1200 - v1206 + 1, v1215), v1201);
                    render.line(vector(v1214 - v1200, v1215 + v1207), vector(v1214 - v1200 - v1206, v1215), v1201);
                    render.line(vector(v1214 - v1200 + 1, v1215 + v1207), vector(v1214 - v1200 - v1206 + 1, v1215), v1201);
                end;
                if v1212 > 1 then
                    v1201.a = v1212;
                    render.line(vector(v1214 + v1200, v1215 - v1207), vector(v1214 + v1200 + v1206, v1215), v1201);
                    render.line(vector(v1214 + v1200 + 1, v1215 - v1207), vector(v1214 + v1200 + v1206 + 1, v1215), v1201);
                    render.line(vector(v1214 + v1200, v1215 + v1207), vector(v1214 + v1200 + v1206, v1215), v1201);
                    render.line(vector(v1214 + v1200 + 1, v1215 + v1207), vector(v1214 + v1200 + v1206 + 1, v1215), v1201);
                end;
                return;
            end;
        end;
    end;
end);
local v1216 = {};
local l_rage_0 = v15.rage;
local l_rage_lethal_sub_1_0 = l_config_sub_0.rage_lethal_sub_1;
local _ = l_config_sub_0.rage_lethal_sub;
local function v1220()
    -- upvalues: l_rage_0 (ref)
    l_rage_0.hitbox:override();
    l_rage_0.dmg:override();
    l_rage_0.body_muilt:override();
    l_rage_0.hc:override();
    l_rage_0.sp:override();
    l_rage_0.sp_en:override();
end;
local v1221 = {
    Max = {
        hc = 77, 
        muilt = 60
    }, 
    High = {
        hc = 58, 
        muilt = 80
    }, 
    Medium = {
        hc = 50, 
        muilt = 90
    }, 
    Low = {
        hc = 46, 
        muilt = 100
    }
};
local v1222 = {
    close = {
        dmg = 92, 
        dist = 30
    }, 
    mid = {
        dmg = 91, 
        dist = 90
    }, 
    far = {
        dmg = 90, 
        dist = 999
    }
};
local function v1224(v1223)
    -- upvalues: l_rage_0 (ref)
    l_rage_0.hitbox:override(table.unpack(v1223.hitbox));
    l_rage_0.dmg:override(v1223.dmg);
    l_rage_0.body_muilt:override(v1223.muilt);
    l_rage_0.hc:override(v1223.hc);
    l_rage_0.sp:override(v1223.sp);
    l_rage_0.sp_en:override(v1223.sp_en);
end;
v1216.on_createmove = function(_)
    -- upvalues: l_config_sub_0 (ref), v1220 (ref), l_rage_0 (ref), l_rage_lethal_sub_1_0 (ref), v1221 (ref), v71 (ref), v1222 (ref), v1224 (ref)
    if not l_config_sub_0.rage.lethal:get() then
        return v1220();
    elseif l_config_sub_0.rage_lethal.mode:get() == "Manual" then
        local v1226 = entity.get_local_player();
        if not v1226 or not v1226:is_alive() then
            return v1220();
        else
            local v1227 = entity.get_threat();
            if not v1227 or v1227.m_iHealth > l_config_sub_0.rage_lethal_sub.enemy_hp:get() then
                return v1220();
            else
                local v1228 = {};
                local v1229 = l_config_sub_0.rage_lethal_sub.hitbox:get();
                if type(v1229) == "table" then
                    local v1230 = {
                        [1] = "Chest", 
                        [2] = "Stomach", 
                        [3] = "Legs", 
                        [4] = "Feet"
                    };
                    for v1231, v1232 in ipairs(v1230) do
                        if v1229[v1231] then
                            v1228[#v1228 + 1] = v1232;
                        end;
                    end;
                else
                    v1228[1] = v1229;
                end;
                if #v1228 == 0 then
                    v1228 = {
                        [1] = "Stomach"
                    };
                end;
                local v1233 = l_config_sub_0.rage_lethal_sub.dmg:get();
                local v1234 = l_config_sub_0.rage_lethal_sub.hc:get();
                local v1235 = l_config_sub_0.rage_lethal_sub.scale:get();
                l_rage_0.hitbox:override(table.unpack(v1228));
                l_rage_0.dmg:override(v1233 > 0 and v1233 or nil);
                l_rage_0.hc:override(v1234 > 0 and v1234 or nil);
                l_rage_0.body_muilt:override(v1235 > 0 and v1235 or nil);
                l_rage_0.sp:override(nil);
                l_rage_0.sp_en:override(nil);
                return;
            end;
        end;
    elseif not l_config_sub_0.rage.lethal:get() then
        return v1220();
    else
        local v1236 = entity.get_local_player();
        if not v1236 or not v1236:is_alive() then
            return v1220();
        else
            local v1237 = v1236:get_player_weapon();
            if not v1237 or v1237:get_weapon_index() ~= 40 then
                return v1220();
            else
                local v1238 = entity.get_threat();
                if not v1238 then
                    return v1220();
                elseif v1238.m_iHealth > l_rage_lethal_sub_1_0.enemyhp:get() then
                    return v1220();
                else
                    for _, v1240 in ipairs(ui.get_binds()) do
                        if v1240.reference:id() == 3865218783 and v1240.active then
                            return v1220();
                        end;
                    end;
                    local v1241 = v1221[l_rage_lethal_sub_1_0.accuracy:get()] or v1221.Max;
                    local v1242 = l_rage_lethal_sub_1_0.exclude:get();
                    local v1243 = v71.to_foot((v1236:get_origin() - v1238:get_origin()):length());
                    local l_m_iHealth_1 = v1238.m_iHealth;
                    if v1243 > 53 and (v1238.m_ArmorValue or 0) > 0 and l_m_iHealth_1 >= 87 then
                        return v1220();
                    elseif l_m_iHealth_1 == 91 and (v1238.m_ArmorValue or 0) > 0 and v1243 > 40 then
                        return v1220();
                    elseif l_m_iHealth_1 == 92 and (v1238.m_ArmorValue or 0) > 0 and v1222.close.dist < v1243 then
                        return v1220();
                    else
                        local v1245 = 1 - math.clamp(v1243 / v1222.mid.dist, 0, 1);
                        local v1246 = math.clamp(l_m_iHealth_1 / 92, 0, 1);
                        local v1247 = v1243 <= v1222.close.dist and v1222.close or v1243 <= v1222.mid.dist and v1222.mid or v1222.far;
                        local v1248 = l_rage_lethal_sub_1_0.accuracy:get() or "Max";
                        local v1249 = v1248 == "Max" and {
                            [1] = "Arms", 
                            [2] = "Legs", 
                            [3] = "Feet"
                        } or nil;
                        local v1250 = {
                            [1] = "Chest", 
                            [2] = "Stomach"
                        };
                        if v1242 then
                            table.remove(v1250, 1);
                        end;
                        local v1251 = math.clamp(v1241.hc - math.round(v1245 * 10 + v1246 * 5), 1, 100);
                        local v1252 = math.max(l_m_iHealth_1 + 2, v1247.dmg + math.round(v1245 * 8 + v1246 * 6));
                        if l_m_iHealth_1 >= 80 and l_m_iHealth_1 <= 86 then
                            v1252 = l_m_iHealth_1;
                        end;
                        local v1253 = "";
                        v1253 = v1248 == "Max" and "Force" or v1248 == "High" and "Prefer" or nil;
                        v1224({
                            hitbox = v1250, 
                            hc = v1251, 
                            dmg = v1252, 
                            muilt = v1241.muilt, 
                            sp = v1253, 
                            sp_en = v1249
                        });
                        return;
                    end;
                end;
            end;
        end;
    end;
end;
v64[#v64 + 1] = v1216;
local v1254 = {};
local l_rage_1 = v15.rage;
local l_dynamic_0 = l_config_sub_0.rage.dynamic;
local v1257 = {
    [1] = {
        vmin = 0, 
        s_max = 76, 
        s_min = 68, 
        vmax = 40
    }, 
    [2] = {
        vmin = 40, 
        s_max = 76, 
        s_min = 68, 
        vmax = 80
    }, 
    [3] = {
        vmin = 80, 
        s_max = 85, 
        s_min = 70, 
        vmax = 110
    }, 
    [4] = {
        vmin = 110, 
        s_max = 80, 
        s_min = 60, 
        vmax = 200
    }, 
    [5] = {
        vmin = 200, 
        s_max = 70, 
        s_min = 52, 
        vmax = 240
    }, 
    [6] = {
        vmin = 240, 
        s_max = 65, 
        s_min = 50, 
        vmax = 9999
    }
};
local function v1258()
    -- upvalues: l_rage_1 (ref)
    l_rage_1.s_head_scale:override();
end;
v1254.get_target_scale = function(_, v1260)
    -- upvalues: v1257 (ref)
    for _, v1262 in ipairs(v1257) do
        if v1262.vmin <= v1260 and v1260 < v1262.vmax then
            local v1263 = (v1260 - v1262.vmin) / (v1262.vmax - v1262.vmin);
            local v1264 = math.lerp(v1262.s_min, v1262.s_max, v1263);
            return math.clamp(v1264, 0, 95);
        end;
    end;
    return 95;
end;
v1254.main = function(v1265)
    -- upvalues: l_dynamic_0 (ref), v1258 (ref), v10 (ref), l_rage_1 (ref)
    if not l_dynamic_0:get() then
        return v1258();
    else
        local v1266 = entity.get_local_player();
        if not v1266 or not v1266:is_alive() then
            return v1258();
        else
            local v1267 = v1266:get_player_weapon();
            if not v1267 or v1267:get_weapon_index() ~= 40 then
                return v1258();
            else
                local l_m_vecVelocity_2 = v1266.m_vecVelocity;
                local v1269 = v1265:get_target_scale((math.floor(math.sqrt(l_m_vecVelocity_2.x ^ 2 + l_m_vecVelocity_2.y ^ 2))));
                local v1270 = v10.anim_new("scout_head_scale", v1269, nil, 0.08);
                local v1271 = math.floor(v1270 + 0.5);
                l_rage_1.s_head_scale:override(v1271);
                return;
            end;
        end;
    end;
end;
v1254.on_createmove = function(v1272)
    v1272:main();
end;
v64[#v64 + 1] = v1254;
local function v1280(v1273, v1274, v1275, v1276)
    local v1277 = color(0, v1276.a);
    local l_v1274_0 = v1274;
    local l_v1275_0 = v1275;
    render.line(vector(v1273.x - l_v1274_0 - 1, v1273.y - l_v1274_0 - 1), vector(v1273.x - l_v1275_0 + 1, v1273.y - l_v1275_0 + 1), v1277);
    render.line(vector(v1273.x - l_v1274_0, v1273.y - l_v1274_0), vector(v1273.x - l_v1275_0, v1273.y - l_v1275_0), v1276);
    render.line(vector(v1273.x - l_v1274_0 - 1, v1273.y + l_v1274_0 + 1), vector(v1273.x - l_v1275_0 + 1, v1273.y + l_v1275_0 - 1), v1277);
    render.line(vector(v1273.x - l_v1274_0, v1273.y + l_v1274_0), vector(v1273.x - l_v1275_0, v1273.y + l_v1275_0), v1276);
    render.line(vector(v1273.x + l_v1274_0 + 1, v1273.y - l_v1274_0 - 1), vector(v1273.x + l_v1275_0 - 1, v1273.y - l_v1275_0 + 1), v1277);
    render.line(vector(v1273.x + l_v1274_0, v1273.y - l_v1274_0), vector(v1273.x + l_v1275_0, v1273.y - l_v1275_0), v1276);
    render.line(vector(v1273.x + l_v1274_0 + 1, v1273.y + l_v1274_0 + 1), vector(v1273.x + l_v1275_0 - 1, v1273.y + l_v1275_0 - 1), v1277);
    render.line(vector(v1273.x + l_v1274_0, v1273.y + l_v1274_0), vector(v1273.x + l_v1275_0, v1273.y + l_v1275_0), v1276);
end;
local v1292 = {
    on_render = function(_)
        -- upvalues: l_config_sub_0 (ref), v11 (ref), v1280 (ref)
        if not l_config_sub_0.visual.world:get() then
            return;
        else
            local v1282 = l_config_sub_0.visual_world_sub.fade:get() / 10;
            local _ = l_config_sub_0.visual_world_sub.wait:get() / 10;
            local v1284 = l_config_sub_0.visual_world_sub.color:get();
            local v1285 = l_config_sub_0.visual_world_sub.start_pos:get();
            local v1286 = l_config_sub_0.visual_world_sub.end_pos:get();
            for v1287, v1288 in pairs(v11) do
                if v1288.fade <= 0 then
                    v11[v1287] = nil;
                else
                    v1288.wait = v1288.wait - globals.frametime;
                    if v1288.wait <= 0 then
                        local v1289 = l_config_sub_0.visual_world_sub.speed:get();
                        v1288.fade = v1288.fade - v1289 / v1282 * globals.frametime;
                    end;
                    if v1288.pos and not v1288.reason then
                        local v1290 = render.world_to_screen(v1288.pos);
                        if v1290 then
                            local v1291 = color(v1284.r, v1284.g, v1284.b, math.floor(v1284.a * v1288.fade));
                            v1280(v1290, v1285, v1286, v1291);
                        end;
                    end;
                end;
            end;
            return;
        end;
    end
};
local v1293 = {
    Neverlose = v307.verdana_nl, 
    Onetap = v307.verdana_op, 
    Seoge = v307.seoge_s, 
    Gabriola = v307.gabriola, 
    Comic = v307.comic
};
local v1308 = {
    on_render = function(_)
        -- upvalues: l_config_sub_0 (ref), v1293 (ref), v307 (ref), v12 (ref)
        if not l_config_sub_0.visual.damage:get() then
            return;
        else
            local v1295 = entity.get_local_player();
            if not v1295 or not v1295:is_alive() then
                return;
            else
                local _ = l_config_sub_0.visual_damage_sub.wait:get() / 10;
                local v1297 = l_config_sub_0.visual_damage_sub.fade:get() / 10;
                local v1298 = l_config_sub_0.visual_damage_sub.color:get("Body")[1];
                local v1299 = l_config_sub_0.visual_damage_sub.color:get("Head")[1];
                local v1300 = v1293[l_config_sub_0.visual_damage_sub.type:get()] or v307.pixel;
                for v1301, v1302 in pairs(v12) do
                    if v1302.fade <= 0 then
                        v12[v1301] = nil;
                    else
                        v1302.wait = v1302.wait - globals.frametime;
                        if v1302.wait <= 0 then
                            v1302.fade = v1302.fade - l_config_sub_0.visual_damage_sub.speed:get() / v1297 * globals.frametime;
                        end;
                        local v1303 = render.world_to_screen(v1302.pos);
                        if v1303 and v1302.reason == nil then
                            local v1304 = v1303.x + l_config_sub_0.visual_damage_sub.width:get();
                            local v1305 = v1303.y + l_config_sub_0.visual_damage_sub.height:get();
                            local v1306 = v1302.hitgroup ~= 1 and v1298 or v1299;
                            local v1307 = color(v1306.r, v1306.g, v1306.b, math.floor(v1306.a * v1302.fade));
                            render.text(v1300, vector(v1304, v1305), v1307, "c", tostring(v1302.dmg));
                        end;
                    end;
                end;
                return;
            end;
        end;
    end
};
events.aim_ack:set(function(v1309)
    -- upvalues: v11 (ref), l_config_sub_0 (ref), v12 (ref)
    v11[v1309.id] = {
        fade = 1, 
        pos = v1309.aim, 
        dmg = v1309.damage, 
        wait = l_config_sub_0.visual_world_sub.wait:get() / 10, 
        hitgroup = v1309.hitgroup, 
        reason = v1309.state
    };
    v12[v1309.id] = {
        fade = 1, 
        pos = v1309.aim, 
        dmg = v1309.damage, 
        wait = l_config_sub_0.visual_damage_sub.wait:get() / 10, 
        hitgroup = v1309.hitgroup, 
        reason = v1309.state
    };
end);
v64[#v64 + 1] = setmetatable(v1292, {
    __call = v1292.on_render
});
v64[#v64 + 1] = setmetatable(v1308, {
    __call = v1308.on_render
});
local v1310 = nil;
v1310 = {};
local v1311 = {};
local v1312 = nil;
local v1313 = nil;
local v1314 = ui.create("Windows"):visibility(false);
local function v1318(v1315)
    local l_status_4, l_result_4 = pcall(json.parse, v1315);
    if not l_status_4 then
        return nil;
    else
        return l_result_4;
    end;
end;
local v1319 = {
    mouse_pos = vector(), 
    mouse_pos_prev = vector(), 
    mouse_down = false, 
    mouse_clicked = false, 
    mouse_down_duration = 0, 
    mouse_delta = vector(), 
    mouse_clicked_pos = vector()
};
do
    local l_v1311_0, l_v1312_0, l_v1313_0, l_v1314_0, l_v1318_0, l_v1319_0 = v1311, v1312, v1313, v1314, v1318, v1319;
    l_v1319_0.update_mouse_inputs = function()
        -- upvalues: l_v1319_0 (ref)
        local l_frametime_2 = globals.frametime;
        local v1327 = ui.get_mouse_position();
        local v1328 = common.is_button_down(1);
        l_v1319_0.mouse_pos_prev = l_v1319_0.mouse_pos;
        l_v1319_0.mouse_pos = v1327;
        l_v1319_0.mouse_delta = l_v1319_0.mouse_pos - l_v1319_0.mouse_pos_prev;
        l_v1319_0.mouse_down = v1328;
        l_v1319_0.mouse_clicked = v1328 and l_v1319_0.mouse_down_duration < 0;
        local l_l_v1319_0_0 = l_v1319_0;
        local v1330;
        if v1328 then
            if l_v1319_0.mouse_down_duration < 0 then
                v1330 = 0;
                goto label0 --[[  true, true  ]];
            else
                v1330 = l_v1319_0.mouse_down_duration + l_frametime_2;
                if v1330 then
                    goto label0;
                end;
            end;
        end;
        v1330 = -1;
        ::label0::;
        l_l_v1319_0_0.mouse_down_duration = v1330;
        if l_v1319_0.mouse_clicked then
            l_v1319_0.mouse_clicked_pos = l_v1319_0.mouse_pos;
        end;
    end;
    local v1331 = {};
    v1331.__index = v1331;
    v1331.__new = function(v1332, v1333, v1334)
        -- upvalues: l_v1314_0 (ref)
        if type(v1334) ~= "table" then
            v1334 = {};
        end;
        return setmetatable({
            is_hovered = false, 
            is_active = true, 
            item = l_v1314_0:value(v1333, ""), 
            is_clamped = v1334.clamped == true, 
            pos = vector(), 
            size = vector(), 
            anchor = vector()
        }, v1332);
    end;
    v1331.get_pos = function(v1335)
        return v1335.pos;
    end;
    v1331.set_pos = function(v1336, v1337)
        local v1338 = render.screen_size();
        local v1339 = v1337:clone();
        if v1336.is_clamped then
            v1339.x = math.clamp(v1339.x, 0, v1338.x - v1336.size.x);
            v1339.y = math.clamp(v1339.y, 0, v1338.y - v1336.size.y);
        end;
        if v1336.pos ~= v1339 then
            v1336.item:set(json.stringify({
                x = v1339.x + v1336.size.x * v1336.anchor.x, 
                y = v1339.y + v1336.size.y * v1336.anchor.y
            }));
        end;
        v1336.pos = v1339;
        return v1336;
    end;
    v1331.get_size = function(v1340)
        return v1340.size;
    end;
    v1331.set_size = function(v1341, v1342)
        local v1343 = v1342 - v1341.size;
        local v1344 = v1341.pos - v1343 * v1341.anchor;
        v1341.size = v1342;
        v1341:set_pos(v1344);
        return v1341;
    end;
    v1331.get_anchor = function(v1345)
        return v1345.anchor;
    end;
    v1331.set_anchor = function(v1346, v1347)
        v1346.anchor = v1347;
        return v1346;
    end;
    v1331.build = function(v1348)
        -- upvalues: l_v1318_0 (ref), l_v1311_0 (ref)
        local v1349 = v1348.item:get();
        local v1350 = l_v1318_0(v1349);
        if v1350 ~= nil and v1350.x ~= nil and v1350.y ~= nil then
            v1348.pos = vector(v1350.x, v1350.y);
        end;
        table.insert(l_v1311_0, v1348);
        return v1348;
    end;
    local function v1354(v1351, v1352, v1353)
        return v1351.x >= v1352.x and v1351.x <= v1353.x and v1351.y >= v1352.y and v1351.y <= v1353.y;
    end;
    local function v1360()
        -- upvalues: l_v1311_0 (ref), v1354 (ref), l_v1319_0 (ref), l_v1312_0 (ref)
        local v1355 = nil;
        if ui.get_alpha() > 0 then
            for v1356 = 1, #l_v1311_0 do
                local v1357 = l_v1311_0[v1356];
                local l_pos_0 = v1357.pos;
                local l_size_0 = v1357.size;
                if v1357.is_active and v1354(l_v1319_0.mouse_pos, l_pos_0, l_pos_0 + l_size_0) then
                    v1355 = v1357;
                end;
            end;
        end;
        l_v1312_0 = v1355;
    end;
    local function v1361()
        -- upvalues: l_v1319_0 (ref), l_v1313_0 (ref), l_v1312_0 (ref)
        if not l_v1319_0.mouse_down then
            l_v1313_0 = nil;
            return;
        else
            if l_v1319_0.mouse_clicked and l_v1312_0 ~= nil then
                l_v1313_0 = l_v1312_0;
            end;
            return;
        end;
    end;
    local function v1364()
        -- upvalues: l_v1311_0 (ref)
        for v1362 = 1, #l_v1311_0 do
            local v1363 = l_v1311_0[v1362];
            v1363.is_dragged = false;
            v1363.is_hovered = false;
        end;
    end;
    local function v1365()
        -- upvalues: l_v1312_0 (ref)
        if l_v1312_0 == nil then
            return;
        else
            l_v1312_0.is_hovered = true;
            return;
        end;
    end;
    local function v1367()
        -- upvalues: l_v1313_0 (ref), l_v1319_0 (ref)
        if l_v1313_0 == nil then
            return;
        else
            local v1366 = l_v1313_0.pos + l_v1319_0.mouse_delta;
            l_v1313_0:set_pos(v1366);
            l_v1313_0.is_dragged = true;
            return;
        end;
    end;
    local function v1368()
        -- upvalues: l_v1319_0 (ref), v1360 (ref), v1361 (ref), v1364 (ref), v1365 (ref), v1367 (ref)
        l_v1319_0.update_mouse_inputs();
        v1360();
        v1361();
        v1364();
        v1365();
        v1367();
    end;
    local function v1370(v1369)
        -- upvalues: l_v1313_0 (ref), l_v1312_0 (ref)
        if not (l_v1313_0 ~= nil or l_v1312_0 ~= nil) then
            return;
        else
            v1369.in_attack = false;
            v1369.in_attack2 = false;
            return;
        end;
    end;
    v1310.new = function(v1371, v1372)
        -- upvalues: v1331 (ref)
        return v1331:__new(v1371, v1372);
    end;
    events.render(v1368);
    events.createmove(v1370);
end;
v1311 = {};
v1312 = 4;
v1313 = 4;
v1314 = render.screen_size();
v1318 = {
    Bold = 4, 
    Big = v307.big, 
    Pixel = v307.pixel, 
    Medium = v307.medium
};
v1319 = v1310.new("damage_indicator", {
    clamped = true
}):set_anchor(vector(0, 1)):set_pos(vector(v1314.x * 0.5 + 12, v1314.y * 0.5 - 12)):build();
local function v1374()
    -- upvalues: v15 (ref)
    local v1373 = v15.rage.dmg:get_override() or v15.rage.dmg:get();
    if v1373 == 0 then
        return "Auto";
    elseif v1373 > 100 then
        return "+" .. v1373 - 100;
    else
        return tostring(v1373);
    end;
end;
v1311.on_render = function(_)
    -- upvalues: l_config_sub_0 (ref), v1318 (ref), v1374 (ref), v1312 (ref), v1313 (ref), v1319 (ref)
    if not l_config_sub_0.visual.dmg_ind:get() then
        return;
    else
        local v1376 = entity.get_local_player();
        if not v1376 or not v1376:is_alive() then
            return;
        else
            local v1377 = l_config_sub_0.visual_damage_ind.color:get();
            local v1378 = v1318[l_config_sub_0.visual_damage_ind.type:get()] or v1318.Default;
            local v1379 = v1374();
            local v1380 = render.measure_text(v1378, "", v1379) + vector(v1312, v1313) * 2 + vector(1, 0);
            local v1381 = ui.get_alpha() > 0;
            local l_is_dragged_0 = v1319.is_dragged;
            local v1383;
            if v1381 then
                v1383 = l_is_dragged_0 and 0.5 or 1;
            else
                v1383 = 0;
            end;
            local v1384 = 1;
            local v1385 = v1319:get_pos();
            if v1383 > 0.02 then
                local v1386 = color(200, 200, 200, math.floor(128 * v1383));
                render.rect_outline(v1385, v1385 + v1380, v1386, 1, 4);
            end;
            local v1387 = color(v1377.r, v1377.g, v1377.b, math.floor(v1377.a * v1384));
            render.text(v1378, v1385 + v1380 * 0.5 + vector(1, 0), v1387, "cs", v1379);
            v1319:set_size(v1380);
            return;
        end;
    end;
end;
v64[#v64 + 1] = setmetatable(v1311, {
    __call = v1311.on_render
});
local v1392 = {
    main = function(_, v1389)
        -- upvalues: l_config_sub_0 (ref), v65 (ref), v71 (ref)
        if not l_config_sub_0.misc.dropnade:get() then
            return;
        elseif globals.curtime < v65.nade.until_drop then
            v1389.in_use = 1;
            return;
        else
            if l_config_sub_0.misc_sub.nade_key:get() and v65.nade.timer < 1 then
                v65.nade.timer = v65.nade.timer + 1;
                if l_config_sub_0.misc_sub.nade_select:get("Smoke") then
                    v71.dropGrenade("use weapon_knife;use weapon_smokegrenade;drop", 0.15);
                end;
                if l_config_sub_0.misc_sub.nade_select:get("Molotov") then
                    v71.dropGrenade("use weapon_knife;use weapon_molotov;use weapon_incgrenade;drop", 0.2);
                end;
                if l_config_sub_0.misc_sub.nade_select:get("Grenade") then
                    v71.dropGrenade("use weapon_knife;use weapon_hegrenade;drop", 0.1);
                end;
            elseif not l_config_sub_0.misc_sub.nade_key:get() and v65.nade.timer >= 1 then
                v65.nade.timer = 0;
            end;
            return;
        end;
    end, 
    on_createmove = function(v1390, v1391)
        v1390:main(v1391);
    end
};
v64[#v64 + 1] = v1392;
local v1402 = {
    main = function(_)
        -- upvalues: l_config_sub_0 (ref)
        local v1394 = entity.get_local_player():get_player_weapon();
        if not v1394 or v1394 == nil then
            return;
        else
            if l_config_sub_0.visual.viewmodel:get() then
                cvar.viewmodel_fov:int(l_config_sub_0.visual_viewmodel_sub.fov:get(), true);
                cvar.viewmodel_offset_x:float(l_config_sub_0.visual_viewmodel_sub.x:get() / 20, true);
                cvar.viewmodel_offset_y:float(l_config_sub_0.visual_viewmodel_sub.y:get() / 20, true);
                cvar.viewmodel_offset_z:float(l_config_sub_0.visual_viewmodel_sub.z:get() / 20, true);
                local v1395 = l_config_sub_0.visual_viewmodel_sub.hand:get();
                local v1396 = v1394:get_classname() == "CKnife";
                local l_cl_righthand_0 = cvar.cl_righthand;
                local l_l_cl_righthand_0_0 = l_cl_righthand_0;
                l_cl_righthand_0 = l_cl_righthand_0.int;
                local v1399 = nil;
                if v1396 then
                    v1399 = v1395 == "Right" and l_config_sub_0.visual_viewmodel_sub.knfie_l:get() and 0 or v1395 == "Left" and l_config_sub_0.visual_viewmodel_sub.knfie_r:get() and 1 or v1395 == "Right" and 1 or 0;
                else
                    v1399 = v1395 == "Right" and 1 or 0;
                end;
                l_cl_righthand_0(l_l_cl_righthand_0_0, v1399);
            else
                cvar.viewmodel_fov:int(60);
                cvar.viewmodel_offset_x:float(1);
                cvar.viewmodel_offset_y:float(1);
                cvar.viewmodel_offset_z:float(-1.5);
            end;
            return;
        end;
    end, 
    on_createmove = function(v1400)
        v1400:main();
    end, 
    on_shutdown = function(_)
        cvar.viewmodel_fov:int(60);
        cvar.viewmodel_offset_x:float(1);
        cvar.viewmodel_offset_y:float(1);
        cvar.viewmodel_offset_z:float(-1.5);
    end
};
v64[#v64 + 1] = v1402;
local _ = nil;
local v1404 = ffi.typeof("        struct {\n            float  m_flLayerAnimtime;\n            float  m_flLayerFadeOuttime;\n\n            // dispatch flags\n            void  *m_pDispatchedStudioHdr;\n            int    m_nDispatchedSrc;\n            int    m_nDispatchedDst;\n\n            int    m_nOrder;\n            int    m_nSequence;\n            float  m_flPrevCycle;\n            float  m_flWeight;\n            float  m_flWeightDeltaRate;\n\n            // used for automatic crossfades between sequence changes;\n            float  m_flPlaybackRate;\n            float  m_flCycle;\n            int    m_pOwner;\n            int    m_nInvalidatePhysicsBits;\n        } **\n    ");
do
    local l_v1404_0 = v1404;
    local function v1407(v1406)
        -- upvalues: l_v1404_0 (ref)
        return ffi.cast(l_v1404_0, ffi.cast("uintptr_t", v1406[0]) + 10640)[0];
    end;
    local function v1412(v1408, v1409)
        -- upvalues: l_config_sub_0 (ref)
        local v1410 = l_config_sub_0.misc_animation_sub.inair:get();
        if v1410 == "Static" then
            v1408.m_flPoseParameter[6] = 100 * 0.01;
            return;
        elseif v1410 == "Moonwalk" then
            local v1411 = v1409[6];
            v1411.m_flWeight = 1;
            v1411.m_flCycle = globals.curtime * 0.55 % 1;
            return;
        else
            return;
        end;
    end;
    local function v1421(v1413, _)
        -- upvalues: l_config_sub_0 (ref), v15 (ref)
        local v1415 = l_config_sub_0.misc_animation_sub.onground:get();
        if v1415 == "Static" then
            v1413.m_flPoseParameter[0] = 1;
            v15.aa.leg:override("Sliding");
            return;
        elseif v1415 == "Jitter" then
            local l_tickcount_2 = globals.tickcount;
            local v1417 = l_config_sub_0.misc_animation_sub.speed_1:get();
            local v1418 = l_config_sub_0.misc_animation_sub.speed_2:get();
            local v1419 = 1 / (l_tickcount_2 % 8 >= 4 and 200 or 400);
            local v1420 = l_tickcount_2 % 4 >= 2 and v1417 or v1418;
            v1413.m_flPoseParameter[0] = v1420 * v1419;
            v15.aa.leg:override("Sliding");
            return;
        elseif v1415 == "Moonwalk" then
            v1413.m_flPoseParameter[7] = 0;
            v15.aa.leg:override("Walking");
            return;
        else
            v15.aa.leg:override();
            return;
        end;
    end;
    local function v1424(v1422, v1423)
        -- upvalues: l_config_sub_0 (ref)
        if l_config_sub_0.misc_animation_sub.misc:get("Pitch Zero") then
            if v1423.landing then
                v1422.m_flPoseParameter[12] = 0.5;
            end;
            return;
        else
            return;
        end;
    end;
    local function v1426(v1425)
        -- upvalues: l_config_sub_0 (ref)
        if l_config_sub_0.misc_animation_sub.misc:get("Earthquake") then
            v1425[12].m_flWeight = utils.random_float(0, 1);
            return;
        else
            return;
        end;
    end;
    local function v1428(v1427)
        -- upvalues: l_config_sub_0 (ref)
        if l_config_sub_0.misc_animation_sub.misc:get("Static Slow Walk") then
            v1427.m_flPoseParameter[9] = 0;
            return;
        else
            return;
        end;
    end;
    local function v1433(v1429)
        -- upvalues: v1407 (ref), v675 (ref), v1421 (ref), v1424 (ref), v1412 (ref), v1428 (ref), v1426 (ref)
        if v1429 ~= entity.get_local_player() then
            return;
        else
            local v1430 = v1429:get_anim_state();
            if v1430 == nil then
                return;
            else
                local v1431 = v1407(v1429);
                if v1431 == nil then
                    return;
                else
                    local v1432 = v675.get_state();
                    if v1432 == "moving" or v1432 == "slow" or v1432 == "stand" or v1432 == "crough" or v1432 == "sneak" then
                        v1421(v1429, v1431);
                        v1424(v1429, v1430);
                    elseif v1432 == "air" or v1432 == "airduck" or v1432 == "airknife" or v1432 == "airtaser" then
                        v1412(v1429, v1431);
                    end;
                    if v1432 == "slow" then
                        v1428(v1429);
                    end;
                    v1426(v1431);
                    return;
                end;
            end;
        end;
    end;
    l_config_sub_0.misc.animation:set_callback(function(v1434)
        -- upvalues: v15 (ref), v1433 (ref)
        local v1435 = v1434:get();
        if not v1435 then
            v15.aa.leg:override();
        end;
        events.post_update_clientside_animation(v1433, v1435);
    end, true);
end;
v1404 = "Trashhode.txt";
local v1436 = {
    configs = {}
};
local v1437 = {
    Tank = "{Trashhode:config}:W3sicGFnZSI6Mi4wfSx7ImFsbF9zZXQiOnsiYXRfdGFyZ2V0Ijp0cnVlLCJhdm9pZCI6dHJ1ZSwicGl0Y2giOiJEb3duIn0sImNvbmRpdGlvbiI6eyJjbmRfbGlzdCI6IkNyb3VjaGluZyJ9LCJmYWtlbGFnIjp7ImZvcmNlIjpmYWxzZSwibGltaXQiOjEuMCwibWF4IjoxLjAsIm1pbiI6MS4wLCJtb2RlIjoiTmV2ZXJsb3NlIiwibmFkZSI6ZmFsc2UsInN0ZXAiOjEuMH0sImZha2VsYWdfZW5hYmxlIjp7ImVuYWJsZSI6ZmFsc2UsIm9uc2hvdCI6ZmFsc2V9LCJmYWtlbGFnX3Nob3QiOnsic2hvdF9vcHRpbXplZCI6WyJ+Il0sInNob3RfcGVlayI6ZmFsc2UsInNob3RfcGVla19jaG9rZSI6ZmFsc2V9LCJnZW5lcmFsIjp7Im1hc3RlciI6dHJ1ZSwicGFnZSI6MS4wfSwic2V0Ijp7ImFpbXRpY2siOnRydWUsImF1dG9ocyI6dHJ1ZSwiZmFzdGxhZGRlciI6ZmFsc2UsImZkc3BlZWQiOnRydWUsImZyZWVzdGFuZCI6ZmFsc2UsIm1hbnVhbCI6IkRpc2FibGVkIn0sInNldF9zdWIiOnsiZnNfb3AiOlsxLjAsMi4wLCJ+Il0sIm1hbnVhbF9vcCI6WzEuMCwyLjAsMy4wLCJ+Il19fSx7ImFpciI6eyJkZWZlbnNpdmUiOmZhbHNlLCJkZWZlbnNpdmVfZmxpY2tfdHJpZ2dlciI6IlRpY2tjb3VudCIsImRlZmVuc2l2ZV9tb2RlIjoiQ3VzdG9tIiwiZGVmZW5zaXZlX21vZGVfY2hlY2siOiJUaWNrYmFzZSIsImRlZmVuc2l2ZV9tb2RlX21heCI6MTUuMCwiZGVmZW5zaXZlX21vZGVfbWluIjozLjAsImRlZmVuc2l2ZV9tb2RlX3RpY2siOjguMCwiZGVmZW5zaXZlX29ucGVlayI6ZmFsc2UsImRlZmVuc2l2ZV9waXRjaCI6IlN0YXRpYyIsImRlZmVuc2l2ZV9waXRjaF9qaXR0ZXJfc3BlZWQiOjEuMCwiZGVmZW5zaXZlX3BpdGNoX21heCI6MC4wLCJkZWZlbnNpdmVfcGl0Y2hfbWF4XzIiOjAuMCwiZGVmZW5zaXZlX3BpdGNoX21pbiI6MC4wLCJkZWZlbnNpdmVfcGl0Y2hfbWluXzIiOjAuMCwiZGVmZW5zaXZlX3BpdGNoX3NwZWVkIjoxLjAsImRlZmVuc2l2ZV9waXRjaF9zdGF0aWMiOjAuMCwiZGVmZW5zaXZlX3BpdGNoX3N3aXRjaCI6MS4wLCJkZWZlbnNpdmVfeWF3IjoiV3JhaXRoIiwiZGVmZW5zaXZlX3lhd19hZGFwdGl2ZSI6MC4wLCJkZWZlbnNpdmVfeWF3X2N5Y2xlX2ludmVydCI6ZmFsc2UsImRlZmVuc2l2ZV95YXdfZmxpY2siOmZhbHNlLCJkZWZlbnNpdmVfeWF3X2Z1bGwiOjAuMCwiZGVmZW5zaXZlX3lhd19qaXR0ZXJfc3BlZWQiOjEuMCwiZGVmZW5zaXZlX3lhd19tYXgiOjE4MC4wLCJkZWZlbnNpdmVfeWF3X21heF8yIjowLjAsImRlZmVuc2l2ZV95YXdfbWluIjotMTgwLjAsImRlZmVuc2l2ZV95YXdfbWluXzIiOjAuMCwiZGVmZW5zaXZlX3lhd19zcGVlZCI6MjAuMCwiZGVmZW5zaXZlX3lhd19zdGF0aWMiOjAuMCwiZGVmZW5zaXZlX3lhd19zd2l0Y2giOjEuMCwiZGVsYXlfYmFzZSI6ZmFsc2UsImRlbGF5X2N5Y2xlX3NwZWVkIjoxLjAsImRlbGF5X2ppdHRlcnRpY2tfcmVwZWF0IjoxMC4wLCJkZWxheV9tYXhfdGljayI6MS4wLCJkZWxheV9taW5fdGljayI6MS4wLCJkZWxheV9tb2RlIjoiU3RhdGljIiwiZGVsYXlfc3RhdGljX3RpY2siOjEuMCwiZGVzeW5jIjoiU3RhdGljIiwiZGVzeW5jX2FuZ2xlbW9kZSI6IkRpc2FibGVkIiwiZGVzeW5jX2FudGlfYnJ1IjpmYWxzZSwiZGVzeW5jX2ludmVydCI6ZmFsc2UsImRlc3luY19sZWZ0IjowLjAsImRlc3luY19wZXJpb2QiOmZhbHNlLCJkZXN5bmNfcmlnaHQiOjAuMCwiZGVzeW5jX3RpY2siOjQuMCwiZW5hYmxlIjp0cnVlLCJtb2RpZmllcl9tb2RlIjoiSml0dGVyIiwibW9kaWZpZXJfbW9kZV9vZmZzZXQiOjE5LjAsIm1vZGlmaWVyX3JhbmRvbSI6ZmFsc2UsIm1vZGlmaWVyX3JhbmRvbV9kZWZhdWx0IjowLjAsIm1vZGlmaWVyX3JhbmRvbV9tYXgiOjAuMCwibW9kaWZpZXJfcmFuZG9tX21pbiI6MC4wLCJtb2RpZmllcl9yYW5kb21fbW9kZSI6IkRlZmF1bHQiLCJtb2RpZmllcl9zd2F5X3NwZWVkIjoxLjAsInlhd19mbHVjdGF0ZSI6MC4wLCJ5YXdfZmx1Y3RhdGVfZW5hYmxlIjpmYWxzZSwieWF3X2xlZnQiOi0xNS4wLCJ5YXdfbW9kZSI6IkppdHRlciIsInlhd19vZmZzZXQiOjAuMCwieWF3X3JpZ2h0IjoyNy4wLCJ5YXdfdGFyZ2V0Ijo5LjB9LCJhaXJkdWNrIjp7ImRlZmVuc2l2ZSI6dHJ1ZSwiZGVmZW5zaXZlX2ZsaWNrX3RyaWdnZXIiOiJUaWNrY291bnQiLCJkZWZlbnNpdmVfbW9kZSI6Ik5ldmVybG9zZSIsImRlZmVuc2l2ZV9tb2RlX2NoZWNrIjoiVGlja2Jhc2UiLCJkZWZlbnNpdmVfbW9kZV9tYXgiOjAuMCwiZGVmZW5zaXZlX21vZGVfbWluIjowLjAsImRlZmVuc2l2ZV9tb2RlX3RpY2siOjguMCwiZGVmZW5zaXZlX29ucGVlayI6ZmFsc2UsImRlZmVuc2l2ZV9waXRjaCI6IlN0YXRpYyIsImRlZmVuc2l2ZV9waXRjaF9qaXR0ZXJfc3BlZWQiOjEuMCwiZGVmZW5zaXZlX3BpdGNoX21heCI6MC4wLCJkZWZlbnNpdmVfcGl0Y2hfbWF4XzIiOjAuMCwiZGVmZW5zaXZlX3BpdGNoX21pbiI6MC4wLCJkZWZlbnNpdmVfcGl0Y2hfbWluXzIiOjAuMCwiZGVmZW5zaXZlX3BpdGNoX3NwZWVkIjoxLjAsImRlZmVuc2l2ZV9waXRjaF9zdGF0aWMiOjQ1LjAsImRlZmVuc2l2ZV9waXRjaF9zd2l0Y2giOjEuMCwiZGVmZW5zaXZlX3lhdyI6IlJhbmRvbSBKaXR0ZXIiLCJkZWZlbnNpdmVfeWF3X2FkYXB0aXZlIjowLjAsImRlZmVuc2l2ZV95YXdfY3ljbGVfaW52ZXJ0IjpmYWxzZSwiZGVmZW5zaXZlX3lhd19mbGljayI6ZmFsc2UsImRlZmVuc2l2ZV95YXdfZnVsbCI6MzYwLjAsImRlZmVuc2l2ZV95YXdfaml0dGVyX3NwZWVkIjoxLjAsImRlZmVuc2l2ZV95YXdfbWF4IjowLjAsImRlZmVuc2l2ZV95YXdfbWF4XzIiOjAuMCwiZGVmZW5zaXZlX3lhd19taW4iOjAuMCwiZGVmZW5zaXZlX3lhd19taW5fMiI6MC4wLCJkZWZlbnNpdmVfeWF3X3NwZWVkIjoxLjAsImRlZmVuc2l2ZV95YXdfc3RhdGljIjowLjAsImRlZmVuc2l2ZV95YXdfc3dpdGNoIjoxLjAsImRlbGF5X2Jhc2UiOmZhbHNlLCJkZWxheV9jeWNsZV9zcGVlZCI6MS4wLCJkZWxheV9qaXR0ZXJ0aWNrX3JlcGVhdCI6MTAuMCwiZGVsYXlfbWF4X3RpY2siOjEuMCwiZGVsYXlfbWluX3RpY2siOjEuMCwiZGVsYXlfbW9kZSI6IlN0YXRpYyIsImRlbGF5X3N0YXRpY190aWNrIjoxLjAsImRlc3luYyI6IlN0YXRpYyIsImRlc3luY19hbmdsZW1vZGUiOiJEaXNhYmxlZCIsImRlc3luY19hbnRpX2JydSI6ZmFsc2UsImRlc3luY19pbnZlcnQiOmZhbHNlLCJkZXN5bmNfbGVmdCI6MC4wLCJkZXN5bmNfcGVyaW9kIjpmYWxzZSwiZGVzeW5jX3JpZ2h0IjowLjAsImRlc3luY190aWNrIjo0LjAsImVuYWJsZSI6dHJ1ZSwibW9kaWZpZXJfbW9kZSI6IkRpc2FibGVkIiwibW9kaWZpZXJfbW9kZV9vZmZzZXQiOjAuMCwibW9kaWZpZXJfcmFuZG9tIjpmYWxzZSwibW9kaWZpZXJfcmFuZG9tX2RlZmF1bHQiOjAuMCwibW9kaWZpZXJfcmFuZG9tX21heCI6MC4wLCJtb2RpZmllcl9yYW5kb21fbWluIjowLjAsIm1vZGlmaWVyX3JhbmRvbV9tb2RlIjoiRGVmYXVsdCIsIm1vZGlmaWVyX3N3YXlfc3BlZWQiOjEuMCwieWF3X2ZsdWN0YXRlIjowLjAsInlhd19mbHVjdGF0ZV9lbmFibGUiOmZhbHNlLCJ5YXdfbGVmdCI6MC4wLCJ5YXdfbW9kZSI6IkppdHRlciIsInlhd19vZmZzZXQiOjAuMCwieWF3X3JpZ2h0IjowLjAsInlhd190YXJnZXQiOjAuMH0sImFpcmtuaWZlIjp7ImRlZmVuc2l2ZSI6dHJ1ZSwiZGVmZW5zaXZlX2ZsaWNrX3RyaWdnZXIiOiJUaWNrY291bnQiLCJkZWZlbnNpdmVfbW9kZSI6Ik5ldmVybG9zZSIsImRlZmVuc2l2ZV9tb2RlX2NoZWNrIjoiVGlja2Jhc2UiLCJkZWZlbnNpdmVfbW9kZV9tYXgiOjAuMCwiZGVmZW5zaXZlX21vZGVfbWluIjowLjAsImRlZmVuc2l2ZV9tb2RlX3RpY2siOjguMCwiZGVmZW5zaXZlX29ucGVlayI6ZmFsc2UsImRlZmVuc2l2ZV9waXRjaCI6IkRpc2FibGVkIiwiZGVmZW5zaXZlX3BpdGNoX2ppdHRlcl9zcGVlZCI6MS4wLCJkZWZlbnNpdmVfcGl0Y2hfbWF4IjowLjAsImRlZmVuc2l2ZV9waXRjaF9tYXhfMiI6MC4wLCJkZWZlbnNpdmVfcGl0Y2hfbWluIjowLjAsImRlZmVuc2l2ZV9waXRjaF9taW5fMiI6MC4wLCJkZWZlbnNpdmVfcGl0Y2hfc3BlZWQiOjEuMCwiZGVmZW5zaXZlX3BpdGNoX3N0YXRpYyI6MC4wLCJkZWZlbnNpdmVfcGl0Y2hfc3dpdGNoIjoxLjAsImRlZmVuc2l2ZV95YXciOiJEaXNhYmxlZCIsImRlZmVuc2l2ZV95YXdfYWRhcHRpdmUiOjAuMCwiZGVmZW5zaXZlX3lhd19jeWNsZV9pbnZlcnQiOmZhbHNlLCJkZWZlbnNpdmVfeWF3X2ZsaWNrIjpmYWxzZSwiZGVmZW5zaXZlX3lhd19mdWxsIjowLjAsImRlZmVuc2l2ZV95YXdfaml0dGVyX3NwZWVkIjoxLjAsImRlZmVuc2l2ZV95YXdfbWF4IjowLjAsImRlZmVuc2l2ZV95YXdfbWF4XzIiOjAuMCwiZGVmZW5zaXZlX3lhd19taW4iOjAuMCwiZGVmZW5zaXZlX3lhd19taW5fMiI6MC4wLCJkZWZlbnNpdmVfeWF3X3NwZWVkIjoxLjAsImRlZmVuc2l2ZV95YXdfc3RhdGljIjowLjAsImRlZmVuc2l2ZV95YXdfc3dpdGNoIjoxLjAsImRlbGF5X2Jhc2UiOmZhbHNlLCJkZWxheV9jeWNsZV9zcGVlZCI6MS4wLCJkZWxheV9qaXR0ZXJ0aWNrX3JlcGVhdCI6MTAuMCwiZGVsYXlfbWF4X3RpY2siOjEuMCwiZGVsYXlfbWluX3RpY2siOjEuMCwiZGVsYXlfbW9kZSI6IlN0YXRpYyIsImRlbGF5X3N0YXRpY190aWNrIjoxLjAsImRlc3luYyI6IlN0YXRpYyIsImRlc3luY19hbmdsZW1vZGUiOiJEaXNhYmxlZCIsImRlc3luY19hbnRpX2JydSI6ZmFsc2UsImRlc3luY19pbnZlcnQiOmZhbHNlLCJkZXN5bmNfbGVmdCI6MC4wLCJkZXN5bmNfcGVyaW9kIjpmYWxzZSwiZGVzeW5jX3JpZ2h0IjowLjAsImRlc3luY190aWNrIjo0LjAsImVuYWJsZSI6dHJ1ZSwibW9kaWZpZXJfbW9kZSI6IkRpc2FibGVkIiwibW9kaWZpZXJfbW9kZV9vZmZzZXQiOjAuMCwibW9kaWZpZXJfcmFuZG9tIjpmYWxzZSwibW9kaWZpZXJfcmFuZG9tX2RlZmF1bHQiOjAuMCwibW9kaWZpZXJfcmFuZG9tX21heCI6MC4wLCJtb2RpZmllcl9yYW5kb21fbWluIjowLjAsIm1vZGlmaWVyX3JhbmRvbV9tb2RlIjoiRGVmYXVsdCIsIm1vZGlmaWVyX3N3YXlfc3BlZWQiOjEuMCwieWF3X2ZsdWN0YXRlIjowLjAsInlhd19mbHVjdGF0ZV9lbmFibGUiOmZhbHNlLCJ5YXdfbGVmdCI6MC4wLCJ5YXdfbW9kZSI6IkppdHRlciIsInlhd19vZmZzZXQiOjAuMCwieWF3X3JpZ2h0IjowLjAsInlhd190YXJnZXQiOjAuMH0sImFpcnRhc2VyIjp7ImRlZmVuc2l2ZSI6dHJ1ZSwiZGVmZW5zaXZlX2ZsaWNrX3RyaWdnZXIiOiJUaWNrY291bnQiLCJkZWZlbnNpdmVfbW9kZSI6Ik5ldmVybG9zZSIsImRlZmVuc2l2ZV9tb2RlX2NoZWNrIjoiVGlja2Jhc2UiLCJkZWZlbnNpdmVfbW9kZV9tYXgiOjAuMCwiZGVmZW5zaXZlX21vZGVfbWluIjowLjAsImRlZmVuc2l2ZV9tb2RlX3RpY2siOjguMCwiZGVmZW5zaXZlX29ucGVlayI6ZmFsc2UsImRlZmVuc2l2ZV9waXRjaCI6IkRpc2FibGVkIiwiZGVmZW5zaXZlX3BpdGNoX2ppdHRlcl9zcGVlZCI6MS4wLCJkZWZlbnNpdmVfcGl0Y2hfbWF4IjowLjAsImRlZmVuc2l2ZV9waXRjaF9tYXhfMiI6MC4wLCJkZWZlbnNpdmVfcGl0Y2hfbWluIjowLjAsImRlZmVuc2l2ZV9waXRjaF9taW5fMiI6MC4wLCJkZWZlbnNpdmVfcGl0Y2hfc3BlZWQiOjEuMCwiZGVmZW5zaXZlX3BpdGNoX3N0YXRpYyI6MC4wLCJkZWZlbnNpdmVfcGl0Y2hfc3dpdGNoIjoxLjAsImRlZmVuc2l2ZV95YXciOiJEaXNhYmxlZCIsImRlZmVuc2l2ZV95YXdfYWRhcHRpdmUiOjAuMCwiZGVmZW5zaXZlX3lhd19jeWNsZV9pbnZlcnQiOmZhbHNlLCJkZWZlbnNpdmVfeWF3X2ZsaWNrIjpmYWxzZSwiZGVmZW5zaXZlX3lhd19mdWxsIjowLjAsImRlZmVuc2l2ZV95YXdfaml0dGVyX3NwZWVkIjoxLjAsImRlZmVuc2l2ZV95YXdfbWF4IjowLjAsImRlZmVuc2l2ZV95YXdfbWF4XzIiOjAuMCwiZGVmZW5zaXZlX3lhd19taW4iOjAuMCwiZGVmZW5zaXZlX3lhd19taW5fMiI6MC4wLCJkZWZlbnNpdmVfeWF3X3NwZWVkIjoxLjAsImRlZmVuc2l2ZV95YXdfc3RhdGljIjowLjAsImRlZmVuc2l2ZV95YXdfc3dpdGNoIjoxLjAsImRlbGF5X2Jhc2UiOmZhbHNlLCJkZWxheV9jeWNsZV9zcGVlZCI6MS4wLCJkZWxheV9qaXR0ZXJ0aWNrX3JlcGVhdCI6MTAuMCwiZGVsYXlfbWF4X3RpY2siOjEuMCwiZGVsYXlfbWluX3RpY2siOjEuMCwiZGVsYXlfbW9kZSI6IlN0YXRpYyIsImRlbGF5X3N0YXRpY190aWNrIjoxLjAsImRlc3luYyI6IlN0YXRpYyIsImRlc3luY19hbmdsZW1vZGUiOiJEaXNhYmxlZCIsImRlc3luY19hbnRpX2JydSI6ZmFsc2UsImRlc3luY19pbnZlcnQiOmZhbHNlLCJkZXN5bmNfbGVmdCI6MC4wLCJkZXN5bmNfcGVyaW9kIjpmYWxzZSwiZGVzeW5jX3JpZ2h0IjowLjAsImRlc3luY190aWNrIjo0LjAsImVuYWJsZSI6dHJ1ZSwibW9kaWZpZXJfbW9kZSI6IkRpc2FibGVkIiwibW9kaWZpZXJfbW9kZV9vZmZzZXQiOjAuMCwibW9kaWZpZXJfcmFuZG9tIjpmYWxzZSwibW9kaWZpZXJfcmFuZG9tX2RlZmF1bHQiOjAuMCwibW9kaWZpZXJfcmFuZG9tX21heCI6MC4wLCJtb2RpZmllcl9yYW5kb21fbWluIjowLjAsIm1vZGlmaWVyX3JhbmRvbV9tb2RlIjoiRGVmYXVsdCIsIm1vZGlmaWVyX3N3YXlfc3BlZWQiOjEuMCwieWF3X2ZsdWN0YXRlIjowLjAsInlhd19mbHVjdGF0ZV9lbmFibGUiOmZhbHNlLCJ5YXdfbGVmdCI6MC4wLCJ5YXdfbW9kZSI6IkppdHRlciIsInlhd19vZmZzZXQiOjAuMCwieWF3X3JpZ2h0IjowLjAsInlhd190YXJnZXQiOjAuMH0sImNyb3VjaCI6eyJkZWZlbnNpdmUiOmZhbHNlLCJkZWZlbnNpdmVfZmxpY2tfdHJpZ2dlciI6IlRpY2tjb3VudCIsImRlZmVuc2l2ZV9tb2RlIjoiRmxpY2siLCJkZWZlbnNpdmVfbW9kZV9jaGVjayI6IlRpY2tiYXNlIiwiZGVmZW5zaXZlX21vZGVfbWF4IjoxNS4wLCJkZWZlbnNpdmVfbW9kZV9taW4iOjMuMCwiZGVmZW5zaXZlX21vZGVfdGljayI6OC4wLCJkZWZlbnNpdmVfb25wZWVrIjpmYWxzZSwiZGVmZW5zaXZlX3BpdGNoIjoiUmFuZG9tIiwiZGVmZW5zaXZlX3BpdGNoX2ppdHRlcl9zcGVlZCI6MS4wLCJkZWZlbnNpdmVfcGl0Y2hfbWF4Ijo4OS4wLCJkZWZlbnNpdmVfcGl0Y2hfbWF4XzIiOjAuMCwiZGVmZW5zaXZlX3BpdGNoX21pbiI6LTg5LjAsImRlZmVuc2l2ZV9waXRjaF9taW5fMiI6MC4wLCJkZWZlbnNpdmVfcGl0Y2hfc3BlZWQiOjEuMCwiZGVmZW5zaXZlX3BpdGNoX3N0YXRpYyI6MC4wLCJkZWZlbnNpdmVfcGl0Y2hfc3dpdGNoIjoxLjAsImRlZmVuc2l2ZV95YXciOiJTdGF0aWMiLCJkZWZlbnNpdmVfeWF3X2FkYXB0aXZlIjowLjAsImRlZmVuc2l2ZV95YXdfY3ljbGVfaW52ZXJ0IjpmYWxzZSwiZGVmZW5zaXZlX3lhd19mbGljayI6ZmFsc2UsImRlZmVuc2l2ZV95YXdfZnVsbCI6MC4wLCJkZWZlbnNpdmVfeWF3X2ppdHRlcl9zcGVlZCI6MS4wLCJkZWZlbnNpdmVfeWF3X21heCI6MC4wLCJkZWZlbnNpdmVfeWF3X21heF8yIjowLjAsImRlZmVuc2l2ZV95YXdfbWluIjowLjAsImRlZmVuc2l2ZV95YXdfbWluXzIiOjAuMCwiZGVmZW5zaXZlX3lhd19zcGVlZCI6MS4wLCJkZWZlbnNpdmVfeWF3X3N0YXRpYyI6LTkwLjAsImRlZmVuc2l2ZV95YXdfc3dpdGNoIjoxLjAsImRlbGF5X2Jhc2UiOmZhbHNlLCJkZWxheV9jeWNsZV9zcGVlZCI6MS4wLCJkZWxheV9qaXR0ZXJ0aWNrX3JlcGVhdCI6MTAuMCwiZGVsYXlfbWF4X3RpY2siOjEuMCwiZGVsYXlfbWluX3RpY2siOjEuMCwiZGVsYXlfbW9kZSI6IlN0YXRpYyIsImRlbGF5X3N0YXRpY190aWNrIjoxLjAsImRlc3luYyI6IlN0YXRpYyIsImRlc3luY19hbmdsZW1vZGUiOiJEaXNhYmxlZCIsImRlc3luY19hbnRpX2JydSI6ZmFsc2UsImRlc3luY19pbnZlcnQiOmZhbHNlLCJkZXN5bmNfbGVmdCI6MTMuMCwiZGVzeW5jX3BlcmlvZCI6ZmFsc2UsImRlc3luY19yaWdodCI6MTEuMCwiZGVzeW5jX3RpY2siOjQuMCwiZW5hYmxlIjp0cnVlLCJtb2RpZmllcl9tb2RlIjoiU3dheSBKaXR0ZXIiLCJtb2RpZmllcl9tb2RlX29mZnNldCI6MjMuMCwibW9kaWZpZXJfcmFuZG9tIjpmYWxzZSwibW9kaWZpZXJfcmFuZG9tX2RlZmF1bHQiOjAuMCwibW9kaWZpZXJfcmFuZG9tX21heCI6MC4wLCJtb2RpZmllcl9yYW5kb21fbWluIjowLjAsIm1vZGlmaWVyX3JhbmRvbV9tb2RlIjoiRGVmYXVsdCIsIm1vZGlmaWVyX3N3YXlfc3BlZWQiOjEuMCwieWF3X2ZsdWN0YXRlIjowLjAsInlhd19mbHVjdGF0ZV9lbmFibGUiOmZhbHNlLCJ5YXdfbGVmdCI6LTE5LjAsInlhd19tb2RlIjoiSml0dGVyIiwieWF3X29mZnNldCI6NS4wLCJ5YXdfcmlnaHQiOjExLjAsInlhd190YXJnZXQiOjUuMH0sImZha2UgZHVjayI6eyJkZWZlbnNpdmUiOmZhbHNlLCJkZWZlbnNpdmVfZmxpY2tfdHJpZ2dlciI6IlRpY2tjb3VudCIsImRlZmVuc2l2ZV9tb2RlIjoiTmV2ZXJsb3NlIiwiZGVmZW5zaXZlX21vZGVfY2hlY2siOiJUaWNrYmFzZSIsImRlZmVuc2l2ZV9tb2RlX21heCI6MC4wLCJkZWZlbnNpdmVfbW9kZV9taW4iOjAuMCwiZGVmZW5zaXZlX21vZGVfdGljayI6OC4wLCJkZWZlbnNpdmVfb25wZWVrIjpmYWxzZSwiZGVmZW5zaXZlX3BpdGNoIjoiRGlzYWJsZWQiLCJkZWZlbnNpdmVfcGl0Y2hfaml0dGVyX3NwZWVkIjoxLjAsImRlZmVuc2l2ZV9waXRjaF9tYXgiOjAuMCwiZGVmZW5zaXZlX3BpdGNoX21heF8yIjowLjAsImRlZmVuc2l2ZV9waXRjaF9taW4iOjAuMCwiZGVmZW5zaXZlX3BpdGNoX21pbl8yIjowLjAsImRlZmVuc2l2ZV9waXRjaF9zcGVlZCI6MS4wLCJkZWZlbnNpdmVfcGl0Y2hfc3RhdGljIjowLjAsImRlZmVuc2l2ZV9waXRjaF9zd2l0Y2giOjEuMCwiZGVmZW5zaXZlX3lhdyI6IkRpc2FibGVkIiwiZGVmZW5zaXZlX3lhd19hZGFwdGl2ZSI6MC4wLCJkZWZlbnNpdmVfeWF3X2N5Y2xlX2ludmVydCI6ZmFsc2UsImRlZmVuc2l2ZV95YXdfZmxpY2siOmZhbHNlLCJkZWZlbnNpdmVfeWF3X2Z1bGwiOjAuMCwiZGVmZW5zaXZlX3lhd19qaXR0ZXJfc3BlZWQiOjEuMCwiZGVmZW5zaXZlX3lhd19tYXgiOjAuMCwiZGVmZW5zaXZlX3lhd19tYXhfMiI6MC4wLCJkZWZlbnNpdmVfeWF3X21pbiI6MC4wLCJkZWZlbnNpdmVfeWF3X21pbl8yIjowLjAsImRlZmVuc2l2ZV95YXdfc3BlZWQiOjEuMCwiZGVmZW5zaXZlX3lhd19zdGF0aWMiOjAuMCwiZGVmZW5zaXZlX3lhd19zd2l0Y2giOjEuMCwiZGVsYXlfYmFzZSI6ZmFsc2UsImRlbGF5X2N5Y2xlX3NwZWVkIjoxLjAsImRlbGF5X2ppdHRlcnRpY2tfcmVwZWF0IjoxMC4wLCJkZWxheV9tYXhfdGljayI6MS4wLCJkZWxheV9taW5fdGljayI6MS4wLCJkZWxheV9tb2RlIjoiU3RhdGljIiwiZGVsYXlfc3RhdGljX3RpY2siOjEuMCwiZGVzeW5jIjoiU3RhdGljIiwiZGVzeW5jX2FuZ2xlbW9kZSI6IkRpc2FibGVkIiwiZGVzeW5jX2FudGlfYnJ1IjpmYWxzZSwiZGVzeW5jX2ludmVydCI6ZmFsc2UsImRlc3luY19sZWZ0IjowLjAsImRlc3luY19wZXJpb2QiOmZhbHNlLCJkZXN5bmNfcmlnaHQiOjAuMCwiZGVzeW5jX3RpY2siOjQuMCwiZW5hYmxlIjp0cnVlLCJtb2RpZmllcl9tb2RlIjoiRGlzYWJsZWQiLCJtb2RpZmllcl9tb2RlX29mZnNldCI6MC4wLCJtb2RpZmllcl9yYW5kb20iOmZhbHNlLCJtb2RpZmllcl9yYW5kb21fZGVmYXVsdCI6MC4wLCJtb2RpZmllcl9yYW5kb21fbWF4IjowLjAsIm1vZGlmaWVyX3JhbmRvbV9taW4iOjAuMCwibW9kaWZpZXJfcmFuZG9tX21vZGUiOiJEZWZhdWx0IiwibW9kaWZpZXJfc3dheV9zcGVlZCI6MS4wLCJ5YXdfZmx1Y3RhdGUiOjAuMCwieWF3X2ZsdWN0YXRlX2VuYWJsZSI6ZmFsc2UsInlhd19sZWZ0IjowLjAsInlhd19tb2RlIjoiSml0dGVyIiwieWF3X29mZnNldCI6MC4wLCJ5YXdfcmlnaHQiOjAuMCwieWF3X3RhcmdldCI6MC4wfSwiZmFrZSBsYWciOnsiZGVmZW5zaXZlIjpmYWxzZSwiZGVmZW5zaXZlX2ZsaWNrX3RyaWdnZXIiOiJUaWNrY291bnQiLCJkZWZlbnNpdmVfbW9kZSI6Ik5ldmVybG9zZSIsImRlZmVuc2l2ZV9tb2RlX2NoZWNrIjoiVGlja2Jhc2UiLCJkZWZlbnNpdmVfbW9kZV9tYXgiOjAuMCwiZGVmZW5zaXZlX21vZGVfbWluIjowLjAsImRlZmVuc2l2ZV9tb2RlX3RpY2siOjguMCwiZGVmZW5zaXZlX29ucGVlayI6ZmFsc2UsImRlZmVuc2l2ZV9waXRjaCI6IkRpc2FibGVkIiwiZGVmZW5zaXZlX3BpdGNoX2ppdHRlcl9zcGVlZCI6MS4wLCJkZWZlbnNpdmVfcGl0Y2hfbWF4IjowLjAsImRlZmVuc2l2ZV9waXRjaF9tYXhfMiI6MC4wLCJkZWZlbnNpdmVfcGl0Y2hfbWluIjowLjAsImRlZmVuc2l2ZV9waXRjaF9taW5fMiI6MC4wLCJkZWZlbnNpdmVfcGl0Y2hfc3BlZWQiOjEuMCwiZGVmZW5zaXZlX3BpdGNoX3N0YXRpYyI6MC4wLCJkZWZlbnNpdmVfcGl0Y2hfc3dpdGNoIjoxLjAsImRlZmVuc2l2ZV95YXciOiJEaXNhYmxlZCIsImRlZmVuc2l2ZV95YXdfYWRhcHRpdmUiOjAuMCwiZGVmZW5zaXZlX3lhd19jeWNsZV9pbnZlcnQiOmZhbHNlLCJkZWZlbnNpdmVfeWF3X2ZsaWNrIjpmYWxzZSwiZGVmZW5zaXZlX3lhd19mdWxsIjowLjAsImRlZmVuc2l2ZV95YXdfaml0dGVyX3NwZWVkIjoxLjAsImRlZmVuc2l2ZV95YXdfbWF4IjowLjAsImRlZmVuc2l2ZV95YXdfbWF4XzIiOjAuMCwiZGVmZW5zaXZlX3lhd19taW4iOjAuMCwiZGVmZW5zaXZlX3lhd19taW5fMiI6MC4wLCJkZWZlbnNpdmVfeWF3X3NwZWVkIjoxLjAsImRlZmVuc2l2ZV95YXdfc3RhdGljIjowLjAsImRlZmVuc2l2ZV95YXdfc3dpdGNoIjoxLjAsImRlbGF5X2Jhc2UiOmZhbHNlLCJkZWxheV9jeWNsZV9zcGVlZCI6MS4wLCJkZWxheV9qaXR0ZXJ0aWNrX3JlcGVhdCI6MTAuMCwiZGVsYXlfbWF4X3RpY2siOjEuMCwiZGVsYXlfbWluX3RpY2siOjEuMCwiZGVsYXlfbW9kZSI6IlN0YXRpYyIsImRlbGF5X3N0YXRpY190aWNrIjoxLjAsImRlc3luYyI6IlN0YXRpYyIsImRlc3luY19hbmdsZW1vZGUiOiJEaXNhYmxlZCIsImRlc3luY19hbnRpX2JydSI6ZmFsc2UsImRlc3luY19pbnZlcnQiOmZhbHNlLCJkZXN5bmNfbGVmdCI6MC4wLCJkZXN5bmNfcGVyaW9kIjpmYWxzZSwiZGVzeW5jX3JpZ2h0IjowLjAsImRlc3luY190aWNrIjo0LjAsImVuYWJsZSI6dHJ1ZSwibW9kaWZpZXJfbW9kZSI6IkRpc2FibGVkIiwibW9kaWZpZXJfbW9kZV9vZmZzZXQiOjAuMCwibW9kaWZpZXJfcmFuZG9tIjpmYWxzZSwibW9kaWZpZXJfcmFuZG9tX2RlZmF1bHQiOjAuMCwibW9kaWZpZXJfcmFuZG9tX21heCI6MC4wLCJtb2RpZmllcl9yYW5kb21fbWluIjowLjAsIm1vZGlmaWVyX3JhbmRvbV9tb2RlIjoiRGVmYXVsdCIsIm1vZGlmaWVyX3N3YXlfc3BlZWQiOjEuMCwieWF3X2ZsdWN0YXRlIjowLjAsInlhd19mbHVjdGF0ZV9lbmFibGUiOmZhbHNlLCJ5YXdfbGVmdCI6MC4wLCJ5YXdfbW9kZSI6IkppdHRlciIsInlhd19vZmZzZXQiOjAuMCwieWF3X3JpZ2h0IjowLjAsInlhd190YXJnZXQiOjAuMH0sImdsb2JhbCI6eyJkZWZlbnNpdmUiOmZhbHNlLCJkZWZlbnNpdmVfZmxpY2tfdHJpZ2dlciI6IlRpY2tjb3VudCIsImRlZmVuc2l2ZV9tb2RlIjoiTmV2ZXJsb3NlIiwiZGVmZW5zaXZlX21vZGVfY2hlY2siOiJUaWNrYmFzZSIsImRlZmVuc2l2ZV9tb2RlX21heCI6MC4wLCJkZWZlbnNpdmVfbW9kZV9taW4iOjAuMCwiZGVmZW5zaXZlX21vZGVfdGljayI6OC4wLCJkZWZlbnNpdmVfb25wZWVrIjpmYWxzZSwiZGVmZW5zaXZlX3BpdGNoIjoiRGlzYWJsZWQiLCJkZWZlbnNpdmVfcGl0Y2hfaml0dGVyX3NwZWVkIjoxLjAsImRlZmVuc2l2ZV9waXRjaF9tYXgiOjAuMCwiZGVmZW5zaXZlX3BpdGNoX21heF8yIjowLjAsImRlZmVuc2l2ZV9waXRjaF9taW4iOjAuMCwiZGVmZW5zaXZlX3BpdGNoX21pbl8yIjowLjAsImRlZmVuc2l2ZV9waXRjaF9zcGVlZCI6MS4wLCJkZWZlbnNpdmVfcGl0Y2hfc3RhdGljIjowLjAsImRlZmVuc2l2ZV9waXRjaF9zd2l0Y2giOjEuMCwiZGVmZW5zaXZlX3lhdyI6IkRpc2FibGVkIiwiZGVmZW5zaXZlX3lhd19hZGFwdGl2ZSI6MC4wLCJkZWZlbnNpdmVfeWF3X2N5Y2xlX2ludmVydCI6ZmFsc2UsImRlZmVuc2l2ZV95YXdfZmxpY2siOmZhbHNlLCJkZWZlbnNpdmVfeWF3X2Z1bGwiOjAuMCwiZGVmZW5zaXZlX3lhd19qaXR0ZXJfc3BlZWQiOjEuMCwiZGVmZW5zaXZlX3lhd19tYXgiOjAuMCwiZGVmZW5zaXZlX3lhd19tYXhfMiI6MC4wLCJkZWZlbnNpdmVfeWF3X21pbiI6MC4wLCJkZWZlbnNpdmVfeWF3X21pbl8yIjowLjAsImRlZmVuc2l2ZV95YXdfc3BlZWQiOjEuMCwiZGVmZW5zaXZlX3lhd19zdGF0aWMiOjAuMCwiZGVmZW5zaXZlX3lhd19zd2l0Y2giOjEuMCwiZGVsYXlfYmFzZSI6ZmFsc2UsImRlbGF5X2N5Y2xlX3NwZWVkIjoxLjAsImRlbGF5X2ppdHRlcnRpY2tfcmVwZWF0IjoxMC4wLCJkZWxheV9tYXhfdGljayI6MS4wLCJkZWxheV9taW5fdGljayI6MS4wLCJkZWxheV9tb2RlIjoiU3RhdGljIiwiZGVsYXlfc3RhdGljX3RpY2siOjEuMCwiZGVzeW5jIjoiRGlzYWJsZWQiLCJkZXN5bmNfYW5nbGVtb2RlIjoiRGlzYWJsZWQiLCJkZXN5bmNfYW50aV9icnUiOmZhbHNlLCJkZXN5bmNfaW52ZXJ0IjpmYWxzZSwiZGVzeW5jX2xlZnQiOjAuMCwiZGVzeW5jX3BlcmlvZCI6ZmFsc2UsImRlc3luY19yaWdodCI6MC4wLCJkZXN5bmNfdGljayI6NC4wLCJtb2RpZmllcl9tb2RlIjoiRGlzYWJsZWQiLCJtb2RpZmllcl9tb2RlX29mZnNldCI6MC4wLCJtb2RpZmllcl9yYW5kb20iOmZhbHNlLCJtb2RpZmllcl9yYW5kb21fZGVmYXVsdCI6MC4wLCJtb2RpZmllcl9yYW5kb21fbWF4IjowLjAsIm1vZGlmaWVyX3JhbmRvbV9taW4iOjAuMCwibW9kaWZpZXJfcmFuZG9tX21vZGUiOiJEZWZhdWx0IiwibW9kaWZpZXJfc3dheV9zcGVlZCI6MS4wLCJ5YXdfZmx1Y3RhdGUiOjAuMCwieWF3X2ZsdWN0YXRlX2VuYWJsZSI6ZmFsc2UsInlhd19sZWZ0IjowLjAsInlhd19tb2RlIjoiSml0dGVyIiwieWF3X29mZnNldCI6MC4wLCJ5YXdfcmlnaHQiOjAuMCwieWF3X3RhcmdldCI6MC4wfSwibW92aW5nIjp7ImRlZmVuc2l2ZSI6ZmFsc2UsImRlZmVuc2l2ZV9mbGlja190cmlnZ2VyIjoiVGlja2NvdW50IiwiZGVmZW5zaXZlX21vZGUiOiJOZXZlcmxvc2UiLCJkZWZlbnNpdmVfbW9kZV9jaGVjayI6IlRpY2tiYXNlIiwiZGVmZW5zaXZlX21vZGVfbWF4IjowLjAsImRlZmVuc2l2ZV9tb2RlX21pbiI6MC4wLCJkZWZlbnNpdmVfbW9kZV90aWNrIjo4LjAsImRlZmVuc2l2ZV9vbnBlZWsiOmZhbHNlLCJkZWZlbnNpdmVfcGl0Y2giOiJEaXNhYmxlZCIsImRlZmVuc2l2ZV9waXRjaF9qaXR0ZXJfc3BlZWQiOjEuMCwiZGVmZW5zaXZlX3BpdGNoX21heCI6MC4wLCJkZWZlbnNpdmVfcGl0Y2hfbWF4XzIiOjAuMCwiZGVmZW5zaXZlX3BpdGNoX21pbiI6MC4wLCJkZWZlbnNpdmVfcGl0Y2hfbWluXzIiOjAuMCwiZGVmZW5zaXZlX3BpdGNoX3NwZWVkIjoxLjAsImRlZmVuc2l2ZV9waXRjaF9zdGF0aWMiOjAuMCwiZGVmZW5zaXZlX3BpdGNoX3N3aXRjaCI6MS4wLCJkZWZlbnNpdmVfeWF3IjoiRGlzYWJsZWQiLCJkZWZlbnNpdmVfeWF3X2FkYXB0aXZlIjowLjAsImRlZmVuc2l2ZV95YXdfY3ljbGVfaW52ZXJ0IjpmYWxzZSwiZGVmZW5zaXZlX3lhd19mbGljayI6ZmFsc2UsImRlZmVuc2l2ZV95YXdfZnVsbCI6MC4wLCJkZWZlbnNpdmVfeWF3X2ppdHRlcl9zcGVlZCI6MS4wLCJkZWZlbnNpdmVfeWF3X21heCI6MC4wLCJkZWZlbnNpdmVfeWF3X21heF8yIjowLjAsImRlZmVuc2l2ZV95YXdfbWluIjowLjAsImRlZmVuc2l2ZV95YXdfbWluXzIiOjAuMCwiZGVmZW5zaXZlX3lhd19zcGVlZCI6MS4wLCJkZWZlbnNpdmVfeWF3X3N0YXRpYyI6MC4wLCJkZWZlbnNpdmVfeWF3X3N3aXRjaCI6MS4wLCJkZWxheV9iYXNlIjp0cnVlLCJkZWxheV9jeWNsZV9zcGVlZCI6MS4wLCJkZWxheV9qaXR0ZXJ0aWNrX3JlcGVhdCI6MTAuMCwiZGVsYXlfbWF4X3RpY2siOjMuMCwiZGVsYXlfbWluX3RpY2siOjMuMCwiZGVsYXlfbW9kZSI6IlJhbmRvbSIsImRlbGF5X3N0YXRpY190aWNrIjoxLjAsImRlc3luYyI6IlN0YXRpYyIsImRlc3luY19hbmdsZW1vZGUiOiJEaXNhYmxlZCIsImRlc3luY19hbnRpX2JydSI6dHJ1ZSwiZGVzeW5jX2ludmVydCI6ZmFsc2UsImRlc3luY19sZWZ0IjoxNC4wLCJkZXN5bmNfcGVyaW9kIjp0cnVlLCJkZXN5bmNfcmlnaHQiOjEyLjAsImRlc3luY190aWNrIjo0LjAsImVuYWJsZSI6dHJ1ZSwibW9kaWZpZXJfbW9kZSI6IkppdHRlciIsIm1vZGlmaWVyX21vZGVfb2Zmc2V0IjoxNS4wLCJtb2RpZmllcl9yYW5kb20iOmZhbHNlLCJtb2RpZmllcl9yYW5kb21fZGVmYXVsdCI6MC4wLCJtb2RpZmllcl9yYW5kb21fbWF4IjowLjAsIm1vZGlmaWVyX3JhbmRvbV9taW4iOjAuMCwibW9kaWZpZXJfcmFuZG9tX21vZGUiOiJEZWZhdWx0IiwibW9kaWZpZXJfc3dheV9zcGVlZCI6MS4wLCJ5YXdfZmx1Y3RhdGUiOjIuMCwieWF3X2ZsdWN0YXRlX2VuYWJsZSI6ZmFsc2UsInlhd19sZWZ0IjotMjMuMCwieWF3X21vZGUiOiJKaXR0ZXIiLCJ5YXdfb2Zmc2V0IjowLjAsInlhd19yaWdodCI6MzQuMCwieWF3X3RhcmdldCI6MTAuMH0sInNsb3ciOnsiZGVmZW5zaXZlIjpmYWxzZSwiZGVmZW5zaXZlX2ZsaWNrX3RyaWdnZXIiOiJUaWNrY291bnQiLCJkZWZlbnNpdmVfbW9kZSI6IkN1c3RvbSIsImRlZmVuc2l2ZV9tb2RlX2NoZWNrIjoiVGlja2Jhc2UiLCJkZWZlbnNpdmVfbW9kZV9tYXgiOjE1LjAsImRlZmVuc2l2ZV9tb2RlX21pbiI6My4wLCJkZWZlbnNpdmVfbW9kZV90aWNrIjo4LjAsImRlZmVuc2l2ZV9vbnBlZWsiOmZhbHNlLCJkZWZlbnNpdmVfcGl0Y2giOiJDeWNsZSBTcGluIiwiZGVmZW5zaXZlX3BpdGNoX2ppdHRlcl9zcGVlZCI6MjAuMCwiZGVmZW5zaXZlX3BpdGNoX21heCI6MzAuMCwiZGVmZW5zaXZlX3BpdGNoX21heF8yIjowLjAsImRlZmVuc2l2ZV9waXRjaF9taW4iOi0zMC4wLCJkZWZlbnNpdmVfcGl0Y2hfbWluXzIiOjAuMCwiZGVmZW5zaXZlX3BpdGNoX3NwZWVkIjoxLjAsImRlZmVuc2l2ZV9waXRjaF9zdGF0aWMiOjAuMCwiZGVmZW5zaXZlX3BpdGNoX3N3aXRjaCI6MS4wLCJkZWZlbnNpdmVfeWF3IjoiRmxpY2siLCJkZWZlbnNpdmVfeWF3X2FkYXB0aXZlIjowLjAsImRlZmVuc2l2ZV95YXdfY3ljbGVfaW52ZXJ0IjpmYWxzZSwiZGVmZW5zaXZlX3lhd19mbGljayI6ZmFsc2UsImRlZmVuc2l2ZV95YXdfZnVsbCI6MC4wLCJkZWZlbnNpdmVfeWF3X2ppdHRlcl9zcGVlZCI6MS4wLCJkZWZlbnNpdmVfeWF3X21heCI6LTExMC4wLCJkZWZlbnNpdmVfeWF3X21heF8yIjowLjAsImRlZmVuc2l2ZV95YXdfbWluIjoxMTAuMCwiZGVmZW5zaXZlX3lhd19taW5fMiI6MC4wLCJkZWZlbnNpdmVfeWF3X3NwZWVkIjoxLjAsImRlZmVuc2l2ZV95YXdfc3RhdGljIjowLjAsImRlZmVuc2l2ZV95YXdfc3dpdGNoIjoxLjAsImRlbGF5X2Jhc2UiOmZhbHNlLCJkZWxheV9jeWNsZV9zcGVlZCI6MS4wLCJkZWxheV9qaXR0ZXJ0aWNrX3JlcGVhdCI6MTAuMCwiZGVsYXlfbWF4X3RpY2siOjEuMCwiZGVsYXlfbWluX3RpY2siOjEuMCwiZGVsYXlfbW9kZSI6IlN0YXRpYyIsImRlbGF5X3N0YXRpY190aWNrIjoxLjAsImRlc3luYyI6IlN0YXRpYyIsImRlc3luY19hbmdsZW1vZGUiOiJEaXNhYmxlZCIsImRlc3luY19hbnRpX2JydSI6ZmFsc2UsImRlc3luY19pbnZlcnQiOmZhbHNlLCJkZXN5bmNfbGVmdCI6MjQuMCwiZGVzeW5jX3BlcmlvZCI6ZmFsc2UsImRlc3luY19yaWdodCI6MzAuMCwiZGVzeW5jX3RpY2siOjQuMCwiZW5hYmxlIjp0cnVlLCJtb2RpZmllcl9tb2RlIjoiRGlzYWJsZWQiLCJtb2RpZmllcl9tb2RlX29mZnNldCI6MC4wLCJtb2RpZmllcl9yYW5kb20iOmZhbHNlLCJtb2RpZmllcl9yYW5kb21fZGVmYXVsdCI6MC4wLCJtb2RpZmllcl9yYW5kb21fbWF4IjowLjAsIm1vZGlmaWVyX3JhbmRvbV9taW4iOjAuMCwibW9kaWZpZXJfcmFuZG9tX21vZGUiOiJEZWZhdWx0IiwibW9kaWZpZXJfc3dheV9zcGVlZCI6MS4wLCJ5YXdfZmx1Y3RhdGUiOjAuMCwieWF3X2ZsdWN0YXRlX2VuYWJsZSI6ZmFsc2UsInlhd19sZWZ0Ijo4LjAsInlhd19tb2RlIjoiSml0dGVyIiwieWF3X29mZnNldCI6MC4wLCJ5YXdfcmlnaHQiOi04LjAsInlhd190YXJnZXQiOi0zLjB9LCJzbmVhayI6eyJkZWZlbnNpdmUiOnRydWUsImRlZmVuc2l2ZV9mbGlja190cmlnZ2VyIjoiVGlja2NvdW50IiwiZGVmZW5zaXZlX21vZGUiOiJDdXN0b20iLCJkZWZlbnNpdmVfbW9kZV9jaGVjayI6IlRpY2tiYXNlIiwiZGVmZW5zaXZlX21vZGVfbWF4IjoxNS4wLCJkZWZlbnNpdmVfbW9kZV9taW4iOjMuMCwiZGVmZW5zaXZlX21vZGVfdGljayI6OC4wLCJkZWZlbnNpdmVfb25wZWVrIjpmYWxzZSwiZGVmZW5zaXZlX3BpdGNoIjoiU3RhdGljIiwiZGVmZW5zaXZlX3BpdGNoX2ppdHRlcl9zcGVlZCI6MS4wLCJkZWZlbnNpdmVfcGl0Y2hfbWF4Ijo4OS4wLCJkZWZlbnNpdmVfcGl0Y2hfbWF4XzIiOjAuMCwiZGVmZW5zaXZlX3BpdGNoX21pbiI6LTg5LjAsImRlZmVuc2l2ZV9waXRjaF9taW5fMiI6MC4wLCJkZWZlbnNpdmVfcGl0Y2hfc3BlZWQiOjEuMCwiZGVmZW5zaXZlX3BpdGNoX3N0YXRpYyI6LTg5LjAsImRlZmVuc2l2ZV9waXRjaF9zd2l0Y2giOjEuMCwiZGVmZW5zaXZlX3lhdyI6IldyYWl0aCIsImRlZmVuc2l2ZV95YXdfYWRhcHRpdmUiOjAuMCwiZGVmZW5zaXZlX3lhd19jeWNsZV9pbnZlcnQiOmZhbHNlLCJkZWZlbnNpdmVfeWF3X2ZsaWNrIjpmYWxzZSwiZGVmZW5zaXZlX3lhd19mdWxsIjowLjAsImRlZmVuc2l2ZV95YXdfaml0dGVyX3NwZWVkIjoxLjAsImRlZmVuc2l2ZV95YXdfbWF4IjoxODAuMCwiZGVmZW5zaXZlX3lhd19tYXhfMiI6MC4wLCJkZWZlbnNpdmVfeWF3X21pbiI6LTE4MC4wLCJkZWZlbnNpdmVfeWF3X21pbl8yIjowLjAsImRlZmVuc2l2ZV95YXdfc3BlZWQiOjEwLjAsImRlZmVuc2l2ZV95YXdfc3RhdGljIjotOTAuMCwiZGVmZW5zaXZlX3lhd19zd2l0Y2giOjEuMCwiZGVsYXlfYmFzZSI6ZmFsc2UsImRlbGF5X2N5Y2xlX3NwZWVkIjoxLjAsImRlbGF5X2ppdHRlcnRpY2tfcmVwZWF0IjoxMC4wLCJkZWxheV9tYXhfdGljayI6MS4wLCJkZWxheV9taW5fdGljayI6MS4wLCJkZWxheV9tb2RlIjoiU3RhdGljIiwiZGVsYXlfc3RhdGljX3RpY2siOjEuMCwiZGVzeW5jIjoiU3RhdGljIiwiZGVzeW5jX2FuZ2xlbW9kZSI6IkRpc2FibGVkIiwiZGVzeW5jX2FudGlfYnJ1IjpmYWxzZSwiZGVzeW5jX2ludmVydCI6ZmFsc2UsImRlc3luY19sZWZ0IjowLjAsImRlc3luY19wZXJpb2QiOmZhbHNlLCJkZXN5bmNfcmlnaHQiOjAuMCwiZGVzeW5jX3RpY2siOjQuMCwiZW5hYmxlIjp0cnVlLCJtb2RpZmllcl9tb2RlIjoiRGlzYWJsZWQiLCJtb2RpZmllcl9tb2RlX29mZnNldCI6MC4wLCJtb2RpZmllcl9yYW5kb20iOmZhbHNlLCJtb2RpZmllcl9yYW5kb21fZGVmYXVsdCI6MC4wLCJtb2RpZmllcl9yYW5kb21fbWF4IjowLjAsIm1vZGlmaWVyX3JhbmRvbV9taW4iOjAuMCwibW9kaWZpZXJfcmFuZG9tX21vZGUiOiJEZWZhdWx0IiwibW9kaWZpZXJfc3dheV9zcGVlZCI6MS4wLCJ5YXdfZmx1Y3RhdGUiOjAuMCwieWF3X2ZsdWN0YXRlX2VuYWJsZSI6ZmFsc2UsInlhd19sZWZ0IjowLjAsInlhd19tb2RlIjoiSml0dGVyIiwieWF3X29mZnNldCI6OS4wLCJ5YXdfcmlnaHQiOjAuMCwieWF3X3RhcmdldCI6MC4wfSwic3RhbmQiOnsiZGVmZW5zaXZlIjpmYWxzZSwiZGVmZW5zaXZlX2ZsaWNrX3RyaWdnZXIiOiJUaWNrY291bnQiLCJkZWZlbnNpdmVfbW9kZSI6Ik5ldmVybG9zZSIsImRlZmVuc2l2ZV9tb2RlX2NoZWNrIjoiVGlja2Jhc2UiLCJkZWZlbnNpdmVfbW9kZV9tYXgiOjAuMCwiZGVmZW5zaXZlX21vZGVfbWluIjowLjAsImRlZmVuc2l2ZV9tb2RlX3RpY2siOjguMCwiZGVmZW5zaXZlX29ucGVlayI6ZmFsc2UsImRlZmVuc2l2ZV9waXRjaCI6IkRpc2FibGVkIiwiZGVmZW5zaXZlX3BpdGNoX2ppdHRlcl9zcGVlZCI6MS4wLCJkZWZlbnNpdmVfcGl0Y2hfbWF4IjowLjAsImRlZmVuc2l2ZV9waXRjaF9tYXhfMiI6MC4wLCJkZWZlbnNpdmVfcGl0Y2hfbWluIjowLjAsImRlZmVuc2l2ZV9waXRjaF9taW5fMiI6MC4wLCJkZWZlbnNpdmVfcGl0Y2hfc3BlZWQiOjEuMCwiZGVmZW5zaXZlX3BpdGNoX3N0YXRpYyI6MC4wLCJkZWZlbnNpdmVfcGl0Y2hfc3dpdGNoIjoxLjAsImRlZmVuc2l2ZV95YXciOiJEaXNhYmxlZCIsImRlZmVuc2l2ZV95YXdfYWRhcHRpdmUiOjAuMCwiZGVmZW5zaXZlX3lhd19jeWNsZV9pbnZlcnQiOmZhbHNlLCJkZWZlbnNpdmVfeWF3X2ZsaWNrIjpmYWxzZSwiZGVmZW5zaXZlX3lhd19mdWxsIjowLjAsImRlZmVuc2l2ZV95YXdfaml0dGVyX3NwZWVkIjoxLjAsImRlZmVuc2l2ZV95YXdfbWF4IjowLjAsImRlZmVuc2l2ZV95YXdfbWF4XzIiOjAuMCwiZGVmZW5zaXZlX3lhd19taW4iOjAuMCwiZGVmZW5zaXZlX3lhd19taW5fMiI6MC4wLCJkZWZlbnNpdmVfeWF3X3NwZWVkIjoxLjAsImRlZmVuc2l2ZV95YXdfc3RhdGljIjowLjAsImRlZmVuc2l2ZV95YXdfc3dpdGNoIjoxLjAsImRlbGF5X2Jhc2UiOmZhbHNlLCJkZWxheV9jeWNsZV9zcGVlZCI6MS4wLCJkZWxheV9qaXR0ZXJ0aWNrX3JlcGVhdCI6MTAuMCwiZGVsYXlfbWF4X3RpY2siOjEuMCwiZGVsYXlfbWluX3RpY2siOjEuMCwiZGVsYXlfbW9kZSI6IlN0YXRpYyIsImRlbGF5X3N0YXRpY190aWNrIjoxLjAsImRlc3luYyI6IlN0YXRpYyIsImRlc3luY19hbmdsZW1vZGUiOiJEaXNhYmxlZCIsImRlc3luY19hbnRpX2JydSI6ZmFsc2UsImRlc3luY19pbnZlcnQiOmZhbHNlLCJkZXN5bmNfbGVmdCI6Ny4wLCJkZXN5bmNfcGVyaW9kIjpmYWxzZSwiZGVzeW5jX3JpZ2h0Ijo4LjAsImRlc3luY190aWNrIjo0LjAsImVuYWJsZSI6dHJ1ZSwibW9kaWZpZXJfbW9kZSI6IkppdHRlciIsIm1vZGlmaWVyX21vZGVfb2Zmc2V0IjoxOS4wLCJtb2RpZmllcl9yYW5kb20iOmZhbHNlLCJtb2RpZmllcl9yYW5kb21fZGVmYXVsdCI6MC4wLCJtb2RpZmllcl9yYW5kb21fbWF4IjowLjAsIm1vZGlmaWVyX3JhbmRvbV9taW4iOjAuMCwibW9kaWZpZXJfcmFuZG9tX21vZGUiOiJEZWZhdWx0IiwibW9kaWZpZXJfc3dheV9zcGVlZCI6MS4wLCJ5YXdfZmx1Y3RhdGUiOjAuMCwieWF3X2ZsdWN0YXRlX2VuYWJsZSI6ZmFsc2UsInlhd19sZWZ0IjoyMy4wLCJ5YXdfbW9kZSI6IkppdHRlciIsInlhd19vZmZzZXQiOjAuMCwieWF3X3JpZ2h0IjotMTUuMCwieWF3X3RhcmdldCI6LTMuMH19XQ==", 
    Default = "{Trashhode:config}:W3siY29uZmlnX1VJIjp7ImNmZ19zZWxlY3RvciI6My4wLCJuYW1lIjoiMjIyMiJ9LCJwYWdlIjoyLjB9LHsiYWxsX3NldCI6eyJhdF90YXJnZXQiOnRydWUsImF2b2lkIjp0cnVlLCJwaXRjaCI6IkRvd24ifSwiY29uZGl0aW9uIjp7ImNuZF9saXN0IjoiQWlyIGNyb3VjaGluZyJ9LCJmYWtlbGFnIjp7ImZvcmNlIjpmYWxzZSwibGltaXQiOjE1LjAsIm1heCI6MS4wLCJtaW4iOjEuMCwibW9kZSI6Ik5ldmVybG9zZSIsIm5hZGUiOmZhbHNlLCJzdGVwIjoxLjB9LCJmYWtlbGFnX2VuYWJsZSI6eyJlbmFibGUiOnRydWUsIm9uc2hvdCI6dHJ1ZX0sImZha2VsYWdfc2hvdCI6eyJzaG90X29wdGltemVkIjpbIlJlc2V0IERlc3luYyIsIlJlc2V0IEZMIiwiQ2hva2UiLCJ+Il0sInNob3RfcGVlayI6dHJ1ZSwic2hvdF9wZWVrX2Nob2tlIjp0cnVlfSwiZ2VuZXJhbCI6eyJtYXN0ZXIiOnRydWUsInBhZ2UiOjIuMH0sInNldCI6eyJhaW10aWNrIjp0cnVlLCJhaXJsYWciOmZhbHNlLCJhdXRvaHMiOnRydWUsImZhc3RsYWRkZXIiOmZhbHNlLCJmZHNwZWVkIjp0cnVlLCJmcmVlc3RhbmQiOmZhbHNlLCJtYW51YWwiOiJEaXNhYmxlZCIsInJlY2hhcmdlIjpmYWxzZSwic2xvd3NwZWVkIjpmYWxzZX0sInNldF9zdWIiOnsiYWlybGFnX29wIjpmYWxzZSwiYWlybGFnX3RpY2siOjguMCwiZnNfb3AiOlsxLjAsMi4wLCJ+Il0sIm1hbnVhbF9vcCI6WzEuMCwyLjAsMy4wLCJ+Il0sInNsb3dzcGVlZF9vcCI6MjAuMH19LHsiYWlyIjp7ImRlZmVuc2l2ZSI6dHJ1ZSwiZGVmZW5zaXZlX2ZsaWNrX3RyaWdnZXIiOiJTaW1wbGUiLCJkZWZlbnNpdmVfbW9kZSI6IkN1c3RvbSIsImRlZmVuc2l2ZV9tb2RlX2NoZWNrIjoiVGlja2Jhc2UiLCJkZWZlbnNpdmVfbW9kZV9tYXgiOjE1LjAsImRlZmVuc2l2ZV9tb2RlX21pbiI6My4wLCJkZWZlbnNpdmVfbW9kZV90aWNrIjo4LjAsImRlZmVuc2l2ZV9vbnBlZWsiOmZhbHNlLCJkZWZlbnNpdmVfcGl0Y2giOiJTdGF0aWMiLCJkZWZlbnNpdmVfcGl0Y2hfaml0dGVyX3NwZWVkIjoxLjAsImRlZmVuc2l2ZV9waXRjaF9tYXgiOjAuMCwiZGVmZW5zaXZlX3BpdGNoX21heF8yIjowLjAsImRlZmVuc2l2ZV9waXRjaF9taW4iOjAuMCwiZGVmZW5zaXZlX3BpdGNoX21pbl8yIjowLjAsImRlZmVuc2l2ZV9waXRjaF9zcGVlZCI6MS4wLCJkZWZlbnNpdmVfcGl0Y2hfc3RhdGljIjowLjAsImRlZmVuc2l2ZV9waXRjaF9zd2l0Y2giOjEuMCwiZGVmZW5zaXZlX3lhdyI6IlJhbmRvbSBKaXR0ZXIiLCJkZWZlbnNpdmVfeWF3X2FkYXB0aXZlIjowLjAsImRlZmVuc2l2ZV95YXdfY3ljbGVfaW52ZXJ0IjpmYWxzZSwiZGVmZW5zaXZlX3lhd19mbGljayI6ZmFsc2UsImRlZmVuc2l2ZV95YXdfZnVsbCI6MzYwLjAsImRlZmVuc2l2ZV95YXdfaml0dGVyX3NwZWVkIjoxLjAsImRlZmVuc2l2ZV95YXdfbWF4IjoxODAuMCwiZGVmZW5zaXZlX3lhd19tYXhfMiI6MC4wLCJkZWZlbnNpdmVfeWF3X21pbiI6LTE4MC4wLCJkZWZlbnNpdmVfeWF3X21pbl8yIjowLjAsImRlZmVuc2l2ZV95YXdfc3BlZWQiOjIwLjAsImRlZmVuc2l2ZV95YXdfc3RhdGljIjowLjAsImRlZmVuc2l2ZV95YXdfc3dpdGNoIjoxLjAsImRlbGF5X2Jhc2UiOmZhbHNlLCJkZWxheV9jeWNsZV9zcGVlZCI6MS4wLCJkZWxheV9qaXR0ZXJ0aWNrX3JlcGVhdCI6MTAuMCwiZGVsYXlfbWF4X3RpY2siOjEuMCwiZGVsYXlfbWluX3RpY2siOjEuMCwiZGVsYXlfbW9kZSI6IlN0YXRpYyIsImRlbGF5X3N0YXRpY190aWNrIjoxLjAsImRlc3luYyI6IlN0YXRpYyIsImRlc3luY19hbmdsZW1vZGUiOiJEaXNhYmxlZCIsImRlc3luY19hbnRpX2JydSI6ZmFsc2UsImRlc3luY19pbnZlcnQiOmZhbHNlLCJkZXN5bmNfbGVmdCI6MC4wLCJkZXN5bmNfcGVyaW9kIjpmYWxzZSwiZGVzeW5jX3JpZ2h0IjowLjAsImRlc3luY190aWNrIjo0LjAsImVuYWJsZSI6dHJ1ZSwibW9kaWZpZXJfbW9kZSI6IkRpc2FibGVkIiwibW9kaWZpZXJfbW9kZV9vZmZzZXQiOjAuMCwibW9kaWZpZXJfcmFuZG9tIjpmYWxzZSwibW9kaWZpZXJfcmFuZG9tX2RlZmF1bHQiOjAuMCwibW9kaWZpZXJfcmFuZG9tX21heCI6MC4wLCJtb2RpZmllcl9yYW5kb21fbWluIjowLjAsIm1vZGlmaWVyX3JhbmRvbV9tb2RlIjoiRGVmYXVsdCIsIm1vZGlmaWVyX3N3YXlfc3BlZWQiOjEuMCwieWF3X2ZsdWN0YXRlIjowLjAsInlhd19mbHVjdGF0ZV9lbmFibGUiOmZhbHNlLCJ5YXdfbGVmdCI6MC4wLCJ5YXdfbW9kZSI6IkppdHRlciIsInlhd19vZmZzZXQiOjAuMCwieWF3X3JpZ2h0IjowLjAsInlhd190YXJnZXQiOjAuMH0sImFpcmR1Y2siOnsiZGVmZW5zaXZlIjp0cnVlLCJkZWZlbnNpdmVfZmxpY2tfdHJpZ2dlciI6IlNpbXBsZSIsImRlZmVuc2l2ZV9tb2RlIjoiQ3VzdG9tIiwiZGVmZW5zaXZlX21vZGVfY2hlY2siOiJUaWNrYmFzZSIsImRlZmVuc2l2ZV9tb2RlX21heCI6MTUuMCwiZGVmZW5zaXZlX21vZGVfbWluIjozLjAsImRlZmVuc2l2ZV9tb2RlX3RpY2siOjE2LjAsImRlZmVuc2l2ZV9vbnBlZWsiOmZhbHNlLCJkZWZlbnNpdmVfcGl0Y2giOiJDeWNsZSBTcGluIiwiZGVmZW5zaXZlX3BpdGNoX2ppdHRlcl9zcGVlZCI6MzMuMCwiZGVmZW5zaXZlX3BpdGNoX21heCI6MjguMCwiZGVmZW5zaXZlX3BpdGNoX21heF8yIjowLjAsImRlZmVuc2l2ZV9waXRjaF9taW4iOi0zMC4wLCJkZWZlbnNpdmVfcGl0Y2hfbWluXzIiOjAuMCwiZGVmZW5zaXZlX3BpdGNoX3NwZWVkIjoxLjAsImRlZmVuc2l2ZV9waXRjaF9zdGF0aWMiOjQ1LjAsImRlZmVuc2l2ZV9waXRjaF9zd2l0Y2giOjEuMCwiZGVmZW5zaXZlX3lhdyI6IkZsaWNrIiwiZGVmZW5zaXZlX3lhd19hZGFwdGl2ZSI6MC4wLCJkZWZlbnNpdmVfeWF3X2N5Y2xlX2ludmVydCI6ZmFsc2UsImRlZmVuc2l2ZV95YXdfZmxpY2siOmZhbHNlLCJkZWZlbnNpdmVfeWF3X2Z1bGwiOjM2MC4wLCJkZWZlbnNpdmVfeWF3X2ppdHRlcl9zcGVlZCI6MS4wLCJkZWZlbnNpdmVfeWF3X21heCI6LTkwLjAsImRlZmVuc2l2ZV95YXdfbWF4XzIiOjE4MC4wLCJkZWZlbnNpdmVfeWF3X21pbiI6OTAuMCwiZGVmZW5zaXZlX3lhd19taW5fMiI6LTE4MC4wLCJkZWZlbnNpdmVfeWF3X3NwZWVkIjoxLjAsImRlZmVuc2l2ZV95YXdfc3RhdGljIjotMTA0LjAsImRlZmVuc2l2ZV95YXdfc3dpdGNoIjoxLjAsImRlbGF5X2Jhc2UiOnRydWUsImRlbGF5X2N5Y2xlX3NwZWVkIjoxLjAsImRlbGF5X2ppdHRlcnRpY2tfcmVwZWF0IjoxMC4wLCJkZWxheV9tYXhfdGljayI6MS4wLCJkZWxheV9taW5fdGljayI6MS4wLCJkZWxheV9tb2RlIjoiU3RhdGljIiwiZGVsYXlfc3RhdGljX3RpY2siOjMzLjAsImRlc3luYyI6IkppdHRlciIsImRlc3luY19hbmdsZW1vZGUiOiJEaXNhYmxlZCIsImRlc3luY19hbnRpX2JydSI6ZmFsc2UsImRlc3luY19pbnZlcnQiOmZhbHNlLCJkZXN5bmNfbGVmdCI6NjAuMCwiZGVzeW5jX3BlcmlvZCI6ZmFsc2UsImRlc3luY19yaWdodCI6NjAuMCwiZGVzeW5jX3RpY2siOjQuMCwiZW5hYmxlIjp0cnVlLCJtb2RpZmllcl9tb2RlIjoiSml0dGVyIiwibW9kaWZpZXJfbW9kZV9vZmZzZXQiOjAuMCwibW9kaWZpZXJfcmFuZG9tIjpmYWxzZSwibW9kaWZpZXJfcmFuZG9tX2RlZmF1bHQiOjAuMCwibW9kaWZpZXJfcmFuZG9tX21heCI6MC4wLCJtb2RpZmllcl9yYW5kb21fbWluIjowLjAsIm1vZGlmaWVyX3JhbmRvbV9tb2RlIjoiRGVmYXVsdCIsIm1vZGlmaWVyX3N3YXlfc3BlZWQiOjEuMCwieWF3X2ZsdWN0YXRlIjowLjAsInlhd19mbHVjdGF0ZV9lbmFibGUiOmZhbHNlLCJ5YXdfbGVmdCI6MC4wLCJ5YXdfbW9kZSI6IkppdHRlciIsInlhd19vZmZzZXQiOjAuMCwieWF3X3JpZ2h0IjowLjAsInlhd190YXJnZXQiOjAuMH0sImFpcmtuaWZlIjp7ImRlZmVuc2l2ZSI6dHJ1ZSwiZGVmZW5zaXZlX2ZsaWNrX3RyaWdnZXIiOiJTaW1wbGUiLCJkZWZlbnNpdmVfbW9kZSI6Ik5ldmVybG9zZSIsImRlZmVuc2l2ZV9tb2RlX2NoZWNrIjoiVGlja2Jhc2UiLCJkZWZlbnNpdmVfbW9kZV9tYXgiOjAuMCwiZGVmZW5zaXZlX21vZGVfbWluIjowLjAsImRlZmVuc2l2ZV9tb2RlX3RpY2siOjguMCwiZGVmZW5zaXZlX29ucGVlayI6ZmFsc2UsImRlZmVuc2l2ZV9waXRjaCI6IkRpc2FibGVkIiwiZGVmZW5zaXZlX3BpdGNoX2ppdHRlcl9zcGVlZCI6MS4wLCJkZWZlbnNpdmVfcGl0Y2hfbWF4IjowLjAsImRlZmVuc2l2ZV9waXRjaF9tYXhfMiI6MC4wLCJkZWZlbnNpdmVfcGl0Y2hfbWluIjowLjAsImRlZmVuc2l2ZV9waXRjaF9taW5fMiI6MC4wLCJkZWZlbnNpdmVfcGl0Y2hfc3BlZWQiOjEuMCwiZGVmZW5zaXZlX3BpdGNoX3N0YXRpYyI6MC4wLCJkZWZlbnNpdmVfcGl0Y2hfc3dpdGNoIjoxLjAsImRlZmVuc2l2ZV95YXciOiJEaXNhYmxlZCIsImRlZmVuc2l2ZV95YXdfYWRhcHRpdmUiOjAuMCwiZGVmZW5zaXZlX3lhd19jeWNsZV9pbnZlcnQiOmZhbHNlLCJkZWZlbnNpdmVfeWF3X2ZsaWNrIjpmYWxzZSwiZGVmZW5zaXZlX3lhd19mdWxsIjowLjAsImRlZmVuc2l2ZV95YXdfaml0dGVyX3NwZWVkIjoxLjAsImRlZmVuc2l2ZV95YXdfbWF4IjowLjAsImRlZmVuc2l2ZV95YXdfbWF4XzIiOjAuMCwiZGVmZW5zaXZlX3lhd19taW4iOjAuMCwiZGVmZW5zaXZlX3lhd19taW5fMiI6MC4wLCJkZWZlbnNpdmVfeWF3X3NwZWVkIjoxLjAsImRlZmVuc2l2ZV95YXdfc3RhdGljIjowLjAsImRlZmVuc2l2ZV95YXdfc3dpdGNoIjoxLjAsImRlbGF5X2Jhc2UiOmZhbHNlLCJkZWxheV9jeWNsZV9zcGVlZCI6MS4wLCJkZWxheV9qaXR0ZXJ0aWNrX3JlcGVhdCI6MTAuMCwiZGVsYXlfbWF4X3RpY2siOjEuMCwiZGVsYXlfbWluX3RpY2siOjEuMCwiZGVsYXlfbW9kZSI6IlN0YXRpYyIsImRlbGF5X3N0YXRpY190aWNrIjoxLjAsImRlc3luYyI6IlN0YXRpYyIsImRlc3luY19hbmdsZW1vZGUiOiJEaXNhYmxlZCIsImRlc3luY19hbnRpX2JydSI6ZmFsc2UsImRlc3luY19pbnZlcnQiOmZhbHNlLCJkZXN5bmNfbGVmdCI6MC4wLCJkZXN5bmNfcGVyaW9kIjpmYWxzZSwiZGVzeW5jX3JpZ2h0IjowLjAsImRlc3luY190aWNrIjo0LjAsImVuYWJsZSI6dHJ1ZSwibW9kaWZpZXJfbW9kZSI6IkRpc2FibGVkIiwibW9kaWZpZXJfbW9kZV9vZmZzZXQiOjAuMCwibW9kaWZpZXJfcmFuZG9tIjpmYWxzZSwibW9kaWZpZXJfcmFuZG9tX2RlZmF1bHQiOjAuMCwibW9kaWZpZXJfcmFuZG9tX21heCI6MC4wLCJtb2RpZmllcl9yYW5kb21fbWluIjowLjAsIm1vZGlmaWVyX3JhbmRvbV9tb2RlIjoiRGVmYXVsdCIsIm1vZGlmaWVyX3N3YXlfc3BlZWQiOjEuMCwieWF3X2ZsdWN0YXRlIjowLjAsInlhd19mbHVjdGF0ZV9lbmFibGUiOmZhbHNlLCJ5YXdfbGVmdCI6MC4wLCJ5YXdfbW9kZSI6IkppdHRlciIsInlhd19vZmZzZXQiOjAuMCwieWF3X3JpZ2h0IjowLjAsInlhd190YXJnZXQiOjAuMH0sImFpcnRhc2VyIjp7ImRlZmVuc2l2ZSI6dHJ1ZSwiZGVmZW5zaXZlX2ZsaWNrX3RyaWdnZXIiOiJTaW1wbGUiLCJkZWZlbnNpdmVfbW9kZSI6Ik5ldmVybG9zZSIsImRlZmVuc2l2ZV9tb2RlX2NoZWNrIjoiVGlja2Jhc2UiLCJkZWZlbnNpdmVfbW9kZV9tYXgiOjAuMCwiZGVmZW5zaXZlX21vZGVfbWluIjowLjAsImRlZmVuc2l2ZV9tb2RlX3RpY2siOjguMCwiZGVmZW5zaXZlX29ucGVlayI6ZmFsc2UsImRlZmVuc2l2ZV9waXRjaCI6IlN0YXRpYyIsImRlZmVuc2l2ZV9waXRjaF9qaXR0ZXJfc3BlZWQiOjEuMCwiZGVmZW5zaXZlX3BpdGNoX21heCI6MC4wLCJkZWZlbnNpdmVfcGl0Y2hfbWF4XzIiOjAuMCwiZGVmZW5zaXZlX3BpdGNoX21pbiI6MC4wLCJkZWZlbnNpdmVfcGl0Y2hfbWluXzIiOjAuMCwiZGVmZW5zaXZlX3BpdGNoX3NwZWVkIjoxLjAsImRlZmVuc2l2ZV9waXRjaF9zdGF0aWMiOjQ1LjAsImRlZmVuc2l2ZV9waXRjaF9zd2l0Y2giOjEuMCwiZGVmZW5zaXZlX3lhdyI6IlJhbmRvbSBKaXR0ZXIiLCJkZWZlbnNpdmVfeWF3X2FkYXB0aXZlIjowLjAsImRlZmVuc2l2ZV95YXdfY3ljbGVfaW52ZXJ0IjpmYWxzZSwiZGVmZW5zaXZlX3lhd19mbGljayI6ZmFsc2UsImRlZmVuc2l2ZV95YXdfZnVsbCI6MzYwLjAsImRlZmVuc2l2ZV95YXdfaml0dGVyX3NwZWVkIjoxLjAsImRlZmVuc2l2ZV95YXdfbWF4IjowLjAsImRlZmVuc2l2ZV95YXdfbWF4XzIiOjAuMCwiZGVmZW5zaXZlX3lhd19taW4iOjAuMCwiZGVmZW5zaXZlX3lhd19taW5fMiI6MC4wLCJkZWZlbnNpdmVfeWF3X3NwZWVkIjoxLjAsImRlZmVuc2l2ZV95YXdfc3RhdGljIjowLjAsImRlZmVuc2l2ZV95YXdfc3dpdGNoIjoxLjAsImRlbGF5X2Jhc2UiOmZhbHNlLCJkZWxheV9jeWNsZV9zcGVlZCI6MS4wLCJkZWxheV9qaXR0ZXJ0aWNrX3JlcGVhdCI6MTAuMCwiZGVsYXlfbWF4X3RpY2siOjEuMCwiZGVsYXlfbWluX3RpY2siOjEuMCwiZGVsYXlfbW9kZSI6IlN0YXRpYyIsImRlbGF5X3N0YXRpY190aWNrIjoxLjAsImRlc3luYyI6IlN0YXRpYyIsImRlc3luY19hbmdsZW1vZGUiOiJEaXNhYmxlZCIsImRlc3luY19hbnRpX2JydSI6ZmFsc2UsImRlc3luY19pbnZlcnQiOmZhbHNlLCJkZXN5bmNfbGVmdCI6MC4wLCJkZXN5bmNfcGVyaW9kIjpmYWxzZSwiZGVzeW5jX3JpZ2h0IjowLjAsImRlc3luY190aWNrIjo0LjAsImVuYWJsZSI6dHJ1ZSwibW9kaWZpZXJfbW9kZSI6IkRpc2FibGVkIiwibW9kaWZpZXJfbW9kZV9vZmZzZXQiOjAuMCwibW9kaWZpZXJfcmFuZG9tIjpmYWxzZSwibW9kaWZpZXJfcmFuZG9tX2RlZmF1bHQiOjAuMCwibW9kaWZpZXJfcmFuZG9tX21heCI6MC4wLCJtb2RpZmllcl9yYW5kb21fbWluIjowLjAsIm1vZGlmaWVyX3JhbmRvbV9tb2RlIjoiRGVmYXVsdCIsIm1vZGlmaWVyX3N3YXlfc3BlZWQiOjEuMCwieWF3X2ZsdWN0YXRlIjowLjAsInlhd19mbHVjdGF0ZV9lbmFibGUiOmZhbHNlLCJ5YXdfbGVmdCI6MC4wLCJ5YXdfbW9kZSI6IkppdHRlciIsInlhd19vZmZzZXQiOjAuMCwieWF3X3JpZ2h0IjowLjAsInlhd190YXJnZXQiOjAuMH0sImNyb3VjaCI6eyJkZWZlbnNpdmUiOnRydWUsImRlZmVuc2l2ZV9mbGlja190cmlnZ2VyIjoiU2ltcGxlIiwiZGVmZW5zaXZlX21vZGUiOiJDdXN0b20iLCJkZWZlbnNpdmVfbW9kZV9jaGVjayI6IlRpY2tiYXNlIiwiZGVmZW5zaXZlX21vZGVfbWF4IjoxNS4wLCJkZWZlbnNpdmVfbW9kZV9taW4iOjQuMCwiZGVmZW5zaXZlX21vZGVfdGljayI6Ny4wLCJkZWZlbnNpdmVfb25wZWVrIjpmYWxzZSwiZGVmZW5zaXZlX3BpdGNoIjoiSml0dGVyIiwiZGVmZW5zaXZlX3BpdGNoX2ppdHRlcl9zcGVlZCI6MS4wLCJkZWZlbnNpdmVfcGl0Y2hfbWF4Ijo0NS4wLCJkZWZlbnNpdmVfcGl0Y2hfbWF4XzIiOjAuMCwiZGVmZW5zaXZlX3BpdGNoX21pbiI6LTQ1LjAsImRlZmVuc2l2ZV9waXRjaF9taW5fMiI6MC4wLCJkZWZlbnNpdmVfcGl0Y2hfc3BlZWQiOjEuMCwiZGVmZW5zaXZlX3BpdGNoX3N0YXRpYyI6MC4wLCJkZWZlbnNpdmVfcGl0Y2hfc3dpdGNoIjoxLjAsImRlZmVuc2l2ZV95YXciOiJKaXR0ZXIiLCJkZWZlbnNpdmVfeWF3X2FkYXB0aXZlIjowLjAsImRlZmVuc2l2ZV95YXdfY3ljbGVfaW52ZXJ0IjpmYWxzZSwiZGVmZW5zaXZlX3lhd19mbGljayI6ZmFsc2UsImRlZmVuc2l2ZV95YXdfZnVsbCI6MC4wLCJkZWZlbnNpdmVfeWF3X2ppdHRlcl9zcGVlZCI6MS4wLCJkZWZlbnNpdmVfeWF3X21heCI6OTAuMCwiZGVmZW5zaXZlX3lhd19tYXhfMiI6MC4wLCJkZWZlbnNpdmVfeWF3X21pbiI6LTkwLjAsImRlZmVuc2l2ZV95YXdfbWluXzIiOjAuMCwiZGVmZW5zaXZlX3lhd19zcGVlZCI6MS4wLCJkZWZlbnNpdmVfeWF3X3N0YXRpYyI6LTkwLjAsImRlZmVuc2l2ZV95YXdfc3dpdGNoIjoxLjAsImRlbGF5X2Jhc2UiOmZhbHNlLCJkZWxheV9jeWNsZV9zcGVlZCI6MS4wLCJkZWxheV9qaXR0ZXJ0aWNrX3JlcGVhdCI6MTAuMCwiZGVsYXlfbWF4X3RpY2siOjEuMCwiZGVsYXlfbWluX3RpY2siOjEuMCwiZGVsYXlfbW9kZSI6IlN0YXRpYyIsImRlbGF5X3N0YXRpY190aWNrIjoxLjAsImRlc3luYyI6IlN0YXRpYyIsImRlc3luY19hbmdsZW1vZGUiOiJEaXNhYmxlZCIsImRlc3luY19hbnRpX2JydSI6ZmFsc2UsImRlc3luY19pbnZlcnQiOmZhbHNlLCJkZXN5bmNfbGVmdCI6MC4wLCJkZXN5bmNfcGVyaW9kIjpmYWxzZSwiZGVzeW5jX3JpZ2h0IjowLjAsImRlc3luY190aWNrIjo0LjAsImVuYWJsZSI6dHJ1ZSwibW9kaWZpZXJfbW9kZSI6IkRpc2FibGVkIiwibW9kaWZpZXJfbW9kZV9vZmZzZXQiOjAuMCwibW9kaWZpZXJfcmFuZG9tIjpmYWxzZSwibW9kaWZpZXJfcmFuZG9tX2RlZmF1bHQiOjAuMCwibW9kaWZpZXJfcmFuZG9tX21heCI6MC4wLCJtb2RpZmllcl9yYW5kb21fbWluIjowLjAsIm1vZGlmaWVyX3JhbmRvbV9tb2RlIjoiRGVmYXVsdCIsIm1vZGlmaWVyX3N3YXlfc3BlZWQiOjEuMCwieWF3X2ZsdWN0YXRlIjowLjAsInlhd19mbHVjdGF0ZV9lbmFibGUiOmZhbHNlLCJ5YXdfbGVmdCI6MC4wLCJ5YXdfbW9kZSI6IkppdHRlciIsInlhd19vZmZzZXQiOjUuMCwieWF3X3JpZ2h0IjowLjAsInlhd190YXJnZXQiOjEwLjB9LCJmYWtlIGR1Y2siOnsiZGVmZW5zaXZlIjpmYWxzZSwiZGVmZW5zaXZlX2ZsaWNrX3RyaWdnZXIiOiJTaW1wbGUiLCJkZWZlbnNpdmVfbW9kZSI6Ik5ldmVybG9zZSIsImRlZmVuc2l2ZV9tb2RlX2NoZWNrIjoiVGlja2Jhc2UiLCJkZWZlbnNpdmVfbW9kZV9tYXgiOjAuMCwiZGVmZW5zaXZlX21vZGVfbWluIjowLjAsImRlZmVuc2l2ZV9tb2RlX3RpY2siOjguMCwiZGVmZW5zaXZlX29ucGVlayI6ZmFsc2UsImRlZmVuc2l2ZV9waXRjaCI6IkRpc2FibGVkIiwiZGVmZW5zaXZlX3BpdGNoX2ppdHRlcl9zcGVlZCI6MS4wLCJkZWZlbnNpdmVfcGl0Y2hfbWF4IjowLjAsImRlZmVuc2l2ZV9waXRjaF9tYXhfMiI6MC4wLCJkZWZlbnNpdmVfcGl0Y2hfbWluIjowLjAsImRlZmVuc2l2ZV9waXRjaF9taW5fMiI6MC4wLCJkZWZlbnNpdmVfcGl0Y2hfc3BlZWQiOjEuMCwiZGVmZW5zaXZlX3BpdGNoX3N0YXRpYyI6MC4wLCJkZWZlbnNpdmVfcGl0Y2hfc3dpdGNoIjoxLjAsImRlZmVuc2l2ZV95YXciOiJEaXNhYmxlZCIsImRlZmVuc2l2ZV95YXdfYWRhcHRpdmUiOjAuMCwiZGVmZW5zaXZlX3lhd19jeWNsZV9pbnZlcnQiOmZhbHNlLCJkZWZlbnNpdmVfeWF3X2ZsaWNrIjpmYWxzZSwiZGVmZW5zaXZlX3lhd19mdWxsIjowLjAsImRlZmVuc2l2ZV95YXdfaml0dGVyX3NwZWVkIjoxLjAsImRlZmVuc2l2ZV95YXdfbWF4IjowLjAsImRlZmVuc2l2ZV95YXdfbWF4XzIiOjAuMCwiZGVmZW5zaXZlX3lhd19taW4iOjAuMCwiZGVmZW5zaXZlX3lhd19taW5fMiI6MC4wLCJkZWZlbnNpdmVfeWF3X3NwZWVkIjoxLjAsImRlZmVuc2l2ZV95YXdfc3RhdGljIjowLjAsImRlZmVuc2l2ZV95YXdfc3dpdGNoIjoxLjAsImRlbGF5X2Jhc2UiOmZhbHNlLCJkZWxheV9jeWNsZV9zcGVlZCI6MS4wLCJkZWxheV9qaXR0ZXJ0aWNrX3JlcGVhdCI6MTAuMCwiZGVsYXlfbWF4X3RpY2siOjEuMCwiZGVsYXlfbWluX3RpY2siOjEuMCwiZGVsYXlfbW9kZSI6IlN0YXRpYyIsImRlbGF5X3N0YXRpY190aWNrIjoxLjAsImRlc3luYyI6IlN0YXRpYyIsImRlc3luY19hbmdsZW1vZGUiOiJEaXNhYmxlZCIsImRlc3luY19hbnRpX2JydSI6ZmFsc2UsImRlc3luY19pbnZlcnQiOmZhbHNlLCJkZXN5bmNfbGVmdCI6MC4wLCJkZXN5bmNfcGVyaW9kIjpmYWxzZSwiZGVzeW5jX3JpZ2h0IjowLjAsImRlc3luY190aWNrIjo0LjAsImVuYWJsZSI6dHJ1ZSwibW9kaWZpZXJfbW9kZSI6IkRpc2FibGVkIiwibW9kaWZpZXJfbW9kZV9vZmZzZXQiOjAuMCwibW9kaWZpZXJfcmFuZG9tIjpmYWxzZSwibW9kaWZpZXJfcmFuZG9tX2RlZmF1bHQiOjAuMCwibW9kaWZpZXJfcmFuZG9tX21heCI6MC4wLCJtb2RpZmllcl9yYW5kb21fbWluIjowLjAsIm1vZGlmaWVyX3JhbmRvbV9tb2RlIjoiRGVmYXVsdCIsIm1vZGlmaWVyX3N3YXlfc3BlZWQiOjEuMCwieWF3X2ZsdWN0YXRlIjowLjAsInlhd19mbHVjdGF0ZV9lbmFibGUiOmZhbHNlLCJ5YXdfbGVmdCI6MC4wLCJ5YXdfbW9kZSI6IkppdHRlciIsInlhd19vZmZzZXQiOjAuMCwieWF3X3JpZ2h0IjowLjAsInlhd190YXJnZXQiOjAuMH0sImZha2UgbGFnIjp7ImRlZmVuc2l2ZSI6ZmFsc2UsImRlZmVuc2l2ZV9mbGlja190cmlnZ2VyIjoiU2ltcGxlIiwiZGVmZW5zaXZlX21vZGUiOiJOZXZlcmxvc2UiLCJkZWZlbnNpdmVfbW9kZV9jaGVjayI6IlRpY2tiYXNlIiwiZGVmZW5zaXZlX21vZGVfbWF4IjowLjAsImRlZmVuc2l2ZV9tb2RlX21pbiI6MC4wLCJkZWZlbnNpdmVfbW9kZV90aWNrIjo4LjAsImRlZmVuc2l2ZV9vbnBlZWsiOmZhbHNlLCJkZWZlbnNpdmVfcGl0Y2giOiJEaXNhYmxlZCIsImRlZmVuc2l2ZV9waXRjaF9qaXR0ZXJfc3BlZWQiOjEuMCwiZGVmZW5zaXZlX3BpdGNoX21heCI6MC4wLCJkZWZlbnNpdmVfcGl0Y2hfbWF4XzIiOjAuMCwiZGVmZW5zaXZlX3BpdGNoX21pbiI6MC4wLCJkZWZlbnNpdmVfcGl0Y2hfbWluXzIiOjAuMCwiZGVmZW5zaXZlX3BpdGNoX3NwZWVkIjoxLjAsImRlZmVuc2l2ZV9waXRjaF9zdGF0aWMiOjAuMCwiZGVmZW5zaXZlX3BpdGNoX3N3aXRjaCI6MS4wLCJkZWZlbnNpdmVfeWF3IjoiRGlzYWJsZWQiLCJkZWZlbnNpdmVfeWF3X2FkYXB0aXZlIjowLjAsImRlZmVuc2l2ZV95YXdfY3ljbGVfaW52ZXJ0IjpmYWxzZSwiZGVmZW5zaXZlX3lhd19mbGljayI6ZmFsc2UsImRlZmVuc2l2ZV95YXdfZnVsbCI6MC4wLCJkZWZlbnNpdmVfeWF3X2ppdHRlcl9zcGVlZCI6MS4wLCJkZWZlbnNpdmVfeWF3X21heCI6MC4wLCJkZWZlbnNpdmVfeWF3X21heF8yIjowLjAsImRlZmVuc2l2ZV95YXdfbWluIjowLjAsImRlZmVuc2l2ZV95YXdfbWluXzIiOjAuMCwiZGVmZW5zaXZlX3lhd19zcGVlZCI6MS4wLCJkZWZlbnNpdmVfeWF3X3N0YXRpYyI6MC4wLCJkZWZlbnNpdmVfeWF3X3N3aXRjaCI6MS4wLCJkZWxheV9iYXNlIjpmYWxzZSwiZGVsYXlfY3ljbGVfc3BlZWQiOjEuMCwiZGVsYXlfaml0dGVydGlja19yZXBlYXQiOjEwLjAsImRlbGF5X21heF90aWNrIjoxLjAsImRlbGF5X21pbl90aWNrIjoxLjAsImRlbGF5X21vZGUiOiJTdGF0aWMiLCJkZWxheV9zdGF0aWNfdGljayI6MS4wLCJkZXN5bmMiOiJTdGF0aWMiLCJkZXN5bmNfYW5nbGVtb2RlIjoiRGlzYWJsZWQiLCJkZXN5bmNfYW50aV9icnUiOmZhbHNlLCJkZXN5bmNfaW52ZXJ0IjpmYWxzZSwiZGVzeW5jX2xlZnQiOjAuMCwiZGVzeW5jX3BlcmlvZCI6ZmFsc2UsImRlc3luY19yaWdodCI6MC4wLCJkZXN5bmNfdGljayI6NC4wLCJlbmFibGUiOnRydWUsIm1vZGlmaWVyX21vZGUiOiJEaXNhYmxlZCIsIm1vZGlmaWVyX21vZGVfb2Zmc2V0IjowLjAsIm1vZGlmaWVyX3JhbmRvbSI6ZmFsc2UsIm1vZGlmaWVyX3JhbmRvbV9kZWZhdWx0IjowLjAsIm1vZGlmaWVyX3JhbmRvbV9tYXgiOjAuMCwibW9kaWZpZXJfcmFuZG9tX21pbiI6MC4wLCJtb2RpZmllcl9yYW5kb21fbW9kZSI6IkRlZmF1bHQiLCJtb2RpZmllcl9zd2F5X3NwZWVkIjoxLjAsInlhd19mbHVjdGF0ZSI6MC4wLCJ5YXdfZmx1Y3RhdGVfZW5hYmxlIjpmYWxzZSwieWF3X2xlZnQiOjAuMCwieWF3X21vZGUiOiJKaXR0ZXIiLCJ5YXdfb2Zmc2V0IjowLjAsInlhd19yaWdodCI6MC4wLCJ5YXdfdGFyZ2V0IjowLjB9LCJnbG9iYWwiOnsiZGVmZW5zaXZlIjpmYWxzZSwiZGVmZW5zaXZlX2ZsaWNrX3RyaWdnZXIiOiJTaW1wbGUiLCJkZWZlbnNpdmVfbW9kZSI6Ik5ldmVybG9zZSIsImRlZmVuc2l2ZV9tb2RlX2NoZWNrIjoiVGlja2Jhc2UiLCJkZWZlbnNpdmVfbW9kZV9tYXgiOjAuMCwiZGVmZW5zaXZlX21vZGVfbWluIjowLjAsImRlZmVuc2l2ZV9tb2RlX3RpY2siOjguMCwiZGVmZW5zaXZlX29ucGVlayI6ZmFsc2UsImRlZmVuc2l2ZV9waXRjaCI6IkRpc2FibGVkIiwiZGVmZW5zaXZlX3BpdGNoX2ppdHRlcl9zcGVlZCI6MS4wLCJkZWZlbnNpdmVfcGl0Y2hfbWF4IjowLjAsImRlZmVuc2l2ZV9waXRjaF9tYXhfMiI6MC4wLCJkZWZlbnNpdmVfcGl0Y2hfbWluIjowLjAsImRlZmVuc2l2ZV9waXRjaF9taW5fMiI6MC4wLCJkZWZlbnNpdmVfcGl0Y2hfc3BlZWQiOjEuMCwiZGVmZW5zaXZlX3BpdGNoX3N0YXRpYyI6MC4wLCJkZWZlbnNpdmVfcGl0Y2hfc3dpdGNoIjoxLjAsImRlZmVuc2l2ZV95YXciOiJEaXNhYmxlZCIsImRlZmVuc2l2ZV95YXdfYWRhcHRpdmUiOjAuMCwiZGVmZW5zaXZlX3lhd19jeWNsZV9pbnZlcnQiOmZhbHNlLCJkZWZlbnNpdmVfeWF3X2ZsaWNrIjpmYWxzZSwiZGVmZW5zaXZlX3lhd19mdWxsIjowLjAsImRlZmVuc2l2ZV95YXdfaml0dGVyX3NwZWVkIjoxLjAsImRlZmVuc2l2ZV95YXdfbWF4IjowLjAsImRlZmVuc2l2ZV95YXdfbWF4XzIiOjAuMCwiZGVmZW5zaXZlX3lhd19taW4iOjAuMCwiZGVmZW5zaXZlX3lhd19taW5fMiI6MC4wLCJkZWZlbnNpdmVfeWF3X3NwZWVkIjoxLjAsImRlZmVuc2l2ZV95YXdfc3RhdGljIjowLjAsImRlZmVuc2l2ZV95YXdfc3dpdGNoIjoxLjAsImRlbGF5X2Jhc2UiOmZhbHNlLCJkZWxheV9jeWNsZV9zcGVlZCI6MS4wLCJkZWxheV9qaXR0ZXJ0aWNrX3JlcGVhdCI6MTAuMCwiZGVsYXlfbWF4X3RpY2siOjEuMCwiZGVsYXlfbWluX3RpY2siOjEuMCwiZGVsYXlfbW9kZSI6IlN0YXRpYyIsImRlbGF5X3N0YXRpY190aWNrIjoxLjAsImRlc3luYyI6IkRpc2FibGVkIiwiZGVzeW5jX2FuZ2xlbW9kZSI6IkRpc2FibGVkIiwiZGVzeW5jX2FudGlfYnJ1IjpmYWxzZSwiZGVzeW5jX2ludmVydCI6ZmFsc2UsImRlc3luY19sZWZ0IjowLjAsImRlc3luY19wZXJpb2QiOmZhbHNlLCJkZXN5bmNfcmlnaHQiOjAuMCwiZGVzeW5jX3RpY2siOjQuMCwibW9kaWZpZXJfbW9kZSI6IkRpc2FibGVkIiwibW9kaWZpZXJfbW9kZV9vZmZzZXQiOjAuMCwibW9kaWZpZXJfcmFuZG9tIjpmYWxzZSwibW9kaWZpZXJfcmFuZG9tX2RlZmF1bHQiOjAuMCwibW9kaWZpZXJfcmFuZG9tX21heCI6MC4wLCJtb2RpZmllcl9yYW5kb21fbWluIjowLjAsIm1vZGlmaWVyX3JhbmRvbV9tb2RlIjoiRGVmYXVsdCIsIm1vZGlmaWVyX3N3YXlfc3BlZWQiOjEuMCwieWF3X2ZsdWN0YXRlIjowLjAsInlhd19mbHVjdGF0ZV9lbmFibGUiOmZhbHNlLCJ5YXdfbGVmdCI6MC4wLCJ5YXdfbW9kZSI6IkppdHRlciIsInlhd19vZmZzZXQiOjAuMCwieWF3X3JpZ2h0IjowLjAsInlhd190YXJnZXQiOjAuMH0sIm1vdmluZyI6eyJkZWZlbnNpdmUiOnRydWUsImRlZmVuc2l2ZV9mbGlja190cmlnZ2VyIjoiU2ltcGxlIiwiZGVmZW5zaXZlX21vZGUiOiJOZXZlcmxvc2UiLCJkZWZlbnNpdmVfbW9kZV9jaGVjayI6IlRpY2tiYXNlIiwiZGVmZW5zaXZlX21vZGVfbWF4IjowLjAsImRlZmVuc2l2ZV9tb2RlX21pbiI6MC4wLCJkZWZlbnNpdmVfbW9kZV90aWNrIjo4LjAsImRlZmVuc2l2ZV9vbnBlZWsiOmZhbHNlLCJkZWZlbnNpdmVfcGl0Y2giOiJEaXNhYmxlZCIsImRlZmVuc2l2ZV9waXRjaF9qaXR0ZXJfc3BlZWQiOjEuMCwiZGVmZW5zaXZlX3BpdGNoX21heCI6MC4wLCJkZWZlbnNpdmVfcGl0Y2hfbWF4XzIiOjAuMCwiZGVmZW5zaXZlX3BpdGNoX21pbiI6MC4wLCJkZWZlbnNpdmVfcGl0Y2hfbWluXzIiOjAuMCwiZGVmZW5zaXZlX3BpdGNoX3NwZWVkIjoxLjAsImRlZmVuc2l2ZV9waXRjaF9zdGF0aWMiOjAuMCwiZGVmZW5zaXZlX3BpdGNoX3N3aXRjaCI6MS4wLCJkZWZlbnNpdmVfeWF3IjoiRGlzYWJsZWQiLCJkZWZlbnNpdmVfeWF3X2FkYXB0aXZlIjowLjAsImRlZmVuc2l2ZV95YXdfY3ljbGVfaW52ZXJ0IjpmYWxzZSwiZGVmZW5zaXZlX3lhd19mbGljayI6ZmFsc2UsImRlZmVuc2l2ZV95YXdfZnVsbCI6MC4wLCJkZWZlbnNpdmVfeWF3X2ppdHRlcl9zcGVlZCI6MS4wLCJkZWZlbnNpdmVfeWF3X21heCI6MC4wLCJkZWZlbnNpdmVfeWF3X21heF8yIjowLjAsImRlZmVuc2l2ZV95YXdfbWluIjowLjAsImRlZmVuc2l2ZV95YXdfbWluXzIiOjAuMCwiZGVmZW5zaXZlX3lhd19zcGVlZCI6MS4wLCJkZWZlbnNpdmVfeWF3X3N0YXRpYyI6MC4wLCJkZWZlbnNpdmVfeWF3X3N3aXRjaCI6MS4wLCJkZWxheV9iYXNlIjpmYWxzZSwiZGVsYXlfY3ljbGVfc3BlZWQiOjEuMCwiZGVsYXlfaml0dGVydGlja19yZXBlYXQiOjEwLjAsImRlbGF5X21heF90aWNrIjo2LjAsImRlbGF5X21pbl90aWNrIjoxLjAsImRlbGF5X21vZGUiOiJSYW5kb20iLCJkZWxheV9zdGF0aWNfdGljayI6MS4wLCJkZXN5bmMiOiJKaXR0ZXIiLCJkZXN5bmNfYW5nbGVtb2RlIjoiRGlzYWJsZWQiLCJkZXN5bmNfYW50aV9icnUiOmZhbHNlLCJkZXN5bmNfaW52ZXJ0IjpmYWxzZSwiZGVzeW5jX2xlZnQiOjYwLjAsImRlc3luY19wZXJpb2QiOmZhbHNlLCJkZXN5bmNfcmlnaHQiOjYwLjAsImRlc3luY190aWNrIjo0LjAsImVuYWJsZSI6dHJ1ZSwibW9kaWZpZXJfbW9kZSI6IkppdHRlciIsIm1vZGlmaWVyX21vZGVfb2Zmc2V0IjowLjAsIm1vZGlmaWVyX3JhbmRvbSI6ZmFsc2UsIm1vZGlmaWVyX3JhbmRvbV9kZWZhdWx0IjowLjAsIm1vZGlmaWVyX3JhbmRvbV9tYXgiOjAuMCwibW9kaWZpZXJfcmFuZG9tX21pbiI6MC4wLCJtb2RpZmllcl9yYW5kb21fbW9kZSI6IkRlZmF1bHQiLCJtb2RpZmllcl9zd2F5X3NwZWVkIjoxLjAsInlhd19mbHVjdGF0ZSI6MC4wLCJ5YXdfZmx1Y3RhdGVfZW5hYmxlIjpmYWxzZSwieWF3X2xlZnQiOjE2LjAsInlhd19tb2RlIjoiSml0dGVyIiwieWF3X29mZnNldCI6MC4wLCJ5YXdfcmlnaHQiOi0yLjAsInlhd190YXJnZXQiOjAuMH0sInNsb3ciOnsiZGVmZW5zaXZlIjp0cnVlLCJkZWZlbnNpdmVfZmxpY2tfdHJpZ2dlciI6IlNpbXBsZSIsImRlZmVuc2l2ZV9tb2RlIjoiRmxpY2siLCJkZWZlbnNpdmVfbW9kZV9jaGVjayI6IlRpY2tiYXNlIiwiZGVmZW5zaXZlX21vZGVfbWF4IjoxNS4wLCJkZWZlbnNpdmVfbW9kZV9taW4iOjcuMCwiZGVmZW5zaXZlX21vZGVfdGljayI6OC4wLCJkZWZlbnNpdmVfb25wZWVrIjpmYWxzZSwiZGVmZW5zaXZlX3BpdGNoIjoiUmFuZG9tIFN0YXRpYyIsImRlZmVuc2l2ZV9waXRjaF9qaXR0ZXJfc3BlZWQiOjIwLjAsImRlZmVuc2l2ZV9waXRjaF9tYXgiOjIwLjAsImRlZmVuc2l2ZV9waXRjaF9tYXhfMiI6MC4wLCJkZWZlbnNpdmVfcGl0Y2hfbWluIjotMjAuMCwiZGVmZW5zaXZlX3BpdGNoX21pbl8yIjowLjAsImRlZmVuc2l2ZV9waXRjaF9zcGVlZCI6MS4wLCJkZWZlbnNpdmVfcGl0Y2hfc3RhdGljIjowLjAsImRlZmVuc2l2ZV9waXRjaF9zd2l0Y2giOjEuMCwiZGVmZW5zaXZlX3lhdyI6IlN0YXRpYyIsImRlZmVuc2l2ZV95YXdfYWRhcHRpdmUiOjAuMCwiZGVmZW5zaXZlX3lhd19jeWNsZV9pbnZlcnQiOmZhbHNlLCJkZWZlbnNpdmVfeWF3X2ZsaWNrIjpmYWxzZSwiZGVmZW5zaXZlX3lhd19mdWxsIjowLjAsImRlZmVuc2l2ZV95YXdfaml0dGVyX3NwZWVkIjoxLjAsImRlZmVuc2l2ZV95YXdfbWF4IjotMTEwLjAsImRlZmVuc2l2ZV95YXdfbWF4XzIiOjAuMCwiZGVmZW5zaXZlX3lhd19taW4iOjk1LjAsImRlZmVuc2l2ZV95YXdfbWluXzIiOjAuMCwiZGVmZW5zaXZlX3lhd19zcGVlZCI6MS4wLCJkZWZlbnNpdmVfeWF3X3N0YXRpYyI6LTExMC4wLCJkZWZlbnNpdmVfeWF3X3N3aXRjaCI6MS4wLCJkZWxheV9iYXNlIjpmYWxzZSwiZGVsYXlfY3ljbGVfc3BlZWQiOjEuMCwiZGVsYXlfaml0dGVydGlja19yZXBlYXQiOjEwLjAsImRlbGF5X21heF90aWNrIjoxLjAsImRlbGF5X21pbl90aWNrIjoxLjAsImRlbGF5X21vZGUiOiJTdGF0aWMiLCJkZWxheV9zdGF0aWNfdGljayI6MS4wLCJkZXN5bmMiOiJTdGF0aWMiLCJkZXN5bmNfYW5nbGVtb2RlIjoiRGlzYWJsZWQiLCJkZXN5bmNfYW50aV9icnUiOmZhbHNlLCJkZXN5bmNfaW52ZXJ0IjpmYWxzZSwiZGVzeW5jX2xlZnQiOjAuMCwiZGVzeW5jX3BlcmlvZCI6ZmFsc2UsImRlc3luY19yaWdodCI6MzAuMCwiZGVzeW5jX3RpY2siOjQuMCwiZW5hYmxlIjp0cnVlLCJtb2RpZmllcl9tb2RlIjoiRGlzYWJsZWQiLCJtb2RpZmllcl9tb2RlX29mZnNldCI6MC4wLCJtb2RpZmllcl9yYW5kb20iOmZhbHNlLCJtb2RpZmllcl9yYW5kb21fZGVmYXVsdCI6MC4wLCJtb2RpZmllcl9yYW5kb21fbWF4IjowLjAsIm1vZGlmaWVyX3JhbmRvbV9taW4iOjAuMCwibW9kaWZpZXJfcmFuZG9tX21vZGUiOiJEZWZhdWx0IiwibW9kaWZpZXJfc3dheV9zcGVlZCI6MS4wLCJ5YXdfZmx1Y3RhdGUiOjAuMCwieWF3X2ZsdWN0YXRlX2VuYWJsZSI6ZmFsc2UsInlhd19sZWZ0IjowLjAsInlhd19tb2RlIjoiSml0dGVyIiwieWF3X29mZnNldCI6MC4wLCJ5YXdfcmlnaHQiOjAuMCwieWF3X3RhcmdldCI6MC4wfSwic25lYWsiOnsiZGVmZW5zaXZlIjp0cnVlLCJkZWZlbnNpdmVfZmxpY2tfdHJpZ2dlciI6IlNpbXBsZSIsImRlZmVuc2l2ZV9tb2RlIjoiRmxpY2siLCJkZWZlbnNpdmVfbW9kZV9jaGVjayI6IlRpY2tiYXNlIiwiZGVmZW5zaXZlX21vZGVfbWF4IjoxNS4wLCJkZWZlbnNpdmVfbW9kZV9taW4iOjQuMCwiZGVmZW5zaXZlX21vZGVfdGljayI6OC4wLCJkZWZlbnNpdmVfb25wZWVrIjpmYWxzZSwiZGVmZW5zaXZlX3BpdGNoIjoiSml0dGVyIiwiZGVmZW5zaXZlX3BpdGNoX2ppdHRlcl9zcGVlZCI6MS4wLCJkZWZlbnNpdmVfcGl0Y2hfbWF4Ijo0NS4wLCJkZWZlbnNpdmVfcGl0Y2hfbWF4XzIiOjAuMCwiZGVmZW5zaXZlX3BpdGNoX21pbiI6LTQ1LjAsImRlZmVuc2l2ZV9waXRjaF9taW5fMiI6MC4wLCJkZWZlbnNpdmVfcGl0Y2hfc3BlZWQiOjEuMCwiZGVmZW5zaXZlX3BpdGNoX3N0YXRpYyI6LTg5LjAsImRlZmVuc2l2ZV9waXRjaF9zd2l0Y2giOjEuMCwiZGVmZW5zaXZlX3lhdyI6IkppdHRlciIsImRlZmVuc2l2ZV95YXdfYWRhcHRpdmUiOjAuMCwiZGVmZW5zaXZlX3lhd19jeWNsZV9pbnZlcnQiOmZhbHNlLCJkZWZlbnNpdmVfeWF3X2ZsaWNrIjpmYWxzZSwiZGVmZW5zaXZlX3lhd19mdWxsIjowLjAsImRlZmVuc2l2ZV95YXdfaml0dGVyX3NwZWVkIjoxLjAsImRlZmVuc2l2ZV95YXdfbWF4Ijo5MC4wLCJkZWZlbnNpdmVfeWF3X21heF8yIjowLjAsImRlZmVuc2l2ZV95YXdfbWluIjotOTAuMCwiZGVmZW5zaXZlX3lhd19taW5fMiI6MC4wLCJkZWZlbnNpdmVfeWF3X3NwZWVkIjoxMC4wLCJkZWZlbnNpdmVfeWF3X3N0YXRpYyI6LTkwLjAsImRlZmVuc2l2ZV95YXdfc3dpdGNoIjoxLjAsImRlbGF5X2Jhc2UiOmZhbHNlLCJkZWxheV9jeWNsZV9zcGVlZCI6MS4wLCJkZWxheV9qaXR0ZXJ0aWNrX3JlcGVhdCI6MTAuMCwiZGVsYXlfbWF4X3RpY2siOjEuMCwiZGVsYXlfbWluX3RpY2siOjEuMCwiZGVsYXlfbW9kZSI6IlN0YXRpYyIsImRlbGF5X3N0YXRpY190aWNrIjoxLjAsImRlc3luYyI6IlN0YXRpYyIsImRlc3luY19hbmdsZW1vZGUiOiJEaXNhYmxlZCIsImRlc3luY19hbnRpX2JydSI6ZmFsc2UsImRlc3luY19pbnZlcnQiOmZhbHNlLCJkZXN5bmNfbGVmdCI6MC4wLCJkZXN5bmNfcGVyaW9kIjpmYWxzZSwiZGVzeW5jX3JpZ2h0IjowLjAsImRlc3luY190aWNrIjo0LjAsImVuYWJsZSI6dHJ1ZSwibW9kaWZpZXJfbW9kZSI6IkRpc2FibGVkIiwibW9kaWZpZXJfbW9kZV9vZmZzZXQiOjAuMCwibW9kaWZpZXJfcmFuZG9tIjpmYWxzZSwibW9kaWZpZXJfcmFuZG9tX2RlZmF1bHQiOjAuMCwibW9kaWZpZXJfcmFuZG9tX21heCI6MC4wLCJtb2RpZmllcl9yYW5kb21fbWluIjowLjAsIm1vZGlmaWVyX3JhbmRvbV9tb2RlIjoiRGVmYXVsdCIsIm1vZGlmaWVyX3N3YXlfc3BlZWQiOjEuMCwieWF3X2ZsdWN0YXRlIjowLjAsInlhd19mbHVjdGF0ZV9lbmFibGUiOmZhbHNlLCJ5YXdfbGVmdCI6MC4wLCJ5YXdfbW9kZSI6IkppdHRlciIsInlhd19vZmZzZXQiOjkuMCwieWF3X3JpZ2h0IjowLjAsInlhd190YXJnZXQiOjExLjB9LCJzdGFuZCI6eyJkZWZlbnNpdmUiOnRydWUsImRlZmVuc2l2ZV9mbGlja190cmlnZ2VyIjoiU2ltcGxlIiwiZGVmZW5zaXZlX21vZGUiOiJOZXZlcmxvc2UiLCJkZWZlbnNpdmVfbW9kZV9jaGVjayI6IlRpY2tiYXNlIiwiZGVmZW5zaXZlX21vZGVfbWF4IjowLjAsImRlZmVuc2l2ZV9tb2RlX21pbiI6MC4wLCJkZWZlbnNpdmVfbW9kZV90aWNrIjo4LjAsImRlZmVuc2l2ZV9vbnBlZWsiOmZhbHNlLCJkZWZlbnNpdmVfcGl0Y2giOiJEaXNhYmxlZCIsImRlZmVuc2l2ZV9waXRjaF9qaXR0ZXJfc3BlZWQiOjEuMCwiZGVmZW5zaXZlX3BpdGNoX21heCI6MC4wLCJkZWZlbnNpdmVfcGl0Y2hfbWF4XzIiOjAuMCwiZGVmZW5zaXZlX3BpdGNoX21pbiI6MC4wLCJkZWZlbnNpdmVfcGl0Y2hfbWluXzIiOjAuMCwiZGVmZW5zaXZlX3BpdGNoX3NwZWVkIjoxLjAsImRlZmVuc2l2ZV9waXRjaF9zdGF0aWMiOjAuMCwiZGVmZW5zaXZlX3BpdGNoX3N3aXRjaCI6MS4wLCJkZWZlbnNpdmVfeWF3IjoiRGlzYWJsZWQiLCJkZWZlbnNpdmVfeWF3X2FkYXB0aXZlIjowLjAsImRlZmVuc2l2ZV95YXdfY3ljbGVfaW52ZXJ0IjpmYWxzZSwiZGVmZW5zaXZlX3lhd19mbGljayI6ZmFsc2UsImRlZmVuc2l2ZV95YXdfZnVsbCI6MC4wLCJkZWZlbnNpdmVfeWF3X2ppdHRlcl9zcGVlZCI6MS4wLCJkZWZlbnNpdmVfeWF3X21heCI6MC4wLCJkZWZlbnNpdmVfeWF3X21heF8yIjowLjAsImRlZmVuc2l2ZV95YXdfbWluIjowLjAsImRlZmVuc2l2ZV95YXdfbWluXzIiOjAuMCwiZGVmZW5zaXZlX3lhd19zcGVlZCI6MS4wLCJkZWZlbnNpdmVfeWF3X3N0YXRpYyI6MC4wLCJkZWZlbnNpdmVfeWF3X3N3aXRjaCI6MS4wLCJkZWxheV9iYXNlIjpmYWxzZSwiZGVsYXlfY3ljbGVfc3BlZWQiOjEuMCwiZGVsYXlfaml0dGVydGlja19yZXBlYXQiOjEwLjAsImRlbGF5X21heF90aWNrIjoxLjAsImRlbGF5X21pbl90aWNrIjoxLjAsImRlbGF5X21vZGUiOiJTdGF0aWMiLCJkZWxheV9zdGF0aWNfdGljayI6MS4wLCJkZXN5bmMiOiJTdGF0aWMiLCJkZXN5bmNfYW5nbGVtb2RlIjoiRGlzYWJsZWQiLCJkZXN5bmNfYW50aV9icnUiOmZhbHNlLCJkZXN5bmNfaW52ZXJ0IjpmYWxzZSwiZGVzeW5jX2xlZnQiOjAuMCwiZGVzeW5jX3BlcmlvZCI6ZmFsc2UsImRlc3luY19yaWdodCI6MC4wLCJkZXN5bmNfdGljayI6NC4wLCJlbmFibGUiOnRydWUsIm1vZGlmaWVyX21vZGUiOiJEaXNhYmxlZCIsIm1vZGlmaWVyX21vZGVfb2Zmc2V0IjowLjAsIm1vZGlmaWVyX3JhbmRvbSI6ZmFsc2UsIm1vZGlmaWVyX3JhbmRvbV9kZWZhdWx0IjowLjAsIm1vZGlmaWVyX3JhbmRvbV9tYXgiOjAuMCwibW9kaWZpZXJfcmFuZG9tX21pbiI6MC4wLCJtb2RpZmllcl9yYW5kb21fbW9kZSI6IkRlZmF1bHQiLCJtb2RpZmllcl9zd2F5X3NwZWVkIjoxLjAsInlhd19mbHVjdGF0ZSI6MC4wLCJ5YXdfZmx1Y3RhdGVfZW5hYmxlIjpmYWxzZSwieWF3X2xlZnQiOjAuMCwieWF3X21vZGUiOiJKaXR0ZXIiLCJ5YXdfb2Zmc2V0IjowLjAsInlhd19yaWdodCI6MC4wLCJ5YXdfdGFyZ2V0IjowLjB9fV0="
};
v329.config_UI = {
    cfg_selector = v329.tab.config_sub:list("", {}), 
    name = v329.tab.config_sub:input("Config Name", ""), 
    create = v329.tab.config_sub:button("Create", function()
        -- upvalues: v1436 (ref)
        v1436:save();
    end, true), 
    load = v329.tab.config_sub:button("Load", function()
        -- upvalues: v1436 (ref)
        v1436:load();
    end, true), 
    save = v329.tab.config_sub:button("\a43A047FF " .. v323.get("floppy-disk") .. "  Save", function()
        -- upvalues: v1436 (ref)
        v1436:save();
    end, true), 
    import = v329.tab.config_sub:button("\aFBC02DFF " .. v323.get("file-import") .. " Import", function()
        -- upvalues: l_clipboard_0 (ref), v1436 (ref)
        local v1438 = (l_clipboard_0.get() or ""):gsub("^%s+", "");
        if v1438:find("{Trashhode:config}") then
            v1436:import(v1438, "config");
        else
            print("Clipboard does not contain a Trashhode config");
        end;
    end, true), 
    export = v329.tab.config_sub:button("\a1E88E5FF " .. v323.get("file-export") .. " Export", function()
        -- upvalues: l_clipboard_0 (ref), v1436 (ref)
        l_clipboard_0.set(v1436:export("config"));
    end, true), 
    remove = v329.tab.config_sub:button("\aFF4F4FB4 " .. v323.get("trash-xmark") .. " Delete", function()
        -- upvalues: v1436 (ref)
        v1436:delete();
    end, true), 
    default = v329.tab.preset:button("Default", function()

    end, true), 
    tank = v329.tab.preset:button("Tank", function()

    end, true)
};
v329.config_UI.default:set_callback(function()
    -- upvalues: v1436 (ref), v1437 (ref)
    v1436:import(v1437.Default, "config");
    print("[Trashhode] Default preset loaded");
end);
v329.config_UI.tank:set_callback(function()
    -- upvalues: v1436 (ref), v1437 (ref)
    v1436:import(v1437.Tank, "config");
    print("[Trashhode] Tank preset loaded");
end);
v329.config_UI.cfg_selector:set_callback(function(v1439)
    -- upvalues: v1436 (ref), v329 (ref)
    local v1440 = (v1436._sorted_names or {})[v1439] or "";
    v329.config_UI.name(v1440);
end);
l_pui_0.traverse(v329.config_UI, function(v1441)
    -- upvalues: v329 (ref)
    v1441:depend({
        [1] = nil, 
        [2] = 2, 
        [1] = v329.page
    });
end);
v1436.write_file = function(_, v1443)
    -- upvalues: v1404 (ref)
    files.write(v1404, json.stringify(v1443));
end;
v1436.update_name = function(v1444)
    -- upvalues: v329 (ref)
    local v1445 = v329.config_UI.cfg_selector();
    local v1446 = 1;
    for v1447 in pairs(v1444.configs) do
        if v1445 == v1446 or v1445 == 0 then
            return v329.config_UI.name(v1447);
        else
            v1446 = v1446 + 1;
        end;
    end;
end;
v1436.update_configs = function(v1448)
    -- upvalues: v329 (ref)
    local v1449 = {};
    for v1450 in pairs(v1448.configs) do
        v1449[#v1449 + 1] = v1450;
    end;
    table.sort(v1449);
    v1448._sorted_names = v1449;
    v329.config_UI.cfg_selector:update(v1449);
    v1448:write_file(v1448.configs);
    v1448:update_name();
end;
v1436.get_current_name = function(v1451)
    -- upvalues: v329 (ref)
    local v1452 = v329.config_UI.name();
    if v1452:match("%w") then
        return v1452;
    else
        local v1453 = v329.config_UI.cfg_selector();
        return (v1451._sorted_names or {})[v1453];
    end;
end;
v1436.setup = function(v1454)
    -- upvalues: v1404 (ref)
    local v1455 = files.read(v1404);
    v1454.configs = v1455 and (json.parse(v1455) or {}) or {};
    v1454:update_configs();
end;
v1436.export_config = function(_)
    -- upvalues: l_pui_0 (ref), v329 (ref), l_link_0 (ref), v330 (ref), l_base64_0 (ref)
    local v1457 = l_pui_0.setup({
        [1] = v329, 
        [2] = l_link_0, 
        [3] = v330
    }, true);
    return l_base64_0.encode(json.stringify(v1457:save()));
end;
v1436.export = function(v1458, v1459, ...)
    local l_status_5, l_result_5 = pcall(v1458["export_" .. v1459], v1458, ...);
    return l_status_5 and "{Trashhode:" .. v1459 .. "}:" .. l_result_5 or "";
end;
v1436.import_config = function(_, v1463)
    -- upvalues: l_base64_0 (ref), l_pui_0 (ref), v329 (ref), l_link_0 (ref), v330 (ref)
    local v1464 = json.parse(l_base64_0.decode(v1463));
    l_pui_0.setup({
        [1] = v329, 
        [2] = l_link_0, 
        [3] = v330
    }, true):load(v1464);
end;
v1436.import = function(v1465, v1466, v1467, ...)
    local v1468 = v1466:match("{Trashhode:(%w+)}");
    assert(v1468 == v1467, "Tag mismatch");
    local v1469 = v1466:gsub("^.-}%s*:?", ""):gsub("%s+", ""):gsub("-", "+"):gsub("_", "/");
    v1469 = v1469 .. string.rep("=", (4 - #v1469 % 4) % 4);
    assert(v1465["import_" .. v1468], "unknown tag " .. v1468);
    return v1465["import_" .. v1468](v1465, v1469, ...);
end;
v1436.save = function(v1470)
    -- upvalues: v329 (ref)
    local v1471 = v1470:get_current_name();
    if not v1471 then
        return print("Invalid name");
    else
        v1470.configs[v1471] = v1470:export("config");
        v1470:update_configs();
        for v1472, v1473 in ipairs(v1470._sorted_names) do
            if v1473 == v1471 then
                v329.config_UI.cfg_selector(v1472);
                break;
            end;
        end;
        return;
    end;
end;
v1436.load = function(v1474)
    -- upvalues: v329 (ref)
    local v1475 = v1474:get_current_name();
    local v1476 = v1474.configs[v1475];
    if not v1476 then
        return print("Invalid name");
    else
        v1474:import(v1476, "config");
        local l_ipairs_0 = ipairs;
        local v1478 = v1474._sorted_names or {};
        for v1479, v1480 in l_ipairs_0(v1478) do
            if v1480 == v1475 then
                v329.config_UI.cfg_selector(v1479);
                v329.config_UI.name(v1480);
                break;
            end;
        end;
        return;
    end;
end;
v1436.delete = function(v1481)
    local v1482 = v1481:get_current_name();
    if v1481.configs[v1482] then
        v1481.configs[v1482] = nil;
        v1481:update_configs();
    else
        print("Invalid name");
    end;
end;
v1436:setup();
local v1483 = render.screen_size().y * 0.45;
local v1484 = v1310.new("watermark", {
    clamped = true
}):set_anchor(vector(0, 0)):set_pos(vector(30, v1483)):build();
local v1485 = 4;
local v1486 = 2;
local v1521 = {
    on_render = function(_)
        -- upvalues: l_gradient_0 (ref), v1485 (ref), v1486 (ref), v1484 (ref)
        if not globals.is_in_game then
            return;
        else
            local v1488 = common.get_username();
            local v1489 = ui.get_style("Active Text");
            local v1490 = color(144, 203, 251, 255):to_hex();
            local v1491 = l_gradient_0.text_animate("B E T A U S E R", -1, {
                color(255, 255, 255), 
                color(91, 91, 91)
            });
            local v1492 = l_gradient_0.text_animate("D E V E L O P E R", -1.5, {
                color(255, 255, 255), 
                color(91, 91, 91)
            });
            local v1493 = l_gradient_0.text_animate("R E C O D E", -1.3, {
                color(255, 255, 255), 
                color(91, 91, 91)
            });
            local v1494 = l_gradient_0.text_animate("S U P P O R T E R", -1.5, {
                color(255, 255, 255), 
                color(91, 91, 91)
            });
            local v1495 = l_gradient_0.text_animate("O W N E R", -1.3, {
                color(255, 255, 255), 
                color(91, 91, 91)
            });
            local v1496 = nil;
            local v1497 = nil;
            local v1498 = nil;
            if v1488 == "920250763" or v1488 == "JKCKMK2" then
                local v1499 = "E N T R O P Y";
                local v1500 = v1491:get_animated_text();
                v1498 = "[" .. v1488 .. "]";
                v1497 = v1500;
                v1496 = v1499;
            elseif v1488 == "entropy-tech" then
                local v1501 = "P A S T E H O D E";
                local v1502 = v1492:get_animated_text();
                v1498 = "[CODER]";
                v1497 = v1502;
                v1496 = v1501;
            elseif v1488 == "3543496802" then
                local v1503 = "P A S T E H O D E";
                local v1504 = v1494:get_animated_text();
                v1498 = "[3543496802]";
                v1497 = v1504;
                v1496 = v1503;
            elseif v1488 == "L0u14" then
                local v1505 = "P A S T E H O D E";
                local v1506 = v1495:get_animated_text();
                v1498 = "[L0u14]";
                v1497 = v1506;
                v1496 = v1505;
            else
                local v1507 = "P A S T E H O D E";
                local v1508 = v1493:get_animated_text();
                v1498 = "[DEV]";
                v1497 = v1508;
                v1496 = v1507;
            end;
            local v1509 = "\a" .. v1490 .. v1496 .. " - " .. v1497 .. " \aEB6161FF" .. v1498;
            local v1510 = render.measure_text(4, "", v1509);
            local v1511 = v1510 + vector(v1485 * 2, v1486 * 2);
            v1484:set_size(v1511);
            local v1512 = v1484:get_pos();
            if ui.get_alpha() > 0 or v1484.is_dragged then
                local l_v1512_0 = v1512;
                local v1514 = v1512 + v1511;
                render.rect_outline(l_v1512_0, v1514, color(200, 200, 200, math.floor(120 * (v1484.is_dragged and 1 or ui.get_alpha()))), 1, 4);
            end;
            render.text(4, v1512 + vector(v1485, v1486), v1489, nil, v1509);
            local v1515 = "\a" .. v1490 .. v1496 .. " - " .. v1497;
            local v1516 = " \aEB6161FF" .. v1498;
            local v1517 = render.measure_text(4, "", v1516);
            local _ = render.measure_text(4, "", v1515);
            local v1519 = v1510.x - v1517.x - 10;
            local _ = v1512 + vector(v1517.x + 110, v1510.y - 3);
            render.shadow(v1512 + 8, v1512 + vector(v1519, 0) + 8, color(144, 203, 251, 255));
            v1491:animate();
            v1492:animate();
            v1493:animate();
            v1494:animate();
            v1495:animate();
            return;
        end;
    end
};
v64[#v64 + 1] = setmetatable(v1521, {
    __call = v1521.on_render
});
local v1522 = {};
local v1523 = render.screen_size();
local v1524 = v1310.new("debug_panel", {
    clamped = true
}):set_anchor(vector(1, 0)):set_pos(vector(v1523.x - 20, 70)):build();
local v1525 = 4;
local v1526 = 3;
local v1527 = 2;
local _ = 4;
local _ = ui.get_style("Link Active");
local v1530 = "\a90CBFBFFTrashhode\aDEFAULT  " .. v323.get("minus") .. "  Debug Panel";
local v1531 = 0;
v1522.on_render = function(_)
    -- upvalues: l_config_sub_0 (ref), v15 (ref), v71 (ref), l_aim_0 (ref), v1530 (ref), v1527 (ref), v1531 (ref), v1525 (ref), v1526 (ref), v1524 (ref)
    if not l_config_sub_0.visual.panel:get() then
        return;
    else
        local v1533 = rage.exploit:get() < 1 and "\aFFFF00FFCharging" or "\a30FF00FFCharged";
        local v1534 = v15.rage.dt:get() and v1533 or "\aFF0000FFDisabled";
        local v1535 = v71.get_left_right();
        local v1536 = math.defensive_state();
        if not v1536 or not v1535 then
            return;
        else
            local v1537 = v15.rage.dmg:get_override() or v15.rage.dmg:get();
            local v1538 = v15.rage.hitbox:get_override();
            local v1539 = "";
            if v1538 == nil then
                v1539 = "\aFF0000FFDisabled";
            else
                local v1540 = table.unpack(v1538);
                v1539 = (not (v1540 ~= "Chest") or v1540 == "Stomach") and "\a30FF00FFEnabled" or "\aFF0000FFDisabled";
            end;
            local v1541 = "None";
            local v1542 = entity.get_threat();
            if v1542 then
                local v1543 = v1542:get_name();
                if v1543 and v1543 ~= "" then
                    v1541 = v1543;
                end;
            end;
            v1542 = l_aim_0.get_desync_delta();
            local v1544 = math.floor(v1542 + 0.5);
            local v1545 = {
                [1] = {
                    font = 4, 
                    txt = "aa"
                }, 
                [2] = {
                    font = 1, 
                    txt = "- Defensive State : " .. v1536
                }, 
                [3] = {
                    font = 1, 
                    txt = "- AA-Side : " .. v1535
                }, 
                [4] = {
                    font = 1, 
                    txt = ""
                }, 
                [5] = {
                    font = 4, 
                    txt = "rage"
                }, 
                [6] = {
                    font = 1, 
                    txt = "- Lethal Baim : " .. v1539
                }, 
                [7] = {
                    font = 1, 
                    txt = "- Dmg : " .. v1537
                }, 
                [8] = {
                    font = 1, 
                    txt = "- Threat : " .. v1541
                }, 
                [9] = {
                    font = 1, 
                    txt = ""
                }, 
                [10] = {
                    font = 4, 
                    txt = "exploit"
                }, 
                [11] = {
                    font = 1, 
                    txt = "- DT State : " .. v1534
                }, 
                [12] = {
                    font = 1, 
                    txt = "- Desync Angle : " .. v1544
                }
            };
            local v1546 = 0;
            local v1547 = render.measure_text(4, "", v1530);
            local l_x_9 = v1547.x;
            local l_y_5 = v1547.y;
            for _, v1551 in ipairs(v1545) do
                local v1552 = v1551.txt ~= "" and v1551.txt or " ";
                local v1553 = render.measure_text(v1551.font, "", v1552);
                l_x_9 = math.max(l_x_9, v1546 + v1553.x);
                l_y_5 = l_y_5 + v1553.y + v1527;
            end;
            l_y_5 = l_y_5 - v1527 + render.measure_text(1, "", " ").y;
            v1531 = math.max(v1531, l_x_9);
            local v1554 = vector(v1531 + v1525 * 2, l_y_5 + v1526 * 3);
            v1524:set_size(v1554);
            local v1555 = v1524:get_pos();
            local v1556 = ui.get_alpha() > 0;
            local l_is_dragged_1 = v1524.is_dragged;
            local v1558;
            if v1556 then
                v1558 = l_is_dragged_1 and 0.5 or 1;
            else
                v1558 = 0;
            end;
            if v1558 > 0.02 then
                local v1559 = color(200, 200, 200, math.floor(128 * v1558));
                render.rect_outline(v1555, v1555 + v1554, v1559, 1, 4);
            end;
            render.text(4, vector(v1555.x + v1525, v1555.y + v1526), color(255, 255, 255), nil, v1530);
            local v1560 = v1555.y + v1526 + v1547.y + render.measure_text(1, "", " ").y;
            local v1561 = v1555.x + v1525;
            for _, v1563 in ipairs(v1545) do
                if v1563.txt ~= "" then
                    render.text(v1563.font, vector(v1561, v1560), color(255, 255, 255), nil, v1563.txt);
                end;
                v1560 = v1560 + render.measure_text(v1563.font, "", v1563.txt ~= "" and v1563.txt or " ").y + v1527;
            end;
            return;
        end;
    end;
end;
v64[#v64 + 1] = setmetatable(v1522, {
    __call = v1522.on_render
});
local v1576 = {
    RESOLUTION = 9.25925925925926E-4, 
    alpha = l_smoothy_0.new(0), 
    on_render = function(v1564)
        -- upvalues: l_config_sub_0 (ref), v15 (ref)
        local v1565 = l_config_sub_0.visual.scope:get();
        v15.visual.scope:override(v1565 and "Remove All" or "Remove Overlay");
        if not l_config_sub_0.visual.scope:get() then
            return;
        else
            local v1566 = entity.get_local_player();
            if v1566 == nil or not v1566:is_alive() then
                return;
            else
                local v1567 = v1564.alpha(0.05, v1566.m_bIsScoped);
                if v1567 <= 0.01 then
                    return;
                else
                    local v1568 = render.screen_size();
                    local v1569 = v1568 * 0.5;
                    local v1570 = l_config_sub_0.visual_scope.color:get();
                    local v1571 = l_config_sub_0.visual_scope.offset:get() * v1568.y * v1564.RESOLUTION;
                    local v1572 = l_config_sub_0.visual_scope.pos:get() * v1568.y * v1564.RESOLUTION;
                    v1571 = math.floor(v1571);
                    v1572 = math.floor(v1572);
                    local v1573 = color(v1570.r, v1570.g, v1570.b, math.floor(v1570.a * v1567));
                    local v1574 = color(v1570.r, v1570.g, v1570.b, 0);
                    local v1575 = l_config_sub_0.visual_scope.rotate:get();
                    if v1575 then
                        render.push_rotation(45);
                    end;
                    render.gradient(vector(v1569.x, v1569.y - v1571 + 1), vector(v1569.x + 1, v1569.y - v1572), v1573, v1573, v1574, v1574);
                    render.gradient(vector(v1569.x, v1569.y + v1571), vector(v1569.x + 1, v1569.y + v1572), v1573, v1573, v1574, v1574);
                    render.gradient(vector(v1569.x - v1571 + 1, v1569.y), vector(v1569.x - v1572, v1569.y + 1), v1573, v1574, v1573, v1574);
                    render.gradient(vector(v1569.x + v1571, v1569.y), vector(v1569.x + v1572, v1569.y + 1), v1573, v1574, v1573, v1574);
                    if v1575 then
                        render.pop_rotation();
                    end;
                    return;
                end;
            end;
        end;
    end
};
v64[#v64 + 1] = setmetatable(v1576, {
    __call = v1576.on_render
});
local v1626 = {
    mp_ff = cvar.mp_friendlyfire, 
    smoke_data = {}, 
    molotov_data = {}, 
    erase = function(_, v1578)
        for v1579 in pairs(v1578) do
            v1578[v1579] = nil;
        end;
    end, 
    is_friendly = function(v1580, v1581)
        if v1580.mp_ff:int() == 1 then
            return false;
        else
            local v1582 = entity.get_local_player();
            local l_m_hOwnerEntity_0 = v1581.m_hOwnerEntity;
            if l_m_hOwnerEntity_0 == nil or not l_m_hOwnerEntity_0:is_player() then
                return false;
            else
                return l_m_hOwnerEntity_0 ~= v1582 and not l_m_hOwnerEntity_0:is_enemy();
            end;
        end;
    end, 
    update_smoke = function(v1584)
        -- upvalues: l_config_sub_0 (ref)
        local l_visual_radius_0 = l_config_sub_0.visual_radius;
        if not l_config_sub_0.visual.grenade:get() or not l_visual_radius_0.smoke:get() then
            return v1584:erase(v1584.smoke_data);
        else
            local v1586 = entity.get_entities("CSmokeGrenadeProjectile");
            local v1587 = {};
            for v1588 = 1, #v1586 do
                local v1589 = v1586[v1588];
                if v1589.m_bDidSmokeEffect then
                    local v1590 = v1589:get_index();
                    v1587[v1590] = true;
                    if not v1584.smoke_data[v1590] then
                        v1584.smoke_data[v1590] = {
                            alpha = 0, 
                            radius = 125, 
                            origin = v1589:get_origin()
                        };
                    end;
                end;
            end;
            for v1591 in pairs(v1584.smoke_data) do
                if not v1587[v1591] then
                    v1584.smoke_data[v1591] = nil;
                end;
            end;
            return;
        end;
    end, 
    update_molotov = function(v1592)
        -- upvalues: l_config_sub_0 (ref)
        local l_visual_radius_1 = l_config_sub_0.visual_radius;
        if not l_config_sub_0.visual.grenade:get() or not l_visual_radius_1.molotov:get() then
            return v1592:erase(v1592.molotov_data);
        else
            local v1594 = entity.get_entities("CInferno");
            local v1595 = {};
            for v1596 = 1, #v1594 do
                local v1597 = v1594[v1596];
                local l_m_fireCount_0 = v1597.m_fireCount;
                if l_m_fireCount_0 ~= 0 then
                    local v1599 = v1597:get_index();
                    v1595[v1599] = true;
                    local v1600 = v1592.molotov_data[v1599];
                    if not v1600 then
                        v1600 = {
                            fire_cnt = 0, 
                            alpha = 0, 
                            radius = 0, 
                            origin = v1597:get_origin(), 
                            friendly = v1592:is_friendly(v1597)
                        };
                        v1592.molotov_data[v1599] = v1600;
                    end;
                    if v1600.fire_cnt < l_m_fireCount_0 then
                        v1600.fire_cnt = l_m_fireCount_0;
                        local v1601 = {};
                        local v1602 = 0;
                        for v1603 = 0, l_m_fireCount_0 - 1 do
                            if v1597.m_bFireIsBurning[v1603] then
                                v1602 = v1602 + 1;
                                v1601[v1602] = vector(v1597.m_fireXDelta[v1603], v1597.m_fireYDelta[v1603], v1597.m_fireZDelta[v1603]);
                            end;
                        end;
                        local v1604 = 0;
                        local v1605 = nil;
                        local v1606 = nil;
                        for v1607 = 1, v1602 do
                            for v1608 = 1, v1602 do
                                local v1609 = (v1601[v1608] - v1601[v1607]):lengthsqr();
                                if v1604 < v1609 then
                                    local l_v1609_0 = v1609;
                                    local v1611 = v1601[v1607];
                                    v1606 = v1601[v1608];
                                    v1605 = v1611;
                                    v1604 = l_v1609_0;
                                end;
                            end;
                        end;
                        if v1605 and v1606 then
                            v1600.origin = v1597:get_origin() + (v1605 + v1606) / 2;
                            v1600.radius = math.sqrt(v1604) / 2 + 40;
                        end;
                    end;
                end;
            end;
            for v1612 in pairs(v1592.molotov_data) do
                if not v1595[v1612] then
                    v1592.molotov_data[v1612] = nil;
                end;
            end;
            return;
        end;
    end, 
    on_render = function(v1613)
        -- upvalues: l_config_sub_0 (ref)
        local l_visual_radius_2 = l_config_sub_0.visual_radius;
        if not l_config_sub_0.visual.grenade:get() then
            return;
        else
            local l_frametime_3 = globals.frametime;
            local v1616 = l_visual_radius_2.smoke.color:get();
            local v1617 = l_visual_radius_2.molotov.color:get();
            for _, v1619 in pairs(v1613.smoke_data) do
                v1619.alpha = math.min(v1619.alpha + l_frametime_3 * 4, 1);
                render.circle_3d_outline(v1619.origin, color(v1616.r, v1616.g, v1616.b, v1616.a), v1619.radius * v1619.alpha, 0, 1, 1);
            end;
            for _, v1621 in pairs(v1613.molotov_data) do
                v1621.alpha = math.min(v1621.alpha + l_frametime_3 * 4, 1);
                local v1622 = v1621.friendly and color(149, 184, 6, 255) or color(v1617.r, v1617.g, v1617.b, v1617.a);
                render.circle_3d_outline(v1621.origin, v1622, v1621.radius * v1621.alpha, 0, 1, 1);
                local v1623 = render.world_to_screen(v1621.origin);
                if v1623 then
                    local v1624 = v1621.friendly and "\226\156\148" or "\226\157\140";
                    local v1625 = v1621.friendly and color(149, 184, 6, 255) or color(230, 21, 21, 255);
                    render.text(1, v1623, v1625, "c", v1624);
                end;
            end;
            return;
        end;
    end
};
local function v1627()
    -- upvalues: v1626 (ref)
    v1626:update_smoke();
    v1626:update_molotov();
end;
events.net_update_start(v1627, true);
v64[#v64 + 1] = setmetatable(v1626, {
    __call = function()
        -- upvalues: v1626 (ref)
        v1626:on_render();
    end
});
local _ = {
    prepare = function(_)

    end
};
local v1630 = {
    send_bool = false, 
    cycle_var = 0
};
do
    local l_v1630_0 = v1630;
    local function v1643()
        -- upvalues: l_link_0 (ref), v15 (ref), l_v1630_0 (ref)
        if not l_link_0.general.master:get() or not l_link_0.fakelag_enable.enable:get() then
            return nil;
        else
            local v1632 = v15.rage.dt:get() or v15.rage.dt:get_override();
            local v1633 = v15.rage.hs:get() or v15.rage.hs:get_override();
            local v1634 = v15.rage.fd:get();
            if l_link_0.fakelag.disable:get() and (v1632 or v1633) and not v1634 then
                return 1;
            else
                local v1635 = l_link_0.fakelag.mode:get();
                local v1636 = 1;
                if v1635 == "Neverlose" then
                    v1636 = l_link_0.fakelag.limit:get();
                elseif v1635 == "Fluctuate" then
                    local v1637 = l_link_0.fakelag.limit:get();
                    v1636 = globals.tickcount % 17 == 0 and 1 or v1637;
                elseif v1635 == "Trashhode" then
                    v1636 = 14;
                elseif v1635 == "Cycle" then
                    local v1638 = l_link_0.fakelag.min:get();
                    local v1639 = l_link_0.fakelag.max:get();
                    local v1640 = math.max(1, l_link_0.fakelag.step:get());
                    l_v1630_0.cycle_var = l_v1630_0.cycle_var + 1;
                    if v1640 < l_v1630_0.cycle_var then
                        l_v1630_0.cycle_var = 0;
                    end;
                    v1636 = v1638 + l_v1630_0.cycle_var;
                    if v1639 < v1636 then
                        l_v1630_0.cycle_var = 0;
                        v1636 = v1638;
                    end;
                elseif v1635 == "Random" then
                    local v1641 = l_link_0.fakelag.min:get();
                    local v1642 = l_link_0.fakelag.max:get();
                    v1636 = utils.random_int(v1641, v1642);
                end;
                return math.clamp(v1636, 1, 17);
            end;
        end;
    end;
    local function v1646(v1644)
        -- upvalues: v1643 (ref), v15 (ref), l_link_0 (ref)
        local v1645 = v1643();
        if not v1645 then
            v15.aa.fl_limit:override();
            return;
        else
            v15.aa.fl_limit:override(v1645);
            if l_link_0.fakelag.force:get() and v1644.choked_commands < v1645 then
                v1644.send_packet = false;
            end;
            return;
        end;
    end;
    events.createmove:set(v1646);
end;
v65.flag.fd_reset = false;
v65.flag.fd_reset_expire = 0;
v65.flag.isfl_off = false;
v65.flag.isfl_expire = 0;
v65.flag.nade_zero = false;
v1630 = {
    expire = 0, 
    id = 0, 
    active = false
};
local function v1649(v1647)
    local l_m_fThrowTime_0 = v1647.m_fThrowTime;
    return (not not v1647.hegrenade or v1647.smokegrenade or v1647.molotov or v1647.incgrenade) and l_m_fThrowTime_0 > 0 and l_m_fThrowTime_0 < globals.curtime;
end;
do
    local l_v1630_1, l_v1649_0 = v1630, v1649;
    events.createmove:set(function(v1652)
        -- upvalues: v65 (ref), l_link_0 (ref), l_v1649_0 (ref), v15 (ref), l_v1630_1 (ref)
        local v1653 = entity.get_local_player();
        if not v1653 then
            return;
        else
            local v1654 = v1653:get_player_weapon();
            if not v1654 then
                return;
            else
                v65.flag.nade_zero = l_link_0.fakelag.nade:get() and l_v1649_0(v1654) or false;
                if v65.flag.nade_zero then
                    v15.rage.dt_lag_limit:override(0);
                    v15.aa.fl_limit:override(0);
                    local v1655 = v1652.command_number % 8 == 0;
                    v1652.no_choke = v1655;
                    v1652.force_defensive = v1655;
                else
                    v15.rage.dt_lag_limit:override();
                end;
                local v1656 = v1654.m_fLastShotTime or 0;
                if v1656 ~= l_v1630_1.id then
                    l_v1630_1.id = v1656;
                    l_v1630_1.active = true;
                    l_v1630_1.expire = globals.curtime + 0.061956;
                end;
                if l_v1630_1.active and globals.curtime > l_v1630_1.expire then
                    l_v1630_1.active = false;
                end;
                if not l_link_0.fakelag_enable.onshot:get() or not l_v1630_1.active or v15.rage.fd:get() then
                    return;
                else
                    local l_shot_optimzed_0 = l_link_0.fakelag_shot.shot_optimzed;
                    local v1658 = v1652.command_number % 8 == 0;
                    local v1659 = l_link_0.fakelag_shot.shot_peek:get();
                    local v1660 = l_link_0.fakelag_shot.shot_peek_choke:get();
                    local v1661 = v15.rage.peek:get();
                    if l_shot_optimzed_0:get("Reset Desync") and (not v1659 or v1661) then
                        v15.aa.body_yaw:override(false);
                        v65.flag.fd_reset = true;
                        v65.flag.fd_reset_expire = globals.curtime + 0.12;
                    end;
                    if l_shot_optimzed_0:get("Reset FL") then
                        v15.aa.fl_limit:override(0);
                        v65.flag.isfl_off = true;
                        v65.flag.isfl_expire = globals.curtime + 0.12;
                    end;
                    if l_shot_optimzed_0:get("Choke") and (not v1660 or v1661) then
                        v1652.no_choke = true;
                    end;
                    if l_shot_optimzed_0:get("Send_Packet") then
                        v1652.send_packet = v1658;
                    end;
                    v1652.force_defensive = v1658;
                    return;
                end;
            end;
        end;
    end);
    events.net_update_end:set(function()
        -- upvalues: v65 (ref), v15 (ref)
        local l_curtime_3 = globals.curtime;
        if v65.flag.fd_reset and v65.flag.fd_reset_expire <= l_curtime_3 then
            v65.flag.fd_reset = false;
            v15.aa.body_yaw:override();
        end;
        if v65.flag.isfl_off and v65.flag.isfl_expire <= l_curtime_3 then
            v65.flag.isfl_off = false;
            v15.aa.fl_limit:override();
        end;
    end);
    local l_main_1 = v906.main;
    v906.main = function(v1664, v1665)
        -- upvalues: l_main_1 (ref), v65 (ref), v15 (ref)
        l_main_1(v1664, v1665);
        if v65.flag.fd_reset then
            v15.aa.body_yaw:override(false);
        end;
    end;
    if not _G.__Trashhode_orig_calc_limit then
        _G.__Trashhode_orig_calc_limit = calc_limit;
        calc_limit = function(...)
            -- upvalues: v65 (ref)
            if v65.flag.isfl_off or v65.flag.nade_zero then
                return 0;
            else
                return _G.__Trashhode_orig_calc_limit(...);
            end;
        end;
    end;
end;
v1630 = {
    main = function(_)
        -- upvalues: l_config_sub_0 (ref)
        local v1667 = entity.get_local_player();
        if v1667 == nil or not v1667:is_alive() then
            return;
        elseif v1667:get_player_weapon() == nil then
            return;
        elseif not l_config_sub_0.rage.predict:get() then
            return;
        else
            local v1668 = utils.net_channel();
            cvar.cl_interp:float(v1668.latency[0] * 1000 < 45 and 0.015875 or 0.02, true);
            cvar.cl_interpolate:int(v1668.latency[0] * 1000 < 45 and 1 or 0, true);
            cvar.cl_interp_ratio:int(v1668.latency[0] * 1000 < 45 and 2 or 0, true);
            return;
        end;
    end, 
    on_pre_render = function(v1669)
        v1669:main();
    end
};
v64[#v64 + 1] = setmetatable(v1630, {
    __call = v1630.on_pre_render
});
v1649 = v1310.new("Slow-Warning", {
    clamped = true
}):set_anchor(vector(0.5, 0)):set_pos(vector(render.screen_size().x / 2, render.screen_size().y * 0.35)):build();
local v1670 = 4;
local _ = 3;
local _ = 2;
local v1704 = {
    bar = function(_, v1674, v1675, v1676, v1677, v1678, v1679)
        -- upvalues: v1649 (ref), v14 (ref), v71 (ref), v1670 (ref)
        local v1680 = 95;
        local v1681 = v1649:get_pos();
        local l_x_10 = v1681.x;
        local l_y_6 = v1681.y;
        local v1684 = 35;
        local v1685 = 35;
        local v1686 = render.screen_size();
        local l_is_dragged_2 = v1649.is_dragged;
        if common.is_button_down(2) and v1649.is_hovered then
            v1649:set_pos(vector(v1686.x * 0.5 - (v1684 + 8 + v1680) * 0.5, l_y_6));
        end;
        if v14 then
            render.rect(vector(l_x_10 - 3, l_y_6 - 4), vector(v1684 + 3, v1685 + 3), color(16, 16, 16, math.floor(255 * v1678)), 4);
            local v1688 = math.abs(globals.curtime * 0.5 % 2 - 1) * 255 * v1678;
            render.texture(v14, vector(l_x_10 - 1, l_y_6 - 1), vector(v1684 + 2, v1685 + 2), color(0, 0, 0, v1688), "f");
            render.texture(v14, vector(l_x_10, l_y_6), nil, color(v1675, v1676, v1677, v1688), "f");
        end;
        render.text(4, vector(l_x_10 + v1684 + 8, l_y_6 + 3), color(255, 255, 255, math.floor(255 * v1678)), nil, string.format("Slowed down %d%%", v1674 * 100));
        local v1689 = l_x_10 + v1684 + 8;
        local v1690 = l_y_6 + 20;
        local l_v1680_0 = v1680;
        local v1692 = 12;
        v71.rectangle_outline_render(v1689, v1690, l_v1680_0, v1692, 0, 0, 0, math.floor(255 * v1678), 1);
        render.rect(vector(v1689 + 1, v1690 + 1), vector(v1689 + l_v1680_0 - 1, v1690 + v1692 - 1), color(16, 16, 16, math.floor(255 * v1678)));
        local v1693 = math.floor((l_v1680_0 - 2) * v1674);
        render.rect(vector(v1689 + 1, v1690 + 1), vector(v1689 + 1 + v1693, v1690 + v1692 - 1), color(v1675, v1676, v1677, math.floor(255 * v1678)));
        if v1679 then
            local v1694 = v1684 + 8 + v1680;
            render.rect_outline(vector(l_x_10 - 4, l_y_6 - 6), vector(l_x_10 - 4 + v1694 + 8, l_y_6 - 6 + v1685 + 6), color(200, 200, 200, 255), 1, 4);
        end;
        local v1695;
        if v1679 then
            v1695 = l_is_dragged_2 and 0 or 1;
        else
            v1695 = 0;
        end;
        if v1695 > 0.05 then
            render.text(v1670, vector(l_x_10, l_y_6 + v1685 + 6), color(255, 255, 255, 255 * v1695), nil, "Press M2 to center.");
        end;
        v1649:set_size(vector(v1684 + 8 + v1680, v1685));
    end, 
    main = function(v1696)
        -- upvalues: l_config_sub_0 (ref), v71 (ref)
        local v1697 = entity.get_local_player();
        if not v1697 or not v1697:is_alive() then
            return;
        elseif not l_config_sub_0.visual.slowdown:get() then
            return;
        elseif l_config_sub_0.visual_slow.style:get() ~= "Bar" then
            return;
        else
            local l_m_flVelocityModifier_0 = v1697.m_flVelocityModifier;
            local v1699 = ui.get_alpha() > 0;
            local v1700, v1701, v1702 = v71.rgb_health_based(l_m_flVelocityModifier_0);
            local v1703 = v71.remap(l_m_flVelocityModifier_0, 1, 0, 0.85, 1);
            if v1699 then
                v1703 = math.max(v1703, 0.8);
            elseif v1703 < 0.01 then
                return;
            end;
            v1696:bar(l_m_flVelocityModifier_0, v1700, v1701, v1702, v1703, v1699);
            return;
        end;
    end
};
local v1705 = {};
local v1706 = 215;
local v1707 = 50;
local v1708 = 184;
local _ = 4;
local _ = 4;
local v1711 = render.screen_size();
local v1712 = v1310.new("velocity_indicator", {
    clamped = true
}):set_anchor(vector(0.5, 0)):set_pos(vector(v1711.x * 0.5 - v1706 * 0.5, v1711.y / 3.5)):build();
local v1713 = color(144, 203, 251);
local v1714 = color(255, 75, 75);
v1705.on_render = function(v1715)
    -- upvalues: l_config_sub_0 (ref), v1712 (ref), v1711 (ref), v1706 (ref), v1708 (ref), v1707 (ref), v1714 (ref), v1713 (ref)
    local v1716 = entity.get_local_player();
    if not v1716 or not v1716:is_alive() then
        return;
    elseif not l_config_sub_0.visual.slowdown:get() then
        return;
    elseif l_config_sub_0.visual_slow.style:get() ~= "Line" then
        return;
    else
        local v1717 = v1716.m_flVelocityModifier or 1;
        local v1718 = ui.get_alpha() > 0;
        local l_is_dragged_3 = v1712.is_dragged;
        local v1720 = v1718 or v1717 < 0.99;
        v1715.alpha = math.lerp(v1715.alpha or 0, v1720 and 1 or 0, 0.08);
        v1715.warn_l = math.lerp(v1715.warn_l or 0, v1717 < 0.99 and 1 or 0, 0.06);
        if v1715.alpha < 0.02 then
            return;
        else
            if common.is_button_down(2) and v1712.is_hovered then
                v1711 = render.screen_size();
                local l_y_7 = v1712:get_pos().y;
                v1712:set_pos(vector(v1711.x * 0.5 - v1706 * 0.5, l_y_7));
            end;
            local v1722 = v1712:get_pos();
            local v1723 = v1722 + vector(15, 30);
            local v1724 = v1723 + vector(v1708 + 1, 8);
            local v1725;
            if v1718 then
                v1725 = l_is_dragged_3 and 0.5 or 1;
            else
                v1725 = 0;
            end;
            if v1725 > 0.02 then
                render.rect_outline(v1722, v1722 + vector(v1706, v1707), color(200, 200, 200, 160 * v1725), 1, 4);
            end;
            local v1726 = v1714:lerp(v1713, v1717);
            render.shadow(v1723, v1724, v1726:alpha_modulate(255 * v1715.alpha), 100, 0, 13);
            render.rect(v1723, v1724, color(0, 0, 0, 180 * v1715.alpha), 3);
            render.rect(v1723 + vector(2, 2), v1723 + vector(-1, 3) + vector(v1708 * v1717, 3), v1726:alpha_modulate(255 * v1715.alpha), 3);
            local v1727 = ("\226\155\148\239\184\143 Max velocity reduced by %d %%"):format((math.floor(v1717 * 100 + 0.5)));
            render.text(1, v1723 + vector(v1708 / 2, -10), color(255, 255, 255, 255 * v1715.alpha), "c", v1727);
            local v1728;
            if v1718 then
                v1728 = l_is_dragged_3 and 0 or 1;
            else
                v1728 = 0;
            end;
            if v1728 > 0.05 then
                render.text(1, v1722 + vector(15, 40), color(255, 255, 255, 255 * v1728), "d", "Press M2 to center.");
            end;
            v1712:set_size(vector(v1706, v1707));
            return;
        end;
    end;
end;
v64[#v64 + 1] = v1705;
v1704.on_render = function(v1729)
    v1729:main();
end;
v64[#v64 + 1] = setmetatable(v1704, {
    __call = v1704.on_render
});
local _ = nil;
local _ = nil;
esp.enemy:new_text("Distance", "1 ft", function(v1732)
    -- upvalues: v71 (ref)
    local v1733 = entity.get_local_player();
    if v1733 == nil then
        return nil;
    else
        local v1734 = v1733:get_origin();
        local v1735 = v1732:get_origin() - v1734;
        local v1736 = v71.to_foot(v1735:length());
        return string.format("%i ft", v1736);
    end;
end);
(function()
    -- upvalues: v486 (ref), l_config_sub_0 (ref)
    if not v486 or not v486.createNotification then
        return;
    else
        local v1737 = l_config_sub_0.visual_logger_color.color_1:get("Notify")[1];
        local v1738 = " \aABABAB42|  \aDEFAULT Welcome Back , \a8BA5FFFF" .. common.get_username() .. "\aDEFAULT  Last Update: \a8BA5FFFF25/07/15\aDEFAULT  Your Build: \a8BA5FFFFRecode  ";
        v486:createNotification(v1737, v1738);
        return;
    end;
end)();
local v1763 = {
    damp = 0.3, 
    resolve_grenade_throw = function(v1739, v1740, v1741, v1742, v1743)
        v1740.x = v1740.x - 10 + math.abs(v1740.x) / 9;
        local v1744 = vector():angles(v1740);
        local v1745 = v1743 * 1.25;
        local v1746 = math.clamp(v1741 * 0.9, 15, 750);
        local v1747 = math.clamp(v1742, 0, 1);
        v1746 = v1746 * math.lerp(v1739.damp, 1, v1747);
        local l_v1744_0 = v1744;
        for _ = 1, 8 do
            l_v1744_0 = (v1744 * (l_v1744_0 * v1746 + v1745):length() - v1745) / v1746;
            l_v1744_0:normalize();
        end;
        local v1750 = l_v1744_0.angles(l_v1744_0);
        if v1750.x > -10 then
            v1750.x = 0.9 * v1750.x + 9;
        else
            v1750.x = 1.125 * v1750.x + 11.25;
        end;
        return v1750;
    end, 
    on_grenade_override_view = function(v1751, v1752)
        -- upvalues: l_config_sub_0 (ref)
        local v1753 = entity.get_local_player();
        if v1753 == nil or not v1753:is_alive() then
            return;
        elseif not l_config_sub_0.misc.supertoss:get() then
            return;
        else
            local v1754 = v1753:get_player_weapon();
            if v1754 == nil then
                return;
            else
                local v1755 = v1754:get_weapon_info();
                if v1755 == nil then
                    return;
                elseif v1755.weapon_type ~= 9 then
                    return;
                else
                    v1752.angles = v1751:resolve_grenade_throw(v1752.angles, v1755.throw_velocity, v1754.m_flThrowStrength, v1752.velocity);
                    return;
                end;
            end;
        end;
    end, 
    handle_supertoss = function(v1756, v1757)
        -- upvalues: l_config_sub_0 (ref)
        if v1757.jitter_move ~= true then
            return;
        elseif not l_config_sub_0.misc.supertoss:get() then
            return;
        else
            local v1758 = entity.get_local_player();
            if v1758 == nil then
                return;
            elseif v1758:get_player_weapon() == nil then
                return;
            else
                local v1759 = v1758:get_player_weapon();
                local v1760 = v1759:get_weapon_info();
                local _ = v1759:get_name();
                if v1760 == nil or v1760.weapon_type ~= 9 then
                    return;
                elseif v1759.m_fThrowTime < globals.curtime - to_time(globals.clock_offset) then
                    return;
                else
                    v1757.in_speed = true;
                    local v1762 = v1758:simulate_movement();
                    v1762:think();
                    v1757.view_angles = v1756:resolve_grenade_throw(v1757.view_angles, v1760.throw_velocity, v1759.m_flThrowStrength, v1762.velocity);
                    return;
                end;
            end;
        end;
    end
};
events.createmove:set(function(v1764)
    -- upvalues: v1763 (ref)
    v1763:handle_supertoss(v1764);
end);
events.grenade_override_view:set(function(v1765)
    -- upvalues: v1763 (ref)
    v1763:on_grenade_override_view(v1765);
end);
({
    init = function()
        -- upvalues: v64 (ref)
        for _, v1767 in ipairs(v64) do
            do
                local l_v1767_0 = v1767;
                for v1769, v1770 in pairs(l_v1767_0) do
                    local v1771 = v1769:match("^on_(.+)");
                    do
                        local l_v1770_0 = v1770;
                        if v1771 and events[v1771] and events[v1771].set then
                            events[v1771]:set(function(...)
                                -- upvalues: l_v1770_0 (ref), l_v1767_0 (ref)
                                l_v1770_0(l_v1767_0, ...);
                            end);
                        end;
                    end;
                end;
            end;
        end;
    end
}).init();