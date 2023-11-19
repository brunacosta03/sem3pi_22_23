#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

#include "sensores.h"
#include "import_file.h"
#include "matriz_diaria_resumo.h"

extern struct Config config;
extern int max_id;

void show_temp_sensors(Sensor *sensores_temp) {
    printf("\nSensores Temperatura:");
    
    for(int i = 0; i < config.n_sensores_temp; i++){
    	printf("\n\nID SENSOR - %d\n", sensores_temp[i].id);
    	unsigned short * readings_temp = sensores_temp[i].readings;
    	
    	for(int j = 0; j < sensores_temp[i].readings_size; j++){
    		printf("%dC ", (char) readings_temp[j]);
		}
	}
}

void show_velc_vento_sensors(Sensor *sensores_velc_vento) {
    printf("\nSensores Velocidade do Vento:");

    for(int i = 0; i < config.n_sensores_velc_vento; i++){
    	printf("\n\nID SENSOR - %d\n", sensores_velc_vento[i].id);
    	unsigned short * readings_velc_vento = sensores_velc_vento[i].readings;
    	
		for(int j = 0; j < sensores_velc_vento[i].readings_size; j++){
	    	printf("%dkm/h ", (unsigned char) readings_velc_vento[j]);
		}
	}
}

void show_dir_vento_sensors(Sensor *sensores_dir_vento) {
	printf("\nSensores Direcao do Vento:");

    for(int i = 0; i < config.n_sensores_dir_vento; i++){
    	printf("\n\nID SENSOR - %d\n", sensores_dir_vento[i].id);
    	unsigned short * readings_dir_vento = sensores_dir_vento[i].readings;
    	
		for(int j = 0; j < sensores_dir_vento[i].readings_size; j++){
	    	printf("%d ", readings_dir_vento[j]);
		}
	}
}

void show_pluvio_sensors(Sensor *sensores_pluvio) {
	printf("\nSensores Pluviosidade:");

    for(int i = 0; i < config.n_sensores_pluvio; i++){
    	printf("\n\nID SENSOR - %d\n", sensores_pluvio[i].id);
    	unsigned short * readings_pluvio = sensores_pluvio[i].readings;
	
		for(int j = 0; j < sensores_pluvio[i].readings_size; j++){
	    	printf("%dmm ", (unsigned char) readings_pluvio[j]);
		}
	}
}

void show_humd_atm_sensors(Sensor *sensores_humd_atm) {
	printf("\nSensores Humidade Atmosferica:");

    for(int i = 0; i < config.n_sensores_humd_atm; i++){
    	printf("\n\nID SENSOR - %d\n", sensores_humd_atm[i].id);
    	unsigned short * readings_humd_atm = sensores_humd_atm[i].readings;
    	
		for(int j = 0; j < sensores_humd_atm[i].readings_size; j++){
	    	printf("%d%% ", (unsigned char) readings_humd_atm[j]);
		}
	}
}

void show_humd_solo_sensors(Sensor *sensores_humd_solo) {
	printf("\nSensores Humidade do Solo:");

    for(int i = 0; i < config.n_sensores_humd_solo; i++){
    	printf("\n\nID SENSOR - %d\n", sensores_humd_solo[i].id);
    		unsigned short * readings_humd_solo = sensores_humd_solo[i].readings;
    	
		for(int j = 0; j < sensores_humd_solo[i].readings_size; j++){
	    	printf("%d%% ", (unsigned char) readings_humd_solo[j]);
		}
	}
}

