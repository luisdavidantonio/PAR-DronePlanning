; Smart-city emergency drones - Model A (recharge to max)
(define (domain drones)
  (:requirements :strips :typing :negative-preconditions
                 :conditional-effects :action-costs)

  (:types
    drone location supply level - object   ; base types
    medkit water comms - supply            ; kinds of supply
  )

  (:predicates
    ;  Drone state (dynamic - changes during actions) 
    (at ?d - drone ?l - location)                          ;where drone is located
    (carrying ?d - drone ?s - supply)             ;whether a drone is carrying a supply
    (empty ?d - drone)                            ;whether a drone is carrying nothing
    (battery ?d - drone ?current - level)         ;the battery level of a drone

    ;  Map (static - does not change during actions) 
    (connected ?l1 ?l2 - location)                ;whether two locations are connected
    (has-charger ?l - location)                         ;whether a location has a charging station
    
    ;  Map (dynamic) 
    (accessible ?l - location)                           ;whether a location is accessible

    ;  Supplies & Mission (dynamic) 
    (supply-at ?s - supply ?l - location)             ;whether a supply is available at a location
    (delivered ?s - supply ?l - location)                 ;whether a supply has been delivered to a location
    (inspected ?l - location)                             ;whether a location has been inspected
    (needs ?s - supply ?l - location)                 ;whether a location needs a supply

    ;  Unlocking rules (static) 
    (unlocks-by-inspection ?l  ?y - location)             ;inspecting ?l unlocks access to y
    (unlocks-by-delivery ?s - supply ?l ?y - location)    ;delivering ?s at ?l unlocks access to y

    ;  Battery encoding (static) 
    (flight-cost ?from ?to - location ?c - level)         ; flying ?from -> ?to costs ?c levels
    (battery-after ?current ?c ?left - level)              ; ?current - ?c = ?left (only listed if ?current >= ?c)
    (next-level ?n1 ?n2 - level)                            ; ?l2 = ?l1 + 1 (used by Model B's recharge)
    (max-level ?full - level)                             ; ?full is the maximum battery level
  )
  
  (:functions
    (total-cost) - number                                ; plan cost, minimized by the metric
    (distance ?from ?to - location) - number            ; static: cost added to total-cost per flight
  )

  (:action fly
    :parameters (?d - drone ?from ?to - location ?current ?c ?left - level)
    :precondition (and
      (at ?d ?from)               
      (connected ?from ?to)       
      (accessible ?to)            
      (battery ?d ?current)        
      (flight-cost ?from ?to ?c)  
      (battery-after ?current ?c ?left)  
    )
    :effect (and
      (not (at ?d ?from))                           ; drone no longer at ?from
      (at ?d ?to)                                   ; drone now at ?to
      (not (battery ?d ?current))                    ; drone's battery no longer ?current
      (battery ?d ?left)                            ; drone's battery now ?left
      (increase (total-cost) (distance ?from ?to))
    )
  )
  
  (:action inspect
    :parameters (?d - drone ?l - location)
    :precondition (and
      (at ?d ?l)                                      ; drone ?d is at ?l
      (not (inspected ?l))                               ; ?l has not been inspected
    )
    :effect (and
      (inspected ?l)                                  ; ?l is now inspected
      (forall (?y - location)
        (when (unlocks-by-inspection ?l ?y)           ; inspecting ?l unlocks ?y
              (accessible ?y))); ?y becomes accessible 
      (increase (total-cost) 1)
    )
  )

  (:action pick-up-supply
    :parameters (?d - drone ?s - supply ?l - location)
    :precondition (and
      (at ?d ?l)                                      ; drone ?d is at ?l
      (supply-at ?s ?l)                               ; supply ?s is at ?l
      (empty ?d)                                      ; drone ?d is empty
    )
    :effect (and
      (not (supply-at ?s ?l))                         ; supply ?s is no longer at ?l
      (not (empty ?d)); drone ?d is no longer empty
      (carrying ?d ?s); drone ?d is carrying ?s
      (increase (total-cost) 1)
    )
  )
  
  (:action deliver-supply
    :parameters (?d - drone ?s - supply ?l - location)
    :precondition (and
      (at ?d ?l); drone ?d is at ?l
      (carrying ?d ?s); drone ?d is carrying ?s
      (needs ?s ?l); location ?l needs ?s
    )
    :effect (and
      (not (carrying ?d ?s)); drone ?d is no longer carrying ?s
      (empty ?d); drone ?d is empty again
      (delivered ?s ?l); ?s is delivered at ?l
      (not (needs ?s ?l)); ?l no longer needs ?s
      (forall (?y - location)
        (when (unlocks-by-delivery ?s ?l ?y); delivering ?s at ?l unlocks ?y
              (accessible ?y))); ?y becomes accessible
      (increase (total-cost) 1)
    )
  )

  (:action recharge
    :parameters (?d - drone ?l - location ?current ?full - level)
    :precondition (and
      (at ?d ?l); drone ?d is at ?l
      (has-charger ?l); ?l has a charger
      (battery ?d ?current); drone's battery is ?current
      (max-level ?full); ?full is the max level
    )
    :effect (and
      (not (battery ?d ?current)); battery no longer ?current
      (battery ?d ?full); battery is now ?full
      (increase (total-cost) 1)
    )
  )
)