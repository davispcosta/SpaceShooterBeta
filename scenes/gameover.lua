local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local gameoverGrupo = display.newGroup()

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

   local sceneGroup = self.view

   fimDeJogoTexto = display.newText('FIM DE JOGO', 10, 0, native.systemFontBold, 20)
   fimDeJogoTexto.x = display.contentCenterX
   fimDeJogoTexto.y = 100
   gameoverGrupo:insert(fimDeJogoTexto)

   botaoVoltar = display.newImage("imgs/backBtn.png")
   botaoVoltar.x = display.contentCenterX
   botaoVoltar.y = display.contentCenterY
   gameoverGrupo:insert(botaoVoltar)

   function gotoMenu()
    composer.gotoScene("scenes.menu")
   end
   botaoVoltar:addEventListener("tap", gotoMenu)

end


-- show()
function scene:show( event )

   local sceneGroup = self.view
   local phase = event.phase

   if ( phase == "will" ) then
       -- Code here runs when the scene is still off screen (but is about to come on screen)

   elseif ( phase == "did" ) then
       -- Code here runs when the scene is entirely on screen

   end
end


-- hide()
function scene:hide( event )

   local sceneGroup = self.view
   local phase = event.phase

   if ( phase == "will" ) then
       -- Code here runs when the scene is on screen (but is about to go off screen)
    display.remove(gameoverGrupo)

   elseif ( phase == "did" ) then
       -- Code here runs immediately after the scene goes entirely off screen

   end
end


-- destroy()
function scene:destroy( event )

   local sceneGroup = self.view
   -- Code here runs prior to the removal of scene's view

end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene