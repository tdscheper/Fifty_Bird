--[[
    PlayState Class
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The PlayState class is the bulk of the game, where the player actually controls the bird and
    avoids pipes. When the player collides with a pipe, we should go to the GameOver state, where
    we then go back to the main menu.
    
    Updated by Tommy Scheper
    tdscheper@gmail.com
]]

PlayState = Class{__includes = BaseState}

--[[
    Called when this state is transitioned to from another state.
]]
function PlayState:enter(params)
    scrolling = true
    self.bird = params.bird
    self.pipePairs = params.pipePairs
    self.timer = params.timer
    self.score = params.score
    self.highScore = params.highScore
    self.highScoreTrue = params.highScoreTrue
end

function PlayState:update(dt)
    -- update timer for pipe spawning
    self.timer = self.timer + dt

    collided = false

    -- spawn a new pipe pair every 1.25 to 1.75 seconds (this felt right)
    if self.timer > math.random(1.25, 1.75) then
        -- determine size of gap
        local gapHeight = math.random(BIRD_HEIGHT * 3, BIRD_HEIGHT * 4)
        local maxVisiblePipeLength = (VIRTUAL_HEIGHT - GROUND_HEIGHT - gapHeight) / 2 + MIN_VISIBLE_PIPE_LENGTH
        
        -- let pipe be placed at random y that is valid
        local y = math.random(MIN_VISIBLE_PIPE_LENGTH, maxVisiblePipeLength)

        -- add a new pipe pair at the end of the screen at our new Y
        table.insert(self.pipePairs, PipePair(y, gapHeight))

        -- reset timer
        self.timer = 0
    end

    -- for every pair of pipes..
    for k, pair in pairs(self.pipePairs) do
        -- score a point if the pipe has gone past the bird to the left all the way
        -- be sure to ignore it if it's already been scored
        if not pair.scored then
            if pair.x + PIPE_WIDTH < self.bird.x then
                self.score = self.score + 1
                pair.scored = true
                sounds['score']:play()
            end
        end

        -- update position of pair
        pair:update(dt)
    end

    -- we need this second loop, rather than deleting in the previous loop, because
    -- modifying the table in-place without explicit keys will result in skipping the
    -- next pipe, since all implicit keys (numerical indices) are automatically shifted
    -- down after a table removal
    for k, pair in pairs(self.pipePairs) do
        if pair.remove then
            table.remove(self.pipePairs, k)
        end
    end

    -- allow player to pause/unpause game by pressing P
    if love.keyboard.wasPressed('p') then
        gStateMachine:change('pause', {
            bird = self.bird, 
            pipePairs = self.pipePairs,
            timer = self.timer,
            score = self.score,
            highScore = self.highScore
        })
    end

    -- simple collision between bird and all pipes in pairs
    for k, pair in pairs(self.pipePairs) do
        for l, pipe in pairs(pair.pipes) do
            collide = self.bird:collides(pipe)    
            if collide then
                sounds['explosion']:play()
                sounds['hurt']:play()

                if self.score > self.highScore then
                    self.highScore = self.score
                    love.filesystem.write('fifty_bird.lst', tostring(self.highScore) .. '\n')
                    self.highScoreTrue = true
                end

                gStateMachine:change('score', {
                    bird = self.bird,
                    pipePairs = self.pipePairs,
                    score = self.score,
                    highScore = self.highScore,
                    highScoreTrue = self.highScoreTrue,
                    collided = collide
                })
            end
        end
    end

    -- update bird based on gravity and input
    self.bird:update(dt)

    -- reset if we get to the ground
    if self.bird.y + BIRD_HEIGHT + LEEWAY >= VIRTUAL_HEIGHT - GROUND_HEIGHT then
        self.bird.y = VIRTUAL_HEIGHT - GROUND_HEIGHT - BIRD_HEIGHT
        sounds['explosion']:play()
        sounds['hurt']:play()

        if self.score > self.highScore then
            self.highScore = self.score
            love.filesystem.write('fifty_bird.lst', tostring(self.highScore) .. '\n')
            self.highScoreTrue = true
        end

        gStateMachine:change('score', {
            bird = self.bird,
            pipePairs = self.pipePairs,
            score = self.score,
            highScore = self.highScore,
            highScoreTrue = self.highScoreTrue,
            collided = collide
        })
    end
end

function PlayState:render()
    for k, pair in pairs(self.pipePairs) do
        pair:render()
    end

    love.graphics.setFont(flappyFont)
    love.graphics.print('Score: ' .. tostring(self.score), 8, 8)

    self.bird:render()
end

--[[
    Called when this state changes to another state.
]]
function PlayState:exit()
    -- stop scrolling for the death/score screen
    scrolling = false
end
