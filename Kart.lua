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
	o.image = love.graphics.newImage(imagepath or "assets/gokart3.png")
	return o
end

function Kart:update(dt)
	if love.keyboard.isDown("left") then
		self.theta = self.theta - self.dtheta * dt
	end
	if love.keyboard.isDown("right") then
		self.theta = self.theta + self.dtheta * dt
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
end

function Kart:shoot() 
    print("x " .. self.x .. "y " .. self.y)
    
    -- self.weapon:fire()
end

function Kart:draw()
	love.graphics.draw(self.image, self.x, self.y, self.theta)
end

return {
    Kart = Kart
}
