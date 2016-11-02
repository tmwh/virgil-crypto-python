import os
import sys
import shutil
from distutils import sysconfig
from distutils.command.build import build as _build
from distutils.command.build_ext import build_ext as _build_ext

from distutils.spawn import spawn
from setuptools import setup, Extension

try:
    THIS_FILE = __file__
except NameError:
    THIS_FILE = sys.argv[0]
THIS_FILE = os.path.abspath(THIS_FILE)

if os.path.dirname(THIS_FILE):
    os.chdir(os.path.dirname(THIS_FILE))
SCRIPT_DIR = os.getcwd()

def run_process(args):
    spawn(args)

class VirgilBuild(_build):
    def __init__(self, *args, **kwargs):
        _build.__init__(self, *args, **kwargs)

    def run(self):
        crypto_dir = os.path.join(SCRIPT_DIR, "src", "virgil-crypto")
        os.chdir(crypto_dir)
        build_prefix = os.path.join(SCRIPT_DIR, "_build")
        install_prefix = SCRIPT_DIR
        install_dir = "virgil_crypto"
        VirgilBuild.cleanup_dir(build_prefix)

        cmake_build_command = [
            "cmake",
            "-H.",
            "-B%s" % build_prefix,
            "-DPYTHON_INCLUDE_DIR=%s" % sysconfig.get_python_inc(),
            "-DPYTHON_LIBRARY=%s" % sysconfig.get_config_var("LIBDIR"),
            "-DCMAKE_INSTALL_PREFIX=%s" % install_prefix,
            "-DINSTALL_API_DIR_NAME=%s" % install_dir,
            "-DINSTALL_LIB_DIR_NAME=%s" % install_dir,
            "-DLANG=python"
        ]
        run_process(cmake_build_command)
        cmake_install_command = [
            "cmake",
            "--build",
            build_prefix,
            "--target",
            "install"
        ]
        run_process(cmake_install_command)
        os.chdir(SCRIPT_DIR)
        VirgilBuild.cleanup_dir(build_prefix)

    @staticmethod
    def cleanup_dir(path):
        shutil.rmtree(path, ignore_errors=True)

class VirgilBuildExt(_build_ext):
    def __init__(self, *args, **kwargs):
        _build_ext.__init__(self, *args, **kwargs)

    def run(self):
        return

setup(
    name="virgil-crypto",
    version="2.0.0b1",
    author="Virgil Security",
    url="https://virgilsecurity.com/",
    classifiers=[
        "Development Status :: 4 - Beta",
        "License :: OSI Approved :: BSD License",
        "Natural Language :: English",
        "Programming Language :: C++",
        "Programming Language :: Python :: 2.7",
        "Programming Language :: Python :: 3.4",
        "Programming Language :: Python :: 3.5",
        "Topic :: Security :: Cryptography",
    ],
    license="BSD",
    packages=["virgil_crypto"],
    include_package_data=True,
    zip_safe=False,
    long_description="Virgil Crypto library wrapper",
    cmdclass={
        'build': VirgilBuild,
        'build_ext': VirgilBuildExt,
    },
    ext_modules=[Extension('_virgil_crypto_python', [])],
    ext_package='virgil_crypto'
)
