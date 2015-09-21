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
  aokLexer.l

  Compile: flex -Ppl_yy -oaokLexer.c aokLexer.l
------------------------------------------------------------------------------*/

/*----------------------------------------------------------------------------*/
/* Headers                                                                    */
%{
#include "aokLoaderFuncs.h"
#include "c_utils.h"
#ifndef YY_NO_UNPUT
  #define YY_NO_UNPUT
#endif
extern int fileno(FILE *stream);
%}

        /*
         * States
         */
%s  OBJECT

        /*
         * Tokens
         */
tok_ws              [\t\ ]+
tok_newline         [\t ]*\n
tok_objNoWs         \%[^\n\t ]+
tok_objNoRem        \%[_a-zA-Z0-9][^\n\/{2}]*
tok_comment         \/\/.*
      /* unexpected */
tok_nows            [^\n\t\ ]+



/*----------------------------------------------------------------------------*/
/* Rules                                                                      */
%%

<INITIAL>{tok_ws}         ;
<INITIAL>{tok_newline}    {BEGIN INITIAL;   got_tok_newline(yytext);}
<INITIAL>{tok_comment}    ;
<INITIAL>{tok_objNoWs}    {BEGIN OBJECT;    got_tok_objNoWs(yytext);}
<INITIAL>{tok_objNoRem}   {BEGIN OBJECT;    got_tok_objNoRem(yytext);}


<OBJECT>{tok_ws}          ;
<OBJECT>{tok_comment}     ;
<OBJECT>{tok_nows}        {BEGIN INITIAL;   lex_err("<OBJECT>{tok_nows} unexpected '%s'",yytext);};
<OBJECT>{tok_newline}     {BEGIN INITIAL;   got_tok_newline(yytext);}

%%

/*<INITIAL>{tok_objOpen}    {BEGIN OBJECT;    got_tok_objAny (yytext);} */

/*----------------------------------------------------------------------------*/
/* C                                                                          */

extern void lex_reset(const char *in_fn);

int foo_1234(void)
{
  char *statFooC = 0;
  yyunput('x',statFooC);
  return input();
}

int aokLoadFile(const char *inpFileName)
{
  FILE *loadFH = fopen(inpFileName,"r");
  if (loadFH == NULL)
    return errPrn("Failed to open file '%s' for input!",inpFileName);

  lex_reset(inpFileName);
  pl_yyin = loadFH;
  pl_yylex();
  fclose(loadFH);

  return 1;
}



