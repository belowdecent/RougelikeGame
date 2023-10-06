package systems

import "vendor:sdl2"
import "../engine/ecs"
import c "../components/graphics"

update_renderable_position :: proc(sprites: []c.Sprite) {
	for &sprite in sprites {
		sprite.image.dest.x = i32(sprite.position.x)
		sprite.image.dest.y = i32(sprite.position.y)
	}
}

draw_renderable :: proc(renderer: ^sdl2.Renderer, images: []c.Image) {
	for &image in images {
		sdl2.RenderCopy(renderer, image.source, image.clip, image.dest)
	}
}
