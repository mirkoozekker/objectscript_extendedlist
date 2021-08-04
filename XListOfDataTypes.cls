Class %ZLib.XListOfDataTypes Extends (%ListOfDataTypes, %ZLib.XList)
{

ClassMethod instantiate() As %ZLib.XListOfDataTypes [ Internal, Private ]
{
	return ..%New()
}

/// Creates a new list containing the parts of the string split by the given seperator.
ClassMethod fromString(string As %String, delimiter As %String = ",", zConvertMode As %String = "") As %ZLib.XListOfDataTypes
{
	#dim i as %Integer
	#dim list as %ZLib.XListOfDataTypes
	#dim workString as %String = string
	
	set:zConvertMode'="" workString = $ZCONVERT(string, zConvertMode)
	
	set list = ##class(%ZLib.XListOfDataTypes).%New()
	for i=1:1:$Length(workString,delimiter)
	{
		do list.Insert($ZSTRIP($Piece(workString,delimiter,i),"<>W"))
	}
	
	return list
}

/// Creates a new list form the given array containing its values and keys seperated by given seperator.
ClassMethod fromArrayWithKey(array As %AbstractArray, separator As %String = ":") As XList
{
	#dim a as XList
	#dim k as %String
	
	set a = ..instantiate()
	do a.insertArrayValues(array, 1, separator)

	return a
}

/// Adds all values of the given Array to the list. Key kan be included an will be seperated by given seperator.
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

/// Sorts the items of this list equivalent to those in the given list, casesensitive optionally.
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

/// Returns a list containing only the not empty values of this list.
Method selectNotEmptyValues() As XListOfDataTypes
{
	return ..select(##class(%ZLib.Delegates.ObjectMethodConverter).create($this, "isNotEmpty"))
}

/// Calls the given Action on every item of the list parallely with the given number auf threads.
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

