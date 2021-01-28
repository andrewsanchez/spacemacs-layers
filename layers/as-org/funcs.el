(defun as/verify-refile-target ()
  "Exclude todo keywords with a done state from refile targets"
  (not (member (nth 2 (org-heading-components)) org-done-keywords)))
(setq org-refile-target-verify-function 'as/verify-refile-target
      org-refile-allow-creating-parent-nodes 'confirm
      org-src-fontify-natively t
      org-duration-format (quote h:mm))

(defun as/tangle-dotfiles ()
  "If the current file matches 'as-.+org$', tangle blocks."
  (when (string-match "as-.+org$" (buffer-file-name))
    (org-babel-tangle)
    (message "%s tangled" buffer-file-name)))
(add-hook 'after-save-hook #'as/tangle-dotfiles)

(setq org-src-window-setup (quote current-window)
      org-confirm-babel-evaluate nil)
(org-babel-do-load-languages
 'org-babel-load-languages
 '((python . t)
   (emacs-lisp . t)
   (shell . t)))

(defun org-archive-done-tasks-agenda ()
  (interactive)
  (org-map-entries
   (lambda ()
     (org-archive-subtree)
     (setq org-map-continue-from (outline-previous-heading))) "/DONE" 'agenda))

(defun org-archive-done-tasks-buffer ()
  (interactive)
  (org-map-entries
   (lambda ()
     (org-archive-subtree)
     (setq org-map-continue-from (outline-previous-heading))) "/DONE" 'file))

(defun transform-square-brackets-to-round-ones(string-to-transform)
  "Transforms [ into ( and ] into ), other chars left unchanged."
  (concat (mapcar #'(lambda (c) (if (equal c ?\[) ?\( (if (equal c ?\]) ?\) c))) string-to-transform)))