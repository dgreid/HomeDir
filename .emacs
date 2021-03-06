(setq max-specpdl-size 3000)
(setq max-lisp-eval-depth 5000)

;; Add local lisp folder to load-path
(setq load-path (append load-path (list "~/elisp" "~/elisp/google" "~/elisp/icicles" "~/elisp/color-theme-6.6.0")))

;; key bindings I am used to
(global-set-key [C-f1] 'compile)
(global-set-key [C-S-f1] 'kill-compilation)
(global-set-key [C-f2] 'recompile)
(global-set-key (kbd "C-c C-a") 'apropos)
(define-key isearch-mode-map (kbd "C-o")
  (lambda () (interactive)
    (let ((case-fold-search isearch-case-fold-search))
      (occur (if isearch-regexp isearch-string (regexp-quote isearch-string))))))

(setq inhibit-startup-screen t)

;; scroll the `*compilation*' buffer window to follow output as it appears
(setq compilation-scroll-output t)

;; disable C-z on X11 sessions
(when window-system
(global-unset-key "\C-z"))

;; don't let scrolling ramp up it is really annoying unless the file is HUGE
(setq mouse-wheel-progressive-speed nil)

;; Undo/redo window layouts with "C-c <left>" and "C-c <right>"
(winner-mode 1)

;; Drive out the mouse when it's too near to the cursor.
(mouse-avoidance-mode 'animate)

;; uniquify!
(require 'uniquify)
(setq uniquify-buffer-name-style 'reverse)
(setq uniquify-separator "|")
(setq uniquify-after-kill-buffer-p t)
(setq uniquify-ignore-buffers-re "^\\*")

; I don't like transient mark mode on unless I do so manually.
(setq transient-mark-mode nil)
; more emacs 23 stuff, make next line go to the real next line
(setq line-move-visual nil)
; emacs 23 allows for run time font scaling: map it to ctrl-scroll-wheel
(global-set-key [C-mouse-4] (lambda () (interactive)
                                      (text-scale-increase 1)))
(global-set-key [C-mouse-5] (lambda () (interactive)
                                      (text-scale-decrease 1)))
(defun dgr-reset-text-size ()
  "reset the text scaling for the current buffer to the default size"
  (interactive)
  (text-scale-increase 0))

;; indent regions after pasting them.
(defadvice yank (after indent-region activate)
  (if (member major-mode '(emacs-lisp-mode scheme-mode lisp-mode
                                           c-mode c++-mode objc-mode
                                           LaTeX-mode TeX-mode))
      (indent-region (region-beginning) (region-end) nil)))

;; I only need a few system to be parsed when compiling...
(eval-after-load "compile"
  '(progn
     (setq compilation-error-regexp-alist (list 'gnu 'gcc-include))
     ))

(setq c-default-style "linux")
;; confirm on exit
(setq confirm-kill-emacs 'y-or-n-p)

;; don't show the scroll bar,
;;  if possible, show the cool indiction in the mode line of buffer position
(if (require 'sml-modeline nil 'noerror)    ;; use sml-modeline if available
    (progn
      (sml-modeline-mode 1)                   ;; show buffer pos in the mode line
      )
  )

(scroll-bar-mode -1)
(setq next-line-add-newlines nil)
(setq font-lock-maximum-decoration t)
(setq-default column-number-mode t)
;; show matching parens when cursor is near one
(show-paren-mode t)
(setq show-paren-style `mixed)
;; spell check comments and strings on the fly
(add-hook `c-mode-common-hook `flyspell-prog-mode)
;; use cscope if we can
(require `dgr-xcscope)
(setq cscope-display-cscope-buffer-single-match nil) ; I just want to get to where I am going
;; hide-show code blocks
(add-hook 'c-mode-common-hook
  (lambda()
    (local-set-key (kbd "C-<right>") 'hs-show-block)
    (local-set-key (kbd "C-<left>")  'hs-hide-block)
    (local-set-key (kbd "C-<up>")    'hs-hide-all)
    (local-set-key (kbd "C-<down>")  'hs-show-all)
;;    (local-set-key (kbd "M-.")       'cscope-find-global-definition)
;;    (local-set-key (kbd "M-,")       'cscope-find-this-symbol)
    (hs-minor-mode t)))
;; dtrt-indent auto-detects the indentation style of a c file when it is opened
(add-hook 'c-mode-common-hook
  (lambda()
    (require 'dtrt-indent)
    (dtrt-indent-mode t)))
(add-hook 'c-mode-common-hook
          (lambda()
            (setq comment-auto-fill-only-comments t)))

;; in c-mode we want to do some auto indentation, etc
(require `dgr-c-auto-indent-stuff)

;; show trailing whitespace and tabs in c-mode
(add-hook 'c-mode-common-hook
  (lambda()
    (setq show-trailing-whitespace t)))
(require 'whitespace)

;; highlight TODO, etc
(add-hook 'c-mode-common-hook
          (lambda ()
            (font-lock-add-keywords nil
                                    '(("\\<\\(FIXME\\|TODO\\|BUG\\):" 1 font-lock-warning-face t)))))

;; make gdb show all kinds of info
(setq gdb-many-windows t)

;; stuff that is disabled by default that I like.
(put 'upcase-region 'disabled nil)
(put 'narrow-to-region 'disabled nil)

;; allow to jump between windows easier than "C-x o"
(require 'windmove)
(windmove-default-keybindings 'super)

;; easy and fast line number display toggling
(require 'linum)
(global-set-key (kbd "<f6>") 'linum-mode)

(setq
 frame-title-format
 (concat "%b" " : [" invocation-name "@" system-name "]" ))

;ido completion - taken from emacs-fu
(require 'ido)                      ; ido is part of emacs
(ido-mode t)                        ; for both buffers and files
(setq
   ido-ignore-buffers               ; ignore these guys
   '("\\` " "^\*Mess" "^\*Back" ".*Completion" "^\*Ido")
   ido-work-directory-list '("~" "/~/src")
   ido-use-filename-at-point nil    ; don't use filename at point (annoying)
   ido-case-fold  nil               ; be case-sensitive
   ido-use-url-at-point nil         ;  don't use url at point (annoying)
   ido-enable-flex-matching t       ; be flexible
   ido-max-prospects 4              ; don't spam my minibuffer
   ido-enable-last-directory-history t ; remember last used dirs
   ido-everywhere t                 ; use for many file dialogs
   ido-max-work-directory-list 30   ; should be enough
   ido-max-work-file-list      50   ; remember many
   ido-confirm-unique-completion t) ; wait for RET, even with unique completion

;; google-region - search for the selected text in google
(defun google-region (&optional flags)
  "Google the selected region"
  (interactive)
  (let ((query (buffer-substring (region-beginning) (region-end))))
    (browse-url (concat "http://www.google.com/search?ie=utf-8&oe=utf-8&q=" query))))
;; press control-c g to google the selected region
(global-set-key (kbd "C-c g") 'google-region)

;; use bash when we run a shell
(setq shell-file-name "bash")
;set window height of the compilation buffer
(setq compilation-window-height 10)

(require 'ediff)
; Make ediff not use that annoying seperate frame:
(setq ediff-window-setup-function 'ediff-setup-windows-plain)
; and make it put the buffers side-by-side:
(setq ediff-split-window-function 'split-window-horizontally)

(setq make-backup-files nil)      ; don't make pesky backup files
(setq version-control 'never)     ; don't use version numbers for backup files
(setq vc-make-backup-files nil)
(setq make-backup-files nil)
(setq-default show-trailing-whitespace t)

(set-face-attribute 'default nil :height 100)

; my color scheme
(require 'color-theme)
(defun color-theme-dgr ()
  "Dylan's Emacs color theme"
  (interactive)
  (color-theme-install
    '(color-theme-dgr
       ((foreground-color . "wheat")
         (background-color . "dark slate grey")
         (background-mode . dark))
       (bold ((t (:bold t))))
       (bold-italic ((t (:italic t :bold t))))
       (font-lock-builtin-face ((t (:italic t :foreground "LightSteelBlue"))))
       (font-lock-comment-face ((t (:italic t :foreground "chocolate1"))))
       (font-lock-comment-delimiter-face ((t (:foreground "chocolate"))))
       (font-lock-constant-face ((t (:bold t :foreground "Aquamarine"))))
       (font-lock-doc-face ((t (:foreground "LightSalmon"))))
;;       (font-lock-reference-face ((t (:foreground "white"))))
       (font-lock-function-name-face ((t (:foreground "LightSkyBlue"))))
       (font-lock-keyword-face ((t (:bold t :foreground "Cyan1"))))
       (font-lock-preprocessor-face ((t (:foreground "LightSteelBlue"))))
       (font-lock-string-face ((t (:foreground "LightSalmon"))))
       (font-lock-type-face ((t (:bold t :foreground "PaleGreen"))))
       (font-lock-variable-name-face ((t (:foreground "LightGoldenrod"))))
       (font-lock-warning-face ((t (:bold t :italic nil :underline t
                                     :foreground "Pink"))))
       (hl-line ((t (:background "#112233"))))
       (mode-line ((t (:foreground "black" :background "grey75"))))
       (region ((t (:foreground nil :background "blue3"))))
       (scroll-bar ((t (:background "dark slate grey"))))
       (show-paren-match-face ((t (:foreground nil
                                    :background "#050505")))))))

; new frame behavior
(defun dgr-new-windowed-frame ()
  (if (require 'zenburn nil 'noerror)    ;; include zenburn if available
      (progn
        (color-theme-zenburn)                   ;; and use it
        )
    (progn
      (color-theme-dgr) ;; else use my local theme.
      (set-cursor-color "wheat")
      )
    )
)
(defun dgr-new-tty-frame ()
  (color-theme-tty-dark)
)
(defun dgr-new-frame (frame)
  (let ((color-theme-is-global nil))
    (select-frame frame)
    (if (window-system frame)
        (dgr-new-windowed-frame)
      (dgr-new-tty-frame)
      ))
  )
;; config any future frames
(add-hook 'after-make-frame-functions 'dgr-new-frame)

;; default to zenburn
(require 'zenburn)
(color-theme-zenburn)

;; save history for searches and my kill ring
(setq savehist-additional-variables    ;; also save...
  '(search-ring regexp-search-ring kill-ring)    ;; ... my search entries
  savehist-file "~/.emacs.d/savehist") ;; keep my home clean
(savehist-mode t)                      ;; do customization before activate

;; save where I was in a file the last time I visited it
(setq save-place-file "~/.emacs.d/saveplace") ;; keep my ~/ clean
(setq-default save-place t)                   ;; activate it for all buffers
(require 'saveplace)                          ;; get the package

;; kill all buffers of the same name
;;  allows for quick clean up when you start to see "setup.c<8>"
(global-set-key (kbd "C-x K") 'kill-other-buffers-of-this-file-name)
(defun kill-other-buffers-of-this-file-name (&optional buffer)
  "Kill all other buffers visiting files of the same base name."
  (interactive "bBuffer to make unique: ")
  (setq buffer (get-buffer buffer))
  (cond ((buffer-file-name buffer)
         (let ((name (file-name-nondirectory (buffer-file-name buffer))))
           (loop for ob in (buffer-list)
                 do (if (and (not (eq ob buffer))
                             (buffer-file-name ob)
                             (let ((ob-file-name (file-name-nondirectory (buffer-file-name ob))))
                               (or (equal ob-file-name name)
                                   (string-match (concat name "\\.~.*~$") ob-file-name))) )
                        (kill-buffer ob)))))
        (default (message "This buffer has no file name."))))

;; macro to increment comments just for numbers
;; must set register n to the number to start at before using
(fset 'inccommentnum
   "\C-s//\C-k\C-xrgn\C-u1\C-xr+n")

;; 'y' instead of 'yes'
(fset 'yes-or-no-p 'y-or-n-p)

;; hippie expand instead of standard
(setq hippie-expand-try-functions-list '(try-expand-dabbrev try-expand-dabbrev-all-buffers try-expand-dabbrev-from-kill try-complete-file-name-partially try-complete-file-name try-expand-all-abbrevs try-expand-list try-expand-line try-complete-lisp-symbol-partially try-complete-lisp-symbol))
(global-set-key (kbd "M-/") 'hippie-expand)


;;; Matlab-mode setup:

;; Set up matlab-mode to load on .m files
(autoload 'matlab-mode "matlab" "Enter MATLAB mode." t)
(setq auto-mode-alist (cons '("\\.m\\'" . matlab-mode) auto-mode-alist))
(autoload 'matlab-shell "matlab" "Interactive MATLAB mode." t)

;; Customization:
(setq matlab-indent-function t)	; if you want function bodies indented
(setq matlab-verify-on-save-flag nil) ; turn off auto-verify on save
(defun my-matlab-mode-hook ()
  (setq fill-column 76))		; where auto-fill should wrap
(add-hook 'matlab-mode-hook 'my-matlab-mode-hook)
(defun my-matlab-shell-mode-hook ()
  '())
(add-hook 'matlab-shell-mode-hook 'my-matlab-shell-mode-hook)

;; Turn off Matlab desktop
(setq matlab-shell-command-switches '("-nojvm"))

;; Load verilog mode only when needed
(autoload 'verilog-mode "verilog-mode" "Verilog mode" t )
;; Any files that end in .v should be in verilog mode
(setq auto-mode-alist (cons '("\\.v\\'" . verilog-mode) auto-mode-alist))
;; Any files in verilog mode should have their keywords colorized
(add-hook 'verilog-mode-hook '(lambda () (font-lock-mode 1)))

;; verilog customizations...
(setq verilog-auto-newline nil)
(setq verilog-auto-indent-on-newline nil)
(setq verilog-indent-begin-after-if nil)

;; translates ANSI colors into text-properties, for eshell
(autoload 'ansi-color-for-comint-mode-on "ansi-color" nil t)
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

;; keep the window simple, no toolbar, no menubar
(menu-bar-mode nil)
(tool-bar-mode nil)

;; finally load icicles
;(require 'icicles)

;enable window scrolling
(put 'scroll-left 'disabled nil)

; functions to use tramp to sudo-edit a file
(defun sudo-edit (&optional arg)
  (interactive "p")
  (if arg
      (find-file (concat "/sudo:root@localhost:" (ido-read-file-name "File: ")))
    (find-alternate-file (concat "/sudo:root@localhost:" buffer-file-name))))

(defun sudo-edit-current-file ()
  (interactive)
  (find-alternate-file (concat "/sudo:root@localhost:" (buffer-file-name (current-buffer)))))

; mignight-mode will clean up un-used buffers at midnight
(require 'midnight)
(midnight-delay-set 'midnight-delay "4:30am")
(setq clean-buffer-list-delay-general 1)

; org mode customization
(defun dgr-org-mode-stuff ()
  "Dylan's org mode customization"
  (org-update-checkbox-count t)
  (visual-line-mode t)
  (flyspell-mode t)
  (setq org-log-done t)
)
(add-hook 'org-mode-hook 'dgr-org-mode-stuff)

(defun dgr-load-org-work-agenda ()
  "Dylan's work agenda"
  (interactive)
  (setq org-agenda-files (list "~/org_google"))
)

(defun dgr-load-org-my-agenda ()
  "Dylan's agenda"
  (interactive)
  (setq org-agenda-files (list "~/org"))
)

(org-remember-insinuate)
(setq org-directory "~/org")
(setq org-default-notes-file (concat org-directory "/notes.org"))
(define-key global-map "\C-cr" 'org-remember)
(define-key global-map "\C-ca" 'org-agenda)

(setq org-remember-templates
      '(("ToDo" ?t "** TODO %?\n" "~/org/tasks.org" "New Tasks")
        ("DefenderToDo" ?d "** TODO %?\n" "~/org/Defender/notes.org" "New Tasks")
        ("WorkToDo" ?w "** TODO %?\n" "~/org/work/notes.org" "New Tasks")
        ("DefCodeReminder" ?c "** TODO %?\n %i \n %a" "~/org/Defender/notes.org" "Code Reminders")))

; git blame mode from git's contrib directory
(require 'git-blame)

; google specific configs
(load-file "/home/build/public/eng/elisp/google.el")

; google line-length enforcement
(defun font-lock-width-keyword (width)
  "Return a font-lock style keyword for a string beyond width WIDTH
that uses 'font-lock-warning-face'."
  `((,(format "^%s\\(.+\\)" (make-string width ?.))
     (1 font-lock-warning-face t))))

(font-lock-add-keywords 'c++-mode (font-lock-width-keyword 80))
(font-lock-add-keywords 'java-mode (font-lock-width-keyword 80))
(font-lock-add-keywords 'python-mode (font-lock-width-keyword 80))

; use chrome
(setq browse-url-browser-function 'browse-url-generic
      browse-url-generic-program "google-chrome")

; don't auto-split windows
(setq split-width-threshold nil)
(setq split-height-threshold nil)
