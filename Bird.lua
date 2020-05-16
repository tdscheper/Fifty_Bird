--[[
    Bird Class
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The Bird is what we control in the game via clicking or the space bar; whenever we press either,
    the bird will flap and go up a little bit, where it will then be affected by gravity. If the bird hits
    the ground or a pipe, the game is over.

    Updated by Tommy Scheper
    tdscheper@gmail.com
]]

Bird = Class{}

local GRAVITY = 20

function Bird:init()
    self.image = love.graphics.newImage('images/bird.png')
    self.x = (VIRTUAL_WIDTH - BIRD_WIDTH) / 2
    self.y = (VIRTUAL_HEIGHT - BIRD_HEIGHT) / 2

    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    self.dy = 0
end

--[[
    AABB collision that expects a pipe, which will have an X and Y and reference
    global pipe width and height values.
]]
function Bird:collides(pipe)
    if self.x + self.width - LEEWAY >= pipe.x and self.x + LEEWAY <= pipe.x + PIPE_WIDTH then
        if pipe.orientation == 'top' then
            if self.y + LEEWAY <= pipe.y then
                return true
            end
        else
            if self.y + self.height - LEEWAY >= pipe.y then
                return true
            end
        end
    end

    return false
end

function Bird:update(dt)
    self.dy = self.dy + GRAVITY * dt

    if love.keyboard.wasPressed('space') or love.mouse.wasPressed(1) then
        self.dy = -5
        sounds['jump']:play()
    end

    self.y = self.y + self.dy
end

-- Makes bird fall to the ground after colliding with a pipe
function Bird:fall_to_ground(dt)
    self.dy = self.dy + GRAVITY * dt
    self.y = self.y + self.dy
    
    if self.y + BIRD_HEIGHT >= VIRTUAL_HEIGHT - GROUND_HEIGHT then
        self.y = VIRTUAL_HEIGHT - GROUND_HEIGHT - BIRD_HEIGHT
    end
    
end

function Bird:render()
    love.graphics.draw(self.image, self.x, self.y)
end