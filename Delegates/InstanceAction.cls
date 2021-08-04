Class %ZLib.Delegates.InstanceAction Extends %ZLib.Delegates.Action [ Abstract ]
{

Property Instance As %RegisteredObject [ Internal, Private ];

Method combineArgs(ByRef newArray, args... As %RegisteredObject) [ Internal, Private ]
{
  #dim c as %Integer
  #dim currentArgsCount as %Integer

  set currentArgsCount =  $ORDER(..Args(""),-1)
  set c = $GET(args,0)

  do:((currentArgsCount+c)>..#MaxArgs) ..throwMaxArgsExceededException(..#MaxArgs,currentArgsCount+c)

  for i=1:1:currentArgsCount
  {
    set newArray(i) = $GET(..Args(i),"")
  }

  for i=2:1:c
  {
    set newArray(i-1+currentArgsCount) = $GET(args(i),"")
  }
}

}

