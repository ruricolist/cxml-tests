(defsystem "cxml-tests"
  :serial t
  :perform (test-op (o c) (uiop:symbol-call :cxml-tests :run-tests))
  :components ((:file "test")
               (:file "xmlconf")
               (:file "suite"))
  :depends-on ("uiop"
               "fiveam"
               "cxml"
               "alexandria"))
