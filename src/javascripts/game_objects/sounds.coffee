class Sounds extends Object
  constructor: (scene) ->
    super()
    
    @scene = scene
    
    @run = @scene.sound.add('run')
    @slashBush = @scene.sound.add('slash_bush')
    @slashAir = @scene.sound.add('slash_air')
    
module.exports = Sounds
