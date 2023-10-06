package tilemap

import "core:math/linalg"
import "vendor:sdl2"

import "src:components/graphics"
import "src:engine/ecs"

// A tilemap for image tiles without any other information
ImageTilemap :: struct {
	tiles: []Tile,
	tileset: ^sdl2.Texture,
	tileset_size: [2]i32,
	components: []^graphics.Image,
	size: [2]i32,
	basis: linalg.Matrix2x2f32,
	offset: [2]i32,
}

init_tilemap :: proc(
	tilemap: ^ImageTilemap, 
	renderer: ^sdl2.Renderer,
	manager: ^ecs.EC_Manager,
) {
	tilemap.components = make([]^graphics.Image, len(tilemap.tiles))
	scale_matrix: matrix[2, 2]f32 = {
		f32(tilemap.size.x), 0,

		0, f32(tilemap.size.y),
	}

	for tile, index in tilemap.tiles {
		entity := ecs.new_entity(manager)
		tileimage := ecs.add_component(
			entity,
			graphics.Image {
				tilemap.tileset,
				new(sdl2.Rect),
				new(sdl2.Rect),
			},
			manager,
		)
		tilemap.components[index] = tileimage

		tileimage.clip.x = tile.source.x * tilemap.tileset_size.x 
		tileimage.clip.y = tile.source.y * tilemap.tileset_size.y
		tileimage.clip.w = tilemap.tileset_size.x
		tileimage.clip.h = tilemap.tileset_size.y

		f32_pos: [2]f32
		f32_pos.x = f32(tile.position.x)
		f32_pos.y = f32(tile.position.y)
		tile_transform := tilemap.basis * scale_matrix * f32_pos

		tileimage.dest.x = i32(tile_transform.x) + tilemap.offset.x
		tileimage.dest.y = i32(tile_transform.y) + tilemap.offset.y
		tileimage.dest.w = tilemap.size.x
		tileimage.dest.h = tilemap.size.y
	}
}

clear_tilemap :: proc(
	tilemap: ^ImageTilemap,
	manager: ^ecs.EC_Manager,
) {

}
