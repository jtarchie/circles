local circles = {}
local maxCircles = 10

local function createDirection()
	local direction = math.random()
	if direction < 0.5 then
		return -1
	end
	return 1
end

local Circle = {}
Circle.__index = Circle

function Circle.new(x, y)
	return setmetatable({
		x = x,
		y = y,
		radius = math.random(50),
		dx = createDirection() * (10 + math.random(1, 25)),
		dy = createDirection() * (10 + math.random(1, 25)),
		color = { math.random(255), math.random(255), math.random(255) },
	}, Circle)
end

function Circle:update(dt)
	self.x = self.x + (dt * self.dx)
	self.y = self.y + (dt * self.dy)
end

local function checkCollision(x1, y1, w1, h1, x2, y2, w2, h2)
	return x1 < x2 + w2 and x2 < x1 + w1 and y1 < y2 + h2 and y2 < y1 + h1
end

function love.load()
	for _ = 1, maxCircles do
		table.insert(
			circles,
			Circle.new(math.random(0, love.graphics.getWidth()), math.random(0, love.graphics.getHeight()))
		)
	end
end

function love.update(dt)
	local x, y = love.mouse.getPosition()

	for i, circle in ipairs(circles) do
		if
			(circle.x - circle.radius) > love.graphics.getWidth()
			or (circle.x + circle.radius) < 0
			or (circle.y - circle.radius) > love.graphics.getHeight()
			or (circle.y + circle.radius) < 0
			or checkCollision(circle.x, circle.y, circle.radius, circle.radius, x, y, 25, 25)
		then
			table.remove(circles, i)
			circle = Circle.new(math.random(0, love.graphics.getWidth()), math.random(0, love.graphics.getHeight()))
			table.insert(circles, circle)
		else
			circle:update(dt)
		end
	end
end

function love.draw()
	for _, circle in ipairs(circles) do
		love.graphics.setColor(love.math.colorFromBytes(circle.color))
		love.graphics.circle("fill", circle.x, circle.y, circle.radius, 200)
	end

	local x, y = love.mouse.getPosition()
	love.graphics.setColor(love.math.colorFromBytes(100, 100, 100))
	love.graphics.circle("fill", x, y, 25, 200)
end
