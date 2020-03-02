using Test
using Covers

cc=Cover(4,8)
cc(1,1,true)
cc(2,2,true)

@test all(cc .^ Bool[1 1 1 1 1 1 1 1;
                     0 1 0 0 0 0 0 0;
                     0 1 0 0 0 0 0 0;
                     0 1 0 0 0 0 0 0])


@test cc[9] && (!cc[10])

cc[9] =false
@test all(cc .^ Bool[0 1 0 0 0 0 0 0;
                     0 1 0 0 0 0 0 0;
                     0 1 0 0 0 0 0 0;
                     0 1 0 0 0 0 0 0])

cc[10] =true

@test all(cc .^ Bool[0 1 1 0 0 0 0 0;
                     0 1 1 0 0 0 0 0;
                     0 1 1 0 0 0 0 0;
                     0 1 1 0 0 0 0 0])
cc[9] =true

@test all(cc .^ Bool[0 1 1 0 0 0 0 0;
                     0 1 1 0 0 0 0 0;
                     0 1 1 0 0 0 0 0;
                     0 1 1 0 0 0 0 0])

cc[10] =false
@test all(cc .^ Bool[0 1 0 0 0 0 0 0;
                     0 1 0 0 0 0 0 0;
                     0 1 0 0 0 0 0 0;
                     0 1 0 0 0 0 0 0])


cc=Cover(4,8)
cc(1,1,true)
cc(2,2,true)

@test cc[1,3] && (!cc[2,3])

cc[1,3] =false
@test all(cc .^ Bool[0 1 0 0 0 0 0 0;
                  0 1 0 0 0 0 0 0;
                  0 1 0 0 0 0 0 0;
                  0 1 0 0 0 0 0 0])

cc[2,3] =true

@test all(cc .^ Bool[0 1 1 0 0 0 0 0;
                  0 1 1 0 0 0 0 0;
                  0 1 1 0 0 0 0 0;
                  0 1 1 0 0 0 0 0])
