-- 
-- Abstract: ALexplorer - OpenAL sample project 
-- Exercises some of Corona's "secret" OpenAL features.
-- 
-- Version: 0.1
-- 
-- Sample code is MIT licensed, see http://developer.anscamobile.com/code/license
-- Copyright (C) 2010 ANSCA Inc. All Rights Reserved.

require 'sprite'
local widget = require "widget"
local easingx  = require("easingx")

local spriteGroup = display.newGroup()

--------------------------------------------------------------------------------
-- Sprite sequence setup:  mouths
--------------------------------------------------------------------------------
local mouthLoader = require "mouths"
local mouthData = mouthLoader.getSpriteSheetData()
local mouthSheet = sprite.newSpriteSheetFromData( "mouths.png", mouthData )
local spriteSetHello = sprite.newSpriteMultiSet( 
   {
      { sheet = mouthSheet, 
      frames = {
                1, --closed
                5, --listening (smile)      
                1, 1, 3, 3, 3, 1, 1, 1, 2, 2, 2, 1, 1, 2, 2, 2, 2, 3, 3, 3, 1, 1
      }        },   
   }
)
sprite.add (spriteSetHello, "default", 1, 1, 100, 1)
sprite.add (spriteSetHello, "listening", 2, 1, 100, 1)
sprite.add (spriteSetHello, "talking", 3, spriteSetHello.frameCount - 3, 100, 0)
local sprite1 = sprite.newSprite( spriteSetHello )
sprite1.x = display.contentCenterX
sprite1.y = 100

function sprite1:wait ()
print ("WAIT")
    if sprite1.sequence ~= "default" then
        sprite1:pause ()
        sprite1:prepare("default")
        sprite1:play ()
    end
end
function sprite1:listen ()
print ("LISTEN")
    if sprite1.sequence ~= "listening" then
        sprite1:pause ()
        sprite1:prepare("listening")
        sprite1:play ()
    end
end
function sprite1:talk ()
print ("TALK")
    sprite1:pause ()
    sprite1:prepare("talking")
    sprite1:play ()
end

sprite1:wait()


--------------------------------------------------------------------------------
-- Sprite sequence setup:  eyes
--------------------------------------------------------------------------------

local eyeLoader = require "eyes"
local eyeData = eyeLoader.getSpriteSheetData()
local eyeSheet = sprite.newSpriteSheetFromData( "eyes.png", eyeData )
local spriteSetEyes = sprite.newSpriteMultiSet( 
   {
      { sheet = eyeSheet, frames = {
              3, -- default
              2, -- happy
              4, -- up
              3, 1, 1, 3-- blink
      }                            },   
   }
)
sprite.add (spriteSetEyes, "default", 1, 1, 100, 1)
sprite.add (spriteSetEyes, "happy", 2, 1, 100, 1)
sprite.add (spriteSetEyes, "up", 3, 1, 400, 0)
sprite.add (spriteSetEyes, "blink", 4, 4, 200, 1)

local spriteEyes = sprite.newSprite( spriteSetEyes )
spriteEyes.x = display.contentWidth / 2
spriteEyes.y = sprite1.y 
print (spriteEyes.y)

function spriteEyes:wait ()
    if spriteEyes.sequence ~= "default" then
        spriteEyes:prepare("default")
        spriteEyes:play ()
    end
end
function spriteEyes:listen ()
    if spriteEyes.sequence ~= "up" then
        spriteEyes:prepare("up")
        spriteEyes:play ()
    end
end
function spriteEyes:talk ()
    spriteEyes:prepare("happy")  
    spriteEyes:play ()
end
function spriteEyes:blink ()
    spriteEyes:prepare("blink")
    spriteEyes:play ()
end
function spriteEyes:timer ( event)
    spriteEyes:blink ()
end
spriteEyes:blink()
--spriteEyes:talk()
timer.performWithDelay( 5000, spriteEyes, 0 ) -- blink

spriteGroup:insert (sprite1)
spriteGroup:insert (spriteEyes)
spriteGroup.y = 0
spriteGroup.xScale = 2
spriteGroup.yScale = 0.1

