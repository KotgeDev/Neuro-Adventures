extends Control
class_name CloseablePanel
## Emits close_panel and
## becomes invisible when tab / esc is pressed 


signal close_panel

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("menu"):
		close()  

## Call function whenever user wants to close this panel 
## Override function to add further functionality 
## when closing the panel  	
func close() -> void:
	self.visible = false 
	close_panel.emit() 
