// CS 218 - Provided C++ program
//	This programs calls assembly language routines.

//  NOTE: To compile this program, and produce an object file
//	must use the "g++" compiler with the "-c" option.
//	Thus, the command "g++ -c main.c" will produce
//	an object file named "main.o" for linking.

//  Must ensure g++ compiler is installed:
//	sudo apt-get update
//	sudo apt-get upgrade
//	sudo apt-get install g++

// ***************************************************************************

#include <cstdlib>
#include <iostream>
#include <fstream>
#include <cstdlib>
#include <string>
#include <iomanip>

using namespace std;


// ***************************************************************
//  Prototypes for external functions.
//	The "C" specifies to use the standard C/C++ style
//	calling convention.

extern "C" int getFileDescriptors(int, char **, FILE **, FILE **);
extern "C" int countChars(FILE *, int *);
extern "C" int cracker(int *);
extern "C" int decrypt(int, FILE *, FILE *);
extern "C" void resetRead(FILE *);


// ***************************************************************
//  Begin a basic C++ program (does not use objects).

int main(int argc, char* argv[])
{

// --------------------------------------------------------------------
//  Declare variables and simple display header
//	Note, by default, C++ integers are doublewords (32-bits).

	string	bars;
	bars.append(50,'-');
	FILE	*readFile, *writeFile;
	int	key;
	int	ltrCounts[26];

	for (int i=0; i<26; i++)
		ltrCounts[i] = 0;

	cout << bars << endl;
	cout << "CS 218 - Assignment #11 - Caesar Cipher Cracker"
		<< endl << endl;


// --------------------------------------------------------------------
//  Attempt to decrypt...

	if (getFileDescriptors(argc, argv, &readFile, &writeFile)) {

		if(!countChars(readFile, ltrCounts)) {
			cout << "Error reading file, program terminated."
				<< endl;
		} else {

			key = cracker(ltrCounts);
			resetRead(readFile);

			if (decrypt(key, readFile, writeFile))
				cout << "The decryption key was: "
					<< key << endl;
			else
				cout << "Error decrypting." << endl;
		}
	}

// --------------------------------------------------------------------
//  All done...

	return 0;
}

