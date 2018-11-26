(setq as/org (concat (getenv "HOME") "/org/")
      as/agenda (concat as/org "agenda/")
      as/views (concat (getenv "HOME") "/org/views/")
      as/gtd (concat as/org "gtd.org"))
(setq org-default-notes-file "/Users/andrew/org/notes.org")
(setq org-hide-leading-stars t)
(setq org-todo-keywords
  '((sequence "TODO" "|" "DONE")))
(setq org-refile-targets '((nil :maxlevel . 3)
                       (org-agenda-files :maxlevel . 2)))
(setq org-outline-path-complete-in-steps nil)
(setq org-completion-use-ido nil)
(setq org-refile-use-outline-path t) 
(defun as/verify-refile-target ()
  "Exclude todo keywords with a done state from refile targets"
  (not (member (nth 2 (org-heading-components)) org-done-keywords)))
(setq org-refile-target-verify-function 'as/verify-refile-target)
(setq org-refile-allow-creating-parent-nodes 'confirm)
(setq org-src-fontify-natively t)
;; (add-to-list 'org-modules 'org-habit)
(setq org-duration-format (quote h:mm))

(defun as/tangle-dotfiles ()
  "If the current file matches 'as-.+org$', tangle blocks."
  (when (string-match "as-.+org$" (buffer-file-name))
    (org-babel-tangle)
    (message "%s tangled" buffer-file-name)))
(add-hook 'after-save-hook #'as/tangle-dotfiles)
(setq org-src-window-setup (quote current-window))
(org-babel-do-load-languages
 'org-babel-load-languages
 '(
   (python . t)
   (emacs-lisp . t)
   (shell . t)))
 (setq org-confirm-babel-evaluate nil)

(setq org-capture-templates
      '(("t" "TODO" entry (file+headline as/gtd "Collect")
         "* TODO %? %^G \n  %U" :empty-lines 1)
        ("s" "Scheduled TODO" entry (file+headline as/gtd "Collect")
         "* TODO %? %^G \nSCHEDULED: %^t\n  %U" :empty-lines 1)
        ("d" "Deadline" entry (file+headline as/gtd "Collect")
         "* TODO %? %^G \n  DEADLINE: %^t" :empty-lines 1)
        ("p" "Priority" entry (file+headline as/gtd "Collect")
         "* TODO [#A] %? %^G \n  SCHEDULED: %^t")
        ("a" "Appointment" entry (file+headline as/gtd "Collect")
         "* %? %^G \n  %^t")
        ("b" "Bookmark" entry (file+headline as/gtd "Bookmarks")
         "* %:annotation\n%u\n\n%i" :empty-lines 1)
        ("n" "Note" entry (file+headline as/gtd "Notes")
         "* %? %^G\n%U" :empty-lines 1)
        ("j" "Journal" entry (file+datetree "/Users/andrew/org/agenda/journal.org")
        "* %? %^G\nEntered on %U\n")))

(setq org-agenda-files
      '("/Users/andrew/org/gtd.org"
        "/Users/andrew/org/PMI/PMI.org"
        "/Users/andrew/org/Fluent-Forever/Fluent-Forever.org"))
(setq org-agenda-include-diary t)
(setq org-tag-persistent-alist '(("work" . ?w)
                                  ("buy" . ?b)
                                  ("sdm" . ??)
                                  ("X" . ?x)
                                  ("misc" . ?m)
                                  ("finance" . ?f)
                                  ("read" . ?r)
                                  ("school" . ?s)))

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

;;  (setq org-agenda-sorting-strategy
;;        '((agenda timestamp-up category-up priority-down)
;;          (todo priority-down timestamp-up category-up)
;;          (tags priority-down timestamp-up category-up)
;;          (search category-up timestamp-up)))

