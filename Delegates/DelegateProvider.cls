Class %ZLib.Delegates.DelegateProvider Extends %RegisteredObject [ Abstract ]
{

ClassMethod getClassMethodAction(methodName As %String, args... As %RegisteredObject) As %ZLib.Delegates.ClassMethodAction
{
		return ##class(%ZLib.Delegates.ClassMethodAction).create(..%ClassName(1), methodName, args...)
}

ClassMethod getClassMethodToDataTypeConverter(methodName As %String, args... As %RegisteredObject) As %ZLib.Delegates.ClassMethodConverter
{
		return ##class(%ZLib.Delegates.ClassMethodConverter).createToDataType(..%ClassName(1), methodName, args...)
}

ClassMethod getClassMethodToObjectConverter(methodName As %String, args... As %RegisteredObject) As %ZLib.Delegates.ClassMethodConverter
{
		return ##class(%ZLib.Delegates.ClassMethodConverter).createToObject(..%ClassName(1), methodName, args...)
}

Method getObjectMethodAction(methodName As %String, args... As %RegisteredObject) As %ZLib.Delegates.ObjectMethodAction
{
		return ##class(%ZLib.Delegates.ClassMethodAction).create($this, methodName, args...)
}

Method getObjectMethodToDataTypeConverter(methodName As %String, args... As %RegisteredObject) As %ZLib.Delegates.ObjectMethodConverter
{
		return ##class(%ZLib.Delegates.ClassMethodConverter).createToDataType($this, methodName, args...)
}

Method getObjectMethodToObjectConverter(methodName As %String, args... As %RegisteredObject) As %ZLib.Delegates.ObjectMethodConverter
{
		return ##class(%ZLib.Delegates.ClassMethodConverter).createToDataType($this, methodName, args...)
}

}
