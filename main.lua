function love.load()
   hightScore = 0
   
   if love.filesystem.exists('img/hss.snipe') then
     hightScore = love.filesystem.read('img/hss.snipe')
   end

   combo = 0
   isFinish = false
   bonusTime = 0
   prevTime = love.timer.getTime(); 
   timer = 0
	 score = 0
   delay = 1
   lives = 3
   level = 5000
   shots = { }
   gameOver = love.graphics.newImage("img/gameover.png")
   heartImg = love.graphics.newImage("img/heart.png")  
   bgImg = love.graphics.newImage("img/background.png")
   violetBall = love.graphics.newImage("img/ball1.png")
   blueBall = love.graphics.newImage("img/ball2.png")
   yellowBall = love.graphics.newImage("img/ball3.png")
   bombImg = love.graphics.newImage("img/bomb.png")
   shotImg1 = love.graphics.newImage("img/shot1.png")
   shotImg2 = love.graphics.newImage("img/shot2.png")
   shotImg3 = love.graphics.newImage("img/shot3.png")
   plus1 = love.graphics.newImage("img/+1.png")
   plus2 = love.graphics.newImage("img/+2.png")
   plus3 = love.graphics.newImage("img/+3.png")
   plus5 = love.graphics.newImage("img/+5.png")
   boom = love.graphics.newImage("img/boom.png")
   shot = {shotImg1, shotImg2, shotImg3}
   ballsType = {violetBall, blueBall, yellowBall}
   width = love.graphics.getWidth()
   height = love.graphics.getHeight()
   cursor = love.mouse.newCursor("img/sight.png", 0, 0)
   love.mouse.setCursor(cursor)
   balls = { }
   bombs = { }
   popups = { }
end

function love.keypressed(key)
   if isFinish == true then
      bombs = { }
      balls = { }
      lives = 3
      score = 0
      combo = 0
      timer = 0
      isFinish = false
      prevTime = love.timer.getTime(); 
      delay = 1
      level = 5000
      bonusTime = 0
   end
end

function love.mousereleased(x, y, button)
   x = x + 10
   y = y + 10
   tx = x
   ty = y
   if button == 'l' then
        fl = false
      	for i = 1, #balls, 1 do
          if i <= #balls then
      		  distance = math.sqrt(math.pow(x-balls[i].x, 2) + math.pow(y-balls[i].y, 2))
      		  if distance <= 39 then
              fl = true
              combo = combo + 1
      			  if balls[i].img == violetBall then
              score = score + 1
              popup = {
                x = tx + 25;
                y = ty - 10;
                img = plus1;
                cnt = 0;
              }
              table.insert(popups, popup)
              elseif balls[i].img == blueBall then
                score = score + 2
                popup = {
                  x = tx + 25;
                  y = ty - 10;
                  img = plus2;
                  cnt = 0;
                }
                table.insert(popups, popup)
              else
                score = score + 3
                popup = {
                  x = tx + 20;
                  y = ty - 10;
                  img = plus3;
                  cnt = 0;
                }
              table.insert(popups, popup)
            end
            table.remove(balls, i)
      		 end
      		end
      	end
        for i = 1, #bombs, 1 do
          if i <= #bombs then
            distance = math.sqrt(math.pow(x-bombs[i].x, 2) + math.pow(y-bombs[i].y, 2))
            if distance <= 35 then
              lives = lives - 1
              popup = {
                  x = tx;
                  y = ty;
                  img = boom;
                  cnt = 0;
              }
              table.insert(popups, popup)
              table.remove(bombs, i)
            end
          end
        end

        shotItem = {
          x = tx;
          y = ty;
          img = shot[math.random(3)];
          cnt = 0;
        }

        if fl == false then
          combo = 0
          table.insert(shots, shotItem)
        end
        
   end
   if combo >= 5 and combo % 5 == 0 then
      bonusTime = bonusTime + 2
      popup = {
                  x = width / 2 + 45;
                  y = 12;
                  img = plus5;
                  cnt = 0;
      }
      table.insert(popups, popup)
   end
