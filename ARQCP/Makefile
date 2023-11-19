# A Makefile with variables and suffix rules
# variaveis
INCLUDES = pcg32_random_r.h sensores.h matriz_diaria_resumo.h isValidValue.h import_file.h export_file.h
SOURCES = main.c generate_seed.c generate_sensor_values.c pcg32_random_r.s sens_temp.s sens_velc_vento.s sens_dir_vento.s sens_humd_atm.s sens_humd_solo.s sens_pluvio.s sensores.c matriz_diaria_resumo.c isValidValue.c import_file.c export_file.c
OBJFILES = main.o generate_seed.o generate_sensor_values.o pcg32_random_r.o sens_temp.o sens_velc_vento.o sens_dir_vento.o sens_humd_atm.o sens_humd_solo.o sens_pluvio.o sensores.o matriz_diaria_resumo.o isValidValue.o import_file.o export_file.o
EXEC = prog_avg

# Suffix rules
.SUFFIXES : .c .o

# How to build an object .o from a code file .c ; $< -- file name
.c.o:
	gcc -Wall -g -c $<
	
.s.o:
	gcc -Wall -g -c $<

${EXEC}: ${OBJFILES}
	gcc -Wall -g -o ${EXEC} ${OBJFILES}

${OBJFILES}: ${SOURCES} ${INCLUDES}

run: ${EXEC}
	./${EXEC}

clean:
	rm -f ${OBJFILES} ${EXEC}