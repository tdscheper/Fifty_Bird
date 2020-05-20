--[[
    ScoreState Class
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    A simple state used to display the player's score before they
    transition back into the play state. Transitioned to from the
    PlayState when they collide with a Pipe.

    Updated by Tommy Scheper
    tdscheper@gmail.com
]]

ScoreState = Class{__includes = BaseState}

local MEDAL_WIDTH = 50
local MEDAL_HEIGHT = 50

--[[
    When we enter the score state, we expect to receive the score
    from the play state so we know what to render to the State.
]]
function ScoreState:enter(params)
    self.bird = params.bird
    self.pipePairs = params.pipePairs
    self.score = params.score
    self.highScore = params.highScore
    self.highScoreTrue = params.highScoreTrue
    self.collided = params.collided
    self.timer = 0
end

function ScoreState:update(dt)
    self.timer = self.timer + 1
   
    if self.collided then
        self.bird:fall_to_ground(dt) 
    end

    -- go back to play if enter is pressed. Allow a few seconds to wait
    if self.timer > 3 then
        if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
            gStateMachine:change('countdown', {highScore = self.highScore})
        end
    end
end

function ScoreState:render()
    bronze = love.graphics.newImage('images/bronze_medal.png')
    silver = love.graphics.newImage('images/silver_medal.png')
    gold = love.graphics.newImage('images/gold_medal.png')
    
    for k, pair in pairs(self.pipePairs) do
        pair:render()
    end
    self.bird:render()
    
    -- simply render medal, score to the middle of the screen
    if self.score >= 15 and self.score < 25 then
        love.graphics.draw(bronze, (VIRTUAL_WIDTH - MEDAL_WIDTH) / 2, (VIRTUAL_HEIGHT - MEDAL_HEIGHT) / 4)
    elseif self.score >= 25 and self.score < 35 then
        love.graphics.draw(silver, (VIRTUAL_WIDTH - MEDAL_WIDTH) / 2, (VIRTUAL_HEIGHT - MEDAL_HEIGHT) / 4)
    elseif self.score >= 35 then
        love.graphics.draw(gold, (VIRTUAL_WIDTH - MEDAL_WIDTH) / 2, (VIRTUAL_HEIGHT - MEDAL_HEIGHT) / 4)
    end

    love.graphics.setFont(mediumFont)
    if not self.highScoreTrue then
        love.graphics.printf('Score: ' .. tostring(self.score), 0, 130, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Tap to Play Again!', 0, 150, VIRTUAL_WIDTH, 'center')
    else
        love.graphics.printf('New High Score!', 0, 130, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Score: ' .. tostring(self.score), 0, 150, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Tap to Play Again!', 0, 170, VIRTUAL_WIDTH, 'center')
    end
end
