(* Dan Grossman, Coursera PL, HW2 Provided Code *)

(* if you use this function to compare two strings (returns true if the same
   string), then you avoid several of the functions in problem 1 having
   polymorphic types that may be confusing *)
fun same_string(s1 : string, s2 : string) =
    s1 = s2

fun all_except_option ( s : string, xs : string list ) =
	let	fun internal(s : string, xs : string list, rs : string list, found : bool ) =
		case xs of
			[] => 
			if ( not found ) then NONE else SOME rs
			| y::ys => 
			if ( same_string( s, y ) ) then internal( s, ys, rs, true ) else internal( s, ys, rs @ [y], found )
	in
		internal( s, xs, [], false )
	end
	
fun	get_substitutions1( subs : string list list, s : string ) =
	let fun internal1 ( xs : string list list, s : string, res : string list ) =
		case xs
			of [] => res
			| y::ys =>
				( case all_except_option(s, y)
					of NONE => internal1( ys, s, res )
					| SOME y => internal1( ys, s, res @ y ))
	in
		internal1( subs, s, [] )
	end
	
fun get_substitutions2( subs : string list list, s : string ) =	get_substitutions1( subs, s )

fun similar_names( subs : string list list, nm : {first:string, middle:string, last:string} ) =
	let fun internal ( xs : string list, mid :string, las : string, res : {first:string, middle:string, last:string} list ) =
		case xs
			of [] => res
			| y::ys => internal( ys, mid, las, res @ [{first=y, middle=mid, last=las}] ) 
	in
		internal( get_substitutions2( subs, #first nm ), #middle nm, #last nm, [nm] )
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

fun card_color(c : card) =
    let fun internal(s : suit) =
	    case s
	     of Clubs => Black
	      | Spades => Black
	      | Diamonds => Red
	      | Hearts => Red
    in
	internal(#1 c)
    end

fun card_value(c : card) =
    let fun internal(r : rank) =
	    case r
	     of Ace => 11
	     | Num i => i
	     | _ => 10
    in
	internal(#2 c)
    end

fun remove_card(cs : card list, c : card, e) =
    let fun internal(cs : card list, c : card, e, b : bool, out : card list) =
	case cs of 
	    [] =>
	    (if (b=false) then raise e else out)
	    | x::xs =>
		(if (x=c andalso b=false) then internal (xs, c, e, true, out) else internal(xs, c, e, b, out @ [x]))
    in
	internal(cs, c, e, false, [])
    end

fun all_same_color(cs : card list) =
    let fun internal(cs : card list, c : color) =
	    case cs of
		[] => true
	         | x::xs => 
		   (card_color(x)=c andalso internal(xs, c))
    in
	case cs of
	    [] => true
	    | x::xs => internal(xs, card_color(x))
    end

fun sum_cards(cs : card list) =
    let fun internal(cs : card list, n : int) =
	    case cs of
		[] => n
	        | x::xs => internal(xs, card_value(x)+n)
    in
	internal(cs, 0)
    end

fun score(cs : card list, goal : int) =
    let val sum = sum_cards(cs) in
	let val ps = (if (sum > goal) then 3*(sum - goal) else goal - sum) in
	    if (all_same_color(cs)=false) then ps else ps div 2
	end
    end

fun officiate(cs : card list, m : move list, goal : int) =
    let internal(cs :card list, hs : card list, m : move list, n : int, goal : int) =
	case m of
	  [] => n
	  | x::xs => (
	     case x of
		 Draw =>
		 ( if (cs=[]) then n else if (sum_cards(hs) > goal) then n else internal() )
			 | Discard c => internal(xs, remove_card(c), illegalMove))
