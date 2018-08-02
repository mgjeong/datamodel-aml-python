# cython: linetrace=True
# cython: binding=True
'''
Dcumentation for DATAMODEL_AML_PYTHON

`amlpy` is a cython binding module written over datamodel-aml-cpp(libaml) so as to expose datamodel aml api's to python applications.

Copyright 2017 Samsung Electronics All Rights Reserved.

Licensed under the Apache License, Version 2.0 (the "License")'''

from libcpp.string cimport string
from libcpp.vector cimport vector
from cython.operator cimport dereference as deref
from inc.amlObject cimport AMLObject
from inc.amlData cimport AMLData
from inc.representation cimport Representation
from inc.amlValueType cimport *
import logging as log

if LOG_LEVEL == 'debug':
	log.basicConfig(level=log.DEBUG)

def __invalidInputException(cause):
	log.error("Exception caught : ", cause)
	raise Exception(cause)

cdef class pyAMLData:
	'''
        This class contains an internal  map of raw data in a key value pair form.
	It contains a pointer to native AMLData instance.
        If no pyAMLData instance passed, new AMLData instance created.	
	If pyAMLData passed, it acts as a copy constructor overloading.
        @param pyAMLData: [optional] For copy constructor.
	@usage: 
		amlData = pyAMLData() // Create a new pyAMLData object
		OR
		amlData = pyAMLData(pyAMLData obj) // Create a new instance and  copy data of obj instance.'''
	cdef AMLData data
	def __cinit__(self, *args):
		if len(args) != 0:
			log.debug("pyAMLData: IN constructor with arguments")
			if len(args) ==  1:
				log.debug("pyAMLData: 1 argument read")
				tempAmlData = args[0]
				if isinstance(tempAmlData, pyAMLData):
					log.debug("pyAMLData: Argument type pyAMLData read")
					amlData = <pyAMLData>tempAmlData
					self.data = deref(new AMLData(amlData.data))
				else:
					log.debug("pyAMLData: Invalid argument class type")
					__invalidInputException("Invalid argument type")
			else:
				log.debug("pyAMLData: Invalid number of args in constructor")
				__invalidInputException("Invalid number of arguments")
		else:
			log.debug("pyAMLData: In constructor without arguments")
			self.data = deref(new AMLData())
	def setValue(self, *args):
		'''
		This function sets key and value pair on AMLData.
		Value types accepted are : strings, vector[strings] or pyAMLData.
		@param key: AMLData Key.
		@param value: AMLData value. [string, vector or pyAMLData]
		@usage :
			a = pyAMLData()
			a.setValue('key', '20') // type string
			OR
			a.setValue('key', ['10', '20', '30'] // type vector[string]
			OR
			sample = pyAMLData()
			a.setValue('key', sample) // type pyAMLData
		'''
		log.debug("pyAMLData: setValue called")
		if len(args) !=  2:
			log.debug("pyAMLData: invalid number of arguments caught")
			__invalidInputException("Invalid number of arguments")
		else:
			key, value = args
			log.debug("pyAMLData: key and data value", key, value)
			if isinstance(value, str):
				log.debug("pyAMLData: value is instance of string")
				self.data.setValue(<string>key, <string>value)
			elif isinstance(value, list):
				log.debug("pyAMLData: value is instance of list")
				self.data.setValue(<string>key, <vector[string]>value)
			elif isinstance(value, pyAMLData):
				log.debug("pyAMLData: value is instance of pyAMLData")
				tempAmlData = <pyAMLData>value
				self.data.setValue(<string>key, tempAmlData.data)
			else:
				log.debug("pyAMLData: Invalid type of value caught")
				__invalidInputException("Invalid argument type")
	def getValueToStr(self, key):
		'''
		This function returns the string value which matches the key in AMLData's AMLMap.
		@param key: pair's which has string value, key.
		@return string: String value which matches the key on AMLMap.
		'''
		log.debug("pyAMLData: getValueToStr called")
		try:
			log.debug("pyAMLData: calling getValueToStr for key", key)
			return self.data.getValueToStr(key)
		except Exception as e:
			__invalidInputException(e)
	def getValueToStrArr(self, key):
		'''
		This function returns the string array value which matches the key in AMLData's AMLMap.
		@param key: pair's which has string value, key.
		@return vector[string]: String array value which matches the key on AMLMap 
		'''
		log.debug("pyAMLData: getValueToStrArray called")
		try:
			log.debug("pyAMLData: calling getValueToStrArr for key", key)
			return self.data.getValueToStrArr(key)
		except Exception as e:
			__invalidInputException(e)
	def getValueToAMLData(self, key):
		'''
		This function returns a pyAMLData insatance which contains pointer to amlData that matches the  key in AMLData's AMLMap.
		@param key: pair's which has AMLData, key.
		@return pyAMLData: pyAMLData value which matches the key on AMLMap.
		'''
		log.debug("pyAMLData: getValueToAMLData called")
		try:
			log.debug("pyAMLData: Creating pyAMLData object")
			amlData = pyAMLData()
			amlData.data = self.data.getValueToAMLData(key)
			log.debug("pyAMLData: returning pyAMLData object")
			return amlData
		except Exception as e:
			__invalidInputException(e)
	def getKeys(self):
		'''
		This function return string list about AMLData's AMLMap keys string array.
		@return vector[string]: vector of string data's keys value list.
		'''
		log.debug("pyAMLData: getKeys being called")
		return self.data.getKeys()
	def getValueType(self, key):
		'''
		This function return string list about AMLData's AMLMap keys string array.
		@param key: string of the AMLData value to check.
		@return amlValueType: value's AMLValueType of pre defined data type.
		'''
		log.debug("pyAMLData: get value type called for key ", key)
		#cdef c = {<int>String : "String", <int>StringArray : "StringArray", <int>}
		#return c[<int>self.data.getValueType(key)]
		return [<int>self.data.getValueType(key)]

