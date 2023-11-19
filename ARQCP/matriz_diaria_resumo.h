#ifndef ASM_H
#define ASM_H
float** create_matrix(int rows, int cols);
void free_matrix(float** matrix, int rows);
void matriz_diaria_resumo (unsigned long periocidade, int * sensor, float ** matriz_nova, int linha, int upperLimit, int lowerLimit);
int isValid(int number, int lower, int upper);
#endif
