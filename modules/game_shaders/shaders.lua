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
    name = 'Map - Sample Texture',
    frag = 'shaders/fragment/sample_texture.frag',
    tex1 = 'images/shaders/stars'
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
{
    name = 'Map - Enhance',
    frag = 'shaders/fragment/enhance.frag'
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
    --{name = 'Galaxy2',  frag = 'shaders/fragment/galaxy.frag', drawColor = false},
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
    {name = 'slime',  frag = 'shaders/fragment/slime.frag', drawColor = true},
    
    --monster shaders
    {name = 'Monster Might', frag = 'shaders/fragment/monster_might.frag'},
    {name = 'Blackout', frag = 'shaders/fragment/blackout.frag'},
    {name = 'Stealth', frag = 'shaders/fragment/stealth.frag'},


    {name = 'Forged', frag = 'shaders/fragment/forged.frag', drawColor = false},
    {name = 'Orbital', frag = 'shaders/fragment/orbital.frag', drawColor = false},
    {name = 'Corrupted', frag = 'shaders/fragment/corrupted.frag', drawColor = false},

    {name = 'Damaged', useFramebuffer = true, frag = 'shaders/fragment/damaged.frag', drawColor = true},

    {name = 'Zaphire', frag = 'shaders/fragment/creature_texture_zoom.frag', tex1 = '/images/shaders/zaphire.png', drawColor = false},
    {name = 'Galaxy', frag = 'shaders/fragment/creature_texture_sample.frag', tex1 = '/images/shaders/galaxy.png', drawColor = false},
    {name = 'Blue Flames', frag = 'shaders/fragment/creature_texture_zoom.frag', tex1 = '/images/shaders/blueflames.png', drawColor = false},
    {name = 'Prismatic', frag = 'shaders/fragment/creature_texture_zoom.frag', tex1 = '/images/shaders/prismatic.png', drawColor = false},
    {name = 'Blueveins', frag = 'shaders/fragment/creature_texture_sample.frag', tex1 = '/images/shaders/blueveins.png', drawColor = false},
    {name = 'Diamond', frag = 'shaders/fragment/creature_texture_zoom.frag', tex1 = '/images/shaders/diamond.png', drawColor = false},
    {name = 'Red Flames', frag = 'shaders/fragment/creature_texture_sample.frag', tex1 = '/images/shaders/redflames.png', drawColor = false},
    {name = 'Aqua', frag = 'shaders/fragment/creature_texture_zoom.frag', tex1 = '/images/shaders/aqua.png', drawColor = false},
    {name = 'Fire Spiral', frag = 'shaders/fragment/creature_texture_zoom.frag', tex1 = '/images/shaders/firespiral.png', drawColor = false},
    {name = 'Purple Aqua', frag = 'shaders/fragment/creature_texture_zoom.frag', tex1 = '/images/shaders/purpleaqua.png', drawColor = false},
    {name = 'Ashes', frag = 'shaders/fragment/creature_texture_sample.frag', tex1 = '/images/shaders/ashes.png', drawColor = false},
    {name = 'Storm', frag = 'shaders/fragment/creature_texture_sample.frag', tex1 = '/images/shaders/storm.png', drawColor = false},
    {name = 'Mercury', frag = 'shaders/fragment/creature_texture_zoom.frag', tex1 = '/images/shaders/mercury.png', drawColor = false},
    {name = 'Abstract', frag = 'shaders/fragment/creature_texture_sample.frag', tex1 = '/images/shaders/abstract.png', drawColor = false},
    {name = 'Circuit', frag = 'shaders/fragment/creature_texture_zoom.frag', tex1 = '/images/shaders/circuit.png', drawColor = false},
    {name = 'Glitch', frag = 'shaders/fragment/creature_texture_zoom.frag', tex1 = '/images/shaders/glitch.png', drawColor = false},
    {name = 'Waves', frag = 'shaders/fragment/creature_texture_zoom.frag', tex1 = '/images/shaders/waves.png', drawColor = false},
    {name = 'Ruby', frag = 'shaders/fragment/creature_texture_zoom.frag', tex1 = '/images/shaders/ruby.png', drawColor = false},
    {name = 'Prisma', frag = 'shaders/fragment/creature_texture_zoom.frag', tex1 = '/images/shaders/prisma.png', drawColor = false},
    {name = 'Vortex', frag = 'shaders/fragment/creature_texture_zoom.frag', tex1 = '/images/shaders/vortex.png', drawColor = false},
    {name = 'Purple Wave', frag = 'shaders/fragment/creature_texture_zoom.frag', tex1 = '/images/shaders/purplewave.png', drawColor = false},
    {name = 'Abstract Solid', frag = 'shaders/fragment/creature_texture_zoom.frag', tex1 = '/images/shaders/abstractsolid.png', drawColor = false},
    {name = 'Balloons', frag = 'shaders/fragment/creature_texture_sample.frag', tex1 = '/images/shaders/balloons.png', drawColor = false},
    {name = 'Clouds White', frag = 'shaders/fragment/creature_texture_sample.frag', tex1 = '/images/shaders/clouds_white.png', drawColor = false},
    {name = 'Clouds Gray', frag = 'shaders/fragment/creature_texture_sample.frag', tex1 = '/images/shaders/clouds_gray.png', drawColor = false},
    {name = 'Cyborg', frag = 'shaders/fragment/creature_texture_zoom.frag', tex1 = '/images/shaders/cyborg.png', drawColor = false},
    {name = 'Glitch 2', frag = 'shaders/fragment/creature_texture_zoom.frag', tex1 = '/images/shaders/glitch2.png', drawColor = false},
    {name = 'Majestic', frag = 'shaders/fragment/creature_texture_zoom.frag', tex1 = '/images/shaders/majestic.png', drawColor = false},
    {name = 'Golden', frag = 'shaders/fragment/creature_texture_sample.frag', tex1 = '/images/shaders/golden.png', drawColor = false},
    {name = 'Slime', frag = 'shaders/fragment/creature_texture_zoom.frag', tex1 = '/images/shaders/slime.png', drawColor = false},
    {name = 'Sky', frag = 'shaders/fragment/creature_texture_zoom.frag', tex1 = '/images/shaders/sky.png', drawColor = false}



 }

