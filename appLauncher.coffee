# simulating the launch of an app
class AppLauncher
	constructor : (@launchImage, @lockScreen, @content, @contentDelay = 1, @lockScreenOffset = 1550, @launchImageOffset = 200) ->
		if launchImage? and lockScreen? and content?
			
			#hide things that don't need to be seen
			@launchImage.opacity = 0
			@content.opacity = 0

			# animation variable
			@launchOrigin = launchImage.y
		else 
			throw "Didn't get all the things I need"
	launchApp: =>
		@lockScreen.opacity = 1
		@lockScreen.animate
			properties:
				scale: 8
				y: layers.lockScreen.y + @lockScreenOffset
				opacity: 0
			
			curve: "ease-in"
			time: 0.5
		@launchImage.scale = 0.05
		@launchImage.y = @launchOrigin - @launchImageOffset 
		@launchImage.animate
			properties:
				scale: 1
				opacity: 1
				y: @launchOrigin
			curve: "ease-out"
			time: 0.5
		Utils.delay @contentDelay, @displayContent
		
	displayContent : =>
		@content.animate
			properties:
				opacity: 1
			curve: "ease-out"
			time: 0.3

appLauncher = new AppLauncher layers.launch_Image, layers.lockScreen, layers.content
		
Utils.delay 2, appLauncher.launchApp
