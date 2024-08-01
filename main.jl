include("solver.jl")
include("output.jl")
include("input.jl")
import .Solver, .Output, .Input

# una interfaz de linea de comandos que le pregunte cual es la entrada

function simplex()
    solucion = 0
    entrada::Tuple = Input.parseEntrada()
    if !entrada[1]
        prueba = Solver.getSolucion(entrada[3], entrada[2])
        #print(`$(prueba.ColumnaPivote)`)#todo quitar
        solucion = Solver.solve(prueba, false)
    else
        solucion = dosFases(entrada)
    end
    final = join(solucion.Textual)
    #solucion = Solver.redondear(solution)#todo no necesario
    Output.escribirTablaIntermedia(solucion.Historial)
    Output.escribirTablaFinal(solucion.Tabular)
    Output.escribirSolucion(final)
end

function dosFases(entrada)
    prueba = Solver.getSolucion(entrada[3], false)
    print(`$(prueba.ColumnaPivote)`)#todo quitar
    Output.escribirTablaFinal(prueba.Tabular)

    fase1 = Solver.solve(prueba, true)

    #completeHistorial = push!(fase1.Historial, fase1.Tabular)
    #prueba = Solver.getSolucion(fase1.Tabular, entrada[2], completeHistorial)
    #fase2 = Solver.solve(prueba,false)
    return fase1
end

simplex()