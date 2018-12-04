class HeroSlash extends Phaser.GameObjects.Sprite
  constructor: (scene, x, y, key, frame) ->
    super scene, x, y, key, frame
    
    @scene.physics.add.existing(@)
    scene = @scene
    collider = @scene.physics.add.collider(@, @scene.hand, (slash, hand) ->
      hand.destroy()
      collider.destroy()
      
      bloodParticle = scene.add.particles('pixel')
      
      emitter = bloodParticle.createEmitter(
        x: hand.x
        y: hand.y + 4
        lifespan: 200
        speed: { min: 10, max: 100 }
        angle: { min: 220, max: 320 }
        gravityY: 150
        deathCallback: scene.remainsGraphics.particleDeathCallback
        deathCallbackScope: scene.remainsGraphics
      )
      
      scene.time.addEvent(
        delay: 1000
        callback: ->
          bloodParticle.destroy()
      )
      
      scene.hero.turnInsane()
    )

  hit: ->
    tileX = @scene.map.worldToTileX(@x)
    tileY = @scene.map.worldToTileY(@y)
    tile = @scene.map.getTileAt(tileX, tileY)
      
    if tile && [196, 251].includes(tile.index)
      @scene.sounds.slashBush.play()
      @scene.map.putTileAt(231, tileX, tileY)
    else
      @scene.sounds.slashAir.play()

module.exports = HeroSlash
