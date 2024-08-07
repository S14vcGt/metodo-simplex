module Solver

struct Solucion
    Tabular::Vector{Vector{Float64}}
    Textual::Set{String}
    ColumnaPivote::Integer
    Historial::Vector{Vector{Vector{Float64}}}
    Maximizar::Bool
end

function getSolucion(table::Vector, maximizar::Bool, historial::Vector=Vector(), texto::Set{String}=Set(["Solución óptima"]))
    fx = 0
    if maximizar
        fx = (x::Vector) -> argmin(x)
    else
        fx = (x::Vector) -> argmax(x[2:end-1]) + 1 # se le suma 1 porque no se toma en cuenta el indice de
    end                                          # la columna de la funcion objetivo
    return Solucion(table, texto, fx(table[1]), historial, maximizar)
end

function CondicionOptimilidad(nextable::Vector, maximizar::Bool, dosFases::Bool, numVariables)
    if maximizar
        return minimum(nextable) < 0
    else
        if !dosFases
            return maximum(nextable[2:end-1]) > 0
        else
            return maximum(nextable[2:numVariables+1]) > 0
        end
    end
end

function obtenerFilaPivote(sol::Solucion)
    global table_no_function = sol.Tabular[2:end] # primero elimino la fila de la funcion objetivo
    global min = 1e10
    global fila_pivote = 0
    for i in eachindex(table_no_function)
        if table_no_function[i][sol.ColumnaPivote] > 0
            actual = table_no_function[i][end] / table_no_function[i][sol.ColumnaPivote] # aplico la prueba del cociente mínimo
            actual == min ? push!(sol.Textual, " degenerada") : 0 # si alguno de los valores resultantes es igual al mínimo guardado, es degenerada
            if actual ≤ min
                min = actual
                fila_pivote = i
            end
        end
    end
    return fila_pivote
end

function solve(sol::Solucion, dosFases::Bool, numVar=0)
    global fila_pivote = obtenerFilaPivote(sol)

    if fila_pivote == 0
        push!(sol.Textual, "Solución no acotada")
        return sol
    end

    fila_pivote += 1
    global nextable = fill([0.0], length(sol.Tabular))
    nextable[fila_pivote] = (1 / sol.Tabular[fila_pivote][sol.ColumnaPivote]) * sol.Tabular[fila_pivote]
    for i in eachindex(nextable)
        if (i != fila_pivote)
            nextable[i] = (-sol.Tabular[i][sol.ColumnaPivote] * nextable[fila_pivote]) + sol.Tabular[i]
        end
    end

    # Se aplica la condición de optimalidad
    if CondicionOptimilidad(nextable[1], sol.Maximizar, dosFases, numVar)
        push!(sol.Historial, nextable)
        return solve(getSolucion(nextable, sol.Maximizar, sol.Historial, sol.Textual), dosFases, numVar)
    else
        if !dosFases
            noBasicas = map((x) -> isNoBasic(x), transpuesta(nextable))
            for i in eachindex(nextable[1])
                if noBasicas[i] && nextable[1][i] == 0
                    if nextable ∉ sol.Historial
                        push!(sol.Textual, " múltiple")
                        printstyled("\nsolución encontrada:\n"; color=:cyan, bold=true)
                        for j in eachindex(nextable)
                            printstyled("$(nextable[j])\n"; color=:light_cyan)
                        end
                        println("$(nextable ∉ sol.Historial)")
                        push!(sol.Historial, nextable)
                        return solve(Solucion(nextable, sol.Textual, i, sol.Historial, sol.Maximizar), dosFases)
                    else
                        return Solucion(nextable, sol.Textual, i, sol.Historial, sol.Maximizar)
                    end
                end
            end
        end
        " múltiple." ∉ sol.Textual ? push!(sol.Textual, " única.") : 0
        return Solucion(nextable, sol.Textual, sol.ColumnaPivote, sol.Historial, sol.Maximizar)
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
end