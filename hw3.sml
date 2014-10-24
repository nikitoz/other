(* Coursera Programming Languages, Homework 3, Provided Code *)

exception NoAnswer

datatype pattern = Wildcard
		 | Variable of string
		 | UnitP
		 | ConstP of int
		 | TupleP of pattern list
		 | ConstructorP of string * pattern

datatype valu = Const of int
	      | Unit
	      | Tuple of valu list
	      | Constructor of string * valu

fun g f1 f2 p =
    let 
	val r = g f1 f2 
    in
	case p of
	    Wildcard          => f1 ()
	  | Variable x        => f2 x
	  | TupleP ps         => List.foldl (fn (p,i) => (r p) + i) 0 ps
	  | ConstructorP(_,p) => r p
	  | _                 => 0
    end

(**** for the challenge problem only ****)

datatype typ = Anything
	     | UnitT
	     | IntT
	     | TupleT of typ list
	     | Datatype of string

(**** you can put all your code here ****)

fun only_capitals (xs : string list) = List.filter (fn (x : string) => Char.isUpper(String.sub(x, 0)))  xs

fun longest_string1 (xs :string list) =
	case xs of [] => "" 
	| y::ys => (List.foldl (fn (z: string, r:string) => if (String.size z > String.size r) then z else r ) y ys)

fun longest_string2 (xs :string list) =
	case xs of [] => "" 
	| y::ys => (List.foldl (fn (z: string, r:string) => if (String.size z >= String.size r) then z else r ) y ys)


fun longest_string_helper pred xs =
	case xs of [] => "" 
	| y::ys => (List.foldl (fn (z : string, r : string) => if (pred(String.size z, String.size r)) then z else r ) y ys)

val longest_string3  = fn x => longest_string_helper (fn (x,y) =>  x >  y ) x
val longest_string4  = fn x => longest_string_helper (fn (x,y) =>  x >= y ) x
fun longest_capitalized xs = (longest_string1 o only_capitals) xs
fun rev_string s : string = (String.implode o List.rev o String.explode) s

fun first_answer f = fn a =>
	case a of
		[] => raise NoAnswer
		| x::xs => case (f x) of
					NONE => first_answer f xs
					| SOME v => v

fun all_answers f = fn lst =>
	let fun helper(f1, lst1, acc) =
		case lst1 of
			[]       => SOME acc
		 	|  x::xs => case (f1 x) of
							NONE     => NONE
						 	| SOME v => helper(f1, xs, acc @ v)
	in  helper(f, lst, []) end

fun count_wildcards p =
	let val cnt = ref 0
		val _ =  (g
					(fn _ => let val _ = cnt := (!cnt) + 1 in 0 end)
					(fn _ => 0)
					p)
	in !cnt end
fun count_wild_and_variable_lengths p =
	let val cntw = ref 0
		val cnts = ref 0
		val _ = (g 
					(fn _ => let val _ = cntw := (!cntw) + 1 in 0 end)
					(fn s : string => let val _ = cnts := (!cnts) + (String.size s) in 0 end)
					p
				)
	in !cntw + !cnts end

fun count_some_var (s1, p) =
	let val cnts = ref 0
	val _ = (g
				(fn _ => 0)
				(fn s2 => if (s1 = s2) then (let val _ = cnts := (!cnts) + 1 in 0 end) else 0)
				p
			)
	in !cnts end

fun check_pat p =
	let val lst = ref []
		val _ = (g (fn _ => 0) (fn s => let val _ = lst := (!lst) @ [s] in 0 end) p)
		fun foo lst =
			case lst of
				[]     => true
			   | x::xs => if (List.exists (fn y => x = y) xs) then false else (foo xs)
	in foo (!lst) end

fun match (v, p) =
	case (p,v) of
		(Wildcard,_)         => SOME []
	 | (Variable s, _)       => SOME [(s, v)]
	 | (UnitP, Unit)         => SOME []
	 | (ConstP c1, Const c2) => if (c1=c2) then SOME [] else NONE
	 | (TupleP ps, Tuple vs) => (
		if (List.length ps = List.length vs) then
			(all_answers match (ListPair.zip (vs, ps)))
		else NONE)
	 | (ConstructorP(s1, p2), Constructor(s2, v2)) => if (s1=s2) then match(v2, p2) else NONE
	 | (_,_) => NONE


fun first_match v = fn ps =>
	(SOME (first_answer (fn p => match(v, p)) ps)) handle NoAnswer => NONE


(*
fun match_type (t, p) =
	case (t, p) of
		(Anything, _)    => SOME Anything
	  | (UnitT, UnitP)   => SOME UnitT
	  | (IntT, ConstP i) => SOME IntT
      | (TupleT ts, TupleP ps) =>
		(if (List.length ps = List.length ts) then
			let val ls = (all_answers match_type (ListPair.zip (ts, ps))) in NONE end				
(*
			let val ls = (List.map match_type  (ListPair.zip (ts, ps))) in
				if (List.exists 
					(fn a => case a of NONE => true 
							 | _ => false ) 
					ls ) then NONE 
				else SOME(TupleT(ls))
			end
*)
		else NONE)
      |  (_,_) => NONE*)

fun match_type2 (t, p) =
	case (t,p) of
		(TupleT ts, TupleP ps) => 
			let val vs = (all_answers match_type2 (ListPair.zip (ts, ps))) in vs end
			   | (Anything,_) => SOME [Anything]
			   | (_,_)        =>  NONE

(*
fun typecheck_patterns ( ts,  ps : pattern list) =
	(SOME (first_answer (fn t => all_answers(match_type, ps) ) 
				ts
	)) handle NoAnswer => NONE  

*)
