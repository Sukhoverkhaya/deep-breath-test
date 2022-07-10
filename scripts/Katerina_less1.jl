using Plots
using Statistics

include("../src/readfiles.jl")

binfile = "data/WD001080722144945/reo/reo.bin"
hdrfile = "data/WD001080722144945/reo/reo.hdr"
evtfile = "data/WD001080722144945/DeepBreath.evt"

num_ch, fs, ibeg, iend, timestart, names, lsbs, units, type, types = readhdr(hdrfile)
reo_data, fs, timestart, units = readbin(binfile)
data, fs, timestart, units = readevt(evtfile)

# plot(ecg_data.C6N)
# scatter!(data.time,ecg_data.C6N[data.time])

# ФИЛЬТРЫ БЕЗ СОСТОЯНИЙ

# пересчёт по формулам

inp=reo_data.C6N;
out=fill(0, size(inp))

function some_formula(x)
    return x+(5*x^2)/10^8
end

# for i in 1:length(inp)
#     x=inp[i]
#     y=some_formula(x)
#     out[i]=y
# end

out=map(some_formula, inp) # форма записи цикла выше

plot(inp)
plot!(out,legend=false)

# пороговый детектор
function detect_threshold(x)
    return x>222000
end

out=map(detect_threshold,inp)

t=1:length(inp);
plot(t,inp)
plot!(t[out],inp[out],legend=false)

# ФИЛЬТРЫ С СОСТОЯНИЯМИ

out=fill(NaN,size(inp))

#############
# for i in 1001:length(inp)
#     out[i]=(inp[i]-inp[i-1000])+mean(inp)
# end
###############

#############
# x0=inp[1]
# for i in 1001:1000:length(inp)
#     xi=inp[i]
#     out[i]=(xi-x0)+mean(inp)
#     x0=xi
# end
#############

#############
# function my_diff(x0,x,m)
#     y=(x-x0)+m
#     x0=x
#     return x0,y
# end

# x0=inp[1]
# m=mean(inp)
# for i in 1001:1000:length(inp)
#     x=inp[i]
#     x0,y=my_diff(x0,x,m)
#     out[i]=y
# end
###########

###########
# с произвольным шагом
# delta=1000

# buf=fill(inp[1],delta)
# k=1

# for i in 1:length(inp)
#     x0=buf[k]
#     x=inp[i]
#     y=(x-x0)+m
#     out[i]=y

#     buf[k]=x
#     k+=1
#     if k>length(buf)
#         k=1
#     end
# end
#########

#######
delta=1000

buf=fill(inp[1],delta)
k=1
state=(buf,k)

function my_diff(state,x)
    buf,k=state

    x0=buf[k]
    y=(x-x0)+m

    buf[k]=x
    k+=1
    if k>length(buf)
        k=1
    end
    state=(buf,k)
    return state,y
end

for i in 1001:length(inp)
    x=inp[i]
    state,y=my_diff(state,x)
    out[i]=y
end
############

# ФУНКЦИИ В СКОЛЬЗЯЩЕМ ОКНЕ

out=fill(0.0,size(inp))
window=1000

buf=fill(inp[1],window-1)
k=1
state=(buf,k)

function my_mean(state,x)
    buf,k=state
    sum_x=x
    for xi in buf #сумма всех элементов буфера + один новый
        sum_x+=xi
    end
    y=sum_x/window

    buf[k]=x
    k+=1
    if k>length(buf)
        k=1
    end

    state=(buf,k)
    return state,y
end

for i in 1:length(inp)
    x=inp[i]
    state,y=my_mean(state,x)
    out[i]=y
end

# ДЕЦИМАТОР (прореживает сигнал)

coef_dcm=1000

out=Float64[]
len_out=length(inp)÷coef_dcm   
sizehint!(out,len_out)

r_counter=0

function my_dcm(r_counter, out, x)
    r_counter+=1
    if r_counter==coef_dcm
        push!(out,x)
        r_counter=0
    end
    return r_counter,out
end

for i in 1:length(inp)
    x=inp[i]
    r_counter,out=my_dcm(r_counter,out,x)
end

plot(inp)
plot!(coef_dcm:coef_dcm:length(inp),out, legend=false)