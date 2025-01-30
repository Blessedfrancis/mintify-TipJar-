(define-data-var owner principal tx-sender)
(define-data-var total-tips uint u0)
(define-data-var tip-percent uint u10) ;; Default tip percentage is 10%

;; Event types for better traceability
(define-map tips-log { sender: principal, amount: uint, timestamp: uint } { sender: principal, amount: uint, timestamp: uint })

;; Set contract initialization - the owner of the tip jar and the default tip percentage
(define-public (initialize-contract (owner-principal principal) (default-tip-percent uint))
    (begin
        (asserts! (< default-tip-percent u100) (err "Tip percentage cannot exceed 100%"))
        (var-set owner owner-principal)
        (var-set tip-percent default-tip-percent)
        (ok true)
    )
)

;; Set tip percentage - only the contract owner can set the tip percentage
(define-public (set-tip-percent (percentage uint))
    (begin
        (asserts! (is-eq tx-sender (var-get owner)) (err "Only the contract owner can set the tip percentage"))
        (asserts! (< percentage u100) (err "Tip percentage cannot exceed 100%"))
        (var-set tip-percent percentage)
        (ok true)
    )
)

;; Get tip percentage
(define-read-only (get-tip-percent)
    (ok (var-get tip-percent))
)


;; Function to send tips to the jar
(define-public (send-tip (amount uint))
  (begin
    (asserts! (not (is-eq tx-sender (var-get owner))) (err u3))
    (let ((current-balance (var-get total-tips))
          (timestamp stacks-block-height))
        (if (> amount u0)
          (match (stx-transfer? amount tx-sender (var-get owner))
            success 
              (begin
                (var-set total-tips (+ current-balance amount))
                (map-set tips-log { sender: tx-sender, amount: amount, timestamp: timestamp } { sender: tx-sender, amount: amount, timestamp: timestamp })
                (ok amount))
            error (err u1))
          (err u2)))))

;; Function to withdraw tips by the owner
(define-public (withdraw-tips (amount uint))
  (begin
    (asserts! (is-eq tx-sender (var-get owner)) (err "Only owner can withdraw tips"))
    (let ((current-balance (var-get total-tips)))
        (if (>= current-balance amount)
          (begin
            (var-set total-tips (- current-balance amount))
            (ok amount))
          (err "Insufficient funds.")))))

;; Function to view total tips received
(define-read-only (get-total-tips)
  (ok (var-get total-tips)))

;; Function to get individual contribution of a sender
(define-read-only (get-contribution (sender principal))
  (ok (default-to { sender: sender, amount: u0, timestamp: u0 } (map-get? tips-log { sender: sender, amount: u0, timestamp: u0 }))))

;; Get contract owner
(define-read-only (get-owner)
    (ok (var-get owner))
)
