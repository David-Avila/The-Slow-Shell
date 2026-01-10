import "textUtil"

neofetch = function
	print
	printJump "  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  "
	printJump " @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ "
	printJump " @@`---`@@@@`---`@`-------`@`----`@@`----`@`-------`@@@ "
	printJump " @@`----`@@`----`@@@`---`@@@`----`@@`----`@@@`---`@@@@@ "
	printJump " @@`----------`@@@`---`@@@`----------`@@@`---`@@@@@ "
	printJump " @@`----------`@@@`---`@@@`----`@@`----`@@@`---`@@@@@ "
	printJump " @@`----`@@`----`@@@`---`@@@`----`@@`----`@@@`---`@@@@@ "
	printJump " @@`----`@@`----`@`-------`@`----`@@`----`@`-------`@@@ "
	printJump " @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ "
	printJump " @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ "
	printJump " @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ "
	printJump " @@`---`@@`---`@`---`@@`-----`@`-----`@@@@`------`@@@@@ "
	printJump " @@`--------`@`---`@`---`@@@@`--`@`--`@@`---`@@@@`---`@@@ "
	printJump " @@`---`@@`---`@`---`@`--`@@@@@`----`@@@`--`@@@@@@`--`@@@ "
	printJump " @@`---`@@`---`@`---`@`---`@@@@`--`@`--`@@`---`@@@@`---`@@@ "
	printJump " @@`---`@@`---`@`---`@@`-----`@`--`@@`--`@@@`------`@@@@@ "
	printJump " @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ "
	printJump "  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  "
	print
end function

printError = function(s)
	defaultColor = text.color
	colors = ["#fab387", "#f38ba8"]
	
	text.color = colors[0]
	
	which = 0
	while len(s)
		pos = s.indexOf("`")
		if pos == null then
			text.color = colors[0]
			print s, ""
			break
		end if
		print s[:pos], ""
		which = not which
		text.color = colors[which]
		s = s[pos+1:]
	end while
	text.color = defaultColor
	print
end function

printJump = function(s, altColor="#94e2d5")
	defaultColor = text.color
	
	colors = ["#fab387", altColor]
	text.color = colors[0]
	
	which = 0
	while len(s)
		pos = s.indexOf("`")
		if pos == null then
			text.color = colors[0]
			print s, ""
			break
		end if
		print s[:pos], ""
		which = not which
		text.color = colors[which]
		s = s[pos+1:]
	end while
	text.color = defaultColor
	print
end function

coloredPrint = function(s, altColor="#a6e3a1")
	defaultColor = text.color
	
	colors = [text.color, altColor]
	text.color = colors[0]
	
	which = 0
	while len(s)
		pos = s.indexOf("`")
		if pos == null then
			text.color = colors[0]
			print s, ""
			break
		end if
		print s[:pos], ""
		which = not which
		text.color = colors[which]
		s = s[pos+1:]
	end while
	text.color = defaultColor
end function

ls = function(path=".")
	spaces = " "*80
	text.delimiter = char(13)
	
	dirInfo = file.info(path)
	if dirInfo == null then
		printError "Invalid path: `" + path +"`"
		return
	end if
	
	lines = [dirInfo.path + " : "]	
	
	if not dirInfo.isDirectory then
		files = [file.name(dirInfo.path)]
		dirInfo = file.info(file.parent(dirInfo.path))
	else
		files = file.children(dirInfo.path)
		if files.len == 0 then
			print lines[0]
			print ".."
			return
		end if
	end if
	
	files.sort
	for i in range(0, files.len-1)
		finfo = file.info(file.child(dirInfo.path,files[i]))
		if finfo == null then
			lines.push "file.info failed on: " + file.child(path, files[i])
			continue
		end if
		namecol = (files[i]+spaces)[:32]
		sizecol = (spaces+finfo.size)[-8:]
		if finfo.isDirectory then 
			namecol = "`" + (files[i]+spaces)[:32] + "`"
			sizecol = "     DIR"
		end if
		lines.push "  " + namecol + sizecol + "  " + finfo.date
	end for
	
	// Print results
	printed = 0
	for i in range(0, lines.len-1)
		line = "" + lines[i]
		coloredPrint(line[:67], "#fab387")
		if line.len > 67 then print line[67], "" else print
		printed = printed + 1
		if printed > 24 and i+1 < lines.len then
			text.inverse = true
			print "[" + (lines.len - i - 1) + " more]", ""
			text.inverse = false
			done = false
			while not done
				k = key.get
				ikey = code(k)
				if ikey == 27 or k == "q" or k == "Q" then done = true
				if ikey == 10 or ikey == 13 or ikey == 3 or k == " " then break
				yield
			end while
			text.column = 0
			print " " * 32
			text.column = 0
			if done then break
			printed = 0
		end if
	end for
	
	
	text.color = "#f38ba8"
end function

bash = function
	load "/usr/Shell/shell"
	edit
end function

exec = function(f)
	load f
	run
end function

editor = function
	load "/sys/demo/levelEditor"
	run
end function

cRun = function
	print "Works"
end function

commands = {
  "ls": @ls,
  "l": @ls,
  "editor": @editor,
  "cd": @cd,
  "echo": @print,
  "cat": @view,
  "rm" : @delete,
  "print": @pprint,
  "load" : @load,
  "save" : @save,
  "reboot": @reboot,
  "reset" : @reset,
  "clear": @clear,
  "mkdir": @mkdir,
  "edit": @edit,
  "exit" : @exit,
  "bash": @bash,
  "neofetch": @neofetch,
  "run": @run}

_shell = function
	while true
		gfx.clear "#1e1e2e"
		text.color = "#f38ba8"
		coloredPrint("[`dslower` ~ " + pwd + "]", "#cba6f7")
		
		text.color = "#b4befe"
		line = input("$: ")
		
		text.color = "#a6adc8"
		line = line.split(" ")
		
		cmd = line[0]
		arg = ""
		if line.len > 1 then
			arg = line[1]
		end if
		
		if cmd[:2] == "./" then
			commandFound = true
			exec cmd[2:]
		else
			commandFound = false
			for c in commands
				if c.key == cmd then
					if arg == "" then
						c.value
					else
						if c.key == "edit" then
							load arg
							edit
						else
							c.value arg
						end if
					end if
					commandFound = true
				end if
			end for
			
			if cmd == "exec" then
				commandFound = true
				exec arg
			end if
		end if
		
		if not commandFound then
			printError "Command `'" + cmd + "'` not found"	
		end if
	end while
end function

_shell