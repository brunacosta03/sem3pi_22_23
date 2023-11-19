#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

#include "import_file.h"
#include "matriz_diaria_resumo.h"
#include "sensores.h"
#include "pcg32_random_r.h"
#include "isValidValue.h"
#include "export_file.h"

#define maxWrongReads 3

uint64_t state = 0;  
uint64_t inc = 0;

struct Config config;
int max_id = 0;


int main() {
	//Import config file
	if(import_file("config_file.cfg")){
		//Generate Seed
		generate_seed();
		
		//Sensores
		Sensor * sensores_temp = create_sensores(config.n_sensores_temp);
		Sensor * sensores_velc_vento = create_sensores(config.n_sensores_velc_vento);
		Sensor * sensores_dir_vento = create_sensores(config.n_sensores_dir_vento);
		Sensor * sensores_pluvio = create_sensores(config.n_sensores_pluvio);
		Sensor * sensores_humd_atm = create_sensores(config.n_sensores_humd_atm);
		Sensor * sensores_humd_solo = create_sensores(config.n_sensores_humd_solo);
		
		//Preencher dados dos Sensores
		fill_all_sensores(sensores_temp, sensores_velc_vento, sensores_dir_vento, sensores_pluvio, sensores_humd_atm, sensores_humd_solo);
		
		//6 tipos de sensor por isso 6 linhas. 3 colunas (MIN, MAX, MEDIA)
		float ** matrix = create_matrix(6, 3);
	    
	    set_all_matriz_resumo(sensores_temp, sensores_velc_vento, sensores_dir_vento, sensores_pluvio, sensores_humd_atm, sensores_humd_solo, matrix);
	    
	    
	    int opt;
	    		    
		do {
			printf("\nMAIN MENU\n");
			
		    printf("1. MOSTRAR TODOS OS SENSORES\n");
		    printf("2. ACRESCENTAR SENSORES\n");
		    printf("3. REMOVER SENSORES\n");
		    printf("4. ALTERAR FREQUENCIA DE UM TIPO DE SENSORES\n");
		    printf("5. VER A MATRIZ RESUMO\n");
			printf("6. EXPORTAR MATRIZ RESUMO PARA FICHEIRO\n");
			printf("7. EXPORTAR TODOS OS SENSORES PARA FICHEIRO\n");
			printf("0. SAIR\n");

		    printf("\nOPCAO: ");
		    scanf("%d", &opt);
		
		    switch (opt) {
		        case 1:
	    			show_sensores(sensores_temp, sensores_velc_vento, sensores_dir_vento, sensores_pluvio, sensores_humd_atm, sensores_humd_solo);
					break;
					
		        case 2:
		            add_sensores_menu(&sensores_temp, &sensores_velc_vento, &sensores_dir_vento, &sensores_pluvio, &sensores_humd_atm, &sensores_humd_solo);
		            set_all_matriz_resumo(sensores_temp, sensores_velc_vento, sensores_dir_vento, sensores_pluvio, sensores_humd_atm, sensores_humd_solo, matrix);
		            
		            break;
		            
		        case 3:
					delete_sensores_menu(&sensores_temp, &sensores_velc_vento, &sensores_dir_vento, &sensores_pluvio, &sensores_humd_atm, &sensores_humd_solo);
					set_all_matriz_resumo(sensores_temp, sensores_velc_vento, sensores_dir_vento, sensores_pluvio, sensores_humd_atm, sensores_humd_solo, matrix);
					
		            break;
		            
		        case 4:
					alter_sensores_freq_menu(&sensores_temp, &sensores_velc_vento, &sensores_dir_vento, &sensores_pluvio, &sensores_humd_atm, &sensores_humd_solo);
					set_all_matriz_resumo(sensores_temp, sensores_velc_vento, sensores_dir_vento, sensores_pluvio, sensores_humd_atm, sensores_humd_solo, matrix);
					
		            break;
		            
		        case 5:
					set_all_matriz_resumo(sensores_temp, sensores_velc_vento, sensores_dir_vento, sensores_pluvio, sensores_humd_atm, sensores_humd_solo, matrix);
					show_stats_sensores(matrix);
					
					break;

				case 6:
					export_matrix(matrix, 6);
					printf("EXPORTADO COM SUCESSO!\n\n");
					
					break;

				case 7:
					export_sensors(sensores_temp, sensores_velc_vento, sensores_dir_vento, sensores_pluvio, sensores_humd_atm, sensores_humd_solo);
					printf("EXPORTADO COM SUCESSO!\n\n");
					
					break;

		        case 0:
		            printf("A SAIR DA APLICACAO!\n\n");
		            break;
		            
		        default:
		            printf("OPCAO INVALIDA!\n\n");
		    }
		}while (opt != 0);
	    
		//Free all type of sensores
	    free_sensores(sensores_temp, config.n_sensores_temp);
	    free_sensores(sensores_velc_vento, config.n_sensores_velc_vento);
	    free_sensores(sensores_dir_vento, config.n_sensores_dir_vento);
	    free_sensores(sensores_pluvio, config.n_sensores_pluvio);
	    free_sensores(sensores_humd_atm, config.n_sensores_humd_atm);
	    free_sensores(sensores_humd_solo, config.n_sensores_humd_solo);
		free_matrix(matrix, 6);
	}

    return 0;
}
