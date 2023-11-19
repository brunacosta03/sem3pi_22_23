#ifndef EXPORT_FILE_H
#define EXPORT_FILE_H
#include "sensores.h"
void export_matrix(float **matrix, int n_rows);
void export_sensors(Sensor * sensores_temp, Sensor * sensores_velc_vento, Sensor * sensores_dir_vento, Sensor * sensores_pluvio, Sensor * sensores_humd_atm, Sensor * sensores_humd_solo);
#endif