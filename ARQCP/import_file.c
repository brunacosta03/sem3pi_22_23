#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

#include "sensores.h"
#include "import_file.h"

//Numero de sensores de um determinado tipo
extern struct Config config;
extern int max_id;

int import_file(char * file_name){
	FILE *f = fopen(file_name, "r");
	
	if (f == NULL) {
		printf("\n\nFICHEIRO NAO ENCONTRADO!\n");
		printf("\nCOLOQUE UM FICHEIRO \"config_file.cfg\" VALIDO\n\n");
    	
    	fclose(f);
    	return 0;
  	}
  	
  	//Frequecia de leitura para cada tipo de sensor
  	fscanf(f, "freq_sensores_temp=%ld\n", &config.f_sensores_temp);
	fscanf(f, "freq_sensores_velc_vento=%ld\n", &config.f_sensores_velc_vento);
	fscanf(f, "freq_sensores_dir_vento=%ld\n", &config.f_sensores_dir_vento);
	fscanf(f, "freq_sensores_pluvio=%ld\n", &config.f_sensores_pluvio);
	fscanf(f, "freq_sensores_humd_atm=%ld\n", &config.f_sensores_humd_atm);
	fscanf(f, "freq_sensores_humd_solo=%ld\n", &config.f_sensores_humd_solo);
	
	if(config.f_sensores_temp == 0 || config.f_sensores_velc_vento == 0 || config.f_sensores_dir_vento == 0 ||
						 config.f_sensores_pluvio == 0 || config.f_sensores_humd_atm == 0 || config.f_sensores_humd_solo == 0){
		printf("\nFICHEIRO \"config_file.cfg\" ENCONTRADO, MAS ALGUMA FREQUENCIA NAO E VALIDA\n\n");
    	
    	fclose(f);
		return 0;			 
	}
	
	//Numero de sensores para cada tipo
	fscanf(f, "num_sensores_temp=%ld\n", &config.n_sensores_temp);
	fscanf(f, "num_sensores_velc_vento=%ld\n", &config.n_sensores_velc_vento);
	fscanf(f, "num_sensores_dir_vento=%ld\n", &config.n_sensores_dir_vento);
	fscanf(f, "num_sensores_pluvio=%ld\n", &config.n_sensores_pluvio);
	fscanf(f, "num_sensores_humd_atm=%ld\n", &config.n_sensores_humd_atm);
	fscanf(f, "num_sensores_humd_solo=%ld\n", &config.n_sensores_humd_solo);
	
	if(config.n_sensores_temp == 0 || config.n_sensores_velc_vento == 0 || config.n_sensores_dir_vento == 0 ||
						 config.n_sensores_pluvio == 0 || config.n_sensores_humd_atm == 0 || config.n_sensores_humd_solo == 0){
		printf("\nFICHEIRO \"config_file.cfg\" ENCONTRADO, MAS ALGUM DOS NUMEROS DE SENSORES NAO E VALIDO\n\n");
    	
    	fclose(f);
		return 0;			 
	}
	
	
	printf("\n\nFICHEIRO IMPORTADO!\n\n");
	fclose(f);
	
	return 1;
}

