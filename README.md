# DataModel AML library (python)
datamodel-aml-python is a wrapper on top of the datamodel-aml-cpp library which provides the way to present raw data(key/value based) to AutomationML(AML) standard format.
 - Transform raw data to AML data(XML).
 - Serialization / Deserialization AML data using protobuf.
 
 ## Prerequisites ##
- SCons
  - Version : 2.3.0 or above
  - [How to install](http://scons.org/doc/2.3.0/HTML/scons-user/c95.html)

- Protobuf
  - Version : 3.4.0(mandatory)
  - Protobuf will be installed by build option (See 'How to build')
  - Refer to the links below for manual installation.
    - [Where to download](https://github.com/google/protobuf/releases/tag/v3.4.0)
    - [How to install](https://github.com/google/protobuf/blob/master/src/README.md)
	
	
## How to build ##

AUTO BUILD : 
===============
1. Goto: ~/datamodel-aml-python/
2. Run the script:
	$ ./build_auto.sh --with_dependencies=true --target_arch=x86 [with dependency]
		OR
	$ ./build_auto.sh --with_dependencies=false --target_arch=x86 [without dependency]
3. Run samples : 
	Goto: ~/datamodel-aml-python/samples/
	Place a datamodel.aml file in samples folder
	$ python samples.python []
