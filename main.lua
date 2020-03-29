--[[
	Space Invaders Remake 

	- Main Program - 

	Author: Aamer Shikari 
	shikariaamer@gmail.com

	Features a spaceship (Player) with the goal of getting the 
	highest score possible. After each round the difficulty of 
	the invaders and the point values increase. 

	ADDITIONAL NOTES HERE
]]

-- push is a library that will allow us to draw our game at a virtual
-- resolution, instead of however large our window is; used to provide
-- a more retro aesthetic
--
-- https://github.com/Ulydev/push
push = require 'push'

-- the "Class" library we're using will allow us to represent anything in
-- our game as code, rather than keeping track of many disparate variables and
-- methods
--
-- https://github.com/vrld/hump/blob/master/class.lua
Class = require 'class'

-- our Cursor class, is a structure that helps us in determining which mode 
-- the user is looking to play, very simple yet extremely fundamental
require 'Cursor'

-- our Ship class, 
require 'Ship'

-- Enemy/Alien class 
require 'Alien'

-- Bullet class
require 'Bullet'

-- size of our actual window 
WINDOW_WIDTH = 1100
WINDOW_HEIGHT = 540

-- size we're trying to emulate with push
VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

-- creation of the ship/player object 

local Player1 = Ship(VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT - 15)
local Player2 = Ship(VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT - 15)
local a = {}
for i = 0, 9 do 
	a[i] = {}
	for j = 0, 4 do 
		a[i][j] = Alien(10 + 22*i, 30 + 17*j, i, j)
	end
end 
local shot = Bullet()
-- speed of the ship 
SHIP_SPEED = 350

-- image rotation counter
swap = 0

function love.load()
    -- set love's default filter to "nearest-neighbor", which essentially
    -- means there will be no filtering of pixels (blurriness), which is
    -- important for a nice crisp, 2D look
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- set the title of our application window
    love.window.setTitle('Space Invaders')

    -- seed the RNG so that calls to random are always random
    math.randomseed(os.time())

    -- initialize our nice-looking retro text fonts
    smallFont = love.graphics.newFont('font.ttf', 8)
    largeFont = love.graphics.newFont('font.ttf', 16)
    scoreFont = love.graphics.newFont('font.ttf', 32)
    love.graphics.setFont(smallFont)


    -- Sounds stored here for later use 
    -- sounds = { 

    --}

    -- initialize our virtual resolution, which will be rendered within our
    -- actual window no matter its dimensions
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true,
        canvas = false
    })

    --the state of the game, can be any of the following: 
    -- 1. 'intro' (the loading screen/beginning of the game)
    gameState = 'intro'

    -- variables to store the players scores
    SCORE_1 = 0
    SCORE_2 = 0 
    SCORE_HI = 0

    --Level for the aliens (difficulty indicator)
    P1_LEVEL = 1
    P2_LEVEL = 1

    -- Indicator of current Player
    TURN = 1

    --Incidcator of dead alien colums
    DEAD_LEFT = 0
    DEAD_RIGHT = 0

    -- creates an instance of each cursor for start screen
    cursor = Cursor(VIRTUAL_WIDTH / 2 - 42, VIRTUAL_HEIGHT / 2 - 28, 4, 2, 2)

    
end

--[[
    Called whenever we change the dimensions of our window, as by dragging
    out its bottom corner, for example. In this case, we only need to worry
    about calling out to `push` to handle the resizing. Takes in a `w` and
    `h` variable representing width and height, respectively.
]]
function love.resize(w, h)
    push:resize(w, h)
end

