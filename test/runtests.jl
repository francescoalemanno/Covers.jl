using Test
using Covers

cc=Cover(4,8)
cc(1,1,true)
cc(2,2,true)

@test all(cc .^ Bool[1 1 1 1 1 1 1 1; 0 1 0 0 0 0 0 0; 0 1 0 0 0 0 0 0; 0 1 0 0 0 0 0 0])
@test cc[9] && (!cc[10])
