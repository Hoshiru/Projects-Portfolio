#  CS 218, MIPS Assignment #3
#  MIPS assembly language main program and procedures:

#  * MIPS assembly language void function, prtHeaders() to 
#    display some headers as per assignment format example.

#  * MIPS assembly language void function, calcTotalAreas(), 
#    to calculate the toal area for each square pyramid
#    in a series of square pyramids.

#  * MIPS assembly language void function, countSort(), to sort
#    the areas array (small to large) using the count sort
#    algorithm.

#  * MIPS assembly langauge, value returning function, median(),
#    to find the statistical median of an array.

#  * MIPS assembly langauge, value returning function, estMedian(),
#    to find the estimated median of an array.

#  * MIPS assembly language void function, totalAreasStats(),
#    that will find the minimum, maximum, estimated median, median,
#    percentage difference (between the median and estimated medain),
#    sum, and float average of the total areas array.  The function
#    must call the median(), and estMedian() functions.
#    Additionally, the routine must call the countSort() function.
#    The estimated median must be determine before the sort.
#    The minimum, maximum, and statistical median must be
#    determined after the sort.

#  * MIPS assembly language function, printAreas(), to
#    display the areas array statistical information:
#    sum, minimum, maximum, median, integer average, and
#    float average in the format shown in the example.
#    The numbers should be printed 8 per line (see example).


#####################################################################
#  data segment

.data

# -----
#  Data declarations for main.

bases1:		.word	 19,  17,  15,  13,  11,  19,  17,  15,  13,  11
		.word	 12,  14,  16,  18,  10,  29,  27,  25,  23,  21
		.word	 29,  27,  25,  23,  21,  22,  24,  26,  28,  20
slants1:	.word	 34,  32,  31,  35,  34,  33,  32,  37,  38,  39
		.word	 32,  30,  36,  38,  30,  44,  42,  41,  45,  44
		.word	 43,  42,  47,  48,  49,  42,  40,  46,  48,  40
totalAreas1:	.space	120
len1:		.word	30
min1:		.word	0
max1:		.word	0
med1:		.word	0
estMed1:	.word	0
pctDiff1:	.float	0.0
sum1:		.word	0
fAve1:		.float	0.0

bases2:		.word	 12,  11,  16,  17,  15,  10,  11,  13,  12,  15
		.word	 12,  13,  12,  19,  14,  11,  11,  18,  16,  17
		.word	 13,  15,  11,  19,  18,  19,  12,  14,  10,  11
		.word	 10,  14,  16,  17,  14,  15,  16,  19,  18,  12
		.word	 11,  13,  14,  16,  10,  16,  15,  17,  10,  16
		.word	 14,  12,  14,  16,  17,  14,  16,  10,  16,  13
		.word	 12,  13,  12,  12,  14,  11,  11,  18,  16,  17
		.word	 13,  15,  11,  19,  18,  19,  12,  14,  10,  11
		.word	 10,  14,  16,  17,  14,  15,  16,  19,  18,  12
		.word	 11,  13,  14,  16,  10,  16,  15,  17,  10,  16
		.word	 12,  15,  17,  13,  17,  17,  17,  19,  18,  14
		.word	 10,  11,  13,  12,  15,  10,  11,  12,  12,  12
		.word	 12,  11,  16,  17,  15,  11,  12,  13,  14,  15
		.word	 14,  12,  14,  16,  17,  14,  16,  10,  16,  13
		.word	 12,  15,  17,  12,  17,  17,  17,  19,  18
slants2:	.word	 45,  55,  43,  54,  68,  59,  42,  56,  49,  41
		.word	 55,  65,  53,  64,  18,  69,  52,  66,  59,  51
		.word	 57,  51,  67,  51,  67,  57,  57,  61,  61,  59
		.word	 52,  59,  55,  59,  53,  55,  51,  52,  54,  59
		.word	 56,  52,  52,  51,  56,  60,  64,  58,  68,  62
		.word	 67,  57,  69,  54,  53,  54,  55,  56,  55,  54
		.word	 61,  63,  56,  69,  61,  52,  60,  68,  51,  59
		.word	 47,  41,  57,  41,  57,  47,  47,  51,  51,  49
		.word	 42,  49,  45,  49,  43,  45,  41,  42,  44,  49
		.word	 46,  42,  42,  41,  46,  50,  54,  48,  58,  52
		.word	 57,  47,  59,  44,  43,  44,  45,  46,  45,  44
		.word	 51,  53,  46,  59,  51,  42,  50,  58,  41,  49
		.word	 59,  44,  47,  49,  52,  54,  46,  48,  52,  53
		.word	 42,  51,  56,  57,  46,  52,  61,  66,  67,  56
		.word	 69,  64,  67,  69,  62,  64,  56,  68,  62
totalAreas2:	.space	596
len2:		.word	149
min2:		.word	0
max2:		.word	0
med2:		.word	0
estMed2:	.word	0
pctDiff2:	.float	0.0
sum2:		.word	0
fAve2:		.float	0.0

bases3:		.word	 11,  18,  15,  13,  12,  10,  18,  11,  14,  12
		.word	 15,  12,  16,  12,  13,  19,  16,  12,  18,  11
		.word	 12,  15,  16,  17,  15,  14,  18,  10,  16,  13
		.word	 13,  12,  11,  11,  11,  13,  12,  16,  18,  13
		.word	 12,  19,  15,  19,  11,  15,  19,  12,  14,  19
		.word	 10,  14,  16,  17,  14,  17,  16,  19,  18,  12
		.word	 11,  13,  16,  19,  11,  12,  14,  18,  11,  15
		.word	 19,  14,  19,  12,  17,  14,  16,  11,  12,  13
		.word	 11,  13,  14,  16,  10,  16,  15,  17,  10,  16
		.word	 11,  18,  15,  13,  12,  10,  18,  11,  14,  12
		.word	 15,  12,  16,  12,  13,  19,  16,  12,  18,  11
		.word	 12,  15,  16,  17,  15,  14,  19,  10,  16,  13
		.word	 13,  12,  11,  11,  11,  14,  12,  16,  18,  19
		.word	 12,  19,  15,  19,  14,  15,  19,  12,  14,  19
		.word	 10,  14,  16,  17,  14,  15,  16,  19,  18,  12
		.word	 11,  13,  16,  19,  11,  12,  14,  18,  11,  15
		.word	 19,  14,  19,  12,  17,  14,  16,  11,  12,  13
		.word	 11,  13,  14,  16,  11,  16,  15,  17,  10,  16
