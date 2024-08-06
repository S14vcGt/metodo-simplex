include("solver.jl")
include("output.jl")
include("input.jl")
import .Solver, .Output, .Input

# Una interfaz de línea de comandos que le pregunte cuál es la entrada
function simplex()
    solucion = 0
    entrada::Tuple = Input.parseEntrada()
    if !entrada[1]

        if !entrada[2]
            Input.normalizarVarNegativas(entrada[3], lastindex(entrada[4]))
        end

        prueba = Solver.getSolucion(entrada[3], entrada[2])
        solucion = Solver.solve(prueba, false)
    else
        solucion = dosFases(entrada)
    end
    final = join(solucion.Textual)

    Output.escribirTablaIntermedia(solucion.Historial)
    Output.escribirTablaFinal(solucion.Tabular)
    Output.escribirSolucion(final)
    Output.escribirValoresVariables(solucion.Tabular)
end

function dosFases(entrada)
    prueba = Solver.getSolucion(entrada[3], false)
    fase1 = Solver.solve(prueba, true, lastindex(entrada[4]))
    Output.escribirTablaFinal(fase1.Tabular)

    completeHistorial = push!(fase1.Historial, fase1.Tabular)
    Input.parseTabla(fase1.Tabular, entrada[5], entrada[4])
    prueba = Solver.getSolucion(fase1.Tabular, entrada[2], completeHistorial)
    fase2 = Solver.solve(prueba, false)
    return fase2
end

simplex()
