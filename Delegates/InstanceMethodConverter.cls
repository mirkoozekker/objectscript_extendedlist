Class %ZLib.Delegates.InstanceMethodConverter Extends (%ZLib.Delegates.InstanceAction, %ZLib.Delegates.Converter)
{

ClassMethod create(methodName As %String, resultIsDataType As %Boolean = 1) As %ZLib.Delegates.InstanceMethodConverter [ Internal ]
{
	#dim d as %ZLib.Delegates.InstanceMethodConverter
	set d = ..%New()
	set d.MemberName = methodName
	set d.ResultIsDataType = resultIsDataType
	return d
}

Method invoke(args... As %RegisteredObject) As %RegisteredObject [ CodeMode = objectgenerator ]
{
	do %code.WriteLine("  set ..Instance = args(1)")
	do ..invokeBase("  set result = $Method(..Instance")
	do %code.WriteLine("  return result")
}

/// Creates an datatype-returning ClassMethodConverter.
ClassMethod createToDataType(methodName As %String) As %ZLib.Delegates.InstanceMethodConverter
{
	return ..create(methodName, 1)
}

/// Creates an object-returning ClassMethodConverter.
ClassMethod createToObject(methodName As %String) As %ZLib.Delegates.InstanceMethodConverter
{
	return ..create(methodName, 0)
}

}

