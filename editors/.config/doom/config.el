;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq user-full-name "Amir Ayyam"
      user-mail-address "amf.ayyam@gmail.com")
(setq doom-theme 'doom-one)
(setq display-line-numbers-type 'relative)
(setq org-directory "~/org/")

;; disable M-c which corresponds to capitalize word because it's near M-x and I tend to hit it accidentally
(global-set-key (kbd "M-c") nil)

;; maximize on startup
(add-to-list 'initial-frame-alist '(fullscreen . maximized))
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; make horizontal scrolling work via my mouse
(setq mouse-wheel-tilt-scroll t)

;; set evil leader
(evil-set-leader '(normal visual) (kbd "SPC"))
;; disable continuing comments after o/O
(setq +evil-want-o/O-to-continue-comments nil)

(map! :leader :desc "Rename Symbol" :n "r" #'lsp-rename)
(map! :i "C-k" #'lsp-signature-activate)
(map! :leader :desc "Code Action(s)" :n "a" #'lsp-execute-code-action)
(map! :leader :desc "Format buffer" :n "fd" #'+format/buffer)

;; CLIPBOARD
;; Do not use the X clipboard for the unnamed register ""
(setq select-enable-clipboard nil)

;; Map <leader>y to yank to clipboard
;; Tip: use :leader instead of defining of "<leader>y"; it makes the description apply to which-key
(map! :leader :desc "Yank to system clipboard" :nv "y"
      (lambda ()
        (interactive)
        (evil-use-register ?+)
        (call-interactively 'evil-yank)))

;; Map <leader>p to paste (after) from system clipboard
(map! :leader :desc "Paste (after) from system clipboard" :nv "p"
      (lambda ()
        (interactive)
        (evil-use-register ?+)
        (call-interactively 'evil-paste-after)))

;; Map <leader>p to paste (before) from system clipboard
(map! :leader :desc "Paste (before) from system clipboard" :nv "P"
      (lambda ()
        (interactive)
        (evil-use-register ?+)
        (call-interactively 'evil-paste-before)))

;; Map C-S-c globally to copy form clipboard
(global-set-key (kbd "C-S-c")
                (lambda ()
                  (interactive)
                  (evil-use-register ?+)
                  (call-interactively 'evil-yank)))

;; Map C-S-v globally to paste form clipboard
(global-set-key (kbd "C-S-v")
                (lambda ()
                  (interactive)
                  (evil-use-register ?+)
                  (call-interactively 'evil-paste-before)))

(defun my/reveal-file-in-files ()
  (interactive)
  (if-let (file (buffer-file-name))
      (call-process "nautilus" nil 0 nil "--select" (expand-file-name file))
    (message "Current buffer is not visiting a file!")))

(defun my/reveal-root-in-files ()
  (interactive)
  (if-let (file (buffer-file-name))
      (call-process "nautilus" nil 0 nil (or (doom-project-root) default-directory))
    (message "Current buffer is not visiting a file!")))

(map! :leader
      (:prefix-map ("o" . "open/projects")
       :desc "Org agenda"       "A"  #'org-agenda
       (:prefix ("a" . "org agenda")
        :desc "Agenda"         "a"  #'org-agenda
        :desc "Todo list"      "t"  #'org-todo-list
        :desc "Tags search"    "m"  #'org-tags-view
        :desc "View search"    "v"  #'org-search-view)
       ;; :desc "Browse project"               "." #'+default/browse-project
       :desc "Switch to project buffer"     "b" #'projectile-switch-to-buffer
       :desc "Remove known project"         "D" #'projectile-remove-known-project
       :desc "Show errors"                  "e" #'flycheck-list-errors
       :desc "Discover projects in folder"  "f" #'+default/discover-projects
       :desc "Find file in other project"   "F" #'doom/find-file-in-other-project
       :desc "Reveal file in Files"         "h" #'my/reveal-file-in-files
       :desc "Reveal project root in Files" "H" #'my/reveal-root-in-files
       :desc "Kill project buffers"         "k" #'projectile-kill-buffers
       :desc "Add new project"              "n" #'projectile-add-known-project
       :desc "Open popup dialog"            "o" #'+popup/toggle
       :desc "Browse other project"         "p" #'doom/browse-in-other-project
       :desc "Switch project"               "q" #'projectile-switch-project
       :desc "Find recent project files"    "r" #'projectile-recentf
       :desc "Run project"                  "R" #'projectile-run-project
       :desc "Save project files"           "s" #'projectile-save-project-buffers
       :desc "Switch to scratch buffer"     "X" #'doom/switch-to-project-scratch-buffer
       ))

;; enable tabs
(require 'centaur-tabs)
(centaur-tabs-mode t)
(setq centaur-tabs-style "bar")
(add-to-list 'default-frame-alist '(fullscreen . maximized))
(setq centaur-tabs-set-icons t)
(setq centaur-tabs-icon-type 'nerd-icons)
(global-set-key (kbd "M-h")  'centaur-tabs-backward)
(global-set-key (kbd "M-l") 'centaur-tabs-forward)
(global-set-key (kbd "C-M-h") 'centaur-tabs-move-current-tab-to-left)
(global-set-key (kbd "C-M-l") 'centaur-tabs-move-current-tab-to-right)
(map! :n "<leader>bo" #'centaur-tabs-kill-other-buffers-in-current-group)

;; keybindings
(map! :n "gr" #'+lookup/references)


;; Use meta+j/k to move lines down/up
(require 'move-text)
(map! :nv "M-j" #'move-text-down
      :nv "M-k" #'move-text-up)

;; Resize windows with Ctrl + Arrow
(map! :n "C-<left>"  #'evil-window-decrease-width
      :n "C-<right>" #'evil-window-increase-width
      :n "C-<up>"  #'evil-window-increase-height
      :n "C-<down>"    #'evil-window-decrease-height)

;; Move between windows with ctrl+h/j/k/l
(map! :n "C-h" #'evil-window-left
      :n "C-j" #'evil-window-down
      :n "C-k" #'evil-window-up
      :n "C-l" #'evil-window-right)

;; Open suggestions (completion) popup on Ctrl + Space and close the popup on Ctrl + E
(map! :i "C-SPC" #'+corfu/dabbrev-or-last)
(map! :i "C-e" #'corfu-quit)

;; Show documentation in suggestion popup
(with-eval-after-load 'corfu
  (require 'corfu-popupinfo)
  (corfu-popupinfo-mode 1))

(require 'vterm)
(map! :nv "C-`" #'+vterm/toggle)

(require 'evil-surround)
(global-evil-surround-mode 1)
;; default config: cs to change surround, ds to delete surround

(require 'lean4-mode)

;; --------------------------------------------------------------------------------------
;; treemacs/dired
;; --------------------------------------------------------------------------------------
(require 'treemacs)
(setq treemacs-position 'right)
(setq treemacs-follow-mode t)
(setq treemacs-hide-gitignored-files-mode t)
(define-key evil-treemacs-state-map (kbd "a")   #'treemacs-create-file)
(define-key evil-treemacs-state-map (kbd "A")   #'treemacs-create-dir)
(map! :leader :desc "Open sidebar" :n "e" #'+treemacs/toggle)
;; (define-key dired-mode-map (kbd "a") #'dired-create-empty-file)
;; (define-key dired-mode-map (kbd "A") #'dired-create-directory)
;; enable nerd icons in dired
(add-hook 'dired-mode-hook #'nerd-icons-dired-mode)

;; --------------------------------------------------------------------------------------
;; LaTeX
;; --------------------------------------------------------------------------------------
(setq math-mode-from-persian 0)

(defun begin-math-mode-from-persian()
  (interactive)
  (progn
    (toggle-input-method)
    (insert "$")
    (setq math-mode-from-persian t)))

(defun try-begin-persian-after-math-mode()
  (interactive)
  (progn
    (insert "$")
    (when (eq math-mode-from-persian t)
      (toggle-input-method)
      (setq math-mode-from-persian 0))))

(defun begin-latex-command()
  (interactive)
  (progn
    (insert "\\")
    (when (string= current-input-method "persian")
      (toggle-input-method))))

(defun insert-lr-block()
  (interactive)
  (when (string= current-input-method "persian")
    (progn
      (insert "\n\\lr{")
      (save-excursion (insert "}\n"))
      (toggle-input-method))))

(defun insert-lr-footnote()
  (interactive)
  (when (string= current-input-method "persian")
    (progn
      (insert "\n\\footnote{\\lr{")
      (save-excursion (insert "}}\n"))
      (toggle-input-method))))

(defun end-english-block()
  (interactive)
  (unless (string= current-input-method "persian")
    (progn
      (forward-line)
      (toggle-input-method))))

(add-hook
 'LaTeX-mode-hook
 (lambda ()
   (visual-line-mode 1)
   (+bidi-mode 1)
   ;; make each line start a bidi paragraph
   (setq-local bidi-paragraph-start-re "^")
   (setq-local bidi-paragraph-separate-re "^")
   (define-key evil-insert-state-local-map
               (kbd "﷼") 'begin-math-mode-from-persian)
   (define-key evil-insert-state-local-map
               (kbd "$") 'try-begin-persian-after-math-mode)
   (define-key evil-insert-state-local-map
               (kbd "\\") 'begin-latex-command)
   (define-key evil-insert-state-local-map
               (kbd "C-1") 'insert-lr-block)
   (define-key evil-insert-state-local-map
               (kbd "C-2") 'insert-lr-footnote)
   (define-key evil-insert-state-local-map
               (kbd "C-`") 'end-english-block)))

;; --------------------------------------------------------------------------------------
;; lsp-ui
;; --------------------------------------------------------------------------------------
(setq lsp-ui-doc-position 'at-point)
(setq lsp-ui-doc-show-with-mouse t)
(setq lsp-ui-doc-delay 0.3)
(map! :n
      "K"
      (lambda ()
        (interactive)
        (if (and (fboundp 'lsp-ui-doc--frame-visible-p)
                 (lsp-ui-doc--frame-visible-p))
            (lsp-ui-doc-focus-frame)
          (lsp-ui-doc-glance))))
(with-eval-after-load 'lsp-ui-doc
  (evil-define-key 'normal lsp-ui-doc-frame-mode-map
    (kbd "<escape>") #'lsp-ui-doc-hide))
;; --------------------------------------------------------------------------------------
;; sideline
;; --------------------------------------------------------------------------------------
(use-package! sideline-lsp
  :init
  (setq sideline-backends-right '(sideline-lsp sideline-flycheck))
  (setq sideline-truncate t))

(use-package! lsp-mode :hook (lsp-mode . sideline-mode))
(use-package! lsp-ui :init (setq lsp-ui-sideline-enable nil))
(use-package! sideline-flycheck
  :hook (flycheck-mode . sideline-flycheck-setup))
;; --------------------------------------------------------------------------------------
;; rocq
;; --------------------------------------------------------------------------------------

;; autocompleting symbols and tactics defined externally
(setq company-coq-live-on-the-edge t)
;; doom disables company features it its rocq setup, we need to modify the value to exclude company
(after! company-coq
  (setq company-coq-disabled-features '(hello spinner smart-subscripts)))

;; Defined in ~/.config/emacs/.local/straight/repos/PG/generic/pg-user.el
(defun proof-assert-next-command-interactive ()
  "Process until the end of the next unprocessed command after point.
If inside a comment, just process until the start of the comment."
  (interactive)
  (proof-with-script-buffer ; for toolbar/other buffers
   (save-excursion
     (goto-char (proof-queue-or-locked-end))
     (skip-chars-forward " \t\n")
     (proof-assert-until-point))
   (proof-maybe-follow-locked-end)))

(defun my/proof-assert-next-command-interactive ()
  "Like `proof-assert-next-command-interactive`, but place cursor sensibly.
   After executing the next unprocessed Coq command:
   - If the next character after the command is a newline, leave point on
     the final character of the command.
   - Otherwise, leave point at the next character."
  (interactive)
  (proof-with-script-buffer
   ;; Execute next unprocessed command (same as original)
   (save-excursion
     (goto-char (proof-queue-or-locked-end))
     (skip-chars-forward " \t\n")
     (proof-assert-until-point))
   ;; Now handle point placement
   (let* ((locked-end (proof-queue-or-locked-end))
          (after-command (save-excursion
                           (goto-char locked-end)
                           (skip-chars-forward " \t")
                           (point))))
     (goto-char after-command)
     (when (looking-at "\n")
       (backward-char 1)))))

(with-eval-after-load 'proof-script
  (define-key coq-mode-map (kbd "<M-down>")
              'my/proof-assert-next-command-interactive)
  (define-key coq-mode-map (kbd "<M-up>")
              'proof-undo-last-successful-command)
  (define-key coq-mode-map (kbd "<M-right>")
              'proof-goto-point)
  )