void show_sensores(Sensor * sensores_temp, Sensor * sensores_velc_vento, Sensor * sensores_dir_vento, Sensor * sensores_pluvio, Sensor * sensores_humd_atm, Sensor * sensores_humd_solo){	
	printf("\n\n------------------------------------------------------\n");
	
	show_temp_sensors(sensores_temp);
	printf("\n\n------------------------------------------------------\n");


	show_velc_vento_sensors(sensores_velc_vento);
	printf("\n\n------------------------------------------------------\n");


	show_dir_vento_sensors(sensores_dir_vento);
	printf("\n\n------------------------------------------------------\n");
	
	
	show_pluvio_sensors(sensores_pluvio);
	printf("\n\n------------------------------------------------------\n");
	
	
	show_humd_atm_sensors(sensores_humd_atm);
	printf("\n\n------------------------------------------------------\n");
	
	
	show_humd_solo_sensors(sensores_humd_solo);
	printf("\n\n------------------------------------------------------\n");
}

void show_stats_sensores(float** matrix){
    float min, max, med;
    int line = 0;

	printf("\n<--------------ESTATISTICAS DOS SENSORES-------------->\n");

	max = *( *(matrix + line));
	min = *( *(matrix + line) + 1 );
	med = *( *(matrix + line) + 2 );
	
	printf("\n\nRESUMO DOS SENSORES TEMPERATURA\n");
	
	printf("\nMinimo: %.2f", min);
	printf("\nMaximo: %.2f", max);
	printf("\nMedia: %.2f", med);
	    
	line++;
	

	max = *( *(matrix + line));
	min = *( *(matrix + line) + 1 );
	med = *( *(matrix + line) + 2 );
	
	printf("\n\nRESUMO DOS SENSORES VELOCIDADE DO VENTO\n");
	
	printf("\nMinimo: %.2f", min);
	printf("\nMaximo: %.2f", max);
	printf("\nMedia: %.2f", med);
	    
	line++;
	

	max = *( *(matrix + line));
	min = *( *(matrix + line) + 1 );
	med = *( *(matrix + line) + 2 );
	
	printf("\n\nRESUMO DOS SENSORES DIRECAO DO VENTO\n");
	
	printf("\nMinimo: %.2f", min);
	printf("\nMaximo: %.2f", max);
	printf("\nMedia: %.2f", med);
	    
	line++;
	
	max = *( *(matrix + line));
	min = *( *(matrix + line) + 1 );
	med = *( *(matrix + line) + 2 );
	
	printf("\n\nRESUMO DOS SENSORES PLUVIOSIDADE\n");
	
	printf("\nMinimo: %.2f", min);
	printf("\nMaximo: %.2f", max);
	printf("\nMedia: %.2f", med);
	    
	line++;

	

	max = *( *(matrix + line));
	min = *( *(matrix + line) + 1 );
	med = *( *(matrix + line) + 2 );
	
	printf("\n\nRESUMO DOS SENSORES HUMIDADE ATMOSFERICA\n");
	
	printf("\nMinimo: %.2f", min);
	printf("\nMaximo: %.2f", max);
	printf("\nMedia: %.2f", med);
	    
	line++;




	max = *( *(matrix + line));
	min = *( *(matrix + line) + 1 );
	med = *( *(matrix + line) + 2 );
	
	printf("\n\nRESUMO DOS SENSORES HUMIDADE DO SOLO\n");
	
	printf("\nMinimo: %.2f", min);
	printf("\nMaximo: %.2f", max);
	printf("\nMedia: %.2f", med);
	    
	line++;

    
    printf("\n\n------------------------------------------------------\n");
}

Sensor * create_sensores(int n_sensores){
	Sensor * ptr_sensor = NULL;
	
	ptr_sensor = (Sensor *) malloc(n_sensores * (sizeof (Sensor)));
	
	return ptr_sensor;
}

#define daySeconds 86400

