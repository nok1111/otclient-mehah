HOTKEY = 'Ctrl+Y'
MAP_SHADERS = { {
    name = 'Map - Default',
    frag = nil
}, {
    name = 'Map - Fog',
    frag = 'shaders/fragment/fog.frag',
    tex1 = 'images/clouds'
}, {
    name = 'Map - Rain',
    frag = 'shaders/fragment/rain.frag'
}, {
    name = 'Map - Snow',
    frag = 'shaders/fragment/snow.frag',
    tex1 = 'images/snow'
}, {
    name = 'Map - Gray Scale',
    frag = 'shaders/fragment/grayscale.frag'
}, {
    name = 'Map - Bloom',
    frag = 'shaders/fragment/bloom.frag'
}, {
    name = 'Map - Sepia',
    frag = 'shaders/fragment/sepia.frag'
}, {
    name = 'Map - Pulse',
    frag = 'shaders/fragment/pulse.frag',
    drawViewportEdge = true
}, {
    name = 'Map - Old Tv',
    frag = 'shaders/fragment/oldtv.frag'
}, {
    name = 'Map - Party',
    frag = 'shaders/fragment/party.frag'
}, {
    name = 'Map - Radial Blur',
    frag = 'shaders/fragment/radialblur.frag',
    drawViewportEdge = true
}, {
    name = 'Map - Zomg',
    frag = 'shaders/fragment/zomg.frag',
    drawViewportEdge = true
}, {
    name = 'Map - Heat',
    frag = 'shaders/fragment/heat.frag',
    drawViewportEdge = true
}, {
    name = 'Map - Noise',
    frag = 'shaders/fragment/noise.frag'
} }

OUTFIT_SHADERS = { {
    name = 'Outfit - Default',
    frag = nil
}, {
    name = 'Outfit - Rainbow', 
    frag = 'shaders/fragment/party.frag'
}, {
    name = 'Outfit - Ghost',
    frag = 'shaders/fragment/radialblur.frag',
    drawColor = false
}, {
    name = 'Outfit - Jelly',
    frag = 'shaders/fragment/heat.frag'
}, {
    name = 'Outfit - Fragmented',
    frag = 'shaders/fragment/noise.frag'
}, {
    name = 'Outfit - Outline',
    useFramebuffer = true,
    frag = 'shaders/fragment/outline.frag'
},
 {
        name = 'Aura',
        frag = 'shaders/fragment/radialblur.frag',
        drawColor = false
    }, 

	{name = 'Jelly', frag = 'shaders/fragment/heat.frag'},
    {name = 'Distorted', frag = 'shaders/fragment/noise.frag'},
	{name = 'Rainbow', useFramebuffer = true, frag = 'shaders/fragment/party.frag'},
	{name = 'Bloom', useFramebuffer = true, frag = 'shaders/fragment/bloom.frag'},
	{name = 'Radial Blur', useFramebuffer = true, frag = 'shaders/fragment/radialblur.frag'},
	{name = 'Old Tv', useFramebuffer = true, frag = 'shaders/fragment/oldtv.frag'},
	{name = 'Zomg', useFramebuffer = true, frag = 'shaders/fragment/zomg.frag'},
	{name = 'Rainbowgpt', frag = 'shaders/fragment/rainbowgpt.frag' , drawColor = false},
	{name = 'Lava', frag = 'shaders/fragment/flames.frag', drawColor = true},
	{name = 'Galaxy',  frag = 'shaders/fragment/galaxy.frag'},
	{name = 'Ghost', frag = 'shaders/fragment/ghost.frag'},
	{name = 'Metallic', frag = 'shaders/fragment/metallic.frag', drawColor = false},
	{name = 'Golden', frag = 'shaders/fragment/outline_golden.frag', drawColor = false},
	{name = 'Red Glow', frag = 'shaders/fragment/red_glow.frag'},
	{name = 'Soul',  frag = 'shaders/fragment/soul.frag'},
	{name = 'Fragmented', frag = 'shaders/fragment/fragmented.frag'},
	{name = 'Test', useFramebuffer = true, frag = 'shaders/fragment/outline.frag'},






 }

