include("solver.jl")
include("output.jl")
import .Solver, .Output

# una interfaz de linea de comandos que le pregunte cual es la entrada
#por terminal
#por archivo tex

#elija la salida
#por terminal
#en archivo tex
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
prueba = Solver.Solucion(tabla2, Set(["Solución óptima"]), argmin(tabla2[1]))
solucion = Solver.maximizar(prueba)
final = join(solucion.Textual)
Output.escribirTablaFinal(solucion.Tabular)
Output.escribirSolucion(final)

