;  Jared Hayes, CS 218 Section 02 - Assignment #11
;  Functions Template

; ***********************************************************************
;  Data declarations
;	Note, the error message strings should NOT be changed.
;	All other variables may changed or ignored...

; ---- Debug in DDD with this command format: run -i a11f1.txt -o clear.txt

section	.data

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
SYS_lseek	equ	8			; system call code for file repositioning
SYS_fork	equ	57			; system call code for fork
SYS_exit	equ	60			; system call code for terminate
SYS_creat	equ	85			; system call code for file open/create
SYS_time	equ	201			; system call code for get time

LF		equ	10
SPACE		equ	" "
NULL		equ	0
ESC		equ	27

O_CREAT		equ	0x40
O_TRUNC		equ	0x200
O_APPEND	equ	0x400

O_RDONLY	equ	000000q			; file permission - read only
O_WRONLY	equ	000001q			; file permission - write only
O_RDWR		equ	000002q			; file permission - read and write

S_IRUSR		equ	00400q
S_IWUSR		equ	00200q
S_IXUSR		equ	00100q

; -----
;  Define program specific constants.

BUFF_SIZE	equ	750000			; buffer size (will be changed)

; -----
;  Local variables for getFileDescriptors() function.

eof		db	FALSE

usageMsg	db	"Usage: ./cracker -i <inputFileName> "
		db	"-o <outputFileName>", LF, NULL
errIncomplete	db	"Error, incomplete command line arguments.", LF, NULL
errExtra	db	"Error, too many command line arguments.", LF, NULL
errInputSpec	db	"Error, invalid input file specifier.", LF, NULL
errOutputSpec	db	"Error, invalid output specifier.", LF, NULL
errInputFile	db	"Error, unable to open input file.", LF, NULL
errOutputFile	db	"Error, unable to open output file.", LF, NULL

; -----
;  Local variables for countChars() function.

done		db	FALSE
charr		db	0

; -----
;  Local variables for getCharacter() function.
;	accessed by resetRaed() function.

buffMax		dq	BUFF_SIZE
curr		dq	BUFF_SIZE
wasEOF		db	FALSE

errRead		db	"Error, reading input file.", LF,
		db	"Program terminated.", LF, NULL

; -----
;  Local variables for putCharacter() function.

tmpChr		db	0
errWrite	db	"Error, writting to output file.", LF,
		db	"Program terminated.", LF, NULL

; -----
;  Local variables for cracker() function.

rotate		dd	0
diff		dd	0.0
min		dd	27.0
total		dd	0.0
tmp		dd	0.0
status		dw	0.0
tmpKey		dd	0
tmpFreq		dd	0.0
fSum		dd	0.0

ptZero		dd	0.0

found		dd	0.0, 0.0, 0.0, 0.0, 0.0
		dd	0.0, 0.0, 0.0, 0.0, 0.0
		dd	0.0, 0.0, 0.0, 0.0, 0.0
		dd	0.0, 0.0, 0.0, 0.0, 0.0
		dd	0.0, 0.0, 0.0, 0.0, 0.0
		dd	0.0

freq		dd	0.07833		; a
		dd	0.01601		; b
		dd	0.02398		; c
		dd	0.04554		; d
		dd	0.12706		; e
		dd	0.02039		; f
		dd	0.02352		; g
		dd	0.05742		; h
		dd	0.06827		; i
		dd	0.00250		; j
		dd	0.01107		; k
		dd	0.03974		; l
		dd	0.02605		; m
		dd	0.06622		; n
		dd	0.07617		; o
		dd	0.01904		; p
		dd	0.00070		; q
		dd	0.05445		; r
		dd	0.06205		; s
		dd	0.09500		; t
		dd	0.02997		; u
		dd	0.00849		; v
		dd	0.02563		; w
		dd	0.00195		; x
		dd	0.01964		; y
		dd	0.00080		; z

; -----
;  Local variables for decrypt() function (if any).



; ------------------------------------------------------------------------
;  Unitialized data

section	.bss

buffer		resb	BUFF_SIZE
testCount	resd	26


