Hero = require './game_objects/hero.coffee'
Enemy = require './game_objects/enemy.coffee'
RemainsGraphics = require './game_objects/remains_graphics.coffee'

showDebug = false
drawDebug = (map, debugGraphics) ->
  debugGraphics.clear()
  if showDebug
    map.renderDebug debugGraphics,
      tileColor: null
      collidingTileColor: new (Phaser.Display.Color)(243, 134, 48, 200)
      faceColor: new (Phaser.Display.Color)(40, 39, 37, 255)
  return

module.exports = ->
  @keys = @input.keyboard.addKeys('W,S,A,D')

  @map = @make.tilemap(
    key: 'map'
  )

  tileset = @map.addTilesetImage('tileset', 'tiles')
  layer = @map.createStaticLayer('static', tileset, 0, 0)
  layer_bushes = @map.createDynamicLayer('dynamic', tileset, 0, 0)
  @map.setCollision([196, 251])

  @anims.create(
    key: 'run'
    frames: @anims.generateFrameNumbers('gardener', start: 0, end: 1)
    frameRate: 10
    repeat: -1
  )
  @anims.create(
    key: 'run_insane'
    frames: @anims.generateFrameNumbers('gardener', start: 2, end: 3)
    frameRate: 10
    repeat: -1
  )
  @anims.create(
    key: 'grab'
    frames: @anims.generateFrameNumbers('gardener', start: 4, end: 8)
    frameRate: 7
  )
  @anims.create(
    key: 'hold'
    frames: @anims.generateFrameNumbers('gardener', start: 5, end: 8)
    frameRate: 7
    repeat: -1
  )
  @anims.create(
    key: 'slash'
    frames: @anims.generateFrameNumbers('slash')
    frameRate: 10
    repeat: -1,
    yoyo: true
  )
  
  @remainsGraphics = @add.gameObject(RemainsGraphics)
  
  @enemies = @add.group()
  
  enemy = @add.gameObject(Enemy, 15 * 16, 5 * 16, 'aztec1', 0)
  @physics.add.existing(enemy)
  enemy.body.setSize(12, 20)
  enemy.body.setOffset(4, 4)
  enemy.body.immovable = true
  
  @enemies.add(enemy)
  
  # DEBUG only
  @hero = @add.gameObject(Hero, 12 * 16, 5 * 16, 'gardener', 1)
  # @hero = @add.gameObject(Hero, 12 * 16, 57 * 16, 'gardener', 1)
  @physics.add.existing(@hero)
  @hero.body.setSize(12, 14, true)
  
  @physics.add.collider(@hero, [layer, layer_bushes])
  @physics.add.collider(@hero, @enemies, (hero, enemy)->
    hero.hit(0.01)
  )
  @cameras.main.setBounds(0, 0, @map.widthInPixels, @map.heightInPixels)
  @cameras.main.startFollow(@hero)
  
  debugGraphics = @add.graphics()
  @input.keyboard.on 'keydown_C', (event) ->
    showDebug = !showDebug
    drawDebug(map, debugGraphics)
    return

  @keys = @input.keyboard.addKeys('w,s,a,d')
  
  # DEBUG only
  @keys = @input.keyboard.addKeys('w,s,a,d,q')
