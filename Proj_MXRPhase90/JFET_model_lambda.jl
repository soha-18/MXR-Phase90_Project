using ACME
using StaticArrays

function jfet(typ; vp, idss, λ)
    if typ == :n
        polarity = 1
    elseif typ == :p
        polarity = -1
    else
        throw(ArgumentError("Unknown JFET type $(typ), must be :n or :p"))
    end
            return ACME.Element(mv=[-1 0; 0 -1; 0 0; 0 0],
                mi=[0 0; 0 0; 0 -1; 1 0],
                mq=polarity*[1 0 0; 0 1 0; 0 0 1; 0 0 0],
        ports=[:gate => :source, :drain => :source],
        nonlinear_eq = @inline function (q)
            vgs, vds, id = q
            id = id
            vp1 = polarity*vp
            K = (idss/vp1^2)
        if vgs <= vp1 && vds >= 0
            res = @SVector [-id]
            J = @SMatrix [0.0 0.0 -1.0]
        elseif vds < vgs - vp1 && vds >= 0
            res = @SVector [(2*K*(vgs-vp1-(vds/2))*vds*(1+λ*vds)) - id]
            J = @SMatrix [((2*K*vds)*(1+λ*vds)) (2*K*(vgs-vp1-vds)+(K*λ*(4*vgs-4*vp1-3*vds)*vds)) -1.0]
        elseif vds >= vgs - vp1 && vds >= 0
            res = @SVector [idss*((1-vgs/vp1)^2)*(1+λ*vds) - id]
            J = @SMatrix [(2*(-(idss/vp1))*(1-vgs/vp1)*(1+λ*vds)) (idss*((1-vgs/vp1)^2)*λ) -1.0]
        else
            res = @SVector [-id]
            J = @SMatrix [0.0 0.0 -1.0]
            end
            return (res,J)
        end)
    end
