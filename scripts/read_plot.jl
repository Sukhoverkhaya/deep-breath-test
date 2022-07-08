#=
пример чтения данных
=#

include("../src/readfiles.jl")

binfile = "data/NC233180121072507/NC233180121072507.bin"
hdrfile = "data/NC233180121072507/NC233180121072507.hdr"
evtfile = "data/NC233180121072507/NC233180121072507.evt"
txdfile = "data/NC233180121072507/NC233180121072507.txd"

num_ch, fs, ibeg, iend, timestart, names, lsbs, units, type, types = readhdr(hdrfile)


ecg_data, fs, timestart, units = readbin(binfile, 1:2000)

evt_data, fs, timestart, units = readevt(evtfile)

txd_data, fs, timestart, units = readevt(txdfile)

using Plots

# покажем все каналы на графике:

plot_names = String.(hcat(keys(ecg_data)...))
plot_data = hcat(ecg_data...)
plot(plot_data, layout = (length(ecg_data), 1), margin = 0Plots.cm, xticks = nothing, labels = plot_names)

# 1 канал ЭКГ + точки rrInterval

plot(ecg_data.LR)

x = txd_data.time[1:3]
y = ecg_data.LR[x]
scatter!(x, y, marker = :circle)
