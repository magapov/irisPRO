/// Компании
Class PassDB.Company Extends %Persistent
{

Property name As %String;

Property inn As %Integer;

Index inn On inn [ Data = name ];

Storage Default
{
<Data name="CompanyDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>name</Value>
</Value>
<Value name="3">
<Value>inn</Value>
</Value>
</Data>
<DataLocation>^PassDB.CompanyD</DataLocation>
<DefaultData>CompanyDefaultData</DefaultData>
<IdLocation>^PassDB.CompanyD</IdLocation>
<IndexLocation>^PassDB.CompanyI</IndexLocation>
<StreamLocation>^PassDB.CompanyS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
