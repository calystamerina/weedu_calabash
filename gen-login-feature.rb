ARGV.each do|filenamegen|
	# puts "variable : #{filenamegen}"
	file_names = [filenamegen]
	file_names.each do |file_name|
	  text = File.read(file_name)
	  if text.length > 0
		  text = "features/01.login/login.feature:5 " + text 
		  text.gsub!(("["),"")
		  text.gsub!((","),"")
		  text.gsub!(('"'),"")
		  #text.gsub!((' '),"\n")
		  text.gsub!((']'),"")
		  # To write changes to the file, use:
		  File.open(file_name, "w") {|file| file.puts text }
	   end
	end
end

