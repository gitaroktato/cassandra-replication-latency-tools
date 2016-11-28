#!/usr/bin/python
import string
import matplotlib.pyplot as plt

stats = '''
Lantency for query: 114
Lantency for query: 105
Lantency for query: 104
Lantency for query: 99
Lantency for query: 142
Lantency for query: 100
Lantency for query: 102
Lantency for query: 105
Lantency for query: 102
Lantency for query: 105
Lantency for query: 102
Lantency for query: 109
Lantency for query: 102
Lantency for query: 105
Lantency for query: 110
Lantency for query: 100
Lantency for query: 101
Lantency for query: 106
Lantency for query: 98
Lantency for query: 116
Lantency for query: 140
Lantency for query: 97
Lantency for query: 102
Lantency for query: 106
Lantency for query: 101
Lantency for query: 102
Lantency for query: 99
Lantency for query: 137
Lantency for query: 125
Lantency for query: 100
Lantency for query: 106
Lantency for query: 106
Lantency for query: 100
Lantency for query: 110
Lantency for query: 139
Lantency for query: 119
Lantency for query: 147
Lantency for query: 200
Lantency for query: 129
Lantency for query: 125
Lantency for query: 106
Lantency for query: 107
Lantency for query: 158
Lantency for query: 124
Lantency for query: 117
Lantency for query: 127
Lantency for query: 119
Lantency for query: 112
Lantency for query: 165
Lantency for query: 119
Lantency for query: 104
Lantency for query: 100
Lantency for query: 114
Lantency for query: 101
Lantency for query: 103
Lantency for query: 98
'''
lines = string.split(string.strip(stats), "\n")
latency_list = map(lambda line: string.split(line, ':')[1], lines)

# print latency_list
plt.plot(range(0,len(latency_list)), latency_list, 'bs')
plt.show()
