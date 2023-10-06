package ecs

import "core:container/queue"

Component_List_State :: struct {
	free_indicies: queue.Queue(u32),
	next_index: u32
}
