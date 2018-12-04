Character = require './character.coffee'

class Enemy extends Character
  constructor: (scene, x, y, key, frame) ->
    super scene, x, y, key, frame

    @needsTint = false
    @counter = 0
  
  hit: (value) ->
    super.hit(value)

    @needsTint = true
  
  die: ->
    bloodParticle = @scene.add.particles('pixel')
    
    emitter = bloodParticle.createEmitter(
      x: @x
      y: @y
      lifespan: 200
      speed: { min: 10, max: 100 }
      gravityY: 150
      deathCallback: @scene.remainsGraphics.particleDeathCallback
      deathCallbackScope: @scene.remainsGraphics
    )
    
    @scene.time.addEvent(
      delay: 300
      callback: ->
        bloodParticle.destroy()
    )
    
    super.die()
  
  moveToHero: ->
    if @scene.hero
      velocity = new (Phaser.Math.Vector2)
      angle = Phaser.Math.Angle.BetweenPoints(@, @scene.hero)
      @scene.physics.velocityFromRotation(angle, 60, velocity)
      @body.setVelocity(velocity.x, velocity.y)
      @anims.play('aztec1_run')
    else
      @body.setVelocity(0, 0)
      @anims.stop()
  
  preUpdate: (time, delta) ->
    super.preUpdate(time, delta)
    
    if time - @counter > 1000
      @moveToHero()
      @counter = time

    if @needsTint
      gb = 255 * @health
      @setTint(new Phaser.Display.Color(255, gb, gb).color)
      @needsTint = false

module.exports = Enemy
