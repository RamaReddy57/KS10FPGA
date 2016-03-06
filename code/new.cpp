//******************************************************************************
//
//  KS10 Console Microcontroller
//
//! \brief
//!    operator new() and operator delete() implementation
//!
//! \file
//!    new.cpp
//!
//! \author
//!    Rob Doyle - doyle (at) cox (dot) net
//
//******************************************************************************
//
// Copyright (C) 2013-2016 Rob Doyle
//
// This file is part of the KS10 FPGA Project
//
// The KS10 FPGA project is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by the Free
// Software Foundation, either version 3 of the License, or (at your option) any
// later version.
//
// The KS10 FPGA project is distributed in the hope that it will be useful, but
// WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
// or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
// more details.
//
// You should have received a copy of the GNU General Public License along with
// this software.  If not, see <http://www.gnu.org/licenses/>.
//
//******************************************************************************

#include "stdio.h"
#include "lwiplib.h"

//!
//! \brief
//!    C++ memory allocator.
//!
//! \details
//!    This just wrappers the <b>mem_malloc</b> function
//!
//! \returns
//!    Pointer to memory allocated from heap.
//!

void *operator new(size_t size) {
    return mem_malloc(size);
}

//!
//! \brief
//!    Free memory that was allocated by operator new()
//!

void operator delete(void * ptr) {
    mem_free(ptr);
}
