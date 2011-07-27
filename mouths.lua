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
				name = "Closedmouth.png",
				spriteColorRect = { x = 64, y = 68, width = 152, height = 132 }, 
				textureRect = { x = 1, y = 1, width = 300, height = 300 }, 
				spriteSourceSize = { width = 300, height = 300 }, 
				spriteTrimmed = false,
				textureRotated = false
			},
		
			{
				name = "HappyMouth.png",
				spriteColorRect = { x = 81, y = 143, width = 124, height = 96 }, 
				textureRect = { x = 302, y = 1, width = 300, height = 300 }, 
				spriteSourceSize = { width = 300, height = 300 }, 
				spriteTrimmed = false,
				textureRotated = false
			},
		
			{
				name = "OpenMouth.png",
				spriteColorRect = { x = 89, y = 149, width = 108, height = 96 }, 
				textureRect = { x = 603, y = 1, width = 300, height = 300 }, 
				spriteSourceSize = { width = 300, height = 300 }, 
				spriteTrimmed = false,
				textureRotated = false
			},
		
			{
				name = "TongueMouth.png",
				spriteColorRect = { x = 88, y = 142, width = 120, height = 94 }, 
				textureRect = { x = 904, y = 1, width = 300, height = 300 }, 
				spriteSourceSize = { width = 300, height = 300 }, 
				spriteTrimmed = false,
				textureRotated = false
			},
		
			{
				name = "smileMouth.png",
				spriteColorRect = { x = 61, y = 154, width = 156, height = 58 }, 
				textureRect = { x = 1205, y = 1, width = 300, height = 300 }, 
				spriteSourceSize = { width = 300, height = 300 }, 
				spriteTrimmed = false,
				textureRotated = false
			},
		
		}
	}

	return sheet
end