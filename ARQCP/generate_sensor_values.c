#include <stdio.h>
#include <stdint.h>
#include "sensores.h"
#include "isValidValue.h"
#include "pcg32_random_r.h"

#define maxWrongReads 3

void fill_sens_temp(Sensor * sensor_temp){
	unsigned short * readings_temp = sensor_temp -> readings;
	*(readings_temp) = 10; //Temperatura inicial = 10;
	
	for(int i = 1; i < sensor_temp -> readings_size; i++){ 
        char ult_temp = sens_temp(*(readings_temp + i - 1), pcg32_random_r());
        *(readings_temp + i) = ult_temp;
    
        
        //Leituras erradas sensor temperatura
		if(!isValidChar(ult_temp, (char)sensor_temp -> min_limit, sensor_temp -> max_limit)){
			sensor_temp -> count_wrong = sensor_temp -> count_wrong + 1;
        	
        	if(sensor_temp -> count_wrong == maxWrongReads){
        		printf("\n3 leituras seguidas erradas no sensor da temperatura\n\n");
				generate_seed();
				i = i - 3;
				
				sensor_temp -> count_wrong = 0;
			}
        	
		} else {
			sensor_temp -> count_wrong = 0;
		}
	}
}

void fill_sens_velc_vento(Sensor * sensor_velc_vento){
	unsigned short * readings_velc_vento = sensor_velc_vento -> readings;
	*(readings_velc_vento) = 6;  //Velocidade do vento inicial = 6;
	
	//Sensor Velocidade do Vento
	for(int i = 1; i < sensor_velc_vento -> readings_size; i++){
		unsigned char ult_velc_vento = sens_velc_vento(*(readings_velc_vento + i - 1), pcg32_random_r());
        *(readings_velc_vento + i) = ult_velc_vento;
		
        
        //Leituras erradas sensor velocidade do vento
		if(!isValidChar(ult_velc_vento, sensor_velc_vento -> min_limit, sensor_velc_vento -> max_limit)){
			sensor_velc_vento -> count_wrong = sensor_velc_vento -> count_wrong + 1;
        	
        	if(sensor_velc_vento -> count_wrong == maxWrongReads){
        		printf("\n3 leituras seguidas erradas no sensor do vento\n\n");
				generate_seed();
				i = i - 3;
				
				sensor_velc_vento -> count_wrong = 0;
			}
        	
		} else {
			sensor_velc_vento -> count_wrong = 0;
		}
	}
}

void fill_sens_dir_vento(Sensor * sensor_dir_vento){
	unsigned short * readings_dir_vento = sensor_dir_vento -> readings;
	*(readings_dir_vento) = 180; //Direcao do vento inicial = 180;
	
	//Sensor Direcao do Vento
	for(int i = 1; i < sensor_dir_vento -> readings_size; i++){
		unsigned short ult_dir_vento = sens_dir_vento(*(readings_dir_vento + i - 1), pcg32_random_r());
        *(readings_dir_vento + i) = ult_dir_vento;
	
		
		//Leituras erradas sensor direcao do vento
		if(!isValid(ult_dir_vento, sensor_dir_vento -> min_limit, sensor_dir_vento -> max_limit)){
        	sensor_dir_vento -> count_wrong = sensor_dir_vento -> count_wrong + 1;
        	
        	if(sensor_dir_vento -> count_wrong == maxWrongReads){
        		printf("\n3 leituras seguidas erradas no sensor da direcao do vento\n\n");
				generate_seed();
				i = i - 3;
				
				sensor_dir_vento -> count_wrong = 0;
			}
        	
		} else {
			sensor_dir_vento -> count_wrong = 0;
		}
	}
}

