#ifndef SENSORES_H
#define SENSORES_H
typedef struct{
	unsigned short id;
	unsigned char sensor_type;
	unsigned short max_limit; // limites do sensor
	unsigned short min_limit;
	unsigned long frequency; // frequency de leituras (em segundos)
	unsigned long readings_size; // tamanho do array de leituras
	unsigned short *readings; // array de leituras di�rias
	int count_wrong;
 } Sensor;

char sens_temp(char ult_temp, char comp_rand);

unsigned char sens_velc_vento(unsigned char ult_velc_vento, char comp_rand);

unsigned short sens_dir_vento(unsigned short ult_dir_vento, short comp_rand);

unsigned char sens_humd_atm(unsigned char ult_hmd_atm, unsigned char ult_pluvio, char comp_rand);

unsigned char sens_humd_solo(unsigned char ult_hmd_solo, unsigned char ult_pluvio, char comp_rand);

unsigned char sens_pluvio(unsigned char ult_pluvio, char ult_temp, char comp_rand);

void show_sensores(Sensor * sensores_temp, Sensor * sensores_velc_vento, Sensor * sensores_dir_vento, Sensor * sensores_pluvio, Sensor * sensores_humd_atm, Sensor * sensores_humd_solo);

void show_stats_sensores(float** matrix);

Sensor * create_sensores(int n_sensores);

void fill_sens_data(Sensor * ptr_sensor, unsigned short id, unsigned char sensor_type, unsigned short max_limit, unsigned short min_limit, unsigned long frequency);

void update_sens_data(Sensor * ptr_sensor, unsigned long frequency);

void fill_sens_temp(Sensor * sensor_temp);

void fill_sens_velc_vento(Sensor * sensor_velc_vento);

void fill_sens_dir_vento(Sensor * sensor_dir_vento);

void fill_sens_pluvio(Sensor * sensor_pluvio, Sensor * sensor_temp);

void fill_sens_humd_atm(Sensor * sensor_humd_atm, Sensor * sensor_pluvio);

void fill_sens_humd_solo(Sensor * sensor_humd_solo, Sensor * sensor_pluvio);

void free_sensores(Sensor * sensores, int n_sensores);

void add_sensores_menu(Sensor ** sensores_temp, Sensor ** sensores_velc_vento, Sensor ** sensores_dir_vento, Sensor ** sensores_pluvio, Sensor ** sensores_humd_atm, Sensor ** sensores_humd_solo);

void new_size_sensores(Sensor ** sensor, int new_size);

int delete_sensores(Sensor ** sensores, int n_sensores);

int getIndexById(Sensor * sensores, int id_sensor, int n_sensores);

void delete_sensores_menu(Sensor ** sensores_temp, Sensor ** sensores_velc_vento, Sensor ** sensores_dir_vento, Sensor ** sensores_pluvio, Sensor ** sensores_humd_atm, Sensor ** sensores_humd_solo);

void alter_sensores_freq_menu(Sensor ** sensores_temp, Sensor ** sensores_velc_vento, Sensor ** sensores_dir_vento, Sensor ** sensores_pluvio, Sensor ** sensores_humd_atm, Sensor ** sensores_humd_solo);

void set_resumo_matriz_sensores_temp(Sensor * sensores_temp, float ** matrix, int line);

void set_resumo_matriz_sensores(Sensor * sensor, int n_sensores, float ** matrix, int line);

void resize_matrix(float*** matrix, int old_rows, int new_rows, int cols);

void set_all_matriz_resumo(Sensor * sensores_temp, Sensor * sensores_velc_vento, Sensor * sensores_dir_vento, Sensor * sensores_pluvio, Sensor * sensores_humd_atm, Sensor * sensores_humd_solo, float ** matrix);
#endif
