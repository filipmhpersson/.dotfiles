(local M {})
(local state { :current nil :timer nil})

 (fn trim [val]
	 (: (: (or val "") :gsub "^%s+" "") :gsub "%s+$" ""))

 (fn run [cmd cb]
 	(vim.system cmd { :text true} (fn [res] (cb (= res.code 0) (trim res.stdout)))))

(fn run_sync [cmd]
  (local res (. (vim.system cmd { :text true}) :wait))
  res.code (trim res.stdout))
 
(local state { :current nil :timer nil })
(fn detect_tmux_appearance [cb]
(if vim.env.TMUX (run 
		["tmux" "show-options" "-gvq" "@appearance"]
		(fn [ok out]
			(if 
				(and ok (or (= out "dark") (= out "light")))
				(cb out)
				(print ok))))
	(cb "fail")))

(fn detect_macos_appearance [cb]
 (if (= (vim.fn.has "mac") 0)
  (cb "dark")
  (run 
    ["defaults" "read" "-g" "AppleInterfaceStyle"]
    (fn [ok output]
      (cb (or (and ok (= output "Dark") "dark") "light"))))))

(fn detect_appearance [cb]
  (detect_tmux_appearance 
    (fn [mode]
      (if mode
        (cb mode)
        (detect_macos_appearance cb)))))

(fn detect_appearance_sync []
  (if (and vim.env.TMUX (~= vim.env.TMUX ""))
    (print "TMUX TODO")))

;
;
;
;
; ;(detect_tmux_appearance (fn [ret] (print ret)))
