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
  c_utils.c
------------------------------------------------------------------------------*/
#include "c_utils.h"
#include <stdarg.h>

//------------------------------------------------------------------------------

int prFileLineErr(const char *fmt, const char *fn, int lnum)
{
  int tmpLen = strlen(fmt);
  if (fmt[tmpLen-1] != '\n')
    printf("\n");
  return printf("* error in %s:%d\n\n",fn,lnum);
}

int FUNC_ERR_PRN(const char *fn, int lnum, const char *fmt, ...)
{
  va_list args;
  va_start(args,fmt);
  printf("ERROR: ");
  vprintf(fmt,args);
  int ret = prFileLineErr(fmt,fn,lnum);
  va_end(args);
  exit(-1);
  return ret;
}

int FUNC_ASST_PRN(bool f, const char *fn, int lnum, const char *fmt, ...)
{
  va_list args;
  if (f)
    return 0;
  va_start(args,fmt);
  printf("ERROR: ");
  vprintf(fmt,args);
  int ret = prFileLineErr(fmt,fn,lnum);
  va_end(args);
  exit(-1);
  return ret;
}

int FUNC_STATFN_PRN(const char *fu, const char *fmt, ...)
{
  va_list args;
  va_start(args,fmt);
  printf("[%s]",fu);
  int ret = vprintf(fmt,args);
  va_end(args);
  int tmpLen = strlen(fmt);
  if (fmt[tmpLen-1] != '\n')
    printf("\n");
  return ret;
}



