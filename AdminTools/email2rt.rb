#!/bin/ruby

#This script is useful for those pesky users who try to bypass the ticketing system by email you directly.
#Simply move these emails, which should be tickets, into a special folder in your inbox and
#Set it to run in your crontab every 15 minutes to automagically move these to your ticketing system, and "send" a polite email to the client with no effort.
#Long live laziness!

# Uses Ruby's built in imap and smtp modules.
# Fill in username password and IMAP/SMTP address

require 'net/imap'
require 'net/smtp'


USERNAME = "" #IMAP/SMTP UN
PASSWORD = "" #IMAP/SMTP PW
FDQNEMAILSERVER = "" #FDQN of your email server ie "mail.company.edu"

DOMAIN = "" # "organization.edu"
TICKETSYSTEMEMAIL = "" # The email address of your ticketing system

#Opens IMAP connection to email account
#scans emails in "Inbox/.toRT" for emails
#Creates struct of each email info for sendEmail function
def getmsgs(username, password)
	targetMailBox="Inbox/.toRT"
	moveToMailBox="Inbox/-.inrt"
	localEmail = Struct.new(:bodyArray, :nameArray, :subjectArray)
	localBodyArray = []
	localNameArray = []
	localSubjectArray = []
        at="@"

        imap = Net::IMAP.new(FDQNEMAILSERVER,993,true)
        imap.login(username, password)
        imap.select("Inbox/.toRT")
        imap.search(["ALL"]).each do |msg|
                envelope = imap.fetch(msg, "ENVELOPE")[0].attr["ENVELOPE"]
                sender = envelope.from[0].mailbox
                host = envelope.from[0].host
                emailaddress = sender + at + host
                body = imap.fetch(msg,'BODY[TEXT]')[0].attr['BODY[TEXT]']
		subject = envelope.subject
		
		localSubjectArray.push(subject)
                localBodyArray.push(body)
                localNameArray.push(emailaddress)

        	imap.copy(msg, moveToMailBox)
		imap.store(msg, "+FLAGS", [:Deleted])

        end
	imap.expunge

        imap.logout
        imap.disconnect
	
	rtnStructEmail = localEmail.new(localBodyArray, localNameArray, localSubjectArray)
	
	return rtnStructEmail
end

#Creates SMTP connection
#Creates email response for each email retrieved and
#Uses the info from the Struct to personalize each message
def sendEmail(username, password, emailStruct)
        smtp = Net::SMTP.new FDQNEMAILSERVER, 587
        smtp.enable_starttls
        smtp.start(DOMAIN,username, password, :login)
        $i = 0
        $num = emailStruct.bodyArray.length
                while $i < $num do
			msg = "Subject: RE: #{emailStruct.subjectArray[$i]} \n\n requestor:#{emailStruct.nameArray[$i]} \n\n\n Hello, \n\nI've recieved your message.  The best way to receive assistance for technical support (Moodle, email, classroom assistance) is to open a support ticket by emailing itshelp@aurora.edu.  No worries this time,  I've forwarded your message there already. \n\n There's no action needed by you at this time; you'll hear back from us soon! \n\n  Orignal Message: \n #{emailStruct.bodyArray[$i]}"
                smtp.send_message(msg,"#{emailStruct.nameArray[$i]}", TICKETSYSTEMEMAIL) #send to multiple addresses by making an array for second argument)
                        $i +=1
                end
end


Email = getmsgs(USERNAME,PASSWORD)
sendEmail(USERNAME,PASSWORD, Email)
