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
	walls = {},
	id = 0,
	guiHeight = 100,
	text = nil,
	mapWidth = 1200,
	mapHeight = 900,
	timer = nil,
	score = 0,
}

Game.__index = Game

function Game:new()
	ggg = {}
	setmetatable(ggg, self)
	return ggg
end

function Game:load()
	love.window.setMode(self.mapWidth, self.mapHeight)

	table.insert(self.boxes, box.Box:new(nil))
	table.insert(self.boxes, box.Box:new(nil))
	table.insert(self.boxes, box.Box:new(nil))
	table.insert(self.boxes, box.Box:new(nil))
	--self.timer = Timer:new(180)

	table.insert(self.walls, wall.Wall:new(0, self.guiHeight, self.mapWidth, self.guiHeight))
	table.insert(self.walls, wall.Wall:new(0, self.guiHeight, 0, self.mapHeight))
	table.insert(self.walls, wall.Wall:new(self.mapWidth, self.guiHeight, self.mapWidth, self.mapHeight))
	table.insert(self.walls, wall.Wall:new(0, self.mapHeight, self.mapWidth, self.mapHeight))
	table.insert(self.walls, wall.Wall:new(self.mapWidth / 2, self.guiHeight + 150, self.mapWidth / 2, 450))
	table.insert(
		self.walls,
		wall.Wall:new(self.mapWidth / 3, self.mapHeight * 2 / 3, self.mapWidth / 3, self.mapHeight * 2 / 3 + 150)
	)
	table.insert(
		self.walls,
		wall.Wall:new(
			self.mapWidth * 2 / 3,
			self.mapHeight * 2 / 3,
			self.mapWidth * 2 / 3,
			self.mapHeight * 2 / 3 + 150
		)
	)

	self.sock = socket.connect("localhost", 5000)
	self.id = tonumber(self.sock:receive("*l"))

	self.mainKart = kart.Kart:new(100, 200, self.id)

	local time_recieved = tonumber(self.sock:receive("*l"))
	self.timer = Timer:new(10, time_recieved)
	love.graphics.setFont(love.graphics.newFont(50))

	local font = love.graphics.getFont()
	self.text = love.graphics.newText(font)
end

function Game:update(dt)
	-- k:update(dt)
	local hitby = self.mainKart:update(dt, self.walls, self.bulletCoords)
	-- print("hitby", hitby)

	local playerInfos = {}
	if self.sock ~= nil then
		local kartStr = "P " .. self.mainKart:getPosString()
		local bullStr = {}
		for i = 1, 3 do
			local bull = self.mainKart.bu[i]
			table.insert(bullStr, "B " .. bull:getPosString())
		end
		local boxesStr = ""
		for id, box in ipairs(self.boxes) do
			local boxStr = box:getString()
			boxesStr = boxesStr .. ",X " .. boxStr
			-- print("BOX: " .. boxStr)
		end
		-- print("BOXES: " .. boxesStr)
		local sendStr = kartStr
			.. ","
			.. bullStr[1]
			.. ","
			.. bullStr[2]
			.. ","
			.. bullStr[3]
			.. boxesStr
			.. ","
			.. hitby
		-- print("Sent: " .. sendStr)
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

			if playerInfo[1] == self.id and playerInfo[5] ~= self.score then
				self.score = playerInfo[5]
				print("HIT SOMEONE")
			end

			for i = 1, 3 do
				local bulletRaw = self.sock:receive("*l")
				-- print(bulletRaw)
				local bulletInfo = {}
				for number in string.gmatch(bulletRaw, "[^%s]+") do
					table.insert(bulletInfo, tonumber(number))
				end
				table.insert(self.bulletCoords, bulletInfo)
			end
			table.insert(playerInfos, playerInfo)
			playerRaw = self.sock:receive("*l")
		end
		for i = 0, 3 do
			local boxRaw = self.sock:receive("*l")
			local boxInfo = {}
			for number in string.gmatch(boxRaw, "[^%s]+") do
				table.insert(boxInfo, tonumber(number))
				--print("BoxInfo number " .. tonumber(number) .. "! " .. number)
			end
			-- print(boxInfo[5])
			local new_box = Box:new(boxInfo[2], boxInfo[3], boxInfo[4], boxInfo[5] / 10000)

			--print("newbox: " .. new_box:getString())
			table.insert(self.boxes, new_box)
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
				if self.mainKart.weapon == nil then
					box.visible = false
					self.mainKart.weapon = box:getWeapon()
				end
				print("BOX COLLISION")
			elseif not box.visible and box.timeinv >= 3 then
				box.visible = true
			end
			box:update()
		end

		love.graphics.setFont(love.graphics.newFont(50))

		font = love.graphics.getFont()
		text = love.graphics.newText(font)
	end
	if self.timer:update() == 1 then
		local text = ""
		for index, playerInfo in ipairs(self.playersCoords) do
			text = text .. playerInfo[1] .. ": " .. playerInfo[5] .. "\n"
		end
		print(text)
		love.graphics.print(text, 40, 40, 0, 1, 1)
		while true do
		end
	end
end

function Game:draw()
	-- k:draw()
	local bullets = 0
	if self.mainKart.weapon ~= nil then
		bullets = self.mainKart.weapon.bullets
	end
	self.text:set("Bullets: " .. bullets .. " Score: " .. self.score .. " Timer: " .. self.timer:getString())
	love.graphics.draw(self.text, 10, 10)
	local width = self.mainKart.image:getWidth()
	local height = self.mainKart.image:getHeight()
	-- drawing.drawRotated(100, 100, width, height, 0, self.mainKart.image)

	for id, player in ipairs(self.playersCoords) do
		-- love.graphics.draw(self.mainKart.image, player[2], player[3], player[4]/1000)
		drawing.drawRotated(player[2], player[3], width, height, player[4] / 1000, self.mainKart.image)
	end

	local tempbu = Bullet:new(0, 0, 0)
	local bulletWidth = tempbu.image:getWidth()
	love.graphics.points(self.mainKart.x, self.mainKart.y)
	for id, bullet in ipairs(self.bulletCoords) do
		-- print(bullet[1], bullet[2], bullet[3], bullet[4]/1000)
		if bullet[2] ~= -1 and bullet[3] ~= -1 then
			drawing.drawRotated(bullet[2], bullet[3], bulletWidth, bulletWidth, bullet[4] / 1000, tempbu.image)
		end
	end
	love.graphics.points(self.mainKart.x, self.mainKart.y)

	for i, wall in ipairs(self.walls) do
		wall:draw()
	end

	for id, box in ipairs(self.boxes) do
		box:draw()
	end
	--self.timer:draw()
end

return {
	Game = Game,
}
