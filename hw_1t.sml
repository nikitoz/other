fun is_older_test () =
	( is_older( ( 1,2,3 ), ( 1,2,3 ) ) = false
		andalso  is_older( ( 1,2,3 ), ( 2,2,3 ) ) = true
		andalso  is_older( ( 1,2,3 ), ( 1,3,3 ) ) = true
		andalso  is_older( ( 1,2,3 ), ( 1,2,4 ) ) = true
		andalso  is_older( ( 1,2,3 ), ( 1,2,2 ) ) = false
		andalso  is_older( ( 1,2,3 ), ( 1,1,3 ) ) = false
		andalso  is_older( ( 2,2,3 ), ( 1,2,3 ) ) = false )

fun number_in_month_test () =
	( ( number_in_month( [ ( 1,2,3 ), ( 1,2,4 ), ( 1,1,3 ), ( 3,1,3 ), ( 9991,6,3 ) ], 2 ) = 2 )
	andalso ( number_in_month( [ ( 1,2,3 ), ( 1,2,4 ), ( 1,1,3 ), ( 1,1,3 ), ( 9991,6,3 ) ], 1 ) = 2 )
	andalso ( number_in_month( [ ( 1,2,3 ), ( 1,2,4 ), ( 1,1,3 ), ( 3,1,3 ), ( 9991,6,3 ) ], 6 ) = 1 ) 
    andalso ( number_in_month( [ ( 1,2,3 ), ( 1,2,4 ), ( 16,2,3 ), ( 3,1,3 ), ( 9991,2,3 ) ], 2) = 4 )
	andalso ( number_in_month( [ ( 1,2,3 ), ( 1,4,4 ), ( 1,1,3 ), ( 3,1,3 ), ( 9991,6,3 ) ], 4) = 1 )
	andalso ( number_in_month( [], 2 ) = 0 ) ) 