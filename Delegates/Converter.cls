Class %ZLib.Delegates.Converter Extends %ZLib.Delegates.Action [ Abstract ]
{

Property ResultIsDataType As %Boolean;

/// Creates an object-returning ClassMethodConverter.
ClassMethod createToObject() As %ZLib.Delegates.Converter [ Abstract, Internal ]
{
}

/// Creates an datatype-returning ClassMethodConverter.
ClassMethod createToDataType() As %ZLib.Delegates.Converter [ Abstract, Internal ]
{
}

Method invoke(a As %RegisteredObject) As %RegisteredObject [ Abstract ]
{
}

}

