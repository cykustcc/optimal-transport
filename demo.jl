include("Grids.jl")
include("DynamicOT.jl")
using Images, Colors, FixedPointNumbers, DynamicOT, MAT, PyPlot
firstFrame=ARGS[1];
secondFrame=ARGS[2];

p0=float(data(convert(Image{Gray}, load("$firstFrame.png"))));
p1=float(data(convert(Image{Gray}, load("$secondFrame.png"))));

## Get the file name part of pathes
firstFrame=basename(firstFrame);
secondFrame=basename(secondFrame);

@show sum(p0)
@show sum(p1)

dir="";
if length(ARGS) > 5
  dir=string(ARGS[6], "/");
end

T=parse(ARGS[3]) # time ticks
result=solveGeodesic(p0, p1, T, δ=float(ARGS[4])/pi);

t=round(Int, (T+1)/2);
U=result[1];
ζ = reshape(U.ζ[t,:],U.cdim[2:end]...);
#imshow(ζ,cmap="bwr",vmin=-.05, vmax=.05);
imsave("$(dir)source_$(firstFrame)",transpose(ζ),cmap="bwr",vmin=-.05, vmax=.05);

## write interpolating frames
#for i=1:(T+1)
#    interp=min(1,reshape(result[1].ρ[i,:,:],size(p0)));
#    imwrite(grayim(interp), "$(dir)$firstFrame-$i.png")
#end

## compute estimation error if the ground-truth frame is given
if length(ARGS) > 4
  midFrame=ARGS[5];
  if (midFrame != "-") 
    mid=float(data(convert(Image{Gray}, load("$midFrame.png"))));
    estmid=min(1, reshape(result[1].ρ[t,:,:],size(p0)));
    err_msqr = sqrt(mean((mid - estmid).^2));
    err_mabs = mean(abs(mid-estmid))
    @show err_msqr
    @show err_mabs
  end
end

## write out data
matwrite("$(dir)$firstFrame-data.mat", Dict{Any,Any}(
           "mass" => U.ρ,
           "momentum" => U.ω,
           "source" => U.ζ))

## write flows
width=size(p0)[1];
height=size(p0)[2];
ρ=reshape(result[1].ρ[t,:,:], size(p0));
ω1=result[1].ω[1][t,:,:];
ω2=result[1].ω[2][t,:,:];
ω1=reshape(ω1, (width+1, height));
ω2=reshape(ω2, (width, height+1));
f=open("$(dir)$firstFrame-momentum.flo", "w");
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
