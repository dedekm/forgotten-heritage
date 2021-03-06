Hero = require './game_objects/hero.coffee'
EnemyEmitter = require './game_objects/enemy_emitter.coffee'
RemainsGraphics = require './game_objects/remains_graphics.coffee'
Sounds = require './game_objects/sounds.coffee'

WALLS =  [
  0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 18, 19, 20,
  22, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 40,
  41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55,
  56, 58, 59, 60, 61, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75,
  76, 77, 78, 79, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92,
  93, 94, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107,
  108, 109, 110, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121,
  122, 123, 124, 128, 129, 130, 131, 132, 136, 137, 141, 142, 143,
  144, 145, 146, 147, 148, 149, 150, 151, 152, 153, 156, 157, 160,
  161, 162, 163, 164, 165, 167, 169, 170, 171, 172, 176, 177, 178,
  179, 180, 181, 183, 185, 186, 187, 188, 192, 193, 194, 195, 196,
  197, 199, 202, 203, 204, 205, 206, 207, 208, 209, 210, 211, 212,
  214, 218, 219, 220, 221, 225, 226, 227, 228, 229, 232, 233, 234,
  235, 236, 237, 239, 240, 241, 242, 243, 244, 245, 246, 247, 248,
  249, 250, 251, 252, 253, 255, 256
]

module.exports = ->
  @keys = @input.keyboard.addKeys('w,s,a,d')
  
  @sounds = new Sounds(@)

  @map = @make.tilemap(
    key: 'map'
  )

  tileset = @map.addTilesetImage('tileset', 'tiles')
  layer = @map.createStaticLayer('static', tileset, 0, 0)
  layer.setCollision(WALLS)
  layer_bushes = @map.createDynamicLayer('dynamic', tileset, 0, 0)
  layer_bushes.setCollision([196, 251])
  @map.bushes = layer_bushes
  layer_walls = @map.createStaticLayer('walls', tileset, 0, 0)
  layer_walls.setCollision(WALLS).setVisible(false)
  @map.walls = layer_walls

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
    key: 'aztec1_run'
    frames: @anims.generateFrameNumbers('aztec1')
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
  
  @enemyEmitters = [
    new EnemyEmitter(@, 7 * 16, 5 * 16),
    new EnemyEmitter(@, 9 * 16, 25 * 16),
    new EnemyEmitter(@, 27 * 16, 4 * 16),
    new EnemyEmitter(@, 24 * 16, 22 * 16)
  ]
  
  @hand = @add.image(22 * 16 - 8, 11 * 16 - 8, 'hand')
  @physics.add.existing(@hand)
  @hand.body.setSize(16, 16, true)
  
  @hero = @add.gameObject(Hero, 12 * 16, 52 * 16, 'gardener', 1)
  @physics.add.existing(@hero)
  @hero.body.setSize(12, 14)
  @hero.body.setOffset(2, 4)
  
  @physics.add.collider(@hero, [layer, layer_bushes])
  @physics.add.collider(@hero, @enemies, (hero, enemy)->
    hero.hit(0.01)
  )
  @cameras.main.setBounds(0, 0, @map.widthInPixels, @map.heightInPixels)
  @cameras.main.startFollow(@hero)
  
  @sounds.background.garden.play(loop: true, volume: 1)
