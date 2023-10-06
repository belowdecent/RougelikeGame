package systems

import "src:engine"
import "src:engine/vector_math"

import "core:math"
import "core:math/linalg"

import c "src:components"

controls :: proc(players: []c.Player, pressed: engine.Input_Set) {
	using engine

	player := &players[0]
	direction: vector_math.Vec3

	if (Input.Up in pressed) {
		direction.y -= 1
	}
	if (Input.Down in pressed) {
		direction.y += 1
	}
	if (Input.Left in pressed) {
		direction.x -= 1
	}
	if (Input.Right in pressed) {
		direction.x += 1
	}

	if (linalg.length2(direction) < 0.01) {
		player.velocity = 0
		player.current_speed = player.start_speed
	} else {
		player.current_speed = math.min(
			player.current_speed + player.acceleration, 
			player.velocity_limit,
		)

		player.velocity = linalg.normalize0(direction) * player.current_speed
	}
}
