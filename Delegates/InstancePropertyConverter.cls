Class %ZLib.Delegates.InstancePropertyConverter Extends %ZLib.Delegates.Converter
{

ClassMethod create(propertyName As %String, resultIsDataType As %Boolean = 1) As %ZLib.Delegates.InstancePropertyConverter [ Internal ]
{
	#dim d as %ZLib.Delegates.InstancePropertyConverter
	set d = ..%New()
	set d.MemberName = propertyName
	set d.ResultIsDataType = resultIsDataType
	return d
}

Method invoke(obj As %RegisteredObject) As %RegisteredObject
{
	return $PROPERTY(obj, ..MemberName)
}

/// Creates an datatype-returning ClassMethodConverter.
ClassMethod createToDataType(propertyName As %String) As %ZLib.Delegates.InstancePropertyConverter
{
	return ..create(propertyName, 1)
}

/// Creates an object-returning ClassMethodConverter.
ClassMethod createToObject(propertyName As %String) As %ZLib.Delegates.InstancePropertyConverter
{
	return ..create(propertyName, 1)
}

}

