(defun insertion-sort (arr)
  ; Store the length of the array in n
  (let ((n (length arr)))
  
    ; Loop from index i = 1 to n - 1 (outer loop of insertion sort)
    (loop for i from 1 below n do
      ; key is the current value to insert, taken from arr[i]
      (let ((key (nth i arr))
            ; j is the index of the last sorted element to the left of key
            (j (- i 1)))
        
        ; Shift elements greater than key one position to the right
        ; Continue while j >= 0 and arr[j] > key
        (loop while (and (>= j 0) (< key (nth j arr))) do
          ; Copy arr[j] to arr[j + 1] (shift right by one position)
          (setf (nth (+ j 1) arr) (nth j arr))
          ; Decrement j to move left
          (decf j))

        ; After shifting, insert key at the correct position (j + 1)
        (setf (nth (+ j 1) arr) key))
      
      ; Print the array after each insertion step to observe the sorting progress
      (print arr))

    ; Return the sorted array
    arr))

; Test cases
(setq tc1 '(83 72 65 54 47 33 29 11))
(setq tc2 '(11 33 23 45 13 25 8 135))

; Sort and print the progress for each test case
(insertion-sort tc1)
(terpri) ; Print a newline
(insertion-sort tc2)
