#!/usr/bin/perl
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
# Created: Mon Mar 21 20:11:07 PDT 2015
#---------------------------------------------------------------------

use warnings;
use strict;
use File::Copy;
use File::Path;
use File::Basename;

sub Help {
    print <<EOF;
Usage: createCfile.pl [options] <NEWFILE>
       All files specified must be relative to current path
Options:
-def=<DEF_NAME>
    Optional Heading Define
-user=<USER_NAME>
    Override default author name
-h
-help
    Print this help
verbosity=<VERBOSITY_LEVEL>
    Set verbosity level
EOF
}

sub generateFile
{
  my $fileName   = shift;
  my $headingDef = shift;
  my $userStr    = shift;
  my $dateStr    = shift;

  my $outF;
  open $outF, ">", $fileName or die("\nERROR: Unable to open $fileName for output!\n\n");

  print $outF "/*******************************************************************************\n";
  print $outF "* Copyright (c) 2015 $userStr\n";
  print $outF "*\n";
  print $outF "* Permission is hereby granted, free of charge, to any person obtaining a copy\n";
  print $outF "* of this software and associated documentation files (the \"Software\"), to deal\n";
  print $outF "* in the Software without restriction, including without limitation the rights\n";
  print $outF "* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell\n";
  print $outF "* copies of the Software, and to permit persons to whom the Software is\n";
  print $outF "* furnished to do so, subject to the following conditions:\n";
  print $outF "*\n";
  print $outF "* The above copyright notice and this permission notice shall be included in all\n";
  print $outF "* copies or substantial portions of the Software.\n";
  print $outF "*\n";
  print $outF "* THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR\n";
  print $outF "* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,\n";
  print $outF "* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE\n";
  print $outF "* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER\n";
  print $outF "* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,\n";
  print $outF "* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE\n";
  print $outF "* SOFTWARE.\n";
  print $outF "********************************************************************************\n";
  print $outF "* $fileName\n";
  print $outF "* Author : $userStr\n";
  print $outF "* Created: $dateStr\n";
  print $outF "*******************************************************************************/\n";
  print $outF "\n";

  if ($headingDef ne "") {
    print $outF "#ifndef $headingDef\n";
    print $outF "#define $headingDef\n";
    print $outF "\n\n\n";
    print $outF "//------------------------------------------------------------------------------\n";
    print $outF "\n";
    print $outF "#endif  //$headingDef\n";
    print $outF "\n";
  } else {
    print $outF "//------------------------------------------------------------------------------\n";
    print $outF "\n";
  }

  close($outF);
}

sub Main
{
  if ($#ARGV < 0) {
    Help();
    die("\ncreateCfile.pl requires more arguments\n");
  }

  my $verbosity   = 0;
  my $headingDef  = "";
  my $newFileName = "";
  my $dateStr     = "";
  my $userStr     = "";

  $userStr = `whoami`; chomp($userStr);
  $dateStr = `date`;   chomp($dateStr);

  foreach my $arg (@ARGV) {
    if ($arg =~ m/^-def=/) {
      $headingDef = $arg;
      $headingDef =~ s/^-def=//;
      $headingDef = "__" . $headingDef . "__";
    } elsif ($arg =~ m/^-user=/) {
      $userStr = $arg;
      $userStr =~ s/^-user=//;
    } elsif ($arg =~ m/^-h/) {
      Help();
      die("\n");
    } elsif ($arg =~ m/^-help/) {
      Help();
      die("\n");
    } elsif ($arg =~ m/^-/) {
      Help();
      die("\nERROR: Unkown option $arg\n");
    } else {
      if ($arg =~ m/^verbosity=/) {
        $verbosity = $arg;
      } else {
        $newFileName = $arg;
      }
    }
  }

  if ($newFileName eq "") {
    Help();
    die("\nERROR: file name not specified\n");
  }

  if ($verbosity > 0) {
    printf("verb: $verbosity, headingDef: '$headingDef', newFile: $newFileName, user: $userStr, date: $dateStr\n");
  }

  generateFile($newFileName, $headingDef, $userStr, $dateStr);
}

#---------------------------------------------------------------------

Main ();

