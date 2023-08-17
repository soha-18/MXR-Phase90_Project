using ACME
using Plots
using StaticArrays
#gr()
include("JFET_model.jl")

vdd=-collect(range(0,stop=6.5,length=500))
v_in=collect(range(0,stop=3,length=7))
y=zeros(1,500)
y1=zeros(length(v_in),500)

for i = 1:length(v_in)
    jfet_circuit = @circuit begin
        vgs = voltagesource(v_in[i])
        vds = voltagesource()
        j_out = currentprobe()
        J = jfet(:p; vp = 3.0, idss = 10e-3, λ = 0.02)
        vgs[+] == J[gate]
        vds[+] == j_out[+]
        j_out[-] == J[drain]
        vgs[-] == J[source] == vds[-]
    end
    model2 = DiscreteModel(jfet_circuit, 1/500)
    pjef= ModelRunner(model2, true)
    run!(pjef, y, transpose(vdd))
    y1[i,:]=y
end
plot(vdd,transpose(y1), legend = false)
annotate!([(-6, 0.0005, ("Vgs= 3V", 10, :blue)), (-6, -0.000625, ("Vgs= 2.5V", 10, :blue))])
annotate!([(-6, -0.0015, ("Vgs= 2V", 10, :blue)), (-6, -0.003, ("Vgs= 1.5V", 10, :blue))])
annotate!([(-6, -0.0050, ("Vgs= 1V", 10, :blue)), (-6, -0.0065, ("Vgs= 0.5V", 10, :blue))])
annotate!([(-6, -0.0095, ("Vgs= 0V", 10, :blue))])
title!("P-channel JFET")
xaxis!("Drain-Source voltage in Volts")
yaxis!("Drain current in Ampere")
