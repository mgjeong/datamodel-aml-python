'''
/*******************************************************************************
 * Copyright 2018 Samsung Electronics All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 *******************************************************************************/

This is a cython header file containing declarations for AMLValueType enum from aml cpp library.
'''

cdef extern from "AMLInterface.h" namespace "AML" :
	#Declaration for AMLValueType.
	#This enum class represent AMLdata Value type
	cdef cppclass AMLValueType:
		pass

cdef extern from "AMLInterface.h" namespace "AML::AMLValueType":
	#These are declaration for individual AMLValueType enum values mapped to their cpp values.

	cdef AMLValueType String
	cdef AMLValueType StringArray
	#cdef AMLValueType AMLData
