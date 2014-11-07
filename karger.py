import random

class g():

	def __init__(self, filename, n):
		self.N   = n
		self.id_ = n
		self.edges = []
		with open(filename) as f:
			for i in range(0, self.N):
				d = f.readline().split()
				a = int(d[0])
				for b in d[1:len(d)]:
					bb = int(b)
					bd = True
					for e in self.edges:
						if ((e[0] == a and e[1] == bb) or (e[1] == a and e[0] == bb)):
							bd = False
							break
					if (bd):
						self.edges.append((a, int(b)))
		#print self.edges
					
	def new_id(self):
		self.id_ = self.id_ + 1
		return self.id_

	def contract(self, i):
		a = self.edges[i][0]
		b = self.edges[i][1]

		next_id = self.new_id()

		i = len(self.edges) - 1
		while (i != -1):
			if ((self.edges[i][0] == a and self.edges[i][1] == b) or (self.edges[i][0] == b and self.edges[i][1] == a)):
				del self.edges[i]
			i = i - 1

		for c in [a,b]:
			for j in range(0, len(self.edges)):
				if (self.edges[j][0] == c) :
					self.edges[j] = (next_id, self.edges[j][1])
				if (self.edges[j][1] == c):
					self.edges[j] = (self.edges[j][0], next_id)

		self.N = self.N - 1

	def printme(self):
		print self.edges

	def cut_weight(self):
		return len(self.edges)

	def num_vertices(self):
		return self.N

def dowork():
	num = 200
	v = g('D:/Projects/other/kargerMinCut.txt', num)
	while (v.num_vertices() > 2):
		r = random.randint(0, v.num_vertices()-1)
		#print 'random = ', r
		v.contract(r)
		#v.printme()
	return v.cut_weight()
	#print v.cut_weight()

results = []
	#random.seed()
for h in range(0, 1000):
	results.append(dowork())
#	print min(results)
#	results = []
print results
print '-result-'
print min(results)
