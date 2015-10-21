# optimal-transport
This Julia toolbox solves the dynamical optimal transport problem and various extensions allowing mass to vary along transport. It handles:
- an interpolated distance between Fisher-Rao and W2;
- partial optimal transport (quadratic cost, absolute value cost);
- an interpolation between W1 and Fisher-Rao;
- and of course standard Wasserstein distances (1,2);

Check the associated article where the mathematical frawmework is described:
http://arxiv.org/abs/1506.06430

and see the associated notebooks for a simple overview.

Available soon:
- extension to Riemannian manifolds

## How to run
Update 2015-10-21: 2D examples in the paper has been added. 
```julia
julia> include("Grids.jl")
julia> include("DynamicOT.jl")
julia> using Images, DynamicOT
julia> p0=1-data(float(imread("p0.png")));
julia> p1=1-data(float(imread("p1.png")));
julia> T=10 # time ticks
julia> result=solveGeodesic(p0,p1,T);
julia> interp=max(0,1-reshape(result[1].ρ[T/2+1,:,:],size(p0)));
julia> imwrite(grayim(interp3), "pmid.png")
```
