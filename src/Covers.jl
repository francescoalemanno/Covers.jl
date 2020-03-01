module Covers
    import Base.size
    import Base.getindex
    import Base.setindex!
    using DefaultArrays
    export Cover, twicecovered

    struct Cover{N} <: AbstractArray{Bool,N}
        size::NTuple{N,Int}
        cov::Vector{BitArray{1}}
    end

    Cover(size::Int...) where N =Cover(size,[falses(s) for s in size])

    Base.size(A::Cover) = A.size


    @inline function boundscheck(A::Cover,I)
        if length(I) != length(A.size) || (!all(I .<= A.size)) 
            throw(BoundsError)
        end
    end
    @inline function getindex(A::Cover,i::Int) 
        I=CartesianIndices(A)[i]
        A[I]
    end
    @inline function Base.getindex(A::Cover, I::Int...) 
        @boundscheck boundscheck(A,I)
        any(A.cov[i][I[i]] for i in eachindex(I))
    end
    @inline function Base.getindex(A::Cover{N}, I::NTuple{N,Int}) where N
        @boundscheck boundscheck(A,I)
        sum(A.cov[i][I[i]] for i in eachindex(I))
    end
    @inline function Base.setindex!(A::Cover, v::Bool, i,j) 
        A.cov[i][j]=v
    end

    @inline function twicecovered(A::Cover)
        ret=DefaultArray(false,A.size)
        for t in eachindex(A)
            ret[t]=A[Tuple(t)]>1
        end
        ret
    end
end # module