void fill_sens_data(Sensor * ptr_sensor, unsigned short id, unsigned char sensor_type, unsigned short max_limit, unsigned short min_limit, unsigned long frequency){
	int readings_size = daySeconds / frequency;
	
	unsigned short * ptr_readings = NULL;
	ptr_readings = (unsigned short *) malloc(readings_size * (sizeof (unsigned short)));
	
	
	ptr_sensor -> id = id;
	ptr_sensor -> sensor_type = sensor_type;
	ptr_sensor -> max_limit = max_limit;
	ptr_sensor -> min_limit = min_limit;
	ptr_sensor -> frequency = frequency;
	ptr_sensor -> readings_size = readings_size;
	ptr_sensor -> readings = ptr_readings;
	ptr_sensor -> count_wrong = 0;
}

void update_sens_data(Sensor * ptr_sensor, unsigned long frequency){
	int readings_size = daySeconds / frequency;
	
	unsigned short * ptr_readings = ptr_sensor -> readings;
	
	ptr_readings = realloc(ptr_readings, readings_size * sizeof(unsigned short));
	
	
	ptr_sensor -> frequency = frequency;
	ptr_sensor -> readings_size = readings_size;
	ptr_sensor -> readings = ptr_readings;
	ptr_sensor -> count_wrong = 0;
}

void free_sensores(Sensor * sensores, int n_sensores){
	for(int i = 0; i < n_sensores; i++){
    	unsigned short * sensor_readings = sensores[i].readings;
    	
    	free(sensor_readings);
	}
	
	free(sensores);
}

