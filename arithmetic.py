def long_division(a, b):
    # suppose we work only with 8 bit signed integers
    if (0 == b):
	raise 'Division by zero'
    r = 0
    p = 0
    s = False
    if (a < 0):
	a *= -1
	s = True
    if (b < 0):
	b *= -1
	s = s == False
    cnt = 0x40
    while (cnt != 0):
	r = r << 1
        if (cnt&a != 0):
            r |= 1
	if (r >= b):
            r -= b
            p |= cnt
	cnt = cnt >> 1
    if (s):
	p *= -1
	r *= -1
    return (p,r)

def long_multiplication(a, b):
    p = 0
    s = False
    if (a < 0):
	a *= -1
	s = True
    if (b < 0):
	b *= -1
	s = ~s
    cnt = 0x40
    while (cnt != 0):
	p   = p   << 1
	if (b&cnt):
            p += a
    	cnt = cnt >> 1
    if (s):
	p *= -1
    return p
    

def test_mul():
    print long_multiplication(2,1)
    print long_multiplication(2,3)
    print long_multiplication(2,4)
    print long_multiplication(2,-2)
    print long_multiplication(-3,-4)
    print long_multiplication(0,1)

def test_div():
    try:
    	print long_division(2,1)
	print long_division(4,2)
    	print long_division(10,3)
    	print long_division(6,2)
    	print long_division(70, -11)#(-6, -4)
    	print long_division(-70, -11)#(-6, -4)
    	print long_division(1, 0)
    except:
    	print 'Something was divided by zero'

test_mul()
test_div()
	
