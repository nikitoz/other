
N = 100000

def input_ff(filename):
	retval = []
	with open(filename) as f:
		for i in range(0, N):
			d = int(f.readline())
			retval.append(d)

	return retval

def count_inversions_split(a, begin, end):
	retval = 0
	r = []
	midian = (end - begin)/2
	i = begin
	j = begin + midian
	while (j != end or i != begin + midian):
		if ((i == begin + midian) or ((j != end) and (a[i] > a[j]))):
			#print 'j ', j, ' i ', i
			r.append(a[j])
			if (i != begin + midian):
				retval = retval + ((begin + midian) - i)
			j = j + 1
			#print 'j'
		else:
			r.append(a[i])
			i = i + 1
			#print 'i'
	a[begin:end] = r
	return retval

def count_inversions(a, begin, end):
	if (end-begin < 2):
		return 0
	midian = (end - begin)/2
	x = count_inversions(a, begin, begin + midian)
	y = count_inversions(a, begin + midian, end)
	z = count_inversions_split(a, begin, end)
	return x + y + z


#test_ar = [1, 5, 3, 6]
#print (count_inversions_split(test_ar, 0, len(test_ar)))

fn = 'D:\\IntegerArray.txt'
arr = input_ff(fn)
print count_inversions(arr, 0, len(arr))
