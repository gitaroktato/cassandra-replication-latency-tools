#!/usr/bin/python
import string
import matplotlib.pyplot as plt
import numpy as np
import os
print os.getcwd()

def parse_logs(file_name):
    stats = open(file_name, 'r')
    lines = string.split(string.strip(stats.read()), '\n')
    lines = filter(lambda line: not line.startswith('Waiting'), lines)
    return map(lambda line: string.split(line, ':')[1], lines)

def get_mean_as_list(latency_list):
    return [np.mean(np.array(latency_list).astype(int)) for i in latency_list]

# print latency_list
latency_list_by1node2 = parse_logs('statistics/latency-simulation-250ms-by1node2.log')
latency_list_by1node3 = parse_logs('statistics/latency-simulation-250ms-by1node3.log')
latency_list_node1 = parse_logs('statistics/latency-simulation-250ms-awsnode1.log')
latency_list_node2 = parse_logs('statistics/latency-simulation-250ms-awsnode2.log')
latency_list_node3 = parse_logs('statistics/latency-simulation-250ms-awsnode3.log')

mean_by1 = get_mean_as_list(latency_list_by1node2);
mean_aws = get_mean_as_list(latency_list_node1);

by1node2, = plt.plot(range(0,len(latency_list_by1node2)), latency_list_by1node2, 'r^', color='#bccad6', label='by1node2')
by1node3, = plt.plot(range(0,len(latency_list_by1node3)), latency_list_by1node3, 'r^', color='#8d9db6', label='by1node3')
#
awsnode1, = plt.plot(range(0,len(latency_list_node1)), latency_list_node1, 'rs', color='#f9ccac', label='awsnode1')
awsnode2, = plt.plot(range(0,len(latency_list_node2)), latency_list_node2, 'rs', color='#f4a688', label='awsnode2')
awsnode3, = plt.plot(range(0,len(latency_list_node3)), latency_list_node3, 'rs', color='#e0876a', label='awsnode3')
# Means
mean_by1_label, = plt.plot(range(0,len(latency_list_by1node2)), mean_by1, 'b', label='mean by1')
mean_aws_label, = plt.plot(range(0,len(latency_list_node1)), mean_aws, 'r', label='mean aws')
#
plt.legend(handles=[by1node2, by1node3, awsnode1, awsnode2, awsnode3, mean_by1_label, mean_aws_label])
plt.grid(True)
plt.show()
