using Plots
using Statistics

include("../src/readfiles.jl")

binfile = "data/WD001080722142026/reo/reo.bin"
hdrfile = "data/WD001080722142026/reo/reo.hdr"
evtfile = "data/WD001080722142026/DeepBreath.evt"

num_ch, fs, ibeg, iend, timestart, names, lsbs, units, type, types = readhdr(hdrfile)
reo_data, fs, timestart, units = readbin(binfile)
data, fs, timestart, units = readevt(evtfile)

# inp=reo_data.C6N;

# plot(reo_data.C6N)
# scatter!(data.time,reo_data.C6N[data.time])

inp=reo_data.C6N[data.time[1]:data.time[2]]

plot(inp)

# ФИЛЬТРАЦИЯ СКОЛЬЗЯЩИМ СРЕДНИМ
out_av=fill(0.0,size(inp))
window=1000

buf=fill(inp[1],window-1)
k=1
state=(buf,k)

include("findminmax.jl")

for i in 1:length(inp)
    state,y=movaverage(state,inp[i])
    out_av[i]=y
end

# ДЕТЕКТОР ЛОКАЛЬНЫХ МАКСИМУМОВ И МИНИМУМОВ

out=Int[]

radius=1000

state=(pos=1,amp=-Inf,m=-1)

include("findminmax.jl")

for i in 1:length(out_av)
    out,state=findminmax(i,out_av[i],radius,state)
end

plot(inp)
plot!(out_av)
scatter!(out,out_av[out],marker=:circle,legend=false)