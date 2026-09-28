// The Slow Shell installer
print "Installing  [-----------]", ""
wait 0.5
text.column = 13

progress = function
	print "#", ""
	wait 0.25
end function

if not file.exists("/usr/dss") then
	mkdir "/usr/dss"
	mkdir "/usr/dss/templates"
	mkdir "/usr/dss/templates/default"
	mkdir "/usr/dss/templates/dsl"
end if

if not file.exists("/usr/.templates") then
	mkdir "/usr/.templates"
	mkdir "/usr/.templates/default"
	mkdir "/usr/.templates/dsl"
end if

cd "/usr/dss"

// Downloading files
fileServer = "https://github.com/David-Avila/The-Slow-Shell/raw/refs/heads/main/"
dssFiles = ["dss.ms", "loader.ms", "utils.ms", "parser.ms", "keywords.ms", "dspm.ms", "pkgs.ms"]

templates = {
"default":["main.ms", "startup.ms"], 
"dsl":["DSL_Lib.ms", "main.ms", "startup.ms"]}

for f in dssFiles
	p = fileServer + f
	raw = http.get(p)
	
	fl = file.open(f, "w+")
	fl.write raw
	fl.close
	progress
end for

for id in templates.indexes
	for tp in templates[id]
		p = fileServer + "templates/" + id + "/" + tp
		raw = http.get(p)
		
		f = "/usr/dss/templates/" + id + "/" + tp
		fl = file.open(f, "w+")
		fl.write raw
		fl.close
	end for
	progress
end for

p = "/usr/dss/templates/default"
for f in file.children(p)
	file.copy p+"/"+f, "/usr/.templates/default/" + f
end for

p = "/usr/dss/templates/dsl"
for f in file.children(p)
	file.copy p+"/"+f, "/usr/.templates/dsl/" + f
end for

// setting shell on startup file
cd "/usr"

progress

stF = file.open("startup.ms", "a+")
stF.write char(10)
stF.write char(10)
stF.write "env.shell = ""/usr/dss/dss"""
stF.close

progress

print ""

cd "/usr"

// greet message
text.color = "#89b4fa"
print "DSS", ""
text.color = "#cdd6f4"
print " was installed."

print "Type ", ""
text.color = "#89b4fa"
print "reboot", ""

text.color = "#cdd6f4"
print " and hit enter to apply changes."

