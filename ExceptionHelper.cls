Class %ZLib.ExceptionHelper Extends %RegisteredObject
{

/// Lokalisiert den Text und wirft ihn als GeneralException
ClassMethod raiseException(name As %String, text As %String)
{
	Throw ##class(%Exception.General).%New(name,,,text)
}

/// Wirft den übergebenen Text ohne Lokalisation als GeneralException
ClassMethod raiseLocalizedException(name As %String, text As %String)
{
}

/// Lokalisiert den Text und wirft ihn als UserDefined Exception, die Details werden nicht lokalisiert
ClassMethod raiseExceptionUD(name As %String, text As %String, details As %String = "")
{
	Throw ##class(%ZLib.Exceptions.UserDefinedException).%New(name,,,text,,text,details)
}

/// Wirft den Text als UserDefined Exception, Text und Details werden nicht lokalisiert
ClassMethod reraise(exception As %Exception.AbstractException)
{
	Throw ##class(%ZLib.Exceptions.ReThrowException).create(exception)
}

/// Gibt an, ob die übergebene Exception mit Stack nicht in die Anwendungsausgabe geschrieben werden soll.
ClassMethod traceDisabled(ex As %Exception.AbstractException) As %Boolean
{
	return $IsObject(ex) && ex.%IsA(##class(%ZLib.Exceptions.TraceDisableableException).%ClassName(1)) && ex.TraceDisabled
}

/// Gibt eine Exception mit ihrere Inner Exception aus, wenn diese vorhanden ist
/// @param ex bezeichnet die Exception
/// @return gibt den Fehler Text aus
ClassMethod displayWithInnerException(ex As %Exception.AbstractException) As %String
{
	return ex.DisplayString()_$S(ex.InnerException '= $$$NULLOREF:..displayWithInnerException(ex.InnerException),1:"")
}

/// Gibt eine Exception mit ihrere Inner Exception aus, wenn diese vorhanden ist
/// @param ex bezeichnet die Exception
/// @return gibt den Fehler Text aus
ClassMethod displayWithInnerExceptionWithStack(ex As %Exception.AbstractException) As %String
{
	return $SYSTEM.Status.GetErrorText(ex.AsStatus())
}

/// Zählt den PLevel einer Exception
/// @param ex bezeichnet die zu prüfende Exception
/// @return gibt den PLevel der Exception zurück
ClassMethod countPLevel(ex As %Exception.AbstractException) As %Integer
{
	return:(ex = "") 0
	return 1+..countPLevel(ex.InnerException)
}

/// Schreibt den Stack in einen String aus
/// @return liefert den Stack zurück
ClassMethod printStack() As %String
{
	#dim stream As %Stream.GlobalCharacter = ##class(%Stream.GlobalCharacter).%New()
	#dim a As %String = ""
	#dim i As %Integer
	#dim place As %String
	#dim last As %String = ""
	
	do stream.WriteLine($ZERROR )
	for i=$STACK:-1:1
	{
		set place = $STACK(i,"PLACE")
		set a = $STACK(i,"MCODE")_" ["_place_"]"
		
		do:(last '= a) stream.WriteLine(a)
		set last = a
	}
	return stream.Read(99999999)
}

/// Zeigt den Stack auf der StdKonsole an 
/// @param exception bezeichnet die geworfende Fehlermeldung
/// @return gibt den Fehler zurück
ClassMethod stackAsString(exception As %Exception.AbstractException)
{
	#dim str As %String
	return:('$IsObject(exception)) ""
	set str = $SYSTEM.Status.GetErrorText(exception.AsStatus())
	set:('$IsObject(exception.InnerException)) str = str_exception.Location
	return str_..stackAsString(exception.InnerException)
}

/// Gibt den Stack bis zum Auftreten der Exception als separierten String zurück.
ClassMethod getStack(ex As %Exception.AbstractException, separator As %String = ";") As %String
{
	#dim array as %String
	#dim str as %String
	#dim key as %String
	#dim sep as %String
	
	set sep = separator_" "
	
	do ex.StackAsArray(.array)
	set str=""
  SET key=$ORDER(array(""))
  WHILE (key'="") {
		set str=array(key)_" ("_array(key,"PLACE")_")"_sep_str
		SET key = $ORDER(array(key))
  }
	
	return $E(str,1,*-$L(sep)-1)
}

}

