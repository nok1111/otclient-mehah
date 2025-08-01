local HOTKEY = 'Ctrl+Y'
local MAP_SHADERS = { {
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
},

{name = 'Desert', frag = 'shaders/fragment/desert.frag', tex1 = 'images/clouds' },
{name = 'Desert3', frag = 'shaders/fragment/desert.frag', tex1 = 'images/sandstorm' },
{name = 'Desert4', frag = 'shaders/fragment/desert.frag', tex1 = 'images/desert2' },

{
    name = 'Map - Heatwave',
    frag = 'shaders/fragment/heat2.frag',
    drawViewportEdge = true
},
{
    name = 'Map - confusion',
    frag = 'shaders/fragment/confusion.frag',
    drawViewportEdge = true
},
{
    name = 'Map - blind',
    frag = 'shaders/fragment/blind.frag',
    drawViewportEdge = true
},
{
    name = 'Map - fear',
    frag = 'shaders/fragment/fear.frag',
    drawViewportEdge = true
},
 }

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
    name = 'Outfit - ice',
    useFramebuffer = true,
    frag = 'shaders/fragment/outline - colorfull.frag'
},

 {      name = 'Aura',
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
    {name = 'Galaxy',  frag = 'shaders/fragment/galaxy.frag', drawColor = false},
    {name = 'Ghost', frag = 'shaders/fragment/ghost.frag'},
    {name = 'Metallic', frag = 'shaders/fragment/metallic.frag', drawColor = false},
    {name = 'Golden', frag = 'shaders/fragment/outline_golden.frag', drawColor = false},
    {name = 'frost armor', frag = 'shaders/fragment/frost_armor.frag', drawColor = false},
    {name = 'Red Glow', frag = 'shaders/fragment/red_glow.frag'},
    {name = 'Soul',  frag = 'shaders/fragment/soul.frag'},
    
    {name = 'Fragmented', frag = 'shaders/fragment/fragmented.frag'},
    {name = 'Test', useFramebuffer = true, frag = 'shaders/fragment/outline.frag', drawColor = false},
    
    
    
    {name = 'chess',  frag = 'shaders/fragment/chess.frag', drawColor = false},
    {name = 'ripple',  frag = 'shaders/fragment/ripple.frag', drawColor = false},
    {name = 'magnetic',  frag = 'shaders/fragment/magnetic.frag', drawColor = true},
    
    --monster shaders
    {name = 'Monster Might', frag = 'shaders/fragment/monster_might.frag'},
    {name = 'Blackout', frag = 'shaders/fragment/blackout.frag'},
    {name = 'Stealth', frag = 'shaders/fragment/stealth.frag'},

    


 }

MOUNT_SHADERS = { {
    name = 'Mount - Default',
    frag = nil
}, {
    name = 'Mount - Rainbow',
    frag = 'shaders/fragment/party.frag'
} }

local function attachShaders()
    local map = modules.game_interface.getMapPanel()
    map:setShader('Default')

    local player = g_game.getLocalPlayer()
    player:setShader('Default')
    player:setMountShader('Default')
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

ShaderController = Controller:new()

function ShaderController:onInit()
    for _, opts in pairs(MAP_SHADERS) do
        registerShader(opts, 'setupMapShader')
    end

    for _, opts in pairs(OUTFIT_SHADERS) do
        registerShader(opts, 'setupOutfitShader')
    end

    for _, opts in pairs(MOUNT_SHADERS) do
        registerShader(opts, 'setupMountShader')
    end
    Keybind.new('Windows', 'show/hide Shader Windows', HOTKEY, '')
    Keybind.bind('Windows', 'show/hide Shader Windows', {
        {
          type = KEY_DOWN,
          callback = function() ShaderController.ui:setVisible(not ShaderController.ui:isVisible()) end,
         }
    })
end

function ShaderController:onTerminate()
    g_shaders.clear()
    Keybind.delete('Windows', 'show/hide Shader Windows')
end

function ShaderController:onGameStart()
    attachShaders()

    self:loadHtml('shaders.html', modules.game_interface.getMapPanel())

    for _, opts in pairs(MAP_SHADERS) do
        self.ui.mapComboBox:addOption(opts.name, opts)
    end

    for _, opts in pairs(OUTFIT_SHADERS) do
        self.ui.outfitComboBox:addOption(opts.name, opts)
    end

    for _, opts in pairs(MOUNT_SHADERS) do
        self.ui.mountComboBox:addOption(opts.name, opts)
    end
end

function ShaderController:onMapComboBoxChange(event)
    local map = modules.game_interface.getMapPanel()
    map:setShader(event.text)

    local data = event.target:getCurrentOption().data
    map:setDrawViewportEdge(data.drawViewportEdge == true)
end

function ShaderController:onOutfitComboBoxChange(event)
    local player = g_game.getLocalPlayer()
    if player then
        player:setShader(event.text)
        local data = event.target:getCurrentOption().data
        player:setDrawOutfitColor(data.drawColor ~= false)
    end
end

function ShaderController:onMountComboBoxChange(event)
    local player = g_game.getLocalPlayer()
    if player then
        player:setMountShader(event.text)
    end
end
