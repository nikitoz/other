fun toDays(date: int*int*int) = (#1 date)*365 + (#2 date)*31 + (#3 date)

fun is_older( date1 : int*int*int, date2 : int*int*int ) =	toDays( date1 ) < toDays( date2 )

fun number_in_month( xs: ( int*int*int ) list, m : int ) =
	let
		fun number_int_month_internal(xs: ( int*int*int ) list, m : int, sum : int) =
			if ( null xs ) then
				sum
			else if ( (#2 (hd( xs )) ) = m ) then
				number_int_month_internal( tl xs , m, sum + 1 )
			else
				number_int_month_internal( tl xs , m, sum )
	in
		number_int_month_internal ( xs, m, 0 )
	end
	
fun number_in_months ( dates : (int * int * int) list, ms : int list ) =
	let
		fun internal (dates : (int * int * int) list, ms : int list, res : int) =
			if (null ms) then
				res
			else
				internal (dates, tl ms, res + number_in_month(dates, hd ms))
	in
		internal(dates, ms, 0)
	end
	
fun dates_in_month ( dates : (int * int * int) list, m : int ) =
	let
		fun internal(dates : (int * int * int) list, m : int, res : (int * int *int) list ) =
			if ( null dates ) then
				res
			else if ( (#2 (hd( dates )) ) = m ) then
				internal( tl dates , m, res @ [(hd(dates))] )
			else
				internal( tl dates, m, res )
	in
		internal ( dates, m, [] )
	end
	
fun dates_in_months ( dates : ( int * int * int ) list, ms : int list ) =
	let
		fun internal( dates : (int * int * int) list, ms : int list, res : (int * int *int) list ) =
			if ( null ms ) then
				res
			else 
				internal( dates, tl ms, res @ dates_in_month( dates, hd ms) )
	in
		internal ( dates, ms, [] )
	end
	
fun get_nth ( xs : string list, n : int ) =
	if ( n = 1 ) then
		hd xs
	else
		get_nth( tl xs, n-1 )
		
fun date_to_string ( date : int * int * int ) =
	let
		val str_months = [ "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
	in
		get_nth( str_months, #2 date) ^ " " ^ Int.toString( #3 date ) ^ "," ^ " " ^ Int.toString( #1 date )
	end
		
fun number_before_reaching_sum ( n : int, xs : int list ) =
	let
		fun internal ( n : int, xs : int list, sm : int, prev : int, res : int ) =
			if (sm >= n) then
				res - 1
			else
				internal ( n, tl xs, sm + hd(xs), hd xs, res + 1 )
	in
		internal ( n, xs, 0, 0, 0)
	end

 fun what_month ( m : int ) =
	let
		val days_in_months = [ 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 ]
	in
		number_before_reaching_sum( m, days_in_months ) + 1
	end
	
fun month_range ( days : ( int * int ) ) =
	let
		fun internal( day1 : int, day2 : int ) =
			if ( day1 > day2 ) then
				[]
			else
				[ what_month( day1 ) ] @ internal ( day1+1, day2 )
	in
		internal( #1 days, #2 days )
	end
		
fun oldest ( dates : (int * int * int) list ) =
	let
		fun min_date( xs : (int * int * int) list, md : (int * int * int) ) =
			if ( null xs ) then
				md
			else if ( is_older( hd xs, md ) ) then
				min_date( tl xs, hd xs )
			else
				min_date( tl xs, md )
	in
		if ( null dates ) then
			NONE
		else
			SOME ( min_date( tl dates, hd dates ) )
	end
	
fun contains( xs : int list, n : int ) =
	if ( null xs ) then
		false
	else if ( ( hd xs ) = n ) then
		true
	else
		contains( tl xs, n )
	

fun remove_duplicates( m : int list ) =
	let 
		fun internal( m : int list, n : int list ) =
			if ( null m ) then
				n
			else if ( contains ( n, hd m ) ) then
				internal ( tl m, n )
			else
				internal ( tl m, n @ [hd m] )
	in
		internal( m, [] )
	end
			
		
fun number_in_months_challenge( dates : (int * int * int) list, ms : int list ) = 
	number_in_months( dates, remove_duplicates( ms ) )
	
fun dates_in_months_challenge( dates : ( int * int * int ) list, ms : int list ) = 
	dates_in_months( dates, remove_duplicates( ms ) )
	
fun is_leap( y : int ) =
	if ( ( ( y mod 400 ) = 0 ) orelse ( ( y mod 4 = 0 ) andalso not( ( y mod 100 ) = 0 ) ) ) then
		true
	else
		false
	
	
fun reasonable_date( date : ( int * int * int ) ) =
	if ( ( ( #1 date ) > 0 ) andalso ( ( #2 date) > 0 ) andalso ( ( #2 date) < 13 ) andalso ( ( #3 date) > 0 ) ) then
		if ( ( ( #2 date ) = 2 ) andalso ( ( #3 date ) = 29 ) ) then
			if ( is_leap( #1 date ) ) then
				true
			else 
				false
		else if ( ( #2 date ) = 2 ) then
			if ( ( #3 date ) < 29 ) then 
				true
			else
				false
		else if ( ( ( #2 date ) = 4 ) orelse ( ( #2 date ) = 6 ) orelse ( ( #2 date ) = 9 ) orelse ( ( #2 date ) = 11 ) ) then
			if ( ( #3 date ) < 31 ) then
				true
			else
				false
		else if ( ( #3 date ) < 32 ) then 
			true
		else 
			false
	else 
		false
	
	
			
			
			
			
			
			
			
			
			
			
