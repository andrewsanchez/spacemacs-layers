;;; packages.el --- %LAYER_NAME% layer packages file for Spacemacs.
;;
;; Copyright (c) 2012-2020 Sylvain Benner & Contributors
;;
;; Author: %USER_FULL_NAME% <%USER_MAIL_ADDRESS%>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3
;; Briefly, each package to be installed or configured by this layer should be
;; added to `%LAYER_NAME%-packages'. Then, for each package PACKAGE:
;;
;; - If PACKAGE is not referenced by any other Spacemacs layer, define a
;;   function `%LAYER_NAME%/init-PACKAGE' to load and initialize the package.

;; - Otherwise, PACKAGE is already referenced by another Spacemacs layer, so
;;   define the functions `%LAYER_NAME%/pre-init-PACKAGE' and/or
;;   `%LAYER_NAME%/post-init-PACKAGE' to customize the package as it is loaded.

;;; Code:

(defconst anki-packages
  '((anki-editor :location elpa)))

(defun anki/init-anki-editor ()
   (use-package anki-editor
     :defer t
     :commands (anki-editor-cloze anki-editor-cloze-dwim anki-editor-cloze-region)
     :bind ("C-." . anki-editor-mode)))


;;; packages.el ends here
