module Output

using DataFrames

function escribirSolucion(sol::String)
    printstyled("\n $sol \n"; color=:light_green, bold=true)
end

function escribirTablaFinal(sol::Vector{Vector{Float64}})
    mat = hcat(sol...)'
    df = DataFrame(mat, :auto)
    printstyled("\n La tabla final es:\n"; color=:cyan, bold=true)
    show(df, allrows=true, allcols=true)
end

function escribirTablaIntermedia(tablas::Vector{Vector{Vector{Float64}}})
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
