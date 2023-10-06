package graphics

import "vendor:sdl2"
import "vendor:sdl2/image"

import "src:engine/texture_manager"

// A simple static image struct
Image :: struct {
	source: ^sdl2.Texture,
	dest: ^sdl2.Rect,
	clip: ^sdl2.Rect,
}

// Create image
// source: surface or path
// clip_rect: full image or custom
// render_rect: full size or custom
create_image :: proc{
	create_image_auto,
	create_image_resize,
	create_image_crop,
}

create_image_from_texture :: proc(
	texture: ^sdl2.Texture,
	crop: sdl2.Rect,
	dest: sdl2.Rect,
) -> Image {
	clip := new_clone(crop)
	dest := new_clone(dest)
	
	return Image{
		source = texture,
		clip = clip,
		dest = dest,
	}
}

create_image_auto :: proc(
	manager: ^texture_manager.Manager,
	path: string,
) -> Image {
	entry := texture_manager.load_static(manager, path)
	
	return create_image_from_texture(
		entry.texture,
		sdl2.Rect{0, 0, entry.size.x, entry.size.y},
		sdl2.Rect{0, 0, entry.size.x, entry.size.y},
	)
}

create_image_resize :: proc(
	manager: ^texture_manager.Manager,
	path: string,
	dest: sdl2.Rect,
) -> Image {
	entry := texture_manager.load_static(manager, path)
	
	return create_image_from_texture(
		entry.texture,
		sdl2.Rect{0, 0, entry.size.x, entry.size.y},
		dest,
	)
}

create_image_crop :: proc(
	manager: ^texture_manager.Manager,
	path: string,
	crop: sdl2.Rect,
	dest: sdl2.Rect,
) -> Image {
	entry := texture_manager.load_static(manager, path)
	
	return create_image_from_texture(
		entry.texture,
		crop,
		dest,
	)
}
