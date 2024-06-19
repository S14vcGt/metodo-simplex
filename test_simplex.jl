using Test
include("metodo_simplex.jl")  # Asegúrate de que este es el nombre de tu archivo que contiene la implementación del Simplex

@testset "Pruebas del Método Simplex" begin
    # Caso de prueba 1: Prueba básica para verificar solución óptima
    tabla1 = [
        [1, -2, -5, -8, 0, 0, 0, 0],
        [0, 1, 1, 1, 1, 0, 0, 12],
        [0, 8, -4, 4, 0, 1, 0, 24],
        [0, 0, 1, 1, 0, 0, 1, 8]
    ]
    @testset "Solución Óptima" begin
        sol_text = Set(["Solución óptima"])
        columna_pivote = argmin(tabla1[1])
        Max_simplex(tabla1, columna_pivote, sol_text)
        @test "única." in sol_text
    end

    # Caso de prueba 2: Verifica solución no acotada
    tabla2 = [
        [1, 24, 32, 48, 0, 0, 0, 0],
        [0, -1, -1, -1, -1, 0, 0, -400],
        [0, -1, -1, -2, 0, -1, 0, -600],
        [0, -2, -3, -5, 0, 0, -1, -1500]
    ]
    @testset "Solución No Acotada" begin
        columna_pivote = argmin(tabla2[1])
        result = Max_simplex(tabla2, columna_pivote)
        @test result == "Solución no acotada"
    end

    # Añade más pruebas según las necesidades de tu proyecto
end
