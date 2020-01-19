LevelMaker = Class{}

NONE = 1
SINGLE_PYRAMID = 2
MULTI_PYRAMID = 3

-- per-row patterns
SOLID = 1           -- all colors the same in this row
ALTERNATE = 2       -- alternate colors
SKIP = 3            -- skip every other block
NONE = 4            -- no blocks this row

function LevelMaker.createMap(level)
  local bricks = {}

  local numRows = math.random(1, 5)

  local numCols = math.random(7, 13)

  numCols = numCols % 2 == 0 and (numCols + 1) or numCols

  local highestTier = math.min(3, math.floor(level / 5))

    -- highest color of the highest tier
  local highestColor = math.min(5, level % 5 + 3)

  for y = 1, numRows do 
    local skipPattern = math.random(1, 2) == 1 and true or false

    -- whether we want to enable alternating colors for this row
    local alternatePattern = math.random(1, 2) == 1 and true or false
    
    -- choose two colors to alternate between
    local alternateColor1 = math.random(1, highestColor)
    local alternateColor2 = math.random(1, highestColor)
    local alternateTier1 = math.random(0, highestTier)
    local alternateTier2 = math.random(0, highestTier)
    
    -- used only when we want to skip a block, for skip pattern
    local skipFlag = math.random(2) == 1 and true or false

    -- used only when we want to alternate a block, for alternate pattern
    local alternateFlag = math.random(2) == 1 and true or false

    -- solid color we'll use if we're not alternating
    local solidColor = math.random(1, highestColor)
    local solidTier = math.random(0, highestTier)
    for x = 1, numCols do
      if skipPattern and skipFlag then
        -- turn skipping off for the next iteration
        skipFlag = not skipFlag

        -- Lua doesn't have a continue statement, so this is the workaround
        goto continue
      else
          -- flip the flag to true on an iteration we don't use it
          skipFlag = not skipFlag
      end
      b = Brick(
              -- x-coordinate
              (x-1)                   -- decrement x by 1 because tables are 1-indexed, coords are 0
              * 32                    -- multiply by 32, the brick width
              + 8                     -- the screen should have 8 pixels of padding; we can fit 13 cols + 16 pixels total
              + (13 - numCols) * 16,  -- left-side padding for when there are fewer than 13 columns
              
              -- y-coordinate
              y * 16                  -- just use y * 16, since we need top padding anyway
          ) 


      if alternatePattern and alternateFlag then
        b.color = alternateColor1
        b.tier = alternateTier1
        alternateFlag = not alternateFlag
      else
          b.color = alternateColor2
          b.tier = alternateTier2
          alternateFlag = not alternateFlag
      end

      -- if not alternating and we made it here, use the solid color/tier
      if not alternatePattern then
          b.color = solidColor
          b.tier = solidTier
      end 

      table.insert( bricks, b )

      ::continue::
    end
  end

  return bricks
end