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
# Perl script to generate .gdbinit file
# Author : manxinator
# Created: Mon Mar 21 20:38:29 PDT 2015
#---------------------------------------------------------------------

use warnings;
use strict;
use File::Copy;
use File::Path;
use File::Basename;

sub Help {
    print <<EOF;
Usage: createGdbinit.pl [options] <NEW_FILE>
       All files specified must be relative to current path
Options:
-b=<BREAKPOINT>
    Optional breakpoint
-h
-help
    Print this help
verbosity=<VERBOSITY_LEVEL>
    Set verbosity level
EOF
}

sub generateFile
{
    my $binFileName   = shift;
    my $_brkPointLst  = shift;
    my $runArgs       = shift;
    my $verbosity     = shift;

    my @breakPointLst = @$_brkPointLst;
    my $outFileName = ".gdbinit." . $binFileName;


    # Cleanup
    #
    unlink ".gdbinit";
    unlink $outFileName;


    my $fullFileName = `which $binFileName`;
    chomp $fullFileName;
    if ($fullFileName eq "") {
        $fullFileName = "./$binFileName";
        chomp $fullFileName;
	}

    printf "verb: $verbosity, runArgs: $runArgs, binary: $fullFileName\n";

    my $outF;
    open $outF, ">", $outFileName or die("\nERROR: Unable to open $fullFileName for output!\n\n");

    print $outF "\n";
    print $outF "symbol-file $fullFileName\n";
    print $outF "exec-file   $fullFileName\n";
    print $outF "\n";

    foreach my $oneBp (@breakPointLst) {
        printf "+ b $oneBp\n";
        print $outF "b $oneBp\n";
    }
    print $outF "\n";

    print $outF "define go\n";
    print $outF "    r $runArgs\n";
    print $outF "    echo ddd: frame 0\\n\n";
    print $outF "end\n\n\n";

    close($outF);


    symlink($outFileName,".gdbinit");
}

sub Main
{
    if ($#ARGV < 0) {
        Help();
        die("\ncreateGdbinit.pl requires more arguments\n");
    }

    my @breakPointLst;

    my $verbosity   = 0;
    my $binFileName = "";
    my $runArgs     = "";  # Support for this not yet implemented

    foreach my $arg (@ARGV) {
        if ($arg =~ m/^-b=/) {
            my $oneBreakPoint = "";
            $oneBreakPoint    = $arg;
            $oneBreakPoint    =~ s/^-b=//;
            chomp $oneBreakPoint;
            push (@breakPointLst,$oneBreakPoint);
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
                $binFileName = $arg;
            }
        }
    }

    if ($binFileName eq "") {
        Help();
        die("\nERROR: binary name not specified\n");
    }

    generateFile($binFileName, \@breakPointLst, $runArgs, $verbosity);
}

#---------------------------------------------------------------------

Main ();

