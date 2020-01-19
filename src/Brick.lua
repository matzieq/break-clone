
Brick = Class{}

function Brick:init(x, y)
  self.tier = 0
  self.color = 1
  
  self.x = x
  self.y = y
  self.width = 32
  self.height = 16
  

  self.inPlay = true
end

function Brick:hit()
  gSounds['brick-hit-2']:stop()
  gSounds['brick-hit-2']:play()

  -- if we're at a higher tier than the base, we need to go down a tier
  -- if we're already at the lowest color, else just go down a color
  if self.tier > 0 then
      if self.color == 1 then
          self.tier = self.tier - 1
          self.color = 5
      else
          self.color = self.color - 1
      end
  else
      -- if we're in the first tier and the base color, remove brick from play
      if self.color == 1 then
          self.inPlay = false
      else
          self.color = self.color - 1
      end
  end

  -- play a second layer sound if the brick is destroyed
  if not self.inPlay then
      gSounds['brick-hit-1']:stop()
      gSounds['brick-hit-1']:play()
  end
end

function Brick:render()
  if self.inPlay then
    love.graphics.draw(gTextures['main'], 
      -- multiply color by 4 (-1) to get our color offset, then add tier to that
      -- to draw the correct tier and color brick onto the screen
      gFrames['bricks'][1 + ((self.color - 1) * 4) + self.tier],
        self.x, self.y)
  end
end