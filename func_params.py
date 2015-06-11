# function params
def func(a,b,c=0,*args,**kw):
	print 'a=',a,'b=',b,'c=',c,'args=',args,'kw=',kw

func(1,2,3,'a','b',x=99)

args = (1,2,3,4)
kw = {'x':99}
func(*args,**kw)