TEXTURE_OUTFIT_SHADERS = {}
for _, opts in ipairs(OUTFIT_SHADERS) do
    if opts.frag == 'shaders/fragment/creature_texture_sample.frag' and opts.tex1 then
        table.insert(TEXTURE_OUTFIT_SHADERS, opts)
    end
end

MOUNT_SHADERS = { {
    name = 'Mount - Default',
    frag = nil
}, {
    name = 'Mount - Rainbow',
    frag = 'shaders/fragment/party.frag'
} }

ENHANCE_SHADER_NAME = 'Map - Enhance'

-- GLSL post-process function: color enhancements applied after any weather shader
local ENHANCE_POST_GLSL = [=[
vec3 _enhancePost(vec3 color, vec2 uv) {
    vec3 curved = color * color * (3.0 - 2.0 * color);
    color = mix(color, curved, 0.5);
    float luma = dot(color, vec3(0.299, 0.587, 0.114));
    float mx = max(color.r, max(color.g, color.b));
    float mn = min(color.r, min(color.g, color.b));
    float sat = mx - mn;
    color = mix(vec3(luma), color, 1.0 + 0.15 * (1.0 - sat));
    luma = dot(color, vec3(0.299, 0.587, 0.114));
    color = mix(vec3(luma), color, 1.08);
    color.r += 0.005;
    color.b -= 0.0025;
    vec2 d = uv - 0.5;
    color *= 1.0 - dot(d, d) * 0.8;
    return clamp(color, 0.0, 1.0);
}
]=]

-- Maps original shader name -> combined enhanced name
local enhancedShaderMap = {}
-- Maps shader name -> its options (for drawViewportEdge etc.)
local mapShaderOpts = {}
local suppressShaderComboCallbacks = false

function isEnhanceEnabled()
    return g_settings.getBoolean('enhance-graphics', true)
end

function setEnhanceEnabled(enabled)
    g_settings.set('enhance-graphics', enabled)
    local map = modules.game_interface.getMapPanel()
    if map then
        if enabled then
            map:setShader(ENHANCE_SHADER_NAME)
        else
            map:setShader('Map - Default')
        end
    end
end

function getDefaultMapShader()
    if isEnhanceEnabled() then
        return ENHANCE_SHADER_NAME
    end
    return 'Map - Default'
end

function setMapShaderSafe(shaderName)
    local map = modules.game_interface.getMapPanel()
    if not map then return end

    local opts = mapShaderOpts[shaderName]

    if isEnhanceEnabled() then
        if shaderName == 'Map - Default' then
            shaderName = ENHANCE_SHADER_NAME
        elseif enhancedShaderMap[shaderName] then
            shaderName = enhancedShaderMap[shaderName]
        end
    end

    map:setShader(shaderName)
    if opts then
        map:setDrawViewportEdge(opts.drawViewportEdge == true)
    end
end

local function attachShaders()
    local map = modules.game_interface.getMapPanel()
    map:setShader(getDefaultMapShader())
end

