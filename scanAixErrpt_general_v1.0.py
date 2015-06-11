# -*- coding: utf-8 -*-
#Function: Scan errpt information from Aix logs
#author  : zsg
#date    : 2015-2-6
from Tkinter import *
import os
import datetime
import tkMessageBox
import locale

scan_dir=os.getcwd().decode(locale.getdefaultlocale()[1]) #scan_dir,put aix logs
scan_date_s=(datetime.date.today()+datetime.timedelta(-7)).strftime('%Y-%m-%d %H:%M') 
root=Tk()
root.title(u"扫描AIX日志，输出'起始扫描时间'之后产生errpt信息")
f1=Frame(root)
Label(f1,text=u'日志保存路径：',font=(15),width=18).pack(side=LEFT)
entry=Entry(f1,font=('Helvetica',10),width=40)
entry.insert(0,scan_dir)
entry.pack(side=LEFT)
f1.pack(pady=10)
f2=Frame(root)
Label(f2,text=u'起始扫描时间：',font=(15),width=18).pack(side=LEFT)
entry2=Entry(f2,font=('Helvetica',10),width=40)
entry2.insert(0,scan_date_s)
entry2.pack(side=LEFT)
f2.pack()
f3=Frame(root)
Label(f3,text=u'扫描结果保存路径：',font=(15),width=18).pack(side=LEFT)
entry3=Entry(f3,font=('Helvetica',10),width=40)
entry3.insert(0,scan_dir+os.path.sep+'errpt.dat')
entry3.pack(side=LEFT)
f3.pack(pady=10)
f4=Frame(root)
v=IntVar()
chkbutton=Checkbutton(f4,text=u'扫描文件系统，使用率大于等于',variable=v)
v.set(0)

v1=StringVar()
entry5=Entry(f4,font=('Helvetica',10),width=5,textvariable=v1,state='disabled')
chkbutton.pack(side=LEFT)
entry5.pack(side=LEFT)
Label(f4,text='%').pack(side=LEFT)
f4.pack()
#define event for chkbutton
def chkbutton_action(event):
    if v.get()==1:
        v1.set('')
        entry5.config(state='disabled')
    else:
        v1.set('85')
        entry5.config(state='normal')
        
chkbutton.bind('<Button-1>',chkbutton_action)

def scan_go():
    e.set(u"状态栏：")
    scan_dir=entry.get()
    if os.path.exists(scan_dir) is False:
        e.set(u"状态栏：'日志保存路径'不存在，请重新输入！")
        return
    
    scan_date_s=entry2.get()
    try:
        scan_datetime=datetime.datetime.strptime(scan_date_s,'%Y-%m-%d %H:%M')
    except Exception:
        e.set(u"状态栏：'起始扫描时间'不正确，请按格式重新输入！")
        return

    if v.get()==1:
        utilization=entry5.get()
        if utilization.isdigit()==False or int(utilization)<70 or int(utilization)>99:
            e.set(u"状态栏：使用率只能为70-99之间的整数，请重新输入！")
            return
    
    scan_report=entry3.get()
    if os.path.exists(scan_report) is True:
        if tkMessageBox.askquestion(title=u'询问',message=scan_report+u'\n文件已存在，将被覆盖，是否继续？')=='no':
            return
    try:
        ferrpt=open(scan_report,'w')
    except Exception:
        e.set(u"状态栏：'扫描结果保存路径'不正确，请重新输入！")
        return
#scan unilization of directories
    if v.get()==1:  
        for file in os.listdir(scan_dir):
            openfile=scan_dir+os.path.sep+file
            if os.path.isfile(openfile):
                bprint=False 
                bhostprint=True 
                with open(openfile) as f:
                    if f.readline().find("hostname")>0:
                        hostname=f.readline()
                        for line in f:
                            if line[0:10]=='Filesystem':
                                filesystem=line
                                bprint=True
                                continue
                            
                            if line.find("lsvg -o")>0:
                                break
                            
                            if bprint and len(line.split())==7:
                                 l_utilization=line.split()[3][:-1]
                                 if l_utilization.isdigit() and int(l_utilization)>=int(utilization):
                                    if bhostprint:
                                        ferrpt.write('Hostname:'+hostname)
                                        ferrpt.write(filesystem)
                                        bhostprint=False
                                    ferrpt.write(line)

#scan errpt information

    bexist_aixlog=False #Verify aix logs exists
    bexist_errpt=False  #Verify errpt information exists
    for file in os.listdir(scan_dir): 
        openfile=scan_dir+os.path.sep+file
        if os.path.isfile(openfile):
            bprint=False 
            bhostprint=True 
            with open(openfile) as f:
                if f.readline().find("hostname")>0:
                    bexist_aixlog=True
                    hostname=f.readline()
                    for line in f:
                        if line[0:10]=='IDENTIFIER':
                            identifer=line
                            bprint=True
                        if line[0:10]=='Filesystem':
                            break
                        if bprint and line[11:21].isdigit():
                            date_str=line[11:19]+'20'+line[19:21]
                            dt_obj=datetime.datetime.strptime(date_str,"%m%d%H%M%Y")  
                            if dt_obj>scan_datetime:
                                bexist_errpt=True
                                if bhostprint:
                                    ferrpt.write('Hostname:'+hostname)
                                    ferrpt.write(identifer)
                                    bhostprint=False
                                ferrpt.write(line)


    
    ferrpt.close()
    if bexist_aixlog==False:
        e.set(u"状态栏：'日志保存路径'不存在AIX日志，请检查！")
    elif bexist_errpt==False:
        e.set(u"状态栏：扫描完毕，'起始扫描时间'之后没产生errpt信息！")
    else:        
        e.set(u'状态栏：扫描完毕，请查看扫描结果!')
        

Button(root,text=u'执行扫描',font=(16),command=scan_go).pack(fill=X,pady=10)
Label(root,text=u"注意'起始扫描时间'的输入格式：年-月-日 时:分，英文下输入",fg='red').pack()
e=StringVar()
entry4=Entry(root,textvariable=e,relief=FLAT)
e.set(u'状态栏：')
entry4.pack(fill=X)
root.mainloop()


