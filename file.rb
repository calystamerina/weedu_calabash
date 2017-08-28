data = ""
apk = "apk/*"
oddeven = 0
screenshots_error = "screenshots/error/"
devicesnum = 0
filename = "list-features.txt"
featurestr = ""
featurelistnum = 0
featurelistnumperdev = 0
devicelist = Array.new
featurelist = Array.new
multithread = Array.new
remultithread = Array.new
featuredevlist =  Array.new

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

ARGV.each do|adb|
	system("adb connect #{adb}")
	# sleep(5)
	devicelist.push(adb)
	puts "first adb : #{adb}"
end

if File.file?(filename) == false
	generatefeaturelist(filename)
end

def filenamefeature (fileinput)
	fstrlist = Array.new
	File.open(fileinput, "r") do |f|
	feature = ""
	  f.each_line do |line|
		line.sub! "\n", ' '
		if line.include? "#"
	   	else
	   		puts line
	   		fstrlist.push(line) 
		end
	  end
	end
	fstrlist.sort!  
	return fstrlist
end

devices = `adb devices`.split("\n")[1 .. -1]
devices.each do |adbdev|
	adbdev.sub! "device", ''
	adbdev.sub! " ", ''
	if devicelist[0].to_s.length != 0
		if devicelist[0].strip == adbdev.strip
		else
			devicelist.push(adbdev)
		end
	else
		devicelist.push(adbdev)
	end
end

featurelist = filenamefeature(filename)
devicesnum = devicelist.length
featurelistnum = featurelist.length
featurelistnumperdev = featurelistnum/devicesnum

if featurelistnum%devicesnum == 1
	oddeven = 1
	featurelistnumperdev = featurelistnumperdev + 1
end

puts "Total feature : #{featurelistnum}"
puts "Total per dev : #{featurelistnumperdev}"
puts "Total device : #{devicesnum}"
status = "false"

if devicesnum > 0
	flag = 0
	ctr = 0
	num = 0
	for i in 0..featurelistnum +1 
		if flag < featurelistnumperdev
			featurestr = featurestr + featurelist[num].to_s + " "
			flag = flag + 1
			num = num + 1
		else
			if featurestr.include? "login"
			else
				featurestr = "features/01.login/login.feature " + featurestr 
			end
			featuredevlist[ctr] = featurestr
			featurestr = ""
			ctr = ctr + 1
			flag = 0
		end
	end
	
	if oddeven == 1
		featuredevlist[ctr] = "features/01.login/login.feature " + featurestr
	end

	# Multithreads
	for i in 0..devicesnum-1
		multithread.push(Thread.new{system ("calabash-android run #{apk} #{featuredevlist[i]}  screenshot_path=#{screenshots_error} -f rerun --out rerundev_#{i}.txt --format pretty -verbose --format html --out reports/automated_report_dev_#{i}.html ADB_DEVICE_ARG=#{devicelist[i]}")})
		sleep(60)
	end
    
	# Multithreads Invoke
	for i in 0..devicesnum-1
		multithread[i].join
		sleep(60)
	end
    
	system("adb devices")
	# Clear Array
	multithread.clear
    
	# Rerun Feature Multithreads 
	for i in 0..devicesnum-1
		featurestr = ""
		system("adb connect #{devicelist[i]}")
		featurelist = filenamefeature("rerundev_#{i}.txt")
		for i in 0..featurelist.length
			featurestr = featurestr + featurelist[i].to_s
		end
		# puts "length : "
		# puts featurestr.length
		if featurestr.length == 0
			puts "Device #{devicelist[i]} All Schenario ok no need to rerun"
		else
			featurestr = "features/01.login/login.feature " + featurestr
			remultithread.push(Thread.new{system ("calabash-android run #{apk} #{featurestr}  screenshot_path=#{screenshots_error} --format pretty -verbose --format html --out reports/rerun_automated_report_dev_#{i}.html ADB_DEVICE_ARG=#{devicelist[i]}")})
		end
		sleep(60)
	end
    
	# Rerun Feature Multithreads Invoke
	for i in 0..devicesnum-1
		remultithread[i].join
		sleep(60)
	end
end
