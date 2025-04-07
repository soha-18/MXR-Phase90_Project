using ACME
using Plots
using Waveforms
using WAV
plotlyjs()
include("JFET_model_lambda.jl")
a, fs = wavread("sinesweep_0.2.wav")
#fs = 96000
u = transpose(a)
#t = collect(range(0,stop=1,step=1/fs))
#u = 1*sin.(2π*200*t)
phase = 0
t = transpose(1/fs*collect(range(0,stop=length(u)-1,step=1)))
v = 1.8*trianglewave.(2π*8*(t .- phase))
x = zeros(2,length(u))
x[1,:] = u
x[2,:] = v
y = zeros(1,length(u))
circ = @circuit begin
    G_in = voltagesource()
    Vref = voltagesource(5.1)
    vBias = voltagesource(; rs=1)
    r3 = resistor(10e3)
    c5 = capacitor(1e-8)
    r14 = resistor(470e3)
    r1 = resistor(10e3)
    r5 = resistor(10e3)
    r10 = resistor(10e3)
    r11 = resistor(10e3)
    r12 = resistor(10e3)
    r13 = resistor(10e3)
    r17 = resistor(10e3)
    r18 = resistor(10e3)
    r6 =  resistor(24e3)
    r25 = resistor(24e3)
    r26 = resistor(24e3)
    r23 = resistor(24e3)
    r16 = resistor(150e3)
    r8 = resistor(150e3)
    r7 = resistor(150e3)
    r2 = resistor(150e3)
    r4 = resistor(56e3)
    c1 = capacitor(47e-9)
    c3 = capacitor(47e-9)
    c6 = capacitor(47e-9)
    c9 = capacitor(47e-9)
    c2 = capacitor(47e-9)
    U1a = opamp()
    U2a = opamp()
    U2d = opamp()
    U2c = opamp()
    U2b = opamp()
    Q2 = jfet(:n; vp = -3, idss = 10e-3, λ = 0.018)
    Q3 = jfet(:n; vp = -3, idss = 10e-3, λ = 0.018)
    Q4 = jfet(:n; vp = -3, idss = 10e-3, λ = 0.02)
    Q5 = jfet(:n; vp = -3, idss = 10e-3, λ = 0.018)
    Q1 = bjt(:pnp, is=1e-14,βf=100)
    v_out = voltageprobe()
    #input_buffer
    G_in[+] == r3[1]
    G_in[-] == gnd
    r3[2] == c5[1]
    c5[2] == r14[1] == U1a["in+"]
    U1a["in-"] == U1a["out+"] == r16[1] == r1[1] == c1[1]
    r14[2] == Vref[+]
    #phase_shift
    r1[2] == r5[1] == U2a["in-"]
    Q2[drain] == r6[1]
    c1[2] == r6[1] == U2a["in+"]
    r5[2] == U2a["out+"] == r11[1] == c3[1]
    r11[2] == r10[1] == U2d["in-"]
    Q3[drain] == r25[1]
    c3[2] == r25[1] == U2d["in+"]
    r10[2] == U2d["out+"] == r12[1] == c6[1]
    r12[2] == r13[1] == U2c["in-"]
    Q4[drain] == r26[1]
    c6[2] == r26[1] == U2c["in+"]
    r13[2] == U2c["out+"] == r17[1] == c9[1]
    r17[2] == r18[1] == U2b["in-"]
    Q5[drain] == r23[1]
    c9[2] == r23[1] == U2b["in+"]
    r18[2] == U2b["out+"] == r8[1]
    r6[2] == Q2[source] == Vref[+]
    r25[2] == Q3[source] == Vref[+]
    r26[2] == Q4[source] == Vref[+]
    r23[2] == Q5[source] == Vref[+]
    Q2[gate] == Q3[gate] == Q4[gate] == Q5[gate] == vBias[+]
    #output_mixer
    Vref[+] == Q1[emitter]
    r16[2] == r8[2] == r7[1] == Q1[base]
    r7[2] == Q1[collector] == r4[1] == c2[1]
    c2[2] == r2[1] == v_out[+]
    r4[2] == r2[2] == gnd
    Vref[-] ==  vBias[-] ==  v_out[-] == gnd
    U1a["out-"] == U2a["out-"] == U2d["out-"] == U2c["out-"] == U2b["out-"] == gnd
end

model = DiscreteModel(circ, 1/fs)
runner = ModelRunner(model, true)
run!(runner, y, x)
#wavplay(vec(y),fs)
wavwrite(transpose(y),"offset_0V.wav", Fs = fs)
