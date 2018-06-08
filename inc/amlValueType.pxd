cdef extern from "AMLInterface.h" namespace "AML" :
	cdef cppclass AMLValueType:
		pass

cdef extern from "AMLInterface.h" namespace "AML::AMLValueType":
	cdef AMLValueType String
	cdef AMLValueType StringArray
	#cdef AMLValueType AMLData
