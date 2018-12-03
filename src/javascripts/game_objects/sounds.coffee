class Sounds extends Object
  constructor: (scene) ->
    super()
    
    @scene = scene
    
    @slashBush = @scene.sound.add('slash_bush')
    @slashAir = @scene.sound.add('slash_air')
    
module.exports = Sounds
