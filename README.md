# Adlink D2K Boards Python Library

Python abstraction of the C API using Cython.

## Build

Be sure that exist a simbolic link named "driver" to the location where the 
Adlink SDK is located. Then run:
```
./build.sh
```

## Samples

### AIFile
```
PYTHONPATH=$PWD python3 samples/AIFile.py
```