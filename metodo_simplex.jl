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

function parseEntrada(path="entrada.txt")
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
function Max_simplex(table, columna_pivote, solucion_textual=Set(["Solución óptima"]), iter=1)
    #determino el elemento pivote
    global table_no_function = table[2:end]# primero elimino la fila de la funcion objetivo
    global min = 1e10
    global fila_pivote = 0
    for i in eachindex(table_no_function)
        if table_no_function[i][columna_pivote] > 0
            actual = table_no_function[i][end] / table_no_function[i][columna_pivote]#aplico la prueba del conciente minimo
            actual == min ? push!(solucion_textual, " degenerada") : 0#si alguno de los valores resultantes es igual al minino guardado, es degenerada
            if actual ≤ min
                min = actual
                fila_pivote = i
            end
        end
    end
    if fila_pivote == 0
        return println("Solución no acotada")
    end
    fila_pivote += 1
    global nextable = fill([0.0], length(table))
    nextable[fila_pivote] = (1 / table_no_function[fila_pivote-1][columna_pivote])table_no_function[fila_pivote-1]
    for i in eachindex(nextable)
        if (i != fila_pivote)
            nextable[i] = -table[i][columna_pivote] * nextable[fila_pivote] + table[i]
        end
    end
    # se aplica la condicion de optimalidad
    if minimum(nextable[1]) < 0
        printstyled("\n Tabla $iter \n"; color=:blue)
        for i in eachindex(nextable)
            printstyled("$(nextable[i])\n"; color=:light_blue)
        end
        Max_simplex(nextable, argmin(nextable[1]), solucion_textual, iter + 1)
    else
        noBasicas = map((x) -> isNoBasic(x), transpuesta(nextable))
        for i in eachindex(nextable[1])
            if noBasicas[i] && nextable[1][i] == 0# si es multiple...
                append!(solucion_textual, " múltiple")
                printstyled("\nsolución encontrada:\n"; color=:cyan, bold=true)
                for i in eachindex(nextable)
                    printstyled("$(nextable[i])\n"; color=:light_cyan)
                end
                return Max_simplex(nextable, i, solucion_textual, iter + 1)
            end
        end
        printstyled("\n La tabla final es:\n"; color=:cyan, bold=true)
        for i in eachindex(nextable)
            printstyled("$(nextable[i])\n"; color=:light_cyan)
        end
        " múltiple." ∉ solucion_textual ? push!(solucion_textual, " única.") : 0
        final = join(solucion_textual)
        printstyled("\n $final \n"; color=:light_green, bold=true)
    end
end

table = [
    [1, -2, -5, -8, 0, 0, 0, 0],
    [0, 1, 1, 1, 1, 0, 0, 12],
    [0, 8, -4, 4, 0, 1, 0, 24],
    [0, 0, 1, 1, 0, 0, 1, 8]
]
table2 = [
    [1, -24, -32, -48, 0, 0, 0, 0],
    [0, 1, 1, 1, 1, 0, 0, 400],
    [0, 1, 1, 2, 0, 1, 0, 600],
    [0, 2, 3, 5, 0, 0, 1, 1500]
]
parseEntrada()
#trans = transpuesta(table)
#println(trans)
#println(map((x) -> isBasic(x), trans))
Max_simplex(table2, argmin(table2[1]))#falta manejar soluciones multiples y ciclos degenerados ?como identificar un ciclo degenerado
# se debe pasar como parametro el indice de la vaiable de entrada para poder manejar soluciones multiples