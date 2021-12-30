Class %ZLib.Delegates.InstanceMethodEqualsConverter Extends %ZLib.Delegates.InstanceMethodComparisonConverter
{

Method invoke(obj As %RegisteredObject) As %RegisteredObject
{
	return $Method(obj, ..MemberName)=..CompareTo
}

}
