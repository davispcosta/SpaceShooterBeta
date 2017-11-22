local composer = require( "composer" )
local scene = composer.newScene()
composer.recycleOnSceneChange = true

local physics = require('physics')
physics.start()
physics.setGravity(0, 0)

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local fundo
local fundoGrupo = display.newGroup()
local principalGrupo = display.newGroup()
local uiGrupo = display.newGroup()
local vidasGrupo = display.newGroup()
local nave
local quantidadeVidas
local chefao
local inimigo

local scoreTexto
local score


-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

   local sceneGroup = self.view
   -- Code here runs when the scene is first created but has not yet appeared on screen

   quantidadeVidas = 3
   score = 0

   ---- FUNDO
   fundo = display.newImage('imgs/background.png', display.contentCenterX, display.contentCenterY)
   fundo.width = display.contentWidth
   fundo.height = display.contentHeight
   fundoGrupo:insert(fundo)

   ---- NAVE
   nave = display.newImage("imgs/ship.png")
   nave.x = display.contentWidth/2
   nave.y = display.contentHeight - 100
   nave.name = "NAVE"
   principalGrupo:insert(nave)
   physics.addBody(nave)

   ---- SCORE
   scoreTexto = display.newText('Score: ', 10, 0, native.systemFontBold, 14)
   scoreTexto.x = 50
   uiGrupo:insert(scoreTexto)

   ---- VIDAS
   function criarVidas(quantidadeVidas)
        for i = 1, quantidadeVidas do
            vida = display.newImage('imgs/ship.png')
            vida.x = (display.contentWidth - vida.width * 0.7) - (5 * i+1) - vida.width * i + 20
            vida.y = display.contentHeight - vida.height * 0.7
            vidasGrupo:insert(vida)            
        end
   end
   criarVidas(quantidadeVidas)

    ---- FUNÇÃO DE MOVER NAVE
    function moverNave(e)
        if(e.phase == 'began') then
            lastX = e.x - nave.x
        elseif(e.phase == 'moved') then
            nave.x = e.x - lastX
        end
    end
    fundo:addEventListener('touch', moverNave)

    ---- FUNÇÃO DE ATIRAR
    local tiros = display.newGroup()
    function moverTiro()
        for a = 0, tiros.numChildren, 1 do
            if tiros[a] ~= nil and tiros[a].x ~= nil then
                tiros[a].y = tiros[a].y - 1 
            end            
        end
    end
    function atirar(e)
        local tiro = display.newImage('imgs/shoot.png')
        tiro.x = nave.x
        tiro.y = nave.y - nave.height
        tiro.name = 'TIRO'
        physics.addBody(tiro)    
        tiros:insert(tiro)       
    end
    moverTiroLoop = timer.performWithDelay(1, moverTiro, -1)
    principalGrupo:insert(tiros)
    fundo:addEventListener('tap', atirar)

    ---- CRIAR INIMIGOS
    local inimigos = display.newGroup()
    function moverInimigo()
        for a = 0, inimigos.numChildren, 1 do
            if inimigos[a] ~= nil and inimigos[a].x ~= nil then
                inimigos[a].y = inimigos[a].y + 3
            end            
        end
    end
    function inimigoColisao(event)
        if(event.phase == "began") then

            if(event.other.name == "NAVE") then
                event.target:removeSelf()
                display.remove(vidasGrupo)            
                quantidadeVidas = quantidadeVidas - 1
                vidasGrupo = display.newGroup()
                criarVidas(quantidadeVidas)

                if quantidadeVidas == 0 then
                    composer.gotoScene("scenes.gameover")
                end

            elseif(event.other.name == "TIRO") then
                event.target:removeSelf()
                event.other:removeSelf()
                score = score + 1
                scoreTexto.text = "Score: "..score
            end
        end
    end
    function adicionarInimigo()
        inimigo = display.newImage('imgs/enemy.png')
        inimigo.x = math.floor(math.random() * (display.contentWidth - inimigo.width))
        inimigo.y = -inimigo.height
        inimigo.name = "INIMIGO"
        physics.addBody(inimigo, "static")
        inimigos:insert(inimigo)
        inimigo:addEventListener('collision', inimigoColisao)        
    end
    principalGrupo:insert(inimigos)
    moverInimigoLoop = timer.performWithDelay(1, moverInimigo, -1)
    criarInimigoLoop = timer.performWithDelay(1000, adicionarInimigo, -1)

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
       fundo:removeEventListener('touch', moverNave)
       fundo:removeEventListener('tap', atirar)
       inimigo:removeEventListener('collision', inimigoColisao) 

       display.remove(fundoGrupo)
       display.remove(inimigos)       
       display.remove(principalGrupo)
       display.remove(uiGrupo)
       display.remove(vidasGrupo)

       timer.cancel(moverTiroLoop)
       timer.cancel(moverInimigoLoop)
       timer.cancel(criarInimigoLoop)                 

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