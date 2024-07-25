include("solver.jl")
include("output.jl")
include("input.jl")
import .Solver, .Output, .Input

# una interfaz de linea de comandos que le pregunte cual es la entrada
#por terminal
#por archivo csv

#elija la salida
#por terminal
#en archivo csv
function datos_prueba()
    tabla = [
        [1, -2, -5, -8, 0, 0, 0, 0],
        [0, 1, 1, 1, 1, 0, 0, 12],
        [0, 8, -4, 4, 0, 1, 0, 24],
        [0, 0, 1, 1, 0, 0, 1, 8]
    ]
    tabla2 = [
        [1, -24, -32, -48, 0, 0, 0, 0],
        [0, 1, 1, 1, 1, 0, 0, 400],
        [0, 1, 1, 2, 0, 1, 0, 600],
        [0, 2, 3, 5, 0, 0, 1, 1500]
    ]
    tabla3 = [
        [1, -2, -5, -8, 0, 0, 0, 0],
        [0, 6, 8, 4, 1, 0, 0, 96],
        [0, 2, 1, 2, 0, 1, 0, 40],
        [0, 5, 3, 2, 0, 0, 1, 60]
    ]
    tabla4 = [
        [1, (19 / 6), 0, (-7 / 3), (5 / 6), 0, 0, 25],
        [0, (5 / 6), 1, (2 / 6), (1 / 6), 0, 0, 5],
        [0, (4 / 3), 0, (4 / 3), (-1 / 3), 1, 0, 5],
        [0, (-8 / 3), 0, (1 / 3), (-1 / 3), 0, 1, 0]]
    tabla5 = [
        [1, 0, 0, 0, 0, -1, -1, 0],
        [0, 3, 1, 0, 0, 1, 0, 3],
        [0, 4, 3, -1, 0, 0, 1, 6],
        [0, 1, 2, 0, 1, 0, 0, 4]
    ]
    return tabla5
end
function tres_pr(table)
    return map((x) -> x[1:3], table)

end
test = tres_pr(datos_prueba())
aux = Solver.transpuesta(test)
holguras = [[0, 0, -1, 0], [0, 0, 0, 1]]
eres = [[-1, 1, 0, 0], [-1, 0, 1, 0]]
soluciones = [[0, 3, 6, 4]]
append!(aux, holguras, eres, soluciones)
aux2 = Solver.transpuesta(aux)
println("$(aux)")
println("$(aux2)")

#prueba = Solver.getSolucion(test, false)
#print(`$(prueba.ColumnaPivote)`)
#solucion = Solver.maximizar(prueba)
#final = join(solucion.Textual)
#solucion = Solver.redondear(solution)
#Output.escribirTablaIntermedia(solucion.Historial)
#Output.escribirTablaFinal(solucion.Tabular)
#Output.escribirSolucion(final)

