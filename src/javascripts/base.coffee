GameObjectPlugin = require './plugins/game_object_plugin.coffee'

preload = require './preload.coffee'
create = require './create.coffee'
update = require './update.coffee'


config =
  type: Phaser.AUTO
  width: 800
  height: 600
  pixelArt: true
  physics:
    default: 'arcade'
    debug: true
  plugins:
    global: [
        { key: 'GameObjectPlugin', plugin: GameObjectPlugin, start: true }
    ]
  scene:
    preload: preload
    create: create
    update: update

game = new (Phaser.Game)(config)
