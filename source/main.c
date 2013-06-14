#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <ivss.h>

void main(int argc, char **argv) {
	IVSS_SYSTEM* system;
	char* filename;

	//Determine filename from command line
	if (argc > 1) {
		filename = argv[1];
	} else {
		filename = "test.ivss";
	}

	//Initialize system
	printf("Internal Vessel Systems Simulator\n");
	printf("--------------------------------------------------------------------------------");
	IVSS_System_Create(&system);
	IVSS_Common_Register(system);
	
	//Load configuration file
	printf("Loading configuration...\n");
	IVSS_System_LoadFromFile(system,filename);

	//Start up simulation
	IVSS_System_Reset(system);

	//Do nothing
	while (1) {
		SIMC_Thread_Sleep(1000.0);
	}

	//Destroy simulation and return
	IVSS_System_Destroy(system);
	return;
}