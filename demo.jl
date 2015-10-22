include("Grids.jl")
include("DynamicOT.jl")
using Images, DynamicOT, MAT
firstFrame=ARGS[1];
secondFrame=ARGS[2];

p0=data(float(imread("$firstFrame.png")));
p1=data(float(imread("$secondFrame.png")));
T=parse(ARGS[3]) # time ticks
result=solveGeodesic(p0, p1, T, δ=float(ARGS[4])/pi);

## write interpolating frames
for i=1:(T+1)
    interp=min(1,reshape(result[1].ρ[i,:,:],size(p0)));
    imwrite(grayim(interp), "$firstFrame-$i.png")
end

## compute estimation error if the ground-truth frame is given
if length(ARGS) > 4
  midFrame=ARGS[5];
  mid=data(float(imread("$midFrame.png")));
  estmid=min(1, reshape(result[1].ρ[round(Int, T/2) + 1,:,:],size(p0)));
  err = sqrt(mean((mid - estmid).^2));
  @show err
end

## write out data
matwrite("$firstFrame-data.mat", Dict{Any,Any}(
           "mass" => result[1].ρ,
           "momentum" => result[1].ω,
           "source" => result[1].ζ
           ))
