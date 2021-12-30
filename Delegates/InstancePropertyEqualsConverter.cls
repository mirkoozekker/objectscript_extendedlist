Class %ZLib.Delegates.InstancePropertyEqualsConverter Extends %ZLib.Delegates.InstancePropertyComparisonConverter
{

Method invoke(obj As %RegisteredObject) As %RegisteredObject
{
	return $PROPERTY(obj, ..MemberName)=..CompareTo
}

}
