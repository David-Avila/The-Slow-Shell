// Config and file loader
globals.dss.loadConfig = function
	// check for .config folder
	if not file.exists("/usr/.config") then
		file.makedir "/usr/.config"
	else
		if not file.info("/usr/.config").isDirectory then
			file.makedir "/usr/.config"			
		end if
	end if
	
	// check for config file
	if not file.exists(dss.data.configFile) then
		dss.saveConfig(dss.data.configFile)
	end if
	
	// load data
	if not env.importPaths.hasIndex("/usr/.config") then
		env.importPaths.push "/usr/.config"
	end if
	
	import "dss_conf"
	
	for k in dss_conf.custom
		dss.data[k.key] = k.value
	end for
	
	return dss.data
end function

globals.dss.saveConfig = function(fPath)
	lines = []
	lines.push "custom = {}"
	for prop in dss.data
		lines.push "custom." + prop.key + " = """ + prop.value + """"
	end for
	
	file.writeLines(dss.data.configFile, lines)
end function





