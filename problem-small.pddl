(define (problem small)
  (:domain drones)

  (:objects
    droneA - drone
    s2 s1 depot charging s3 - location
    kit1 - medkit
    b0 b1 b2 b3 b4 - level
  )

  (:init
    ;  Battery tables 
    (max-level b4)
    (next-level b0 b1)
    (next-level b1 b2)
    (next-level b2 b3)
    (next-level b3 b4)

    (battery-after b1 b1 b0)
    (battery-after b2 b1 b1)
    (battery-after b3 b1 b2)
    (battery-after b4 b1 b3)


    ;  Drone 
    (at droneA depot)  (battery droneA b4)  (empty droneA)

    ;  Accessibility & unlocking 
    (accessible s1)
    (accessible s2)
    (accessible s3)
    (accessible depot)
    (accessible charging)

    ;  Charger & supplies 
    (has-charger charging)
    (supply-at kit1 depot)
    (needs kit1 s1)

    ;  Map: each edge needs 6 facts (both directions) 
    (connected depot s1) (connected s1 depot)
    (flight-cost s1 depot b1) (flight-cost depot s1 b1)
    (= (distance s1 depot) 1) (= (distance depot s1) 1)

    (connected depot charging) (connected charging depot)
    (flight-cost charging depot b1) (flight-cost depot charging b1)
    (= (distance charging depot) 1) (= (distance depot charging) 1) 

    (connected charging s3) (connected s3 charging)
    (flight-cost charging s3 b1) (flight-cost s3 charging b1)
    (= (distance charging s3) 1) (= (distance s3 charging) 1)
    
    (connected s1 s2) (connected s2 s1)
    (flight-cost s1 s2 b1) (flight-cost s2 s1 b1)
    (= (distance s1 s2) 1) (= (distance s2 s1) 1)

    ; Plan cost
    (= (total-cost) 0)
  )

  (:goal (and
    (inspected s2)
    (inspected s3)
    (delivered kit1 s1)
  ))

  (:metric minimize (total-cost))
)