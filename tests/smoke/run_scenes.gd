extends SceneTree
# Loads every .tscn, instantiates it, ticks 60 frames, fails on any error.
 
var _failed := false
 
func _init() -> void:
	var scenes := _find_scenes("res://scenes")
	for path in scenes:
		var packed := load(path)
		if packed == null:
			push_error("LOAD FAIL: %s" % path); _failed = true; continue
		var inst = packed.instantiate()
		root.add_child(inst)
		for i in 60:
			await process_frame
		inst.queue_free()
		await process_frame
	quit(1 if _failed else 0)
 
func _find_scenes(dir_path: String) -> PackedStringArray:
	var out := PackedStringArray()
	var dir := DirAccess.open(dir_path)
	if dir == null: return out
	dir.list_dir_begin()
	var name := dir.get_next()
	while name != "":
		var full := dir_path.path_join(name)
		if dir.current_is_dir(): out.append_array(_find_scenes(full))
		elif name.ends_with(".tscn"): out.append(full)
		name = dir.get_next()
	return out