void fill_sens_pluvio(Sensor * sensor_pluvio, Sensor * sensor_temp){
	unsigned short * readings_pluvio = sensor_pluvio -> readings;
	*(readings_pluvio) = 1; //Sensor Pluviosidade valor inicial = 1;
	
	//A Temperatura influencia a Pluviosidade
	unsigned short * readings_temp = sensor_temp -> readings;
	unsigned long temp_frequency = sensor_temp -> frequency;
	
	//Sensor Pluviosidade
	for(int i = 1; i < sensor_pluvio -> readings_size; i++){
		int frequency = sensor_pluvio -> frequency * i / temp_frequency;
		
		
		char ult_temp = (char) *(readings_temp + frequency);
	        
        unsigned char ult_pluvio = sens_pluvio(*(readings_pluvio + i - 1), ult_temp, pcg32_random_r());
        *(readings_pluvio + i) = ult_pluvio;
        
        
		//Leituras erradas sensor da Pluviosidade
		if(!isValidChar(ult_pluvio, sensor_pluvio -> min_limit, sensor_pluvio -> max_limit)){
        	sensor_pluvio -> count_wrong = sensor_pluvio -> count_wrong + 1;
        	
        	if(sensor_pluvio -> count_wrong == maxWrongReads){
        		printf("\n3 leituras seguidas erradas no sensor da pluviosidade\n\n");
				generate_seed();
				i = i - 3;
				
				sensor_pluvio -> count_wrong = 0;
			}
        	
		} else {
			sensor_pluvio -> count_wrong = 0;
		}
    }
}

void fill_sens_humd_atm(Sensor * sensor_humd_atm, Sensor * sensor_pluvio){
	unsigned short * readings_humd_atm = sensor_humd_atm -> readings;
	*(readings_humd_atm) = 60; //Humidade Atmosferica valor inicial = 60;
	
	//A Pluviosidade influencia a Humidade Atmosferica
	unsigned short * readings_pluvio = sensor_pluvio -> readings;
	unsigned long pluvio_frequency = sensor_pluvio -> frequency;
	
	
	//Sensor da Humidade Atmosferica
    for(int i = 1; i < sensor_humd_atm -> readings_size; i++){ 
    	int frequency = sensor_humd_atm -> frequency * i / pluvio_frequency;
    	
    
    	unsigned char ult_pluvio = (unsigned char) *(readings_pluvio + frequency);
    
        unsigned char ult_hmd_atm = sens_humd_atm(*(readings_humd_atm + i - 1), ult_pluvio, pcg32_random_r());
        *(readings_humd_atm + i) = ult_hmd_atm;
        
        
		//Leituras erradas sensor da Humidade Atmosferica
		if(!isValidChar(ult_hmd_atm, sensor_humd_atm -> min_limit, sensor_humd_atm -> max_limit)){
        	sensor_humd_atm -> count_wrong = sensor_humd_atm -> count_wrong + 1;
        	
        	if(sensor_humd_atm -> count_wrong == maxWrongReads){
        		printf("\n3 leituras seguidas erradas no sensor da humidade atmosferica\n\n");
				generate_seed();
				i = i - 3;
				
				sensor_humd_atm -> count_wrong = 0;
			}
        	
		} else {
			sensor_humd_atm -> count_wrong = 0;
		}
    }
}

void fill_sens_humd_solo(Sensor * sensor_humd_solo, Sensor * sensor_pluvio){
	unsigned short * readings_humd_solo = sensor_humd_solo -> readings;
	*(readings_humd_solo) = 50; //Humidade do Solo valor inicial = 50;
	
	//A Pluviosidade influencia a Humidade do Solo
	unsigned short * readings_pluvio = sensor_pluvio -> readings;
	unsigned long pluvio_frequency = sensor_pluvio -> frequency;
	
	
	//Sensor da Humidade do Solo
	for(int i = 1; i < sensor_humd_solo -> readings_size; i++){
		int frequency = sensor_humd_solo -> frequency * i / pluvio_frequency;
	
	  
		unsigned char ult_pluvio = (unsigned char) *(readings_pluvio + frequency);
	       
        unsigned char ult_hmd_solo = sens_humd_solo(*(readings_humd_solo + i - 1), ult_pluvio, pcg32_random_r());
        *(readings_humd_solo + i) = ult_hmd_solo;
        
        
		//Leituras erradas sensor da Humidade do Solo
		if(!isValidChar(ult_hmd_solo, sensor_humd_solo -> min_limit, sensor_humd_solo -> max_limit)){
        	sensor_humd_solo -> count_wrong = sensor_humd_solo -> count_wrong + 1;
        	
        	if(sensor_humd_solo -> count_wrong == maxWrongReads){
        		printf("\n3 leituras seguidas erradas no sensor da humidade do solo\n\n");
				generate_seed();
				i = i - 3;
				
				sensor_humd_solo -> count_wrong = 0;
			}
        	
		} else {
			sensor_humd_solo -> count_wrong = 0;
		}
    }
}
