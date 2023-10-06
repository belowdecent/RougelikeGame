package texture_manager

import "vendor:sdl2"
import "vendor:sdl2/image"
import "core:c"

Entry :: struct {
	texture: ^sdl2.Texture,
	size: [2]c.int,
}

TextureTable :: map[string]Entry

new_entry :: proc(renderer: ^sdl2.Renderer, path: cstring) -> Entry {
	surface := image.Load(path)
	defer sdl2.FreeSurface(surface)

	entry := Entry{
		texture = sdl2.CreateTextureFromSurface(renderer, surface),
		size = [2]c.int{
			surface.w, 
			surface.h,
		},
	}

	return entry
}

destroy_entry :: proc(entry: Entry) {
	sdl2.DestroyTexture(entry.texture)
}
