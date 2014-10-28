import operator

def swap(a, i, j):
	tmp = a[i]
	a[i] = a[j]
	a[j] = tmp

N = 10000
count = 0

def input_ff(filename):
	retval = []
	with open(filename) as f:
		for i in range(0, N):
			d = int(f.readline())
			retval.append(d)

	return retval

def check_less(a, b, e, p):
	for i in range(b, e):
		if (a[i] > p):
			return False
	return True

def check_gr(a, b, e, p):
	for i in range(b, e):
		if (a[i] < p):
			return False
	return True

def partition_first(a, start, end):
	pivot = a[start]
	i = start + 1
	
	for j in range(i, end):
		if (a[j]<pivot):
			swap(a, i, j)
			i = i + 1

	swap(a, start, i-1)
	return i-1

def partition_last(a, start, end):
	swap(a, start, end-1)
	return partition_first(a, start, end)

def partition_median_three(a, start, end):
	m1 = end - start
	midp = operator.floordiv(m1,2) + operator.mod(m1,2) - 1
	
	meow = [(a[start], start), (a[end-1], end-1), (a[start + midp], start + midp)]
	swap(a, start, sorted(meow)[1][1])

	return partition_first(a, start, end)

def is_sorted(a):
	for i in range (1, len(a)):
		if (a[i-1] > a[i]):
			return False
	return True
	
def qsort_ff(a, start, end, partition_algo):
	if (end-start <= 1):
		return
	global count
	count = count + (end-start-1)
	median = partition_algo(a, start, end)
	qsort_ff(a, start, median, partition_algo)
	qsort_ff(a, median+1, end, partition_algo)
	
arr = input_ff('d:\\QuickSort.txt')
qsort_ff(arr, 0, len(arr), partition_median_three)
print is_sorted(arr)
print count