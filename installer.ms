// The Slow Shell installer
if not file.exists("/usr/dss") then
	mkdir "/usr/dss"
end if

cd "/usr/dss"

// Downloading files
fileServer = "https://github.com/David-Avila/The-Slow-Shell/raw/refs/heads/main/"
dssFiles = ["dss.ms", "loader.ms", "utils.ms", "parser.ms", "keywords.ms"]

for f in dssFiles	
	p = fileServer + f
	raw = http.get(p)
	
	fl = file.open(f, "w+")
	fl.write raw.utf8
	fl.close
end for


// setting shell on startup file
cd "/usr"

stF = file.open("startup.ms", "a+")
stF.write char(13)
stF.write "env.shell = ""/usr/dss/dss"""
stF.close

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

