# Basic mobile navigation controller.
# Use like this
# navigationController = new NavigationController [initial layer], [back button layer]


class NavigationController
  
  stack = []
  documentWidth = 0 
  backButton = null

  constructor: (initialView, backControl, docWidth = 640) ->

    if initialView?
      # put one in the chamber
      stack.push initialView

      #set up the width of our document
      documentWidth = docWidth

      if backControl?
        backButton = backControl
        backButton.opacity = 0
 
        backButton.on Events.Click, =>
          if backButton.opacity > 0 # only attempt to go back if there is a back button
            @goBack()
            
    else 
      throw "Didn't get a view to start with"

  # high level public functions
  # toDo: add callback functionality
  goTo: (view) ->
    if view?
      # the view that's leaving
      exit = stack[stack.length-1]
      view.index = exit.index + 1

      #add the view we're navigating to to the stack
      stack.push view

      #move everything around
      _slide view, "in", "rightToLeft"
      _slide exit, "out", "rightToLeft"
    else 
      throw "didn't give goTo a view to go to!"

    if backButton?
        backButton.opacity = 1

  goBackTo: (view) ->
    if view?
      # the view that's leaving
      exit = stack.pop()
      view.index = exit.index + 1

      #move everything around
      _slide view, "in", "leftToRight"
      _slide exit, "out", "leftToRight"

      if backButton? and stack.length < 2
        backButton.opacity = 0

    else 
      throw "didn't give goBackTo a view to go to!"
  goBack: ->
    # this is just sugar
    target = stack[stack.length-2]
    @goBackTo target

  #private functions
  _slide = (view, destination = "in", direction = "rightToLeft") ->
    if view?
      
      #sane defaults (in, rightToLeft)
      viewTargetX = 0
      viewStartingX = documentWidth
      viewTargetBrightness = 100
      view.opacity = 1
      view.brightness = 100

      # check where we're going
      if destination != "in" 
        viewStartingX = 0
        viewTargetBrightness = 50

        if direction == "leftToRight" 
          viewTargetX = documentWidth
        else 
          viewTargetX = 0 - documentWidth
        
      else if direction != "rightToLeft"
        viewTargetX = 0
        viewStartingX = 0 - documentWidth

      #let's slide
      view.x = viewStartingX
      view.animate
        properties:
          x: viewTargetX
          brightness: viewTargetBrightness
        curve: "ease-out"
        time: 0.3

    else
      throw "slide didn't see a view"