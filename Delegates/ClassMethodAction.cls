Class %ZLib.Delegates.ClassMethodAction Extends %ZLib.Delegates.Action
{

Property ClassName As %String [ Internal, Private ];

ClassMethod create(className As %String, methodName As %String, args... As %RegisteredObject) As %ZLib.Delegates.ClassMethodAction
{
	#dim a as %ZLib.Delegates.ClassMethodAction
	
	set a = ..%New()
	do a.setArgs(args...)
	set a.ClassName = className
	set a.MemberName = methodName
	
	return a
}

Method invoke(args... As %RegisteredObject) [ CodeMode = objectgenerator ]
{
	do ..invokeBase("  do $ClassMethod(..ClassName")
}

Method getCall() As %String
{
	return "##class("_..ClassName_")."_..MemberName
}

}