slants3:	.word	 43,  42,  41,  41,  41,  44,  42,  46,  58,  43
		.word	 42,  49,  45,  49,  41,  55,  49,  42,  44,  49
		.word	 40,  44,  46,  57,  44,  35,  46,  29,  48,  42
		.word	 41,  43,  46,  49,  51,  52,  54,  58,  61,  65
		.word	 29,  14,  27,  19,  52,  41,  44,  56,  42,  33
		.word	 41,  53,  54,  46,  40,  56,  75,  27,  50,  46
		.word	 54,  55,  45,  62,  52,  41,  42,  56,  56,  43
		.word	 28,  59,  51,  42,  53,  41,  16,  51,  49,  56
		.word	 46,  19,  49,  37,  46,  54,  54,  56,  64,  42
		.word	 53,  52,  51,  51,  51,  54,  52,  56,  18,  53
		.word	 52,  59,  55,  59,  51,  25,  59,  52,  54,  59
		.word	 50,  54,  56,  17,  54,  45,  56,  39,  58,  52
		.word	 51,  53,  56,  59,  11,  22,  14,  18,  11,  25
		.word	 29,  24,  37,  09,  22,  51,  54,  26,  52,  43
		.word	 51,  23,  24,  56,  50,  16,  15,  17,  60,  56
		.word	 14,  15,  55,  12,  22,  21,  23,  36,  26,  53
		.word	 18,  19,  11,  52,  13,  23,  26,  21,  59,  26
		.word	 56,  39,  59,  47,  16,  14,  24,  16,  14,  52
totalAreas3:	.space	720
len3:		.word	180
min3:		.word	0
max3:		.word	0
med3:		.word	0
estMed3:	.word	0
pctDiff3:	.float	0.0
sum3:		.word	0
fAve3:		.float	0.0

bases4:		.word	 23,  12,  26,  16,  20,  16,  24,  15,  25,  16
		.word	 11,  27,  10,  27,  14,  25,  11,  27,  11,  29
		.word	 23,  12,  26,  16,  20,  16,  24,  16,  25,  12
		.word	 11,  23,  13,  20,  15,  29,  15,  28,  13,  25
		.word	 24,  11,  22,  13,  26,  14,  26,  13,  26,  13
		.word	 17,  24,  10,  22,  14,  25,  16,  22,  18,  22
		.word	 21,  13,  23,  10,  27,  11,  25,  18,  23,  15
		.word	 17,  26,  12,  27,  17,  27,  19,  27,  15,  24
		.word	 23,  14,  22,  13,  26,  14,  26,  12,  26,  13
		.word	 14,  23,  12,  23,  10,  21,  12,  23,  19,  22
		.word	 21,  17,  20,  17,  24,  15,  21,  17,  21,  19
		.word	 13,  22,  16,  26,  10,  26,  14,  26,  15,  22
		.word	 21,  13,  23,  10,  25,  19,  25,  18,  23,  15
		.word	 14,  21,  12,  23,  16,  24,  16,  23,  16,  23
		.word	 27,  14,  20,  12,  24,  15,  26,  12,  28,  12
		.word	 15,  26,  12,  27,  17,  27,  19,  27,  15,  24
		.word	 22,  13,  26,  10,  25,  12,  24,  18,  23,  12
		.word	 11,  22,  11,  23,  16,  29,  14,  22,  15,  21
		.word	 24,  14,  24,  13,  26,  14,  26,  12,  26,  13
		.word	 19,  24,  14,  24,  17,  23,  19,  21,  15,  26
		.word	 23,  12,  26,  16,  20,  16,  24,  15,  25,  16
		.word	 11,  23,  13,  20,  17,  21,  15,  28,  13,  25
		.word	 27,  16,  22,  17,  27,  17,  24,  17,  25,  14
		.word	 13,  24,  12,  23,  16,  24,  16,  22,  16,  23
		.word	 24,  19,  22,  13,  20,  11,  22,  19,  23,  12
		.word	 15,  26,  12,  27,  17,  27,  19,  27,  15,  24
		.word	 23,  13,  26,  10,  25,  12,  24,  18,  23,  12
		.word	 11,  22,  11,  23,  16,  24,  14,  22,  15,  21
		.word	 24,  14,  22,  13,  26,  14,  26,  12,  26,  13
		.word	 19,  24,  14,  24,  17,  23,  19,  21,  15
slants4:	.word	 25,  44,  43,  37,  33,  34,  34,  36,  14,  42
		.word	 16,  32,  32,  31,  46,  30,  34,  38,  21,  12
		.word	 32,  25,  37,  32,  37,  47,  27,  19,  32,  14
		.word	 39,  36,  22,  31,  27,  27,  29,  27,  25,  34
		.word	 34,  41,  42,  33,  16,  34,  46,  33,  36,  13
		.word	 31,  38,  37,  43,  28,  32,  31,  30,  35,  30
		.word	 37,  44,  30,  12,  34,  35,  36,  32,  38,  12
		.word	 33,  32,  46,  26,  31,  36,  14,  35,  15,  36
		.word	 37,  33,  33,  40,  35,  31,  34,  38,  33,  32
		.word	 34,  32,  34,  26,  27,  34,  36,  30,  36,  33
		.word	 22,  31,  36,  17,  20,  30,  31,  33,  32,  45
		.word	 37,  11,  19,  31,  33,  34,  35,  36,  25,  14
		.word	 19,  36,  22,  27,  37,  27,  39,  27,  15,  14
		.word	 21,  35,  35,  32,  31,  35,  30,  39,  32,  34
		.word	 11,  32,  31,  32,  31,  39,  34,  32,  35,  31
		.word	 35,  34,  33,  37,  23,  24,  14,  36,  14,  32
		.word	 26,  22,  22,  31,  36,  10,  24,  18,  18,  32
		.word	 32,  35,  37,  22,  17,  37,  17,  29,  28,  34
		.word	 34,  12,  14,  16,  37,  14,  16,  20,  16,  13
		.word	 22,  31,  36,  27,  34,  20,  21,  13,  32,  35
		.word	 27,  27,  39,  21,  23,  13,  25,  26,  25,  34
		.word	 39,  36,  22,  11,  36,  37,  37,  33,  35,  14
		.word	 24,  31,  32,  23,  26,  24,  26,  23,  16,  23
		.word	 11,  38,  17,  33,  18,  12,  11,  20,  25,  10
		.word	 17,  34,  20,  12,  14,  35,  36,  32,  18,  32
		.word	 13,  32,  36,  26,  11,  26,  24,  35,  35,  26
		.word	 17,  23,  33,  30,  25,  11,  14,  18,  23,  12
		.word	 29,  26,  32,  37,  37,  27,  39,  17,  25,  14
		.word	 21,  35,  25,  22,  17,  25,  10,  29,  12,  20
		.word	 31,  22,  11,  12,  21,  19,  24,  12,  35
