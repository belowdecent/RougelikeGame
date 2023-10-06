package engine

import "core:time" 
import "vendor:sdl2"

GameState :: struct {
	window: ^sdl2.Window,
	renderer: ^sdl2.Renderer,
	time: TimeState,
}

initialize_game :: proc(game: ^GameState) {
	{
		using sdl2

		game.window = CreateWindow(
			"Untitled game",
			WINDOWPOS_CENTERED,
			WINDOWPOS_CENTERED,
			640,
			480,
			WINDOW_SHOWN,
		)

		assert(game.window != nil, GetErrorString())
		game.renderer = CreateRenderer(game.window, -1, RENDERER_ACCELERATED)
	}

	game.time.start_tick = time.tick_now()
}
