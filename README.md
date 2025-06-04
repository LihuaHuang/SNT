# SeqNT
Sequential Network Tomography : Exploiting the Temporal Correlation in Network Monitoring

Sequential network tomography infers link metrics by exploiting the temporal correlation of link state
# setup  
## Requirements:
matlab (>=R2016a)
## topology and routing matrix
1. Use [COLD](https://github.com/rhysbowden/COLD) or other tools to generate the topology, including the adjacency matrix of the graph 
2. Run `routingMatrixGenFromAdja.m` to generate the routing matrix.
## files:
* SBT.m，Sequential boolean tomography
* SAT_cvx.m, Sequential Anolog tomography
* FaCe.m, Bayesian Approach to Network Monitoring for Progressive Failure Localization
* TOMO.m, The Boolean Solution to the Congested IP Link Location Problem: Theory and Practice
* WCS_LP.m, Weighted L1 Optimization,using LP algorithm 
* Rocketfuel, Rocketfuel topologies
* utilities. calculateF1, gendata, MaxIndRows


# Run the SAT, SBT and other recovery methods
The run.m invoke all the recovery methods. The parameters are 
* fileName: routing matrix
* d: Number of link state transitions
* m1: number of measurements at time 1
* m2: number of measurements at time t>1
An example usage is
```matlab
run('matlab.mat',1,1200,600)
