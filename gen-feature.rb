def generatefeaturelist(filenamegen)
	rbfiles = File.join("**", "*.feature")
	strfile = Dir.glob(rbfiles).to_s
	f = File.new(filenamegen, "w")
	f.write(strfile)
	f.close  

	file_names = [filenamegen]
	file_names.each do |file_name|
	  text = File.read(file_name)
	  text.gsub!(("["),"")
	  text.gsub!((","),"")
	  text.gsub!(('"'),"")
	  text.gsub!((' '),"\n")
	  text.gsub!((']'),"")

	  # To write changes to the file, use:
	  File.open(file_name, "w") {|file| file.puts text }
	end
end
generatefeaturelist("feature-list.txt")