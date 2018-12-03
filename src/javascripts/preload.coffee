module.exports = ->
  @game.canvas.style.width = (@game.config.width * @game.config.zoom).toString() + 'px'
  @game.canvas.style.height = (@game.config.height * @game.config.zoom).toString() + 'px'
  
  @load.image('tiles', '/tilemaps/tileset.png')
  @load.tilemapTiledJSON('map', '/tilemaps/map.json')
  @load.spritesheet('gardener', '/images/gardener_14x19.png', frameWidth: 14, frameHeight: 19)
  @load.spritesheet('slash', '/images/slash_7x16.png', frameWidth: 7, frameHeight: 16)
  @load.spritesheet('aztec1', '/images/aztec1_16x24.png', frameWidth: 16, frameHeight: 24)

  graphics = @add.graphics()
  graphics.fillStyle(0xff0000, 1)
  graphics.fillRect(0, 0, 2, 2)
  texture = graphics.generateTexture('pixel', 2, 2)

  @load.audio('slash_bush', ['sounds/slash_bush.ogg', 'sounds/slash_bush.mp3'])
