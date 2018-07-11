from libcpp.string cimport string
from libcpp.vector cimport vector
#from amlValueType cimport AMLValueType

cdef extern from "AMLInterface.h" namespace "AML" :
	cdef cppclass AMLData:
		AMLData()
		AMLData(const AMLData& t)
		void setValue(const string, string)
		void setValue(const string, vector[string] value)
		void setValue(const string, AMLData& value)
		string getValueToStr(const string) except +
		vector[string] getValueToStrArr(const string) except +
		AMLData getValueToAMLData(const string) except +
		vector[string] getKeys()
		int getValueType(const string)

