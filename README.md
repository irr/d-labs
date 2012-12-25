d-labs
-----------

**d-labs**  is a set of sample codes whose main purpose is to experiment and test [D] programming language

Compiler
-----------

*/etc/dmd.conf*
```shell
[Environment]

DFLAGS=-I/data/D/libevent -L-levent -I/data/D/openssl -L-lssl -I%@P%/../../src/phobos -I%@P%/../../src/druntime/import -L-L%@P%/../lib64 -L-L%@P%/../lib32 -L--no-warn-search-mismatch -L--export-dynamic
```

Dependencies
-----------

* [openssl]: D version of the C headers for openssl 
* [libevent]: libevent is an asynchronous event notification software library
* [libevent2]: libevent API provides a mechanism to execute a callback function when a specific event occurs on a file descriptor or after a timeout has been reached


Copyright and License
-----------

Copyright 2012 Ivan Ribeiro Rocha

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
  
[openssl]: https://github.com/D-Programming-Deimos/openssl
[libevent]: https://github.com/D-Programming-Deimos/libevent
[libevent2]: http://libevent.org/