len4:		.word	299
totalAreas4:	.space	1196
min4:		.word	0
max4:		.word	0
med4:		.word	0
estMed4:	.word	0
pctDiff4:	.float	0.0
sum4:		.word	0
fAve4:		.float	0.0

bases5:		.word	 19,  24,  17,  29,  12,  24,  16,  22,  12,  23
		.word	 20,  14,  26,  17,  24,  15,  26,  19,  28,  12
		.word	 11,  20,  11,  22,  19,  21,  11,  24,  12,  20
		.word	 23,  12,  22,  19,  20,  11,  21,  15,  28,  11
		.word	 12,  24,  15,  27,  11,  28,  13,  26,  16,  23
		.word	 21,  13,  24,  16,  21,  16,  25,  17,  29,  16
		.word	 15,  25,  15,  22,  17,  25,  10,  29,  12,  24
		.word	 20,  11,  21,  19,  20,  15,  21,  14,  28,  13
		.word	 11,  23,  14,  26,  10,  26,  15,  27,  10,  26
		.word	 24,  14,  22,  13,  26,  15,  26,  12,  26,  13
		.word	 14,  22,  17,  26,  17,  20,  16,  20,  16,  23
		.word	 23,  14,  27,  19,  22,  14,  26,  18,  22,  13
		.word	 15,  22,  16,  25,  10,  27,  13,  29,  12,  24
		.word	 26,  12,  22,  11,  26,  10,  24,  18,  24,  12
		.word	 17,  27,  17,  27,  17,  27,  17,  27,  17,  27
		.word	 27,  17,  29,  11,  23,  14,  25,  16,  25,  14
		.word	 14,  22,  14   26,  17,  24,  16,  20,  16,  23
		.word	 22,  15,  27,  12,  27,  17,  27,  19,  28,  13
		.word	 15,  22,  16,  25,  10,  27,  13,  29,  12,  24
		.word	 20,  10,  20,  13,  20,  13,  20,  11,  27,  13
		.word	 13,  22,  15,  22,  14,  21,  11,  23,  19,  29
		.word	 22,  14,  25,  17,  21,  18,  23,  16,  26,  11
		.word	 11,  23,  14,  26,  10,  26,  15,  27,  19,  26
		.word	 24,  11,  29,  11,  19,  11,  25,  11,  29,  11
		.word	 11,  23,  16,  29,  11,  23,  18,  22,  11,  27
		.word	 21,  14,  27,  19,  22,  14,  26,  18,  22,  13
		.word	 10,  21,  16,  27,  14,  25,  16,  29,  18,  22
		.word	 25,  15,  25,  12,  27,  15,  20,  19,  22,  14
		.word	 10,  21,  19,  29,  10,  25,  11,  24,  18,  23
		.word	 21,  13,  23,  16,  25,  16,  25,  17,  21,  16
		.word	 14,  24,  14,  23,  16,  24,  16,  22,  16,  23
		.word	 24,  12,  27,  16,  27,  14,  26,  10,  26,  13
		.word	 19,  24,  17,  29,  12,  24,  16,  28,  12,  23
		.word	 25,  12,  26,  15,  20,  17,  23,  19,  22,  14
		.word	 16,  22,  12,  21,  16,  20,  14,  28,  18,  22
		.word	 27,  17,  27,  17,  27,  11,  27,  17,  27,  17
		.word	 17,  27,  19,  21,  13,  24,  15,  26,  15,  24
		.word	 24,  12,  24   16,  27,  14,  26,  10,  26,  13
		.word	 12,  25,  17,  22,  17,  27,  17,  20,  18,  23
		.word	 25,  12,  26,  15,  20,  17,  23,  19,  22,  14
		.word	 11,  23,  16,  29,  11,  23,  18,  22,  11,  27
		.word	 21,  12,  21,  13,  25,  12,  21,  14,  23,  17
slants5:	.word	 52,  19,  25,  39,  31,  35,  39,  52,  44,  49
		.word	 23,  23,  13,  10,  05,  39,  23,  38,  23,  25
		.word	 21,  05,  27,  23,  16,  28,  21,  47,  31,  16
		.word	 22,  19,  35,  29,  11,  15,  19,  42,  44,  29
		.word	 51,  53,  16,  59,  21,  42,  34,  38,  31,  15
		.word	 12,  12,  22,  22,  32,  31,  20,  22,  11,  22
		.word	 13,  02,  20,  12,  12,  32,  22,  10,  12,  22
		.word	 10,  75,  37,  02,  17,  17,  37,  19,  28,  24
		.word	 12,  19,  25,  19,  31,  25,  39,  12,  14,  39
		.word	 22,  64,  38,  71,  25,  11,  32,  07,  21,  31
		.word	 12,  15,  57,  52,  57,  47,  27,  59,  18,  14
		.word	 59,  54,  56,  57,  54,  55,  16,  59,  48,  22
		.word	 41,  43,  46,  49,  51,  52,  54,  58,  61,  15
		.word	 59,  53,  54,  56,  40,  56,  15,  07,  55,  26
		.word	 52,  51,  16,  27,  10,  50,  51,  53,  52,  45
		.word	 47,  53,  53,  40,  15,  51,  54,  58,  53,  52
		.word	 31,  53,  54,  56,  40,  56,  25,  27,  10,  26
		.word	 34,  52,  14,  06,  17,  54,  56,  50,  56,  53
		.word	 42,  15,  57,  52,  57,  47,  17,  19,  28,  34
		.word	 19,  51,  59,  51,  49,  51,  09,  21,  29,  41
		.word	 23,  33,  53,  50,  25,  53,  43,  48,  53,  55
		.word	 21,  35,  57,  13,  26,  18,  21,  27,  34,  16
		.word	 32,  39,  15,  29,  50,  55,  59,  42,  14,  49
		.word	 41,  43,  46,  49,  31,  51,  54,  58,  11,  65
		.word	 50,  52,  52,  52,  52,  51,  22,  51,  26,  22
		.word	 22,  52,  52,  52,  33,  50,  12,  12,  52,  52
		.word	 22,  15,  57,  52,  57,  47,  17,  59,  18,  34
		.word	 52,  39,  55,  59,  51,  55,  59,  52,  54,  59
		.word	 34,  54,  58,  11,  15,  21,  32,  17,  11,  21
		.word	 41,  43,  46,  29,  51,  52,  54,  58,  11,  25
		.word	 12,  39,  15,  19,  11,  35,  39,  32,  54,  59
		.word	 21,  35,  37,  22,  17,  57,  27,  29,  28,  24
		.word	 19,  14,  16,  17,  24,  25,  36,  09,  18,  22
		.word	 51,  53,  31,  29,  21,  12,  54,  18,  11,  35
		.word	 19,  13,  24,  16,  20,  16,  25,  37,  25,  36
		.word	 12,  31,  26,  27,  30,  10,  11,  33,  10,  25
		.word	 52,  33,  13,  10,  25,  21,  24,  28,  23,  12
		.word	 11,  23,  34,  26,  10,  16,  35,  17,  20,  16
		.word	 44,  12,  14,  26,  17,  34,  16,  20,  16,  13
		.word	 12,  25,  17,  12,  17,  17,  37,  59,  38,  14
		.word	 29,  31,  19,  11,  29,  21,  49,  21,  29,  11
		.word	 51,  33,  26,  59,  21,  12,  24,  18,  11,  25
