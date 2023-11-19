#include <stdio.h>
#include <stdlib.h>


#include "isValidValue.h"


float** create_matrix(int rows, int cols) {
	float** matrix;
	
	matrix = malloc(rows * sizeof(float*));
	
	for (int i = 0; i < rows; i++) {
		matrix[i] = malloc(cols * sizeof(float));
	}
	
	return matrix;
}

void free_matrix(float** matrix, int rows) {
	for (int i = 0; i < rows; i++) {
		free(matrix[i]);
  	}

  	free(matrix);
}


void matriz_diaria_resumo (
                           int periocidade, // tamanho do vetor sensor (frequencia das medidas do sensor)
                           int * sensor, // sensor a calcular
                           float ** matriz_nova, // matriz a editar (min max media)
                           int linha, // linha a editar na matriz
                           int upperLimit, // valor maximo que o valor pode gerar
                           int lowerLimit // valor minimo que o valor pode gerar
                           )
                           {

    int valorMinimo, valorMaximo, valorGerado, soma;
    float valorMedio, contador;

    valorMaximo = lowerLimit;
    valorMinimo = upperLimit;
    soma = 0;
    contador = 0;


    for (int i = 0; i < periocidade; i++) {
        valorGerado = *(sensor + i);

        if(isValid(valorGerado, lowerLimit, upperLimit)){
            soma += valorGerado;
            contador++;

            if (valorGerado < valorMinimo) {
                valorMinimo = valorGerado;
            } if (valorGerado > valorMaximo) {
                valorMaximo = valorGerado;
            }
        }
    }
    

    if(contador != 0) {
        valorMedio = (float) soma / contador;
    } else {
        valorMedio = 0;
        valorMinimo = 0;
        valorMaximo = 0;
    }

    *(*(matriz_nova + linha)) = (float) valorMaximo;
    *(*(matriz_nova + linha) + 1) = (float) valorMinimo;
    *(*(matriz_nova + linha) + 2) = valorMedio;
}