cdef class pyAMLObject:
	'''
	This class contains the AML Data.
	The constructor creates a new AMLObject instance
        and stores it in a pointer to a native object.
        @param deviceId: []Device id that source device of AMLObject.
        @param timeStamp: timestamp value of AMLObject delibered by device.
        @param id: [optional]ID of AML Object
	@param pyAMLObject [optional]: For copy constructor. 
	@Usage:
		a. deviceId = "GTC001"
                   timeStamp = "123456789"
                   amlObj = pyAMLObject(deviceId, timeStamp)
		b. ID = "GTC_ROBOT_ID_001"
		   amlObj = pyAMLObject(deviceId, timeStamp, ID)
		c. copyAmlObj = pyAMLObject(amlObj)
	'''
	cdef AMLObject* obj
	def __cinit__(self, *args):
		argsLen = len(args)
		log.debug("pyAMLObject: Constructor called with args length ", argsLen)
		if argsLen != 0:
			if argsLen is 1:
				log.debug("pyAMLObject: Constructor with 1 argument")
				tempAmlObj = args[0]
				if isinstance(tempAmlObj, pyAMLObject):
					log.debug("pyAMLObject: arg is an instance of pyAMLOject")
					amlObj = <pyAMLObject>tempAmlObj
					self.obj = new AMLObject(deref(amlObj.obj))
				else:
					log.debug("pyAMLObject: Invalid argument type caught")
					__invalidInputException("Invalid argument type")
			elif argsLen is 2:
				log.debug("pyAMLObject: Constructor called with 2 args")
				deviceId, timeStamp = args
				self.obj = new AMLObject(deviceId, timeStamp)
			elif argsLen is 3:
				log.debug("pyAMLObject: Constructor called with 3 args")
				deviceId, timeStamp, objId = args
				self.obj = new AMLObject(deviceId, timeStamp, objId)
			else:
				log.debug("pyAMLObject: Constructor with invalid number of args")
				__invalidInputException("Invalid number of arguments")
		else:
			#empty constructor
			log.debug("pyAMLObject: Empty constructor envoked here")
			pass
	def __dealloc__(self):
		if self.obj is not NULL:
			log.debug("pyAMLObject: Deleting native object here")
			del self.obj
	def addData(self, name, pyAMLData d):
		'''
		This function adds AMLData to AMLObject using AMLData key that matches AMLData value.
		@param name: AMLData key.
		@param data: pyAMLData value.
		'''
		try:
			log.debug("pyAMLObject: addData being called here")
			self.obj.addData(name, d.data)
		except Exception as e:
			__invalidInputException(e)	

	def getData(self, name):
		'''
		This function return pyAMLData which matched input name string with AMLObject's amlDatas key.
		@param name: String value to use matching with key.
		@return pyAMLData: containing AMLData that have sub key value fair.
		'''
		try:
			log.debug("pyAMLObject: getdata being called here")
			amlData = pyAMLData()
			log.debug("pyAMLObject: created pyAMLData object here")
			amlData.data = self.obj.getData(name)
			return amlData
		except Exception as e:
			__invalidInputException(e)

	def getDataNames(self):
		'''
		This function return string list about AMLObject's amlDatas keys string array.
		@return vector[string] : vector of string data's keys value list.
		'''
		log.debug("pyAMLObject: getDataNames called here")
		return self.obj.getDataNames()

	def getDeviceId(self):
		'''
		This function return Device's ID saved on AMLObject.
		@return string: String value of device's Id.
		'''
		log.debug("pyAMLObject: get device id called here")
		return self.obj.getDeviceId()

	def getTimeStamp(self):
		'''
		This function return timestamp that deliveried device.
		@return string: String value of timestamp.
		'''
		log.debug("pyAMLObject: get time stamp called here")
		return self.obj.getTimeStamp()

	def getId(self):
		'''
		This function return ID that AMLObject.
		@return string: String value of AMLObject Id.
		'''
		log.debug("pyAMLObject: get id called here")
		return self.obj.getId()

