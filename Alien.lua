--[[
	Alien Class 

	Author: Aamer Shikari 
	shikaraamer@gmail.com

	Class that creates aliens objects that have movements corresponding to 
	the level and immediacy (number of current enemy population) 
]]

Alien = Class{}

function Alien:init(x, y, row, col)
	self.image1 = love.graphics.newImage('alien12.png')
	self.image2 = love.graphics.newImage('alien23.png')
	self.current_image = self.image1
	self.check = 0
	self.width = self.image1:getWidth() 
	self.height = self.image1:getHeight()
	self.dx = 1
	self.dy = 1

	self.start_x = x
	self.start_y = y
	self.row = row 
	self.col = col
	self.x = x
	self.y = y
	self.alive = true
	self.swap = 0
end 

function Alien:update_x(dt) 
	-- Hoard left to right alg 
	-- check if hits wall 
	self.x = self.x + self.dx
end

function Alien:update_y(dt)
	self.y = self.y + self.dy
end

function Alien:swap_image()
	if (self.current_image == self.image1) then 
		self.current_image = self.image2
	else 
		self.current_image = self.image1
	end
end

function Alien:rotate() 
	if self.dx < 0 then 
		if math.max(0, self.x + self.dx * dt) == 0 then 
			return true
		end
	else 
		if math.min(VIRTUAL_WIDTH - self.width, self.x + self.dx * dt) == VIRTUAL_WIDTH - self.width then
			return true
		end 
	end 
	return false
end

function Alien:reset() 
	self.x = self.start_x
	self.y = self.start_y
end 

function Alien:render() 
	if (self.alive) then
		love.graphics.draw(self.current_image, self.x, self.y)
	end
	--love.graphics.rectangle("fill", self.x - 1, self.y, 2, 2) 
	--love.graphics.rectangle("fill", self.x+ self.width - 1, self.y, 2, 2) 
	--love.graphics.rectangle("fill", self.x + self.width - 1, self.y + self.height/2, 2, 2) 
	--love.graphics.rectangle("fill", self.x - 1, self.y + self.height/2, 2, 2) 
end 
