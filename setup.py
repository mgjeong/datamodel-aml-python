'''
Setup file for building datamodel-aml-python.'''

print "\n********************** Build Starting ***************************\n"

from distutils.core import setup
from distutils.extension import Extension
from Cython.Distutils import build_ext
from Cython.Build import cythonize
import numpy, sys, os, platform

extlibs = "dependencies/"
aml = "datamodel-aml-cpp/"
amlcpp = extlibs + aml

target_os = sys.platform
lib_lang='c++'
inc_dirs = []
extra_objs = []
compile_flags = []
lib_ext = ".so"
compiler_directives = {}
define_macros = []
log_level='warn'
DEBUG=False

if '--debug' in sys.argv:
	DEBUG=True

if DEBUG:
	print "Building in DEBUG mode."
	log_level='debug'
	compiler_directives['profile'] = True
	compiler_directives['linetrace'] = True
	define_macros.append(('CYTHON_TRACE', '1'))
	define_macros.append(('CYTHON_TRACE_NOGIL', '1'))
	extra_objs.append("-fprofile-arcs")
	compile_flags.append("-fprofile-arcs")
	compile_flags.append("-ftest-coverage")

inc_dirs.append("include/")
inc_dirs.append(amlcpp + "include")

if target_os == "linux2":

	target_arch = platform.machine()

	if target_arch in ['i686', 'x86']:
		if DEBUG:
			extra_objs.append(amlcpp + "out/linux/x86/debug/libaml.a")
		else:
			extra_objs.append(amlcpp + "out/linux/x86/release/libaml.a")
		extra_objs.append("/usr/local/lib/libprotobuf.a")
	elif target_arch in ['x86_64']:
		if DEBUG:
			extra_objs.append(amlcpp + "out/linux/x86_64/debug/libaml.a")
		else:
			extra_objs.append(amlcpp + "out/linux/x86_64/release/libaml.a")
		extra_objs.append("/usr/local/lib/libprotobuf.so")
	else:
		print "Error : Target Arch not supported ", target_arch
		exit()
	
	compile_flags.append("-std=c++0x")

else:
	print "TARGET OS :: ", target_os, " NOT SUPPORTED"
	print "Build Errors."
	exit()
	
src = "amlcy.pyx"
moduleName = "amlcy"
target = "build." + moduleName

ext_modules = [Extension(target, [src],
                     include_dirs = inc_dirs,
					 language = lib_lang,
                     extra_objects = extra_objs,
					 extra_compile_args = compile_flags,
					 define_macros=define_macros,
					 )]

setup(
  name = moduleName,
  cmdclass = {'build_ext': build_ext},
  ext_modules = cythonize(ext_modules, compiler_directives=compiler_directives,
		compile_time_env={'LOG_LEVEL':log_level}),
  include_dirs=[numpy.get_include(), "include/"],
)
	
if os.path.isfile("build/" + moduleName + lib_ext):
  print "\nSuccessful cython build\n"
else:
  print "\n Cython Build Failed with Errors."
	
print "\n********************** Build Terminated *************************\n"
