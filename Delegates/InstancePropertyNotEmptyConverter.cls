Class %ZLib.Delegates.InstancePropertyNotEmptyConverter Extends %ZLib.Delegates.InstancePropertyNotEqualsConverter
{

ClassMethod create(propertyName As %String) As InstancePropertyNotEqualsConverter
{
	return ##super(propertyName, "")
}

}
