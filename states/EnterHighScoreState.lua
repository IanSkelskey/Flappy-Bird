--[[
    GD50
    Breakout Remake

    -- EnterHighScoreState Class --

    Author: Colton Ogden, Ian Skelskey
    cogden@cs50.harvard.edu, iskelske@asu.edu

    Screen that allows us to input a new high score in the form of three characters, arcade-style.
]]

EnterHighScoreState = Class{__includes = BaseState}

-- individual chars of our string
local chars = {
    [1] = 65, -- a
    [2] = 83, -- s
    [3] = 83  -- s
}

-- char we're currently changing
local highlightedChar = 1

function EnterHighScoreState:enter(params)
    self.highScores = params.highScores
    self.score = params.score
    self.scoreIndex = params.scoreIndex
end

function EnterHighScoreState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        -- update scores table
        local name = string.char(chars[1]) .. string.char(chars[2]) .. string.char(chars[3])

        -- go backwards through high scores table till this score, shifting scores
        for i = 10, self.scoreIndex, -1 do
            self.highScores[i + 1] = {
                name = self.highScores[i].name,
                score = self.highScores[i].score
            }
        end

        self.highScores[self.scoreIndex].name = name
        self.highScores[self.scoreIndex].score = self.score

        -- write scores to file
        local scoresStr = ''

        for i = 1, 10 do
            scoresStr = scoresStr .. self.highScores[i].name .. '\n'
            scoresStr = scoresStr .. tostring(self.highScores[i].score) .. '\n'
        end

        love.filesystem.write('flappy.lst', scoresStr)

        gStateMachine:change('high-scores', {
            highScores = self.highScores
        })
    end

    -- scroll through character slots
    if love.keyboard.wasPressed('left') and highlightedChar > 1 then
        highlightedChar = highlightedChar - 1
        sounds['select']:play()
    elseif love.keyboard.wasPressed('right') and highlightedChar < 3 then
        highlightedChar = highlightedChar + 1
        sounds['select']:play()
    end

    -- scroll through characters
    if love.keyboard.wasPressed('up') then
        chars[highlightedChar] = chars[highlightedChar] + 1
        if chars[highlightedChar] > 90 then
            chars[highlightedChar] = 65
        end
    elseif love.keyboard.wasPressed('down') then
        chars[highlightedChar] = chars[highlightedChar] - 1
        if chars[highlightedChar] < 65 then
            chars[highlightedChar] = 90
        end
    end
end

function EnterHighScoreState:render()
    love.graphics.setFont(mediumFont)
    love.graphics.printf('Your score: ' .. tostring(self.score), 0, 30,
        VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(smallFont)
    love.graphics.printf('Enter your name!', 0, 50,
        VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(mediumFont)

    --
    -- render all three characters of the name
    --
    if highlightedChar == 1 then
        love.graphics.setColor(255/255, 100/255, 100/255, 255/255)
    end
    love.graphics.print(string.char(chars[1]), VIRTUAL_WIDTH / 2 - 24, VIRTUAL_HEIGHT / 2)
    love.graphics.setColor(255/255, 255/255, 255/255, 255/255)

    if highlightedChar == 2 then
        love.graphics.setColor(255/255, 100/255, 100/255, 255/255)
    end
    love.graphics.print(string.char(chars[2]), VIRTUAL_WIDTH / 2 - 6, VIRTUAL_HEIGHT / 2)
    love.graphics.setColor(255/255, 255/255, 255/255, 255/255)

    if highlightedChar == 3 then
        love.graphics.setColor(255/255, 100/255, 100/255, 255/255)
    end
    love.graphics.print(string.char(chars[3]), VIRTUAL_WIDTH / 2 + 16, VIRTUAL_HEIGHT / 2)
    love.graphics.setColor(255/255, 255/255, 255/255, 255/255)

    love.graphics.setFont(smallFont)
    love.graphics.printf('Press Enter to confirm!', 0, VIRTUAL_HEIGHT - 44,
        VIRTUAL_WIDTH, 'center')
end
