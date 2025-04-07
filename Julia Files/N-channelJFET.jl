using ACME
using Plots
using StaticArrays
include("JFET_model.jl")
gr()
vdd=collect(range(0,stop=9,length=500))
v_in=collect(range(-3,stop=0,length=7))
y=zeros(1,500)
y1=zeros(length(v_in),500)

for i = 1:length(v_in)
    jfet_circuit = @circuit begin
        vgs = voltagesource(v_in[i])
        vds = voltagesource()
        j_out = currentprobe()
        J = jfet(:n; vp = -3.0, idss = 10e-3, λ = 0.02)
        vgs[+] == J[gate]
        vds[+] == j_out[+]
        j_out[-] == J[drain]
        vgs[-] == J[source] == vds[-]
    end
    model1 = DiscreteModel(jfet_circuit, 1/7)
    njef = ModelRunner(model1, true)
    run!(njef, y, transpose(vdd))
    y1[i,:]=y
end
plot(vdd,transpose(y1), legend = false)
annotate!([(8.5, -0.0003, ("Vgs= -3V", 10, :blue)), (8.5, 0.000625, ("Vgs= -2.5V", 10, :blue))])
annotate!([(8.5, 0.0015, ("Vgs= -2V", 10, :blue)), (8.5, 0.003, ("Vgs= -1.5V", 10, :blue))])
annotate!([(8.5, 0.0050, ("Vgs= -1V", 10, :blue)), (8.5, 0.0075, ("Vgs= -0.5V", 10, :blue))])
annotate!([(8.5, 0.0105, ("Vgs= 0V", 10, :blue))])
title!("N-channel JFET")
xaxis!("Drain-Source voltage in Volts")
yaxis!("Drain current in Ampere")
