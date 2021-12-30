Class %ZLib.Delegates.InstancePropertyComparisonConverter Extends %ZLib.Delegates.ComparisonConverter
{

ClassMethod create(propertyName As %String, compareTo As %RegisteredObject) As InstancePropertyComparisonConverter
{
	#dim d as %ZLib.Delegates.InstancePropertyEqualsConverter
	set d = ..%New()
	set d.MemberName = propertyName
	set d.CompareTo = compareTo
	set d.ResultIsDataType = 1
	return d
}

}
