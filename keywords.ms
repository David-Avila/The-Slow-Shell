import "dateTime"

getTime = function
	return dateTime.now("HH:mm")
end function

getDate = function
	return dateTime.now("dd-MM")
end function

globals.dss.keywords = [
  {"key" : "USER", "value": globals.dss.data.user},
  {"key" : "PWD" , "value": @pwd},
  {"key" : "TIME" , "value": @getTime},
  {"key" : "DATE" , "value": @getDate}]