totalAreas5:	.space	1680
len5:		.word	420
min5:		.word	0
max5:		.word	0
med5:		.word	0
estMed5:	.word	0
pctDiff5:	.float	0.0
sum5:		.word	0
fAve5:		.float	0.0

# -----
#  Variables for main.

asstHeader:	.ascii	"\nMIPS Assignment #3\n"
		.asciiz	"Square Pyramid Total Areas Program\n\n"

# -----
#  Variables/constants for prtHeaders() function.

hdrTitle:	.ascii	"\n**********************************"
		.ascii	"**********************************"
		.asciiz	"\nSquare Pyramid Data Set #"
hdrLength:	.asciiz	"\nLength: "

hdrStats:	.asciiz	"\nTotal Areas Stats: \n"
hdrAreas:	.asciiz	"\n\nTotal Areas Values: \n"

# -----
#  Variables for totalAreasStats (if any)

fOneHundred:	.float	100.0

# -----
#  Variables/constants for countSort() function.

countArr:	.space	400000
LIMIT		= 100000

# -----
#  Variables/constants for printResults() function.

spc:		.asciiz	"     "
newLine:	.asciiz	"\n"

str1:		.asciiz	"   min      = "
str2:		.asciiz	"\n   max      = "
str3:		.asciiz	"\n   med      = "
str4:		.asciiz	"\n   est med  = "
str5:		.asciiz	"\n   pct diff = %"
str6:		.asciiz	"\n   sum      = "
str7:		.asciiz	"\n   flt ave  = "


#####################################################################
#  text/code segment

# -----
#  Basic flow:
#	for each data set:
#	  * display headers
#	  * calculate total areas, includes sort
#	  * calculate total area stats (min, max, med, estMed, sum, and fAve)
#	  * display results

.text
.globl	main
.ent main
main:

# --------------------------------------------------------
#  Display Program Header.

	la	$a0, asstHeader
	li	$v0, 4
	syscall					# print header
	li	$s0, 1				# counter, data set number

# --------------------------------------------------------
#  Data Set #1

	move	$a0, $s0
	lw	$a1, len1
	jal	prtHeaders
	add	$s0, $s0, 1

#  Square pyramid total areas calculation function
#  HLL Call:
#	calcTotalAreas(totalAreas, len, bases, slants);

	la	$a0, totalAreas1
	lw	$a1, len1
	la	$a2, bases1
	la	$a3, slants1
	jal	calcTotalAreas

#  Calculate total areas stats.
#	Note, function also calls the median() and
#	estMedian() functions.
#  HLL Call:
#	totalAreasStats(totalAreas, len, min, max, med, estMed,
#						pctDiff, sum, fAve);

	la	$a0, totalAreas1		# arg 1
	lw	$a1, len1			# arg 2
	la	$a2, min1			# arg 3
	la	$a3, max1			# arg 4
	subu	$sp, $sp, 20
	la	$t0, med1
	sw	$t0, ($sp)			# arg 5, on stack
	la	$t0, estMed1
	sw	$t0, 4($sp)			# arg 6, on stack
	la	$t0, pctDiff1
	sw	$t0, 8($sp)			# arg 7, on stack
	la	$t0, sum1
	sw	$t0, 12($sp)			# arg 7, on stack
	la	$t6, fAve1
	sw	$t6, 16($sp)			# arg 8, on stack
	jal	totalAreasStats
	addu	$sp, $sp, 20			# clear stack

#  Show final total areas array stats.
#  HLL Call:
#	printResults(totalAreas, len, min, max, med, estMed,
#						pctDiff, sum, fAve);

	la	$a0, totalAreas1		# arg 1
	lw	$a1, len1			# arg 2
	lw	$a2, min1			# arg 3
	lw	$a3, max1			# arg 4
	subu	$sp, $sp, 20
	lw	$t0, med1
	sw	$t0, ($sp)			# arg 5, on stack
	lw	$t0, estMed1
	sw	$t0, 4($sp)			# arg 6, on stack
	lw	$t0, pctDiff1
	sw	$t0, 8($sp)			# arg 7, on stack
	lw	$t0, sum1
	sw	$t0, 12($sp)			# arg 7, on stack
	l.s	$f6, fAve1
	s.s	$f6, 16($sp)			# arg 8, on stack
	jal	printResults
	addu	$sp, $sp, 20			# clear stack

# --------------------------------------------------------
#  Data Set #2

	move	$a0, $s0
	lw	$a1, len2
	jal	prtHeaders
	add	$s0, $s0, 1

#  Square pyramid total areas calculation function
#  HLL Call:
#	calcTotalAreas(totalAreas, len, bases, slants);

	la	$a0, totalAreas2
	lw	$a1, len2
	la	$a2, bases2
	la	$a3, slants2
	jal	calcTotalAreas

#  Calculate total areas stats.
#	Note, function also calls the median() and
#	estMedian() functions.
#  HLL Call:
#	totalAreasStats(totalAreas, len, min, max, med, estMed,
#						pctDiff, sum, fAve);

	la	$a0, totalAreas2		# arg 1
	lw	$a1, len2			# arg 2
	la	$a2, min2			# arg 3
	la	$a3, max2			# arg 4
	subu	$sp, $sp, 20
	la	$t0, med2
	sw	$t0, ($sp)			# arg 5, on stack
	la	$t0, estMed2
	sw	$t0, 4($sp)			# arg 6, on stack
	la	$t0, pctDiff2
	sw	$t0, 8($sp)			# arg 7, on stack
	la	$t0, sum2
	sw	$t0, 12($sp)			# arg 7, on stack
	la	$t6, fAve2
	sw	$t6, 16($sp)			# arg 8, on stack
	jal	totalAreasStats
	addu	$sp, $sp, 20			# clear stack

