Class PassDB.Organisation Extends %Persistent
{

Property name As %String;

Property adress As %String;

ClassMethod saveOrganisation(requestOrgObj) As %Status
{
  set result = {}
  set obj = ##class(PassDB.Organisation).%New()
  set obj.name = requestOrgObj.name
  set obj.adress = requestOrgObj.adress
  set saveResult = obj.%Save()

  if $$$ISOK(saveResult) set result = {"result": true}
  else  set result = {"result": false}
  set ErrorMessage = ##class(%SYSTEM.Status).GetErrorText(saveResult)
  set result.message = ErrorMessage

  return result
}

Method getAll(data) As %String
{
    set data = []
	&sql(
	 	DECLARE MyCursor CURSOR FOR
	    SELECT id, name, adress
	    INTO :id, :name, :adress
	    FROM PassDB.Organisation
 	)

 	&sql(OPEN MyCursor)
    FOR { 
        &sql(FETCH MyCursor)
        if (SQLCODE) quit

        set obj = {"id": (id), "name": (name), "adress": (adress)}
        do data.%Push(obj)
 	}
 	&sql(CLOSE MyCursor)
 	quit
}

Method getNames(data) As %Status
{
    set data = []
	&sql(
	 	DECLARE MyCursor CURSOR FOR
	    SELECT id, name
	    INTO :id, :name
	    FROM PassDB.Organisation
 	)

 	&sql(OPEN MyCursor)
    FOR { 
        &sql(FETCH MyCursor)
        if (SQLCODE) quit

        set obj = {"id": (id), "value": (name)}
        do data.%Push(obj)
 	}
 	&sql(CLOSE MyCursor)
 	quit
}

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
