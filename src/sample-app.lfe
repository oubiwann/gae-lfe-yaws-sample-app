(defmodule sample-app
  (export all))

(defun start (sconf)
  "This is intended to be used by the start_mod YAWS configuration directive.

  The sconf parameter is the sconf record defined in yaws.hrl."
  (lager:start))

(defun out (arg-data)
  "This is called by YAWS when the requested URL matches the URL specified in
  the YAWS config (see ./etc/yaws.conf) with the 'appmods' directive for the
  virtual host in question.

  In particular, this function is intended to handle all traffic for this
  app."
  (lfest:out-helper arg-data #'sample-app-routes:routes/3))
