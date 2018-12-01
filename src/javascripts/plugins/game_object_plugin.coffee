class GameObjectPlugin extends Phaser.Plugins.BasePlugin
  constructor: (pluginManager) ->
    super(pluginManager)
    pluginManager.registerGameObject('gameObject', @createGameObject)

  createGameObject: (klass, x, y, key, frame) ->
    object = new klass(@scene, x, y, key, frame)
    @displayList.add(object)
    
    object

module.exports = GameObjectPlugin
