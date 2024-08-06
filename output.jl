module Output

function escribirSolucion(sol::String)
    printstyled("\n $sol \n"; color=:light_green, bold=true)
end

function escribirTablaFinal(sol::Vector)
    printstyled("\n La tabla final es:\n"; color=:cyan, bold=true)
    for i in eachindex(sol)
        printstyled("$(round.(sol[i],digits=4))\n"; color=:light_cyan)
    end
end

function escribirTablaIntermedia(tablas::Vector)
    foreach((tabla) -> escribirVector(tabla), tablas)
end

function escribirVector(tabla::Vector)
    for i in eachindex(tabla)
        printstyled("$(round.(tabla[i],digits=4))\n"; color=:light_blue)
    end
    print("\n")
end

end