import "keywords"

globals.dss.formatPrint = function(s)
	defaultColor = text.color
	
	keys = dss.keywords
	
	// find colors
	colorOpened = false
	openedAt = 0
	closeAt = 0
	
	chars = s.len-1
	for i in range(0, chars)
		// Checking colors
		if s[i] == "%" then
			if i < chars-1 then
				if s[i+1] == "#" then
					text.color = s[i+1:i+8]
					colorOpened = true
					openedAt = i
					closeAt = 7
					continue
				else if s[i+1] == "{" then
					off = 1
					kw = ""
					
					while true
						off += 1
						if i+off > chars-1 then
							break
						else
							if s[i+off] == "}" then
								break
							else
								kw += s[i+off]
							end if
						end if
					end while
					
					colorOpened = true
					openedAt = i
					closeAt = off
					for k in keys
						if k.key == kw then
							if @k.value isa funcRef then
								v = k.value
								print v, ""
							else
								print k.value, ""
							end if
						end if
					end for
				else 
					text.color = defaultColor
				end if
				continue
			else
				text.color = defaultColor
			end if
			continue
		end if
		
		// Checking format
		if s[i] == "\" then 
			continue
		end if
		
		if i > 0 then
			if s[i-1] == "\" then
				if s[i] == "n" then
					print ""
					continue
				end if
			end if
		end if
		
		if colorOpened then
			if i - openedAt == closeAt then
				colorOpened = false
			end if
		else
			print s[i], ""
		end if
	end for
end function

globals.dss.ls = function(path=".")
	spaces = " "*80
	text.delimiter = char(13)
	
	dirInfo = file.info(path)
	if dirInfo == null then
		dss.printError "Invalid path: `" + path +"`"
		return
	end if
	
	lines = []
	
	if not dirInfo.isDirectory then
		files = [file.name(dirInfo.path)]
		dirInfo = file.info(file.parent(dirInfo.path))
	else
		files = file.children(dirInfo.path)
		if files.len == 0 then
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
			namecol = "`" + namecol + "`"
			sizecol = "     DIR"
		end if
		lines.push "  " + namecol + sizecol + "  " + finfo.date
	end for
	
	// Print results
	printed = 0
	for i in range(0, lines.len-1)
		line = "" + lines[i]
		dss.coloredPrint(line[:67], "#fab387")
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
end function

globals.dss.printError = function(s)
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

globals.dss.printJump = function(s, altColor="#94e2d5")
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

globals.dss.coloredPrint = function(s, altColor="#a6e3a1")
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

globals.dss.preset = function(id=null)
	presets = []
	
	// preset 1
	// -[/usr]
	// \
	// ->
	top    = "%#55ee55 -%#f38ba8[%{PWD}]%\n"
	middle = "%#55ee55| %{USER}\n"
	bottom = "%#55ee55 ->%"
	presets.push top + middle + bottom
	
	// preset 2
	// [User ~ /usr]
	// $>
	top    = "%#f38ba8[%%{USER}%#f38ba8 ~ %{PWD}]%\n"
	bottom = "%#a6e3a1$>%"
	presets.push top + bottom
	
	// preset 3
	// /usr ->
	prompt = "%#b4befe%{PWD}%%#fab387 ->%"
	presets.push prompt
	
	
	if id == null then
		txt  = "Set Preset: `preset NUMBER`\n"
		txt += "Show Presets: `preset show`\n"
		
		dss.formatPrint txt
	else if id isa string then
		if id == "show" or id == "help" then
			i = 1
			for p in presets
				print "-"
				print "preset " + i + ":"
				dss.formatPrint p
				print " "
				
				i += 1
			end for
		else if val(id) isa number then
			id = val(id)
			if id-1 <= presets.len-1 then
				dss.data.prompt = presets[id-1]
				dss.saveConfig
			else
				t = "%#f38ba8ERROR%: Number `" + id + "` is to large\n"
				t += "use a number between 1 and 3\n"
				dss.formatPrint t
			end if
		else
			dss.formatPrint "%#f38ba8ERROR%: Argument `" + id + "` not found\n"
		end if
	end if
end function

globals.dss.history = function(cmd="!")
	if not dss.hasIndex("recentFiles") then
		dss.recentFiles = []
		dss.formatPrint "%#89dceb=> No files opened \n"
		return
	end if
	
	if cmd == "!clear" then
		dss.recentFiles = []
		return
	else if cmd == "!" then
		if dss.recentFiles.len == 0 then
			dss.formatPrint "%#89dceb=> No files opened\n"
		else
			dss.formatPrint "%#89dceb=> Files in buffer:%\n"
			for i in range(0, dss.recentFiles.len-1)
				fol = dss.recentFiles[i].folder
				nam = dss.recentFiles[i].name
				print i + " -> " + fol + "/" + nam
			end for
		end if
	else
		if dss.recentFiles.len == 0 then
			dss.formatPrint "%#89dceb=> No files opened \n"
			return
		end if
		
		fileSearch = cmd[1:cmd.len].lower
		possibleFiles = []
		for i in range(0, dss.recentFiles.len-1)
			fname = dss.recentFiles[i].name.lower
			
			if fileSearch == fname[0:fileSearch.len] then
				possibleFiles.push i
			end if
		end for
		
		found = possibleFiles.len
		if found == 0 then
			dss.formatPrint "%#89dceb=> No files opened with name: " + fileSearch + "\n"
		else if found == 1 then
			cd dss.recentFiles[possibleFiles[0]].folder
			load dss.recentFiles[possibleFiles[0]].name
			edit
		else if found > 1 then
			dss.formatPrint "%#89dceb=> Multiple files opened with name: " + fileSearch + "\n"
			
			for i in possibleFiles
				fol = dss.recentFiles[i].folder
				nam = dss.recentFiles[i].name
				print i + " -> " + fol + "/" + nam
			end for
		end if
	end if
end function

globals.dss.changeUser = function(newUserName)
	if newUserName isa string then
		dss.data.user = newUserName
		dss.saveConfig
		dss.keywords[0].value = newUserName
	end if
end function

globals.dss.update = function
	cd "/usr/dss"
	
	print "Updating    [-----------]", ""
	wait 0.5
	text.column = 13
	
	progress = function
		print "#", ""
		wait 0.25
	end function
	
	progress
	
	// Downloading files
	fileServer = "https://github.com/David-Avila/The-Slow-Shell/raw/refs/heads/main/"
	dssFiles = ["dss.ms", "loader.ms", "utils.ms", "parser.ms", "keywords.ms"]
	
	progress
	
	for f in dssFiles	
		delete f
		
		p = fileServer + f
		raw = http.get(p)
		
		fl = file.open(f, "w+")
		fl.write raw
		fl.close
		
		progress
	end for
	
	progress
	progress
	progress
	progress
	print ""
	
	print "Reboot MiniMicro to apply update."
end function