; ############################################################################

section	.text

; ***************************************************************
;  Routine to get file descriptors.
;	Must parse command line, check for errors,
;	attempt to open files, and, if files open
;	successfully, return descriptors.
;	Otherwise, display appropriate error message.

;  Command Line format:
;	./cracker -i <inputFileName> -o <outputFileName>

; -----
;  HLL Call:
;	getFileDescriptors(argc, argv, &readFile, &writeFile)

; -----
;  Arguments:
;	argc, value				- rdi
;	argv table, address			- rsi
;	input file descriptor, address		- rdx
;	output file descriptor, address		- rcx
;  Returns:
;	file decriptors, via reference
;	TRUE (if worked) or FALSE (if error)

global	getFileDescriptors
getFileDescriptors:


;	YOUR CODE GOES HERE

	push rbx				; prologue
	push r12
	push r13
	

	; if(argc == 1)
	;	display usage error
	;	jump to exitLoop, return FALSE
	
	cmp	 rdi, 1				; if argc != 1
	jne	 fiveArgs			; jump to fiveArgs

	push 	 rdi				; else save argc
	mov	 rdi, usageMsg			; copy errUsage to rdi register
	call	 printString			; call printString display error
	pop	 rdi				; pop argc

	mov	 rax, FALSE			; copy FALSE to rax register
	jmp 	 exitLoop			; jump to exitLoop

; ----------------------------------------------------------------------	
	; if(argc != 5)	
	;	display errOptions
	;	jump to exitLoop, return FALSE

fiveArgs:	
	cmp 	rdi, 5				; if argc is < 5
	jl 	incompleteOpt				; then jump to incompleteOpt
	cmp 	rdi, 5				; if argc is > 5
	jg 	extraOpt				; then jump to extraOpt		

; ------------------------------------------------------------------------	
	; if(argv[1] != "-i")
	; 	display iSpecError
	;	jump to ispecError, return FALSE
	
iArg:
	mov 	rbx, qword[rsi+8]		; copy argv("-i") to rbx register
	
	cmp 	byte[rbx], "-"			; if argv != "_"
	jne 	iSpecError				; jump to iSpecError
	cmp 	byte[rbx+1], "i"		; if argv != "i"
	jne 	iSpecError				; jump to iSpecError
	cmp 	byte[rbx+2], NULL		; if argv != NULL
	jne 	iSpecError				; jump to iSpecError
	mov 	rax, TRUE			; else move TRUE into rax
	
	mov 	r12, 16
; -------------------------------------------------------------------------
	; if(argv[3] != "-o")
	; 	display oSpecError
	;	jump to oSpecError, return FALSE

oArg:
	mov 	rbx, qword[rsi+24]		; copy argv("-o") to rbx
	
	cmp 	byte[rbx], "-"			; if argv != "_"
	jne 	oSpecError				; jump to oSpecError
	cmp 	byte[rbx+1], "o"		; if argv != "o"
	jne 	oSpecError				; jump to oSpecError
	cmp 	byte[rbx+2], NULL		; if argv != NULL
	jne 	oSpecError				; jump to oSpecError
	mov 	rax, TRUE			; else move TRUE into rax

	mov 	r12, 32
; ---------------------------------------------------------------------------
; attempt to open/read file

open_Read_File:
	
	push	rdi				; save arg
	push 	rsi				; save arg
	push	rcx				; save arg

	mov 	rax, SYS_open			; file open
	mov 	rdi, qword[rsi+16]		; file name string
	mov	rsi, O_RDONLY			; read only access
	syscall 

	pop	rcx				; pop save arg
	pop 	rsi				; pop save arg
	pop 	rdi				; pop save arg

	cmp 	rax, 0				; check for success
	jl	errorInput			; if not success, jump to errorInput to diplay error and exit
	
	mov	qword[rdx], rax			; else return file descriptor

