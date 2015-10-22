#!/usr/bin/python
#-------------------------------------------------------------------------------
# Copyright (c) 2015 tontod
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
#-------------------------------------------------------------------------------
# testChecker.simple.py
# Author:   tontod
# Created:  Wed Oct 21 02:41:52 PDT 2015
# Language: Python 2.7.6
#-------------------------------------------------------------------------------

import os, sys, re

#-------------------------------------------------------------------------------

class simpleLogCheck:
  """Simple script that parses the log file
     - Detects three keywords: PASS, ERROR and FAIL
     - Regex Matching is case insensitive
     - If PASS is detected with either ERROR or FAIL, the result is UNKNOWN
     - Result is also written to result.launchtest.temp

     NOTE: This script is allowed to open the run log file for reading only.
           And it shouldn't write to it, since the output will ultimately be
           redirected to the same log file.
     NOTE: run.log is assumed for now, but this may be changed at a later time.
           Metadata should be parsed in launcher.log to get the log name
  """

  def __init__(self):
    """Init the class with a few basic assumptions"""
    self.logFileName = 'run.log' # TODO: get this from metadata -- launcher.log

    self.debug_showOutput = False

  def run(self):
    """Run performs the log file parsing and result printing"""
    try:
      logFh = open(self.logFileName,'r')
    except IOError:
      sys.stderr.write("Failed to open file %s" % self.logFileName)
      sys.exit(2)

    if self.debug_showOutput:
      try:
        logWr = open('debug_showOutput.txt','w')
      except IOError:
        sys.stderr.write("Failed to open file out.txt")
        sys.exit(3)

    detPass = False
    detErro = False
    detFail = False
    m_pass = re.compile('.*pass',  re.I)
    m_erro = re.compile('.*error', re.I)
    m_fail = re.compile('.*fail',  re.I)

    for oneLine in logFh:
      if self.debug_showOutput:
        logWr.write('++> %s' %oneLine)
      if m_pass.match(oneLine): detPass = True
      if m_erro.match(oneLine): detErro = True
      if m_fail.match(oneLine): detFail = True
    if self.debug_showOutput:
      logWr.close()
    logFh.close()

    if self.debug_showOutput:
      print "-------------------------"
      print "detPass: ", str(detPass)
      print "detErro: ", str(detErro)
      print "detFail: ", str(detFail)

    resStr = 'UNKNOWN'
    if detPass and not detErro and not detFail: resStr = 'PASS'
    if not detPass and (detErro or detFail):    resStr = 'FAIL'

    print "-------------------------"
    print "POST_TEST_ANALYSIS: %s!" % resStr

    # Also, output result.launchtest.temp
    with open('result.launchtest.temp','w') as resFh:
      resFh.write( "%s!" % resStr )

#-------------------------------------------------------------------------------

if __name__ == "__main__":
  qualifier = simpleLogCheck()
  qualifier.run()

