
def swap(a, i, j):
	tmp = a[i]
	a[i] = a[j]
	a[j] = tmp

N = 10000

def input_ff(filename):
	retval = []
	with open(filename) as f:
		for i in range(0, N):
			d = int(f.readline())
			retval.append(d)

	return retval

def partition_first(a, start, end):
	pivot = a[start]
	i = start + 1
	for j in range(i+1, end):
		if (a[j]<pivot):
			swap(a, i, j)
			i = i + 1

	swap(a, start, i-1)
	return i-1

def is_sorted(a):
	for i in range (1, len(a)):
		if (a[i-1] > a[i]):
			return False
	return True
	
def qsort_ff(a, start, end, partition_algo):
	if (end-start <= 1):
		return
	median = partition_algo(a, start, end)
	qsort_ff(a, start, median, partition_algo)
	qsort_ff(a, median+1, end, partition_algo)

	
arr = input_ff('d:\\QuickSort.txt')
print arr
qsort_ff(arr, 0, len(arr), partition_first)
print "pew"
print arr
print is_sorted(arr)