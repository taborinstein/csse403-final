# AUTHORS: Taylor Borinstein, Kyra Zhou, Mason Rice
import
  nimgame2 / [
    nimgame,
    settings,
    types,
  ],
  data,
  title,
  main,
  levels,
  win_screen

when isMainModule:
  game = newGame()
  if game.init(GameWidth, GameHeight, title = GameTitle, integerScale = true):
    # Init
    game.setResizable(true) # Window could be resized
    game.minSize = (GameWidth, GameHeight) # Minimal window size
    game.windowSize = (GameWidth * 2, GameHeight * 2) # Double scaling (1280x720)
    game.centrify() # Place window at the center of the screen

    loadData()

    # Create scenes
    titleScene = newTitleScene()
    mainScene = newMainScene()
    winScene = newWinScene()
    
    # Run
    game.scene = titleScene # Initial scene
    run game  # Let's go!
