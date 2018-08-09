'''
Copyright 2018 Samsung Electronics All Rights Reserved.

Licensed under the Apache License, Version 2.0 (the "License")

This is a cython header file containing declarations for AMLValueType enum from aml cpp library.'''

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
