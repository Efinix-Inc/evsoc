////////////////////////////////////////////////////////////////////////////////
// Copyright (C) 2013-2025 Efinix Inc. All rights reserved.
// Full license header bsp/efinix/EfxSapphireSoc/include/LICENSE.MD
////////////////////////////////////////////////////////////////////////////////

/*******************************************************************************
*
* @file print.h
*
* @brief Header file contain all necessary print function that supports char, string, 
*        decimal, and hexadecimal specifiers. Uses medium RAM resources.
*
******************************************************************************/
#pragma once

#include <stdarg.h>
#include <stdlib.h>
#include <stdint.h>
#include <math.h>
#include <string.h>
#include "bsp.h"

#if (ENABLE_BSP_PRINTF)
    static void _putchar(char character){
        #if (ENABLE_SEMIHOSTING_PRINT == 1)
            sh_writec(character);
        #else
            bsp_putChar(character);
        #endif // (ENABLE_SEMIHOSTING_PRINT == 1)
    }

    static void _putchar_s(char *p)
    {
    #if (ENABLE_SEMIHOSTING_PRINT == 1)
        sh_write0(p);
    #else
        while (*p)
            _putchar(*(p++));
    #endif // (ENABLE_SEMIHOSTING_PRINT == 1)
    }

        static void bsp_printHex(uint32_t val)
    {
        uint32_t digits;
        digits =8;

        for (int i = (4*digits)-4; i >= 0; i -= 4) {
            _putchar("0123456789ABCDEF"[(val >> i) % 16]);
        }
    }

    static void bsp_printHex_lower(uint32_t val)
    {
        uint32_t digits;
        digits =8;

        for (int i = (4*digits)-4; i >= 0; i -= 4) {
            _putchar("0123456789abcdef"[(val >> i) % 16]);

        }
    }

    #if (ENABLE_FLOATING_POINT_SUPPORT)
/*******************************************************************************
*
* @brief This function takes a character array as input and reverses its content.
*
* @param s[] Character array to be reversed.
*
* @notes:
* - Initializes two indices, i and j, for the start and end of the string respectively.
* - Iterates through the string from both ends towards the middle.
* - Swaps the characters at positions i and j in each iteration.
*
******************************************************************************/
     static void reverse(char s[])
     {
          int i, j, len;
          char c;
    
          for (i = 0, j = strlen(s)-1; i<j; i++, j--) {
              c = s[i];
              s[i] = s[j];
              s[j] = c;
          }
     }
    
/*******************************************************************************
*
* @brief This function converts an integer to its corresponding string representation
*        and stores it in the provided character array.
*
* @param n Integer to be converted.
* @param s[] Character array to store the resulting string.
*
* @notes:
* - Checks the sign of the integer and records it.
* - Converts the absolute value of the integer to its string representation in reverse order.
* - If the integer was negative, adds a '-' character to the string.
* - Reverses the resulting string to get the correct order.
*
******************************************************************************/   
     static void itos(int n, char s[])
     {
         int i, sign;
    
         if ((sign = n) < 0)  /* record sign */
             n = -n;          /* make n positive */
         i = 0;
         do {       /* generate digits in reverse order */
             s[i++] = n % 10 + '0';   /* get next digit */
         } while ((n /= 10) > 0);     /* delete it */
         if (sign < 0)
             s[i++] = '-';
         s[i] = '\0';
         reverse(s);
    }
    

