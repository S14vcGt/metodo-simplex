module Input

function parseEntrada(path="entrada.tex")
    tabla = []
    for line in eachline(path)
        if !occursin(r"uj|au|un", line)
            m = match(r"\dx_\d|(=|<=)\d", line)
            if m !== nothing
                for exp in m.captures
                    println(exp)
                end
            end
        end
    end
    return tabla
end
end
function hor()
    next = [1, 2, 3]
    sol = Set([[1, 2, 3]])
    push!(sol, [4, 5, 6])
    print("$(next ∈ sol)")
end
hor()