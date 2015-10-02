#---------------------------------------------------------------------
# Copyright (c) 2015 manxinator
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#---------------------------------------------------------------------
# Package-specific Top Level Makefile
# Author : manxinator
# Created: Mon Mar 30 00:16:15 PDT 2015
#---------------------------------------------------------------------

ifndef _MK_APP_LOADERTEST_
_MK_APP_LOADERTEST_=1

        #-------------------------------------------------------------

C99_FILES+=\
  main.c \

CXX_FILES+=\
  c_getopt.cpp \

INCPATH+=\
  ${LOCAL_WS_DIR}/app.loaderTest \

vpath %c \
  ${LOCAL_WS_DIR}/app.loaderTest \

vpath %cpp \
  ${LOCAL_WS_DIR}/app.loaderTest \

        #-------------------------------------------------------------
endif


