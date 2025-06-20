;; Function to receive input n

; Prompts the user to enter the value of n
(defun set-n ()
    (princ "input your N. n = ")
    (read))

;; ----------


;; Functions to construct the board

; Creates a single row (list of 0s)
; Used to build the board (chessboard)
(defun make-row (n)
    (if (= n 0)
        '()
        (cons 0 (make-row (- n 1)))))

; Constructs a 2D board using make-row above
; Creates m rows of size n, forming an n*n board
(defun set-help (m n)
	(if (= m 0)
		'()
		(cons (make-row n) (set-help (- m 1) n))))

; Final function to build the board
(defun set-board (n)
	(set-help n n))

;; ----------



;; Backtracking algorithm will be used to solve the problem
;; It explores all rows, checks if placement is valid, places a queen, and proceeds to the next column. If blocked, it backtracks.



;; Function to try placing a queen in each column recursively

; Attempts to find a valid position for a queen in each column starting from col = 0
(defun solve (board col n)
	(if (= col n)
		'()
		(solve-row board 0 col n)))

; Tries all rows in the current column. Stops when row = n.
; Uses is-safe to check whether a queen can be placed at (row, col)
; Recursive form of a loop
(defun solve-row (board row col n)
	(if (= row n)
		'()
		(if (is-safe board row col n)
			(solve-row-safe board row col n)
			(solve-row board (+ row 1) col n))))


; replace-in-board is used to place a queen at a specific location
; If is-safe returns true, proceeds here
; Places a queen (1) at the position and creates a new board
; If at the last column (col = n-1), calls add-solution to save the board
; Otherwise, proceeds to next column
(defun solve-row-safe (board row col n)
	(setq board-with-queen (replace-in-board board row col 1))
	(if (= col (- n 1))
		(add-solution board-with-queen n)
		(solve board-with-queen (+ col 1) n))
	(solve-row board (+ row 1) col n))



; As mentioned above, to indicate that a queen has been placed at a specific position on the board,
; we need to update the board state.
; This function was created for that purpose.
; It creates a new list by changing the value at the given column (col) in the given row.
; If col is 0, it replaces the first value and appends the rest of the row as is.
(defun replace-in-row (row col val)
	(if (= col 0)
		(cons val (cdr row))
		(cons (car row) (replace-in-row (cdr row) (- col 1) val))))


; When row is 0, only that row is modified (others remain unchanged).
; Calls replace-in-row to update the specific row.
(defun replace-in-board (board row col val)
	(if (= row 0)
		(cons (replace-in-row (car board) col val) (cdr board))
		(cons (car board) (replace-in-board (cdr board) (- row 1) col val))))

; ----------




; From here on are the helper functions for is-safe.
; They check if there's a queen in any direction a queen can move (only the left side is checked).
; Only the left side is checked because the algorithm places queens from left to right, 
; so no queens exist on the right yet.
; If any position has a 1 (indicating a queen), it returns nil; otherwise, it returns t for safe.
(defun is-safe (board row col n)
	(if (check-left board row col)
		(if (check-up-left board (- row 1) (- col 1))
			(check-down-left board (+ row 1) (- col 1) n)
			nil)
		nil))

; Checks if there is a queen to the left.
; The helper function used here will be explained below.
(defun check-left (board row col)
	(if (= col 0)
		t
		(if (= (get-value board row (- col 1)) 1)
			nil
			(check-left board row (- col 1)))))

; Checks the upper-left diagonal.
; The helper function used here will be explained below.
(defun check-up-left (board row col)
	(if (or (< row 0) (< col 0))
		t
		(if (= (get-value board row col) 1)
			nil
			(check-up-left board (- row 1) (- col 1)))))

; Checks the lower-left diagonal.
; The helper function used here will be explained below.
(defun check-down-left (board row col n)
	(if (or (>= row n) (< col 0))
		t
		(if (= (get-value board row col) 1)
			nil
			(check-down-left board (+ row 1) (- col 1) n))))


; Retrieves the value at (row, col) from the board.
; Uses nth to access the elements.
(defun get-value (board row col)
	(nth col (nth row board)))

; -----------


;; From here, functions for result output


; Extracts the coordinates of queens from each row of the board.
(defun extract-positions (board row n)
	(if (= row n)
		'()
		(cons (find-queen-in-row (nth row board) 0 (+ row 1))
		      (extract-positions board (+ row 1) n))))

; Finds the column in a row where a queen (1) is located.
(defun find-queen-in-row (row col row-num)
	(if (null row)
		(list row-num 0)
		(if (= (car row) 1)
			(list row-num (+ col 1))
			(find-queen-in-row (cdr row) (+ col 1) row-num))))


; Adds a solution (board with queens).
; Although the board is represented as a list of 0s and 1s,
; extract-positions is used here to prepare it for output.
(defun add-solution (board n)
	(print (extract-positions board 0 n)))

; ----------

; Get input n and print the result
(setq n (set-n))
(setq board (set-board n))
(setq solutions (solve board 0 n))


; If n is 2 or 3, there are no solutions — handle this case separately.
(if (or (= n 2) (= n 3))
	(print nil))