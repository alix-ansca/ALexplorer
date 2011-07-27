module(...)


-- This file is for use with Corona Game Edition
--
-- The function getSpriteSheetData() returns a table suitable for importing using sprite.newSpriteSheetFromData()
--
-- Usage example:
--			local zwoptexData = require "ThisFile.lua"
-- 			local data = zwoptexData.getSpriteSheetData()
--			local spriteSheet = sprite.newSpriteSheetFromData( "Untitled.png", data )
--
-- For more details, see http://developer.anscamobile.com/content/game-edition-sprite-sheets

function getSpriteSheetData()

	local sheet = {
		frames = {
		
			{
				name = "blinkEyes.png",
				spriteColorRect = { x = 70, y = 69, width = 140, height = 90 }, 
				textureRect = { x = 302, y = 1, width = 300, height = 300 }, 
				spriteSourceSize = { width = 300, height = 300 }, 
				spriteTrimmed = false,
				textureRotated = false
			},
		
			{
				name = "happyEyes.png",
				spriteColorRect = { x = 73, y = 75, width = 140, height = 72 }, 
				textureRect = { x = 603, y = 1, width = 300, height = 300 }, 
				spriteSourceSize = { width = 300, height = 300 }, 
				spriteTrimmed = false,
				textureRotated = false
			},
		
			{
				name = "normalEyes.png",
				spriteColorRect = { x = 82, y = 68, width = 116, height = 90 }, 
				textureRect = { x = 904, y = 1, width = 300, height = 300 }, 
				spriteSourceSize = { width = 300, height = 300 }, 
				spriteTrimmed = false,
				textureRotated = false
			},
		
			{
				name = "upEyes.png",
				spriteColorRect = { x = 86, y = 77, width = 112, height = 62 }, 
				textureRect = { x = 0, y = 0, width = 300, height = 300 }, 
				spriteSourceSize = { width = 300, height = 300 }, 
				spriteTrimmed = false,
				textureRotated = false
			},
		
		}
	}

	return sheet
end