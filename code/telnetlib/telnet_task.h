//******************************************************************************
//
//  KS10 Console Microcontroller
//
//! Telnet Task
//!
//! This module initializes LWIP and the telnet task
//!
//! \file
//!      telnet_task.h
//!
//! \author
//!      Rob Doyle - doyle (at) cox (dot) net
//
//******************************************************************************
//
// Copyright (C) 2014-2015 Rob Doyle
//
// This program is free software; you can redistribute it and/or modify it under
// the terms of the GNU General Public License as published by the Free Software
// Foundation; either version 2 of the License, or (at your option) any later
// version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program; if not, write to the Free Software Foundation, Inc., 59 Temple
// Place - Suite 330, Boston, MA 02111-1307, USA.
//
//******************************************************************************

#ifndef __TELNET_TASK_H
#define __TELNET_TASK_H

#ifdef __cplusplus
extern "C" {
#endif

unsigned long telnetTaskInit(void);

#ifdef __cplusplus
}
#endif

#endif