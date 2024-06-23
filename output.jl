module Output

function escribirSolucion(sol::String)
    printstyled("\n $sol \n"; color=:light_green, bold=true)
end

function escribirTablaFinal(sol::Vector{Vector{Float64}})
    printstyled("\n La tabla final es:\n"; color=:cyan, bold=true)
    for i in eachindex(sol)
        printstyled("$(sol[i])\n"; color=:light_cyan)
    end
end

end