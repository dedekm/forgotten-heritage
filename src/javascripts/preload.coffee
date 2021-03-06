module.exports = ->
  @game.canvas.style.width = (@game.config.width * @game.config.zoom).toString() + 'px'
  @game.canvas.style.height = (@game.config.height * @game.config.zoom).toString() + 'px'
  
  @load.image('tiles', '/tilemaps/tileset.png')
  @load.image('hand', '/images/hand_7x13.png')
  @load.tilemapTiledJSON('map', '/tilemaps/map.json')
  @load.spritesheet('gardener', '/images/gardener_14x19.png', frameWidth: 14, frameHeight: 19)
  @load.spritesheet('slash', '/images/slash_7x16.png', frameWidth: 7, frameHeight: 16)
  @load.spritesheet('aztec1', '/images/aztec1_16x24.png', frameWidth: 16, frameHeight: 24)

  graphics = @add.graphics()
  graphics.fillStyle(0xff0000, 1)
  graphics.fillRect(0, 0, 2, 2)
  texture = graphics.generateTexture('pixel', 2, 2)

  @load.audio('background_garden', ['sounds/background_garden.ogg', 'sounds/background_garden.mp3'])
  @load.audio('background_jungle', ['sounds/background_jungle.ogg', 'sounds/background_jungle.mp3'])
  @load.audio('background_voice', ['sounds/background_voice.ogg', 'sounds/background_voice.mp3'])
  @load.audio('background_metal', ['sounds/background_metal.ogg', 'sounds/background_metal.mp3'])
  @load.audio('run', ['sounds/run.ogg', 'sounds/run.mp3'])
  @load.audio('slash_air', ['sounds/slash_air.ogg', 'sounds/slash_air.mp3'])
  @load.audio('slash_bush', ['sounds/slash_bush.ogg', 'sounds/slash_bush.mp3'])
  @load.audio('scream', ['sounds/scream.ogg', 'sounds/scream.mp3'])
