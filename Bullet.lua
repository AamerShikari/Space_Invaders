--[[
	Bullet Class 

	Author: Aamer Shikari 
	shikaraamer@gmail.com

	The Bullet Class is a unit is a unit that exists for both Players and Aliens. 
	Bullets are objects that determine their own collision with units.
]]

Bullet = Class{}

function Bullet:init() 
	self.x = VIRTUAL_WIDTH/2 
	self.y = VIRTUAL_HEIGHT + 30
	self.width = 1
	self.height = 3
	self.dy = 0
	self.can = true
end 

function Bullet:collides(entity)
    -- first, check to see if the left edge of either is farther to the right
    -- than the right edge of the other
    if self.x > entity.x + entity.width or entity.x > self.x + self.width then
        return false
    end

    -- then check to see if the bottom edge of either is higher than the top
    -- edge of the other
    if self.y + self.height < entity.y or entity.y + entity.height < self.y then
        return false
    end 

    -- if the above aren't true, they're overlapping
    return true
end

function Bullet:hit() 
	self.y = -10
end


function Bullet:update(dt) 
	if self.dy > 0 then 
		if self.y > VIRTUAL_HEIGHT + 3 then 
			self.dy = 0
			self.can = true
		end
	elseif self.dy < 0 then 
		if self.y < -3 then 
			self.dy = 0
			self.can = true
		end 
	end
	self.y = self.y + self.dy * dt
end 

function Bullet:render() 
	love.graphics.setColor(255, 255, 255)
	love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end 
