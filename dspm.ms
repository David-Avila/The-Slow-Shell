// DSPM: The Slow Package Manager

import "listUtil"
import "pkgs" // "packages list"

parse = function(args)
	if args == "" or args == null then
		printHelp
		return
	end if
	
	pkgList = args.split(" ")
	
	action = pkgList[0]
	pkgList.removeVal action
	
	if pkgList.len == 0 then
		print "No package name entered"
		return
	end if
	
	if action == "install" then
		install pkgList
	else
		print "Action '" + action + "' not recognized."
		printHelp
	end if
end function

printHelp = function
	print "DSPM: The Slow Package Manager"
	print "Usage:"
	print "dspm install [option] PACKAGE_NAME"
	print ""
	print "Options:"
	print "-fold : Saves package files inside a folder with the same name as the package. Useful when installing multiple packages in one project."
end function

install = function(pkgList)
	print "Looking for packages"
	wait 0.25
	
	toInstall = []
	
	fold = (pkgList[0] == "-fold")
	if fold then pkgList.removeVal pkgList[0]
	
	if pkgList.len == 0 then
		print "Packge name not supplied."
		return
	end if
	
	for p in pkgList[:]
		if not pkgs.find(p) then
			print "Package: " + p + " couldn't be found."
			pkgList.removeVal p
			continue
		end if
		
		toInstall.push pkgs.get(p)
	end for
	
	if toInstall.len == 0 then
		return
	end if
	
	print "The following packages will be installed:"
	for p in pkgList[:]
		print "-" + p
	end for
	
	k = input("Confirm? Type yes or no: ")
	
	ok = ["Y","y","Yes","yes", ""]
	
	print ""
	
	if ok.indexOf(k) != null then
		print "Installing packages"
		
		i = 0
		m = toInstall.len
		
		print "Installed [0/" + m + "]"
		for p in toInstall
			wait 0.35
			download p, fold
			
			i += 1
			
			text.row += 1
			print "Installed [" + i + "/" + m + "] " + p.name + "             "
		end for
		
		wait 0.35
		print "Packages installed!"
	else
		print "Aborting..."
	end if
end function

download = function(pkg, fold)
	if fold then
		mkdir pkg.name
		cd pkg.name
	end if
	
	for f in pkg.files
		p = pkg.url + f
		raw = http.get(p)
		
		fl = file.open(f, "w+")
		fl.write raw.utf8
		fl.close
	end for
	
	if fold then
		cd ".."
	end if
end function




