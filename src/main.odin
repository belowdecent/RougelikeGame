package game

import "vendor:sdl2"
import "vendor:sdl2/image"
import "core:time"
import "core:math"

import "engine"
import "engine/ecs"
import "engine/texture_manager"

import "components"
import "components/transform"
import "components/graphics"

import "systems"
import "systems/tilemap"
import "systems/displaytree"

import "prefabs"

UPDATE_RATE :: 1.0 / 60.0
FRAME_RATE  :: 1.0 / 60.0

main :: proc() {
	assert(sdl2.Init(sdl2.INIT_VIDEO) == 0, sdl2.GetErrorString())
	defer sdl2.Quit()

	game: engine.GameState
	pressed: engine.Input_Set

	engine.initialize_game(&game)
	defer sdl2.DestroyRenderer(game.renderer)
	defer sdl2.DestroyWindow(game.window)

	ec_manager: ecs.EC_Manager
	tx_manager := texture_manager.init(game.renderer)

	{
		using ecs

		register_component_type(transform.DynamicSoul, &ec_manager, 1)
		register_component_type(components.Player, &ec_manager, 1)
		register_component_type(graphics.Image, &ec_manager, 100)
		register_component_type(graphics.Sprite, &ec_manager, 1)
	}

	tiles := tilemap.ImageTilemap {
		tiles = []tilemap.Tile{
			{{0, 0}, {0, 0}},
			{{1, 0}, {1, 0}},
			{{2, 0}, {2, 0}},
			{{3, 0}, {3, 0}},
			{{0, 1}, {4, 1}},
			{{1, 1}, {0, 2}},
			{{2, 1}, {0, 3}},
			{{3, 1}, {0, 4}},
			{{0, 2}, {0, 0}},
			{{1, 2}, {1, 0}},
			{{2, 2}, {2, 0}},
			{{3, 2}, {3, 0}},
			{{0, 3}, {4, 1}},
			{{1, 3}, {0, 2}},
			{{2, 3}, {0, 3}},
			{{3, 3}, {0, 4}},
		},
		tileset = texture_manager.load_static(&tx_manager, "graphics/tileset/spritesheet.png").texture,
		tileset_size = {32, 32},
		size = {64, 64},
		basis = {
			0.5, -0.5,
			0.25, 0.25,
		},
		offset = {150, 50},
	}

	tilemap.init_tilemap(&tiles, game.renderer, &ec_manager)
	prefabs.create_player(&ec_manager, &tx_manager)

	display: displaytree.Tree
	displaytree.add(&display.root, &tiles)
	displaytree.add(&display.root, &ecs.get_components(graphics.Sprite, &ec_manager)[0])

	e: sdl2.Event
	testimage := texture_manager.load_static(&tx_manager, "graphics/tileset/spritesheet.png").texture
	testimage_rect := sdl2.Rect{
		15, 15, 200, 200,
	}

	for {
		engine.update_time(&game.time)

		// run on input loop timings
		for sdl2.PollEvent(&e) {
			#partial switch e.type {
				case .QUIT:
					return

				case .KEYDOWN: {
					using engine

					#partial switch e.key.keysym.sym {
						case .Q:
							return

						case .W:
							incl(&pressed, Input.Up)
						case .A:
							incl(&pressed, Input.Left)
						case .S:
							incl(&pressed, Input.Down)
						case .D:
							incl(&pressed, Input.Right)
					}
				}

				case .KEYUP: {
					using engine
					#partial switch e.key.keysym.sym {
						case .W:
							excl(&pressed, Input.Up)
						case .A:
							excl(&pressed, Input.Left)
						case .S:
							excl(&pressed, Input.Down)
						case .D:
							excl(&pressed, Input.Right)
					}
				}
			}
		}


		if (game.time.update_dt > UPDATE_RATE) {
			// run on logic loop timings
			using engine

			systems.controls(
				ecs.get_components(components.Player, &ec_manager),
				pressed,
			)

			systems.movement(
				ecs.get_components(transform.DynamicSoul, &ec_manager),
			)

			game.time.update_dt = 0;
		}

		if (game.time.render_dt > FRAME_RATE) {
			// run on render loop timings
			sdl2.SetRenderDrawColor(game.renderer, 0x0F, 0x00, 0xFF, 0xFF)
			sdl2.RenderClear(game.renderer)

			systems.update_renderable_position(ecs.get_components(graphics.Sprite, &ec_manager))
			displaytree.render_node(game.renderer, display.root)
			sdl2.RenderPresent(game.renderer)

			game.time.render_dt = 0
		}

		sdl2.Delay(1)
	}

	texture_manager.destroy(&tx_manager)
}
