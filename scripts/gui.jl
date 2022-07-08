
using CImGui
using ImPlot

include(joinpath(pathof(ImPlot), "..", "..", "demo", "Renderer.jl"))
using .Renderer

const PLOT_DATA = Dict(
    :x => collect(1:200000), 
    :y => map(x-> 0.5 + 0.5 * sin(50 * (x * 0.0001)), 1:200000),
    :x_rr => [100, 200, 300]
)

function ui()
    CImGui.Begin("Window")

    xs = PLOT_DATA[:x]
    ys = PLOT_DATA[:y]
    x_rr = PLOT_DATA[:x_rr]

    if ImPlot.BeginPlot("Line Plot", "x", "f(x)")
        ImPlot.PlotLine("line", xs, ys, length(xs))
        ImPlot.SetNextMarkerStyle(ImPlotMarker_Circle)
        y_rr = ys[x_rr]
        
        # ImPlot::PlotScatter("Data 1", xs1, ys1, 100);
        # ImPlot::PushStyleVar(ImPlotStyleVar_FillAlpha, 0.25f);
        # ImPlot::SetNextMarkerStyle(ImPlotMarker_Square, 6, ImPlot::GetColormapColor(1), IMPLOT_AUTO, ImPlot::GetColormapColor(1));
        # ImPlot::PlotScatter("Data 2", xs2, ys2, 50);
        # ImPlot::PopStyleVar();
        # ImPlot::EndPlot();

        ImPlot.PlotScatter(x_rr, y_rr)
        ImPlot.EndPlot()
    end

    if CImGui.Button("reset")
        println("reset pressed")
        PLOT_DATA[:x] = collect(1:200000)
        PLOT_DATA[:y] = map(x-> 0.5 + 0.5 * sin(50 * (x * 0.00001)), 1:200000)
        PLOT_DATA[:x_rr] = [100, 200, 300]
    end
    if CImGui.Button("show ecg")
        println("show ecg pressed")
        PLOT_DATA[:y] = ecg_data.LR
        PLOT_DATA[:x_rr] = txd_data.time[1:3] .- 200
    end

    CImGui.End()
end

# # main functinon
function show_gui()
    Renderer.render(
        ui, # function object
        width = 1360, 
        height = 780, 
        title = "", 
        hotloading = true
    )
    return nothing
end

show_gui()