GameObject = require './game_object.coffee'

class Hero extends GameObject
  constructor: (scene, x, y, key, frame) ->
    super scene, x, y, key, frame
    
    @scene.add.updateList.add(@)
    
  preUpdate: () ->
    @body.setVelocity 0
    # Horizontal movement
    if @scene.keys.a.isDown
      @body.setVelocityX -100
    else if @scene.keys.d.isDown
      @body.setVelocityX 100
    # Vertical movement
    if @scene.keys.w.isDown
      @body.setVelocityY -100
    else if @scene.keys.s.isDown
      @body.setVelocityY 100

    if @scene.keys.a.isDown
      @anims.play 'left', true
    else if @scene.keys.d.isDown
      @anims.play 'right', true
    else if @scene.keys.w.isDown
      @anims.play 'up', true
    else if @scene.keys.s.isDown
      @anims.play 'down', true
    else
      @anims.stop()
  
module.exports = Hero
