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

This is a cython header file containing declarations for APIs in Representation class from aml cpp library.
'''

from libcpp.string cimport string
from amlObject cimport AMLObject

cdef extern from "Representation.h" namespace "AML" :
	#This class contains cython declarations mapped to Representation  class in aml library.
	#This class converts between AMLObject, AML(XML) string, AML(Protobuf) byte.
	cdef cppclass Representation:
		
		#Declaration for Constructor of Representation.
		#@return: native instance of Representation
		Representation(string amlFilePath) except +

		#Declaration for DataToAml API of Representation class.
		#This function converts AMLObject to AML(XML) string to match the AML model information which is set by constructor.
		#@param: amlObject [in] AMLObject to be converted.
		#@return: AML(XML) string converted from amlObject.
		string DataToAml(const AMLObject& amlObject) except +

		#Declaration for AmlToData API of Representation class.
		#This function converts AML(XML) string to AMLObject to match the AML model information which is set by constructor.
		#@param: xmlStr [in] AML(XML) string to be converted.
		#@return: AMLObject instance converted from AML(XML) string. 
		AMLObject* AmlToData(const string) except +

		#Declaration for DataToByte API of Representation class.
		#This function converts AMLObject to Protobuf byte data to match the AML model information which is set by constructor.
		#@param: amlObject [in] AMLObject to be converted.
		#@return: Protobuf byte data(string) converted from amlObject.
		string DataToByte(const AMLObject& amlObject) except +

		#Declaration for ByteToData API of Representation class.
		#This function converts Protobuf byte data to AMLObject to match the AML model information which is set by constructor.
		#@param: byte [in] Protobuf byte data(string) to be converted.
		#return: AMLObject instance converted from amlObject.
		AMLObject* ByteToData(const string) except +
 
		#Declaration of getRepresentationId API of Representation class.
		#This function returns AutomationML SystemUnitClassLib's unique ID
		#@return: string value of AML SystemUnitClassLIb's ID
		string getRepresentationId()

		#Declaration of getConfigInfo API of Representation class.
		#This function returns AMLObject that contains configuration data which is present in RoleClassLib.
		#@return: AMLObject that has configuration data.
		AMLObject* getConfigInfo()