void fill_all_sensores(Sensor * sensores_temp, Sensor * sensores_velc_vento, Sensor * sensores_dir_vento, Sensor * sensores_pluvio, Sensor * sensores_humd_atm, Sensor * sensores_humd_solo){
	//Preencher dados do Sensor de Temperatura
	for(int i = 0; i < config.n_sensores_temp; i++){
		//Valores gerados entre -10 e 53
		fill_sens_data(&sensores_temp[i], max_id, 1, 50, -5, config.f_sensores_temp);  //A variacao da temperatura e de 5 graus com um minimo de -5 graus e maximo de 50 graus
		max_id++;
		
		//Gerar valores para o sensor de temperatura
		fill_sens_temp(&sensores_temp[i]);
	}

	//Preencher dados do Sensor da Velocidade do Vento
	for(int i = 0; i < config.n_sensores_velc_vento; i++){
		//Valores gerados entre 0 e 53
		fill_sens_data(&sensores_velc_vento[i], max_id, 2, 50, 0, config.f_sensores_velc_vento); //A variacao da velocidade do vento e de 15 km/h com um minimo de 0 km/h e maximo de 50 km/h
		max_id++;
		
		//Gerar valores para o sensor da velocidade do vento
		fill_sens_velc_vento(&sensores_velc_vento[i]);
	}
	
	//Preencher dados do Sensor Direcao do Vento
	for(int i = 0; i < config.n_sensores_dir_vento; i++){
		//Valores gerados entre 0 e 365
		fill_sens_data(&sensores_dir_vento[i], max_id, 3, 359, 0, config.f_sensores_dir_vento); //A variacao da direcao do vento e de 6 com um minimo de 0 graus e maximo de 359 graus
		max_id++;
		
		//Gerar valores para o sensor da direcao do vento
		fill_sens_dir_vento(&sensores_dir_vento[i]);
	}
	
	//Preencher dados do Sensor da Pluviosidade
	for(int i = 0; i < config.n_sensores_pluvio; i++){
		//Valores gerados entre 0 e 103
		fill_sens_data(&sensores_pluvio[i], max_id, 4, 100, 0, config.f_sensores_pluvio); //A variacao da pluviosidade e de 15 com um minimo de 0 mm e maximo de 100 mm; A temperatura e considerada alta se for >= 12
		max_id++;
		
		Sensor * t_sensor_temp;
		
		if(i >= config.n_sensores_temp){
			t_sensor_temp = &sensores_temp[config.n_sensores_temp - 1];
		} else {
			t_sensor_temp = &sensores_temp[i];
		}
		
		//Gerar valores para o sensor pluviosidade
		fill_sens_pluvio(&sensores_pluvio[i], t_sensor_temp);
	}
	
	//Preencher dados do Sensor Humidade Atmosferica
	for(int i = 0; i < config.n_sensores_humd_atm; i++){
		//Valores gerados entre 0 e 103
		fill_sens_data(&sensores_humd_atm[i], max_id, 5, 100, 0, config.f_sensores_humd_atm); //A variacao da humidade da atmosferica e de 5 caso nao esteja a chover e de 15 caso esteja a chover. Minimo 0% maximo 100%
		max_id++;
		
		Sensor * t_sensor_pluvio;
		
		if(i >= config.n_sensores_pluvio){
			t_sensor_pluvio = &sensores_pluvio[config.n_sensores_pluvio - 1];
		} else {
			t_sensor_pluvio = &sensores_pluvio[i];
		}
		
		//Gerar valores para os sensores de humidade atmosferica
		fill_sens_humd_atm(&sensores_humd_atm[i], t_sensor_pluvio);
	} 
 
 	//Preencher dados do Sensor Humidade Atmosferica
	for(int i = 0; i < config.n_sensores_humd_solo; i++){
		//Valores gerados entre 0 e 103
		fill_sens_data(&sensores_humd_solo[i], max_id, 6, 100, 0, config.f_sensores_humd_solo); //A variacao da humidade do solo e de 3 caso nao esteja a chover e de 10 caso esteja a chover. Minimo 0% e maximo 100% 
		max_id++;
		
		Sensor * t_sensor_pluvio;
		
		if(i >= config.n_sensores_pluvio){
			t_sensor_pluvio = &sensores_pluvio[config.n_sensores_pluvio - 1];
		} else {
			t_sensor_pluvio = &sensores_pluvio[i];
		}
		
		//Gerar valores para os sensores da humidade do solo
		fill_sens_humd_solo(&sensores_humd_solo[i], t_sensor_pluvio);
	}
}

void regenerate_all_sensores(Sensor * sensores_temp, Sensor * sensores_velc_vento, Sensor * sensores_dir_vento, Sensor * sensores_pluvio, Sensor * sensores_humd_atm, Sensor * sensores_humd_solo){
	//Preencher dados do Sensor de Temperatura
	for(int i = 0; i < config.n_sensores_temp; i++){		
		//Gerar valores para o sensor de temperatura
		fill_sens_temp(&sensores_temp[i]);
	}

	//Preencher dados do Sensor da Velocidade do Vento
	for(int i = 0; i < config.n_sensores_velc_vento; i++){		
		//Gerar valores para o sensor da velocidade do vento
		fill_sens_velc_vento(&sensores_velc_vento[i]);
	}
	
	//Preencher dados do Sensor Direcao do Vento
	for(int i = 0; i < config.n_sensores_dir_vento; i++){		
		//Gerar valores para o sensor da direcao do vento
		fill_sens_dir_vento(&sensores_dir_vento[i]);
	}
	
	//Preencher dados do Sensor da Pluviosidade
	for(int i = 0; i < config.n_sensores_pluvio; i++){
		Sensor * t_sensor_temp;
		
		if(i >= config.n_sensores_temp){
			t_sensor_temp = &sensores_temp[config.n_sensores_temp - 1];
		} else {
			t_sensor_temp = &sensores_temp[i];
		}
		
		//Gerar valores para o sensor pluviosidade
		fill_sens_pluvio(&sensores_pluvio[i], t_sensor_temp);
	}
	
	//Preencher dados do Sensor Humidade Atmosferica
	for(int i = 0; i < config.n_sensores_humd_atm; i++){		
		Sensor * t_sensor_pluvio;
		
		if(i >= config.n_sensores_pluvio){
			t_sensor_pluvio = &sensores_pluvio[config.n_sensores_pluvio - 1];
		} else {
			t_sensor_pluvio = &sensores_pluvio[i];
		}
		
		//Gerar valores para os sensores de humidade atmosferica
		fill_sens_humd_atm(&sensores_humd_atm[i], t_sensor_pluvio);
	} 
 
 	//Preencher dados do Sensor Humidade Atmosferica
	for(int i = 0; i < config.n_sensores_humd_solo; i++){		
		Sensor * t_sensor_pluvio;
		
		if(i >= config.n_sensores_pluvio){
			t_sensor_pluvio = &sensores_pluvio[config.n_sensores_pluvio - 1];
		} else {
			t_sensor_pluvio = &sensores_pluvio[i];
		}
		
		//Gerar valores para os sensores da humidade do solo
		fill_sens_humd_solo(&sensores_humd_solo[i], t_sensor_pluvio);
	}
	
	printf("\nVALORES DE TODOS OS SENSORES REGENERADOS DEVIDO A ALTERACAO DA FREQUENCIA\n");
}