#  Show final total areas array stats.
#  HLL Call:
#	printResults(totalAreas, len, min, max, med, estMed,
#						pctDiff, sum, fAve);

	la	$a0, totalAreas2		# arg 1
	lw	$a1, len2			# arg 2
	lw	$a2, min2			# arg 3
	lw	$a3, max2			# arg 4
	subu	$sp, $sp, 20
	lw	$t0, med2
	sw	$t0, ($sp)			# arg 5, on stack
	lw	$t0, estMed2
	sw	$t0, 4($sp)			# arg 6, on stack
	lw	$t0, pctDiff2
	sw	$t0, 8($sp)			# arg 7, on stack
	lw	$t0, sum2
	sw	$t0, 12($sp)			# arg 7, on stack
	l.s	$f6, fAve2
	s.s	$f6, 16($sp)			# arg 8, on stack
	jal	printResults
	addu	$sp, $sp, 20			# clear stack

# --------------------------------------------------------
#  Data Set #3

	move	$a0, $s0
	lw	$a1, len3
	jal	prtHeaders
	add	$s0, $s0, 1

#  Square pyramid total areas calculation function
#  HLL Call:
#	calcTotalAreas(totalAreas, len, bases, slants);

	la	$a0, totalAreas3
	lw	$a1, len3
	la	$a2, bases3
	la	$a3, slants3
	jal	calcTotalAreas

#  Calculate total areas stats.
#	Note, function also calls the median() and
#	estMedian() functions.
#  HLL Call:
#	totalAreasStats(totalAreas, len, min, max, med, estMed,
#						pctDiff, sum, fAve);

	la	$a0, totalAreas3		# arg 1
	lw	$a1, len3			# arg 2
	la	$a2, min3			# arg 3
	la	$a3, max3			# arg 4
	subu	$sp, $sp, 20
	la	$t0, med3
	sw	$t0, ($sp)			# arg 5, on stack
	la	$t0, estMed3
	sw	$t0, 4($sp)			# arg 6, on stack
	la	$t0, pctDiff3
	sw	$t0, 8($sp)			# arg 7, on stack
	la	$t0, sum3
	sw	$t0, 12($sp)			# arg 7, on stack
	la	$t6, fAve3
	sw	$t6, 16($sp)			# arg 8, on stack
	jal	totalAreasStats
	addu	$sp, $sp, 20			# clear stack

#  Show final total areas array stats.
#  HLL Call:
#	printResults(totalAreas, len, min, max, med, estMed,
#						pctDiff, sum, fAve);

	la	$a0, totalAreas3		# arg 1
	lw	$a1, len3			# arg 2
	lw	$a2, min3			# arg 3
	lw	$a3, max3			# arg 4
	subu	$sp, $sp, 20
	lw	$t0, med3
	sw	$t0, ($sp)			# arg 5, on stack
	lw	$t0, estMed3
	sw	$t0, 4($sp)			# arg 6, on stack
	lw	$t0, pctDiff3
	sw	$t0, 8($sp)			# arg 7, on stack
	lw	$t0, sum3
	sw	$t0, 12($sp)			# arg 7, on stack
	l.s	$f6, fAve3
	s.s	$f6, 16($sp)			# arg 8, on stack
	jal	printResults
	addu	$sp, $sp, 20			# clear stack

# --------------------------------------------------------
#  Data Set #4

	move	$a0, $s0
	lw	$a1, len4
	jal	prtHeaders
	add	$s0, $s0, 1

#  Square pyramid total areas calculation function
#  HLL Call:
#	calcTotalAreas(totalAreas, len, bases, slants);

	la	$a0, totalAreas4
	lw	$a1, len4
	la	$a2, bases4
	la	$a3, slants4
	jal	calcTotalAreas

#  Calculate total areas stats.
#	Note, function also calls the median() and
#	estMedian() functions.
#  HLL Call:
#	totalAreasStats(totalAreas, len, min, max, med, estMed,
#						pctDiff, sum, fAve);

	la	$a0, totalAreas4		# arg 1
	lw	$a1, len4			# arg 2
	la	$a2, min4			# arg 3
	la	$a3, max4			# arg 4
	subu	$sp, $sp, 20
	la	$t0, med4
	sw	$t0, ($sp)			# arg 5, on stack
	la	$t0, estMed4
	sw	$t0, 4($sp)			# arg 6, on stack
	la	$t0, pctDiff4
	sw	$t0, 8($sp)			# arg 7, on stack
	la	$t0, sum4
	sw	$t0, 12($sp)			# arg 7, on stack
	la	$t6, fAve4
	sw	$t6, 16($sp)			# arg 8, on stack
	jal	totalAreasStats
	addu	$sp, $sp, 20			# clear stack

#  Show final total areas array stats.
#  HLL Call:
#	printResults(totalAreas, len, min, max, med, estMed,
#						pctDiff, sum, fAve);

	la	$a0, totalAreas4		# arg 1
	lw	$a1, len4			# arg 2
	lw	$a2, min4			# arg 3
	lw	$a3, max4			# arg 4
	subu	$sp, $sp, 20
	lw	$t0, med4
	sw	$t0, ($sp)			# arg 5, on stack
	lw	$t0, estMed4
	sw	$t0, 4($sp)			# arg 6, on stack
	lw	$t0, pctDiff4
	sw	$t0, 8($sp)			# arg 7, on stack
	lw	$t0, sum4
	sw	$t0, 12($sp)			# arg 7, on stack
	l.s	$f6, fAve4
	s.s	$f6, 16($sp)			# arg 8, on stack
	jal	printResults
	addu	$sp, $sp, 20			# clear stack

# --------------------------------------------------------
#  Data Set #5

	move	$a0, $s0
	lw	$a1, len5
	jal	prtHeaders
	add	$s0, $s0, 1

#  Square pyramid total areas calculation function
#  HLL Call:
#	calcTotalAreas(totalAreas, len, bases, slants);

	la	$a0, totalAreas5
	lw	$a1, len5
	la	$a2, bases5
	la	$a3, slants5
	jal	calcTotalAreas

