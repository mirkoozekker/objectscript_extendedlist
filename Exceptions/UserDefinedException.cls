/// Inhalt:   	für TRY CATCH ERROR - THROW user defined exceptions
Class %ZLib.Exceptions.UserDefinedException Extends (%Exception.AbstractException, %ZLib.Exceptions.TraceDisableableException)
{

/// Der Build-Kontext. Hier wird festgelegt, in welchen Builds die Klasse
/// enthalten ist.
Parameter CONTEXT = "ADMIN,KERN,ALLE";

Property Name As %String;

Property Code As %String;

Property Location As %String;

Property Data As %String;

Property InnerException As %Exception.AbstractException;

Property Fehlermeldung As %String;

Property Fehlerdetails As %String;

Method %OnNew(pName As %String = "", pCode As %String = "", pLocation As %String = "", pData As %String = "", pInnerException As %Exception.AbstractException = {$$$NULLOREF}, pFehlermeldung As %String = "", pFehlerdetails As %String = "", traceDisabled As %Boolean = 1) As %Status [ Private ]
{
	Set ..Name = pName
	set ..Code = pCode
	set ..Location = pLocation
	set ..Data = pData
	set ..InnerException = pInnerException
	set ..Fehlermeldung = pFehlermeldung
	set ..Fehlerdetails = pFehlerdetails
	set ..TraceDisabled = traceDisabled
	Quit $$$OK
}

/// This outputs the string representation of the exception to the current device, recursively
/// outputing any inner exceptions. 
Method OutputToDevice(pLevel As %Integer = 0)
{
	Set tStream = ##class(%GlobalCharacterStream).%New()
	Do ..OutputToStream(tStream,pLevel)
	Do tStream.OutputToDevice()
}

/// Margrit Miric
/// --- Fehler im servace Protokollfenster anzeigen
Method FehlerAnzeigeImProtokoll()
{
   ;write !,"################################## Method FehlerAnzeigeImProtokoll()"

   write !,"myExceptionUserDefined.Code:      " _ ..Code,!
   write !,"myExceptionUserDefined.Name:       " _ ..Name,!
   write !,"myExceptionUserDefined.Fehlerdetails:       " _ ..Fehlerdetails,!
   write !,"myExceptionUserDefined.Location:       " _ ..Location,!
   write !,"myExceptionUserDefined.Data:       " _ ..Data,!
   write !,"myExceptionUserDefined.Fehlermeldung:       " _ ..Fehlermeldung,!
   write !,"- - - - -",! 

   Quit $$$OK
}

/// --- Fehler im GUI-Fehlerfenster anzeigen
/// 
/// ToDo:  später bei Bedarf alle Fehlerparameter anzeigen, d.h. zusätzlich auch noch:
/// .. Code, .. Name, .. Location 
/// (alles in gleicher Reihenfolge wie in: Method FehlerAnzeigeImProtokoll())  
Method FehlerAnzeigeImFenster()
{
   set fensterText = "<html><b>" _ ..Fehlerdetails _ "</b><br><br>" _ ..Data _ "<br><br>" _   ..Fehlermeldung _"</html>"
   	
   Quit fensterText
}

/// Override this method to provide a custom conversion of an exception to a status
Method OnAsStatus() As %Status [ CodeMode = expression, Private ]
{
$$$ERROR(..Code,..Data,,,,,,,,,..Location)
}

Method DisplayString(pLevel As %Integer = 0) As %String
{
	#dim displayString as %String
	
 	set displayString = ..Fehlermeldung
 	set:(..Fehlerdetails'="") displayString = displayString_$CHAR(10)_..Fehlerdetails
 	
 	quit displayString
}

}

