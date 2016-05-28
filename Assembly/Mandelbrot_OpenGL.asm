;  Jared Hayes, CS218 Section 02, Assignment #10
;  Support Function -> Provided Template.

; -----
;  Function getMandParams()
;	Read, checks, and returns command line parameters.

;  Function plotMandelbrot()
;	Plots mandelbrot function (as per provided algorithm).

; ---------------------------------------------------------

;	MACROS (if any) GO HERE


; ---------------------------------------------------------

section  .data

; -----
;  Define standard constants.

TRUE		equ	1
FALSE		equ	0

SUCCESS		equ	0			; successful operation
NOSUCCESS	equ	1			; unsuccessful operation

STDIN		equ	0			; standard input
STDOUT		equ	1			; standard output
STDERR		equ	2			; standard error

SYS_read	equ	0			; system call code for read
SYS_write	equ	1			; system call code for write
SYS_open	equ	2			; system call code for file open
SYS_close	equ	3			; system call code for file close
SYS_fork	equ	57			; system call code for fork
SYS_exit	equ	60			; system call code for terminate
SYS_creat	equ	85			; system call code for file open/create
SYS_time	equ	201			; system call code for get time

LF		equ	10
SPACE		equ	" "
NULL		equ	0
ESC		equ	27

; -----
;  OpenGL constants

GL_COLOR_BUFFER_BIT	equ	16384
GL_POINTS		equ	0
GL_POLYGON		equ	9
GL_PROJECTION		equ	5889

GLUT_RGB		equ	0
GLUT_SINGLE		equ	0

; -----
;  Local variables for getMandParams() function.

WMIN		equ	200
WMAX		equ	2048

HMIN		equ	200
HMAX		equ	2048

ddFour		dd	4
tmpNum		dd	0

fTenPtZero	dq	10.0

errUsage	db	"Usage: mand "
		db	"-pw <quaternaryNumber> -ph <quaternaryNumber>"
		db	LF, NULL

errOptions	db	"Error, invalid command line options."
		db	LF, NULL

errWSpec	db	"Error, picture width specifier."
		db	LF, NULL
errWValue	db	"Error, picture width value out of range (3020 - 200000)."
		db	LF, NULL

errHSpec	db	"Error, picture height specifier."
		db	LF, NULL
errHValue	db	"Error, picture height value out of range (3020 - 200000)."
		db	LF, NULL

; -----
;  Local variables for platMandelbrot() function

colorTable	db	255,   0,   0,   0
		db	  0,   0, 255,   0
		db	  0, 255,   0,   0
		db	  0, 255, 255,   0
		db	255, 255,   0,   0
		db	255,   0, 255,   0
		db	128, 128, 128,   0
		db	255, 255, 255,   0
clrTableSize	dd	8

nx		dd	0			; Nx
ny		dd	0			; Ny
i		dd	0
ncol		dd	0
nMax		dd	100

fPicHeight	dq	0.0			; pictureheight, double
fPicWidth	dq	0.0			; picture width, double

x		dq	0.0			; current x
y		dq	0.0			; current y

xt		dq	0.0
yt		dq	0.0

xn		dq	0.0
yn		dq	0.0

fTwoPtZero	dq	2.0
fFourPtZero	dq	4.0

; ------------------------------------------------------------

section  .text

; -----
;  Open GL routines.

extern glutInit, glutInitDisplayMode, glutInitWindowSize
extern glutInitWindowPosition
extern glutCreateWindow, glutMainLoop
extern glutDisplayFunc, glutIdleFunc, glutReshapeFunc, glutKeyboardFunc
extern glutSwapBuffers
extern gluPerspective
extern glClearColor, glClearDepth, glDepthFunc, glEnable, glShadeModel
extern glClear, glLoadIdentity, glMatrixMode, glViewport
extern glTranslatef, glRotatef, glBegin, glEnd, glVertex3f, glColor3f
extern glVertex2f, glVertex2i, glColor3ub, glOrtho, glFlush, glVertex2d
extern glutPostRedisplay

; ******************************************************************
;  Function getMandParams()
;	Get, check, convert, verify range, and return:
;		screen width
;		screen height

;	Example call:
;		getMandParams(ARGC, ARGV, picWidth, picHeight);

