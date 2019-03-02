(define (domain warehouse)
	(:requirements :typing)
	(:types robot pallette - bigobject
        	location shipment order saleitem)

  	(:predicates
    	(ships ?s - shipment ?o - order)
    	(orders ?o - order ?si - saleitem)
    	(unstarted ?s - shipment)
    	(started ?s - shipment)
    	(complete ?s - shipment)
    	(includes ?s - shipment ?si - saleitem)

    	(free ?r - robot)
    	(has ?r - robot ?p - pallette)

    	(packing-location ?l - location)
    	(packing-at ?s - shipment ?l - location)
    	(available ?l - location)
    	(connected ?l - location ?l - location)
    	(at ?bo - bigobject ?l - location)
    	(no-robot ?l - location)
    	(no-pallette ?l - location)

    	(contains ?p - pallette ?si - saleitem)
  )

   (:action startShipment
      :parameters (?s - shipment ?o - order ?l - location)
      :precondition (and (unstarted ?s) (not (complete ?s)) (ships ?s ?o) (available ?l) (packing-location ?l))
      :effect (and (started ?s) (packing-at ?s ?l) (not (unstarted ?s)) (not (available ?l)))
   )
   
   (:action robotMove
      :parameters (?r - robot ?l_one - location ?l_two - location)
      :precondition (and (free ?r) (available ?l_one) (available ?l_two) (connected ?l_one ?l_two) (at ?r ?l_one) (no-robot ?l_two))
      :effect (and (at ?r ?l_two) (not (at ?r ?l_one)) (not (no-robot ?l_two)) (no-robot ?l_one))
   )
   
   (:action robotMoveWithPallette
      :parameters (?r - robot ?l_one - location ?l_two - location ?p - pallette)
      :precondition (and (has ?r ?p) (available ?l_one) (available ?l_two) (connected ?l_one ?l_two) (at ?r ?l_one) (at ?p ?l_one) (no-robot ?l_two) (no-pallette ?l_two))
      :effect (and (at ?r ?l_two) (no-robot ?l_one) (no-pallette ?l_one) (at ?p ?l_two))
   )
   
   (:action moveItemFromPalletteToShipment
      :parameters (?r - robot ?l - location ?s - shipment ?si - saleitem ?p - pallette ?o - order)
      :precondition (and (at ?p ?l) (packing-location ?l) (has ?r ?p) (contains ?p ?si) (orders ?o ?si) (available ?l))
      :effect (and (includes ?s ?si) (not (contains ?p ?si)))
   )

    (:action completeShipment
      :parameters (?s - shipment ?o - order ?l - location)
      :precondition (and (ships ?s ?o) (ships ?s ?o) (packing-location ?l) (not (available ?l)) (packing-at ?s ?l))
      :effect (and (complete ?s) (available ?l))
   )
)
