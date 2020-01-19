
require 'src/Dependencies'

function love.load()
    
    love.graphics.setDefaultFilter('nearest', 'nearest')

    math.randomseed(os.time())

    love.window.setTitle('Breakout')

    gFonts = {
        ['small'] = love.graphics.newFont('assets/fonts/font.ttf', 8),
        ['medium'] = love.graphics.newFont('assets/fonts/font.ttf', 16),
        ['large'] = love.graphics.newFont('assets/fonts/font.ttf', 32)
    }
    love.graphics.setFont(gFonts['small'])

    gTextures = {
        ['background'] = love.graphics.newImage('assets/graphics/background.png'),
        ['main'] = love.graphics.newImage('assets/graphics/breakout.png'),
        ['arrows'] = love.graphics.newImage('assets/graphics/arrows.png'),
        ['hearts'] = love.graphics.newImage('assets/graphics/hearts.png'),
        ['particle'] = love.graphics.newImage('assets/graphics/particle.png')
    }
    
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    gSounds = {
        ['paddle-hit'] = love.audio.newSource('assets/sounds/paddle_hit.wav', 'static'),
        ['score'] = love.audio.newSource('assets/sounds/score.wav', 'static'),
        ['wall-hit'] = love.audio.newSource('assets/sounds/wall_hit.wav', 'static'),
        ['confirm'] = love.audio.newSource('assets/sounds/confirm.wav', 'static'),
        ['select'] = love.audio.newSource('assets/sounds/select.wav', 'static'),
        ['no-select'] = love.audio.newSource('assets/sounds/no-select.wav', 'static'),
        ['brick-hit-1'] = love.audio.newSource('assets/sounds/brick-hit-1.wav', 'static'),
        ['brick-hit-2'] = love.audio.newSource('assets/sounds/brick-hit-2.wav', 'static'),
        ['hurt'] = love.audio.newSource('assets/sounds/hurt.wav', 'static'),
        ['victory'] = love.audio.newSource('assets/sounds/victory.wav', 'static'),
        ['recover'] = love.audio.newSource('assets/sounds/recover.wav', 'static'),
        ['high-score'] = love.audio.newSource('assets/sounds/high_score.wav', 'static'),
        ['pause'] = love.audio.newSource('assets/sounds/pause.wav', 'static'),

        ['music'] = love.audio.newSource('assets/sounds/music.wav', 'static')
    }

    gStateMachine = StateMachine {
        ['start'] = function() return StartState() end
    }
    gStateMachine:change('start')

    love.keyboard.keysPressed = {}
end



function love.resize(w, h)
    push:resize(w, h)
end

function love.update(dt)
    gStateMachine:update(dt)

    -- reset keys pressed
    love.keyboard.keysPressed = {}
end

function love.keypressed(key)
    -- add to our table of keys pressed this frame
    love.keyboard.keysPressed[key] = true
end

function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end
end

function love.draw()

    push:apply('start')

    local backgroundWidth = gTextures['background']:getWidth()
    local backgroundHeight = gTextures['background']:getHeight()

    love.graphics.draw(gTextures['background'], 
        -- draw at coordinates 0, 0
        0, 0, 
        -- no rotation
        0,
        -- scale factors on X and Y axis so it fills the screen
        VIRTUAL_WIDTH / (backgroundWidth - 1), VIRTUAL_HEIGHT / (backgroundHeight - 1))
    
    -- use the state machine to defer rendering to the current state we're in
    gStateMachine:render()
    
    -- display FPS for debugging; simply comment out to remove
    displayFPS()
    
    push:apply('end')
end

--[[
    Renders the current FPS.
]]
function displayFPS()
    -- simple FPS display across all states
    love.graphics.setFont(gFonts['small'])
    love.graphics.setColor(0, 255, 0, 255)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 5, 5)
end