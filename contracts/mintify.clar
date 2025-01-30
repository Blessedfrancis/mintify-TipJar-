(define-data-var owner principal tx-sender)
(define-data-var total-tips uint u0)

;; Event types for better traceability
(define-map tips-log principal uint)

;; Set contract initialization - the owner of the tip jar
(define-read-only (get-owner)
  (ok (var-get owner)))

;; Function to send tips to the jar
(define-public (send-tip (amount uint))
  (begin
    (if (is-eq tx-sender (var-get owner))
      (err u1)
      (let ((current-balance (var-get total-tips)))
        (if (> amount u0)
          (match (stx-transfer? amount tx-sender (var-get owner))
            success 
              (begin
                (var-set total-tips (+ current-balance amount))
                (map-set tips-log tx-sender amount)
                (ok amount))
            error (err u1))
          (err u2))))))

;; Function to withdraw tips by the owner
(define-public (withdraw-tips (amount uint))
  (begin
    (if (is-eq tx-sender (var-get owner))
      (let ((current-balance (var-get total-tips)))
        (if (>= current-balance amount)
          (begin
            (var-set total-tips (- current-balance amount))
            (ok amount))
          (err "Insufficient funds.")))
      (err "Only owner can withdraw tips."))))

;; Function to view total tips received
(define-read-only (get-total-tips)
  (ok (var-get total-tips)))

;; Function to get individual contribution of a sender
(define-read-only (get-contribution (sender principal))
  (ok (default-to u0 (map-get? tips-log sender))))
