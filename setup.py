# -*- coding: utf-8 -*-
# ##### BEGIN GPL LICENSE BLOCK #####
#
#  This program is free software; you can redistribute it and/or
#  modify it under the terms of the GNU General Public License
#  as published by the Free Software Foundation; either version 3
#  of the License, or (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program; If not, see <http://www.gnu.org/licenses/>.
#
# ##### END GPL LICENSE BLOCK #####

__author__ = "Alberto López Sánchez"
__email__ = "alopez@cells.es"
__copyright__ = "Copyright 2021, CELLS / ALBA Synchrotron"
__license__ = "GPLv3+"
__version__ = '0.0.1'

from distutils.core import setup
from distutils.extension import Extension
from Cython.Build import cythonize
import numpy

extensions = [
    Extension("adlink",
              sources=["d2kdask.pyx"],
              include_dirs=[numpy.get_include(),
                            '/usr/local/src/adlink/include'],
              library_dirs=['/usr/local/src/adlink/lib'],
              libraries=['pci_dask2k64'],
              extra_compile_args=["-O3"],
              language="c++")
]

setup(
    name="adlink",
    version=__version__,
    license=__license__,
    author=__author__,
    author_email=__email__,
    ext_modules=cythonize(extensions),
)