#include <cstdlib>
#include <iostream>
#include <GL/gl.h>
#include <GL/glut.h>
#include <GL/freeglut.h>

using	namespace	std;

// ----------------------------------------------------------------------
//  CS 218 -> Assignment #10
//  Mandelbrot Program.
//  Provided main...

//  Uses openGL (which must be installed).
//  openGL installation:
//	sudo apt-get update
//	sudo apt-get upgrade
//	sudo apt-get install binutils-gold
//	sudo apt-get install libgl1-mesa-dev
//	sudo apt-get install freeglut3 freeglut3-dev


// ----------------------------------------------------------------------
//  External functions (in seperate file).

extern "C" void plotMandelbrot();
extern "C" int getMandParams(int, char* [], double *, int *, int *);


// ----------------------------------------------------------------------
//  Global variables
//	Must be accessible for openGL display routine, plotMandelbrot().

double	zoomFactor = 1.0;
int	picWidth;
int	picHeight;
double	xOffset = -0.5;
double	yOffset = 0.5;

static	const	double	STEP = 0.02;
static	const	double	ZSTEPINC = 0.03;
double	zStep = ZSTEPINC;

// ----------------------------------------------------------------------
//  Key handler function.
//	Terminates for 'x', 'q', or ESC key.
//	Updates zoomFactor for 'z' (zoom in) and 'Z' (zoom out).

void	keyHandler(unsigned char key, int x, int y)
{
	if (zStep == 0.0)
		zStep = ZSTEPINC;

	if (key == 'z') {
		zoomFactor += zStep;
		zStep += ZSTEPINC;
	}

	if (key == 'Z') {
		zoomFactor -= zStep;
		zStep -= ZSTEPINC;
	}

	if (zoomFactor < 0.0)
		zoomFactor = 0.0;

	if (key == 'x' || key == 'q' || key == 27 || key == 100) {
		glutLeaveMainLoop();
		exit(0);
	}
}

// ----------------------------------------------------------------------
//  Key handler function.
//	Updates x and y offsets if arrow keys are typed.

void	arrowHandler(int key, int x, int y)
{
	if (key == GLUT_KEY_LEFT)
		xOffset += STEP;

	if (key == GLUT_KEY_RIGHT)
		xOffset -= STEP;

	if (key == GLUT_KEY_UP)
		yOffset -= STEP;

	if (key == GLUT_KEY_DOWN)
		yOffset += STEP;
}

// ----------------------------------------------------------------------
//  Main routine.

int main(int argc, char* argv[])
{
	bool	stat;

	double	left = 0.0;
	double	right = 0.0;
	double	bottom = 0.0;
	double	top = 0.0;

	stat = getMandParams(argc, argv, &zoomFactor, &picWidth,
				&picHeight);

	// Debug call for display function
	//	plotMandelbrot();

	right = static_cast<double>(picWidth);
	top = static_cast<double>(picHeight);

	if (stat) {
		glutInit(&argc, argv);
		glutInitDisplayMode(GLUT_RGB | GLUT_SINGLE);
		glutInitWindowSize(picWidth, picHeight);
		glutInitWindowPosition(100, 100);
		glutCreateWindow("CS 218 Assignment #10, Mandelbrot Program");
		glClearColor(0.0, 0.0, 0.0, 0.0);
		glClear(GL_COLOR_BUFFER_BIT);
//		glMatrixMode(GL_PROJECTION);
		glMatrixMode(GL_MODELVIEW);
		glLoadIdentity();
		glOrtho(left, right, bottom, top, 0.0, 1.0);
	
		glutSpecialFunc(arrowHandler);
		glutKeyboardFunc(keyHandler);

		glutDisplayFunc(plotMandelbrot);

		glutMainLoop();
	}

	return 0;
}

