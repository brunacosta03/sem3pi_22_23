#include "export_file.h"
#include "import_file.h"
#include "sensores.h"
#include "matriz_diaria_resumo.h"
#include <stdio.h>
#include <stdlib.h>
#include <stddef.h>

extern struct Config config;
FILE * fp;

void export_matrix(float **matrix, int n_rows) {
    fp = fopen("matriz_data.csv", "w");

    float max, min, med;
    int line = 0;

    if (fp == NULL) {
        printf("Error opening file!\n");
        exit(1);
    }

    fprintf(fp, " ------------ MAX    MIN    MED  ------------\n");

    max = * (*(matrix + line) + 0);
    min = * (*(matrix + line) + 1);
    med = * (*(matrix + line) + 2);

    fprintf(fp, "TEMPERATURE: %.2f | %.2f | %.2f\n", max, min, med);

    line++;

    max = * (*(matrix + line) + 0);
    min = * (*(matrix + line) + 1);
    med = * (*(matrix + line) + 2);

    fprintf(fp, "WIND SPEED: %.2f | %.2f | %.2f\n", max, min, med);

    line++;

    max = * (*(matrix + line) + 0);
    min = * (*(matrix + line) + 1);
    med = * (*(matrix + line) + 2);

    fprintf(fp, "WIND DIRECTION: %.2f | %.2f | %.2f\n", max, min, med);

    line++;
    
    max = * (*(matrix + line) + 0);
    min = * (*(matrix + line) + 1);
    med = * (*(matrix + line) + 2);

    fprintf(fp, "PLUVIOMETER: %.2f | %.2f | %.2f\n", max, min, med);

    line++;

    max = * (*(matrix + line) + 0);
    min = * (*(matrix + line) + 1);
    med = * (*(matrix + line) + 2);

    fprintf(fp, "ATMOSPHERIC HUMIDITY: %.2f | %.2f | %.2f\n", max, min, med);

    line++;

    max = * (*(matrix + line) + 0);
    min = * (*(matrix + line) + 1);
    med = * (*(matrix + line) + 2);

    fprintf(fp, "SOIL HUMIDITY: %.2f | %.2f | %.2f\n", max, min, med);

    fclose(fp);
}

void export_sensors(Sensor * sensores_temp, Sensor * sensores_velc_vento, Sensor * sensores_dir_vento, Sensor * sensores_pluvio, Sensor * sensores_humd_atm, Sensor * sensores_humd_solo) {
    fp = fopen("sensor_data.csv", "w");

    if (fp == NULL) {
        printf("Error opening file!\n");
        exit(1);
    }

    fprintf(fp, "Sensores de Temperatura:\n");
        fprintf(fp, "NUMBER: %ld | MIN: %d | MAX: %d | FREQUENCY: %ld\n", config.n_sensores_temp, (char) sensores_temp->min_limit, sensores_temp->max_limit, sensores_temp->frequency);
        for (int i = 0; i < config.n_sensores_temp; i++) {
            fprintf(fp, "ID: %d | ", sensores_temp[i].id);
            fprintf(fp, "READINGS: ");
            for (int j = 0; j < sensores_temp[i].readings_size; j++) {
                fprintf(fp, "%d ", (char) sensores_temp[i].readings[j]);
            }
            fprintf(fp, "\n");
        }
            fprintf(fp, "\n");

    fprintf(fp, "Sensores de Velocidade do Vento:\n");
        fprintf(fp, "NUMBER: %ld | MIN: %d | MAX: %d | FREQUENCY: %ld\n", config.n_sensores_velc_vento, sensores_velc_vento->min_limit, sensores_velc_vento->max_limit, sensores_velc_vento->frequency);
        for (int i = 0; i < config.n_sensores_velc_vento; i++) {
            fprintf(fp, "ID: %d | ", sensores_velc_vento[i].id);
            fprintf(fp, "READINGS: ");
            for (int j = 0; j < sensores_velc_vento[i].readings_size; j++) {
                fprintf(fp, "%d ", sensores_velc_vento[i].readings[j]);
            }
            fprintf(fp, "\n");
        }
    fprintf(fp, "\n");

    fprintf(fp, "Sensores de Direcao do Vento:\n");
        fprintf(fp, "NUMBER: %ld | MIN: %d | MAX: %d | FREQUENCY: %ld\n", config.n_sensores_dir_vento, sensores_dir_vento->min_limit, sensores_dir_vento->max_limit, sensores_dir_vento->frequency);
        for (int i = 0; i < config.n_sensores_dir_vento; i++) {
            fprintf(fp, "ID: %d | ", sensores_dir_vento[i].id);
            fprintf(fp, "READINGS: ");
            for (int j = 0; j < sensores_dir_vento[i].readings_size; j++) {
                fprintf(fp, "%d ", sensores_dir_vento[i].readings[j]);
            }
            fprintf(fp, "\n");
        }

    fprintf(fp, "\n");

    fprintf(fp, "Sensores de Pluviometro:\n");
        fprintf(fp, "NUMBER: %ld | MIN: %d | MAX: %d | FREQUENCY: %ld\n", config.n_sensores_pluvio, sensores_pluvio->min_limit, sensores_pluvio->max_limit, sensores_pluvio->frequency);
        for (int i = 0; i < config.n_sensores_pluvio; i++) {
            fprintf(fp, "ID: %d | ", sensores_pluvio[i].id);
            fprintf(fp, "READINGS: ");
            for (int j = 0; j < sensores_pluvio[i].readings_size; j++) {
                fprintf(fp, "%d ", sensores_pluvio[i].readings[j]);
            }
            fprintf(fp, "\n");
        }
    fprintf(fp, "\n");

    fprintf(fp, "Sensores de Humidade Atmosferica:\n");
        fprintf(fp, "NUMBER: %ld | MIN: %d | MAX: %d | FREQUENCY: %ld\n", config.n_sensores_humd_atm, sensores_humd_atm->min_limit, sensores_humd_atm->max_limit, sensores_humd_atm->frequency);
        for (int i = 0; i < config.n_sensores_humd_atm; i++) {
            fprintf(fp, "ID: %d | ", sensores_humd_atm[i].id);
            fprintf(fp, "READINGS: ");
            for (int j = 0; j < sensores_humd_atm[i].readings_size; j++) {
                fprintf(fp, "%d ", sensores_humd_atm[i].readings[j]);
            }
            fprintf(fp, "\n");
        }

    fprintf(fp, "\n");

    fprintf(fp, "Sensores de Humidade do Solo:\n");
        fprintf(fp, "NUMBER: %ld | MIN: %d | MAX: %d | FREQUENCY: %ld\n", config.n_sensores_humd_solo, sensores_humd_solo->min_limit, sensores_humd_solo->max_limit, sensores_humd_solo->frequency);
        for (int i = 0; i < config.n_sensores_humd_solo; i++) {
            fprintf(fp, "ID: %d | ", sensores_humd_solo[i].id);
            fprintf(fp, "READINGS: ");
            for (int j = 0; j < sensores_humd_solo[i].readings_size; j++) {
                fprintf(fp, "%d ", sensores_humd_solo[i].readings[j]);
            }
            fprintf(fp, "\n");
        }

    fclose(fp);
}

