package ecs

import "core:mem"
import "core:container/queue"

// Manages components and relations to those components
EC_Manager :: struct {
	entity_counter: Entity,

	ec_map: map[Entity]map[typeid]u32,
	
	component_list_states: map[typeid]Component_List_State,
	component_map: map[typeid]mem.Raw_Slice,
}

new_entity :: proc(manager: ^EC_Manager) -> Entity {
	defer manager.entity_counter += 1
	return manager.entity_counter
}

// Creates a new component list or if one exists does nothing and returns not ok
register_component_type :: proc(
	$T: typeid, 
	manager: ^EC_Manager, 
	$Size: u32
) -> (components: []T, already_exists: bool) #optional_ok {
	components, already_exists = get_components(T, manager)
	if (already_exists) {
		return components, false
	} else {
		component_list := make([]T, Size)
		manager.component_map[T] = transmute(mem.Raw_Slice) component_list
		manager.component_list_states[T] = Component_List_State{}
		return components, true
	}
}

// Returns a component list
get_components :: proc(
	$T: typeid, 
	manager: ^EC_Manager
) -> (components: []T, ok: bool) #optional_ok {
	raw_components: mem.Raw_Slice
	raw_components, ok = manager.component_map[T]

	if (!ok) {
		return nil, ok
	} else {
		return transmute([]T) raw_components, ok
	}
}

add_component :: proc{add_component_empty, add_component_existing}

add_component_empty :: proc(
	entity: Entity, 
	$T: typeid, 
	manager: ^EC_Manager
) -> ^T {
	using queue
	
	list_state := &manager.component_list_states[T]
	components := get_components(T, manager)
	index: u32
	
	index = list_state.next_index
	list_state.next_index += 1
	
	if (manager.ec_map[entity] == nil) {
		manager.ec_map[entity] = make(map[typeid]u32)
	}
	
	(&manager.ec_map[entity])^[T] = index

	components[index] = T{}
	return &components[index]
}

add_component_existing :: proc(
	entity: Entity, 
	component: $T, 
	manager: ^EC_Manager
) -> ^T {
	using queue
	
	list_state := &manager.component_list_states[T]
	components := get_components(T, manager)
	index: u32
	
	index = list_state.next_index
	list_state.next_index += 1
	
	if (manager.ec_map[entity] == nil) {
		manager.ec_map[entity] = make(map[typeid]u32)
	}
	
	(&manager.ec_map[entity])^[T] = index

	components[index] = component
	return &components[index]
}

// Returns a component of T bound to an Entity
get_component :: proc(
	$T: typeid, 
	entity: Entity, 
	manager: ^EC_Manager
) -> (component: ^T, ok: bool) #optional_ok {
	components: []T
	components, ok = get_components(T, manager)
	if (!ok) {
		return nil, ok
	}

	entity_components: ^map[typeid]u32
	entity_components, ok = &manager.ec_map[entity]
	if (!ok) {
		return nil, ok
	}
	
	index: u32
	index, ok = entity_components[T]
	if (!ok || index >= u32(len(components))) {
		return nil, false
	}

	return &(components[index]), true
}

