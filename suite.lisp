(in-package #:cxml-tests)

(def-suite cxml)

(in-suite cxml)

(test parse-rod
  (finishes (cxml:parse-rod "<div>hello <i>world</i></div>" nil)))

;; (def-suite defused-xml :in cxml)

;; (in-suite defused-xml)

;; (test simple-parse (finishes (parse-test-file xml-simple)))
;; (test simple-parse-ns (finishes (parse-test-file xml-simple-ns)))

;; (test entities-forbidden
;;   (flet ((forbidden (file)
;;            (signals cxml:entities-forbidden
;;              (parse-test-file file))))
;;     (forbidden xml-bomb)
;;     (forbidden xml-quadratic)
;;     (forbidden xml-external)))

;; (test entity-cycle
;;   (signals cxml:well-formedness-violation
;;     (parse-test-file xml-cyclic :forbid-entities nil)))

;; (test dtd-forbidden
;;   (flet ((forbidden (file)
;;            (signals cxml:dtd-forbidden
;;              (parse-test-file file :forbid-dtd t))))
;;     (forbidden xml-bomb)
;;     (forbidden xml-quadratic)
;;     (forbidden xml-external)
;;     (forbidden xml-dtd)))

;; (test dtd/external-ref
;;   (signals cxml:external-reference-forbidden
;;     (parse-test-file xml-dtd)))

;; (test external-ref
;;   (signals cxml:external-reference-forbidden
;;     (parse-test-file xml-external :forbid-entities nil)))

;; (test external-file-ref
;;   (signals cxml:external-reference-forbidden
;;     (parse-test-file xml-external-file :forbid-entities nil)))

;; (test allow-expansion
;;   (finishes (parse-test-file xml-bomb2 :forbid-entities nil)))

;;; (in-suite cxml)

(test dtd-embedding
  ;; https://stackoverflow.com/questions/26738465/non-valid-output-of-broadcast-handler-in-common-lisp-closure-xml-package/28528117#28528117
  (let ((teste
          (with-output-to-string (out)
            (let ((h (make-instance 'cxml:sax-proxy :chained-handler (cxml:make-character-stream-sink out))))
              (cxml:parse (test-file-path xml-harem) h
                          :validate t
                          :forbid-external nil
                          :allow-other-keys t)))))
    (is (equal teste (read-file-into-string (test-file-path xml-teste))))))

(def-suite xmlconf :in cxml)

(in-suite xmlconf)

(defun run-xmlconf-suite (name)
  (let ((cxml-tests.xmlconf:*debug-tests*
          (eql *on-error* :debug)))
    (cxml-tests.xmlconf:run-all-tests name)))

(defun compare-results (fn)
  (handler-bind ((warning #'muffle-warning)
                 (puri:uri-parse-error
                   (lambda (e) (declare (ignore e))
                     (when (find-restart 'cxml-tests.xmlconf:skip-test)
                       (invoke-restart 'cxml-tests.xmlconf:skip-test)))))
    (let ((results (run-xmlconf-suite fn)))
      (is-true results))))

(test sax
  (compare-results 'cxml-tests.xmlconf:sax-test))

(test klacks
  (compare-results 'cxml-tests.xmlconf:klacks-test))