function love.update(dt)
	if gameState == 'intro' then 
		if love.keyboard.isDown('down') then 
			cursor:change('down')
		elseif love.keyboard.isDown('up') then 
			cursor:change('up')
		end 	
	end 
	if love.keyboard.isDown('left') then 
		Player1.dx = -SHIP_SPEED
	elseif love.keyboard.isDown('right') then 
		Player1.dx = SHIP_SPEED
	elseif love.keyboard.isDown('space') then 
		Player1:fire(shot)
	else
		Player1.dx = 0
	end
	Player1:update(dt)
	
	for i = 0, 9 do
		for j = 0, 4 do 
			if (a[i][j].alive) then
				if shot:collides(a[i][j]) then
					a[i][j].alive = false
					shot:hit()
					if (TURN == 1) then 
						SCORE_1 = SCORE_1 + P1_LEVEL*100
					else 
						SCORE_2 = SCORE_2 + P2_LEVEL*100
					end
				end
			end
		end
	end


 
	for i = 0, 4 do 
		if (a[0][i].x < 0) then 
			for j = DEAD_LEFT, 9 - DEAD_RIGHT do
				for k = 0, 4 do
					a[j][k].dx = P1_LEVEL
					a[j][k]:update_y()
				end 
			end 
		elseif (a[9][i].x > VIRTUAL_WIDTH - a[0][0].width) then 
			for j = 0, 9 do
				for k = 0, 4 do
					a[j][k].dx = -P1_LEVEL
					a[j][k]:update_y()
				end 
			end 
		end
	end

	for j = 4, 0, -1 do 
		for i = 0, 9 do
			if (a[i][j].alive) then 
				if (a[i][j].y > Player1.y - 20) then 
					gameState = 'over'

				end 
			end 
		end 
	end

	swap = swap + 1
	for i = 0, 9 do 
		for j = 0, 4 do 
			if (swap == 10) then 
				a[i][j]:swap_image()
			end
			a[i][j]:update_x()
		end 
	end
	if (swap == 10) then 
		swap = 0
	end
	shot:update(dt)
	if (boardCleared()) then 
		if (TURN == 1) then 
			P1_LEVEL = P1_LEVEL + 1
			resetBoard(Player1)
		else 
			P2_LEVEL = P2_LEVEL + 1
			resetBoard(Player2)
		end
	end

end

function love.keypressed(key)
	-- `key` will be whatever key this callback detected as pressed
	if key == 'escape' then
        -- the function LÖVE2D uses to quit the application
        love.event.quit()
    -- if we press enter during either the start or serve phase, it should
    -- transition to the next appropriate state
	elseif key == 'enter' or key == 'return' then 
		if (gameState == 'intro') then 
			gameState = 'play'
		elseif (gameState == 'over') then 
			gameState = 'intro'
		end 
	end

end 

function love.draw()
	-- begin drawing with push, in our virtual realm 
	push:start()
	love.graphics.setFont(smallFont) 
	-- render the different texts dependent on gameState 
	if gameState == 'intro' then 
		-- UI messages 
		love.graphics.printf('One Player', 0, VIRTUAL_HEIGHT/2 - 30, VIRTUAL_WIDTH, 'center')
		love.graphics.printf('Two Player', 0, VIRTUAL_HEIGHT/2, VIRTUAL_WIDTH, 'center' )
		cursor:render()

	elseif gameState == 'play' then 
		Player1:render()
		for i = 0, 9 do 
			for j = 0, 4 do 
				a[i][j]:render()
			end 
		end
		shot:render()
	elseif gameState == 'over' then 
		love.graphics.printf('GAME OVER', 110, VIRTUAL_HEIGHT/2, VIRTUAL_WIDTH/2, 'center')
		love.graphics.printf('Press Enter to Play Again!!', 110, VIRTUAL_HEIGHT/2 + 20, VIRTUAL_WIDTH/2, 'center')
	end 
	
	SCORE_HI = math.max(SCORE_1, SCORE_2, SCORE_HI)

	love.graphics.printf('Score<1> HI-SCORE Score<2>', 0, 0, VIRTUAL_WIDTH, 'justify')
	love.graphics.printf(SCORE_1 .. " " .. SCORE_HI .. " " .. SCORE_2, 0, 10, VIRTUAL_WIDTH, 'justify')
	


	-- end our drawing to the virtual realm
	push:finish()
end 

function boardCleared()
	for i = 0, 9 do 
		for j = 0, 4 do
			if (a[i][j].alive) then 
				return false 
			end 
		end 
	end 
	return true
end

function resetBoard(player) 
	for i = 0, 9 do 
		for j = 0, 4 do 
			a[i][j].alive = true
			a[i][j]:reset()
			a[i][j].dx = P1_LEVEL
		end 
	end 
end

function ROW_DEAD(i) 
	for j = 0, 4 do 
		if (a[i][j].alive) then 
			return false
		end 
	end
	return true
end