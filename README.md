This repository contains the test suite for CXML.

To run:

``` lisp
(asdf:load-system :cxml-tests)
(cxml-tests:run-tests)
```

CXML never passed the entire test suite; expect a baseline of five failures each for SAX and Klacks.
