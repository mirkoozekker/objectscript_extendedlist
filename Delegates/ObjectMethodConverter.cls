Class %ZLib.Delegates.ObjectMethodConverter Extends %ZLib.Delegates.Converter
{

Property Instance As %RegisteredObject [ Internal, Private ];

ClassMethod create(instance As %RegisteredObject, methodName As %String, resultIsDataType As %Boolean = 1, args... As %RegisteredObject) As %ZLib.Delegates.ObjectMethodConverter [ Internal ]
{
	#dim d as %ZLib.Delegates.ObjectMethodConverter
	set d = ..%New()
	do d.setArgs(args...)
	set d.Instance = instance
	set d.MemberName = methodName
	set d.ResultIsDataType = resultIsDataType
	return d
}

Method invoke(args... As %RegisteredObject) As %RegisteredObject [ CodeMode = objectgenerator ]
{
	do ..invokeBase("  set result = $Method(..Instance")
	do %code.WriteLine("  return result")
}

/// Creates an datatype-returning ClassMethodConverter.
ClassMethod createToDataType(instance As %RegisteredObject, methodName As %String, args... As %RegisteredObject) As %ZLib.Delegates.ObjectMethodConverter
{
	return ..create(instance,methodName,1,args...)
}

/// Creates an object-returning ClassMethodConverter.
ClassMethod createToObject(instance As %RegisteredObject, methodName As %String, args... As %RegisteredObject) As %ZLib.Delegates.ObjectMethodConverter
{
	return ..create(instance,methodName,0,args...)
}

}

