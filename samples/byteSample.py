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
'''

import sys
sys.path.append("..")
from build import amlcy as aml

def printAMLData(amlData, depth):
	tab = "		"
	i = 1
	indent = ""
	while i < depth:
		indent += tab
		i += 1
	print indent, "{"
	keys = amlData.getKeys()
	
	for key in keys:
		vType = amlData.getValueType(key)
		#if vType == "String":
		if vType == [0]:
			print indent+tab+"\""+key+"\" : "+amlData.getValueToStr(key)
		#elif vType == "StringArray":
		elif vType == [1]:
			print indent+tab+"\""+key+"\" : ", amlData.getValueToStrArr(key)
		else:
			print indent+tab+"\""+key+"\""
			amlDataElements = amlData.getValueToAMLData(key)
			printAMLData(amlDataElements, depth+1)
	print indent, "}"
	

def printAMLObject(amlObject):
	print "\n=================================================================="
	print "\"DEVICE ID\" : ", amlObject.getDeviceId()
	print "\"TIMESTAMP\" : ", amlObject.getTimeStamp()
	print "\"ID\"        : ", amlObject.getId()
	
	dataNames = amlObject.getDataNames()
	for elem in dataNames:
		print "DataName : \"",elem,"\""
		data = amlObject.getData(elem)

		printAMLData(data, 1)
	print "\n=================================================================="

#Main block
try:
	localRep = aml.pyRepresentation("data_model.aml")
except OSError as e:
	print e, "\nEXITING SAMPLE DUE TO ERROR"
	sys.exit()

deviceId = "GTC001"
timeStamp = "123456789"

amlObject = aml.pyAMLObject(deviceId, timeStamp)

model = aml.pyAMLData()
model.setValue("ctname", "Model_107.113.97.248")
model.setValue("con", "SR-P7-970")

axis = aml.pyAMLData()
axis.setValue("x", "20")
axis.setValue("y", "110")
axis.setValue("z", "80")

infoSample = aml.pyAMLData()
infoSample.setValue("id", "f437da3b")
infoSample.setValue("axis", axis)

appendix = ["12303", "935", "1442"]
sampleData = aml.pyAMLData()
sampleData.setValue("info", infoSample)
sampleData.setValue("appendix", appendix)

# Add Datas to AMLObject
amlObject.addData("Model", model)
amlObject.addData("Sample", sampleData)

# Convert AMLObject to AMLstring(XML)
aml_string =  localRep.DataToAml(amlObject)

# Convert AMLstring(XML)
data_from_aml = localRep.AmlToData(aml_string)

byte_string = localRep.DataToByte(data_from_aml)
print byte_string

print "---------------------------------------------------------------------------"

data_from_byte = localRep.ByteToData(byte_string)
printAMLObject(data_from_byte)

print "---------------------------------------------------------------------------"
