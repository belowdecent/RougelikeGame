package systems

import "src:components/transform"

movement :: proc(souls: []transform.DynamicSoul) {
	for &soul in souls {
		soul.position = soul.position + soul.velocity
	}
}
