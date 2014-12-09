;;;; XXX The logging functions in this modules won't be necessary once the
;;;; following bug is fixed in LFE:
;;;;  * https://github.com/rvirding/lfe/issues/99
;;;;
(defmodule sample-app-log
  (export all))

(defun log (level msg)
  (lager:log level '() msg))

(defun log (level format args)
  (log level (io_lib:format format args)))

(defun debug (msg)
  (log 'debug msg))

(defun debug (format args)
  (log 'debug format args))

(defun info (msg)
  (log 'info msg))

(defun info (format args)
  (log 'info format args))

(defun notice (msg)
  (log 'notice msg))

(defun notice (format args)
  (log 'notice format args))

(defun warning (msg)
  (log 'warning msg))

(defun warning (format args)
  (log 'warning format args))

(defun error (msg)
  (log 'error msg))

(defun error (format args)
  (log 'error format args))

(defun critical (msg)
  (log 'critical msg))

(defun critical (format args)
  (log 'critical format args))

(defun alert (msg)
  (log 'alert msg))

(defun alert (format args)
  (log 'alert format args))

(defun emergency (msg)
  (log 'emergency msg))

(defun emergency (format args)
  (log 'emergency format args))

