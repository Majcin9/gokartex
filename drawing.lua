function pointDistance(x0, y0, x1, y1)
    return math.sqrt((x0-x1)^2 + (y0-y1)^2)
end

function circleCollision(x0, y0, x1, y1, r) -- assuming equal radius
    local dist = pointDistance(x0, y0, x1, y1)
    return  dist <= 2*r and dist > 0
end

function drawRotated(x, y, width, height, theta, image)
    local radius = math.sqrt((width * width) + (height * height))/2
    -- angle of the straight pointing from the center to the top left corner
    local alpha = math.asin(height/(2*radius))
    local newx = x - radius*math.cos(alpha + theta)
    local newy = y - radius*math.sin(alpha + theta)
    print(newx, newy)

	love.graphics.draw(image, newx, newy, theta)
end

return {
    pointDistance = pointDistance,
    circleCollision = circleCollision,
    drawRotated = drawRotated
}
