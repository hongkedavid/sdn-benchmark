# mirror_name
# mirroring traffic from or into port 1, 2 to por 3
ovs-vsctl -- set bridge br0 mirrors=@m -- --id=@te-1/1/1 get Port te-1/1/1 -- --id=@te-1/1/2 get Port te-1/1/2 -- --id=@te-1/1/3 get Port te-1/1/3 -- --id=@m create Mirror name=$1 select-dst-port=@te-1/1/1,@te-1/1/2 select-src-port=@te-1/1/1,@te-1/1/2 output-port=@te-1/1/3
