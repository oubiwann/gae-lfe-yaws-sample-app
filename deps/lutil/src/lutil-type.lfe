;;;; data types and type ops
;;;;
(defmodule lutil-type
  (export all))

(defun add-tuples (a b)
  "Given two tuples, add them together."
  (add-tuples (list a b)))

(defun add-tuples (a)
  "Given a list of any number of tuples, add them all together."
  (list_to_tuple
    (lists:flatten
      (lists:map (lambda (x) (tuple_to_list x)) a))))

(defun partition-list (list-data)
  "This function takes lists of even length with an implicit key (atom) value
  pairing and generates a list of two lists: one with all the keys, and the
  other with all the values."
  (lists:partition #'is_atom/1 list-data))

(defun pair-dict (data)
  "'data' is a list of implicit pairs:
    * the odd elements are keys of type 'atom'
    * the even elemnts are the values.

  This list is partitioned. zipped to tuples, and then converted to a dict."
  (let (((tuple keys values) (partition-list data)))
    (dict:from_list
       (lists:zip keys values))))

(defun rename-key (old-key new-key old-proplist)
  "Given an old key, a new key, and an proplist to operate upon, rename the
  keys. This is essentially a create-new-k/v followed by a delete-old-k/v
  set of operations."
  (let ((new-proplist (++ old-proplist
                     `(#(,new-key ,(proplists:get_value
                                     old-key
                                     old-proplist))))))
    (proplists:delete old-key new-proplist)))

(defun orddict-merge (options1 options2)
  "Merge two orddicts.

  That which is added latter will over-write what was previous. As such,
  options2 has presedence over options1."
  (orddict:merge
    #'second-wins/3
    options1
    options2))

(defun second-wins (key val1 val2)
  val2)

(defun host->tuple (host)
  (let ((`#(ok ,tuple) (inet:getaddr host 'inet)))
    tuple))

(defun tuple->host (data)
  (string:join
    (lists:map
      #'integer_to_list/1 (tuple_to_list data))
    "."))

(defun list->tuple (list-data)
  (let ((quoted (lists:map (lambda (x) `',x) list-data)))
    (eval `(tuple ,@quoted))))

(defun atom-cat (atom-1 atom-2)
  "Concatenate two tuples."
  (list_to_atom (++ (atom_to_list atom-1) (atom_to_list atom-2))))

(defun string? (data)
  (io_lib:printable_list data))

(defun unicode? (data)
  (io_lib:printable_unicode_list data))

(defun list? (data)
  (and (is_list data) (not (string? data))))

(defun tuple? (data)
  (is_tuple data))

(defun atom? (data)
  (is_atom data))

(defun binary? (data)
  (is_binary data))

(defun bitstring? (data)
  (is_bitstring data))

(defun bool? (data)
  (is_boolean data))

(defun float? (data)
  (is_float data))

(defun function? (data)
  (is_function data))

(defun function? (data arity)
  (is_function data arity))

(defun integer? (data)
  (is_integer data))

(defun number? (data)
  (is_number data))

(defun record? (data record-tag)
  (is_record data record-tag))

(defun record? (data record-tag size)
  (is_record data record-tag size))

(defun reference? (data)
  (is_reference data))

;; The zip/2, zip/3, and zip/4 implementations are for kicks; probably *much*
;; better to use Erlang's lists:zip/2 and lists:zip3/3. There's no zip/4, so
;; hey -- have fun. The zip/1 function is what's most interesting: it can be
;; used for lists of lists of any length -- no need for special-case arities.
;; In particular, the zip/1 function was needed for the lmatrix library.
;;
;; Note that, unlike the Erlang zip functions, these functions *do not* return
;; a list of tuples; they return a list of lists.
(defun zip (lists)
  (zip-any lists '()))

(defun zip (list-1 list-2)
  (zip-2 list-1 list-2 '()))

(defun zip (list-1 list-2 list-3)
  (zip-3 list-1 list-2 list-3 '()))

(defun zip (list-1 list-2 list-3 list-4)
  (zip-4 list-1 list-2 list-3 list-4 '()))

(defun zip-2
  ((_ '() acc)
    acc)
  (('() _ acc)
    acc)
  (((cons h1 t1) (cons h2 t2) acc)
    (zip-2 t1 t2 (++ acc `((,h1 ,h2))))))

(defun zip-3
  ((_ _ '() acc)
    acc)
  ((_ '() _ acc)
    acc)
  (('() _ _ acc)
    acc)
  (((cons h1 t1) (cons h2 t2) (cons h3 t3) acc)
    (zip-3 t1 t2 t3 (++ acc `((,h1 ,h2 ,h3))))))

(defun zip-4 (list-1 list-2 list-3 list-4 acc)
  (cond
    ((lists:any
        (lambda (x) (== x '()))
        (list list-1 list-2 list-3 list-4))
     acc)
    ('true
      (let (((list (cons h1 t1) (cons h2 t2) (cons h3 t3) (cons h4 t4))
             (list list-1 list-2 list-3 list-4)))
        (zip-4 t1 t2 t3 t4 (++ acc `((,h1 ,h2 ,h3 ,h4))))))))

;; An alternate implementation:
;; (defun zip-4 (list-1 list-2 list-3 list-4 acc)
;;   ((_ _ _ '() acc)
;;     acc)
;;   ((_ _ '() _ acc)
;;     acc)
;;   ((_ '() _ _ acc)
;;     acc)
;;     (('() _ _ _ acc)
;;     acc)
;;   (((cons h1 t1) (cons h2 t2) (cons h3 t3) (cons h4 t4) acc)
;;     (zip-4 t1 t2 t3 t4 (++ acc `((,h1 ,h2 ,h3 ,h4))))))

(defun zip-any (lists acc)
  (cond
    ((lists:any
        (lambda (x) (== x '()))
        lists)
     acc)
    ('true
      (let ((heads (lists:map #'car/1 lists))
            (tails (lists:map #'cdr/1 lists)))
        (zip-any tails (++ acc `(,heads)))))))
