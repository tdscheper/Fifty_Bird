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
    self.score = params.score
    self.bird = params.bird
    self.collided = params.collided
end

function ScoreState:update(dt)
    if self.collided then
        self.bird:fall_to_ground(dt) 
    end
    -- go back to play if enter is pressed
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('countdown')
    end
end

function ScoreState:render()
    bronze = love.graphics.newImage('images/bronze_medal.png')
    silver = love.graphics.newImage('images/silver_medal.png')
    gold = love.graphics.newImage('images/gold_medal.png')
    
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
    love.graphics.printf('Score: ' .. tostring(self.score), 0, 130, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('Press Enter to Play Again!', 0, 150, VIRTUAL_WIDTH, 'center')
end