#  Calculate total areas stats.
#	Note, function also calls the median() and
#	estMedian() functions.
#  HLL Call:
#	totalAreasStats(totalAreas, len, min, max, med, estMed,
#						pctDiff, sum, fAve);

	la	$a0, totalAreas5		# arg 1
	lw	$a1, len5			# arg 2
	la	$a2, min5			# arg 3
	la	$a3, max5			# arg 4
	subu	$sp, $sp, 20
	la	$t0, med5
	sw	$t0, ($sp)			# arg 5, on stack
	la	$t0, estMed5
	sw	$t0, 4($sp)			# arg 6, on stack
	la	$t0, pctDiff5
	sw	$t0, 8($sp)			# arg 7, on stack
	la	$t0, sum5
	sw	$t0, 12($sp)			# arg 7, on stack
	la	$t6, fAve5
	sw	$t6, 16($sp)			# arg 8, on stack
	jal	totalAreasStats
	addu	$sp, $sp, 20			# clear stack

#  Show final total areas array stats.
#  HLL Call:
#	printResults(totalAreas, len, min, max, med, estMed,
#						pctDiff, sum, fAve);

	la	$a0, totalAreas5		# arg 1
	lw	$a1, len5			# arg 2
	lw	$a2, min5			# arg 3
	lw	$a3, max5			# arg 4
	subu	$sp, $sp, 20
	lw	$t0, med5
	sw	$t0, ($sp)			# arg 5, on stack
	lw	$t0, estMed5
	sw	$t0, 4($sp)			# arg 6, on stack
	lw	$t0, pctDiff5
	sw	$t0, 8($sp)			# arg 7, on stack
	lw	$t0, sum5
	sw	$t0, 12($sp)			# arg 7, on stack
	l.s	$f6, fAve5
	s.s	$f6, 16($sp)			# arg 8, on stack
	jal	printResults
	addu	$sp, $sp, 20			# clear stack

# --------------------------------------------------------
#  Done, terminate program.

	li	$v0, 10
	syscall					# au revoir...
.end

#####################################################################
#  Display headers.
#	Simple utility function to display formatted hgeaders
#	for each data set.

.globl	prtHeaders
.ent	prtHeaders
prtHeaders:
	sub	$sp, $sp, 8
	sw	$s0, ($sp)
	sw	$s1, 4($sp)

	move	$s0, $a0
	move	$s1, $a1

	la	$a0, hdrTitle
	li	$v0, 4
	syscall

	move	$a0, $s0
	li	$v0, 1
	syscall

	la	$a0, hdrLength
	li	$v0, 4
	syscall

	move	$a0, $s1
	li	$v0, 1
	syscall

	lw	$s0, ($sp)
	lw	$s1, 4($sp)
	add	$sp, $sp, 8

	jr	$ra
.end	prtHeaders

#####################################################################
#  MIPS assembly language void function to calculate the
#    total area for each square pyramid in a series of
#    square pyramids.

# -----
#  HLL Call:
#	calcTotalAreas(totalAreas, len, bases, slants)

#    Arguments:
#	$a0	- starting address of the total areas array
#	$a1	- starting address of the length
#	$a2	- starting address of the bases array
#	$a3	- starting address of the slants array

#    Returns:
#	totalAreas[] areas array via the passed address

.globl	calcTotalAreas
calcTotalAreas:


#	YOUR CODE GOES HERE

	move 	$t0, $a0     				# areas
	move 	$t1, $a1					# length
	move 	$t2, $a2					# bases
	move	$t3, $a3					# slants
	
calLp: 
	lw 	$t4, ($t2)						# get bases[i]
	lw		$t5,  ($t3) 					# get slants[i]
	mul 	$t6, $t5, 2  					# 2*slants
	add 	$t6, $t6, $t4					# (2*slants+bases)
	mul 	$t6, $t6, $t4					# bases*(2*slants+bases)
	sw 	$t6, ($t0)        				# store areas
	add 	$t0,$t0, 4						# update areas address 
	add	$t2, $t2, 4 					# update bases address
	add  $t3, $t3, 4						# update slants address
	sub 	$t1, $t1, 1 					# len--
	bgtz	$t1, calLp						# if len > 0( not cal finish), continue
	jr 		$ra								# else return value

	jr	$ra
.end calcTotalAreas

#####################################################################
#  MIPS assembly language void function, countSort(), to sort
#    the areas array (small to large) using the count sort
#    algorithm.

# -----
#  HLL Call:
#	countSort(array, len)

# -----
#  Count Sort Algorithm

#	for  i = 0 to (len-1)
#	    count[list[i]] = count[list[i]] + 1
#	endFor

#	p = 0
#	for  i = 0 to (limit-1) do
#	    if  count[i] <> 0  then
#		for  j = 1 to count[i]
#		    list[p] = i
#		    p = p + 1
#		endFor
#	    endIf
#	endFor

# -----
#    Arguments:
#	$a0 - starting address of the list
#	$a1 - list length

#    Returns:
#	sorted list (via reference)

.globl countSort
.ent countSort
countSort:


#	YOUR CODE GOES HERE

	la $t0, countArr								#; count[] array address
	move $t2, $a0								#  list[] array address
	move $t1, $a1								#; loop counter for countLp
	move $t7, $zero							#; i = 0
	
initLp:
	sw $zero, ($t0)								#; initialize count[i] to 0
	addu $t0, $t0, 4 							# increment count array
	subu $t1, $t1, 1								# decrement loop counter (length)
	bnez $t1, initLp								# if counter > 0, loop initLp
	
	la $t0, countArr								#; refresh count[] array address
	move $t1, $a1								#; loop counter for countLp

countLp:											#; for  i = 0 to (len-1)
	la $t0, countArr								# refresh count array address
	lw $t3, ($t2)									#; get list[i] as index for count
	mul $t3, $t3, 4									#; count[list[i]] = count[list[i]] + 1
	add $t0, $t0, $t3									# index = list[i]*4
	lw $t4, ($t0)											# get count[list[i]] 
	add $t4, $t4, 1										# count[list[i]] = count[list[i]] + 1
	sw $t4, ($t0)											# update count[list[i]]

	addu $t2, $t2, 4 								# increment list[i]
	subu $t1, $t1, 1									# decrement loop counter (length)
	bnez $t1, countLp							# if counter > 0, loop countLp

	la $t0, countArr								# refresh count array address
	move $t2, $a0								# refresh list array address
	li $t4, LIMIT									# get LIMIT / loop counter
	move $t9, $zero							#; p = 0

outLp:												#; for  i = 0 to (limit-1) do
	li $t8, 1											#; j = 1
	lw $t3, ($t0)									#; get count[i] for inLp counter
	bnez $t3, inLp								#; if  count[i] <> 0,  then jump to inLp
	j outLpDone									#; else re-loop

inLp:														#; for  j = 1 to count[i]
	sw $t7, ($t2)											#; list[p] = i
	addu	$t9, $t9, 1										#; p = p + 1
	addu $t2, $t2, 4 										# increment list[p]
	addu $t8, $t8, 1										#; increment j
	ble $t8, $t3, inLp									#; if j <= count[i], loop inLp
	
