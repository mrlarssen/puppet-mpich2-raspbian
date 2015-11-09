This is a puppet manifest for installing MPICH2 on a raspbian cluster. With small changes to the paths the pp file, this can be used for any OS.

# Install and configure

Run on each node: sudo puppet apply mpich2.pp

# Testing
1. Set up public/private key authentication between this node and the other nodes in your cluster
2. cd /home/pi/mpich2 and create a file 'machinefile' and add the ips to all your nodes in the cluster including this machine.
3. Run mpi example: mpiexec -f machinefile -n <numberOfNodes> build/examples/cpi
