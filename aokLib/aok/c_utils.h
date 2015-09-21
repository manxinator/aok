/*------------------------------------------------------------------------------
  Copyright (c) 2015 manxinator

  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in all
  copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  SOFTWARE.
--------------------------------------------------------------------------------
  c_utils.h
------------------------------------------------------------------------------*/
#ifndef __C_UTILS_H__
#define __C_UTILS_H__

#define __STDC_FORMAT_MACROS

#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <inttypes.h>
#include <stdbool.h>

//------------------------------------------------------------------------------

#define MAX_STR_SIZE    1024*4
#define MED_STR_SIZE    1024*2
#define SML_STR_SIZE    1024

//------------------------------------------------------------------------------

extern int FUNC_ERR_PRN         (const char *fn, int lnum, const char *fmt, ...) __attribute__ ((format (printf, 3, 4)));
extern int FUNC_STATFN_PRN      (const char *fu, const char *fmt, ...)           __attribute__ ((format (printf, 2, 3)));
extern int FUNC_ASST_PRN(bool f, const char *fn, int lnum, const char *fmt, ...) __attribute__ ((format (printf, 4, 5)));

    //--------------------------------------------------------------------------

#define errPrn(...)         FUNC_ERR_PRN(__FILE__,__LINE__,__VA_ARGS__)
#define statFnPrn(...)      FUNC_STATFN_PRN(__PRETTY_FUNCTION__,__VA_ARGS__)
#define assertPrn(_F_,...)  FUNC_ASST_PRN(_F_,__FILE__,__LINE__,__VA_ARGS__)

//------------------------------------------------------------------------------

#endif


