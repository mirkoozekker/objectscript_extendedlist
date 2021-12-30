Class %ZLib.String Extends %RegisteredObject
{

ClassMethod contains(haystack As %String, needle As %String, caseInsensitiv As %Boolean = 0) As %Boolean
{
	return $FIND($S(caseInsensitiv:..upper(haystack),1:haystack),$S(caseInsensitiv:..upper(needle),1:needle))>0
}

ClassMethod upper(text As %String) As %String
{
	return $ZCONVERT(text,"U")
}

/// Füllt einen String links auf.
ClassMethod justifyLeft(text As %String, length As %Integer, charToPad As %String = " ") As %String
{
	set:($L(charToPad)>1) charToPad = $E(charToPad,1)
	set:($L(charToPad)<1) charToPad = " "
	return $TR($J("", length-$L(text))," ", charToPad)_text
}

/// Füllt einen String rechts auf.
ClassMethod justifyRight(text As %String, length As %Integer, charToPad As %String = " ") As %String
{
	set:($L(charToPad)>1) charToPad = $E(charToPad,1)
	set:($L(charToPad)<1) charToPad = " "
	return text_$TR($J("", length-$L(text))," ", charToPad)
}

/// Wiederholt den String <parameter>text</parameter> mehrfach.
ClassMethod repeat(text As %String, count As %Integer) As %String
{
	return $REPLACE($JUSTIFY("", count), " ", text)
}

/// Entfernt Whitespaces am Anfang und am Ende
ClassMethod trim(text As %String) As %String
{
	return $ZSTRIP(text,"<>W")
}

/// Entfernt Whitespaces am Anfang
ClassMethod trimLeft(text As %String) As %String
{
	return $ZSTRIP(text,"<W")
}

/// Entfernt Whitespaces am Ende
ClassMethod trimRight(text As %String) As %String
{
	return $ZSTRIP(text,">W")
}

/// Entfernt doppelte Einträge aus kommaseparierter String.
ClassMethod distinctList(commaSeparated As %String) As %String
{
	#dim i as %Integer
	#dim tmp As %String
	
	set tmp = ","
	for i=1:1:$LENGTH(commaSeparated,",") 
	{
		set:('$FIND(tmp,","_$P(commaSeparated,",",i)_",")) tmp = tmp_$P(commaSeparated,",",i)_","		
	}
	return $EXTRACT(tmp,2,$LENGTH(tmp)-1)
}

/// Ersetzt im Text einen Teilstring durch einen anderen Teilstring.
/// Die Methode führt die Operation "inplace" aus.
/// Hier kann überlegt werden, den Text als Referenzparameter zu übergeben.
/// 
/// @param text - Der gesamte Text.
/// @param patternOld - Der String, der ersetzt werden soll.
/// @param patternNew - Der String der eingesetzt werden soll.
/// @return - Der bearbeitete Text.
ClassMethod replaceText(ByRef text As %String, patternOld As %String, patternNew As %String) As %String
{
	while ($Find(text,patternOld))
	{
		set $Extract(text,$Find(text,patternOld)-$Length(patternOld),$Find(text,patternOld)-1)= patternNew
	}
	return text
}

/// Ersetzt in einem Text einen Teilstring durch einen anderen Teilstring.
/// Die Methode erstellt einen neuen Text mit den geänderten Strings
/// und lässt den originalen Text unverändert.
/// 
/// @param text - Der gesamte Text.
/// @param patternOld - Der String, der ersetzt werden soll.
/// @param patternNew - Der String der eingesetzt werden soll.
/// @return - Der bearbeitete Text.
/// 
ClassMethod getReplaceText(source As %String, patternOld As %String, patternNew As %String) As %String
{
	#dim i as %Integer
	#dim target as %String = ""
	
	for i=1:1:$Length(source,patternOld) {
	   set $Piece(target,patternNew,i) = $Piece(source,patternOld,i)
	}
	return target
}

/// Stellt sicher, dass textToEnsure am Ende tailingRight stehen hat. 
/// <example>
/// set t = "www"
/// w ##class(twa.util.String).ensureRight(.t)
/// // www.
/// w ##class(twa.util.String).ensureRight(.t)
/// // www.
/// w t
/// // www.
/// </example>
ClassMethod ensureRight(ByRef textToEnsure As %String, tailingChar As %String = ".") As %String
{
	set:(($EXTRACT(textToEnsure, *-$LENGTH(tailingChar)+1, *) '= tailingChar) && (textToEnsure '= "")) textToEnsure = textToEnsure_tailingChar

	return textToEnsure
}

/// Stellt sicher, dass textToEnsure am Ende tailingRight stehen hat. 
/// <example>
/// set t = "xlsx"
/// w ##class(twa.util.String).ensureLeft(.t)
/// // .xlsx
/// w ##class(twa.util.String).ensureLeft(.t)
/// // .xlsx
/// w t
/// // .xlsx
/// </example>
ClassMethod ensureLeft(ByRef textToEnsure As %String, leadingChar As %String = ".") As %String
{
	set:(($EXTRACT(textToEnsure, 1, $LENGTH(leadingChar)) '= leadingChar) && (textToEnsure '= "")) textToEnsure = leadingChar_textToEnsure

	return textToEnsure
}

/// Vergleicht zwei String 
ClassMethod compare(left As %String, right As %String, caseSensitive As %Boolean = {$$$NO}, doTrim As %Boolean = {$$$NO}) As %Boolean
{
	#dim compLeft as %String = left
	#dim compRight as %String = right

	if 'caseSensitive {
		set compLeft = $ZCONVERT(compLeft, "L")
		set compRight = $ZCONVERT(compRight, "L")
	}
	if doTrim {
		set compLeft = ..trim(compLeft)
		set compRight = ..trim(compRight)
	}

	return compLeft = compRight
}

/// Gibt den String <parameter>stringToEnclose</parameter> umschlossen von <parameter>encloseChar</parameter> zurück.
ClassMethod enclose(stringToEnclose As %String, encloseChar As %String = "'") As %String
{
	return encloseChar_stringToEnclose_encloseChar
}

ClassMethod createHtmlElement(tagName As %String, content As %String, tagParameter As %String = "") As %String
{
	return "<"_$ZCONVERT(tagName, "U")_" "_tagParameter_">"_content_"</"_$ZCONVERT(tagName, "U")_">"
}

}
