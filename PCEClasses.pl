:- pce_begin_class(matrix(width,height), vector, "2D Array").

variable(width,		int,	get,	,"Width of matrix").
variable(height,	int,	get,	,"Height of matrix").

initialise(M,Width:int, Height:int) :->
	"Create matrix"::
	send(M,send_super, initialise),
	send(M,slot, width,Width),
	send(M,slot, height,Height),
	Size is Width * Height,
	send(M,fill,@nil,1,Size).

element(M, X:int, Y:int, Value:any) :->
	"Set element at X-Y to Value"::
	get(M, width, W),
	get(M, height, H),
	between(1, W, X),
	between(1, H, Y),
	Location is X + (Y * (W-1)),
	send(M, send_super, element, Location, Value).

%% variable(tiernum,	int,	get,	"Which tier it is").
%% variable(count,		int,	get,	"How many cards there are").
%% variable(image,		string,	get,	"Path of image file").


:-pce_end_class