; -----------------------------------------------------------------------------
;attempt to create output file
create_Write_File:
		
	
	push rdi				; save arg
	push rsi				; save arg
	push rcx				; save arg
	
	mov  	rax, SYS_creat			; file open / create
	mov  	rdi, qword[rsi + 32]		; filedescriptor
	mov 	rsi, S_IRUSR | S_IWUSR		; allow read and write
	syscall

	pop rcx					; pop save arg
	pop rsi					; pop save arg
	pop rdi					; pop save arg

	cmp 	rax, 0				; check create success
	jl	errorOutput			; if not, jump to errorOutput to display error and exit
	
		
	mov	qword[rcx], rax			; else return file descriptor

	mov 	rax, TRUE			; return  success 
	jmp 	exitLoop			; jump to exitLoop

; -------------------------------------------------------------------------------
; This is above function jump here displays error
; 	display error and jump to exitLoop

errorInput:
	push 	rdi				; save arg
	mov 	rdi, errInputFile		; copy error to rdi to display error
	call	printString			; call printString
	pop 	rdi				; pop rdi
	mov	rax, FALSE			; return false 
	jmp 	exitLoop			;  go to exitLoop

errorOutput:
	push	rdi				; save arg
	mov	rdi, errOutputFile		; copy error to rdi to display error
	call 	printString			; call printString
	pop 	rdi				; pop save arg
	mov 	rax, FALSE			; return false
	jmp	exitLoop			;  go to exitLoop

iSpecError:
	push 	rdi				; save arg
	mov 	rdi, errInputSpec		; copy error to rdi to display error
	call 	printString			; call printString
	pop 	rdi				; pop save arg
	mov 	rax, FALSE			; return false
	jmp 	exitLoop			;  go to exitLoop

oSpecError:
	push 	rdi				; save arg
	mov 	rdi, errOutputSpec		; copy error to rdi to display error
	call 	printString			; call printString
	pop 	rdi				; pop save arg
	mov 	rax, FALSE			; return false
	jmp 	exitLoop			;  go to exitLoop

incompleteOpt:
	push 	rdi				; save arg
	mov 	rdi, errIncomplete		; copy error to rdi to display error
	call	printString			; call printString
	pop 	rdi				; pop arg
	mov	rax, FALSE			; return false			
	jmp 	exitLoop				; go to exitLoop

extraOpt:
	push 	rdi				; save arg
	mov 	rdi, errExtra			; copy error to rdi to display error
	call	printString			; call printString
	pop 	rdi				; pop arg
	mov	rax, FALSE			; return false			
	jmp 	exitLoop				; go to exitLoop
				
exitLoop:
	
	pop r13					;pop arg
	pop r12					;pop arg
	pop rbx					;pop arg
	ret



; ***************************************************************
;  Determine the counts for each letter in the file.
;	Returns an array with the count for each letter.
;	Input file handle and address of count array are passed.
;	Note, I/O is buffered by getCharacter() routine.

; ----
;  HLL Call:
;	status = countChars(readFileDesc, &ltrCounts);

; -----
;  Arguments:
;	input file descriptor, value		; - rdi
;	letter counts array, address		; - rsi

; -----
;  algorithm:
;	loop to get a character from input file
;		if lower, force character to be upper case
;		if character is not a character, just skip.
;		if upper, convert letter to index
;		update count array at that index

global	countChars
countChars:


;	YOUR CODE GOES HERE

	push rbx
	push r12
	
	mov rbx, 0				; initialize rbx
	mov r12, 0				; initialize count array index

countLoop:

	push rsi				; save counts array arg through call
	;mov rdi, rdi				; move file descriptor into first arg
	mov rsi, charr				; move address of charr into second arg
	call getCharacter
	pop rsi					; return saved counts array arg

	cmp rax, FALSE				; if char not returned
	je countDone					; jump to countDone

; ------------- Check Char Cases -------------	
	mov bl, byte[charr]			; get char into bl
	cmp bl, "A"				; if char < "A" or char >"z"
	jl skipCount					; jump to skipCount		
	cmp bl, "z"					; ignore char
	jg skipCount
	cmp bl, "a"				; if char > "a" && char < "z"
	jge forceUpper					; jump to forceUpper (make uppercase)
	cmp bl, "Z"				; if char > "Z" and char < "a"
	jg skipCount					; jump to skipCount (ignore char)
	jmp lett2Index				; else convert letter to index

