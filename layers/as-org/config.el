(setq as/org (concat (getenv "HOME") "/Dropbox/org/")
      as/agenda (concat as/org "agenda/")
      as/views (concat as/org "views/")
      as/inbox (concat as/org "inbox.org")
      as/journal (concat as/org "journal/")
      as/bookmarks (concat as/org "bookmarks.org")
      as/roam (concat as/org "roam/")
      as/dailies (concat as/roam "dailies/")
      org-directory as/org)


(defun as/add-new-org-files-to-agenda ()
  "If the current file is in 'as/config, tangle blocks"
  (when (equal (file-name-directory (directory-file-name buffer-file-name)) as/dailies)
    (org-agenda-file-to-front)
    (message "%s added to agenda." buffer-file-name)))
(add-hook 'after-save-hook #'as/add-new-org-files-to-agenda)

(setq org-archive-location "~/Dropbox/org/.archive/%s_archive::datetree/")

(setq org-default-notes-file (concat as/org "notes.org")
      org-hide-leading-stars t
      org-todo-keywords
      '((sequence "TODO(t)" "WAITING(w)" "NEXT(n)" "MAYBE(m)" "|" "DONE(d)" "CANCELLED(c)"))
      org-refile-targets '((nil :maxlevel . 2)
                           (org-agenda-files :maxlevel . 3))
      org-outline-path-complete-in-steps nil
      org-refile-allow-creating-parent-nodes 'confirm
      org-completion-use-ido nil
      org-refile-use-outline-path nil
      ;; Open org files in same window
      org-link-frame-setup '((file . find-file))
      org-agenda-entry-text-maxlines 12
      org-agenda-start-with-log-mode t
      org-agenda-start-with-entry-text-mode nil
      )

(setq org-roam-directory as/roam
      org-roam-db-location (concat as/roam ".roam.db")
      org-roam-dailies-directory as/dailies
      org-journal-dir as/journal)

(setq org-roam-dailies-capture-templates
      '(("d" "default" entry
         #'org-roam-capture--get-point
         "%?"
         :file-name "dailies/%<%Y-%m-%d>"
         :head "#+title: %<%Y-%m-%d>
#+roam_tags:daily
* Daily Tasks
** TODO Power up [/] <%<%Y-%m-%d 09:00>>
   - [ ] Start pomodoro
   - [ ] Review/capture top priorities
   - [ ] Process inputs from other entry points
     - JIRA
     - Todoist
     - Evernote
   - [ ] Add meetings to agenda
   - [ ] Plan gym, yoga, etc.
** Miscellaneous [/]
  - [ ] Clear downloads folder
    #+begin_src emacs-lisp
    (dired \"~/Downloads\")
    #+end_src
  - [ ] Process open tabs
*** Breaks
**** Lunch <%<%Y-%m-%d>>
**** Rejuvenate <%<%Y-%m-%d>>
**** Exercise <%<%Y-%m-%d>>
** TODO Anki <%<%Y-%m-%d>>
** TODO Power down [/] <%<%Y-%m-%d 15:30>>
   - [ ] Close open loops
     - org-mode notes
     - Todoist
     - JIRA
   - [ ] Pre-planning for tomorrow
     - Schedule first deep work session
     - Fill in small time blocks with small tasks
   - [ ] Check-in with James
     - Follow up in current homework
     - Questions?
     - Talking points for next meeting?
** Review
*** What worked well?
*** Where did I get stuck?
*** What did I learn?
** Log %<%Y-%m-%d>    :log:
   :PROPERTIES:
   :CATEGORY: log
   :END:
"
         )))

(setq org-roam-capture-templates
      '(("t" "default" plain (function org-roam--capture-get-point)
         "%?"
         :file-name "%(format-time-string \"%Y-%m-%d--%H-%M-%SZ--${slug}\" (current-time) t)"
         :head "#+title: ${title}\n"
         :unnarrowed t)))

(setq org-capture-templates
      '(("t" "TODO" entry (file+headline as/inbox "Collect")
         "* TODO %? \n  %U" :empty-lines 1)

        ("s" "TODO - Timestamped" entry (file+headline as/inbox "Collect")
         "* TODO %? %^t\n  %U" :empty-lines 1)

        ("d" "TODO - Deadline" entry (file+headline as/inbox "Collect")
         "* TODO %? \n  DEADLINE: %^t" :empty-lines 1)

        ("p" "TODO - Project" entry (file+headline as/inbox "Collect")
         "* TODO %? \n  %U\n  DEADLINE: %^t
** Links
** Resources
** Log
" :empty-lines 1)

        ("a" "Appointment" entry (file+headline as/inbox "Collect")
         "* %? \n  %^t")

        ("n" "Note" entry (file+headline as/inbox "Notes")
         "* %? \n%U" :empty-lines 1)

        ("l" "Log entry" entry (file+olp+datetree as/inbox "Log")
         "* Log entry: %<[%Y-%m-%d %a %H:%M]>
- %?Working on
  Should this be time scoped?
- Next:
- Are you clocked in?
  - Are you actually working on it?
- Notes for tomorrow?
- Notes for power down?
- Anything that can be scheduled?" :empty-lines 1)

        ("j" "Journal" entry (file+datetree as/journal)
         "* %? \nEntered on %U\n")

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
        (".l" "Current agenda with log items (inactive timestamps)" agenda ""
         ((org-agenda-span 7)
          (org-agenda-category-filter-preset '("-habit"))
          (org-overriding-columns-format "%DEADLINE")
          (org-agenda-include-inactive-timestamps t))
         (,(concat as/agenda "agenda-with-log.md")
          ,(concat as/agenda "agenda-with-log.html")))
        ("A" "All TODOs" ((alltodo))
         ((org-agenda-overriding-header "All TODOs")
          (org-agenda-sorting-strategy '(priority-down)))
         ,(concat as/agenda "all.html"))))

(setq org-agenda-exporter-settings
      '((org-agenda-add-entry-text-maxlines 12)
        (htmlize-output-type 'css)))

(setq org-export-with-toc nil
      org-export-with-section-numbers nil)

(setq org-publish-project-alist
      '(("org"
         :base-directory "~/org/"
         :publishing-function org-html-publish-to-html
         :publishing-directory "~/public_html"
         :section-numbers nil
         :table-of-contents nil
         :style "<link rel=\"stylesheet\"
                href=\"../other/mystyle.css\"
                type=\"text/css\"/>")))
