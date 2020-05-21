Class PassDB.Medical Extends %Persistent
{

Property name As %String;

Property adress As %String;

Method getAll(data) As %String
{
    set data = []
	&sql(
	 	DECLARE MyCursor CURSOR FOR
	    SELECT id, name, adress
	    INTO :id, :name, :adress
	    FROM PassDB.Medical
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

Method getNames() As %Status
{
    set data = []
	&sql(
	 	DECLARE MyCursor CURSOR FOR
	    SELECT id, name
	    INTO :id, :name
	    FROM PassDB.Medical
 	)

 	&sql(OPEN MyCursor)
    FOR { 
        &sql(FETCH MyCursor)
        if (SQLCODE) quit

        set obj = {"id": (id), "name": (name)}
        do data.%Push(obj)
 	}
 	&sql(CLOSE MyCursor)
 	quit
}

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
