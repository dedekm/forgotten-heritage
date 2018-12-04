limit = (y, a1, a2) ->
  (y - a2 * 16) / ((a1 - a2) * 16)

module.exports = (time) ->
  for emitter in @enemyEmitters
    if time - emitter.counter > 4000
      emitter.createEnemy() if emitter.active
      emitter.counter = time
      
  unless @hero.insane() || @hero.dead()
    if @hero.y > 45 * 16
      @sounds.background.garden.play(loop: true, volume: 0) unless @sounds.background.garden.isPlaying
      
      n = limit(@hero.y, 50, 45)
      
      if n > 0
        @sounds.background.garden.setVolume(n)
      else
        @sounds.background.garden.stop() if @sounds.background.garden.isPlaying
    else
      @sounds.background.garden.stop() if @sounds.background.garden.isPlaying
    
    if @hero.y < 50 * 16 && @hero.y > 15 * 16
      @sounds.background.jungle.play(loop: true, volume: 0) unless @sounds.background.jungle.isPlaying
    
      if @hero.y < 35 * 16
        n = limit(@hero.y, 35, 15)
      else if @hero.y > 40 * 16
        n = 1 - limit(@hero.y, 50, 40)
      else
        n = 1
      
      if n > 0
        @sounds.background.jungle.setVolume(n)
      else
        @sounds.background.jungle.stop() if @sounds.background.jungle.isPlaying
    else
      @sounds.background.jungle.stop() if @sounds.background.jungle.isPlaying
      
    if @hero.y < 30 * 16
      @sounds.background.voice.play(loop: true, volume: 0) unless @sounds.background.voice.isPlaying
    
      if @hero.y < 8 * 16
        n = limit(@hero.y, 8, -5)
      else if @hero.y > 15 * 16
        n = 1 - limit(@hero.y, 30, 15)
      else
        n = 1
      
      if n > 0
        @sounds.background.voice.setVolume(n)
      else
        @sounds.background.voice.stop() if @sounds.background.voice.isPlaying
    else
      @sounds.background.voice.stop() if @sounds.background.voice.isPlaying
