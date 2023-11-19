#ifndef IMPORTFILE_H
#define IMPORTFILE_H
#include "sensores.h"
struct Config {
  unsigned long f_sensores_temp;
  unsigned long f_sensores_velc_vento;
  unsigned long f_sensores_dir_vento;
  unsigned long f_sensores_pluvio;
  unsigned long f_sensores_humd_atm;
  unsigned long f_sensores_humd_solo;
  unsigned long n_sensores_temp;
  unsigned long n_sensores_velc_vento;
  unsigned long n_sensores_dir_vento;
  unsigned long n_sensores_pluvio;
  unsigned long n_sensores_humd_atm;
  unsigned long n_sensores_humd_solo;
};

int import_file(char * file_name);
void fill_all_sensores(Sensor * sensores_temp, Sensor * sensores_velc_vento, Sensor * sensores_dir_vento, Sensor * sensores_pluvio, Sensor * sensores_humd_atm, Sensor * sensores_humd_solo);
void regenerate_all_sensores(Sensor * sensores_temp, Sensor * sensores_velc_vento, Sensor * sensores_dir_vento, Sensor * sensores_pluvio, Sensor * sensores_humd_atm, Sensor * sensores_humd_solo);
#endif