/*******************************************************************************
*
* @brief This function converts a double number to its string representation with a
*        specified number of decimal places and stores the integer and fractional parts
*        in separate character arrays.
*
* @param n Double number to be converted.
* @param res1 Character array to store the integer part of the number.
* @param res2 Character array to store the fractional part of the number.
*
* @notes:
* - Extracts the integer part of the double number.
* - Calculates the fractional part of the double number.
* - Converts the integer part to its string representation using the 'itos' function.
* - Adds a dot to the 'res2' array.
* - Converts the fractional part to its string representation with a specified
*   number of decimal places.
*
******************************************************************************/
    static void ftoa(double n, char* res1, char* res2)
    {
        float fpart_f;
        int afterpoint=4;
    
        // Extract integer part
        int ipart = (int)n;
    
        // Extract floating part
        double fpart = n - (double)ipart;
    
        // convert integer part to string
        itos(n, res1);
    
        // add dot
        *res2 = '.';
        res2++;
    
        // convert fraction part to string
        fpart_f = (float)fpart * pow(10, afterpoint);
        if (fpart_f<0)
        {
            *res2 = '-';
            res2++;
            fpart_f = -(fpart_f);
        }
        // handling of 0 after decimal point e.g. 1.003
        for (int i=afterpoint; i>0; i--)
        {
            if ((fpart_f<(1 * pow(10, i-1))) && (fpart_f>0))
            {
                *res2='0';
                res2++;
            }
        }
    
        itos((int)fpart_f, res2);
    }
    
/*******************************************************************************
*
* @brief This function converts an unsigned 32-bit integer to its string representation
*        and prints it using the '_putchar_s' function.
*
* @param val Unsigned 32-bit integer value to be printed.
*
******************************************************************************/    
    static void print_dec(uint32_t val)
    {
        char sval[10];
        itos(val, sval);
        _putchar_s(sval);

    }

/*******************************************************************************
*
* @brief This function prints a floating-point value.
*
* @param val Double precision floating-point value to be printed.
*
* @notes:
* - Converts the double precision floating-point value to its string 
*   representation using the 'ftoa' function.
* - Adjusts the string representation to handle negative signs and proper 
*   placement of decimal points.
* - Prints the adjusted string representation using the '_putchar_s' function.
*
******************************************************************************/
    static void print_float(double val)
    {
        int i, j, neg;
        neg=0;
        i=2;
        j=19;
        char sval[21], fval[10];
        ftoa(val, sval, fval);
        if (fval[1] == '-')
        {
            neg = 1;
            while (i<10)
            {
                fval[i-1] = fval[i];
                i++;
            }

        }
        strcat(sval, fval);
        if ((sval[0] != '-') && (neg == 1))
        {
            while (j>=0)
            {
                sval[j+1] = sval[j];
                j--;
            }
            sval[0] = '-';
        }
        _putchar_s(sval);
    }

    #endif //#if (ENABLE_FLOATING_POINT_SUPPORT)

/*******************************************************************************
*  
* @brief This function is used to output a single character.
*
* @param c: The character to be output.
*
******************************************************************************/
    static void bsp_printf_c(int c)
    {
        _putchar(c);
    }

/*******************************************************************************
* @brief This function is used to outputs a null-terminated string. 
*
* @param s: A pointer to the null-terminated string to be output.
*
*******************************************************************************/
    static void bsp_printf_s(char *p)
    {
        _putchar_s(p);
    }


/*******************************************************************************
*
* @brief This function prints an integer to the output.
*
* @param val Integer value to be printed.
*
* @notes:
* - Converts the integer to a string representation by extracting digits.
* - Handles negative numbers by printing a '-' sign.
* - Uses the 'bsp_printf_c' function to print each character.
*
******************************************************************************/
    static void bsp_printf_d(int val)
    {
        char buffer[32];
        char *p = buffer;
        if (val < 0) {
            bsp_printf_c('-');
            val = -val;
        }
        while (val || p == buffer) {
            *(p++) = '0' + val % 10;
            val = val / 10;
        }
        while (p != buffer)
            bsp_printf_c(*(--p));
    }

/*******************************************************************************
*
* @brief This function prints an integer in hexadecimal format to the output.
*
* @param val Integer value to be printed in hexadecimal format.
*
* @notes:
* - Determines the number of hexadecimal digits required for the given value.
* - Calls 'bsp_printHex_lower' to print the hexadecimal representation.
* - Determines the number of leading zeros to be printed based on the value.
*
******************************************************************************/
    static void bsp_printf_x(int val)
    {
        int i,digi=2;

        for(i=0;i<8;i++)
        {
            if((val & (0xFFFFFFF0 <<(4*i))) == 0)
            {
                digi=i+1;
                break;
            }
        }
        bsp_printHex_lower(val);
    }

