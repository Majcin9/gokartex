weapons = require("Weapon")

local Kart = {
	x = 0,
	y = 0,
	velocity = 0,
	transitionSpeed = 5,
	theta = 0,
	dtheta = 15 / (2 * 3.14),
	MaxVelocity = 10,
	imagepath = "assets/gokart3.png",
	image = nil,
    weapon = nil
}

Kart.__index = Kart

function Kart:new(x, y, velocity, transitionSpeed, theta, dtheta, MaxVelocity, imagepath)
	o = {}
	setmetatable(o, self)
	o.x = x or 0
	o.y = y or 0
	o.velocity = velocity or 0
	o.transitionSpeed = transitionSpeed or 5
	o.theta = theta or 0
	o.dtheta = dtheta or (15 / (2 * 3.14))
	o.MaxVelocity = MaxVelocity or 10
    o.weapon = weapons.Weapon:new()
	o.image = love.graphics.newImage(imagepath or "assets/gokart3.png")
	return o
end

function Kart:update(dt)
	if love.keyboard.isDown("left") then
		self.theta = self.theta - self.dtheta * dt
        if self.theta < 0 then
            self.theta = 2 * 3.14
        end
	end
	if love.keyboard.isDown("right") then
		self.theta = self.theta + self.dtheta * dt
        if self.theta > 2*3.14 then
            self.theta = 0
        end
	end

	if love.keyboard.isDown("up") then
		if self.velocity < 0 then
			self.velocity = self.velocity + 3 * self.transitionSpeed * dt
		else
			self.velocity = self.velocity + self.transitionSpeed * dt
		end
	elseif love.keyboard.isDown("down") then
		if self.velocity > 0 then
			self.velocity = self.velocity - 3 * self.transitionSpeed * dt
		else
			self.velocity = self.velocity - self.transitionSpeed * dt
		end
	else
		if self.velocity < 0 then
			self.velocity = self.velocity + 2 * self.transitionSpeed * dt
		elseif self.velocity > 0 then
			self.velocity = self.velocity - 2 * self.transitionSpeed * dt
		end
	end

    if love.keyboard.isDown("space") then
        
    end

	if self.velocity > 0 then
		self.velocity = math.min(self.velocity, self.MaxVelocity)
	elseif self.velocity < 0 then
		self.velocity = math.max(self.velocity, -self.MaxVelocity)
	end
	self.x = self.x + self.velocity * math.cos(self.theta)
	self.y = self.y + self.velocity * math.sin(self.theta)
    if bu ~= nil then
        bu:update()
    end
end


function Kart:shoot() 
    print("x " .. self.x .. "y " .. self.y)
    
    bu = self.weapon:fire(self.x, self.y, self.theta)
end

function Kart:draw()
    local width = self.image:getWidth()
    local height = self.image:getHeight()
    local radius = math.sqrt((width * width) + (height * height))/2
    local newx = self.x + radius*math.cos((5*3.14/4) + self.theta)
    local newy = self.y + radius*math.sin((5*3.14/4) + self.theta)

	love.graphics.draw(self.image, newx, newy, self.theta)
    if bu ~= nil then
        bu:draw(self.theta)
    end
end

function Kart:getPosString()
    return self.x .. " " .. self.y .. " " .. tonumber(self.theta*1000)
end

function ellipseCollision(major, minor, theta, xcenter, ycenter, x, y)
    -- uses formula for ellipse [ (x^2)/(major^2) + (y^2)/(minor^2) = 1]
    -- where if you change the = to a <=, you get all points inside and
    -- on the border of the ellipse
    -- it also applies rotation by replacing x with x*cos(theta) - y*sin(theta)
    -- and y with x*sin(theta) + y*cos(theta)
    -- finally, it translates the entire ellipse for its center to be in
    -- (centerx, centery).
    return (((x-xcenter)*math.cos(theta) - (y-ycenter)*math.sin(theta)) ^ 2)/(major^2) +
           (((x-xcenter)*math.sin(theta) + (y-ycenter)*math.cos(theta)) ^ 2)/(minor^2) <= 1
end

function Kart:isCollidingPoint(x, y)
    local width = self.image:getWidth()
    local height = self.image:getHeight()
    local major = width/2
    local minor = height/2
    return ellipseCollision(major, minor, self.theta, self.x, self.y, x, y)
end

return {
    Kart = Kart
}
