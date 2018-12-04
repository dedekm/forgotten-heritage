GameObjectPlugin = require './plugins/game_object_plugin.coffee'

preload = require './preload.coffee'
create = require './create.coffee'
update = require './update.coffee'


config =
  type: Phaser.AUTO
  width: 288
  height: 192
  pixelArt: true
  zoom: 3
  physics:
    default: 'arcade'
  plugins:
    global: [
        { key: 'GameObjectPlugin', plugin: GameObjectPlugin, start: true }
    ]
  scene:
    preload: preload
    create: create
    update: update

game = new (Phaser.Game)(config)
