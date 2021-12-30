Class %ZLib.Delegates.InstancePropertyNotEqualsConverter Extends %ZLib.Delegates.InstancePropertyEqualsConverter
{

Method invoke(obj As %RegisteredObject) As %RegisteredObject
{
	return $PROPERTY(obj, ..MemberName)'=..CompareTo
}

}
