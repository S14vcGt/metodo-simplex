module Solver
struct Solucion
    Tabular::Vector{Vector{Float64}}
    Textual::Set
    ColumnaPivote::Integer
end

function maximizar(sol::Solucion, iter=1)

    global table_no_function = sol.Tabular[2:end]# primero elimino la fila de la funcion objetivo
    global min = 1e10
    global fila_pivote = 0

    for i in eachindex(table_no_function)
        if table_no_function[i][sol.ColumnaPivote] > 0
            actual = table_no_function[i][end] / table_no_function[i][sol.ColumnaPivote]#aplico la prueba del conciente minimo
            actual == min ? push!(sol.Textual, " degenerada") : 0#si alguno de los valores resultantes es igual al minino guardado, es degenerada
            if actual ≤ min
                min = actual
                fila_pivote = i
            end
        end
    end

    if fila_pivote == 0
        sol.Textual = Set(["Solución no acotada"])
        return sol
    end

    fila_pivote += 1
    global nextable = fill([0.0], length(sol.Tabular))
    nextable[fila_pivote] = (1 / sol.Tabular[fila_pivote][sol.ColumnaPivote])sol.Tabular[fila_pivote]

    for i in eachindex(nextable)
        if (i != fila_pivote)
            nextable[i] = -sol.Tabular[i][sol.ColumnaPivote] * nextable[fila_pivote] + sol.Tabular[i]
        end
    end

    # se aplica la condicion de optimalidad
    if minimum(nextable[1]) < 0
        escribirTablaIntermedia(nextable, iter)
        maximizar(Solucion(nextable, sol.Textual, argmin(nextable[1])), iter + 1)
    else
        noBasicas = map((x) -> isNoBasic(x), transpuesta(nextable))
        for i in eachindex(nextable[1])
            if noBasicas[i] && nextable[1][i] == 0# si es multiple...
                push!(sol.Textual, " múltiple")
                printstyled("\nsolución encontrada:\n"; color=:cyan, bold=true)
                for i in eachindex(nextable)
                    printstyled("$(nextable[i])\n"; color=:light_cyan)
                end
                if iter ≤ 50
                    return maximizar(Solucion(nextable, sol.Textual, i), iter + 1)
                else
                    return Solucion(nextable, sol.Textual, i)
                end
            end
        end

        " múltiple." ∉ sol.Textual ? push!(sol.Textual, " única.") : 0
        return Solucion(nextable, sol.Textual, iter)
    end
end

function isNoBasic(v)
    goal = length(v)
    return goal != mapreduce(x -> x == 1 || x == 0 ? 1 : 0, +, v)
end

function transpuesta(l)
    final = []
    for i in eachindex(l[1])
        append!(final, [map((x) -> x[i], l)])
    end
    return final
end

function escribirTablaIntermedia(nextable::Vector{Vector{Float64}}, iter::Integer)
    printstyled("\n Tabla $iter \n"; color=:blue)
    for i in eachindex(nextable)
        printstyled("$(nextable[i])\n"; color=:light_blue)
    end
end
#una funcion para minimizar
end