outLpDone:
	addu $t7, $t7, 1								#; increment i
	addu $t0, $t0, 4 		 					# increment count array 
	subu $t4, $t4, 1 							# decrement counter (LIMIT)
	bnez $t4, outLp								# if counter > 0, loop outLp

	jr	$ra
.end countSort

#####################################################################
#  MIPS assembly langauge value returning function, median(),
#    to find the statistical median of an array.

# -----
#  HLL Call:
#	med = findMedian(array, len)

# -----
#    Arguments:
#	$a0   - integer
#	$a1   - len

#    Returns:
#	$v0   - median

.globl	findMedian
.ent	findMedian
findMedian:


#	YOUR CODE GOES HERE

#---Middle Value
	
	move $t0, $a0						# get address of array
	move $t3, $a1						# get length
	div $t3, $t3, 2						# get middle index of lAreas
	mul $t3, $t3, 4						# address = index*4
	add $t0, $t0, $t3					# lAreas[index*4]
	lw $t7, ($t0)							# get middle value

#---Determine Even/Odd
	move $t3, $a1						# refresh length
	andi $t4, $t3, 1						# check if length of array is odd
	beq $t4, 1, rMedian				# then middle num found

	subu $t0, $t0, 4						# if even, decrement index of array
	lw $t4, ($t0)							# get lower middle number
	add $t7, $t7, $t4					# find integer ave of the two middle values
	div $t7, $t7, 2					
	
rMedian:
	move $v0, $t7						# return median

	jr	$ra
.end	findMedian

#####################################################################
#  * MIPS assembly langauge, value returning function, estMedian(),
#    to find the estimated median of an array.

# -----
#  HLL Call:
#	med = estMedian(array, len)

# -----
#    Arguments:
#	$a0   - integer
#	$a1   - len

#    Returns:
#	$v0   - median

.globl	estMedian
.ent	estMedian
estMedian:


#	YOUR CODE GOES HERE

#---Middle Value
	
	move $t3, $a1						# get length
	move $t0, $a0						# get address of array
	lw $t1, ($t0)							# get first value of array
	mul $t3, $t3, 4						# address = index*4
	sub $t3, $t3, 4						# last value address = (index*4) - 4
	add $t0, $t0, $t3					# get address of last value of array
	lw $t2, ($t0)							# get last value of array
	add $t7, $t7, $t1					# est med = (first+last+mid)/3
	add $t7, $t7, $t2
	
	move $t3, $a1						# refresh length
	move $t0, $a0						# get address of array
	div $t3, $t3, 2						# get middle index of array
	mul $t3, $t3, 4						# address = index*4
	add $t0, $t0, $t3					# volumes[index*4]
	lw $t4, ($t0)							# get middle value
	add $t7, $t7, $t4					# est med = (first+last+mid)/3
						

#---Determine Even/Odd
	move $t3, $a1						# refresh length
	andi $t4, $t3, 1						# check if length of array is odd
	beq $t4, 1, wasOdd				# then middle num found

	subu $t0, $t0, 4						# if even, decrement index of array
	lw $t4, ($t0)							# get lower middle number
	add $t7, $t7, $t4					# est med = (first+last+both mids)/4
	div $t7, $t7, 4			
	j Middle

wasOdd:
	div $t7, $t7, 3
	
Middle:
	move $v0, $t7						# return mid

	jr	$ra
.end	estMedian

#####################################################################
#  MIPS assembly language void function, totalAreasStats(),
#    that will find the minimum, maximum, estimated median, median,
#    percentage difference (between the median and estimated medain),
#    sum, and float average of the total areas array.  The function
#    must call the median(), and estMedian() functions.
#    Additionally, the routine must call the countSort() function.
#    The estimated median must be determine before the sort.
#    The minimum, maximum, and statistical median must be
#    determined after the sort.

# -----
#  HLL Call:
#	totalAreasStats(areas, len, min, max, med, estMed,
#						pctDiff, sum, fAve)

# -----
#    Arguments:
#	$a0	- starting address of the areas array
#	$a1	- list length
#	$a2	- addr of min
#	$a3	- addr of max
#	($fp)	- addr of med
#	4($fp)	- addr of estMed
#	8($fp)  - addr of pctDiff
#	12($fp)	- addr of sum
#	16($fp)	- addr of fAve

#    Returns (via reference):
#	min, max, med, estMed, sum, fAve

.globl totalAreasStats
.ent totalAreasStats
totalAreasStats:


#	YOUR CODE GOES HERE

	sub $sp, $sp, 24					#reserve registers
			
	sw  	$s0, 0($sp)
	sw  	$s1, 4($sp)
	sw  	$s2, 8($sp)
	sw  	$s3, 12($sp)
	sw  	$fp, 16($sp)
	sw	$ra, 20($sp)
	add 	$fp, $sp, 24					# set frame pointer
	
#----- Aquire Addresses	
	move 	$s0, $a0					# get arr address
	move 	$s1, $a1					# len
	move 	$s2, $a2					# min
	move 	$s3, $a3					# max
	lw			$t4, ($fp)					# med
	lw 		$t5, 4($fp)					# estMed
	lw 		$t6, 8($fp)					# pctDiff
	lw	 		$t7, 12($fp)				# sum
	lw			$t8, 16($fp)				# fAve

# ---------- Find Estimated Median --------
	move $a0, $a0						# pass arr adress
	move $a1, $a1						# pass len
	jal estMedian							# call function
	lw $t5, 4($fp)							# load med
	sw $v0, ($t5)							# return med	
	
# ----- Call Countsort
	move 	$a0, $s0					# pass address arr
	move  	$a1, $s1					# pass len 
	jal countSort							#call function
	
# -------------------- Calculate Statistics ---------------------
	move $s0, $a0						# get arr adress
	lw  $t0, ($s0)							# get arr[0]
	sw $t0, ($s2) 						# store min
	
	sub 	$t0, $s1, 1						# len - 1
	mul 	$t0, $t0, 4						# array[(len -1) *4] get index of max
	add 	$s0, $s0, $t0					# get last address of array
	lw 	$t2, ($s0)						# get last value of array
	sw 	$t2, ($s3)						# store max

# ---------- Find Median --------
	move $a0, $a0						# pass arr adress
	move $a1, $a1						# pass len
	jal findMedian						# call function
	lw $t4, ($fp)							# load med
	sw $v0, ($t4)							# return med
	
	