;	Routine performs all error checking, conversion of ASCII/quaternary
;	to integer, verifys legal range of each value.
;	For errors, applicable message is displayed and FALSE is returned.
;	For good data, all values are returned via addresses with TRUE returned.

;	Command line format (fixed order):
;	  "-pw <quaternaryNumber> -ph <quaternaryNumber>"
; ./mand -pw 3001 -ph 21120
; -----
;  Arguments:
;	1) ARGC					- rdi
;	2) ARGV					- rsi
;	)  zoomfactor, address			- rdx
;	3) screen width, address		- rcx
;	4) screen height, address		- r8

global getMandParams
getMandParams:

;	YOUR CODE GOES HERE

	push rbx				; prologue
	push r12
	push r13
	

	; if(argc == 1)
	;	display usage error
	;	jump to exitLoop, return FALSE
	
	cmp	 rdi, 1				; if argc != 1
	jne	 fiveArgs			; jump to nineArgs

	push 	 rdi				; else save argc
	mov	 rdi, errUsage			; copy errUsage to rdi register
	call	 printString			; call printString display error
	pop	 rdi				; pop argc

	mov	 rax, FALSE			; copy FALSE to rax register
	jmp 	 exitLoop			; jump to exitLoop

; ----------------------------------------------------------------------	
	; if(argc != 5)	
	;	display errOptions
	;	jump to exitLoop, return FALSE

fiveArgs:	
	cmp 	rdi, 5				; if argc is == 5
	je 	wArg				; then jump to wArg
	
	jmp	invalidOpt		

; ------------------------------------------------------------------------	
	; if(argv[1] != "-pw")
	; 	display wSpecError
	;	jump to wspecError, return FALSE
	
wArg:
	mov 	rbx, qword[rsi+8]		; copy argv to rbx register
	
	cmp 	byte[rbx], "-"			; if argv != "_"
	jne 	wSpecError				; jump to wSpecError
	cmp 	byte[rbx+1], "p"		; if argv != "p"
	jne 	wSpecError				; jump to wSpecError
	cmp 	byte[rbx+2], "w"		; if argv != "w"
	jne 	wSpecError				; jump to wSpecError
	cmp 	byte[rbx+3], NULL		; if argv != NULL
	jne 	wSpecError				; jump to wSpecError
	mov 	rax, TRUE			; else move TRUE into rax
	
	mov 	r12, 16
; -------------------------------------------------------------------------
w_Value:	
	mov 	rbx, qword[rsi+16]		; copy next argv (3rd) to rbx
	
	push 	rsi 				; save argv 
	mov 	rdi, rbx			; copy next argv to rdi(3rd arg)
	mov 	rsi, tmpNum			; copy tmpNum to rsi register
	call 	quarternary2Int			; call quarternary2Int 
	pop 	rsi				; pop argv
	cmp	al, TRUE			; if al is not TRUE
	jne	wError				; jump to invalidOpt

; code for checking range (min and max)	

	mov	eax, dword[tmpNum]		; copy integer to rax
	cmp	eax, WMIN			; if integer < WMIN(out of range)
	jb	wError				; jump to wError
	cmp 	eax, WMAX			; else if integer > WMAX (out of range)
	ja	wError				; jump to wError
	
	mov	dword[ecx], eax			; save integer to edx (w value, adress)
	mov 	rax, TRUE			; return true to rax 

; --------------------------------------------------------------------------
	; if(argv[3] != "-ph")
	; 	display hSpecError
	;	jump to hSpecError, return FALSE

hArg:
	mov 	rbx, qword[rsi+24]		; copy h_argv("-ph") to rbx
	
	cmp 	byte[rbx], "-"			; if argv != "_"
	jne 	hSpecError				; jump to hSpecError
	cmp 	byte[rbx+1], "p"		; if argv != "p"
	jne 	hSpecError				; jump to hSpecError
	cmp 	byte[rbx+2], "h"		; if argv != "h"
	jne 	hSpecError				; jump to hSpecError
	cmp 	byte[rbx+3], NULL		; if argv != NULL
	jne 	hSpecError				; jump to hSpecError
	mov 	rax, TRUE			; else move TRUE into rax

	mov 	r12, 32
