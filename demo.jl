include("Grids.jl")
include("DynamicOT.jl")
using Images, DynamicOT, MAT
firstFrame=ARGS[1];
secondFrame=ARGS[2];

p0=float(data(imread("$firstFrame.png")));
p1=float(data(imread("$secondFrame.png")));
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
  err_msqr = sqrt(mean((mid - estmid).^2));
  err_mabs = mean(abs(mid-estmid))
  @show err_msqr
  @show err_mabs
end

## write out data
matwrite("$firstFrame-data.mat", Dict{Any,Any}(
           "mass" => result[1].ρ,
           "momentum" => result[1].ω,
           "source" => result[1].ζ
           ))

## write flows
width=size(p0)[1];
height=size(p0)[2];
ρ=reshape(result[1].ρ[round(Int, T/2)+1,:,:], size(p0));
ω1=result[1].ω[1][round(Int, T/2)+1,:,:];
ω2=result[1].ω[2][round(Int, T/2)+1,:,:];
ω1=reshape(ω1, (width+1, height));
ω2=reshape(ω2, (width, height+1));
f=open("$firstFrame-flow.flo", "w");
write(f, "PIEH");
write(f, Int32(width));
write(f, Int32(height));
for j=1:height
  for i=1:width
    u=(ω1[i,j]+ω1[i+1,j])/2.;
    v=(ω2[i,j]+ω2[i,j+1])/2.;
    write(f, Float32(u));
    write(f, Float32(v));
  end
end
close(f)
