module Output

using DataFrames

function escribirSolucion(sol::String)
    println()
    printstyled("\n $sol \n"; color=:light_green, bold=true)
end

function escribirTablaFinal(sol::Vector{Vector{Float64}})
    mat = hcat(sol...)'
    df = DataFrame(Z=mat[1:4, 1], X1=mat[1:4, 2], X2=mat[1:4, 3], X3=mat[1:4, 4], S1=mat[1:4, 5], S2=mat[1:4, 6], S3=mat[1:4, 7], Solucion=mat[1:4, 8])
    printstyled("\n La tabla final es:\n"; color=:cyan, bold=true)
    show(df, allrows=true, allcols=true)
end

function escribirValoresVariables(sol::Vector{Vector{Float64}})
    mat = hcat(sol...)'
    df = DataFrame(mat, :auto)

    # Nombres de las variables hardcodeados
    variables = ["Z", "x1", "s2", "x3"]

    # Extraer los valores finales de las variables
    final_values = [df[i, end] for i in 1:length(variables)]

    println("\nValores de las variables:")
    for (var, val) in zip(variables, final_values)
        printstyled("\n $var: ", color=:magenta, bold=true)
        printstyled("$(round(val, digits=4))", color=:light_blue, bold=true)
    end
    println("\n")
end

function escribirValoresVariables(sol::Vector{Vector{Float64}})
    mat = hcat(sol...)'
    df = DataFrame(mat, :auto)

    # Nombres de las variables hardcodeados
    variables = ["Z", "x1", "s2", "x3"]

    # Extraer los valores finales de las variables
    final_values = [df[i, end] for i in 1:length(variables)]

    println("\nValores de las variables:")
    for (var, val) in zip(variables, final_values)
        printstyled("\n $var: ", color=:magenta, bold=true)
        printstyled("$(round(val, digits=4))", color=:light_blue, bold=true)
    end
    println("\n")
end

function escribirTablaIntermedia(tablas::Vector{Vector{Vector{Float64}}}, numVar)
    foreach((tabla) -> escribirVector(tabla), tablas)
end

function escribirVector(tabla::Vector{Vector{Float64}})
    aux = map(x -> round.(x, digits=4), tabla)
    mat = hcat(aux...)'
    df = DataFrame(mat, :auto)
    show(df, allrows=true, allcols=true)
    println("\n")
end

end
