package displaytree

import "core:container/queue"
import "vendor:sdl2"

import "src:components/graphics"
import "src:systems/tilemap"

Tree :: struct {
	root: Node,
}

Node :: struct {
	data: DisplayBlock,
	children: queue.Queue(Node),
}

init_tree :: proc(tree: ^Tree) {
	queue.init(&tree.root.children)
}

add :: proc {
	add_empty,
	add_sprite,
	add_tilemap,
}

add_empty :: proc(parent: ^Node) {
	queue.push_back(
		&parent.children,
		Node{
			data = nil,
		},
	)
}

add_sprite :: proc(parent: ^Node, sprite: ^graphics.Sprite) {
	queue.push(
		&parent.children,
		Node{
			data = sprite,
		},
	)
}

add_tilemap :: proc(parent: ^Node, tiles: ^tilemap.ImageTilemap) {
	queue.push(
		&parent.children,
		Node{
			data = tiles,
		},
	)
}

DisplayBlock :: union {
	^tilemap.ImageTilemap,
	^graphics.Sprite,
}

render_node :: proc(renderer: ^sdl2.Renderer, node: Node) {
	render_display_block(renderer, node.data)
	for child in node.children.data {
		render_node(renderer, child)
	}
}

render_display_block :: proc(renderer: ^sdl2.Renderer, block: DisplayBlock) {
	#partial switch v in block {
	case ^tilemap.ImageTilemap:
		render_tilemap(renderer, block.(^tilemap.ImageTilemap))
	case ^graphics.Sprite:
		render_sprite(renderer, block.(^graphics.Sprite))
	}
}

render_tilemap :: proc(renderer: ^sdl2.Renderer, tiles: ^tilemap.ImageTilemap) {
	for &image in tiles.components {
		sdl2.RenderCopy(renderer, image.source, image.clip, image.dest)
	}
}

render_sprite :: proc(renderer: ^sdl2.Renderer, sprite: ^graphics.Sprite) {
	sdl2.RenderCopy(renderer, sprite.image.source, sprite.image.clip, sprite.image.dest)
}
