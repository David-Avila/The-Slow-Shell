
if not globals.hasIndex("dss") then
	globals.dss = {}
	
	// default data
	dss.recentFiles = []
	dss.data = {}
	dss.data.user = "user"
	dss.data.newLine = true
	dss.data.prompt = "%#55ee55$->%"
	dss.data.defaultConfigFile = "/usr/.config/dss_conf.ms"
	dss.data.configFile = "/usr/.config/dss_conf.ms"
end if

if not env.importPaths.hasIndex("/usr/dss") then
	env.importPaths.push "/usr/dss"
end if

import "loader"
dss.loadConfig

import "utils"
import "parser"

globals.setupDSS = function
	if not globals.hasIndex("dss") then
		globals.dss = {}
	end if
	
	if not env.importPaths.hasIndex("/usr/dss") then
		env.importPaths.push "/usr/dss"
	end if
	
	// default data
	if not globals.dss.hasIndex("recentFiles") then
		globals.dss.recentFiles = []
	end if
	
	globals.dss.data = {}
	dss.data.user = "user"
	dss.data.newLine = true
	dss.data.prompt = "%#55ee55$->%"
	dss.data.defaultConfigFile = "/usr/.config/dss_conf.ms"
	dss.data.configFile = "/usr/.config/dss_conf.ms"
	
	dss.data = dss.loadConfig
	return dss.data
end function

globals.setupDSS

start = function
	text.color = "#cdd6f4"
	
	if not globals.hasIndex("dss") then
		globals.setupDSS
	end if
	
	dss.data = globals.setupDSS
	debug_on = false
	
	while true
		gfx.clear "#1e1e2e"
		
		// check new line
		if val(dss.data.newLine) then
			print ""
		end if
		
		// Print prompt
		dss.formatPrint dss.data.prompt
		
		key.clear
		text.color = "#b4befe"
		line = input
		// todo: trim spaces
		
		if line == "" then
			continue
		end if
		
		line = line.split(" ")
		
		cmd = line[0]
		argc = line.len-1
		argv = []
		
		if argc > 0 then 
			for i in range(1, argc)
				argv.push line[i]
			end for
		end if
		
		if debug_on then
			print "/**** DEBUG *****"
			print "Comand: " + cmd
			print "Args(" + argc + "): " + argv
			print "****************/"
		end if
		
		if cmd == "exit" then 
			break
		else
			dss.parse cmd, argc, argv
		end if
	end while
end function

start