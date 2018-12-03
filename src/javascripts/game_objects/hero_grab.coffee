class HeroGrab extends Phaser.GameObjects.Image
  constructor: (scene, x, y, key, frame) ->
    super scene, x, y, key, frame
    
    @scene.physics.add.existing(@)
    @body.setSize(10, 10)
    @moveAway()
    
    @scene.physics.add.collider(@, @scene.enemies, (grab, enemy) ->
      enemy.die()
      @scene.hero.paused = true
      @scene.hero.anims.play('grab')
      grab.moveAway()
    null, @)
  
  moveAway: ->
    @setPosition(-20, -20)

module.exports = HeroGrab
