'''
Copyright 2018 Samsung Electronics All Rights Reserved.

Licensed under the Apache License, Version 2.0 (the "License")

This is a cython header file containing declarations for APIs in AMLObject class from aml cpp library.'''

from libcpp.string cimport string
from libcpp.vector cimport vector
from amlData cimport AMLData

cdef extern from "AMLInterface.h" namespace "AML" :
	#This class contains cython declarations mapped to AMLObject class in aml library.
	#This class contains the AML Data.
	cdef cppclass AMLObject:

		#Declaration for constructor of AMLObject
		#@param: Device id that source device of AMLObject.		
		#@param: timestamp value of AMLObject delibered by device.
		#@return: native instance of AMLObject
		AMLObject(const string deviceId, const string timeStamp)

		#Declaration for constructor of AMLObject
		#@param: Device id that source device of AMLObject.
		#@param: timestamp value of AMLObject delibered by device.
		#@param: id of AMLObject.
		#@return: native instance of AMLObject
		AMLObject(const string deviceId, const string timeStamp, const string id)
		
		#Declaration for Copy Constructor of AMLObject.
		#@return: native instance of AMLObject
		AMLObject(const AMLObject& t)

		#Declaration of addData API of AMLObject class.
		#This function add AMLData to AMLObject using AMLData key that to match AMLData value.
		#@param: name - String value to use matching with key.
		#@param: data - AMLData value.
		void addData(string name, const AMLData& data) except +

		#Declaration of getData API of AMLObject class.
		#This function return AMLData which matched input name string with AMLObject's amlDatas key.
		#@param: name - String value to use matching with key.
		#@return: AMLData that have sub key value fair.
		AMLData getData(string name) except +

		#Declaration of getDataNames API of AMLObject class.
		#This function return string list about AMLObject's amlDatas keys string array.
		#@return: vector of string data's keys value list.
		vector[string] getDataNames()

		#Declaration of getDeviceId API of AMLObject class.
		#This function return Device's ID saved on AMLObject.
		#return: String value of device's Id.
		string getDeviceId()

		#Declaration of getTimeStamp API of AMLObject class.
		#This function return timestamp that deliveried device.
		#return: String value of timestamp.
		string getTimeStamp()

		#Declaration of getId API of AMLObject class.
		#This function return ID that AMLObject.
		#@return: String value of AMLObject Id.
		string getId()
