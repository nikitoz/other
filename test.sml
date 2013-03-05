fun test( s : int list option ) =
	case s of
		SOME [] => 1
		| NONE => 22
		| SOME xs => 
			case xs of
				[] => 0
				| x::xs => 11