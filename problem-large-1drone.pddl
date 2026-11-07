; Large instance: 1 drone, 11 locations, capacity b6, edge costs 1-2
; Design constraint: s4 is locked until comms1 is delivered to s3; 
; Expected failure: fly into s4 before comms1 is delivered to s3 violates (accessible s4)

(define (problem large-1drone)
  (:domain drones)

  (:objects
    droneA - drone
    s1 s2 s3 s4 s5 s6 charging1 charging2 charging3 depot1 depot2 - location
    medkit1 medkit2 - medkit
    water1 - water
    comms1 - comms
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
    (at droneA depot1)  (battery droneA b6)  (empty droneA)

    ;  Accessibility & unlocking 
    (accessible s1)
    (accessible s2)
    (accessible s3)
    (accessible s5)
    (accessible s6)
    (accessible depot1)
    (accessible depot2)
    (accessible charging1)
    (accessible charging2)
    (accessible charging3)
    (unlocks-by-delivery comms1 s3 s4)

    ;  Charger & supplies 
    (has-charger charging1)
    (has-charger charging2)
    (has-charger charging3)
    (supply-at medkit1 depot1)
    (supply-at medkit2 depot2)
    (supply-at comms1 depot2)
    (supply-at water1 depot1)
    (needs medkit1 s1)
    (needs water1 s2)
    (needs comms1 s3)
    (needs medkit2 s5)

    ;  Map: each edge needs 6 facts (both directions) 
    (connected depot1 s1) (connected s1 depot1)
    (flight-cost s1 depot1 b1) (flight-cost depot1 s1 b1)
    (= (distance s1 depot1) 1) (= (distance depot1 s1) 1)

    (connected depot1 s2) (connected s2 depot1)
    (flight-cost s2 depot1 b2) (flight-cost depot1 s2 b2)
    (= (distance s2 depot1) 2) (= (distance depot1 s2) 2)

    (connected depot1 charging1) (connected charging1 depot1)
    (flight-cost charging1 depot1 b1) (flight-cost depot1 charging1 b1)
    (= (distance charging1 depot1) 1) (= (distance depot1 charging1) 1)

    (connected charging1 charging2) (connected charging2 charging1)
    (flight-cost charging2 charging1 b2) (flight-cost charging1 charging2 b2)
    (= (distance charging1 charging2) 2) (= (distance charging2 charging1) 2)

    (connected charging2 s3) (connected s3 charging2)
    (flight-cost s3 charging2 b1) (flight-cost charging2 s3 b1)
    (= (distance charging2 s3) 1) (= (distance s3 charging2) 1)

    (connected s3 s4) (connected s4 s3)
    (flight-cost s4 s3 b1) (flight-cost s3 s4 b1)
    (= (distance s3 s4) 1) (= (distance s4 s3) 1)

    (connected charging2 charging3) (connected charging3 charging2)
    (flight-cost charging3 charging2 b2) (flight-cost charging2 charging3 b2)
    (= (distance charging2 charging3) 2) (= (distance charging3 charging2) 2)

    (connected charging3 depot2) (connected depot2 charging3)
    (flight-cost depot2 charging3 b1) (flight-cost charging3 depot2 b1)
    (= (distance charging3 depot2) 1) (= (distance depot2 charging3) 1)

    (connected depot2 s5) (connected s5 depot2)
    (flight-cost s5 depot2 b1) (flight-cost depot2 s5 b1)
    (= (distance depot2 s5) 1) (= (distance s5 depot2) 1)

    (connected s5 s6) (connected s6 s5)
    (flight-cost s6 s5 b2) (flight-cost s5 s6 b2)
    (= (distance s5 s6) 2) (= (distance s6 s5) 2)

    ; Plan cost
    (= (total-cost) 0)
  )

  (:goal (and
    (inspected s2)
    (inspected s4)
    (inspected s6)
    (delivered medkit1 s1)
    (delivered medkit2 s5)
    (delivered water1 s2)
    (delivered comms1 s3)
  ))

  (:metric minimize (total-cost))
)