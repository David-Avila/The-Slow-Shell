clear

// Settup dsl lib
import "DSL_Lib"
dsl.importPath

// Runtime
rt = {}
dsl.addFSM rt

// States definition
rt.addState "run"

// Main loop
rt.changeState "run"
while dsl.running
  dsl.update
  rt.updateStates

  if dsl.keyPressed("escape") then dsl.stop
	
	yield
end while
