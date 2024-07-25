module Output
#todo si son 1 o 2 variables, que se grafique
function escribirSolucion(sol::String)
    printstyled("\n $sol \n"; color=:light_green, bold=true)
end

function escribirTablaFinal(sol::Vector)
    printstyled("\n La tabla final es:\n"; color=:cyan, bold=true)
    for i in eachindex(sol)
        printstyled("$(sol[i])\n"; color=:light_cyan)
    end
end

function escribirTablaIntermedia(tablas::Set)
    foreach((tabla) -> escribirVector(tabla), tablas)
end

function escribirVector(tabla::Vector)
    for i in eachindex(tabla)
        printstyled("$(tabla[i])\n"; color=:light_blue)
    end
    print("\n")
end
end