(setq as/org (concat (getenv "HOME") "/Dropbox/org/")
      as/agenda (concat as/org "agenda/")
      as/views (concat as/org "views/")
      as/roam (concat as/org "roam/")
      as/inbox (concat as/roam "inbox.org")
      as/dailies (concat as/roam "dailies/")
      as/bookmarks (concat as/roam "bookmarks.org")
      as/journal (concat as/roam "journal/")
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
      org-refile-targets '((nil :maxlevel . 4)
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
      org-roam-db-location "~/.roam.db"
      org-roam-dailies-directory as/dailies
      org-journal-dir as/journal)

(setq org-roam-dailies-capture-templates
      '(("d" "default" entry
         "* %?"
         :target (file+head "%<%Y-%m-%d>.org"
                            "#+title: %<%Y-%m-%d>
#+roam_tags:daily
* Daily Tasks
** Power up [/]
   - [ ] Start pomodoro
   - [ ] Review/capture top priorities
   - [ ] Process inputs from other entry points
     - JIRA
     - Todoist
     - Evernote
   - [ ] Add meetings to agenda
   - [ ] Plan breaks, (lunch, exercise, practice, meditation, etc.)
** Miscellaneous [/]
  - [ ] Clear downloads folder
    #+begin_src emacs-lisp
    (dired \"~/Downloads\")
    #+end_src
  - [ ] Process open tabs
** Power down [/]
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
*** What did I learn?"
))))

(setq org-roam-capture-templates
      '(("d" "default" plain "%?"
         :target (file+head "%<%Y%m%d%H%M%S>-${slug}.org"
                            "#+title: ${title}\n\n* ${title}")
        :unnarrowed t)))

(setq org-roam-capture-ref-templates
      '(("r" "default" plain "%?"
         :target (file+head "%<%Y%m%d%H%M%S>-${slug}.org"
                            "#+title: ${title}\n\n${body}")
         :unnarrowed t)

        ("e" "entry" entry "* %? ${title}"
         :target (file+olp "~/Dropbox/org/roam/inbox.org" ("Collect"))
         :unnarrowed t)))

(setq org-capture-templates
      '(("t" "TODO" entry (file+headline as/inbox "Collect")
         "* TODO %? \n  %U" :empty-lines 1)

        ("s" "TODO - Timestamped" entry (file+headline as/inbox "Collect")
         "* TODO %? %^t\n  %U" :empty-lines 1)

        ("b" "Timeblock" entry (file+olp+datetree as/inbox "Planning")
         "* %? %^t" :time-prompt t :empty-lines 1)

        ("B" "TODO - Backlog" entry (file+headline as/inbox "Backlog")
         "* TODO %? :backlog:\n  %U" :empty-lines 1)

        ("d" "TODO - Deadline" entry (file+headline as/inbox "Collect")
         "* TODO %? \n  DEADLINE: %^t" :empty-lines 1)

        ("p" "TODO - Project" entry (file+headline as/inbox "Collect")
         "* TODO %? \n  %U\n  DEADLINE: %^t
** Notes
** Resources
** Meetings
** Log
" :empty-lines 1)

        ("a" "Appointment" entry (file+headline as/inbox "Collect")
         "* %? %^t\n** Agenda\n")

        ("n" "Note" entry (file+headline as/inbox "Notes")
         "* %? \n%U" :empty-lines 1)

        ("l" "Log entry" entry (file+olp+datetree as/inbox "Log")
         "* %?
%<[%Y-%m-%d %a %H:%M]>
- Scope hammer?
- What's next?
- Reflect
  - Are you clocked in and focused?
  - Any notes you can capture (for tomorrow, power-down, etc)?
  - Anything you can schedule?
  - Do you need a break?
  - Do you need a context change?
- Actions
  - [ ] Exercise/stretch
  - [ ] Listen to or record a glimpse
" :empty-lines 1)

        ("j" "Journal" entry (file+datetree as/journal)
         "* %? \nEntered on %U\n")

        ;; Used with capture protocol Chrome extension
        ("P" "Protocol" entry (file+headline as/bookmarks "Collect")
         "* %^{Title}\nSource: %u, %c\n #+BEGIN_QUOTE\n%i\n#+END_QUOTE\n\n\n%?")

        ("L" "Protocol Link" entry (file+headline as/bookmarks "Inbox")
         "* %? [[%:link][%(transform-square-brackets-to-round-ones \"%:description\")]]\n")))

(setq org-agenda-files (directory-files-recursively as/roam "\\.org$"))
(setq org-agenda-include-diary t)
(setq org-tag-persistent-alist '(("work" . ?w)
                                 ("backlog" . ?b)
                                 ("purchase" . ?p)
                                 ("sdm" . ??)
                                 ("X" . ?x)
                                 ("misc" . ?m)
                                 ("finance" . ?f)
                                 ("read" . ?r)
                                 ("school" . ?s)))

(setq org-deadline-warning-days 14)
(setq org-columns-default-format "%30ITEM(Task) %5Effort(Estimation){:} %30SCHEDULED(Scheduled) %35TIMESTAMP(Timestamp) %35DEADLINE(Deadline) %5CLOCKSUM(Clocked)")
(setq org-agenda-custom-commands
      `(("b" tags-todo "-backlog")
        ("." . "Agenda + category")
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
          ,(concat as/agenda "agenda-with-log.html")))))

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