/*******************************************************************************
*
* @brief This function prints an integer in uppercase hexadecimal format to the output.
*
* @param val Integer value to be printed in uppercase hexadecimal format.
*
* @notes:
* - Determines the number of hexadecimal digits required for the given value.
* - Calls 'bsp_printHex' to print the uppercase hexadecimal representation.
* - Determines the number of leading zeros to be printed based on the value.
*
******************************************************************************/
    static void bsp_printf_X(int val)
        {
            int i,digi=2;

            for(i=0;i<8;i++)
            {
                if((val & (0xFFFFFFF0 <<(4*i))) == 0)
                {
                    digi=i+1;
                    break;
                }
            }
            bsp_printHex(val);
        }
#if (ENABLE_SEMIHOSTING_PRINT == 0)
/*******************************************************************************
*
* @brief This function is a Printf-like function to print formatted data to the output.
*        which acts similar to the standard 'printf' function but supports a 
*        limited set of format specifiers: 'c', 's', 'd', 'x', 'X', and 'f'.
*
* @param format Format string followed by the arguments to be formatted.
* @param ... Variable arguments corresponding to the format specifiers in 'format'.
*
* @notes:
* - Iterates over each character in the format string.
* - Recognizes '%' as the start of a format specifier.
* - Handles each format specifier by calling the appropriate helper function.
* - If floating-point support is disabled, prints a warning for the 'f' specifier.
*
******************************************************************************/
    static void bsp_printf(const char *format, ...)
    {
        int i;
        va_list ap;

        va_start(ap, format);

        for (i = 0; format[i]; i++)
            if (format[i] == '%') {
                while (format[++i]) {
                    if (format[i] == 'c') {
                        bsp_printf_c(va_arg(ap,int));
                        break;
                    }
                    else if (format[i] == 's') {
                        bsp_printf_s(va_arg(ap,char*));
                        break;
                    }
                    else if (format[i] == 'd') {
                        bsp_printf_d(va_arg(ap,int));
                        break;
                    }
                    else if (format[i] == 'X') {
                        bsp_printf_X(va_arg(ap,int));
                        break;
                    }
                    else if (format[i] == 'x') {
                        bsp_printf_x(va_arg(ap,int));
                        break;
                    }
#if (ENABLE_FLOATING_POINT_SUPPORT)
                    else if (format[i] == 'f') {
                        print_float(va_arg(ap,double));
                        break;
                    }
#elif (ENABLE_PRINTF_WARNING)
                    else if (format[i] == 'f') {
                        bsp_printf_s("<Floating point printing not enable. Please Enable it at bsp.h first...>");
                        break;
                    }
#endif //#if (ENABLE_FLOATING_POINT_SUPPORT)
                }
            } else
                bsp_printf_c(format[i]);

        va_end(ap);
    }

#else // #if (ENABLE_SEMIHOSTING_PRINT == 1)
    #include "print_full.h"
/*******************************************************************************
*
* @brief This function is printf-like function to print formatted data to the output
*        when semihosting is enabled. 
*
* @param format Format string followed by the arguments to be formatted.
* @param ... Variable arguments corresponding to the format specifiers in 'format'.
*
******************************************************************************/
    static int bsp_printf(const char* format, ...)
    {
      va_list va;
      va_start(va, format);

      char buffer[MAX_STRING_BUFFER_SIZE];
        const int ret = _vsnprintf(_out_buffer, buffer, (size_t)-1, format, va);
        _putchar_s(buffer);

      va_end(va);
      return ret;
    }


#endif // #if (ENABLE_SEMIHOSTING_PRINT == 0)
#endif //#if (ENABLE_BSP_PRINTF)
