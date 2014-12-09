(defmodule sample-app-gae
  (export all))

(include-file "deps/exemplar/include/html-macros.lfe")

(defun start (arg-data)
  "This function is intended to be called (as configured in the routes
  module) when Google App Engine makes a request to this app's /_ah/start
  URL.

  Any set-up functions you want to run when GAE is ready can be called
  here."
  (set-up arg-data)
  (lfest-json-resp:ok))

(defun set-up (arg-data)
  "A function to call once GAE is ready."
  (io:format "Setting up app, now that GAE is ready ...~n"))

(defun stop (arg-data)
  "This function is intended to be called (as configured in the routes
  module) when Google App Engine makes a request to this app's /_ah/stop
  URL.

  Any clean-up functions you wan to run when GAE is shutting down can be
  called here."
  (clean-up arg-data)
  (lfest-json-resp:ok))

(defun clean-up (arg-data)
  "A function to call once GAE is shutting down the container."
  (io:format "Cleaning up, now that GAE is shutting down the container ...~n"))
