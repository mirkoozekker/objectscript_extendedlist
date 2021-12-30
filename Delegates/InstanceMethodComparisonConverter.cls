Class %ZLib.Delegates.InstanceMethodComparisonConverter Extends %ZLib.Delegates.ComparisonConverter
{

ClassMethod create(methodName As %String, compareTo As %RegisteredObject) As InstanceMethodComparisonConverter
{
	#dim d as InstanceMethodComparisonConverter
	set d = ..%New()
	set d.MemberName = methodName
	set d.CompareTo = compareTo
	set d.ResultIsDataType = 1
	return d
}

}
