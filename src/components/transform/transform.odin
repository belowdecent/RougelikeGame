package transform

import "core:math/linalg"

Vec3 :: linalg.Vector3f32

StaticSoul :: struct {
	position: Vec3,
}

DynamicSoul :: struct {
	position: Vec3,
	velocity: Vec3,

	min_position: Vec3,
	max_position: Vec3,
	velocity_limit: f32,
}