void add_sensores_menu(Sensor ** sensores_temp, Sensor ** sensores_velc_vento, Sensor ** sensores_dir_vento, Sensor ** sensores_pluvio, Sensor ** sensores_humd_atm, Sensor ** sensores_humd_solo){
	int opt;
	Sensor *sensores;
	
	printf("\nADICIONAR SENSORES MENU\n");
		
	printf("1. ADICIONAR SENSORES TEMPERATURA\n");
	printf("2. ADICIONAR SENSORES VELOCIDADE DO VENTO\n");
	printf("3. ADICIONAR SENSORES DIRECAO DO VENTO\n");
	printf("4. ADICIONAR SENSORES PLUVIOSIDADE\n");
	printf("5. ADICIONAR SENSORES HUMIDADE ATMOSFERICA\n");
	printf("6. ADICIONAR SENSORES HUMIDADE DO SOLO\n");
	printf("0. VOLTAR\n");
	
	printf("\nOPCAO: ");
	scanf("%d", &opt);
		
	int n_sensores_add = 0;
	
	if(opt != 0){
		printf("NUMERO DE SENSORES A ADICIONAR:");
		scanf("%d", &n_sensores_add);
	}

		
	switch (opt) {
		case 1:
		    new_size_sensores(sensores_temp, config.n_sensores_temp + n_sensores_add);
		    
			sensores = *sensores_temp;

		    for(int i = config.n_sensores_temp; i < config.n_sensores_temp + n_sensores_add; i++){
		    	fill_sens_data(&sensores[i], max_id, 1, 50, -5, config.f_sensores_temp);
		    	
		    	fill_sens_temp(&sensores[i]);
		    	
		    	max_id++;
			}
			
			config.n_sensores_temp = config.n_sensores_temp + n_sensores_add;
			
			break;
		case 2:
	        new_size_sensores(sensores_velc_vento, config.n_sensores_velc_vento + n_sensores_add);
	        
	        sensores = *sensores_velc_vento;
	        
	        for(int i = config.n_sensores_velc_vento; i < config.n_sensores_velc_vento + n_sensores_add; i++){
				fill_sens_data(&sensores[i], max_id, 2, 50, 0, config.f_sensores_velc_vento);
				
				fill_sens_velc_vento(&sensores[i]);
		    	
		    	max_id++;
			}
			
			config.n_sensores_velc_vento = config.n_sensores_velc_vento + n_sensores_add;
		            
	        break;
		case 3:
	        new_size_sensores(sensores_dir_vento, config.n_sensores_dir_vento + n_sensores_add);
	        
	        sensores = *sensores_dir_vento;
	        
	        for(int i = config.n_sensores_dir_vento; i < config.n_sensores_dir_vento + n_sensores_add; i++){
				fill_sens_data(&sensores[i], max_id, 3, 359, 0, config.f_sensores_dir_vento);
				
				fill_sens_dir_vento(&sensores[i]);
		    	
		    	max_id++;
			}
			
			config.n_sensores_dir_vento = config.n_sensores_dir_vento + n_sensores_add;
		            
			break;
		case 4:
	        new_size_sensores(sensores_pluvio, config.n_sensores_pluvio + n_sensores_add);
	        
	        sensores = *sensores_pluvio;
	        
	        for(int i = config.n_sensores_pluvio; i < config.n_sensores_pluvio + n_sensores_add; i++){
				fill_sens_data(&sensores[i], max_id, 4, 100, 0, config.f_sensores_pluvio);
				
				Sensor * t_sensor_temp;
				Sensor * t_sensores = *sensores_temp;
		
				if(i >= config.n_sensores_temp){
					t_sensor_temp = &t_sensores[config.n_sensores_temp - 1];
				} else {
					t_sensor_temp = &t_sensores[i];
				}
				
				fill_sens_pluvio(&sensores[i], t_sensor_temp);
		    	
		    	max_id++;
			}
			
			config.n_sensores_pluvio = config.n_sensores_pluvio + n_sensores_add;
		            
			break;
		case 5:
		    new_size_sensores(sensores_humd_atm, config.n_sensores_humd_atm + n_sensores_add);
	        
	        sensores = *sensores_humd_atm;
	        
	        for(int i = config.n_sensores_humd_atm; i < config.n_sensores_humd_atm + n_sensores_add; i++){
				fill_sens_data(&sensores[i], max_id, 5, 100, 0, config.f_sensores_humd_atm);
				
				Sensor * t_sensor_pluvio;
				Sensor * t_sensores = *sensores_pluvio;
		
				if(i >= config.n_sensores_pluvio){
					t_sensor_pluvio = &t_sensores[config.n_sensores_pluvio - 1];
				} else {
					t_sensor_pluvio = &t_sensores[i];
				}
				
				fill_sens_humd_atm(&sensores[i], t_sensor_pluvio);
		    	
		    	max_id++;
			}
			
			config.n_sensores_humd_atm = config.n_sensores_humd_atm + n_sensores_add;
		            
			break;
		case 6:
		    new_size_sensores(sensores_humd_solo, config.n_sensores_humd_solo + n_sensores_add);
		    
	        sensores = *sensores_humd_solo;
	        
	        
	        for(int i = config.n_sensores_humd_solo; i < config.n_sensores_humd_solo + n_sensores_add; i++){
				fill_sens_data(&sensores[i], max_id, 6, 100, 0, config.f_sensores_humd_solo);

				
				Sensor * t_sensor_pluvio;
				Sensor * t_sensores = *sensores_pluvio;
							        
							        	
				if(i >= config.n_sensores_pluvio){
					t_sensor_pluvio = &t_sensores[config.n_sensores_pluvio - 1];
				} else {
					t_sensor_pluvio = &t_sensores[i];
				}
				
				fill_sens_humd_solo(&sensores[i], t_sensor_pluvio);
				
		    	
		    	max_id++;
			}
	        
	        config.n_sensores_humd_solo = config.n_sensores_humd_solo + n_sensores_add;
		            
			break;
		case 0: 
			break;
		default:
		    printf("OPCAO INVALIDA!\n\n");
	}
}

int getIndexById(Sensor * sensores, int id_sensor, int n_sensores){
	for(int i = 0; i < n_sensores; i++){
		if(sensores[i].id == id_sensor){
			return i;
		}
	}
	
	
	return -1;
}