local function addShaderTextures(shaderName, opts)
    if not opts then
        return
    end

    local addTexture = g_shaders.addTexture or g_shaders.addMultiTexture
    if not addTexture then
        return
    end

    if opts.tex1 then
        addTexture(shaderName, opts.tex1)
    end
    if opts.tex2 then
        addTexture(shaderName, opts.tex2)
    end

    if opts.texture then
        addTexture(shaderName, opts.texture)
    end

    if type(opts.textures) == 'table' then
        for _, texture in ipairs(opts.textures) do
            if texture then
                addTexture(shaderName, texture)
            end
        end
    end
end

local registerShader = function(opts, method)
    local fragmentShaderPath = resolvepath(opts.frag)

    if fragmentShaderPath ~= nil then
        --  local shader = g_shaders.createShader()
        g_shaders.createFragmentShader(opts.name, opts.frag, opts.useFramebuffer or false)
        addShaderTextures(opts.name, opts)

        -- Setup proper uniforms
        g_shaders[method](opts.name)
    end
end

ShaderController = Controller:new()

function ShaderController:onInit()
    for _, opts in pairs(MAP_SHADERS) do
        registerShader(opts, 'setupMapShader')
        mapShaderOpts[opts.name] = opts
    end

    -- Create combined enhance + weather shaders
    for _, opts in pairs(MAP_SHADERS) do
        if opts.frag and opts.name ~= ENHANCE_SHADER_NAME then
            local ok, source = pcall(function()
                return g_resources.readFileContents(resolvepath(opts.frag))
            end)
            if ok and source and #source > 0 then
                -- Rename void main() -> void _weatherMain()
                local modified = source:gsub('void%s+main%s*%(', 'void _weatherMain(')
                local combined = modified .. '\n' .. ENHANCE_POST_GLSL .. '\n' ..
                    'void main() {\n' ..
                    '    _weatherMain();\n' ..
                    '    gl_FragColor = vec4(_enhancePost(gl_FragColor.rgb, v_TexCoord), gl_FragColor.a);\n' ..
                    '}\n'

                local combinedName = opts.name .. ' + Enhance'
                g_shaders.createFragmentShaderFromCode(combinedName, combined, opts.useFramebuffer or false)
                g_shaders.setupMapShader(combinedName)
                addShaderTextures(combinedName, opts)
                enhancedShaderMap[opts.name] = combinedName
            end
        end
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

    suppressShaderComboCallbacks = true

    for _, opts in pairs(MAP_SHADERS) do
        self.ui.mapComboBox:addOption(opts.name, opts)
    end

    for _, opts in pairs(OUTFIT_SHADERS) do
        self.ui.outfitComboBox:addOption(opts.name, opts)
    end

    if self.ui.textureComboBox then
        for _, opts in ipairs(TEXTURE_OUTFIT_SHADERS) do
            self.ui.textureComboBox:addOption(opts.name, opts)
        end
    end

    for _, opts in pairs(MOUNT_SHADERS) do
        self.ui.mountComboBox:addOption(opts.name, opts)
    end

    local player = g_game.getLocalPlayer()
    if player and self.ui.outfitComboBox then
        local currentOutfit = player:getOutfit()
        local currentShader = (currentOutfit and (currentOutfit.shaders or currentOutfit.shader)) or 'Outfit - Default'
        if currentShader == '' then
            currentShader = 'Outfit - Default'
        end
        self.ui.outfitComboBox:setCurrentOption(currentShader)

        local selected = self.ui.outfitComboBox:getCurrentOption()
        if selected and selected.data then
            player:setDrawOutfitColor(selected.data.drawColor ~= false)
        end
    end

    suppressShaderComboCallbacks = false

    -- Handle server-side map shader changes (from parseMapShader C++ -> Lua event)
    connect(g_game, { onMapShaderChange = setMapShaderSafe })
end

function ShaderController:onGameEnd()
    disconnect(g_game, { onMapShaderChange = setMapShaderSafe })
end

function ShaderController:onMapComboBoxChange(event)
    local shaderName = event.text
    if isEnhanceEnabled() then
        if shaderName == 'Map - Default' then
            shaderName = ENHANCE_SHADER_NAME
        elseif enhancedShaderMap[shaderName] then
            shaderName = enhancedShaderMap[shaderName]
        end
    end

    local map = modules.game_interface.getMapPanel()
    map:setShader(shaderName)

    local data = event.target:getCurrentOption().data
    map:setDrawViewportEdge(data.drawViewportEdge == true)
end

function ShaderController:onOutfitComboBoxChange(event)
    if suppressShaderComboCallbacks then
        return
    end

    local player = g_game.getLocalPlayer()
    if player then
        player:setShader(event.text)
        local data = event.target:getCurrentOption().data
        player:setDrawOutfitColor(data.drawColor ~= false)
    end
end

function ShaderController:onTextureComboBoxChange(event)
    if suppressShaderComboCallbacks then
        return
    end

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
