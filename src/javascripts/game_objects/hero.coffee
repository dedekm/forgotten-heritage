GameObject = require './game_object.coffee'

class Hero extends GameObject
  constructor: (scene, x, y, key, frame) ->
    super scene, x, y, key, frame
    
    @children = []
    @scene.input.on('pointerdown', @pointerdown, @)
    
    @scene.add.updateList.add(@)
    
  preUpdate: () ->
    for child in @children
      child.setPosition(@x + child.relativeX, @y + child.relativeY)
      
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
  
  pointerdown: (pointer) ->
    return if @slash
    
    slashImage = @scene.add.image(@x, @y, 'arrow')

    angle = Phaser.Math.Angle.Reverse(
      Phaser.Math.Angle.Between(pointer.x, pointer.y, @x, @y)
    )
    Phaser.Actions.RotateAroundDistance([slashImage], @, angle, 50)
    slashImage.angle = angle * Phaser.Math.RAD_TO_DEG
    @addChild(slashImage)
    
    @scene.time.addEvent(
      delay: 400
      callback: ->
        @destroyChild(slashImage)
      callbackScope: @
    )
    
  addChild: (child) ->
    child.relativeX = child.x - @x
    child.relativeY = child.y - @y
    @children.push(child)
  
  destroyChild: (child) ->
    index = @children.indexOf(child)
    @children.splice(index, 1)
    child.destroy()
    
module.exports = Hero