forceUpper:
	sub bl, 32				; subtract 32 from lowercase char to make uppercase

; -------- Convert Letter to Index -----------
lett2Index:
	sub bl, 65				; subtract 65 from uppercase char to create index
	add dword[rsi+rbx*4], 1			; count[rbx] = count[rbx] + 1
	add dword[testCount+rbx*4], 1

skipCount:
	jmp countLoop

countDone:
	cmp byte[wasEOF], TRUE			; if end of file detected
	mov rax, TRUE					; return success
						; else return false (file read error)
	pop r12
	pop rbx
	
	ret

; ***************************************************************
;  Get character routine
;	Returns one character from buffer.
;	Fills buffer if buffer is empty.
;	This routine performs all buffer management

;	The read buffer itself and some misc. variables are
;	used ONLY by this routine and as such are not passed.

; ----
;  HLL Call:
;	status = getCharacter(readFileDesc, &char);

;  Arguments:
;	input file descriptor, value			; - rdi
;	character, address				; - rsi
;  Returns:
;	status (SUCCESS or NOSUCCESS)			; - rax
;	character, via reference			; - &rsi

global	getCharacter
getCharacter:


;	YOUR CODE GOES HERE

	push rbx
	push r12
	push r13
	push r14
	push r15

	mov r13, 0					; index
	mov r12, qword[curr]				; get global current index in r12

getNxtChar:

; ------------ if(curr>= bfmax) -------------------

	mov	rax, qword [curr]			; copy curr value to rax
	mov 	rbx, qword[buffMax]			; copy buffMax vaue to rbx
	cmp 	rax, rbx				; if curr < buffMax
	jl	getChars					; jump to get char
					
; ------------ if (wasEOF) ------------------------

check_EOF:
	cmp 	byte[wasEOF], TRUE			; if wasEOF is true
	je 	finish					; jump to finish, else read file
	
; ------------ read Buff_Size from file -----------
			
	push	rsi					; save arg
	push	rdx					; save arg
	mov 	rax, SYS_read				; call code
	;mov	rdi, rdi				; file descriptor
	mov 	rsi, buffer				; address of where to place char read
	mov 	rdx, BUFF_SIZE				; count of char to read
	syscall
	pop 	rdx					; pop arg
	pop	rsi					; pop arg

	cmp 	rax, 0					; if it is nosuccess
	jl	errorOnRead				; jump to errorOnRead to displays error

; ------------ if chars read == 0 -----------------
	cmp rax, 0					; if chars read = 0
	je finish


; ------------ if chars read < BUFF_SIZE ----------
	cmp rax, BUFF_SIZE				; if # of chars read = buffMax
	je resetCurr					; jump to resetCurr
	mov qword[buffMax], rax				; else buffMax = # of chars actually read
	mov byte[wasEOF], TRUE				; wasEOF = true

resetCurr:				

	mov qword[curr], 0				; curr = 0
	mov r12, 0					; r12 = 0

getChars:
	mov rbx, buffer					; get address of buffer in rbx


; ------------ get each char ----------------------

	mov rax, 0
	mov al, byte[rbx+r12]				; get char (1 byte)
	mov byte[rsi], al				; return char in char arg
	
	inc qword[curr]					; increment global current value	
	;inc r12					; increment index	
	jmp charSuccess					; jump to char success

; ------------ displays error ---------------------
errorOnRead:
	push 	rdi					; save arg
	mov 	rdi, errRead				; copy error msg to rdi for display
	call 	printString				; call printString
	pop 	rdi					; pop arg
	mov 	rax, FALSE				; return false
	jmp 	charDone				; jump to charDone


finish:
	mov rax, FALSE					; return false
	jmp charDone					; jump to charDone

charSuccess:
	mov rax, TRUE					; return true

charDone:
	pop 	r15
	pop 	r14
	pop 	r13
	pop	r12
	pop	rbx
	
	ret


; ***************************************************************
;  Write character to output file.
;	This is poor, but no requirement to buffer here.

