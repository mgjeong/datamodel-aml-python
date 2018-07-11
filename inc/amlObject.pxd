from libcpp.string cimport string
from libcpp.vector cimport vector
from amlData cimport AMLData

cdef extern from "AMLInterface.h" namespace "AML" :
	cdef cppclass AMLObject:
		AMLObject(const string deviceId, const string timeStamp)
		AMLObject(const string deviceId, const string timeStamp, const string id)
		AMLObject(const AMLObject& t)

		void addData(string name, const AMLData& data) except +
		AMLData getData(string name) except +
		vector[string] getDataNames()
		string getDeviceId()
		string getTimeStamp()
		string getId()
