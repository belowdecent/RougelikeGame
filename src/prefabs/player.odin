package prefabs

import "vendor:sdl2"

import "src:engine/ecs"
import "src:engine/texture_manager"
import "src:components"
import "src:components/transform"
import "src:components/graphics"

UPDATE_RATE :: 1.0 / 60.0
FRAME_RATE  :: 1.0 / 60.0

create_player :: proc(ec_manager: ^ecs.EC_Manager, tx_manager: ^texture_manager.Manager) -> ^sdl2.Texture {
	player_entity := ecs.new_entity(ec_manager)

	soul := ecs.add_component(
		player_entity, 
		transform.DynamicSoul, 
		ec_manager,
	)
	soul.max_position = 1024
	soul.velocity_limit = 5

	player := ecs.add_component(
		player_entity, 
		components.Player{
			soul = soul,
		}, 
		ec_manager,
	)

	player.start_speed = 1

	player.acceleration = components.calculate_accel(
		0.2,
		soul.velocity_limit,
		player.start_speed,
		UPDATE_RATE,
	)
	player.deceleration = player.acceleration * 3

	my_texture := ecs.add_component(
		player_entity,
		graphics.create_image(
			tx_manager, 
			"graphics/characters/free_character_1-3.png",
			sdl2.Rect{w = 16, h = 20},
			sdl2.Rect{w = 32, h = 40},
		),
		ec_manager,
	)

	sprite := ecs.add_component(
		player_entity,
		graphics.Sprite{&soul.position, my_texture},
		ec_manager,
	)

	return my_texture.source
}
