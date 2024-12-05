extends Node

func _ready() -> void:
	pass
	#var my_IP = "32.556.240.199"
	
	#var code = IPtoCode(my_IP)
	#print(my_IP)
	#print(code)
	#print(codeToIP(code))
	
	

func IPtoCode(address: String) -> String:
	var chunk: String = ""
	var code: String = ""
	var count := 1

	
	for i in address:
		if i == ".":
			var int_chunk = int(chunk)
			int_chunk ^= 255
			if code.length() > 0:
				code += "-"
			code += str(int_chunk)
			chunk = ""
			count += 1
			continue
		elif count == address.length():
			chunk += i
			var int_chunk = int(chunk)
			int_chunk ^= 255
			code += "-" + str(int_chunk)
			
		
		chunk += i
		count += 1
		
	return code
	
func codeToIP(code: String) -> String:
	var chunk: String = ""
	var address: String = ""
	var count := 1
	
	for i in code:
		if i == "-":
			var int_chunk = int(chunk)
			int_chunk ^= 255
			if address.length() > 0:
				address += "."
			address += str(int_chunk)
			chunk = ""
			count += 1
			continue
		elif count == code.length():
			chunk += i
			var int_chunk = int(chunk)
			int_chunk ^= 255
			address += "." + str(int_chunk)
			
		chunk += i
		count += 1
	
	return address
