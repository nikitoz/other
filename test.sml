fun test( s : int list option ) =
	case s of
		SOME [] => 1
		| NONE => 22
		| SOME xs => 
			case xs of
				[] => 0
				| x::xs => 11


fun foo f x y z = 
	if x >= y
	then (f z)
	else foo f y x (tl z)

fun baz f a b c d e = (f (a ^ b))::(c + d)::e

fun mystery f xs =
    let
        fun g xs =
           case xs of
             [] => NONE
           | x::xs' => if f x then SOME x else g xs'
    in
	case xs of
            [] => NONE
	  | x::xs' => if f x then g xs' else mystery f xs'
    end
