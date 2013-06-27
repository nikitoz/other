##################################################################################
#
##################################################################################

def encode(lst):
    if (lst == []): 
        return []
    i = 0
    out = []
    prev = lst[0]
    cnt = 1
    for i in range(1, len(lst)):
        if (prev == lst[i]):
            cnt = cnt + 1
        else:
            out.append((cnt, prev))
            cnt = 1
        prev = lst[i]
    out.append((cnt, prev))
    return out
        
def decode(lst):
    if (lst == []): 
        return []
    out = []
    for x in lst:
        for i in range(0, x[0]):
            out.append(x[1])
    return out

def solveIt(inputData):
    # Modify this code to run your optimization algorithm

    # parse the input
    lines = inputData.split('\n')

    firstLine = lines[0].split()
    items = int(firstLine[0])
    capacity = int(firstLine[1])

    values = []
    weights = []

    for i in range(1, items+1):
        line = lines[i]
        parts = line.split()

        values.append(int(parts[0]))
        weights.append(int(parts[1]))

    items = len(values)

    #print sum(weights)
    #return 0

    # a trivial greedy algorithm for filling the knapsack
    # it takes items in-order until the knapsack is full
    value = 0
    weight = 0
    taken = []
    for i in range(0, items):
        taken.append(0)

    table = []

    column = []
    for i in range(0, weights[0]+1):
        column.append(0)
    for i in range(weights[0]+1, capacity+1):
        column.append(values[0])

    table.append(encode(column))

    for i in range(1, items):
        prev = column
        column = []
        for cap in range(0, capacity+1):
            if (weights[i] > cap):
                column.append(prev[cap]) # it just doesn't fit
            else:
                column.append(max(prev[cap],  values[i] + prev[ cap - weights[i] ]))
        table.append(encode(column))

    #print table

    cap = capacity
    for i in range(items-1, 0, -1):
        column = decode(table[i])
        prev   = decode(table[i-1]) 
        if (column[cap] == values[i] + prev[ cap-weights[i] ]):
            cap  = cap - weights[i]
            taken[i] = 1
        table[i] = []

    p = 0
    for i in range(0, items):
        if (taken[i]!= 0):
            p = p + weights[i]

    p = capacity - p

    column = decode(table[items-1])

    value = column[capacity]
        
    # prepare the solution in the specified output format
    outputData = str(value) + ' ' + str(p) + '\n'
    outputData += ' '.join(map(str, taken))
    return outputData

import sys

if __name__ == '__main__':
    if len(sys.argv) > 1:
        fileLocation = sys.argv[1].strip()
        inputDataFile = open(fileLocation, 'r')
        inputData = ''.join(inputDataFile.readlines())
        inputDataFile.close()
        print solveIt(inputData)
    else:
        print 'This test requires an input file.  Please select one from the data directory. (i.e. python solver.py ./data/ks_4_0)'

