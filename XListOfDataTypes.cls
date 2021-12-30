Class %ZLib.XListOfDataTypes Extends (%ListOfDataTypes, %ZLib.XList)
{

ClassMethod instantiate() As XListOfDataTypes [ Internal, Private ]
{
	return ..%New()
}

ClassMethod fromDynamicArray(array As %DynamicArray) As XListOfDataTypes
{
	#dim list as XListOfDataTypes
	#dim iter as %Iterator.Array
	#dim key as %RegisteredObject
	#dim value as %RegisteredObject
	
	set list = ..%New()

	set iter = array.%GetIterator()
	while iter.%GetNext(.key,.value) {
		do list.Insert(value)
	}

	return list
}

ClassMethod fromString(string As %String, delimiter As %String = ",", zConvertMode As %String = "", addEmptyTokens As %String = {$$$YES}) As XListOfDataTypes
{
	#dim list as XListOfDataTypes
	set list = ..%New()
	do list.insertString(string, delimiter, zConvertMode, addEmptyTokens)
	return list
}

ClassMethod fromStringByLength(string As %String, length As %Integer, ignoreInCompleteEnd As %Boolean = {$$$NO}) As XListOfDataTypes
{
	#dim list as XListOfDataTypes
	set list = ..%New()
	do list.insertStringByLength(string, length, ignoreInCompleteEnd)
	return list
}

ClassMethod fromArrayWithKey(array As %AbstractArray, separator As %String = ":") As XList
{
	#dim a as XList
	#dim k as %String
	
	set a = ..instantiate()
	do a.insertArrayValues(array, 1, separator)

	return a
}

/// Zerlegt den übergebenen String am übergebenen Delimiter.
Method insertString(string As %String, delimiter As %String = ",", zConvertMode As %String = "", addEmptyTokens As %String = {$$$YES})
{
	#dim i as	%Integer
	#dim workString as %String = string
	#dim token as %String
	
	set:zConvertMode'="" workString = $ZCONVERT(string, zConvertMode)
	for i=1:1:$Length(workString,delimiter)
	{
		set token = ##class(String).trim($Piece(workString,delimiter,i))
		do:(addEmptyTokens || (token '= "")) ..Insert(token)
	}
}

/// Stückelt den übergebenen String in Größen von <parameter>length</paremeter>.
/// <parameter>ignoreInCompleteEnd</paremeter> entscheidet, ob unvollständige Stücke ignoriert werden. 
Method insertStringByLength(string As %String, length As %Integer, ignoreInCompleteEnd As %Boolean = {$$$NO})
{
	#dim cnt as %Integer
	#dim i as %Integer
	set cnt = $LENGTH(string) \ length
	set:((($LENGTH(string) # length) > 0) && 'ignoreInCompleteEnd) cnt = cnt+1
	for i = 1:1:cnt {
		do ..Insert($EXTRACT(string, (i-1)*length+1, (i-1)*length+length))
	}
}

Method insertArrayValues(array As %AbstractArray, includeKey As %Boolean = 0, separator As %String = ":")
{
	#dim key as %String
	
	if includeKey
	{
		set key = array.Next()
		while key '= ""
		{
			do ..Insert(key_separator_array.GetAt(key))
			set key = array.Next(key)
		}		
	}
	else
	{
		do ##super(array)
	}
}

Method sortByList(sortOrder As XListOfDataTypes, caseSensitive As %Boolean)
{
	#dim i as %Integer
	#dim j as %Integer
	#dim key as %String
	#dim sortKey as %String
	
	for i = sortOrder.Count():-1:1 {
		for j = ..Count():-1:1	{
			if caseSensitive {
				set key = ..GetAt(j)
				set sortKey = sortOrder.GetAt(i)
			} else {
				set key = $ZCONVERT(..GetAt(j), "L") 
				set sortKey = $ZCONVERT(sortOrder.GetAt(i), "L") 
			}
			
			if (key = sortKey) {
				do ..InsertAt(..GetAt(j), 1)
				do ..RemoveAt(j+1)
				quit
			}
		}
	}
}

Method selectNotEmptyValues() As XListOfDataTypes
{
	return ..select(##class(%ZLib.Delegates.ObjectMethodConverter).create($this, "isNotEmpty"))
}

Method indexOf(startsString As %String, caseSensitive As %Boolean = {$$$NO}) As %Integer
{
	#dim i as %Integer
	#dim currentLine as %String
	#dim compCurrentLine as %String
	#dim compStartsString as %String = startsString

	set:('caseSensitive) compStartsString = $ZCONVERT(startsString, "L")
	For i = 1:1:..Count() {
		set currentLine = ..GetAt(i)
		set compCurrentLine = currentLine
		set:('caseSensitive) compCurrentLine = $ZCONVERT(currentLine, "L")
		return:(compCurrentLine[compStartsString) i
	}
	return -1
}

Method findStartsWith(startsString As %String, caseSensitive As %Boolean = {$$$NO}, returnOffset As %Integer = 0) As %String
{
	return ..GetAt(..indexOf(startsString, caseSensitive) + returnOffset)
}

Method parallel(action As %ZLib.Delegates.ClassMethodAction, numberOfJobs As %Integer = 4)
{
	#dim queue as %SYSTEM.WorkMgr
	#dim i as %Integer
	
	set queue = ##class(%SYSTEM.WorkMgr).Initialize(,.sc,numberOfJobs)
	$$$ThrowOnError(sc)
	
	for i=1:1:..Count()
	{
		$$$ThrowOnError(queue.Queue("="_action.getCall(), ..GetAt(i)))
	}
	
	$$$ThrowOnError(queue.WaitForComplete())
}

Storage Custom
{
<Type>%Library.CompleteCustomStorage</Type>
}

}