MOUNT_SHADERS = { {
    name = 'Mount - Default',
    frag = nil
}, {
    name = 'Mount - Rainbow',
    frag = 'shaders/fragment/party.frag'
} }

-- Fix for texture offset drawing, adding walking offsets.
local dirs = {
    [0] = {
        x = 0,
        y = 1
    },
    [1] = {
        x = 1,
        y = 0
    },
    [2] = {
        x = 0,
        y = -1
    },
    [3] = {
        x = -1,
        y = 0
    },
    [4] = {
        x = 1,
        y = 1
    },
    [5] = {
        x = 1,
        y = -1
    },
    [6] = {
        x = -1,
        y = -1
    },
    [7] = {
        x = -1,
        y = 1
    }
}

shadersPanel = nil

function onWalkEvent()
    local player = g_game.getLocalPlayer()
    local dir = g_game.getLastWalkDir()
    local w = player:getWalkedDistance()
    w.x = w.x + dirs[dir].x
    w.y = w.y + dirs[dir].y
    player:setWalkedDistance(w);
end

function attachShaders()
    local map = modules.game_interface.getMapPanel()
    map:setShader('Default')

    local player = g_game.getLocalPlayer()
    player:setShader('Default')
    player:setMountShader('Default')
end

function init()
    connect(g_game, {
        onGameStart = attachShaders
    })

    g_ui.importStyle('shaders.otui')

    g_keyboard.bindKeyDown(HOTKEY, toggle)

    shadersPanel = g_ui.createWidget('ShadersPanel', modules.game_interface.getMapPanel())
    shadersPanel:hide()

    local mapComboBox = shadersPanel:getChildById('mapComboBox')
    mapComboBox.onOptionChange = function(combobox, option)
        local map = modules.game_interface.getMapPanel()
        map:setShader(option)

        local data = combobox:getCurrentOption().data
        map:setDrawViewportEdge(data.drawViewportEdge == true)
    end

    local outfitComboBox = shadersPanel:getChildById('outfitComboBox')
    outfitComboBox.onOptionChange = function(combobox, option)
        local player = g_game.getLocalPlayer()
        if player then
            player:setShader(option)
            local data = combobox:getCurrentOption().data
            player:setDrawOutfitColor(data.drawColor ~= false)
        end
    end

    local mountComboBox = shadersPanel:getChildById('mountComboBox')
    mountComboBox.onOptionChange = function(combobox, option)
        local player = g_game.getLocalPlayer()
        if player then
            player:setMountShader(option)
        end
    end

    local registerShader = function(opts, method)
        local fragmentShaderPath = resolvepath(opts.frag)

        if fragmentShaderPath ~= nil then
            --  local shader = g_shaders.createShader()
            g_shaders.createFragmentShader(opts.name, opts.frag, opts.useFramebuffer or false)

            if opts.tex1 then
                g_shaders.addMultiTexture(opts.name, opts.tex1)
            end
            if opts.tex2 then
                g_shaders.addMultiTexture(opts.name, opts.tex2)
            end

            -- Setup proper uniforms
            g_shaders[method](opts.name)
        end
    end

    for _, opts in pairs(MAP_SHADERS) do
        registerShader(opts, 'setupMapShader')
        mapComboBox:addOption(opts.name, opts)
    end

    for _, opts in pairs(OUTFIT_SHADERS) do
        registerShader(opts, 'setupOutfitShader')
        outfitComboBox:addOption(opts.name, opts)
    end

    for _, opts in pairs(MOUNT_SHADERS) do
        registerShader(opts, 'setupMountShader')
        mountComboBox:addOption(opts.name, opts)
    end
end

function terminate()
    disconnect(g_game, {
        onGameStart = attachShaders
    })

    g_keyboard.unbindKeyDown(HOTKEY)
    shadersPanel:destroy()
    shadersPanel = nil
end

function toggle()
    shadersPanel:setVisible(not shadersPanel:isVisible())
end
