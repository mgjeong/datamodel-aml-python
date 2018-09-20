import sys, unittest
sys.path.append("..")
sys.path.append(".")
from build import amlcy as aml

sampleFilePath = "../samples/data_model.aml"

class AMLTests(unittest.TestCase):

	def setUp(self):
		print "\n==========================================="
                print "Starting Datamodel-AML Tests ", self._testMethodName, "\n"

	def test_pyRepresentation_N(self):
		self.assertRaises(Exception, aml.pyRepresentation, 1234546)
		self.assertRaises(Exception, aml.pyRepresentation, "")
		self.assertRaises(Exception, aml.pyRepresentation, "invalid/path")
		self.assertRaises(Exception, aml.pyRepresentation, "invalidFile.aml")

	def test_pyRepresentation_P(self):
		localRep = aml.pyRepresentation(sampleFilePath)
		self.assertNotEqual(localRep, None)

		repID = localRep.getRepresentationId()
		self.assertEqual(repID, "SAMPLE_Robot_0.0.1")

	def test_pyAMLObject_P1(self):
		localRep = aml.pyRepresentation(sampleFilePath)
		amlObj = localRep.getConfigInfo()
		self.assertNotEqual(amlObj, None)

		self.assertEqual(amlObj.getDeviceId(), "SAMPLE_Robot_Cycle")
		self.assertEqual(amlObj.getTimeStamp(), "0")
		self.assertEqual(amlObj.getId(), "SAMPLE_Robot_Cycle_0")

		testNames = ['Model', 'Sample']
		self.assertEqual(testNames, amlObj.getDataNames())

	def test_pyAMLObject_P2(self):
		deviceId = "SAMPLE001"
		timeStamp = "123456789"

		amlObj = aml.pyAMLObject(deviceId, timeStamp)
		self.assertEqual(amlObj.getDeviceId(), deviceId)
                self.assertEqual(amlObj.getTimeStamp(), timeStamp)
                self.assertEqual(amlObj.getId(), deviceId + "_" + timeStamp)

	def test_pyAMLObject_p3(self):
		deviceId = "SAMPLE001"
		timeStamp = "123456789"
		ID = "SAMPLE_ROBOT_ID_001"

                amlObj = aml.pyAMLObject(deviceId, timeStamp, ID)
                self.assertEqual(amlObj.getDeviceId(), deviceId)
                self.assertEqual(amlObj.getTimeStamp(), timeStamp)
                self.assertEqual(amlObj.getId(), ID)

	def test_pyAMLObject_p4(self):
		deviceId = "SAMPLE001"
                timeStamp = "123456789"
                testAmlObj = aml.pyAMLObject(deviceId, timeStamp)

		amlObj = aml.pyAMLObject(testAmlObj)

		self.assertEqual(amlObj.getDeviceId(), deviceId)
		self.assertEqual(amlObj.getTimeStamp(), timeStamp)
		self.assertEqual(amlObj.getId(), deviceId + "_" + timeStamp)

	def test_pyAMLObject_N(self):
		self.assertRaises(Exception, aml.pyAMLObject, 30)
		self.assertRaises(Exception, aml.pyAMLObject, "junk1")
		self.assertRaises(Exception, aml.pyAMLObject, 30, 20, 15, 10)
		self.assertRaises(Exception, aml.pyAMLObject, "id1", "id2", "id3", "id4")

	def test_pyAMLData_p1(self):
		localRep = aml.pyRepresentation(sampleFilePath)
		amlObj = localRep.getConfigInfo()
		
		dataNames = amlObj.getDataNames()
		values = ['once', '25']
		index = 0
		for elem in dataNames:
			data = amlObj.getData(elem)
			self.assertNotEqual(data, None)
			
			keys = data.getKeys()
			self.assertEqual(keys, ['cycle'])
			for key in keys:
				vType = data.getValueType(key)
				self.assertEqual(vType, [0])
				self.assertEqual(data.getValueToStr(key), values[index])
			index += 1

	def test_pyAMLData_N(self):
		localRep = aml.pyRepresentation(sampleFilePath)
		amlObj = localRep.getConfigInfo()
		dataNames = amlObj.getDataNames()
		index = 0
		for elem in dataNames:
			data = amlObj.getData(elem)

			self.assertRaises(Exception, data.getValueToStr, 300)
			self.assertRaises(Exception, data.getValueToStr, "")
			self.assertRaises(Exception, data.getValueToStr, None)
			self.assertRaises(Exception, data.getValueToStr, "junkKey1")
			self.assertRaises(Exception, data.getValueToStr, "junk2")
			self.assertRaises(Exception, data.getValueToStr, 10.5)

	def test_pyAMLData_p2(self):
		amlObject = aml.pyAMLObject("SAMPLE001", "123456789")

		data1 = aml.pyAMLData()
		self.assertNotEqual(data1, None)
		key1 = "a"
		value1 = "Model_107.113.97.248"
		data1.setValue(key1, value1)
		amlObject.addData("Model", data1)

		#verify
		testNames = ['Model']
		self.assertEqual(testNames, amlObject.getDataNames())

	def test_pyAMLData_p3(self):
		axisNames = ['x', 'y', 'z']
		axisValues = ['20', '110', '80']
		axis = aml.pyAMLData()
		axis.setValue(axisNames[0], axisValues[0])
		axis.setValue(axisNames[1], axisValues[1])
		axis.setValue(axisNames[2], axisValues[2])
		
		infoSample = aml.pyAMLData()
		infoSample.setValue("axis", axis)

		sampleData = aml.pyAMLData()
		sampleData.setValue("info", infoSample)
		
		amlObject = aml.pyAMLObject("SAMPLE001", "123456789")
		amlObject.addData("Sample", sampleData)	
		
		#verify
		dataNames = amlObject.getDataNames()
		self.assertEqual(['Sample'], dataNames)

		data1 = amlObject.getData(dataNames[0])
		dataKeys1 = data1.getKeys()
		self.assertEqual(['info'], dataKeys1)
		self.assertEqual([2], data1.getValueType(dataKeys1[0]))
	
		data2 = data1.getValueToAMLData(dataKeys1[0])
		dataKeys2 = data2.getKeys()
                self.assertEqual(['axis'], dataKeys2)
		self.assertEqual([2], data2.getValueType(dataKeys2[0]))	

		self.assertRaises(Exception, sampleData.getValueToAMLData, "")
		self.assertRaises(Exception, sampleData.getValueToAMLData, "junkKey1")
		self.assertRaises(Exception, sampleData.getValueToAMLData, 452)
		self.assertRaises(Exception, sampleData.getValueToAMLData, None)		
		data3 = data2.getValueToAMLData(dataKeys2[0])
		dataKeys3 = data3.getKeys()
		self.assertEqual(axisNames, dataKeys3)
		self.assertEqual(data3.getValueToStr(dataKeys3[0]), "20")
		self.assertEqual(data3.getValueToStr(dataKeys3[1]), "110")
		self.assertEqual(data3.getValueToStr(dataKeys3[2]), "80")

	def test_pyAMLData_p4(self):
		data1 = aml.pyAMLData()	
		key1 = "a"
		value1 = "Model_107.113.97.248"
		data1.setValue(key1, value1)
		self.assertEqual(value1, data1.getValueToStr(key1))

		data2 = aml.pyAMLData(data1)
		self.assertEqual(value1, data2.getValueToStr(key1))

	def test_pyAMLData_p5(self):

		localRep = aml.pyRepresentation(sampleFilePath)
		amlObject = aml.pyAMLObject("SAMPLE001", "123456789")

		model = aml.pyAMLData()
		model.setValue("a", "Model_107.113.97.248")
		model.setValue("b", "SR-P7-970")

		axis = aml.pyAMLData()
		axis.setValue("x", "20")
		axis.setValue("y", "110")
		axis.setValue("z", "80")
		infoSample = aml.pyAMLData()
		infoSample.setValue("id", "f437da3b")
		infoSample.setValue("axis", axis)
		sampleData = aml.pyAMLData()
		sampleData.setValue("info", infoSample)
		sampleData.setValue("appendix", ["12303", "935", "1442"])

		amlObject.addData("Model", model)
		amlObject.addData("Sample", sampleData)
		
		aml_string =  localRep.DataToAml(amlObject)
		
		data_from_aml = localRep.AmlToData(aml_string)
		byte_string = localRep.DataToByte(data_from_aml)
		data_from_byte = localRep.ByteToData(byte_string)
		
		#validate both objects are equal
		self.assertEqual(data_from_aml.getDeviceId(), data_from_byte.getDeviceId())
		self.assertEqual(data_from_aml.getTimeStamp(), data_from_byte.getTimeStamp())
		self.assertEqual(data_from_aml.getId(), data_from_byte.getId())
		dataNames_aml = data_from_aml.getDataNames()
		dataNames_byte = data_from_byte.getDataNames()
		self.assertEqual(dataNames_aml, dataNames_byte)
		data1_aml = data_from_aml.getData(dataNames_aml[0])
		data2_aml = data_from_aml.getData(dataNames_aml[1])
		data1_byte = data_from_byte.getData(dataNames_byte[0])
		data2_byte = data_from_byte.getData(dataNames_byte[1])
		self.assertEqual(data1_aml.getKeys(), data1_byte.getKeys())
		self.assertEqual(data2_aml.getKeys(), data2_byte.getKeys())
	
	def test_pypyAMLData_p6(self):
		appendix = ["12303", "935", "1442"]
		sampleData = aml.pyAMLData()
		sampleData.setValue("appendix", appendix)
		keys = sampleData.getKeys()

		for key in keys:
			self.assertEqual(sampleData.getValueType(key), [1])
			self.assertEqual(sampleData.getValueToStrArr(key), appendix)
	
	def test_pypyAMLData_N1(self):
		self.assertRaises(Exception, aml.pyAMLData, 45)
		self.assertRaises(Exception, aml.pyAMLData, "a")
		self.assertRaises(Exception, aml.pyAMLData, 45, 50, 12)
		self.assertRaises(Exception, aml.pyAMLData, "junk1", "junk2")

		data1 = aml.pyAMLData()
		key1 = "a"
		self.assertRaises(Exception, data1.setValue)
		self.assertRaises(Exception, data1.setValue, 45)
		self.assertRaises(Exception, data1.setValue, key1, 45)

	def test_pypyAMLData_N2(self):
		sampleData = aml.pyAMLData()
		sampleData.setValue("appendix", ["12303", "935", "1442"])
		keys = sampleData.getKeys()
		
		for key in keys:
			self.assertEqual(sampleData.getValueType(key), [1])
			self.assertRaises(Exception, sampleData.getValueToStrArr, "")
			self.assertRaises(Exception, sampleData.getValueToStrArr, "junkKey1")
			self.assertRaises(Exception, sampleData.getValueToStrArr, 452)
			self.assertRaises(Exception, sampleData.getValueToStrArr, None)

	def tearDown(self):
		print "Completed Datamodel-AML Test ", self._testMethodName

suite = unittest.TestLoader().loadTestsFromTestCase(AMLTests)
unittest.TextTestRunner(verbosity=3).run(suite)