# ---------- Find Percent Difference --------
	mtc1 $t4, $f7							# move int med to float register
	cvt.s.w $f7, $f7						# convert int med to float
	
	mtc1 $t5, $f9							# convert int estMed to float
	cvt.s.w $f9, $f9
	l.s $f10, fOneHundred				# get 100.0 

	sub.s $f5, $f9, $f7					# pctDiff = [(estMed - median) / median] * 100
	div.s $f5, $f5, $f7					
	mul.s $f5, $f5, $f10
	
	lw $t6, 8($fp)							# load pctDiff
	s.s $f5, ($t6)							# return pctDiff

# ---------- Find Sum --------
	move $s0, $a0						# get arr address
	move $s1, $a1						# len
	move $t1, $zero					# initialize sum
	
sumLp:
	lw $t0, ($s0)							# get array[i]
	add $t1, $t1, $t0					# sum = sum + array[i]
	add $s0, $s0, 4						# increment array
	sub $s1, $s1, 1						# decrement counter
	bnez $s1, sumLp						# loop if counter > 0

	lw $t7, 12($fp)						# load sum
	sw $t1, ($t7)							# return sum

# ---------- Find Average --------	
	mtc1 $t1, $f7							# convert int sum to float
	cvt.s.w $f7, $f7
	
	move $s1, $a1						# get length	
	mtc1 $s1, $f9						# convert length to float
	cvt.s.w $f9, $f9
	
	div.s $f5, $f7, $f9					# fAve= fsum / flen
	
	lw $t8, 16($fp)						# load fAve
	s.s $f5, ($t8)							# return fAve
	
	
# ----- Done, restore registers and return to calling routine

	lw		$s0, 0($sp)
	lw 	$s1, 4($sp)
	lw 	$s2, 8($sp)
	lw 	$s3, 12($sp)	
	lw  	$fp, 16($sp)
	lw		$ra, 20($sp)	
	add 	$sp, $sp, 24

	jr	$ra
.end totalAreasStats

#####################################################################
#  MIPS assembly language procedure, printResults(), to display
#    the final statistical information to console.

#  Note, due to the system calls, the saved registers must be used.
#	As such, push/pop saved registers altered.

# HLL Call
#	printResults(areas, len, min, max, med, estMed,
#					pctDiff, sum, fAve)

# -----
#    Arguments:
#	$a0	- starting address of diags[]
#	$a1	- length
#	$a2	- min
#	$a3	- max
#	($fp)	- med
#	4($fp)	- estMed
#	8($fp)	- pctDiff (flt)
#	12($fp)	- sum
#	16($fp)	- fAve (flt)

#    Returns:
#	N/A

.globl	printResults
.ent	printResults
printResults:


#	YOUR CODE GOES HERE

sub $sp, $sp, 24						#reserve registers
			
	sw  	$s0, 0($sp)
	sw  	$s1, 4($sp)
	sw  	$s2, 8($sp)
	sw  	$s3, 12($sp)
	sw  	$fp, 16($sp)
	sw	$ra, 20($sp)
	add 	$fp, $sp, 24					# set frame pointer
	
#----- Aquire Addresses	
	move 	$s0, $a0					# get arr address
	move 	$s1, $a1					# len
	move 	$s2, $a2					# min
	move 	$s3, $a3					# max
	lw			$t4, ($fp)					# med
	lw 		$t5, 4($fp)					# estMed
	lw 		$t6, 8($fp)					# pctDiff
	lw	 		$t7, 12($fp)				# sum
	lw			$t8, 16($fp)				# fAve

# ----------------------------- Print Area Values -----------------------------

#  Print header
		
	la	$a0, hdrAreas
	li	$v0, 4
	syscall									# print "Total Areas Values "

#----- Print Array

	move $t0, $a0						# get address of array
	move $t3, $a1						# get length
	move $t2, $zero					# initialize row print counter
	j printLoop								
	
#---- Print Areas array results ----

arrNewLine:
	la	$a0, newLine						# print a newline
	li	$v0, 4
	syscall
	move $t2, $zero					# reset row print counter

printLoop:
	beq $t2, 6, arrNewLine			# if print row counter = 6, then print new line/row

	la $a0, spc							# print spaces
	li $v0, 4
	syscall
	lw $t1, ($s0)							# else print areas[n]
	move $a0, $t1	
	li $v0, 1
	syscall
	
	addu $s0, $s0, 4					# increment volumes array
	subu $t3, $t3, 1						# decrement counter
	addu $t2, $t2, 1  					# increment row print counter
	bnez $t3, printLoop				# if counter > 0, loop printLoop
	
	la	$a0, newLine						# print a newline
	li	$v0, 4
	syscall
	
# ----------------------------- Print Area Stats -------------------------------

#  Print header
		
	la	$a0, hdrStats
	li	$v0, 4
	syscall				# print "Total Areas Stats "

#  Print min message followed by result.

	la	$a0, str1
	li	$v0, 4
	syscall				# print "min = "

	move $a0, $s2
	li	$v0, 1
	syscall				# print min

# -----
#  Print max message followed by result.

	la	$a0, str2
	li	$v0, 4
	syscall				# print "max =  "

	move $a0, $s3
	li	$v0, 1
	syscall				# print max

# -----
#  Print med message followed by result.

	la	$a0, str3
	li	$v0, 4
	syscall				# print "med "

	move $a0, $t4
	li	$v0, 1
	syscall				# print med

# -----
#  Print estMed message followed by result.

	la	$a0, str4
	li	$v0, 4
	syscall				# print "estMed = "

	move $a0, $t5
	li	$v0, 1
	syscall				# print estMed

# -----
#  Print pctDiff message followed by result.

	la	$a0, str5
	li	$v0, 4
	syscall				# print "pctDiff = "

	move $a0, $t6
	li	$v0, 1
	syscall				# print pctDiff
	
# -----
#  Print sum message followed by result.

	la	$a0, str6
	li	$v0, 4
	syscall				# print "sum = "

	move $a0, $t7
	li	$v0, 1
	syscall				# print sum
	
# -----
#  Print fAve message followed by result.

	la	$a0, str7
	li	$v0, 4
	syscall				# print "fAve = "

	move $a0, $t8
	li	$v0, 1
	syscall				# print fAve

# -----
#  Done, terminate program.

endit:
	la	$a0, newLine		# print a newline
	li	$v0, 4
	syscall

	
# ----- Done, restore registers and return to calling routine

	lw		$s0, 0($sp)
	lw 	$s1, 4($sp)
	lw 	$s2, 8($sp)
	lw 	$s3, 12($sp)	
	lw  	$fp, 16($sp)
	lw		$ra, 20($sp)	
	add 	$sp, $sp, 24

	jr	$ra
.end printResults

#####################################################################

