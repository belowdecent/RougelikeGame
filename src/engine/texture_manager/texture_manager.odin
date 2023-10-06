package texture_manager

import "vendor:sdl2"
import "vendor:sdl2/image"

import "core:path/slashpath"
import "core:strings"

// change to use better paths
root :: "assets"

Manager :: struct {
	static_textures: TextureTable,
	dynamic_textures: TextureTable,
	renderer: ^sdl2.Renderer,
}

init :: proc(renderer: ^sdl2.Renderer) -> Manager {
	return Manager{
		static_textures = make(TextureTable),
		dynamic_textures = make(TextureTable),
		renderer = renderer,
	}
}

load_static :: proc(texture_manager: ^Manager, path: string) -> Entry{
	texture, ok := texture_manager.static_textures[path]
	if (!ok) {
		path := slashpath.join([]string{root, path})

		texture = new_entry(texture_manager.renderer, strings.clone_to_cstring(path))
		texture_manager.static_textures[path] = texture
	}

	return texture
}

unload :: proc(texture_manager: ^Manager) {
	for key, value in texture_manager.dynamic_textures {
		destroy_entry(value)
		delete_key(&texture_manager.dynamic_textures, key)
	}
}

destroy :: proc(texture_manager: ^Manager) {
	for key, value in texture_manager.static_textures {
		destroy_entry(value)
	}
	for key, value in texture_manager.dynamic_textures {
		destroy_entry(value)
	}

	delete(texture_manager.static_textures)
	delete(texture_manager.dynamic_textures)
}

