package engine

import "core:time" 

TimeState :: struct {
	start_tick: time.Tick,
	since_start: f64,
	tick_dt: f64,
	update_dt: f64,
	render_dt: f64,
}

update_time :: proc(state: ^TimeState) {
	duration := time.tick_since(state.start_tick)
	current_time := time.duration_seconds(duration)
	state.tick_dt = current_time - state.since_start
	state.since_start = current_time
	state.update_dt += state.tick_dt
	state.render_dt += state.tick_dt
}
