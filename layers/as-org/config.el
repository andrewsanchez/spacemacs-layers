(require 'org-protocol)
(add-to-list 'org-modules 'org-protocol)
(setq as/org (concat (getenv "HOME") "/org/")
      as/agenda (concat as/org "agenda/")
      as/views (concat (getenv "HOME") "/org/views/")
      as/gtd (concat as/org "gtd.org"))
(setq org-default-notes-file "/Users/andrew/org/notes.org"
      org-hide-leading-stars t
      org-todo-keywords
      '((sequence "TODO" "|" "DONE"))
      org-refile-targets '((nil :maxlevel . 3)
                           (org-agenda-files :maxlevel . 3))
      org-outline-path-complete-in-steps nil
      org-completion-use-ido nil
      org-refile-use-outline-path t)
(defun as/verify-refile-target ()
  "Exclude todo keywords with a done state from refile targets"
  (not (member (nth 2 (org-heading-components)) org-done-keywords)))
(setq org-refile-target-verify-function 'as/verify-refile-target
      org-refile-allow-creating-parent-nodes 'confirm
      org-src-fontify-natively t
      org-duration-format (quote h:mm))
;; (add-to-list 'org-modules 'org-habit)

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
         "* %a\n  %i" :empty-lines 1)
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

(setq org-agenda-sorting-strategy
      '(deadline-up todo-state-up  timestamp-down priority-down))

(setq org-deadline-warning-days 10)
(setq org-agenda-custom-commands
      `(("a" . "Agenda + category")
        ("aa" "Current agenda without habits" agenda ""
         ((org-agenda-span 5)
          (org-agenda-category-filter-preset '("-habit")))
         (,(concat as/agenda "agenda.ics")
          ,(concat as/agenda "agenda.html")))
        ("ap" "PMI Agenda" agenda ""
         ((org-agenda-span 5)
          (org-agenda-category-filter-preset '("+PMI")))
         (,(concat as/org "PMI/PMI_Dev_Plan.html")))
        ("f" "Fluent Forever"
         ((tags-todo "category={FluentForever}"))
         ((org-agenda-overriding-header ""))
         (,(concat as/org "Fluent-Forever/Fluent-Forever.html")))
        ("h" "Habits" agenda "" ((org-agenda-category-filter-preset '("+habit"))))
        ("A" "All TODOs" ((alltodo))
         ((org-agenda-overriding-header "All TODOs")
          (org-agenda-sorting-strategy '(priority-down)))
         ,(concat as/agenda "all.html"))
        ;; Taken from https://orgmode.org/worg/org-tutorials/org-custom-agenda-commands.html#org7806649
        ("P" "Printed agenda"
         ((agenda "" ((org-agenda-span 7)                      ;; overview of appointments
                      (org-agenda-start-on-weekday nil)         ;; calendar begins today
                      (org-agenda-repeating-timestamp-show-all t)
                      (org-agenda-entry-types '(:timestamp :sexp))))
          (agenda "" ((org-agenda-span 1)                      ; daily agenda
                      (org-deadline-warning-days 7)            ; 7 day advanced warning for deadlines
                      (org-agenda-todo-keyword-format "[ ]")
                      (org-agenda-scheduled-leaders '("" ""))
                      (org-agenda-prefix-format "%t%s")))
          (todo "TODO"                                          ;; todos sorted by context
                ((org-agenda-prefix-format "[ ] %T: ")
                 (org-agenda-sorting-strategy '(tag-up priority-down))
                 (org-agenda-todo-keyword-format "")
                 (org-agenda-overriding-header "\nTasks by Context\n------------------\n"))))
         ((org-agenda-with-colors nil)
          (org-agenda-compact-blocks t)
          (org-agenda-remove-tags t)
          (ps-number-of-columns 2)
           (ps-landscape-mode t))
         ("~/agenda.ps"))))

(setq 
 org-export-with-toc nil
 org-export-with-section-numbers nil)