(setq org-deadline-warning-days 10)
 (setq org-agenda-custom-commands
       `(("a" "Current day/week" agenda "" ((org-agenda-span 5)) 
          (,(concat as/agenda "agenda.ics")
           ,(concat as/agenda "agenda.html")))
         ("A" "Agenda" agenda "" ((org-agenda-category-filter-preset '("-habit"))))
         ("p" "PMI"
          ((tags-todo "gbqc+TODO=\"TODO\"+category=\"PMI\"") 
           (tags-todo "ncbitk+TODO=\"TODO\"+category=\"PMI\""))
          ((org-agenda-overriding-header ""))
          (,(concat as/org "PMI/PMI-all-todos.org")))
         ("f" "Fluent Forever"
          ((tags-todo "category={Fluent Forever}+TODO={TODO\\|WAITING}"))
          ((org-agenda-overriding-header ""))
          (,(concat as/org "Fluent-Forever/Fluent-Forever.html")))
         ("A" "ALL" ((alltodo))
          ((org-agenda-overriding-header "All")
           (org-agenda-sorting-strategy '(priority-down)))
           ,(concat as/agenda "all.html"))))

(defhydra hydra-org-mode ()
  "Org-mode"
  ("t" org-todo "org-todo")
  (":" org-set-tags-command "org-set-tags-command")
  ("n" org-narrow-to-subtree "org-narrow-to-subtree")
  ("w" widen "widen")
  ("s" org-sort)
  ("l" org-demote-subtree "org-demote-subtree")
  ("h" org-promote-subtree "org-promote-subtree")
  ("K" outline-up-heading "org-backward-heading-same-level")
  ("J" org-forward-heading-same-level "org-forward-heading-same-level")
  ("k" outline-previous-visible-heading "outline-previous-visible-heading")
  ("j" outline-next-visible-heading "outline-next-visible-heading")
  ("*" org-toggle-heading "org-toggle-heading")
  ("$" org-archive-done-tasks "org-archive-done-tasks"))
  (evil-leader/set-key-for-mode 'org-mode "m" 'hydra-org-mode/body)

(defhydra hydra-org-clock (:color blue :hint nil)
        "
        Clock   In/out^     ^Edit^   ^Summary     (_?_)
        -----------------------------------------
                _i_n         _e_dit   _g_oto entry
                _c_ontinue   _q_uit   _d_isplay
                _o_ut        ^ ^      _r_eport
                _p_omodoro
        "
        ("i" org-clock-in)
        ("o" org-clock-out)
        ("c" org-clock-in-last)
        ("e" org-clock-modify-effort-estimate)
        ("q" org-clock-cancel)
        ("p" org-pomodoro)
        ("g" org-clock-goto)
        ("d" org-clock-display)
        ("r" org-clock-report)
        ("?" (org-info "Clocking commands")))

(defhydra hydra-org-template (:color blue :hint nil)
  "
_c_enter  _q_uote    _L_aTeX:
_l_atex   _e_xample  _i_ndex:
_a_scii   _v_erse    _I_NCLUDE:
_s_rc     ^ ^        _H_TML:
_h_tml    ^ ^        _A_SCII:
"
  ("s" (hot-expand "<s"))
  ("e" (hot-expand "<e"))
  ("q" (hot-expand "<q"))
  ("v" (hot-expand "<v"))
  ("c" (hot-expand "<c"))
  ("l" (hot-expand "<l"))
  ("h" (hot-expand "<h"))
  ("a" (hot-expand "<a"))
  ("L" (hot-expand "<L"))
  ("i" (hot-expand "<i"))
  ("I" (hot-expand "<I"))
  ("H" (hot-expand "<H"))
  ("A" (hot-expand "<A"))
  ("<" self-insert-command "ins")
  ("o" nil "quit"))

(defun hot-expand (str)
  "Expand org template."
  (insert str)
  (org-try-structure-completion))

  (define-key org-mode-map "<"
  (lambda () (interactive)
     (if (looking-back "^")
         (hydra-org-template/body)
 (self-insert-command 1))))

(setq 
 org-export-with-toc nil
 org-export-with-section-numbers nil)
