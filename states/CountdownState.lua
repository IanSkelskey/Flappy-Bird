--[[
    Countdown State
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Counts down visually on the screen (3,2,1) so that the player knows the
    game is about to begin. Transitions to the PlayState as soon as the
    countdown is complete.
]]

CountdownState = Class{__includes = BaseState}

-- takes 1 second to count down each time
COUNTDOWN_TIME = 0.75

function CountdownState:enter(params)
    self.highScores = params.highScores
    self.score = params.score
end

function CountdownState:init()
    sounds['count']:play()
    if fromStart then
        bird = Bird()
        pipePairs = {}
        else
            scrolling = false
    end
    self.count = 3
    self.timer = 0

end

--[[
    Keeps track of how much time has passed and decreases count if the
    timer has exceeded our countdown time. If we have gone down to 0,
    we should transition to our PlayState.
]]
function CountdownState:update(dt)
    self.timer = self.timer + dt

    -- loop timer back to 0 (plus however far past COUNTDOWN_TIME we've gone)
    -- and decrement the counter once we've gone past the countdown time
    if self.timer > COUNTDOWN_TIME then
        if self.count ~= 1 then
            sounds['count']:play()
        end
        self.timer = self.timer % COUNTDOWN_TIME
        self.count = self.count - 1


        -- when 0 is reached, we should enter the PlayState
        if self.count == 0 then

            gStateMachine:change('play', {
              highScores = self.highScores,
              score = self.score
            })
        end
    end
end

function CountdownState:render()
    if fromStart == false then
        for k, pair in pairs(pipePairs) do
            pair:render()
        end


        love.graphics.setFont(flappyFont)
        love.graphics.print('Score: ' .. tostring(score), 8, 8)
        bird:render()

        if self.highScores == nil then
          love.graphics.print('high score table is nil...', 50, 70)
        end

    end
    -- render count big in the middle of the screen

    love.graphics.setFont(hugeFont)
    love.graphics.printf(tostring(self.count), 0, 120, VIRTUAL_WIDTH, 'center')
end
