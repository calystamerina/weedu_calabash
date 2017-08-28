devices = `adb devices`.split("\n")[1 .. -1]
deviceslist = Array.new
devices.each do |adbdev|
	adbdev.sub! "device", ''
	adbdev.sub! " ", ''
	deviceslist.push(adbdev)
end

File.open("build.properties", 'w') { |file| file.write("# Calabash Info
os = cmd
cmd for windows, /bin/sh for linux
argos = /c
/c for windows, -c for linux, -S for linux plus sudo
dateformat = yyyy-MM-dd HH:mm:ss
dateformatreport = yyyyMMdd-HHmmss
apk_dir = apk_name
screenshots_error = /screenshots/error/

# Device Info Run
1_device = device_1
1_rundev = rundev_1.txt
1_report_dev1 = ${apk_dir}_device_01_report

2_device = device_2
2_rundev = rundev_2.txt
2_report_dev2 = ${apk_dir}_device_02_report

# Additional Device
3_device = device_3
3_rundev = rundev_3.txt
3_report_dev3 = ${apk_dir}_device_03_report

# Device Info Re-Run
1_rerun = rerundev_1.txt
1_re_run_report_dev1 = rerun_${apk_dir}_device_01
2_rerun = rerundev_2.txt
2_re_run_report_dev2 = rerun_${apk_dir}_device_02
# Additional Device
3_rerun = rerundev_3.txt
3_re_run_report_dev3 = rerun_${apk_dir}_device_03")}

path = Dir["apk/*"]
pathstr = path.to_s
pathstr.gsub!(("]"),"")
pathstr.gsub!((".apk"),"")
pathstr.gsub!(('"'),"")
apkname = File.basename(pathstr, '.apk')

file_names = ["build.properties"]
file_names.each do |file_name|
	text = File.read(file_name)
	text.gsub!(("apk_name"),apkname)
	text.gsub!(("device_1"),deviceslist[0])
#	text.gsub!(("device_2"),deviceslist[1])
# Additional Device
#	text.gsub!(("device_3"),deviceslist[2])
	# To write changes to the file, use:
	File.open(file_name, "w") {|file| file.puts text }
end

