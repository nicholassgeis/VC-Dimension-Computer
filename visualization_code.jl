using PlotlyJS, IterTools

#Generates the ball of readius r1, r2, r_3

function ball_generator(r1, r2, r3)
    return product(-r1:r1, -r2:r2, -r3:r3)
end

function multiply_h(n, b)
    return [n[1] + b[1], n[2] + b[2], n[3] + b[3] + n[1]b[2]]
end

function baller_graph(N, r1, r2, r3)
    generator = ball_generator(r1, r2, r3)
    holder = [multiply_h(N, entry) for entry in generator]
    x_t = [holder[i][1] for i in 1:length(holder)]
    y_t = [holder[i][2] for i in 1:length(holder)]
    z_t = [holder[i][3] for i in 1:length(holder)]
    plot(scatter(x=x_t, y=y_t, z=z_t, mode="markers", marker=attr(size=11, opacity=0.8), type="scatter3d"), Layout(margin=attr(l=0, r=0, b=0, t=0)))
end

