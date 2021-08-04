Class %ZLib.Delegates.ObjectMethodAction Extends %ZLib.Delegates.Action
{

Property Instance As %RegisteredObject [ Internal, Private ];

ClassMethod create(instance As %RegisteredObject, methodName As %String, args... As %RegisteredObject) As %ZLib.Delegates.ObjectMethodAction
{
	#dim a as %ZLib.Delegates.ObjectMethodAction
	
	set a = ..%New()
	do a.setArgs(args...)
	set a.Instance = instance
	set a.MemberName = methodName
	
	return a
}

Method invoke(args... As %RegisteredObject) [ CodeMode = objectgenerator ]
{
	do ##class(%ZLib.Delegates.Action).invokeBase("  do $Method(..Instance")
}

}