end

function finish()
   hightScore = math.max(hightScore, score)
   love.filesystem.write("img/hss.snipe", hightScore)
   isFinish = true
end

function love.update(dt)
  if delay % 2 == 0 then

    if timer >= 31 or lives == 0 then
      finish()
    end
    timer = math.ceil(love.timer.getTime() - prevTime)
    if bonusTime >= 2 then
      timer = timer - bonusTime
    end
	
    for i = 1, #shots do
      shots[i].cnt = shots[i].cnt + 1
    end

    for i = 1, #popups do
      popups[i].cnt = popups[i].cnt + 1
    end

	  if delay > 150 and delay % 150 == 0 then
      bomb = {
        x = math.random(width);
        y = -20;
        img = bombImg;
      }
      if bomb.x >= width - 50 then
        bomb.x = width - 70
      end
      table.insert(bombs, bomb)
    end

    for i = 1, #bombs do
      if i <= #bombs then
        bombs[i].y = bombs[i].y + delay/110;
        if bombs[i].y >= height then
          table.remove(bombs, i)
        end
      end
    end

	 if delay % level == 0 then 
    newBall = {
		  x = math.random(width);
		  y = -25;
		  img = ballsType[math.random(3)];
		  speed = 1;
	  }
    if newBall.x >= width - 50 then
        newBall.x = width - 70
      end
	  table.insert(balls, newBall)
   end

   wind = 0.5

   
	 for i = 1, #balls do 
    if i <= #balls then
      
      balls[i].y = balls[i].y + delay/120
      balls[i].x = balls[i].x + wind

      qk = math.random(2)
      if qk == 2 then
        qk = -1
      end

      balls[i].x = balls[i].x + qk
      
      if balls[i].y >= height then
        table.remove(balls, i)
      end
    end
	 end
  end
  delay = delay + 1
  level = level - 100
  if level <= 30 then
    level = 30;
  end
end

function love.draw()

    love.graphics.draw(bgImg, 0, 0)

    if isFinish == true then
      
      love.graphics.draw(gameOver, 265, 30)
      love.graphics.setColor(186, 85, 211 )
      love.graphics.setNewFont(30)
      love.graphics.print("Your score: ", 315, 220)
      love.graphics.print(score, 490, 220)
      love.graphics.print("Hight score: ", 295, 262)
      love.graphics.print(hightScore, 480, 262)
      love.graphics.setColor(224, 225, 225)
      
    else
      
      love.graphics.setColor(127, 255, 0)
      love.graphics.print('x', 10, height - 40)
      love.graphics.print(combo, 35, height - 40)

      love.graphics.setColor(255, 255, 255)

      for i = 1, #balls do      
        love.graphics.draw(balls[i].img, balls[i].x, balls[i].y)
      end
    
      for i = 1, #bombs do
        love.graphics.draw(bombs[i].img, bombs[i].x, bombs[i].y)      
      end

      love.graphics.setNewFont(22);
      love.graphics.print("Score: ", 670, 5)
      love.graphics.print(score, 750, 5)
      for i = 1, lives do
    	 love.graphics.draw(heartImg, i*35 - 25, 5)
      end
      for i = 1, #shots do
        if i <= #shots then
         if shots[i].cnt <= 30 then
            love.graphics.draw(shots[i].img, shots[i].x, shots[i].y)
          else 
            table.remove(shots, i)
          end
        end
      end

      for i = 1, #popups do
        if i <= #popups then
          if popups[i].cnt <= 20 then
          love.graphics.draw(popups[i].img, popups[i].x, popups[i].y)
          else 
            table.remove(popups, i)
          end
        end
      end
      love.graphics.setNewFont(40)
      love.graphics.print(31 - timer, width/2, 10)
      --love.graphics.print(hightScore, width/2, 60)
    end
end
