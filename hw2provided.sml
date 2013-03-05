(* Dan Grossman, Coursera PL, HW2 Provided Code *)

(* if you use this function to compare two strings (returns true if the same
   string), then you avoid several of the functions in problem 1 having
   polymorphic types that may be confusing *)
fun same_string(s1 : string, s2 : string) =
    s1 = s2

fun all_except_option ( s : string, xs : string list ) =
	let	fun internal(s : string, xs : string list, rs : string list, found : bool ) =
		case xs of
			[] => if ( not found ) then NONE else SOME rs
			| x::xs' => if ( same_string( s, x ) ) then internal( s, xs', rs, true ) else internal( s, xs', rs @ [x], found )
	in
		internal( s, xs, [], false )
	end
	
fun	get_substitutions1( subs : string list list, s : string ) =
	let fun internal1 ( xs : string list list, s : string, res : string list ) =
		case xs of
			[] => res
			| x::xs' => case all_except_option( x ) of
					NONE => internal1( tl xs, s, res )
					| SOME y => internal1( tl xs, s, res @ y )
	in
		internal1( subs, s, [] )
	end
					
		

	
(* put your solutions for problem 1 here *)

(* you may assume that Num is always used with values 2, 3, ..., 10
   though it will not really come up *)
datatype suit = Clubs | Diamonds | Hearts | Spades
datatype rank = Jack | Queen | King | Ace | Num of int 
type card = suit * rank

datatype color = Red | Black
datatype move = Discard of card | Draw 

exception IllegalMove

(* put your solutions for problem 2 here *)
