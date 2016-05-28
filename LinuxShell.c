/* Jared Hayes, CS 370 Fall 2014, Project 2
*  Simple Unix Shell
*  	A program that emulates a Linux terminal shell similar to bash.  The shell prompts, accepts commands
*  and executes said commands until the shell is terminated.  It also keeps a history of the last 
*  10 commands executed, that can be cycled through with the up and down arrow keys.
*
*/

#include <stdio.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>

const int MAX_HIST = 10;

int main()
{
	int pid;
	int status;
	int count = 0;
	int curHist = 0, histCnt = 0;
	char *inpt = (char *) calloc(256, sizeof(char));
	char *dir = (char *) calloc(256, sizeof(char));
    char *buffer = (char *) calloc(2, sizeof(char));
	char *cmnd[10];
	char hist[MAX_HIST][256];
	
	while(1)
	{
  
 /*********************************** Printing current working directory prompt **************************/
 
		getcwd(dir, 256);
		printf("%s>", dir);
		free(dir);

 /************************************ Read input and Manage history *******************************/
 
		while(1)
		{
			fgets(buffer, 2, stdin);									// First byte of Arrow Keys
			if (buffer[0] == 27)
			{
				fgets(buffer, 2, stdin);
				if (buffer[0] == 91)									// Second byte of Arrow Keys
				{
					fgets(buffer, 2, stdin);
					if (buffer[0] == 67 || buffer[0] == 68)				// Side Arrows
						continue;
					
				//-----Scroll history-----
					else if (buffer[0] == 65)							// UP Arrow
					{
						if (histCnt != 0 )
						{
							printf(hist[curHist]);						// Print previous command
							strcpy(inpt, hist[curHist]);				// Prepare previous command for execution
							curHist--;									// Decrement history to previous commands
							if (curHist < 0)
								curHist = 0;
						}
						continue;
					}
					else if (buffer[0] == 66)							// DOWN Arrow
					{
						if (histCnt != 0)
						{
							printf(hist[curHist]);						// Print previous command
							strcpy(inpt, hist[curHist]);				// Prepare previous command for execution
							curHist++;									// Increment history to next command
							if (curHist >= histCnt)
								curHist = histCnt-1;
						}
						continue;
					}
				}
			}
			if (strcmp(buffer, "\n") == 0)								// "Enter" pressed
			{
				if (strcmp(inpt, "\n") != 0								// Input exists
				{
					if (histCnt == MAX_HIST-1)							// History is full
					{
						for (j=0; j<histCnt; j++)						// Shift down history
							strcpy(hist[j], hist[j+1]);
					}
					strcpy(hist[histCnt], input);						// Place current command in current history entry
					curHist = histCnt;
					histCnt++;											// increment history
					
					if (histCnt > MAX_HIST-1)
						histCnt = MAX_HIST-1;
				}
			}	
		}


/************************************* Tokenize input and decipher arguments *********************/
  
		char *token = strtok(inpt, " ");
		while (token != NULL)
		{
			//printf("%s\n", token);
			cmnd[count] = token;
			cmnd = strtok(NULL, "\n");
			count++;
		}
		cmnd[count] = NULL;
		
	//----- Check for "change directory" command -----
 
		if (strcmp(cmnd[0]), "cd" == 0)
		{
			if (chdir(cmnd[1]) != 0)
				perror(NULL);
		}
		
		else 
		{
 /*************************** Create child process and execute commands *************************/
 
			pid = fork();

			if (pid>0)
			{
				waitpid(pid, &status, WUNTRACED);                                 // wait for child process                                                                                                           
			}
			else if (pid == 0)
			{                  
				execvp(cmnd[0], command);                                              
				perror(NULL);
			}
			else
			{
				printf("Forking Error");
				exit(1);
			}
		}
	}
	return 0;
}
