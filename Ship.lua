--[[
	Ship Class 

	Author: Aamer Shikari 
	shikaraamer@gmail.com

	The ship is a unit controlled by the player. It is moved by the left/right 
	arrow keys and fires missiles with the spacebar. 
]]

Ship = Class{}

function Ship:init(x, y) 
	self.image = love.graphics.newImage('ship.png')
	self.width = self.image:getWidth()
	self.height = self.image:getHeight()

	-- Places the ship at the bottom center of the screen 
	self.dx = 0
	self.x =  x
	self.y =  y
end

--determines the displacement of the player at the end of a frame
function Ship:update(dt) 
	-- Prevent the player from going over the left side border
	if self.dx < 0 then
        self.x = math.max(0, self.x + self.dx * dt)
    -- Prevent the player from going over the right side border
    else
        self.x = math.min(VIRTUAL_WIDTH - self.width, self.x + self.dx * dt)
    end
end

-- Determines where a bullet will originate from and if it can be fired
function Ship:fire(bullet)
	if bullet.can then
		bullet.x = self.x + self.width/2 - 1
		bullet.y = self.y;
		bullet.dy = -125
		bullet.can = false
	end
end

function Ship:render()

	love.graphics.draw(self.image, self.x, self.y)
	--love.graphics.rectangle("fill", self.x - 1, self.y, 2, 2) 
	--love.graphics.rectangle("fill", self.x+ self.width - 1, self.y, 2, 2) 
	--love.graphics.rectangle("fill", self.x + self.width - 1, self.y + self.height/2, 2, 2) 
	--love.graphics.rectangle("fill", self.x - 1, self.y + self.height/2, 2, 2) 
end 