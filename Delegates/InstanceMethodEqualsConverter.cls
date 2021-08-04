Class %ZLib.Delegates.InstanceMethodEqualsConverter Extends %ZLib.Delegates.Converter
{

Property CompareTo As %String [ Internal, Private ];

ClassMethod create(methodName As %String, compareTo As %RegisteredObject) As %ZLib.Delegates.InstanceMethodEqualsConverter
{
	#dim d as %ZLib.Delegates.InstanceMethodEqualsConverter
	set d = ..%New()
	set d.MemberName = methodName
	set d.CompareTo = compareTo
	set d.ResultIsDataType = 1
	return d
}

Method invoke(obj As %RegisteredObject) As %RegisteredObject
{
	return $Method(obj, ..MemberName)=..CompareTo
}

}