; -----
;  HLL Call:
;	status = putCharacter(writeFileDesc, char);

;  Arguments are:
;	write file descriptor (value)		; - rdi
;	character (value)			; - rsi
;  Returns:
;	SUCCESS or NOSUCESS

; -----
;  This routine returns SUCCESS when character has been written
;	and returns NOSUCCESS only if there is an
;	error on write (which would not normally occur).

global	putCharacter
putCharacter:


;	YOUR CODE GOES HERE

	push rbx
	push rdx
	push r12	
	
	mov 	rax, SYS_write			; code for write
	mov 	rdx, 1				; count of char to write
	;mov	rdi, rdi			; get file descriptor
	;mov	rsi, rsi			; address of char to write
	syscall

	cmp 	rax, 0				; compare if it is success
	jl 	err_write			; jump to err_wirte
				
	mov rax, TRUE				; return success
	jmp writeDone				; jump to writeDone

err_write:	

	mov 	rdi, errWrite			; copy err msg to rdi
	call 	printString			; call printString
	mov 	rax, FALSE			; return false

writeDone:
	
	pop r12
	pop rdx
	pop rbx
	ret


; ***************************************************************
;  CS 218 - Ceasar Cypher Decryption Routine.

;  Ceasar Cyphers can be automatically broken by taking
;	advantage of the known letter frequencies for the
;	English language.

;  The frequencies found in the encrypted text are
;	compared against the known frequencies table.  This
;	requires comparing two lists, which is done using the
;	sum of the squares of the differences of the corresponding
;	entries in the list.  By minimizing this sum, you find
;	the best match.  This is called the "least squares fit".
;	As such, based on the letter frequencies, the routine
;	will find the appropriate decryption rotation key.

;  Note, this routine accepts as input the address a "count"
;	array.  The array must have 26 elements, with the first
;	element, or count(0)  being the number of A's, and count(1)
;	being the number of B's found in the original encrypted text.

; -----
;  HLL call:
;	key = cracker(ltrCounts);

; -----
;  Arguments passed
;	populated letter count array, address		- rdi
;  Returns:
;	rotation key					- rax

global	cracker
cracker:


;	YOUR CODE GOES HERE

	push rbx
	push rcx
	push rdx
	push r12
	push r13
	push r14
	push r15

	mov r12, 0				; index for counts sum
	mov rax, 0				; initialize sum of counts

sumLoop:
	mov ebx, dword[rdi+r12*4]
	add eax, ebx
	inc r12
	cmp r12, 26
	jl sumLoop
	mov dword[fSum], eax
	movss xmm5, dword[fSum]			; save sum of counts in xmm5		

	;mov ebx, freq				; get address of knownFrequencies[]
	mov rax, 0
	mov r13, 0				; rotation amount index

keyLoop:
	mov r12, 0				; initialize index
	movss xmm3, dword[ptZero]		; initialize sum

leastSquares:
	movss xmm0, dword[freq+r12*4]		; get knownFrequencies[i] in xmm0
	mov eax, dword[rdi+r12*4]		
	mov dword[tmpFreq], eax
	movss xmm1, dword[tmpFreq]
	divss xmm1, xmm5			; get foundFrequencies[i] in xmm1
	subss xmm0, xmm1			; knownFrequencies[i] - foundFrequency[i]
	movss dword[diff], xmm0				; copy of difference
	mulss xmm0, xmm0			; (knownFrequencies[i] - foundFrequency[i])^2
	addss xmm3, xmm0			; summation
	movss dword[tmp], xmm3				; copy of summation
	
	inc r12					; increment index
	cmp r12, 26				; if index < length
	jl leastSquares					; loop leastSquares

;----
	cmp r13, 0
	je lSquaresInit
	jmp leastSquaresCheck

lSquaresInit:	
	movss dword[total], xmm3
;---

leastSquaresCheck:
	ucomiss xmm3, dword[total]		; if leastSquares >= old leastSquares
	jae nextKey					; keep old leastSquares
	movss dword[total], xmm3		; else update leastSquares
	mov dword[rotate], r13d			; save shift amount/key 

