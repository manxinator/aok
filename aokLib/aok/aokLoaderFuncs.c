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
  aokLoaderFuncs.c
------------------------------------------------------------------------------*/
#include "aokLoaderFuncs.h"
#include "c_utils.h"
#include <stdarg.h>

//------------------------------------------------------------------------------

int  pl_lineNum = 0x70000000;
char pl_fileName[SML_STR_SIZE];

void lex_reset(const char *in_fn)
{
  pl_lineNum = 1;
  strcpy(pl_fileName,in_fn);
}

int LEX_ERR(const char *fn, int lnum, const char *fmt, ...)
{
  va_list args;
  va_start(args,fmt);
  printf("\n\nLexical Error: Reading '%s' line %d\n",pl_fileName,pl_lineNum);
  printf("ERROR reported by %s:%d -- ",fn,lnum);
  vprintf(fmt,args);
  va_end(args);
  printf("\n");
  exit(-1);
  return 0;
}

        //----------------------------------------------------------------------

int pl_yywrap(void) { return 1; }

        //----------------------------------------------------------------------

void got_tok_newline(const char *yytext)
{
  pl_lineNum++;
}

void got_tok_objNoWs(const char *yytext)
{
  statFnPrn(" (%s)",yytext);
}

void got_tok_objNoRem(const char *yytext)
{
  statFnPrn(" (%s)",yytext);
}

//------------------------------------------------------------------------------