--------------------------------------------------------------------------------
-- Audio recording setup
--------------------------------------------------------------------------------
local dataFileName = "testfile"
if "simulator" == system.getInfo("environment") then
    dataFileName = dataFileName .. ".aif"
else
	local platformName = system.getInfo( "platformName" )
    if "iPhone OS" == platformName then
        dataFileName = dataFileName .. ".aif"
    elseif "Android" == platformName then
        dataFileName = dataFileName .. ".pcm"
    else
    	print("Unknown OS " .. platformName )
    end
end
print (dataFileName)

local r, rmonitor             -- media object for audio recording
local recButton, playButton   -- gui buttons
local ch, src                 -- openAL audio channel and source
local fSoundPlaying = false   -- sound playback state
local pitch					  -- the pitch shift
local sourcePos = {x = 0, y = 5, z = 0}  -- audio source coordinates
local listenerPos = {x = 0, y = 0, z = 0} -- audio listener coordinates

-- Update the state dependent button label
local function updateRecordingLabel ()
    if r then
        local fRecording = r:isRecording ()
        if fRecording then 
            recButton.label = "[] stop recording"
        elseif fSoundPlaying then
            recButton.label = "-playing-"
        else
            recButton.label = "|| record"
        end
    end
end

local function onCompleteSound (event)
print ("END PLAYBACK")
    fSoundPlaying = false    
    updateRecordingLabel ()	
    sprite1:wait()
    spriteEyes:wait()
    playButton.y = recButton.y  -- make the play button visible if hidden
end
 
local function recButtonPress ( event )
    if rmonitor then
        rmonitor:stopRecording()
    end
    if not r then
        local filePath = system.pathForFile( dataFileName, system.DocumentsDirectory )
        r = media.newRecording( filePath )
    end
    if r:isRecording () then
        r:stopRecording()
        local filePath = system.pathForFile( dataFileName, system.DocumentsDirectory )
        -- Play back the recording
        local file = io.open( filePath, "r" )
        if file then
            io.close( file )
            fSoundPlaying = true
            playbackSoundHandle = audio.loadStream( dataFileName, system.DocumentsDirectory )
            ch, src = audio.play(playbackSoundHandle, { onComplete=onCompleteSound })
            al.Source( src, al.PITCH, pitch )
            al.Source( src, al.POSITION, sourcePos.x, sourcePos.y, sourcePos.z )  
            al.Listener( al.POSITION, listenerPos.x, listenerPos.y, listenerPos.z )  
            sprite1:talk()
            spriteEyes:talk()
        end                
    else
        fSoundPlaying = false
        r:startRecording()
        sprite1:listen()
        spriteEyes:listen()
    end
    updateRecordingLabel ()
end

recButton = widget.newButton{
	buttonTheme = "red",
	onPress = recButtonPress,
	label = "|| record",
	emboss = true,
	size = 22
}
recButton.x = display.contentWidth * 0.1	   
recButton.y = display.contentHeight - recButton.height*1.5

--------------------------------------------------------------------------------
-- Play button setup
--------------------------------------------------------------------------------
local function updatePlayLabel ()
    if fSoundPlaying then
        playButton.label = "-playing-"
    else
        playButton.label = "> play"
    end
end

local function onCompletePlay (event)
print ("END PLAYBACK")
    fSoundPlaying = false    
    updatePlayLabel ()	
    sprite1:wait()
    spriteEyes:wait()
end
 

local function playButtonPress ( event )
print ("PLAY")
    if r and not r:isRecording () and not fSoundPlaying then
		local filePath = system.pathForFile( dataFileName, system.DocumentsDirectory )
		-- Play back the recording
		local file = io.open( filePath, "r" )
		if file then
			io.close( file )
			ch, src = audio.play(playbackSoundHandle, { onComplete=onCompletePlay })
			print ("audio.play")
			al.Source( src, al.PITCH, pitch )
			al.Source( src, al.POSITION, sourcePos.x, sourcePos.y, sourcePos.z )  
			print ("al.Source")
			al.Listener( al.POSITION, listenerPos.x, listenerPos.y, listenerPos.z )  
			sprite1:talk()
			spriteEyes:talk()
		end
	end
