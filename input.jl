module Input

function parseEntrada(path="entrada.txt")
    entrada = []
    dos_fases::Bool
    for line in eachline(path)
        append!(entrada, [split(line, ',')])
    end
    restricciones = map((x) ->
            map(y ->
                    if y in ["=", ">=", "<="]
                        return y
                    else
                        return parse(Int, y)
                    end, x), entrada)

    funcion_objetivo = popfirst!(restricciones)
    soluciones = map(x -> popat!(x, lastindex(x)), restricciones)
    pushfirst!(soluciones, 0)

    eres = agregarR(restricciones)
    holguras = agregarS(restricciones)
    coeficientes = sacarCoeficientes(restricciones)

    if isempty(eres)
        dos_fases = false
        for i in eachindex(coeficientes)
            coeficientes[i][1] = funcion_objetivo[i]
        end

    else
        dos_fases = true
        fila_objetivo::Vector{Int} = [0 for _ in 1:(length(restricciones)+1)]
        fila_objetivo[1] = 1
        pushfirst!(coeficientes, fila_objetivo)
    end

    append!(coeficientes, holguras, eres, [soluciones])
    final = transpuesta(coeficientes)

    return (dos_fases, funcion_objetivo, final)
end
function agregarR(restricciones)# si no hay eres el programa debe saber que no debe normalizar otra vez para resolver
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
function sacarCoeficientes(restricciones)
    last = length(restricciones) - 1
    result::Vector{Vector{Int}} = []

    coeficientes = map((x) -> x[1:last], restricciones)
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
