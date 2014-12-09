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

(defun health (arg-data)
  "GAE makes /_ah/health requests on a periodic basis to determine the
  operational status of an app. This function is intended to be called (as
  configured in the routes module) when that URL is requested.

  For more details, see the following:
    https://cloud.google.com/appengine/docs/python/managed-vms/#health_checking"
  (io:format "Got health request ...~n")
  (lfest-text-resp:ok))