end

playButton = widget.newButton{
	buttonTheme = "blue",
	onPress = playButtonPress,
	label = "> play",
	emboss = true,
	size = 20
}
playButton.x = display.contentWidth*0.9 - playButton.width
playButton.y = -recButton.y  -- make it initially hidden

--------------------------------------------------------------------------------
-- Setup sliders for the audio parameters
--------------------------------------------------------------------------------

local pText = widget.newEmbossedText( "" ,display.contentWidth*0.1 , display.contentHeight - recButton.height*3, "HelveticaNeue-Bold", 14, { 255, 255, 255 } )
pText:setText( "Pitch: " .. 1.5 .. "x" )


local pitchSliderCallback = function( event )
	-- makes it so that the middle has pitch = 1, while the ends are 0.5 and 2
	pitch = 2^((event.target.value - 50)/50 )
	pText:setText( "Pitch: " .. math.floor(pitch*100)/100 .. "x", {255,255,255} )
    if fSoundPlaying and src then
        al.Source( src, al.PITCH, pitch )
    end
end

-- To change the default pitch, change the default slider value
local pSlider = widget.newSlider{ value = 75, callback = pitchSliderCallback, width=display.contentWidth*0.8 }
pSlider.x = display.contentCenterX
pSlider.y = recButton.y - recButton.height*2

pitch = 2 ^ ( (pSlider.value - 50) / 50 )

local xText = widget.newEmbossedText( "" ,display.contentWidth*0.1 , display.contentHeight - recButton.height*9, "HelveticaNeue-Bold", 14, { 255, 255, 255 } )
xText:setText( "X: " .. sourcePos.x )
local yText = widget.newEmbossedText( "" ,display.contentWidth*0.1 , display.contentHeight - recButton.height*7, "HelveticaNeue-Bold", 14, { 255, 255, 255 } )
yText:setText( "Y: " .. sourcePos.y )
local zText = widget.newEmbossedText( "" ,display.contentWidth*0.1 , display.contentHeight - recButton.height*5, "HelveticaNeue-Bold", 14, { 255, 255, 255 } )
zText:setText( "Z: " .. sourcePos.z )

local xSliderCallback = function( event )
    sourcePos.x = (event.target.value - 50)/10
	xText:setText("X: " .. sourcePos.x)
    if fSoundPlaying and src then
        al.Source( src, al.POSITION, sourcePos.x, sourcePos.y, sourcePos.z )  
    end
end
local ySliderCallback = function( event )
    sourcePos.y = (event.target.value - 50)/10
	yText:setText("Y: " .. sourcePos.y)
    if fSoundPlaying and src then
        al.Source( src, al.POSITION, sourcePos.x, sourcePos.y, sourcePos.z )  
    end
end
local zSliderCallback = function( event )
    sourcePos.z = (event.target.value - 50)/10
	zText:setText("Z: " .. sourcePos.z)
    if fSoundPlaying and src then
        al.Source( src, al.POSITION, sourcePos.x, sourcePos.y, sourcePos.z )  
    end
end

local xSlider = widget.newSlider{ value = 50, callback = xSliderCallback, width=display.contentWidth*0.8 }
local ySlider = widget.newSlider{ value = 50, callback = ySliderCallback, width=display.contentWidth*0.8 }
local zSlider = widget.newSlider{ value = 50, callback = zSliderCallback, width=display.contentWidth*0.8 }
xSlider.x = display.contentCenterX
ySlider.x = display.contentCenterX
zSlider.x = display.contentCenterX
zSlider.y = recButton.y - recButton.height*4
ySlider.y = recButton.y - recButton.height*6
xSlider.y = recButton.y - recButton.height*8


--------------------------------------------------------------------------------
-- Start 
--------------------------------------------------------------------------------

rmonitor = media.newRecording()
rmonitor:startRecording()

updateRecordingLabel ()      

transition.to(spriteGroup, { time = 800, y = 0, xScale = 1.0, yScale = 1.0, transition = easingx.easeOutElastic }) -- "pop" animation                                
