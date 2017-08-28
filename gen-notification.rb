require 'net/smtp'

ARGV.each do|filenamegen|
	puts "variable : #{filenamegen}"
	
	message = <<MESSAGE_END
From: Automated <agus@kudo.co.id>
To: Automated <agus@kudo.co.id>
Subject: [Kudo Mobile Apps] Automation Testing 
#{filenamegen} Automation Tested by Calabash 

MESSAGE_END

Net::SMTP.start('in-v3.mailjet.com',587,'mailjet.com','705f2faa6ac5dbf9b5fd66508bfe0956','ed968edb8a9337792c45d9d6796e25d3') do |smtp|
  smtp.send_message message, 'agus@kudo.co.id', 
                             'agus@kudo.co.id'
end
end