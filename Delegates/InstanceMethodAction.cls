Class %ZLib.Delegates.InstanceMethodAction Extends %ZLib.Delegates.InstanceAction
{

ClassMethod create(methodName As %String, args... As %RegisteredObject) As %ZLib.Delegates.InstanceMethodAction
{
	#dim a as %ZLib.Delegates.InstanceMethodAction
	
	set a = ..%New()
	do a.setArgs(args...)
	set a.MemberName = methodName
	
	return a
}

Method invoke(args... As %RegisteredObject) [ CodeMode = objectgenerator ]
{
	do %code.WriteLine("  set ..Instance = args(1)")
	do ##class(%ZLib.Delegates.Action).invokeBase("  do $Method(..Instance")
}

}

