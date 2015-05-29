#encoding:gbk
#����Ŀ�ģ������ʼ�����������ȡָ���˻����ʼ����ݣ�д��mysql���ݿ⣬�������м��ʹ��
#����ʹ�ò���
#1.��config.txt�ļ����ò�����json��ʽ
#2.��װruby ��������mysql2��
#3.����ҵ�ƻ�ִ�г���
#Ahthor:Zsg
#Date:20150529
require 'net/pop'
require 'mysql2'
require 'base64'
require 'json'
errlog=File.open('transferMail_err.log','a') #���д�����־
begin
	json = File.read('config.txt') 
	conf = JSON.parse(json)
	client = Mysql2::Client.new(:host => conf["mysql"]["host"], :username => conf["mysql"]["username"], :password => conf["mysql"]["password"]) 
rescue Exception => e
	puts e.inspect
	errlog.puts("#{Time.new}:#{e.inspect}")
	exit
end
mailAccounts = conf["mailAccountToMobile"] #�������ֻ���Ӧ��Ϣ
mailServer = conf["mailServer"]["host"]
port = conf["mailServer"]["port"]
mailAccounts.each {|acc|
    mobiles = acc["mobile"]
	account = acc["account"]
	passwd = acc["password"]
	begin
		#ת���ʼ���MySQL���ݿ⣬ֻ����text/plain�ʼ�
		Net::POP3.delete_all(mailServer, port, account, passwd) do |mail|
			msg = mail.pop #�����ʼ�
			head = mail.header.chop #�ʼ�ͷ����
			content1 = msg.partition(head)[2] #��ȡ�ʼ�����
			content2 = client.escape(Base64.decode64(content1)) #�����SQL���ַ���
			mobiles.each {|mobile|
				client.query("insert into jdsms.t_sendtask(destNumber,content) values('#{mobile}','#{content2}')") #д�����ݿ�
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


		