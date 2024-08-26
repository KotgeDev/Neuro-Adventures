extends Node
class_name RequestBody


static func serialize(type: String, data: Dictionary) -> String: 
	var dict = {
		"type": type,
		"data": data
	}
	
	return JSON.stringify(dict)
