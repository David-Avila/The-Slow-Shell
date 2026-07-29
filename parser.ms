echo = function(args)
	print args
end function

editFile = function(f)
	if not f then
		f = globals._sourceFile
		
		found = false
		for i in dss.recentFiles
			if f == i.name then
				found = true
				break
			end if
		end for
		
		if not found then
			fname = file.name(f)
			fdir = file.info(f).path[0:-fname.len-1]
			dss.recentFiles.push {"folder": fdir, "name": fname}
		end if
	else
		found = false
		for i in dss.recentFiles
			if f == i.name then
				found = true
				break
			end if
		end for
		
		if not found then
			if f[-3:f.len] != ".ms" then
				f += ".ms"
			end if
			
			fname = file.name(f)
			fdir = file.info(f).path[0:-fname.len-1]
			dss.recentFiles.push {"folder": fdir, "name": fname}
		end if
	end if
	
	load f
	edit
end function

globals.dss.cReset = function
	reset
	
	env.importPaths.push "/usr/dss"
	
	import "dss"
	setupDSS
end function

globals.dss.help = function
	dss.formatPrint "%#cdd6f4 DSS % help:\n"
	print "==> Addons:"
	dss.formatPrint "   ==> %#a6e3a1 preset %: Change the terminal theme\n"
	dss.formatPrint "   ==> %#a6e3a1 ! %: Access recent files buffer"
	dss.formatPrint " . For more type %#a6e3a1!help%.\n"
	dss.formatPrint "%#cdd6f4 MiniMicro % help:\n"
	help
end function

globals.dss.parse = function(cmd, argc, argv)
	built_in = {
	  "run": @run,
	  "edit": @editFile,
	  "clear": @clear,
	  "load": @load,
	  "dir": @dir,
	  "cd": @cd,
	  "delete": @delete,
	  "save": @save,
	  "reboot": @reboot,
	  "mkdir": @mkdir,
	  "view": @view,
	  "reset": @dss.cReset,
	  "help": @dss.help}
	
	addons = {
	  "echo": @echo,
	  "fprint": @dss.formatPrint,
	  "ls": @dss.ls,
	  "l": @dss.ls,
	  "cat": @view,
	  "preset": @dss.preset,
	  "chuser": @dss.changeUser,
	  "update": @dss.update}
	
	prop = null
	
	if cmd.indexOf(".") != null then
		spl = cmd.split(".")
		cmd = spl[0]
		prop = spl[1]
	end if
	
	checkPropF = function(fn, pr)
		if pr == null then
			print @fn
		else
			print @fn[pr]
		end if
	end function
	
	checkProp = function(fn, args, pr)
		res = null
		if pr == null then
			if args.len > 0 then
				res = fn(args.join(" "))
			else
				res = fn
			end if
		else
			if args.len > 0 then
				fn[pr](args.join(" "))
			else
				res = fn[pr]
			end if
		end if
		
		if res != null then
			pprint res
		end if
	end function
	
	// check for func reference
	if cmd[0] == "@" then
		cmd = cmd[1:cmd.len]
		if built_in.hasIndex(cmd) then
			checkPropF @built_in[cmd], prop
		else if intrinsics.hasIndex(cmd) then
			checkPropF @intrinsics[cmd], prop
		else if addons.hasIndex(cmd) then
			checkPropF @addons[cmd], prop
		else
			print "ERROR: Command '" + cmd + "' not found"
		end if
	else if cmd[0] == "!" then
		dss.history cmd
	else
		if built_in.hasIndex(cmd) then
			checkProp @built_in[cmd], argv, prop
		else if intrinsics.hasIndex(cmd) then
			checkProp @intrinsics[cmd], argv, prop
		else if addons.hasIndex(cmd) then
			checkProp @addons[cmd], argv, prop
		else
			print "ERROR: Command '" + cmd + "' not found"
		end if
	end if
end function
