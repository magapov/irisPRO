Class PassDB.Medical Extends %Persistent
{

Property name As %String;

Property adress As %String;

Storage Default
{
<Data name="MedicalDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>name</Value>
</Value>
<Value name="3">
<Value>adress</Value>
</Value>
</Data>
<DataLocation>^PassDB.MedicalD</DataLocation>
<DefaultData>MedicalDefaultData</DefaultData>
<IdLocation>^PassDB.MedicalD</IdLocation>
<IndexLocation>^PassDB.MedicalI</IndexLocation>
<StreamLocation>^PassDB.MedicalS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
