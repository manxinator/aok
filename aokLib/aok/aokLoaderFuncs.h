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
  aokLoaderFuncs.h
------------------------------------------------------------------------------*/
#ifndef __AOK_LOADER_FUNCS_H__
#define __AOK_LOADER_FUNCS_H__

#define __STDC_FORMAT_MACROS

#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <inttypes.h>
#include <unistd.h>

//------------------------------------------------------------------------------

#ifdef __cplusplus
extern "C" {
#endif

void got_tok_newline (const char *yytext);
void got_tok_objNoWs (const char *yytext);
void got_tok_objNoRem(const char *yytext);

        //----------------------------------------------------------------------

extern int LEX_ERR(const char *fn, int lnum, const char *fmt, ...) __attribute__ ((format (printf, 3, 4)));
#define lex_err(...)    LEX_ERR(__FILE__,__LINE__,__VA_ARGS__)

#ifdef __cplusplus
}
#endif

//------------------------------------------------------------------------------

#endif


