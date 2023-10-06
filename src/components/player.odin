package components

import "src:components/transform"
import "src:components/graphics"

Player :: struct {
	using soul: ^transform.DynamicSoul,
	acceleration: f32,
	deceleration: f32,
	start_speed: f32,
	current_speed: f32,
}

calculate_accel :: proc(
	time_s: f32, 
	max_speed: f32, 
	start_speed: f32,
	dt: f32,
) -> f32 {
	frames := time_s / dt
	
	return (max_speed - start_speed) / frames
}
