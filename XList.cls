Class %ZLib.XList Extends (%AbstractList, %RegisteredObject) [ Abstract ]
{

/// Gives a converter to compare list values being less or equal to the baseValue.
ClassMethod getLessOrEqualConverter(baseValue As %RegisteredObject) As %ZLib.Delegates.Converter
{
	return ##class(%ZLib.Delegates.ClassMethodConverter).create(..%ClassName(1),"isLessOrEqual",1,baseValue)
}

/// Gives true if val is less or equal to the baseValue.
ClassMethod isLessOrEqual(baseValue As %RegisteredObject, val As %RegisteredObject) As %Boolean
{
	return val<=baseValue
}

/// Gives a converter to compare list values being greater or equal to the baseValue.
ClassMethod getGreaterOrEqualConverter(baseValue As %RegisteredObject) As %ZLib.Delegates.Converter
{
	return ##class(%ZLib.Delegates.ClassMethodConverter).create(..%ClassName(1),"isGreaterOrEqual",1,baseValue)
}

/// Gives true if val is greater or equal to the baseValue.
ClassMethod isGreaterOrEqual(baseValue As %RegisteredObject, val As %RegisteredObject) As %Boolean
{
	return val>=baseValue
}

/// Creates a new XList contaning the passed values.
ClassMethod fromValues(values... As %RegisteredObject) As %ZLib.XList
{
	#dim a as XList
	
	set a = ..instantiate()
	do a.insertValues(values...)
	
	return a
}

/// Creates a new XList contaning the passed values. Skips Nulls.
ClassMethod fromNotEmptyValues(values... As %RegisteredObject) As %ZLib.XList
{
	#dim a as XList
	
	set a = ..instantiate()
	do a.insertNotEmptyValues(values...)
	
	return a
}

/// Inserts values
Method insertValues(values... As %RegisteredObject)
{
	#dim i as %Integer
	for i=1:1:$GET(values,0)
	{
		do ..Insert($GET(values(i),""))
	}
}

/// Inserts values
Method insertNotEmptyValues(values... As %RegisteredObject)
{
	#dim i as %Integer
	for i=1:1:$GET(values,0)
	{
		do:..isNotEmpty(values(i)) ..Insert($GET(values(i),""))
	}
}

Method isNotEmpty(value As %RegisteredObject) As %Boolean
{
	return value'=""
}

/// Creates a new XList containing the list-values.
ClassMethod fromList(list As %AbstractList, converter As %ZLib.Delegates.Converter = {..getDefaultConverter()}) As XList
{
	#dim a as XList
	
	set a = ..instantiate()
	do a.insertMany(list)
	
	return a
}

/// Creates a new XList containing the array values.
ClassMethod fromArray(array As %AbstractArray) As XList
{
	#dim a as XList
	#dim k as %String
	
	set a = ..instantiate()
	do a.insertArrayValues(array)

	return a
}

/// Gives true if predicate gives true for any of the items.
Method any(predicate As %ZLib.Delegates.Converter) As %Boolean
{
	#dim found as %Boolean
	set found = $$$NO

	for i=1:1:..Count()
	{
		set found = predicate.invoke(..GetAt(i))
		quit:found
	}

	return found
}

/// Gives true if predicate gives true for all of the items.
Method all(predicate As %ZLib.Delegates.Converter) As %Boolean
{
	#dim found as %Boolean
	set found = $$$YES

	for i=1:1:..Count()
	{
		set found = predicate.invoke(..GetAt(i))
		quit:'found
	}

	return found
}

/// Gives true if predicate gives true for any of the items of the list.
ClassMethod listAny(list As %AbstractList, predicate As %ZLib.Delegates.Converter) As %Boolean
{
	return ..fromList(list).any(predicate)
}

/// Gives the sum of the items according to the converter.
Method sum(converter As %ZLib.Delegates.Converter = {..getDefaultConverter()}) As %Float
{
	#dim sum as %Float

	set sum = 0
	for i=1:1:..Count()
	{
		set sum = sum + converter.invoke(..GetAt(i))
	}
	return sum
}

/// Gives a sublist containing every item which the predicate gives true for.
Method select(predicate As %ZLib.Delegates.Converter) As %ZLib.XList
{
	#dim list as %ZLib.XList
	#dim item as %RegisteredObject
	
	set list = ..instantiate()

	for i=1:1:..Count()
	{
		set item = ..GetAt(i)
		do:(predicate.invoke(item)) list.Insert(item)
	}

	return list
}

/// Removes all entries that match the predicate.
Method remove(predicate As %ZLib.Delegates.Converter)
{
	do ..removeMany(..select(predicate))
}

/// Gives a sublist containing every list item which the predicate gives true for.
ClassMethod listSelect(list As %AbstractList, predicate As %ZLib.Delegates.Converter) As %ZLib.XList
{
	return ..fromList(list).select(predicate)
}

/// Calls action for every item.
Method foreach(action As %ZLib.Delegates.Action)
{
	for i=1:1:..Count()
	{
		do action.invoke(..GetAt(i))
	}
}

/// Gives the first item.
Method first() As %RegisteredObject
{
	return $S(..Count()>0:..GetAt(1),1:"")
}

/// Gives the last item.
Method last() As %RegisteredObject
{
	return $S(..Count()>0:..GetAt(..Count()),1:"")
}

/// Appends the list's items.
Method insertMany(list As %AbstractList)
{
	return:'$IsObject(list)
	for i=1:1:list.Count()
	{
		do ..Insert(list.GetAt(i))
	}
}

/// Removes the list's items
Method removeMany(list As %AbstractList)
{
	#dim array as %AbstractArray
	#dim deletes as %ZLib.XListOfDataTypes
	#dim i as %Integer
	
	set array = ..fromList(list).toKeyedArray()
	set deletes = ##class(%ZLib.XListOfDataTypes).%New()
	
	for i=1:1:..Count()
	{
		do:array.IsDefined(..GetAt(i)) deletes.Insert(i)
	}
	for i=1:1:deletes.Count()
	{
		do ..RemoveAt(deletes.GetAt(i))
	}
}

/// Gives an array of sublists keyed by the converter.
Method groupBy(keyGetter As %ZLib.Delegates.Converter) As %AbstractArray
{
	#dim a as %AbstractArray
	#dim key as %RegisteredObject
	
	set a =  ..newArray()
	
	for i=1:1:..Count()
	{
		set key = keyGetter.invoke(..GetAt(i))
		do:('a.IsDefined(key)) a.SetAt(..%New(),key)
		do a.GetAt(key).Insert(..GetAt(i))
	}
	
	return a
}

/// Gives an XList descending ordered by the converter's return value for every item.
Method orderDescBy(converter As %ZLib.Delegates.Converter = {..getDefaultConverter()}) As XList
{
	return ..getOrderedList(..groupBy(converter),0)
}

/// Gives an XList ascending ordered by the converter's return value for every item.
Method orderAscBy(converter As %ZLib.Delegates.Converter = {..getDefaultConverter()}) As XList
{
	return ..getOrderedList(..groupBy(converter))
}

ClassMethod getDefaultConverter() As %ZLib.Delegates.ClassMethodConverter [ Internal, Private ]
{
	return ##class(%ZLib.Delegates.ClassMethodConverter).create(..%ClassName(1), "getItem", 1)
}

/// Returns just what you put in to be used as simple converter.
ClassMethod getItem(item As %RegisteredObject) As %RegisteredObject
{
	return item
}

Method getOrderedList(orderedArray As %AbstractArray, asc As %Boolean = 1) As XList [ Internal, Private ]
{
	#dim result as XList
	#dim items as XList
	#dim key as %String
	
	set result = ..instantiate()
	
	set key = $S(asc:orderedArray.Next(),1:orderedArray.Previous())
	while key'=""
	{
		set items = orderedArray.GetAt(key)
		for i=1:1:items.Count()
		{
			do result.Insert(items.GetAt(i))
		}
		set key = $S(asc:orderedArray.Next(key),1:orderedArray.Previous(key))
	}
	
	return result
}

Method newArray() As %AbstractArray [ Internal, Private ]
{
	return $S(..%IsA(##class(%ZLib.XListOfObjects).%ClassName(1)):##class(%ArrayOfObjects).%New(),1:##class(%ArrayOfDataTypes).%New())
}

/// Gives an XList containing every entry just once concerning the converter.
Method distinct(converter As %ZLib.Delegates.Converter = {..getDefaultConverter()}) As %ZLib.XList
{
	#dim x as %ZLib.XList
	#dim a as %ArrayOfDataTypes
	#dim e as %RegisteredObject
	#dim converted as %RegisteredObject
	
	set a = ##class(%ArrayOfDataTypes).%New()
	set x = ..instantiate()
	
	for i=1:1:..Count()
	{
		set e = ..GetAt(i)
		set converted = converter.invoke(e)
		continue:a.IsDefined(converted)
		
		do x.Insert(e)
		do a.SetAt(1,converted)
	}
	
	return x
}

/// Appends the array values.
Method insertArrayValues(array As %AbstractArray)
{
		#dim key as %String

		set key = array.Next()
		while key '= ""
		{
			do ..Insert(array.GetAt(key))
			set key = array.Next(key)
		}
}

/// Gives an XList containing the retur value of the converter for every item.
Method convertAll(converter As %ZLib.Delegates.Converter) As XList
{
	#dim x as XList
	
	set x = $S(converter.ResultIsDataType:##class(%ZLib.XListOfDataTypes).%New(),1:##class(%ZLib.XListOfObjects).%New())
	
	for i=1:1:..Count()
	{
		do x.Insert(converter.invoke(..GetAt(i)))
	}
	
	return x
}

/// Returns true if this list doesn't contain any items.
Method isEmpty() As %Boolean
{
	return ..Count()=0
}

/// Gives an XList containing the retur value of the converter for every item in the list.
ClassMethod listConvertAll(list As %AbstractList, converter As %ZLib.Delegates.Converter) As XList
{
	return ..fromList(list).convertAll(converter)
}

/// Gives the minimum return value of the converter for all items.
Method min(converter As %ZLib.Delegates.Converter = {..getDefaultConverter()}, skipEmptyValues As %Boolean = 0) As %RegisteredObject
{
	return:..isEmpty() ""
	return converter.invoke(..minItem(converter,skipEmptyValues))
}

/// Gives the item having the minimum return value of the converter.
Method minItem(converter As %ZLib.Delegates.Converter = {..getDefaultConverter()}, skipEmptyValues As %Boolean = 0) As %RegisteredObject
{
	return ..getBestItem(converter,skipEmptyValues,0)
}

/// Gives the maximum return value of the converter for all items.
Method max(converter As %ZLib.Delegates.Converter = {..getDefaultConverter()}, skipEmptyValues As %Boolean = 0) As %RegisteredObject
{
	return:..isEmpty() ""
	return converter.invoke(..maxItem(converter,skipEmptyValues))
}

/// Gives the item having the maximum return value of the converter.
Method maxItem(converter As %ZLib.Delegates.Converter = {..getDefaultConverter()}, skipEmptyValues As %Boolean = 0) As %RegisteredObject
{
	return ..getBestItem(converter,skipEmptyValues,1)
}

Method getBestItem(converter As %ZLib.Delegates.Converter, skipEmptyValues As %Boolean, greatest As %Boolean) As %RegisteredObject [ Internal, Private ]
{
	#dim result as %RegisteredObject
	#dim x as %RegisteredObject
	#dim item as %RegisteredObject
	
	set result = ""
    set item = ..first()
	for i=1:1:..Count()
	{
		set x = converter.invoke(..GetAt(i))
		continue:(skipEmptyValues)&&(x="")
		if ..isBetter(result, x, greatest)
		{
			set result = x
			set item = ..GetAt(i)
		}
	}
	
	return item
}

/// Gives a string containing the return values of the converter for every item seperated by the seperator.
Method toString(seperator As %String = ", ", converter As %ZLib.Delegates.Converter = {..getDefaultConverter()}) As %String
{
	#dim line as %String
	set line = ""
	for i=1:1:..Count()
	{
		set line = line_..GetAt(i)_seperator
	}

	return $E(line,1,*-$L(seperator))
}

/// Gives an XList of sublists with a limited number of items.
Method toChunks(chunkSize As %Integer = 500) As %ZLib.XListOfObjects
{
	#dim chunks as %ZLib.XListOfObjects
	#dim chunk as %ZLib.XList
	
	set chunks = ##class(%ZLib.XListOfObjects).%New()
	set chunk = ..%New()
	
	for i=1:1:..Count()
	{
		do chunk.Insert(..GetAt(i))
		if (i#chunkSize)=0
		{
			do chunks.Insert(chunk)
			set chunk = ..%New()
		}
	}
	
	do:chunk.Count()>0 chunks.Insert(chunk)
	
	return chunks
}

/// Gives an ordered array containing the list values.
Method toArray() As %AbstractArray
{
	#dim array as %AbstractArray
	
	set array = ..newArray()
	for i=1:1:..Count()
	{
		do array.SetAt(..GetAt(i),i)
	}
	return array
}

/// Gives a keyed array containing the list values.
Method toKeyedArray(keyGetter As %ZLib.Delegates.Converter = {..getDefaultConverter()}) As %AbstractArray
{
	#dim array as %AbstractArray
	#dim entry as %RegisteredObject
	
	set array = ..newArray()
	for i=1:1:..Count()
	{
		set entry = ..GetAt(i)
		do array.SetAt(entry,keyGetter.invoke(entry))
	}
	return array
}

Method isBetter(bestValue As %RegisteredObject, currentValue As %RegisteredObject, greater As %Boolean) As %Boolean [ Private ]
{
	return bestValue=""||((bestValue<currentValue)&&(greater))||((bestValue>currentValue)&&('greater))
}

ClassMethod instantiate() As XList [ Abstract, Internal, Private ]
{
}

}