void delete_sensores_menu(Sensor ** sensores_temp, Sensor ** sensores_velc_vento, Sensor ** sensores_dir_vento, Sensor ** sensores_pluvio, Sensor ** sensores_humd_atm, Sensor ** sensores_humd_solo){
	int opt;
	int is_deleted;
	
	printf("\nREMOVER SENSORES MENU\n");
		
	printf("1. REMOVER SENSORES TEMPERATURA\n");
	printf("2. REMOVER SENSORES VELOCIDADE DO VENTO\n");
	printf("3. REMOVER SENSORES DIRECAO DO VENTO\n");
	printf("4. REMOVER SENSORES PLUVIOSIDADE\n");
	printf("5. REMOVER SENSORES HUMIDADE ATMOSFERICA\n");
	printf("6. REMOVER SENSORES HUMIDADE DO SOLO\n");
	printf("0. VOLTAR\n");
	
	printf("\nOPCAO: ");
	scanf("%d", &opt);

		
	switch (opt) {
		case 1:
			printf("\n\n------------------------------------------------------\n");
			show_temp_sensors(*sensores_temp);
			printf("\n\n------------------------------------------------------\n");
			
			is_deleted = delete_sensores(sensores_temp, config.n_sensores_temp);
				
			if(is_deleted){
				config.n_sensores_temp = config.n_sensores_temp - 1;
			}
			
			break;

		case 2:
			printf("\n\n------------------------------------------------------\n");
			show_velc_vento_sensors(*sensores_velc_vento);
			printf("\n\n------------------------------------------------------\n");
			
			is_deleted = delete_sensores(sensores_velc_vento, config.n_sensores_velc_vento);
				
			if(is_deleted){
				config.n_sensores_velc_vento = config.n_sensores_velc_vento - 1;
			}
   
	        break;

		case 3:
			printf("\n\n------------------------------------------------------\n");
			show_dir_vento_sensors(*sensores_dir_vento);
			printf("\n\n------------------------------------------------------\n");
			
			is_deleted = delete_sensores(sensores_dir_vento, config.n_sensores_dir_vento);
				
			if(is_deleted){
				config.n_sensores_dir_vento = config.n_sensores_dir_vento - 1;
			}
		            
			break;

		case 4:
			printf("\n\n------------------------------------------------------\n");
			show_pluvio_sensors(*sensores_pluvio);
			printf("\n\n------------------------------------------------------\n");
			
			is_deleted = delete_sensores(sensores_pluvio, config.n_sensores_pluvio);
				
			if(is_deleted){
				config.n_sensores_pluvio = config.n_sensores_pluvio - 1;
			}
		            
			break;

		case 5:
			printf("\n\n------------------------------------------------------\n");
			show_humd_atm_sensors(*sensores_humd_atm);
			printf("\n\n------------------------------------------------------\n");
			
			is_deleted = delete_sensores(sensores_humd_atm, config.n_sensores_humd_atm);
				
			if(is_deleted){
				config.n_sensores_humd_atm = config.n_sensores_humd_atm - 1;
			}
		            
			break;

		case 6:
			printf("\n\n------------------------------------------------------\n");
			show_humd_solo_sensors(*sensores_humd_solo);
			printf("\n\n------------------------------------------------------\n");
			
			is_deleted = delete_sensores(sensores_humd_solo, config.n_sensores_humd_solo);
				
			if(is_deleted){
				config.n_sensores_humd_solo = config.n_sensores_humd_solo - 1;
			}
		            
			break;

		case 0: 
			break;

		default:
		    printf("OPCAO INVALIDA!\n\n");
	}
}


