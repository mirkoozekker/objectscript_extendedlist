Class %ZLib.Delegates.InstanceMethodNotEqualsConverter Extends %ZLib.Delegates.InstanceMethodEqualsConverter
{

Method invoke(obj As %RegisteredObject) As %RegisteredObject
{
	return $Method(obj, ..MemberName)'=..CompareTo
}

}
