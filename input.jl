module Input

function parseEntrada(path="entrada.txt")
    entrada = []
    dos_fases = true
    maximizar = nothing
    final = []

    for line in eachline(path)
        append!(entrada, [split(line, ',')])
    end
    restricciones = map((x) ->
            map(y ->
                    if y in ["=", ">=", "<=", "MAX", "MIN"]
                        return y
                    else
                        return parse(Int, y)
                    end, x), entrada)

    funcion_objetivo = popfirst!(restricciones)

    op = popfirst!(funcion_objetivo)
    if op == "MAX"
        maximizar = true
    elseif op == "MIN"
        maximizar = false
    end

    soluciones = map(x -> popat!(x, lastindex(x)), restricciones)
    pushfirst!(soluciones, 0)

    eres = agregarR(restricciones)
    holguras = agregarS(restricciones)
    coeficientes = sacarCoeficientes(restricciones, length(funcion_objetivo))

    if isempty(eres)
        dos_fases = false
        for i in eachindex(coeficientes)
            coeficientes[i][1] = -funcion_objetivo[i]
        end
    end

    agregarColumnaObjetivo(coeficientes)
    append!(coeficientes, holguras, eres, [soluciones])
    final = transpuesta(coeficientes)

    if dos_fases
        return (dos_fases, maximizar, normalizarEresNegativas(final, length(eres)), funcion_objetivo)
    else
        return (dos_fases, maximizar, final, funcion_objetivo)
    end
end

function normalizarEresNegativas(final, eres)
    largo = length(final[1])
    for index in 1:eres
        columna = largo - index#? para normalizarVariablesNegativas tendria que se 2:largo+1
        fila = 0
        for i in eachindex(final)
            if final[i][columna] == 1
                fila = i
            end
        end
        newZ = final[1] + final[fila]
        final[1] = newZ
    end
    return final
end

function agregarColumnaObjetivo(coeficientes)

    columnaObjetivo::Vector{Int} = [0 for _ in 1:(length(coeficientes[1]))]
    columnaObjetivo[1] = 1
    pushfirst!(coeficientes, columnaObjetivo)

end

function agregarR(restricciones)
    resolve = []

    for i in eachindex(restricciones)
        for j in eachindex(restricciones[i])
            if restricciones[i][j] in ["=", ">="]
                eres = [0 for _ in 1:(length(restricciones)+1)]
                eres[1] = -1
                eres[i+1] = 1
                push!(resolve, eres)
            end
        end
    end

    return resolve
end

function agregarS(restricciones)
    resolve = []
    numb = 0

    for i in eachindex(restricciones)
        for j in eachindex(restricciones[i])
            if restricciones[i][j] in [">=", "<="]
                if restricciones[i][j] == ">="
                    numb = -1
                else
                    numb = 1
                end
                eres = [0 for _ in 1:(length(restricciones)+1)]
                eres[i+1] = numb
                push!(resolve, eres)
            end
        end
    end

    return resolve

end

function sacarCoeficientes(restricciones, variables)
    result::Vector{Vector{Int}} = []

    coeficientes = map((x) -> x[1:variables], restricciones)
    trans = transpuesta(coeficientes)
    append!(result, map(x -> pushfirst!(x, 0), trans))

    return result
end

function transpuesta(l)
    final = []
    for i in eachindex(l[1])
        append!(final, [map((x) -> x[i], l)])
    end
    return final
end
parseEntrada()
end
