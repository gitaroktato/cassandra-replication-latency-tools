#!/usr/bin/python
import string
import matplotlib.pyplot as plt
import numpy as np

def parse_logs(file_name):
    stats = open(file_name, 'r')
    lines = string.split(string.strip(stats.read()), '\n')
    lines = filter(lambda line: not line.startswith('Waiting'), lines)
    return map(lambda line: string.split(line, ':')[1], lines)

def get_mean_as_list(latency_list):
    return [np.mean(np.array(latency_list_node1).astype(int)) for i in latency_list_node1]

# print latency_list
latency_list_node1 = parse_logs('statistics/latency-node1.log')
latency_list_node2 = parse_logs('statistics/latency-node2.log')
latency_list_node3 = parse_logs('statistics/latency-node3.log')

mean_list1 = get_mean_as_list(latency_list_node1);
mean_list2 = get_mean_as_list(latency_list_node2);
mean_list3 = get_mean_as_list(latency_list_node3);

plt.plot(range(0,len(latency_list_node1)), latency_list_node1, 'bs')
plt.plot(range(0,len(latency_list_node2)), latency_list_node2, 'rs')
plt.plot(range(0,len(latency_list_node3)), latency_list_node3, 'gs')
# Means
plt.plot(range(0,len(latency_list_node1)), mean_list1, 'b--')
plt.plot(range(0,len(latency_list_node2)), mean_list2, 'r--')
plt.plot(range(0,len(latency_list_node2)), mean_list3, 'g--')
plt.show()
