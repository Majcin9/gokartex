kart = require("Kart")
weapon = require("Weapon")
box = require("Box")
socket = require("socket")
drawing = require("drawing")
wall = require("Wall")
timer = require("Timer")

Game = {
	playersCoords = {},
	bulletCoords = {},
	mainKart = nil,
	boxes = {},
	sock = nil,
	id = 0,
	timer = nil,
}

Game.__index = Game

function Game:new()
	ggg = {}
	setmetatable(ggg, self)
	return ggg
end

function Game:load()
	self.mainKart = kart.Kart:new(100, 100)
	table.insert(self.boxes, box.Box:new(nil))
	table.insert(self.boxes, box.Box:new(nil))
	table.insert(self.boxes, box.Box:new(nil))
	table.insert(self.boxes, box.Box:new(nil))

	self.sock = socket.connect("localhost", 5000)

	self.id = tonumber(self.sock:receive("*l"))
	--local time_recieved = tonumber(self.sock:receive("*l"))
	--self.timer = Timer:new(180, tonumber(time_recieved))
	self.timer = Timer:new(180)
end

function Game:update(dt)
	-- k:update(dt)
	self.mainKart:update(dt)

	if self.sock ~= nil then
		local kartStr = "P " .. self.mainKart:getPosString()
		local bullStr = {}
		for i = 1, 3 do
			local bull = self.mainKart.bu[i]
			if bull ~= nil then
				table.insert(bullStr, "B " .. bull:getPosString())
			else
				table.insert(bullStr, "B -1 -1")
			end
		end
		local boxesStr = ""
		for id, box in ipairs(self.boxes) do
			local boxStr = box:getString()
			boxesStr = boxesStr .. ",X " .. boxStr
			print("BOX: " .. boxStr)
		end
		print("BOXES: " .. boxesStr)
		local sendStr = kartStr .. "," .. bullStr[1] .. "," .. bullStr[2] .. "," .. bullStr[3] .. boxesStr
		print("Sent: " .. sendStr)
		self.sock:send(sendStr)

		local playerRaw = self.sock:receive("*l")
		self.playersCoords = {}
		self.bulletCoords = {}
		self.boxes = {}
		while playerRaw ~= nil and playerRaw ~= "" do
			local playerInfo = {}
			for number in string.gmatch(playerRaw, "[^%s]+") do
				table.insert(playerInfo, tonumber(number))
			end
			table.insert(self.playersCoords, playerInfo)
			for i = 1, 3 do
				local bulletRaw = self.sock:receive("*l")
				local bulletInfo = {}
				for number in string.gmatch(bulletRaw, "[^%s]+") do
					table.insert(bulletInfo, tonumber(number))
				end
				table.insert(self.bulletCoords, bulletInfo)
			end
			for i = 0, 3 do
				local boxRaw = self.sock:receive("*l")
				local boxInfo = {}
				for number in string.gmatch(boxRaw, "[^%s]+") do
					table.insert(boxInfo, tonumber(number))
					--print("BoxInfo number " .. tonumber(number) .. "! " .. number)
				end
				local new_box = Box:new(boxInfo[2], boxInfo[3], boxInfo[4], boxInfo[5] / 10000)

				print("boxRaw" .. boxRaw)
				--print("newbox: " .. new_box:getString())
				table.insert(self.boxes, new_box)
			end
			playerRaw = self.sock:receive("*l")
		end
	end

	local tempbu = Bullet:new(0, 0, 0)
	for id, bullet in ipairs(self.bulletCoords) do
		if bullet[1] ~= self.id then
			if
				circleCollision(
					self.mainKart.x,
					self.mainKart.y,
					self.mainKart.image:getWidth() / 2,
					bullet[2],
					bullet[3],
					tempbu.image:getWidth() / 2
				)
			then
				print("BULLET COLLISION")
			end
		end
		for id, box in ipairs(self.boxes) do
			if
				circleCollision(
					self.mainKart.x,
					self.mainKart.y,
					self.mainKart.image:getWidth() / 2,
					box.x,
					box.y,
					box.image:getWidth() / 2
				) and box.visible
			then
				box.visible = false
				print("BOX COLLISION")
			elseif not box.visible and box.timeinv >= 3 then
				box.visible = true
			end
			box:update()
		end

		local w = wall.Wall:new(10, 10, 100, 10)
	end
end

function Game:draw()
	-- k:draw()
	local width = self.mainKart.image:getWidth()
	local height = self.mainKart.image:getHeight()
	-- drawing.drawRotated(100, 100, width, height, 0, self.mainKart.image)

	for id, player in ipairs(self.playersCoords) do
		-- love.graphics.draw(self.mainKart.image, player[2], player[3], player[4]/1000)
		drawing.drawRotated(player[2], player[3], width, height, player[4] / 1000, self.mainKart.image)
	end

	local tempbu = Bullet:new(0, 0, 0)
	local bulletWidth = tempbu.image:getWidth()

	for id, bullet in ipairs(self.bulletCoords) do
		drawing.drawRotated(bullet[2], bullet[3], bulletWidth, bulletWidth, bullet[4] / 1000, tempbu.image)
	end
	love.graphics.points(self.mainKart.x, self.mainKart.y)
	for id, bullet in ipairs(self.bulletCoords) do
		print(bullet[2], bullet[3])
		if bullet[2] ~= -1 and bullet[3] ~= -1 then
			drawing.drawRotated(bullet[2], bullet[3], bulletWidth, bulletWidth, bullet[4] / 1000, tempbu.image)
		end
	end
	love.graphics.points(self.mainKart.x, self.mainKart.y)

	love.graphics.line(10, 10, 100, 10)
	for id, box in ipairs(self.boxes) do
		box:draw()
	end
	self.timer:draw()
end

return {
	Game = Game,
}
