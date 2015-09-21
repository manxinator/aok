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
  c_getopt.cpp
------------------------------------------------------------------------------*/
#include "c_getopt.h"
#include <unistd.h>
#include <libgen.h>

//------------------------------------------------------------------------------

char g_progName[SML_STR_SIZE] = "GetOptions";
char g_fileName[SML_STR_SIZE] = "NOT_DEFINED";

int optv = 0;
int opth = 0;

//------------------------------------------------------------------------------

extern int getopt(int argc, char * const argv[], const char *optstring);

extern char *optarg;
extern int optind, opterr, optopt;

//------------------------------------------------------------------------------

void printUsage(int exitVal)
{
  printf("Usage: %s <options>\n",g_progName);
  printf("  -f <s>        Input Filename (%s)\n",g_fileName);
  printf("--------------------------------------------------\n");
  printf("  -v            increase verbosity: 0x%x\n",optv);
  printf("  -h            print help and exit\n");
  exit(exitVal);
}

void parseArgs (int argc, char *argv[])
{
  strcpy(g_progName,basename(argv[0]));

  int c  = 0;
  opterr = 0;

  while ((c = getopt(argc,argv,"f:vh")) != -1)
    switch (c)
    {
    case 'f':
      strcpy(g_fileName,optarg);
      break;

    case 'v':
      optv = (optv<<1) | 1;
      break;
    case '?':
      switch (optopt)
      {
      case 'f':
        break;
      default:
        if (isprint(optopt))
          fprintf(stderr,"ERROR: Unknown option `-%c'.\n",optopt);
        else
          fprintf(stderr,"ERROR: Unknown option character `\\x%x'.\n",optopt);
        break;
      }
      printf("\n\n");
      printUsage(-1);
      break;
    default:
      printUsage(-1);
    }

  for (int index = optind; index < argc; index++)
    printf("Extra Argument: %s\n",argv[index]);

  if (opth)
    printUsage(EXIT_SUCCESS);
}


