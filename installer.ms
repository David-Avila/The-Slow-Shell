// The Slow Shell installer
print "Installing  [-----------]", ""
wait 0.5
text.column = 13

progress = function
	print "#", ""
	wait 0.25
end function

progress

if not file.exists("/usr/dss") then
	mkdir "/usr/dss"
end if

progress

cd "/usr/dss"

progress
// Downloading files
fileServer = "https://github.com/David-Avila/The-Slow-Shell/raw/refs/heads/main/"
dssFiles = ["dss.ms", "loader.ms", "utils.ms", "parser.ms", "keywords.ms"]

progress

for f in dssFiles	
	progress
	
	p = fileServer + f
	raw = http.get(p)
	
	fl = file.open(f, "w+")
	fl.write raw
	fl.close
end for


// setting shell on startup file
cd "/usr"

progress

stF = file.open("startup.ms", "a+")
stF.write char(13)
stF.write char(13)
stF.write "env.shell = ""/usr/dss/dss"""
stF.close

progress

print ""

cd "/"

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