; ---------------------------------------------------------------------------
h_Value:	
	mov 	rbx, qword[rsi+32]		; copy h_argv(5th) to rbx register	
	
	push 	rsi				; save argv
	mov 	rdi, rbx			; copy h_argv(5th) to rdi register
	mov 	rsi, tmpNum			; copy tmpNum to rsi
	call 	quarternary2Int			; call quarternary2Int
	pop 	rsi				; pop  h_argv
	cmp	al, TRUE			; if al is not TRUE 
	jne	hError				; jump to invalidOpt

; code for checking range (min and max)
	
	mov	eax, dword[tmpNum]		; copy integer to rax
	cmp	rax, HMIN			; if integer < HMIN(out of range)
	jb	hError				; jump to hError
	cmp 	rax, HMAX			; if integer > HMax
	ja	hError				; jump to hError
	
	mov	dword[r8d], eax			; save integer to rcx(h value, adress)
	mov 	rax, TRUE			; return true to rax
	jmp	exitLoop
	
; -------------------------------------------------------------------------------
; convert Quarternary to Integer

;	implemented as a function

; -------------------------------------------------------------------------------
	
wError:
	mov rdi, errWValue			; copy errAValue to rdi 
	call printString			; call printString
	mov rax, FALSE				; copy FALSE to rax
	jmp exitLoop				; jump to exitLoop
	
wSpecError:	
	mov rdi, errWSpec			; copy  errASpec to rdi 
	call printString			; call printString
	mov rax, FALSE				; copy FALSE to rax
	jmp exitLoop				; jump to exitLoop
	
hError:
	mov rdi, errHValue			; copy errBValue to rdi 
	call printString			; call printString
	mov rax, FALSE				; copy FALSE to rax
	jmp exitLoop				; jump to exitLoop
	
hSpecError:	
	mov rdi, errHSpec			; copy  errBSpec to rdi
	call printString			; call printString
	mov rax, FALSE				; copy FALSE to rax
	jmp exitLoop				; jump to exitLoop

invalidOpt:
	mov rdi, errOptions
	call printString			; call printString
	mov rax, FALSE				; copy FALSE to rax

exitLoop:
	pop r13
	pop r12
	pop rbx
	ret

; ******************************************************************
;  Function: Check and convert ASCII/quarternary to integer
;	return false 

;  Example HLL Call:
;	stat = quarternary2int(vStr, &num);

global quarternary2Int
quarternary2Int:

;	YOUR FUNCITON GOES HERE

	push rbx
	push r12
	push r13
	push r14
	push r15
	
	mov	r12, 0				; index/counter
	lea 	rbx, byte [rdi]			; vegisimal number address

checkLoop:
	
	mov	al, byte[rbx]			; retrive char
	cmp 	al, NULL			; if char == NULL
	je 	quart2Int				; jump to conversion
	cmp	al,32				; if char == 'space'
	je 	checkNext				; check next character

	cmp 	al, "0"				; if char < 0
	jb 	notValid				; not valid quarternary number
	cmp	al, "3"				; if char > 3
	ja	notValid				; not valid quarternary number

checkNext:
	inc	rbx				; increment buffer
	jmp	checkLoop			; loop

quart2Int:
	lea 	rbx, byte [rdi]			; refresh address
	mov 	rax, 0				; running sum
	mov 	r13, 0				; refresh counter
	mov	r12, 0				; char to convert

cvtLoop:	
	mov 	r12b, byte[rbx]			; read next char
	cmp	r12b, NULL			; if char == NULL
	je 	cvtDone 				; conversion done
	sub 	r12b, "0"			; else integer digit = char - "0" (ASCII 48)
	
calcSum:
	mov	r14d, 4				; set r14d = 4
	mul	r14d				; sum = sum * 4
	add 	rax, r12			; sum = sum + integer digit

	inc 	rbx				; increment index
	inc 	r13				; increment counter
	cmp 	r13, 6				; if counter >= buffer size			
	jae 	cvtDone				; conversion done
	jmp 	cvtLoop 			; else loop to cvtLoop

notValid:
	mov 	rax, FALSE			; copy false to rax
	jmp 	Finished				; jump to finish

cvtDone:	
	mov 	dword[rsi], eax			; else return converted int by reference
	mov 	rax, TRUE			; return TRUE code

