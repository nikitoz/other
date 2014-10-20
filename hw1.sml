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
		fun number_in_months_ (dates : (int * int * int) list, ms : int list, res : int) =
			if (null ms) then
				res
			else
				number_in_months_ (dates, tl ms, res + number_in_month(dates, hd ms))
	in
		number_in_months_(dates, ms, 0)
	end
	
fun dates_in_month ( dates : (int * int * int) list, m : int ) =
	let
		fun dates_in_month_(dates : (int * int * int) list, m : int, res : (int * int *int) list ) =
			if ( null dates ) then
				res
			else if ( (#2 (hd( dates )) ) = m ) then
				dates_in_month_( tl dates , m, res @ [(hd(dates))] )
			else
				dates_in_month_( tl dates, m, res )
	in
		dates_in_month_ ( dates, m, [] )
	end
	
fun dates_in_months (dates : (int * int * int) list, ms : int list) =
	let
		fun dates_in_months_(dates : (int * int * int) list, ms : int list, res : (int * int *int) list ) =
			if ( null ms ) then
				res
			else 
				dates_in_months_( dates, tl ms, res @ dates_in_month( dates, hd ms) )
	in
		dates_in_months_ ( dates, ms, [] )
	end
	
fun get_nth ( xs : string list, n : int ) =
	if (n = 1) then
		hd xs
	else
		get_nth( tl xs, n-1)
		
fun date_to_string ( date : int * int * int ) =
	let
		val str_months = [ "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
	in
		get_nth( str_months, #2 date) ^ " " ^ Int.toString( #3 date ) ^ "," ^ " " ^ Int.toString( #1 date )
	end
		
fun number_before_reaching_sum ( n : int, xs : int list ) =
	let
		fun number_before_reaching_sum_ ( n : int, xs : int list, sm : int, prev : int, res : int ) =
			if (sm >= n) then
				res-1
			else
				number_before_reaching_sum_ ( n, tl xs, sm + hd(xs), hd xs, res+1 )
	in
		number_before_reaching_sum_ ( n, xs, 0, 0, 0)
	end

 fun what_month ( m : int ) =
	let
		val day_months = [ 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 ]
	in
		number_before_reaching_sum ( m, day_months ) + 1
	end

fun month_range (day1 : int, day2 : int) =
	let
		fun month_range_internal (day1 : int, day2 : int, result : int list) =
			if (day1 > day2) then
				result
			else
				month_range_internal (day1 + 1, day2, result @ [what_month(day1)])
	in
		month_range_internal (day1, day2, [])
	end

fun oldest (ds : (int*int*int) list) =
	let
		fun oldest_internal (ds : (int*int*int) list, max : (int*int*int)) =
			if (null ds) then
				max
			else if (is_older(hd ds, max)) then
				oldest_internal(tl ds, hd ds)
			else
				oldest_internal(tl ds, max)
	in
		if (null ds) then
			NONE
		else
			SOME (oldest_internal (tl ds, hd ds))
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
		fun remove_duplicates_internal( m : int list, n : int list ) =
			if ( null m ) then
				n
			else if ( contains ( n, hd m ) ) then
				remove_duplicates_internal ( tl m, n )
			else
				remove_duplicates_internal ( tl m, n @ [hd m] )
	in
		remove_duplicates_internal( m, [] )
	end	
		
fun number_in_months_challenge( dates : (int * int * int) list, ms : int list ) = 
	number_in_months( dates, remove_duplicates( ms ) )
	
fun dates_in_months_challenge( dates : ( int * int * int ) list, ms : int list ) = 
	dates_in_months( dates, remove_duplicates( ms ) )
	
fun is_leap( y : int ) = (((y mod 400) = 0) orelse ((y mod 4 = 0) andalso not((y mod 100) = 0)))
	
fun reasonable_date( date : ( int * int * int ) ) =
	if (((#1 date) > 0) andalso ((#2 date) > 0) andalso ((#2 date) < 13) andalso ((#3 date) > 0)) then
		if (((#2 date) = 2) andalso ((#3 date) = 29)) then
			is_leap(#1 date)
		else if ((#2 date) = 2) then
			(#3 date) < 29 
		else if (((#2 date) = 4) orelse ((#2 date) = 6) orelse ((#2 date) = 9) orelse ((#2 date) = 11)) then
			(#3 date) < 31
		else 
			(#3 date) < 32
	else 
		false
