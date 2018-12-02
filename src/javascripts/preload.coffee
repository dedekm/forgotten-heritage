module.exports = ->
  @game.canvas.style.width = (@game.config.width * @game.config.zoom).toString() + 'px'
  @game.canvas.style.height = (@game.config.height * @game.config.zoom).toString() + 'px'
  
  @load.image('tiles', 'http://labs.phaser.io/assets/tilemaps/tiles/catastrophi_tiles_16.png')
  @load.tilemapCSV('map_base', '/tilemaps/map_base.csv')
  @load.tilemapCSV('map_bushes', '/tilemaps/map_bushes.csv')
  @load.spritesheet('gardener', '/images/gardener_14x16.png', frameWidth: 14, frameHeight: 16)
  @load.spritesheet('slash', '/images/slash_7x16.png', frameWidth: 7, frameHeight: 16)

  graphics = @add.graphics()
  graphics.fillStyle(0xff0000, 1)
  graphics.fillRect(0, 0, 2, 2)
  texture = graphics.generateTexture('pixel', 2, 2)