Finished:
	pop r15					; epilogue
	pop r14
	pop r13
	pop r12
	pop rbx
	ret

; ******************************************************************
;  Plot Mandelbrot Function.

; -----
;  Gloabal variables
;	Shared between this file and the provided main

common	zoomFactor	1:8			; zoom factor (float)
common	picWidth	1:4			; screen width
common	picHeight	1:4			; screen height
common	xOffset		1:8			; (float)
common	yOffset		1:8 			; (float)

global plotMandelbrot
plotMandelbrot:


;	YOUR CODE GOES HERE

	push rbx
	push rdi
	push rsi
	push rdx
	push r12
	push r13
	push r14
	push r15

; -----
; Prepare for drawing
;	glClear(GL_COLOR_BUFFER_BIT);

	mov	rdi, GL_COLOR_BUFFER_BIT
	call	glClear

; glBegin(GL_POINTS);
	mov	rdi, GL_POINTS
	call	glBegin

; -----
; ------------------------------------- Main plot loop ----------------------------------------

;	YOUR CODE GOES HERE

	cvtsi2sd xmm9, dword[picWidth]		; convert picWidth to 64-bit float
	cvtsi2sd xmm10, dword[picHeight]	; convert picHeight to 64-bit float

	mov r12d, dword[nx]			; setup Nx for NxLoop
	inc r12d				; set Nx to 1

nxLoop:
	cvtsi2sd xmm7, r12d			; convert Nx to quad float
	mov r13d, dword[ny]			; setup Ny for NyLoop
	inc r13d				; set Ny to 1

nyLoop:
	cvtsi2sd xmm8, r13d			; convert Ny to quad float

; ----- xt = ( (4/picHeight)*(Nx-picWidth/2) / zoomFactor ) + xOffset 
	
	movsd xmm3, qword[fFourPtZero]		; move 4 into xt
	divsd xmm3, xmm10			; (4/picHeight)
	movsd xmm0, xmm9			; move picWidth into xmm0
	divsd xmm0, qword[fTwoPtZero]		; picWidth/2
	movsd xmm1, xmm7			; move Nx into xmm1
	subsd xmm1, xmm0			; (Nx-picWidth/2)
	mulsd xmm3, xmm1			; xt = (4/picHeight)*(Nx-picWidth/2)
	divsd xmm3, qword[zoomFactor]		; xt = (4/picHeight)*(Nx-picWidth/2) / zoomFactor
	addsd xmm3, qword[xOffset]			; + xOffset
	movsd qword[xt], xmm3			; move answer into xt

; ----- yt = ( (4/picHeight)*(Ny-picHeight/2) / zoomFactor ) + yOffset 

	movsd xmm4, qword[fFourPtZero]		; move 4 into yt
	divsd xmm4, xmm10			; (4/picHeight)
	movsd xmm0, xmm10			; move picHeight into xmm0
	divsd xmm0, qword[fTwoPtZero]		; picheight/2
	movsd xmm1, xmm8			; move Ny into xmm1
	subsd xmm1, xmm0			; (Ny-picHeight/2)
	mulsd xmm4, xmm1			; xt = (4/picHeight)*(Ny-picHeight/2)
	divsd xmm4, qword[zoomFactor]		; xt = (4/picHeight)*(Ny-picHeight/2) / zoomFactor
	addsd xmm4, qword[yOffset]			; + yOffset
	movsd qword[yt], xmm4			; move answer into yt
						
	movsd xmm14, xmm3			; x = xt
	movsd qword[x], xmm14				; save answer in x
	movsd xmm15, xmm4			; y = yt
	movsd qword[y], xmm15				; save answer in y

	mov r14d, dword[i]			; setup i for iLoop
	inc r14d				; set i to 1

iLoop:
; --- xn = x*x - y*y + xt
	movsd xmm5, xmm14			; xn = x
	mulsd xmm5, xmm5			; xn = x*x
	movsd xmm0, xmm15			; xn = x*x - y
	mulsd xmm0, xmm0			; xn = x*x - y*y
	subsd xmm5, xmm0			; xn = x*x - y*y
	addsd xmm5, xmm3			; xn = x*x - y*y + xt
	movsd qword[xn], xmm5			; save answer in xn