int delete_sensores(Sensor ** sensores, int n_sensores){
	if(n_sensores > 1){
		int id_sensor;
	  	printf("ID DO SENSOR A SER APAGADO: ");
	  	scanf("%d", &id_sensor);
	  
		Sensor *t_sensores = *sensores;
		
		int index = getIndexById(t_sensores, id_sensor, n_sensores);
	  
		if (index < 0) {
	    	printf("ID DO SENSOR ERRADO!\n");
	  		return 0;
	  		
	  	} else {
	  		unsigned short * sensor_readings = t_sensores[index].readings;
	    	free(sensor_readings);
	  		
	    	for (int i = index; i < n_sensores - 1; i++) {
	      		t_sensores[i] = t_sensores[i + 1];
			}
	    
	    	new_size_sensores(sensores, n_sensores - 1);
	    	
	    	return 1;
	 	}
	}
	
	printf("APENAS EXISTE 1 SENSOR DESTE TIPO, POR ISSO NAO E POSSIVEL APAGAR-LO!\n");
	return 0;
}

void new_size_sensores(Sensor ** sensor, int new_size){
	*sensor = realloc(*sensor, new_size * sizeof(Sensor));
	
	printf("\nNUMERO DE SENSORES ATUALIZADO COM SUCESSO!\n");
}


void alter_sensores_freq_menu(Sensor ** sensores_temp, Sensor ** sensores_velc_vento, Sensor ** sensores_dir_vento, Sensor ** sensores_pluvio, Sensor ** sensores_humd_atm, Sensor ** sensores_humd_solo){
	int opt;
	unsigned long new_frequency = 0;
	Sensor *sensores;
	
	printf("\nALTERAR FREQUENCIA DOS SENSORES MENU\n");
		
	printf("1. ALTERAR FREQUENCIA SENSORES TEMPERATURA\n");
	printf("2. ALTERAR FREQUENCIA SENSORES VELOCIDADE DO VENTO\n");
	printf("3. ALTERAR FREQUENCIA SENSORES DIRECAO DO VENTO\n");
	printf("4. ALTERAR FREQUENCIA SENSORES PLUVIOSIDADE\n");
	printf("5. ALTERAR FREQUENCIA SENSORES HUMIDADE ATMOSFERICA\n");
	printf("6. ALTERAR FREQUENCIA SENSORES HUMIDADE DO SOLO\n");
	printf("0. VOLTAR\n");
	
	printf("\nOPCAO: ");
	scanf("%d", &opt);
	
	if (opt != 0){
		printf("\nNOVA FREQUENCIA: ");
		scanf("%ld", &new_frequency);
		
		if(new_frequency > 0 && new_frequency <= daySeconds){
			switch (opt) {
				case 1:
					for(int i = 0; i < config.n_sensores_temp; i++){
						sensores = *sensores_temp;
						
						printf("\nFREQUENCIA DO SENSOR COM ID - %d ALTERADA", sensores[i].id);
						    	
						update_sens_data(&sensores[i], new_frequency);
					}
				        	
					config.f_sensores_temp = new_frequency;
					
					break;
		
				case 2:
					for(int i = 0; i < config.n_sensores_velc_vento; i++){
						sensores = *sensores_velc_vento;
						
						printf("\nFREQUENCIA DO SENSOR COM ID - %d ALTERADA", sensores[i].id);
						    	
						update_sens_data(&sensores[i], new_frequency);
					}
				        	
					config.f_sensores_velc_vento = new_frequency;
		
			        break;
		
				case 3:
					for(int i = 0; i < config.n_sensores_dir_vento; i++){
						sensores = *sensores_dir_vento;
						
						printf("\nFREQUENCIA DO SENSOR COM ID - %d ALTERADA", sensores[i].id);
						    	
						update_sens_data(&sensores[i], new_frequency);
					}
				        	
					config.f_sensores_dir_vento = new_frequency;
				            
					break;
		
				case 4:
					for(int i = 0; i < config.n_sensores_pluvio; i++){
						sensores = *sensores_pluvio;
						
						printf("\nFREQUENCIA DO SENSOR COM ID - %d ALTERADA", sensores[i].id);
						    	
						update_sens_data(&sensores[i], new_frequency);
					}
				        	
					config.f_sensores_pluvio = new_frequency;
				            
					break;
		
				case 5:
					for(int i = 0; i < config.n_sensores_humd_atm; i++){
						sensores = *sensores_humd_atm;
						
						printf("\nFREQUENCIA DO SENSOR COM ID - %d ALTERADA", sensores[i].id);
						    	
						update_sens_data(&sensores[i], new_frequency);
					}
				        	
					config.f_sensores_humd_atm = new_frequency;
				            
					break;
		
				case 6:
					for(int i = 0; i < config.n_sensores_humd_solo; i++){
						sensores = *sensores_humd_solo;
						
						printf("\nFREQUENCIA DO SENSOR COM ID - %d ALTERADA", sensores[i].id);
						    	
						update_sens_data(&sensores[i], new_frequency);
					}
				        	
					config.f_sensores_humd_solo = new_frequency;
				            
					break;
		
		
				default:
				    printf("OPCAO INVALIDA!\n\n");
			}
			
			regenerate_all_sensores(*sensores_temp, *sensores_velc_vento, *sensores_dir_vento, *sensores_pluvio, *sensores_humd_atm, *sensores_humd_solo);
		} else {
			printf("\nA FREQUENCIA PRECISA DE SER MAIOR QUE 0 E MENOR OU IGUAL A %d\n", daySeconds);
		}	
	}
}

