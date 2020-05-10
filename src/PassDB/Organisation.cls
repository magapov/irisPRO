Class PassDB.Organisation Extends %Persistent
{

Property name As %String;

Property adress As %String;

Storage Default
{
<Data name="OrganisationDefaultData">
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
<DataLocation>^PassDB.OrganisationD</DataLocation>
<DefaultData>OrganisationDefaultData</DefaultData>
<IdLocation>^PassDB.OrganisationD</IdLocation>
<IndexLocation>^PassDB.OrganisationI</IndexLocation>
<StreamLocation>^PassDB.OrganisationS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
