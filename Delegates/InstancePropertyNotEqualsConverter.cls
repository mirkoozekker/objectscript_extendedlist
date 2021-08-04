Class %ZLib.Delegates.InstancePropertyNotEqualsConverter Extends %ZLib.Delegates.InstancePropertyEqualsConverter
{

Method invoke(obj As %RegisteredObject) As %RegisteredObject
{
	return $PROPERTY(obj, ..MemberName)'=..CompareTo
}

ClassMethod create(propertyName As %String, compareTo As %RegisteredObject) As %ZLib.Delegates.InstancePropertyNotEqualsConverter
{
	return ##super(propertyName, compareTo)
}

}

