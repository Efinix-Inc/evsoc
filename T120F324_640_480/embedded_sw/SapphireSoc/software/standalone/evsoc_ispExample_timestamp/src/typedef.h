#ifndef _TYPEDEF_H_
#define _TYPEDEF_H_


typedef enum _SYS_STATUS {
    ER_SUCCESS = 0,
    ER_FAIL,
    ER_RESERVED
} SYS_STATUS ;


#define _CODE
#define _DATA
#define _XDATA
#define _IDATA

typedef _CODE unsigned char    cBYTE;

typedef unsigned int UINT, uint;
typedef unsigned char BOOL ;

typedef char CHAR, *PCHAR ;
typedef unsigned char uchar, *puchar ;
typedef unsigned char UCHAR, *PUCHAR ;
typedef unsigned char byte, *pbyte ;
typedef unsigned char BYTE, *PBYTE ;

typedef short SHORT, *PSHORT ;
typedef unsigned short ushort, *pushort ;
typedef unsigned short USHORT, *PUSHORT ;
typedef unsigned short word, *pword ;
typedef unsigned short WORD, *PWORD ;

typedef long LONG, *PLONG ;
typedef unsigned long ulong, *pulong ;
typedef unsigned long ULONG, *PULONG ;
typedef unsigned long dword, *pdword ;
typedef unsigned long DWORD, *PDWORD ;

#define NULL 0

#define FALSE 0
#define TRUE 1

#define FAIL -1

#define ON 1
#define OFF 0

#define LO_ACTIVE TRUE
#define HI_ACTIVE FALSE


#endif    // _TYPEDEF_H_
