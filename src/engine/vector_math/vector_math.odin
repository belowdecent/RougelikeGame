package vector_math

import "core:math/linalg"
import "core:math"

Vec3 :: linalg.Vector3f32

clamp_length :: proc(vec: Vec3, target_length: f32) -> Vec3 {
	length := linalg.length(vec)

	if (length > target_length) {
		return (vec / length) * target_length
	} else {
		return vec
	}
}