void resize_matrix(float*** matrix, int old_rows, int new_rows, int cols) {	
	*matrix = realloc(*matrix, new_rows * sizeof(float*));

	for (int i = old_rows; i < new_rows; i++) {
    	(*matrix)[i] = malloc(cols * sizeof(float));
  	}
}

void set_resumo_matriz_sensores_temp(Sensor * sensores_temp, float ** matrix, int line){
	int n_readings = sensores_temp[0].readings_size * config.n_sensores_temp;
	int readings_temp_int[n_readings];
	
	int k = 0;
	
	for(int i = 0; i < config.n_sensores_temp; i++){
		unsigned short *readings = sensores_temp[i].readings;
	    
		for(int j = 0; j < sensores_temp[i].readings_size; j++){
		    readings_temp_int[k] = (char) readings[j];
		    
		    k++;
		}
	}
	
	matriz_diaria_resumo(n_readings, readings_temp_int, matrix, line, (char) sensores_temp[0].max_limit, (char) sensores_temp[0].min_limit);
}

void set_resumo_matriz_sensores(Sensor * sensor, int n_sensores, float ** matrix, int line){
	int n_readings = sensor[0].readings_size * n_sensores;
	int readings_int[n_readings];
	
	int k = 0;
	
	for(int i = 0; i < n_sensores; i++){
		unsigned short *readings = sensor[i].readings;
	    
		for(int j = 0; j < sensor[i].readings_size; j++){
		    readings_int[k] = readings[j];
		    
		    k++;
		}
	}
	
	matriz_diaria_resumo(n_readings, readings_int, matrix, line, sensor[0].max_limit, sensor[0].min_limit);
	 
}

void set_all_matriz_resumo(Sensor * sensores_temp, Sensor * sensores_velc_vento, Sensor * sensores_dir_vento, Sensor * sensores_pluvio, Sensor * sensores_humd_atm, Sensor * sensores_humd_solo, float ** matrix){
	set_resumo_matriz_sensores_temp(sensores_temp, matrix, 0);
	set_resumo_matriz_sensores(sensores_velc_vento, config.n_sensores_velc_vento, matrix, 1);
	set_resumo_matriz_sensores(sensores_dir_vento, config.n_sensores_dir_vento, matrix, 2);
	set_resumo_matriz_sensores(sensores_pluvio, config.n_sensores_pluvio, matrix, 3);
	set_resumo_matriz_sensores(sensores_humd_atm, config.n_sensores_humd_atm, matrix, 4);
	set_resumo_matriz_sensores(sensores_humd_solo, config.n_sensores_humd_solo, matrix, 5);
}
