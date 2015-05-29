#encoding:gbk
require 'net/pop'
require 'mysql2'
require 'base64'
require 'json'
errlog=File.open('transferMail_err.log','a') #运行错误日志
begin
	json = File.read('config1.txt') 
	conf = JSON.parse(json)
	client = Mysql2::Client.new(:host => conf["mysql"]["host"], :username => conf["mysql"]["username"], :password => conf["mysql"]["password"]) 
rescue Exception => e
	puts e.inspect
	errlog.puts("#{Time.new}:#{e.inspect}")
	exit
end
mailAccounts = conf["mailAccountToMobile"] #邮箱与手机对应信息
mailServer = conf["mailServer"]["host"]
port = conf["mailServer"]["port"]
mailAccounts.each {|acc|
    mobiles = acc["mobile"]
	account = acc["account"]
	passwd = acc["password"]
	begin
		#转发邮件至MySQL数据库，只处理text/plain邮件
		Net::POP3.delete_all(mailServer, port, account, passwd) do |mail|
			msg = mail.pop #整封邮件
			head = mail.header.chop #邮件头部分
			content1 = msg.partition(head)[2] #截取邮件内容
			content2 = client.escape(Base64.decode64(content1)) #解码和SQL化字符串
			mobiles.each {|mobile|
				client.query("insert into jdsms.t_sendtask(destNumber,content) values('#{mobile}','#{content2}')") #写入数据库
			}
		end
	rescue Exception => e
	    mailError="#{Time.new} mailAccount #{account} #{e.inspect}"
		puts mailError
		errlog.puts(mailError)
		adminMobile=conf["adminMobile"]
		client.query("insert into jdsms.t_sendtask(destNumber,content) values('#{adminMobile}','#{mailError}')")
		client.close
		exit
    end
}


		