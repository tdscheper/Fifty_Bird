--[[
    PauseState Class
    
    Author: Tommy Scheper
    tdscheper@gmail.com

    The PauseState is the pause screen, which is brought up when a player presses P. 
    It should halt the gameplay and display "PAUSED". Once the player presses P
    again, they are taken out of the PauseState.
]]

PauseState = Class{__includes = BaseState}

function PauseState:enter(params)
    self.bird = params.bird
    self.origBirdDY = params.bird.dy
    self.pipePairs = params.pipePairs
    self.timer = params.timer
    self.score = params.score
    self.highScore = params.highScore
    self.highScoreTrue = params.highScoreTrue
    love.audio.pause(sounds['music'])
    sounds['pause']:play()
end

function PauseState:update(dt)
    -- stop the bird
    self.bird.dy = 0

    if love.keyboard.wasPressed('p') then
        -- get the bird moving again, resume game
        self.bird.dy = self.origBirdDY
        gStateMachine:change('play', {
            bird = self.bird,
            pipePairs = self.pipePairs,
            timer = self.timer,
            score = self.score,
            highScore = self.highScore,
            highScoreTrue = self.highScoreTrue
        })
    end
end

function PauseState:render()
    love.graphics.setFont(flappyFont)
    love.graphics.printf('PAUSED', 0, 80, VIRTUAL_WIDTH, 'center')
end

function PauseState:exit()
    sounds['pause']:play()
    love.audio.resume(sounds['music'])
end
