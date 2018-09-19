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

This is a cython header file containing declarations for APIs in AMLData class from aml cpp library.
'''

from libcpp.string cimport string
from libcpp.vector cimport vector
#from amlValueType cimport AMLValueType

cdef extern from "AMLInterface.h" namespace "AML" :
	#This class contains cython declarations mapped to AMLData class in aml library.
	# This class contains an internal  map of raw data in a key value pair form.
	cdef cppclass AMLData:

		#Declaration for Default Constructor of AMLData.
		#@return: native instance of AMLData 
		AMLData()

		#Declaration for Copy Constructor of AMLData.
		#@return: native instance of AMLData
		AMLData(const AMLData& t)

		#Declaration for setValue() API of AMLData class.
		#This function set key and string type value pair on AMLData.
		#@param:key-AMLData key.
		#@param:value-AMLData value as string.
		void setValue(const string, string)

		#Declaration for setValue() API of AMLData class.
		#This function set key and string vector type value pair on AMLData.
		#@param:key-AMLData key.
		#@param:value-Vector of AMLData values.
		void setValue(const string, vector[string] value)

		#Declaration for setValue() API of AMLData class.
		#This function set key and AMLData type value pair on AMLData.
		#@param:key-AMLData key.
		#@param:value-AMLData value.
		void setValue(const string, AMLData& value)

		#Declaration for getValueToStr() API of AMLData class.
		#This function return string which matched key in a AMLData's AMLMap.
		#@param: key-pair's which has string value, key.
		#@return: String value which matched using key on AMLMap.
		string getValueToStr(const string) except +

		#Declaration for getValueToStrArr() API of AMLData class
		#This function return string array which matched key in a AMLData's AMLMap.
		#@param: key-pair's which has string value, key.
		#@return: String array value which matched using key on AMLMap.
		vector[string] getValueToStrArr(const string) except +

		#Declaration for getValueToStrArr() API of AMLData class.
		#This function return AMLData which matched key in a AMLData's AMLMap.
		#@param: key-pair's which has string value, key.
		#@return: AMLData value which matched using key on AMLMap.
		AMLData getValueToAMLData(const string) except +

		#Declaration for getKeys() API of AMLData class.
		#This function return string list about AMLData's AMLMap keys string array.
		#@return:vector of string data's keys value list.
		vector[string] getKeys()

		#Declaration for getValueType() API of AMLData class.
		#This function return string list about AMLData's AMLMap keys string array.
		#@param: key-pair's which has string value, key.
		#@return: value's AMLValueType of pre defined data type.
		int getValueType(const string)

