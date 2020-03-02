module Covers
    import Base.size
    import Base.getindex
    import Base.setindex!

    using DefaultArrays
    export Cover, multicovered, ncovered

    struct Cover{N} <: AbstractArray{Bool,N}
        size::NTuple{N,Int}
        cov::Vector{BitArray{1}}
    end

    Cover(size::Int...) where N =Cover(size,[falses(s) for s in size])

    size(A::Cover) = A.size


    @inline getindex(A::Cover{1}, i::Int) = _cartesian_getindex(A, i)
    @inline getindex(A::Cover{N}, i::Int) where N = _scalar_getindex(A, i)
    @inline getindex(A::Cover{N}, I::Int...) where N = _cartesian_getindex(A, I...)

    @inline function _scalar_getindex(A::Cover,i::Int)
        I=CartesianIndices(A)[i]
        _cartesian_getindex(A::Cover, Tuple(I)...)
    end


    @inline function _cartesian_getindex(A::Cover{N}, I::Int...) where N
        @boundscheck checkbounds(CartesianIndices(A),I...)
        for i in 1:N
            if A.cov[i][I[i]]
                return true
            end
        end
        return false
    end

    @inline setindex!(A::Cover{1}, v::Bool, i::Int) = _cartesian_setindex!(A, v, i)
    @inline setindex!(A::Cover{N}, v::Bool, i::Int) where N = _scalar_setindex!(A, v, i)
    @inline setindex!(A::Cover{N}, v::Bool, I::Int...) where N = _cartesian_setindex!(A, v, I...)

    @inline function _cartesian_setindex!(A::Cover{N}, v::Bool,I::Int...) where N
        state=A[I...]
        if v && !state
            idx=findmax(size(A))[2]
            A(idx,I[idx],v)
            @goto ret
        end
        if !v && state
            for idx in 1:N
                A(idx,I[idx],v)
            end
            @goto ret
        end
        @label ret
        return v
    end
    @inline function _scalar_setindex!(A::Cover, v::Bool,i::Int)
        I=CartesianIndices(A)[i]
        _cartesian_setindex!(A::Cover,v, Tuple(I)...)
    end

    @inline function (C::Cover)(dim::Int,i::Int,state::Bool)
        C.cov[dim][i]=state
    end

    @inline function multicovered(A::Cover)
        ret=DefaultArray(false,A.size)
        for t in eachindex(A)
            ret[t]=coveredntimes(A, Tuple(t))>1
        end
        ret
    end


    @inline function coveredntimes(A::Cover{N}, I::NTuple{N,Int}) where N
        @boundscheck checkbounds(CartesianIndices(A),I...)
        sum(A.cov[i][I[i]] for i in eachindex(I))
    end

    @inline function ncovered(A::Cover)
        ret=DefaultArray(0,A.size)
        for t in eachindex(A)
            ret[t]=coveredntimes(A, Tuple(t))
        end
        ret
    end

end # module
