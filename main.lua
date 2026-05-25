x, y = 400, 300
velocity = 0
transitionSpeed = 5
theta = 0
dtheta = 10 / (2 * 3.14)

function love.load()
	love.window.setFullscreen(true, "desktop")
	image = love.graphics.newImage("assets/gokart3.png")
end

function love.update(dt)
	if love.keyboard.isDown("left") then
		theta = theta - dtheta * dt
	end
	if love.keyboard.isDown("right") then
		theta = theta + dtheta * dt
	end
	if love.keyboard.isDown("up") then
		velocity = velocity + transitionSpeed * dt
		-- y = y - 100 * dt
	else
		if love.keyboard.isDown("down") then
			velocity = velocity - transitionSpeed * dt
			-- y = y + 100 * dt
		else
			velocity = velocity - transitionSpeed * dt
			if velocity < 0 then
				velocity = 0
			end
		end
	end
	x = x + velocity * math.cos(theta)
	y = y + velocity * math.sin(theta)
end

function love.draw()
	love.graphics.draw(image, x, y, theta)
end