; --- yn = 2*x*y + yt
	movsd xmm6, qword[fTwoPtZero]		; yn = 2
	mulsd xmm6, xmm14			; yn = 2*x
	mulsd xmm6, xmm15			; yn = 2*x*y
	addsd xmm6, xmm4			; yn = 2*x*y + yt
	movsd qword[yn], xmm6			; save answer in yn
	
plotIf:
; --- xn*xn + yn*yn
	movsd xmm0, xmm5			; get xn
	mulsd xmm0, xmm0			; xn*xn
	movsd xmm1, xmm6			; get yn
	mulsd xmm1, xmm1			; yn*yn
	addsd xmm0, xmm1			; xn*xn + yn*yn
	ucomisd xmm0, qword[fFourPtZero]	; if (xn*xn + yn*yn) > 4
	jbe skipPlot					;else end if

; --- c = i % clrTableSize	
	mov edx, 0				; clear edx for divide
	mov eax, r14d				; move i into eax for divide
	div dword[clrTableSize]			; integer divide 
	mov r15d, edx				; put remainder in c
	mov dword[ncol], r15d			; save answer in ncol

; --- setColor (red[c], green[c], blue[c])
	mov rax, 0				; clear rax
	mov rsi, 0				; clear arg registers
	mov rdi, 0				
	mov rdx, 0

	mov ebx, colorTable			; get address of colorTable in ebx
	lea eax, dword[rbx+r15*4]		; get address of dword sized row of color pixel
	mov dil, byte[rax]			; 1st arg - pass 1st byte of color row for red[c]
	mov sil, byte[rax+1]			; 2nd arg - pass 2nd byte of color row for green[c]
	mov dl, byte[rax+2]			; 3rd arg - pass 3rd byte of color row for blue[c]
	call glColor3ub				; call openGL setcolor function

; --- PlotPoint (Nx, Ny)
	movsd xmm0, xmm7			; 1st arg - Nx
	movsd xmm1, xmm8			; 2nd arg - Ny
	call glVertex2d				; call openGL plotpoint function
	jmp nextNy				; break from iLoop - jump to nextNy					

skipPlot:
	movsd xmm14, xmm5			; x = xn
	movsd qword[x], xmm14				; save answer in x
	movsd xmm15, xmm6			; y = yn
	movsd qword[y], xmm15				; save answer in y

	inc r14d				; increment i
	cmp r14d, dword[nMax]			; if i < nMax (100)
	jbe iLoop					; loop iLoop

nextNy:
	inc r13d				; increment Ny
	cmp r13d, dword[picHeight]		; if Ny < picHeight
	jbe nyLoop					; loop NyLoop

	inc r12d				; increment Nx
	cmp r12d, dword[picWidth]		; if Nx < picWidth
	jbe nxLoop					; loop NxLoop
	
; -------------------------------------------------------------------------------------------------

;  Done, make final openGL calls.

mandDone:
	call	glEnd
	call	glFlush

	call	glutPostRedisplay

; -----
;  Return to calling routine.

;	YOUR CODE GOES HERE

	pop r15
	pop r14
	pop r13
	pop r12
	pop rdx
	pop rsi
	pop rdi
	pop rbx
	ret

; ******************************************************************
;  Generic procedure to display a string to the screen.
;  String must be NULL terminated.

;  Algorithm:
;	Count characters in string (excluding NULL)
;	Use syscall to output characters

; -----
;  HLL Call:
;	printString(stringAddr);

;  Arguments:
;	1) address, string
;  Returns:
;	nothing

global	printString
printString:

; -----
;  Count characters to write.

	mov	rdx, 0
strCountLoop:
	cmp	byte [rdi+rdx], NULL
	je	strCountLoopDone
	inc	rdx
	jmp	strCountLoop
strCountLoopDone:
	cmp	rdx, 0
	je	printStringDone

; -----
;  Call OS to output string.

	mov	rax, SYS_write			; system code for write()
	mov	rsi, rdi			; address of char to write
	mov	rdi, STDOUT			; file descriptor for std in
						; rdx=count to write, set above
	syscall					; system call

; -----
;  String printed, return to calling routine.

printStringDone:
	ret

; ******************************************************************

