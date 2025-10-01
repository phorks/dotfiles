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
                  (call-interactively 'evil-paste-after)))

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
(define-key evil-treemacs-state-map (kbd "a")   #'treemacs-create-file)
(define-key evil-treemacs-state-map (kbd "A")   #'treemacs-create-dir)
(map! :leader :desc "Open sidebar" :n "e" #'+treemacs/toggle)

(define-key dired-mode-map (kbd "a") #'dired-create-empty-file)
(define-key dired-mode-map (kbd "A") #'dired-create-directory)
;; enable nerd icons in dired
(add-hook 'dired-mode-hook #'nerd-icons-dired-mode)