cdef class pyRepresentation:
	'''
	This class provides API's for inter-conversion between
	AMLObject, AML(XML) string, AML(protobuf) byte.
	The constructor creates a new Representation class instance
        and stores it in a pointer to a native object.
	@param amlFilePath: Path of AML that contains a data model information.
	@usage:
		a. localRep = pyRepresentation("data_model.aml")
	'''
	cdef Representation* rep
	def __cinit__(self, amlFilePath):
		try:
			log.debug("pyRepresentation: Constructor called with file ", amlFilePath)
			self.rep = new Representation(amlFilePath)
		except Exception as e:
			__invalidInputException(e)
	def __dealloc__(self):
		if self.rep is not NULL:
			log.debug("pyRepresentation: Deleting native object")
			del self.rep
	def DataToAml(self, pyAMLObject amlObj):
		'''
		This function converts AMLObject to AML(XML) string to match the AML model
		 information which is set by constructor.
		@param amlObj: AMLObject to be converted.
		@return: AML(XML) string converted from amlObject.'''
		try:
			log.debug("pyRepresentation: Converting data to AML data here")
			return self.rep.DataToAml(deref(amlObj.obj))
		except Exception as e:
			__invalidInputException(e)
	def AmlToData(self, xmlString):
		'''
		This function converts AML(XML) string to AMLObject to match the AML model
		 information which is set by constructor.
		@param xmlString: AML(XML) string to be converted.
		@return: pyAMLObject containg AMLObject instance converted from AML(XML) string.
		@note: AMLObject instance will be allocated and returned, so it should be deleted after use.'''
		try:
			log.debug("pyRepresentation: Converting AML to data here")
			amlObj = pyAMLObject()
			log.debug("pyRepresentation: Created a new pyAMLObject here")
			amlObj.obj = self.rep.AmlToData(xmlString)
			return amlObj
		except Exception as e:
			__invalidInputException(e)
	def DataToByte(self, pyAMLObject amlObj):
		'''
		This function converts AMLObject to Protobuf byte data to match the AML model
		 information which is set by constructor.
		@param amlObj: AMLObject to be converted.
		@return: Protobuf byte data(string) converted from amlObject.
		'''
		try:
			log.debug("pyRepresentation: Converting data to byte here")
			return self.rep.DataToByte(deref(amlObj.obj))
		except Exception as e:
			__invalidInputException(e)
	def ByteToData(self, byte):
		'''
		This function converts Protobuf byte data to AMLObject to match the AML model
                information which is set by constructor.
		@param byte: protobuf byte data to be converted.
		@return: pyAMLObject instance converted from amlObject.
		'''
		try:
			log.debug("pyRepresentation: Converting byte to data here")
			amlObj = pyAMLObject()
			log.debug("pyRepresentation: Created a new pyAMLObject here")
			amlObj.obj = self.rep.ByteToData(byte)
			return amlObj
		except Exception as e:
			__invalidInputException(e)
	def getRepresentationId(self):
		'''
		This function returns AutomationML SystemUnitClassLib's unique ID
		@return : string value of AML SystemUnitClassLIb's ID'''
		log.debug("pyRepresentation: getRepresentation ID called here")
		return self.rep.getRepresentationId()
	def getConfigInfo(self):
		'''
		This function returns AMLObject that contains configuration data
		 which is present in RoleClassLib.
		@return: pyAMLObject containing AMLObject that has configuration data.'''
		log.debug("pyRepresentation: getConfig info called here")
		amlObj = pyAMLObject()
		log.debug("pyRepresentation: created a new pyAMLObject object here")
		amlObj.obj = self.rep.getConfigInfo()
		return amlObj
