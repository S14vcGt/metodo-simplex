using Test

include("metodo_simplex.jl")  # Asegúrate de que este es el nombre de tu archivo que contiene la implementación del Simplex

# Función para capturar la salida de stdout y stderr
function capture_output(f)
    original_stdout = stdout
    original_stderr = stderr

    (rd, wr) = redirect_pipe()
    redirect_stdout(wr)
    redirect_stderr(wr)

    f()

    close(wr)
    redirect_stdout(original_stdout)
    redirect_stderr(original_stderr)

    output = read(rd, String)
    close(rd)
    return output
end

@testset "Pruebas del Método Simplex" begin
    # Caso de prueba 1: Prueba básica para verificar solución óptima
    tabla1 = [
        [1, -2, -3, 0, 0, 0, 0],
        [0, 2, 1, 1, 0, 0, 14],
        [0, 4, 3, 0, 1, 0, 28],
        [0, 2, 5, 0, 0, 1, 30]
    ]
    @testset "Solución Óptima" begin
        sol_text = Set(["Solución óptima"])
        columna_pivote = argmin(tabla1[1])
        result = capture_output() do
            Max_simplex(tabla1, columna_pivote, sol_text)
        end
        @test "única." in sol_text
    end

    # Caso de prueba 2: Verificar otra tabla con solución óptima
    tabla3 = [
        [1, -1, -1, 0, 0, 0, 0],
        [0, 1, 2, 1, 0, 0, 20],
        [0, 2, 1, 0, 1, 0, 20],
        [0, 1, -1, 0, 0, 1, 10]
    ]
    @testset "Solución Óptima 2" begin
        sol_text = Set(["Solución óptima"])
        columna_pivote = argmin(tabla3[1])
        result = capture_output() do
            Max_simplex(tabla3, columna_pivote, sol_text)
        end
        @test "única." in sol_text
    end

    # Caso de prueba 3: Verifica solución no acotada
    tabla2 = [
        [1, 24, 32, 48, 0, 0, 0, 0],
        [0, -1, -1, -1, -1, 0, 0, -400],
        [0, -1, -1, -2, 0, -1, 0, -600],
        [0, -2, -3, -5, 0, 0, -1, -1500]
    ]
    @testset "Solución No Acotada" begin
        columna_pivote = argmin(tabla2[1])
        result = capture_output() do
            Max_simplex(tabla2, columna_pivote)
        end
        @test occursin("Solución no acotada", result)
    end

    # Añade más pruebas según las necesidades de tu proyecto
end
