Class %ZLib.Delegates.InstancePropertyEqualsConverter Extends %ZLib.Delegates.Converter
{

Property CompareTo As %String [ Internal, Private ];

ClassMethod create(propertyName As %String, compareTo As %RegisteredObject) As InstancePropertyEqualsConverter
{
	#dim d as %ZLib.Delegates.InstancePropertyEqualsConverter
	set d = ..%New()
	set d.MemberName = propertyName
	set d.CompareTo = compareTo
	set d.ResultIsDataType = 1
	return d
}

Method invoke(obj As %RegisteredObject) As %RegisteredObject
{
	return $PROPERTY(obj, ..MemberName)=..CompareTo
}

}

