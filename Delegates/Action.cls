Class %ZLib.Delegates.Action Extends %RegisteredObject [ Abstract ]
{

Parameter MaxArgs As %Integer = 100;

Property MemberName As %String [ Internal, Private ];

Property Args [ Internal, MultiDimensional, Private ];

Method setArgs(args... As %RegisteredObject) [ Internal, Private ]
{
  #dim c as %Integer

  do ..checkNumberOfParameters(,args...)
  set c = $GET(args,0)
  for i=1:1:c
  {
    set ..Args(i) = $GET(args(i),"")
  }
}

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

  for i=1:1:c
  {
    set newArray(i+currentArgsCount) = $GET(args(i),"")
  }
}

Method checkNumberOfParameters(max As %Integer = {..#MaxArgs}, args... As %RegisteredObject) [ Internal, Private ]
{
  do:($GET(args,0)>max) ..throwMaxArgsExceededException(max,$GET(args,0))
}

Method throwMaxArgsExceededException(max As %Integer, is As %Integer) [ Internal, Private ]
{
    do ##class(%ZLib.ExceptionHelper).raiseException("EXHELP.ToManyParametersEX","Die maximale Parameterzahl für diese Klasse ist überschritten.", "Klasse: "_..%ClassName(1)_", Max: "_max_", Anzahl: "_is)
}

Method invoke(args... As %RegisteredObject) [ Abstract ]
{
}

ClassMethod invokeBase(methodCall As %String) [ Internal ]
{
	do %code.WriteLine("  do ..checkNumberOfParameters(,args...)")

	do %code.WriteLine("  do ..combineArgs(.currentArgs,args...)")

	do %code.WriteLine("  set c = $ORDER(currentArgs(""""),-1)")

	do %code.WriteLine("  set:(c="""") c = 0")

	set methodCall = methodCall_", ..MemberName"

	for i=1:1:..#MaxArgs + 1
	{
		do %code.WriteLine($S(i>1:" else",1:" ")_"if c="_(i-1)_"{ "_methodCall_") }")
		set methodCall = methodCall_", currentArgs("_i_")"
	}
}

}

