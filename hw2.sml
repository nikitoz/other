(* Dan Grossman, Coursera PL, HW2 Provided Code *)

(* if you use this function to compare two strings (returns true if the same
   string), then you avoid several of the functions in problem 1 having
   polymorphic types that may be confusing *)
fun same_string(s1, s2) = s1 = s2

fun all_except_option ( s : string, xs : string list ) =
	let	fun internal(s : string, xs : string list, rs : string list, found : bool ) =
		case xs of
			  []    => if ( not found ) then NONE else SOME rs
			| y::ys => if ( same_string( s, y ) ) then internal( s, ys, rs, true ) else internal( s, ys, rs @ [y], found )
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
		let val {first=first_nm,middle=middle_nm,last=last_nm} = nm in
			internal( get_substitutions2( subs, first_nm ), middle_nm, last_nm, [nm] )
		end
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
    case c of 
		   (Clubs,_)    => Black
    	 | (Spades,_)   => Black
    	 | (Diamonds,_) => Red
    	 | (Hearts,_)   => Red

fun card_value(c : card) =
	case c of
		   (_,Ace)   => 11
	     | (_,Num i) => i
	     | (_,_)     => 10

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
	    	| x::xs => (card_color(x)=c andalso internal(xs, c))
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

fun list_add(cs : int list, a : int) =
	let fun internal (cs : int list, rs : int list, a : int) =
		case cs of
			  []    => rs
			| x::xs => internal(xs, rs @ [x+a], a)
	in
		internal (cs, [], a)
	end


fun sum_cards_challenge2(cs : card list) =
	let fun sum_int(cs : card list, res : int list) =
		case cs of
			  []    => res
			| x::xs =>(case x of
					  (_,Ace) => sum_int( xs, list_add(res, 1) @ list_add(res, 11) )
					| (_,_)   => sum_int( xs, list_add(res, card_value(x)) ))
	in
		sum_int(cs, [])
	end

fun sum_cards_challenge(cs : card list) =
	let fun sum_int(cs : card list, aces : int, sum : int) = 
		case cs of
			  [] => (sum, aces)
	    	| x::xs  => 
				(case x of
					  (_,Ace) => sum_int( xs, aces+1, sum )
					| (_,_)   => sum_int( xs, aces, sum + card_value(x)))
	in
		let fun do_sum(v : int*int, aces : int, sums : int list) =
			case v of
				  (s, 0) => sums @ [s+aces]
				| (s, elevens_left) => do_sum( (s, elevens_left-1), aces, sums @ [s+elevens_left*11+aces-elevens_left])
		in
			case sum_int(cs, 0, 0) of
				(s,a) => do_sum( (s,a), a, [] )
		end
	end

fun score_int(sum : int, goal : int, all_same : bool) =
	let val ps = (if (sum > goal) then 3*(sum - goal) else goal - sum) in
    	if (all_same=false) then ps else ps div 2
	end

fun score(cs : card list, goal : int) =
    let val sum = sum_cards(cs) in
		let val ps = (if (sum > goal) then 3*(sum - goal) else goal - sum) in
	    	if (all_same_color(cs)=false) then ps else ps div 2
		end
    end

fun score_challenge(cs : card list, goal : int) =
	let fun internal(s : int list, goal : int, best_score : int, all_same : bool) =
		case s of
			  []    => best_score	
			| x::xs => 
			let val test_best = score_int(x, goal, all_same) in
				if ( test_best < best_score ) then 
					internal(xs, goal, test_best, all_same)
				else
					internal(xs, goal, best_score, all_same)
			end
	in
		internal( sum_cards_challenge(cs), goal, score(cs, goal), all_same_color(cs) )
	end

fun officiate(cs : card list, m : move list, goal : int) =
    let fun internal(cs : card list, hs : card list, m : move list, goal : int) =
		case m of
	  		  [] => score(hs, goal)
	  		| x::xs => (
	     		case x of
		 			  Draw =>
					  	(case cs of
							  [] => score(hs, goal)
							| y::ys => (
								let val phs = hs @ [y] in 
									if (sum_cards(phs) > goal) then score(phs, goal) else internal(ys, phs, xs, goal)
								end
							)
						)
			 		| Discard c => internal(cs, remove_card(hs, c, IllegalMove), xs, goal))
	in
		internal(cs, [], m, goal)
	end

fun officiate_challenge(cs : card list, m : move list, goal : int) =
    let fun internal(cs : card list, hs : card list, m : move list, goal : int) =
		case m of
	  		  [] => score_challenge(hs, goal)
	  		| x::xs => (
	     		case x of
		 			  Draw =>
					  	(case cs of
							  [] => score_challenge(hs, goal)
							| y::ys => internal(ys, hs @ [y], xs, goal))
			 		| Discard c => internal(cs, remove_card(hs, c, IllegalMove), xs, goal))
	in
		internal(cs, [], m, goal)
	end

fun careful_player(cs : card list, goal : int) =
	let fun internal(cs : card list, goal : int, m : move list, hs : card list) =
		case cs of
			 []    => if (score(hs, goal) < goal*10) then m @ [Draw] else m
		   | x::xs => 
			if (score(hs, goal)=0) then 
				m
			else if (score(hs, goal) < goal*10) then
				internal(xs, goal, m @ [Draw], hs@[x])
			else
				case xs of
					  []    => m
					| y::ys => 
						if (score(hs @ [y], goal) = 0) then
							m @ [Discard x, Draw]
						else
							internal(xs, goal, m @ [Discard x], hs)
	in
		internal (cs, goal, [], [])
	end
