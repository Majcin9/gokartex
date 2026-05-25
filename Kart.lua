Kart = {
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
function Kart:new(o, x, y, velocity, transitionSpeed, theta, dtheta, MaxVelocity, imagepath)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	self.x = x or 0
	self.y = y or 0
	self.velocity = velocity or 0
	self.transitionSpeed = transitionSpeed or 5
	self.theta = theta or 0
	self.dtheta = dtheta or (15 / (2 * 3.14))
	self.MaxVelocity = MaxVelocity or 10
	self.image = love.graphics.newImage(imagepath or "assets/gokart3.png")
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
	if self.velocity > 0 then
		self.velocity = math.min(self.velocity, self.MaxVelocity)
	elseif self.velocity < 0 then
		self.velocity = math.max(self.velocity, -self.MaxVelocity)
	end
	self.x = self.x + self.velocity * math.cos(self.theta)
	self.y = self.y + self.velocity * math.sin(self.theta)
end

function Kart:draw()
	love.graphics.draw(self.image, self.x, self.y, self.theta)
end

return {
	Kart = Kart,
}