nextKey:
	mov ebx, dword[freq+r13*4]		; get first knownFrequency[]	
	mov r14, 25				; initialize index at last knownFrequency[]
	mov ecx, dword[freq+r14*4]		; save last knownFrequency[]
	mov dword[freq+r14*4], ebx		; place first knownFrequency in the last spot in array

rotateLoop:					; rotate knownFrequencies[i] by one value (32 bits)
	dec r14					; decrement index 
	mov ebx, dword[freq+r14*4]		; save known frequency
	mov dword[freq+r14*4], ecx		; overwrite known frequency with one f/ next index
	mov ecx, ebx				; move saved known frequency to ecx
	cmp r14, 0				; if index > 0
	jg rotateLoop					; loop rotateLoop

	inc r13					; increment rotation index
	cmp r13, 26				; if rotation index < length
	jl keyLoop					; loop keyLoop

keyDone:
	mov eax, dword[rotate]

	pop r15
	pop r14
	pop r13
	pop r12
	pop rdx
	pop rcx
	pop rbx
	
	ret

; ***************************************************************
;  Decrypt the characters in the file.

;  Basic loop will:
;	get a character from input file (get_chr)
;	if letter, decrypt character (i.e., subtract key)
;	write decrypted character to output file

;  HLL Call:
;	status = decrypt(key, readFile, writeFile);

; -----
;  Arguments:
;	key, value				- rdi
;	input file descriptor, value		- rsi
;	output file descriptor, value		- rdx

global decrypt
decrypt:


;	YOUR CODE GOES HERE

	push rbx
	push r12
	push r13

	mov r13, "A"	
	mov rbx, 0				; initialize rbx

decryptLoop:

; ------------- Read Character ----------------

	push rdi				; save key value arg through call
	push rsi				; save input file descriptor arg through call
	mov rdi, rsi				; move file descriptor into first arg
	mov rsi, charr				; move address of charr into second arg
	call getCharacter
	pop rsi					; return saved args 
	pop rdi

	cmp rax, FALSE				; if char not returned
	je decryptDone					; jump to decryptDone

; ------------- Check Char Cases --------------

	mov bl, byte[charr]			; get char into bl
	cmp bl, "a"
	jg checkZ
	jmp decryptChar
checkZ:
	cmp bl, "z"
	jl forcUpper
	jmp decryptChar

forcUpper:
	sub bl, 32				; subtract 32 from lowercase char to make uppercase


; ------------- Decrypt Character -------------	
decryptChar:
	sub rbx, rdi				; subtract key from char
	cmp bl, 65				; if subtracted char >= 65 "A" (not negative)
	jge writeChar					; writeChar to file
	
	sub bl, 65
	add bl, 91				; else add one ascii higher than "Z" to char

; ------------- Write Character ---------------

writeChar:
	mov byte[charr], bl			; save char into charr variable

	push rdi				; save key value arg through call
	push rsi				; save input file descriptor through call
	mov rdi, rdx				; move file descriptor into first arg
	mov rsi, charr				; move address of char into second arg
	call putCharacter
	pop rsi					; return saved args
	pop rdi

	cmp rax, FALSE				; if char not written
	je decryptDone					; jump to decryptDone

	jmp decryptLoop				; else loop decryptLoop

decryptDone:
	cmp byte[wasEOF], TRUE			; if end of file detected
	mov rax, TRUE					; return success
						; else return false (file read error)
	pop r13
	pop r12
	pop rbx

	ret

; ***************************************************************
;  Reset read file to beginning.
;	must also re-set some buffer variables...

; -----
;  Arguments
;	input file descriptor

;  Return
;	nothing
;	but, file is reset to beginning

global	resetRead
resetRead:

	mov	byte [wasEOF], FALSE
	mov	qword [curr], BUFF_SIZE
	mov	qword [buffMax], BUFF_SIZE

	mov	rax, SYS_lseek
	mov	rdi, rdi
	mov	rsi, 0
	mov	rdx, 0
	syscall

	ret

; ***************************************************************
;  Generic function to display a string to the screen.
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

; ***************************************************************

