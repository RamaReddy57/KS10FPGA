#******************************************************************************
#
# KS10 Console Microcontroller
#
# Brief
#    Command Line Library Build rules
#
# File
#    makefile
#
# Author
#    Rob Doyle - doyle (at) cox (dot) net
#
#******************************************************************************
#
# Copyright (C) 2013-2017 Rob Doyle
#
# This file is part of the KS10 FPGA Project
#
# The KS10 FPGA project is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by the Free
# Software Foundation, either version 3 of the License, or (at your option) any
# later version.
#
# The KS10 FPGA project is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
# or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
# more details.
#
# You should have received a copy of the GNU General Public License along with
# this software.  If not, see <http://www.gnu.org/licenses/>.
#
#******************************************************************************

ifneq (${MAKECMDGOALS}, clean)
ifneq (${MAKECMDGOALS}, rcsclean)
include ../makedefs
endif
endif

TARGET := \
	cmdlinelib

FILES := \
	hist.o \
	cursor.o \
	cmdline.o

HEADERS := \
	hist.hpp \
	cursor.hpp \
	cmdline.hpp \
	../prompt.hpp

$(TARGET).a : $(FILES)

$(FILES) : $(HEADERS)

clean:
	rm -f *.o
	rm -f *.a
	rm -f *.d

rcsclean: clean
	rcsclean *

rcsfetch: $(HEADERS) $(FILES:.o=.cpp) makefile

ifneq (${MAKECMDGOALS}, clean)
-include ${wildcard *.d} __dummy__
endif
