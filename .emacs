(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(coffee-tab-width 2)
 '(column-number-mode t)
 '(compilation-error-regexp-alist
   (quote
    (absoft ada aix ant bash borland caml comma edg-1 edg-2 epc ftnchek iar ibm irix java jikes-file jikes-line gnu gcc-include lcc makepp mips-1 mips-2 msft omake oracle perl php rxp sparc-pascal-file sparc-pascal-line sparc-pascal-example sun sun-ada watcom 4bsd gcov-file gcov-header gcov-nomark gcov-called-line gcov-never-called perl--Pod::Checker perl--Test perl--Test2 perl--Test::Harness weblint
            ("^WARN:.+\\[\\(.*\\):\\(.*\\),\\(.*\\)\\]" 1 2 3))))
 '(compilation-read-command nil)
 '(compilation-scroll-output (quote first-error))
 '(ediff-merge-split-window-function (quote split-window-horizontally))
 '(ediff-split-window-function (quote split-window-horizontally))
 '(ediff-window-setup-function (quote ediff-setup-windows-plain))
 '(eshell-save-history-on-exit t)
 '(fill-column 80)
 '(indent-tabs-mode nil)
 '(inhibit-startup-screen t)
 '(jiralib-url "https://middil.atlassian.net")
 '(magit-ediff-dwim-show-on-hunks t)
 '(magit-status-buffer-switch-function (quote switch-to-buffer))
 '(ns-alternate-modifier (quote meta))
 '(ns-command-modifier (quote meta))
 '(org-modules
   (quote
    (org-bbdb org-bibtex org-docview org-gnus org-info org-irc org-mhe org-rmail org-w3m)))
 '(package-selected-packages
   (quote
    (scala-mode2 yaml-mode web-mode w3m tide slime sass-mode purescript-mode pomodoro org-jira markdown-mode magit lua-mode haskell-mode flycheck-ocaml esup ensime csharp-mode coffee-mode cargo caml actionscript-mode ace-jump-buffer ac-php ac-cake)))
 '(purescript-mode-hook (quote (turn-on-purescript-simple-indent)))
 '(tool-bar-mode nil))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(defmacro ilambda (args &rest body)
  `(lambda ,args
     (interactive)
     ,@body))

(global-set-key [(C w)] ctl-x-map)
(global-set-key [(C \;)] 'other-window)
(global-set-key [(C w) (C i)] 'other-window)
(global-set-key [(f7)] (ilambda () (compile "make -k")))
(global-set-key [(C w) (C \;)] 'comment-or-uncomment-region)
(global-set-key [(C w) (C b)] 'mode-line-other-buffer)
(global-set-key [(C w) (C k)] 'kill-this-buffer)
(global-set-key [(C w) (C w)] 'kill-region)

(global-set-key [(C w) (C l)] 'toggle-truncate-lines)

;; Make navigation a little easier
(global-set-key [(C c) (C c)] 'compile)
(global-set-key [(C c) (C n)] 'next-error)
(global-set-key [(C c) (C p)] 'previous-error)

;(iswitchb-mode t)

(column-number-mode t)
(menu-bar-mode 0)

(display-time-mode t)
(put 'narrow-to-region 'disabled nil)

;(load (expand-file-name "~/quicklisp/slime-helper.el"))

;; (load "~/downloads/android-mode-master/android-mode.el")

;; (load (expand-file-name "~/quicklisp/slime-helper.el"))
;; (setq inferior-lisp-program "clisp")
;(setq inferior-lisp-program "sbcl")

(setq js-indent-level 2)

(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)

(defun moccur (arg regex)
  "My occur function"
  (interactive "P\nsList lines matching regexp: ")
  (let ((current-line (line-number-at-pos)))
    (occur regex arg)
    (select-window (get-buffer-window "*Occur*"))
    (search-forward-regexp (format "%6d:" current-line) nil t)
    (hl-line-mode t)
    (loop for key in '("n" "j" [(C n)]) do (local-set-key key 'moccur--next-line))
    (loop for key in '("p" "k" [(C p)]) do (local-set-key key 'moccur--previous-line))
    (local-set-key "\r" 'moccur--display)))

(defun moccur--next-line ()
  (interactive)
  (next-line)
  (occur-mode-display-occurrence))

(defun moccur--previous-line ()
  (interactive)
  (previous-line)
  (occur-mode-display-occurrence))

(defun moccur--display ()
  (interactive)
  (occur-mode-goto-occurrence)
  (kill-buffer (get-buffer "*Occur*")))

;; IDO support for TAGS
(defun ido-find-tag ()
  "Find a tag using ido"
  (interactive)
  (tags-completion-table)
  (let (tag-names)
    (mapatoms (lambda (x)
                (push (prin1-to-string x t) tag-names))
              tags-completion-table)
    (find-tag (ido-completing-read "Tag: " tag-names))))

(defun ido-find-file-in-tags ()
  (interactive)
  (save-excursion
    (let ((enable-recursive-minibuffers t))
      (visit-tags-table-buffer))
    (find-file
     (expand-file-name
      (ido-completing-read
       "Project file: " (tags-table-files) nil t)))))

(defun my-tags-search ()
  (interactive)
  (let ((default (current-word)))
    (tags-search
     (regexp-quote
      (read-string (format "Find tag (%s): " default) 
                   nil nil default)))))

;; (global-set-key [(C w) (t)] 'ido-find-tag)
;; (global-set-key [(C w) (f)] 'ido-find-file-in-tags)
;; (global-set-key [(M .)]     'my-tags-search)

(require 'cl)

(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)

(package-initialize t)

(when (not package-archive-contents)
  (package-refresh-contents))

;; ENSIME stuff

(defun ensime-load ()
  (interactive)
  
  (require 'ensime)
  (add-hook 'scala-mode-hook 'ensime-scala-mode-hook)

  ;; ENSIME keybindings
  (defun ensime-custom-keybindings ()
    ;; (local-set-key [(C w) (f)]
    ;;                (lambda ()
    ;;                  (interactive)
    ;;                  (let* ((find-cmd "find . -type f -name '*.scala' | grep -v '^\./\.'")
    ;;                         (files (split-string (shell-command-to-string find-cmd) "\n" t))
    ;;                         (selected-file (ido-completing-read "Source: " files)))
    ;;                    (find-file selected-file))))
    (local-set-key [(C c) (C l)] 'ensime-show-uses-of-symbol-at-point)
    (local-set-key [(C c) (C p)] 'ensime-print-type-at-point)
    (local-set-key [(C c) (C i)] 'ensime-inspect-type-at-point)
    (local-set-key [(C .)]       'ensime-edit-definition)
    (local-set-key [(M .)]       'ensime-edit-definition-other-window)
    (local-set-key [(C \,)]      'ensime-pop-find-definition-stack))

  (add-hook 'scala-mode-hook 'ensime-custom-keybindings)

  (global-set-key [(C c) (C f)] 'ensime-search)
  (ensime))


;; MAGIT stuff

;(push (expand-file-name "~/emacs.d/magit/lisp") load-path)
;(autoload 'magit-status "magit" "It's MaGIT" t)

(global-set-key [f12] 'magit-status)
(global-set-key [(C w) (C m)] 'magit-status)

(defun git-grep ()
  (interactive)
  ;;(find-grep (read-string "$ " "git --no-pager grep -niH "))
  (let ((regexp (read-string "git grep: ")))
    (find-grep (format "git --no-pager grep -niH \"%s\" $(git rev-parse --show-toplevel)" regexp)))
  )

;(autoload 'ace-jump-mode "ace-jump-mode" "Emacs quick move minor mode")
(global-set-key [(C \;)] 'ace-jump-mode)

;(ido-mode 'buffers)
(global-set-key [(C x) (b)] 'ace-jump-buffer)

;; Pretty-Print XML

(defun bf-pretty-print-xml-region (begin end)
  "Pretty format XML markup in region. You need to have nxml-mode
http://www.emacswiki.org/cgi-bin/wiki/NxmlMode installed to do
this.  The function inserts linebreaks to separate tags that have
nothing but whitespace between them.  It then indents the markup
by using nxml's indentation rules."
  (interactive "r")
  (save-excursion
    (nxml-mode)
    (goto-char begin)
    (while (search-forward-regexp "\>[ \\t]*\<" nil t)
      (backward-char) (insert "\n"))
    (indent-region begin end))
  (message "Ah, much better!"))

;;;;;;;;;;;;;;;;;;;;;;;

(global-hi-lock-mode t)
(global-set-key [(C \.)] 'hi-lock-current-word)
(global-set-key [(C \,)] 'hi-unlock-current-word)
(global-set-key [(M \.)] 'hi-lock-current-word)
(global-set-key [(M \,)] 'hi-unlock-current-word)

(defun hi-current-word ()
  (format "\\b%s\\b" (regexp-quote (current-word))))

(defun hi-lock-current-word ()
  (interactive)
  (let* ((hi-lock-auto-select-face t)
	 (face (hi-lock-read-face-name)))
    (or (facep face) (setq face 'hi-yellow))
    (unless hi-lock-mode (hi-lock-mode 1))
    (hi-lock-set-pattern (hi-current-word) face)))

(defun hi-unlock-current-word ()
  (interactive)
  (unhighlight-regexp (hi-current-word)))

(global-set-key [(C o)] (lambda ()
                          (interactive)
                          (hi-lock-current-word)
                          (moccur nil (regexp-quote (current-word)))))

(setq inferior-lisp-program "/usr/local/bin/sbcl")

;; Executes the current line as a bash command

(defun bash-the-current-line ()
 (interactive)
 (let ((start-point (point))
       (result (shell-command-to-string (buffer-substring (point-at-bol) (point-at-eol)))))
  (goto-char start-point)
  (end-of-line)
  (newline)
  (insert "===\n")
  (insert result)
  (goto-char start-point)))
