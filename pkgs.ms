globals._dspmPkgRepo = []

_add = function(name, url, files)
	p = {}
	p.name = name
	p.url = url
	p.files = files
	
	globals._dspmPkgRepo.push p
end function

_add "DSL", "https://github.com/David-Avila/The-Slow-Library/raw/refs/heads/main/", ["DSL_Lib.ms"]

find = function(pkg)
	for p in globals._dspmPkgRepo
		if p.name == pkg then
			return true
		end if
	end for
	
	return false
end function

get = function(pkg)
	for p in globals._dspmPkgRepo
		if p.name == pkg then
			return p
		end if
	end for
end function