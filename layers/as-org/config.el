(setq as/org (concat (getenv "HOME") "/Dropbox/org/")
      as/agenda (concat as/org "agenda/")
      as/views (concat as/org "views/")
      as/inbox (concat as/org "inbox.org")
      as/journal (concat as/org "journal/")
      as/bookmarks (concat as/org "bookmarks.org")
      as/dailies (concat as/org "org-roam-dailies/")
      org-directory as/org)


(defun as/add-new-org-files-to-agenda ()
  "If the current file is in 'as/config, tangle blocks"
  (when (equal (file-name-directory (directory-file-name buffer-file-name)) as/dailies)
    (org-agenda-file-to-front)
    (message "%s added to agenda." buffer-file-name)))
(add-hook 'after-save-hook #'as/add-new-org-files-to-agenda)

;; Open org files in same window
(setq org-link-frame-setup '((file . find-file)))

(setq org-default-notes-file (concat as/org "notes.org")
      org-hide-leading-stars t
      org-todo-keywords
      '((sequence "TODO(t)" "WAITING(w)" "|" "DONE(d)" "CANCELLED(c)"))
      org-refile-targets '((nil :maxlevel . 3)
                           (org-agenda-files :maxlevel . 3))
      org-outline-path-complete-in-steps nil
      org-refile-allow-creating-parent-nodes 'confirm
      org-completion-use-ido nil
      org-refile-use-outline-path 'file)

(setq org-roam-directory as/org
      org-roam-db-location (concat as/org ".roam/" "org-roam.db")
      org-roam-dailies-directory (concat as/org "org-roam-dailies/")
      org-journal-dir as/journal)

(setq org-roam-dailies-capture-templates
      '(("d" "default" entry
         #'org-roam-capture--get-point
         "%?"
         :file-name "org-roam-dailies/%<%Y-%m-%d>"
         :head "#+title: %<%Y-%m-%d>
#+roam_tags:daily
* Priorities
* Daily Tasks
** TODO Plan the day
  SCHEDULED: <%<%Y-%m-%d>>
** TODO Anki - Process and Review Notes
  SCHEDULED: <%<%Y-%m-%d>>
** TODO QIIME 2 Forum
  SCHEDULED: <%<%Y-%m-%d>>
* Breaks
** Coffee
  SCHEDULED: <%<%Y-%m-%d>>
** Lunch
  SCHEDULED: <%<%Y-%m-%d>>
** Rest
  SCHEDULED: <%<%Y-%m-%d>>
* Meetings
* Exercises
* Review
** What worked well?
** Where did I get stuck?
** What did I learn?"
         )))

(setq org-roam-capture-templates
      '(("t" "default" plain (function org-roam--capture-get-point)
         "%?"
         :file-name "%(format-time-string \"%Y-%m-%d--%H-%M-%SZ--${slug}\" (current-time) t)"
         :head "#+title: ${title}\n"
         :unnarrowed t)))

(setq org-capture-templates
      '(("t" "TODO" entry (file+headline as/gtd "Collect")
         "* TODO %? \n  %U" :empty-lines 1)

        ("s" "TODO - Scheduled" entry (file+headline as/gtd "Collect")
         "* TODO %? \nSCHEDULED: %^t\n  %U" :empty-lines 1)

        ("d" "TODO - Deadline" entry (file+headline as/gtd "Collect")
         "* TODO %? \n  DEADLINE: %^t" :empty-lines 1)

        ("a" "Appointment" entry (file+headline as/gtd "Collect")
         "* %? \n  %^t")

        ("n" "Note" entry (file+headline as/gtd "Notes")
         "* %? \n%U" :empty-lines 1)

        ;; ("j" "Journal" entry (file+datetree as/journal)
        ;;  "* %? \nEntered on %U\n")

      ;; Used with capture protocol Chrome extension
        ("p" "Protocol" entry (file+headline as/bookmarks "Collect")
         "* %^{Title}\nSource: %u, %c\n #+BEGIN_QUOTE\n%i\n#+END_QUOTE\n\n\n%?")
        ("L" "Protocol Link" entry (file+headline as/bookmarks "Inbox")
         "* %? [[%:link][%(transform-square-brackets-to-round-ones \"%:description\")]]\n")))

(setq org-agenda-files (directory-files-recursively as/org "\\.org$"))
(setq org-agenda-include-diary t)
(setq org-tag-persistent-alist '(("work" . ?w)
                                 ("buy" . ?b)
                                 ("sdm" . ??)
                                 ("X" . ?x)
                                 ("misc" . ?m)
                                 ("finance" . ?f)
                                 ("read" . ?r)
                                 ("school" . ?s)))

(setq org-deadline-warning-days 14)
(setq org-columns-default-format "%30ITEM(Task) %5Effort(Estimation){:} %30SCHEDULED(Scheduled) %35TIMESTAMP(Timestamp) %35DEADLINE(Deadline) %5CLOCKSUM(Clocked)")
(setq org-agenda-custom-commands
      `(("." . "Agenda + category")
        (".a" "Current agenda without habits" agenda ""
         ((org-agenda-span 14)
          (org-agenda-category-filter-preset '("-habit"))
          (org-overriding-columns-format "%DEADLINE"))
         (,(concat as/agenda "agenda.ics")
          ,(concat as/agenda "agenda.html")))
        ("A" "All TODOs" ((alltodo))
         ((org-agenda-overriding-header "All TODOs")
          (org-agenda-sorting-strategy '(priority-down)))
         ,(concat as/agenda "all.html"))))

(setq org-export-with-toc nil
      org-export-with-section-numbers nil)
