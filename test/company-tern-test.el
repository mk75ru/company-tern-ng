;;; relative-buffers-test.el --- relative-buffers test suite

;;; Commentary:

;;; Code:

(require 'ert)
(require 'company-tern)

;;; Align functions and variables.

(ert-deftest test-company-tern-function-p ()
  (should (company-tern-function-p "fn(i: number)")))

(ert-deftest test-company-tern-function-p-with-number ()
  (should (null (company-tern-function-p "number"))))

(ert-deftest test-company-tern-function-type ()
  (let (company-tooltip-align-annotations)
    (should (s-equals? (company-tern-function-type
                        "fn(test: fn(elt: ?, i: number) -> bool, context?: ?) -> bool")
                       "(test, context?)"))))

(ert-deftest test-company-tern-function-type-align-annotation ()
  (let ((company-tooltip-align-annotations t))
    (should (s-equals? (company-tern-function-type
                        "fn(test: fn(elt: ?, i: number) -> bool, context?: ?) -> bool")
                       "fn(test, context?)"))))

(ert-deftest test-company-tern-variable-type ()
  (let ((company-tooltip-align-annotations t))
    (should (s-equals? "number" (company-tern-variable-type "number")))))

(ert-deftest test-company-tern-variable-type-align-annotation ()
  (let (company-tooltip-align-annotations)
    (should (s-equals? " -> number" (company-tern-variable-type "number")))))

;;; Properties marker.

(ert-deftest test-company-tern-property-p ()
  (let ((candidate "property"))
    (put-text-property 0 1 'isProperty t candidate)
    (should (company-tern-property-p candidate))))

(ert-deftest test-company-tern-not-a-property-p ()
  (let ((candidate "other"))
    (put-text-property 0 1 'isProperty json-false candidate)
    (should-not (company-tern-property-p candidate))))

;;; Keywords.

(ert-deftest test-company-tern-keyword-annotation ()
  (let ((candidate "keyword")
        (company-tooltip-align-annotations t))
    (put-text-property 0 1 'type "?" candidate)
    (put-text-property 0 1 'isKeyword t candidate)
    (should (s-equals? ":keyword" (company-tern-get-type candidate)))))

(ert-deftest test-company-tern-keyword-format-annotation ()
  (let ((candidate "keyword"))
    (put-text-property 0 1 'isKeyword t candidate)
    (should (s-equals? " -> :keyword" (company-tern-get-type candidate)))))

;;; Process candidates.

(ert-deftest test-company-tern-format-candidates ()
  (let ((candidate (car (company-tern-format-candidates
                         '((completions . [((isKeyword . t) (depth . 0) (name . "var"))])
                           (isProperty . nil)
                           (end . 1)
                           (start . 0))))))
    (should (s-equals? candidate "var"))
    (should (get-text-property 0 'isKeyword candidate))
    (should-not (get-text-property 0 'isProperty candidate))))

;;; Sort by depth.

(provide 'company-tern-test)

;;; company-tern-test.el ends here
