#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <GLFW/glfw3.h>
#include <ivss.h>
#include "ivss_sim_lua.h"
#include "ivss_win_lcdscreen.h"

int quit_main_thread = 0;
int reload_main_thread = 0;
char ivss_filename[8192] = { 0 };
IVSS_SYSTEM* ivss_system;

// Thread to handle user command input
void command_main() {
	while (1) {
		char command[256] = { 0 };
		scanf("%255s",command);

		if ((strcmp(command,"quit") == 0) ||
			(strcmp(command,"q") == 0) ||
			(strcmp(command,"exit") == 0)) {
			quit_main_thread = 1;
			return;
		} else if (
			(strcmp(command,"reload") == 0) ||
			(strcmp(command,"r") == 0)) {
			reload_main_thread = 1;
		}
	}
}

// Main thread
void main(int argc, char **argv) {
	//Determine filename from command line
	if (argc > 1) {
		strncpy(ivss_filename,argv[1],8191);
	} else {
		strncpy(ivss_filename,"test.ivss",8191);
	}

	//Initialize system
	printf("Internal Vessel Systems Simulator\n");
	printf("--------------------------------------------------------------------------------");
	printf("Type 'quit' or 'q' to exit simulation\n");
	IVSS_System_Create(&ivss_system);
	IVSS_Common_Register(ivss_system);
	IVSS_Simulator_Lua_Register(ivss_system);
	IVSS_Window_LCDScreen_Register(ivss_system);
	
	//Load configuration file
	printf("Loading configuration...\n");
	IVSS_System_LoadFromFile(ivss_system,ivss_filename);

	//Start up simulation
	IVSS_System_Reset(ivss_system);

	//Start up command interface and wait until application shuts down
	SIMC_Thread_Create(command_main,0);
	while (!quit_main_thread) {
		glfwPollEvents();
		SIMC_Thread_Sleep(0.0);

		if (reload_main_thread) {
			reload_main_thread = 0;

			IVSS_System_Stop(ivss_system);
			IVSS_System_Clear(ivss_system);
			printf("Re-loading configuration...\n");
			IVSS_System_LoadFromFile(ivss_system,ivss_filename);
			IVSS_System_Reset(ivss_system);
		}
	}

	//Destroy simulation and return
	IVSS_System_Destroy(ivss_system);
	return;
}