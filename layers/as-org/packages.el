(defconst as-org-packages
  '(org
    org-drill))

(defun as-org/init-org-drill ()
  (use-package org-drill
    :defer t))


(defun as-org/pre-init-org ()
  (spacemacs|use-package-add-hook org
    :post-config
    (require 'org-drill)))

(defun as-org/post-init-org ()
  (add-to-list 'org-modules 'org-protocol)
  (add-to-list 'org-modules 'org-habit))
