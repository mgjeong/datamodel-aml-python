from libcpp.string cimport string
from amlObject cimport AMLObject

cdef extern from "Representation.h" namespace "AML" :
	cdef cppclass Representation:
		Representation(string amlFilePath) except +
		string DataToAml(const AMLObject& amlObject) except +
		AMLObject* AmlToData(const string) except +
		string DataToByte(const AMLObject& amlObject) except +
		AMLObject* ByteToData(const string) except +
 
		string getRepresentationId()
		AMLObject* getConfigInfo()
