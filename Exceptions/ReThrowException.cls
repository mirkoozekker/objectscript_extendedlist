Class %ZLib.Exceptions.ReThrowException Extends %Exception.AbstractException
{

Property originalStack As %ListOfDataTypes;

ClassMethod create(exception As %Exception.AbstractException) As %ZLib.Exceptions.ReThrowException
{
	#dim ex as %ZLib.Exceptions.ReThrowException
	#dim a as %String
	#dim place as %String
	return:(exception.%IsA(##class(%ZLib.Exceptions.UserDefinedException).%ClassName(1))) exception
	
	set ex = ..%New(exception.Name, exception.Code, exception.Location, exception.Data,exception)
	set a = ""
	for i=$STACK:-1:1
	{
		set place = $STACK(i,"PLACE")
		set a = $STACK(i,"MCODE")_" ["_place_"]"
		do:(place'["^%") ex.originalStack.Insert(a)
	}
	return ex
}

Method DisplayString() As %String
{
	#dim p as %Exception.AbstractException
	
	set p = ##this
	
	while p.%IsA(..%ClassName(1)) && (p.InnerException '= "")
	{
		set p = p.InnerException
	}
	
	return p.DisplayString()
}

Method getClassName() As %String
{
	#dim regEx as %Regex.Matcher
	
	set regEx = ##class(%Regex.Matcher).%New("\d+\^(.+)\.\d+ ",..originalStack.GetAt(1))
	do regEx.Locate()
	
	return regEx.Group(1)
}

Method toString() As %String
{
	return ..DisplayString()_"<br>"_##class(%ZLib.XListOfDataTypes).fromList(..originalStack).toString("<br>")
}

Method %OnNew(pName As %String = "", pCode As %String = "", pLocation As %String = "", pData As %String = "", pInnerException As %Exception.AbstractException = {$$$NULLOREF}) As %Status [ Private ]
{
	set sc = ##super(pName,pCode,pLocation,pData,pInnerException)
	set ..originalStack = ##class(%ListOfDataTypes).%New()
	return sc
}

}

