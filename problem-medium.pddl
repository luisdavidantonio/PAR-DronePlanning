; Medium instance: 2 drones, 8 locations, capacity b6, edge costs 1-2
; Design constraint: s5 is locked until s4 is inspected
; Expected failure: (fly ... s4 s5 ...) before (inspect ... s4) violates (accessible s5)

(define (problem medium)
  (:domain drones)

  (:objects
    droneA droneB - drone
    s1 s2 s3 s4 s5 charging1 charging2 depot - location
    medkit1 medkit2 - medkit
    water1 - water
    b0 b1 b2 b3 b4 b5 b6 - level
  )

  (:init
    ;  Battery tables 
    (max-level b6)
    (next-level b0 b1)
    (next-level b1 b2)
    (next-level b2 b3)
    (next-level b3 b4)
    (next-level b4 b5)
    (next-level b5 b6)

    (battery-after b1 b1 b0)
    (battery-after b2 b1 b1)
    (battery-after b3 b1 b2)
    (battery-after b4 b1 b3)
    (battery-after b5 b1 b4)
    (battery-after b6 b1 b5)

    (battery-after b2 b2 b0)
    (battery-after b3 b2 b1)
    (battery-after b4 b2 b2)
    (battery-after b5 b2 b3)
    (battery-after b6 b2 b4)

    ;  Drone 
    (at droneA depot)  (battery droneA b6)  (empty droneA)
    (at droneB charging2)  (battery droneB b6)  (empty droneB)

    ;  Accessibility & unlocking 
    (accessible s1)
    (accessible s2)
    (accessible s3)
    (accessible s4)
    (accessible depot)
    (accessible charging1)
    (accessible charging2)
    (unlocks-by-inspection s4 s5)

    ;  Charger & supplies 
    (has-charger charging1)
    (has-charger charging2)
    (supply-at medkit1 depot)
    (supply-at medkit2 depot)
    (supply-at water1 depot)
    (needs medkit1 s1)
    (needs medkit2 s2)
    (needs water1 s5)

    ;  Map: each edge needs 6 facts (both directions) 
    (connected depot s1) (connected s1 depot)
    (flight-cost s1 depot b1) (flight-cost depot s1 b1)
    (= (distance s1 depot) 1) (= (distance depot s1) 1)

    (connected s1 charging1) (connected charging1 s1)
    (flight-cost charging1 s1 b1) (flight-cost s1 charging1 b1)
    (= (distance charging1 s1) 1) (= (distance s1 charging1) 1)

    (connected s1 s2) (connected s2 s1)
    (flight-cost s1 s2 b2) (flight-cost s2 s1 b2)
    (= (distance s1 s2) 2) (= (distance s2 s1) 2)
    
    (connected depot s3) (connected s3 depot)
    (flight-cost s3 depot b2) (flight-cost depot s3 b2)
    (= (distance s3 depot) 2) (= (distance depot s3) 2)

    (connected s3 charging2) (connected charging2 s3)
    (flight-cost charging2 s3 b1) (flight-cost s3 charging2 b1)
    (= (distance charging2 s3) 1) (= (distance s3 charging2) 1)

    (connected charging2 s4) (connected s4 charging2)
    (flight-cost s4 charging2 b2) (flight-cost charging2 s4 b2)
    (= (distance s4 charging2) 2) (= (distance charging2 s4) 2)

    (connected s4 s5) (connected s5 s4)
    (flight-cost s4 s5 b1) (flight-cost s5 s4 b1)
    (= (distance s4 s5) 1) (= (distance s5 s4) 1)

    ; Plan cost
    (= (total-cost) 0)
  )

  (:goal (and
    (inspected s2)
    (inspected s3)
    (inspected s4)
    (inspected s5)
    (delivered medkit1 s1)
    (delivered medkit2 s2)
    (delivered water1 s5)
  ))

  (:metric minimize (total-cost))
)