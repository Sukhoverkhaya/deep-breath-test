using Plots
using Statistics

include("../src/readfiles.jl")

binfile = "WD001080722144945/reo/reo.bin"
hdrfile = "WD001080722144945/reo/reo.hdr"
evtfile = "WD001080722144945/DeepBreath.evt"

num_ch, fs, ibeg, iend, timestart, names, lsbs, units, type, types = readhdr(hdrfile)
reo_data, fs, timestart, units = readbin(binfile)
data, fs, timestart, units = readevt(evtfile)

inp=reo_data.C6N;

plot(reo_data.C6N)
scatter!(data.time,reo_data.C6N[data.time])

# ПОРОГОВЫЙ ДЕТЕКТОР СОБЫТИЙ
#############################
# out=Int[]

# y0=false
# counter=1
# state=counter,y0
# thr=223000

# function detect_threshold(state,out,x)
#     counter,y0=state

#     y=x>thr
#     if y!=y0
#         push!(out,counter)
#     end
#     counter+=1
#     state=counter,y

#     return state,out
# end

# for i in 1:length(inp)
#     x=inp[i]
#     state,out=detect_threshold(state,out,x)
# end
#####################
# # пример с гистерезисом по амплитуде
# out=Int[]

# y0=false
# counter=1
# cnt_last=1
# state=counter,y0,cnt_last

# h_amp=1000
# thr=223000
# thr_on=thr
# thr_off=thr-h_amp

# function detect_threshold(state,out,x)
#     counter,y0,cnt_last=state

#     if !y0     # если детекции не было
#         y=x>thr_on
#     else       # если детекция была
#         y=x>thr_off
#     end

#     if y!=y0
#         push!(out,counter)
#     end
#     counter+=1
#     state=counter,y,cnt_last

#     return state,out
# end

# for i in 1:length(inp)
#     x=inp[i]
#     state,out=detect_threshold(state,out,x)
# end
###########################

# пример с гистерезисом по времени
# out=Int[]

# y0=false
# counter=1
# cnt_last=1

# state=counter,y0,cnt_last

# h_time=10000
# thr=223000


# function detect_threshold(state,out,x)
#     counter,y0,cnt_last=state

#     y=y0
#     if x>thr   
#         y=true 
#         cnt_last=counter
#     else       
#         if counter >=cnt_last+h_time
#             y=false
#         end
#     end

#     if y!=y0
#         push!(out,counter)
#     end
#     counter+=1
#     state=counter,y,cnt_last

#     return state,out
# end

# for i in 1:length(inp)
#     x=inp[i]
#     state,out=detect_threshold(state,out,x)
# end

# plot(inp)
# hline!([thr])
# scatter!(out,inp[out],marker=:circle,legend=false)
##############

# ДЕТЕКТОР ЛОКАЛЬНЫХ МАКСІМУМОВ

out=Int[]

radius=5000
min_amp=223000

mx=(pos=1,amp=-Inf)

for i in 1+radius:length(inp)-radius

    if i-mx.pos>=radius && mx.amp>=min_amp
        is_max=true
    # for k in i-radius:i+radius
    #     if inp[k]>=inp[i] && i!=k
    #         is_max=false
    #         break
    #     end
    # end
        if is_max
            push!(out,mx.pos)
            mx=(pos=i,amp=inp[i])
        end
    end

    if inp[i]>mx.amp
        mx=(pos=i,amp=inp[i])
    end
end

plot(inp)
scatter!(out,inp[out],marker=:circle,legend=false)

