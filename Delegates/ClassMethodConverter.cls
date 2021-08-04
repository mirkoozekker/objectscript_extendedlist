Class %ZLib.Delegates.ClassMethodConverter Extends %ZLib.Delegates.Converter
{

Property ClassName As %String [ Internal, Private ];

/// Creates an object-returning ClassMethodConverter.
ClassMethod createToObject(className As %String, methodName As %String, args... As %RegisteredObject) As %ZLib.Delegates.ClassMethodConverter
{
	return ..create(className, methodName, 0, args...)
}

/// Creates a datatype-returning ClassMethodConverter.
ClassMethod createToDataType(className As %String, methodName As %String, args... As %RegisteredObject) As %ZLib.Delegates.ClassMethodConverter
{
	return ..create(className, methodName, 1, args...)
}

/// Please use dedicated createToObject or createToDataType.
ClassMethod create(className As %String, methodName As %String, resultIsDataType As %Boolean = 1, args... As %RegisteredObject) As %ZLib.Delegates.ClassMethodConverter [ Internal ]
{
	#dim d as %ZLib.Delegates.ClassMethodConverter
	set d = ..%New()
	do d.setArgs(args...)
	set d.ClassName = className
	set d.MemberName = methodName
	set d.ResultIsDataType = resultIsDataType
	return d
}

Method invoke(args... As %RegisteredObject) As %RegisteredObject [ CodeMode = objectgenerator ]
{
	do ..invokeBase("  set result = $ClassMethod(..ClassName")
	do %code.WriteLine("  return result")
}

}

