/// all users
Class PassDB.Users Extends %Persistent
{

Property fname As %String;

Property sname As %String;

Property age As %Decimal;

Property sex As %String;

Method createUser(fname As %String, sname As %String, age As %Decimal, sex As %String) As %Boolean
{
	set ##this.fname = fname
	set ##this.sname = sname
	set ##this.age = age
	set ##this.sex = sex
	set result = ##this.%Save()
	quit result
}

Method getUsers(data) As %String
{
	set data = []
	&sql(
	 	DECLARE MyCursor CURSOR FOR
	    SELECT id, fname, sname, age, sex
	    INTO :id, :fname, :sname, :age, :sex
	    FROM PassDB.Users
 	)
 	//вариант в массив INTO :singleUserData()
 	&sql(OPEN MyCursor)
 	
  FOR { 
    &sql(FETCH MyCursor)
    if (SQLCODE) quit

    set obj = {"id": (id), "fname": (fname), "sname": (sname), "age": (age), "sex": (sex)}
    do data.%Push(obj)
 	}
 	&sql(CLOSE MyCursor)
 	
 	quit
}

ClassMethod getUsernames(data) As %String
{
	set data = []
	&sql(
	 	DECLARE MyCursor CURSOR FOR
	    SELECT id, fname, sname
	    INTO :id, :fname, :sname
	    FROM PassDB.Users
 	)
	
 	//вариант в массив INTO :singleUserData()
 	&sql(OPEN MyCursor)
 	
  FOR { 
    &sql(FETCH MyCursor)
    if (SQLCODE) quit
	set fullname = fname_" "_sname
    set obj = {"id": (id), "value": (fullname)}
    do data.%Push(obj)
 	}
 	&sql(CLOSE MyCursor)
 	
 	quit
}

ClassMethod SaveUser(requestUserObj) As %Status
{
  set result = {}
  set obj = ##class(PassDB.Users).%New()
  set obj.fname = requestUserObj.fname
  set obj.sname = requestUserObj.sname
  set obj.age = requestUserObj.age
  set obj.sex = requestUserObj.sex
  set saveResult = obj.%Save()

  if $$$ISOK(saveResult) set result = {"result": true}
  else  set result = {"result": false}
  set ErrorMessage = ##class(%SYSTEM.Status).GetErrorText(saveResult)
  set result.message = ErrorMessage

  return result
}

Storage Default
{
<Data name="UsersDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>fname</Value>
</Value>
<Value name="3">
<Value>sname</Value>
</Value>
<Value name="4">
<Value>age</Value>
</Value>
<Value name="5">
<Value>sex</Value>
</Value>
</Data>
<DataLocation>^PassDB.UsersD</DataLocation>
<DefaultData>UsersDefaultData</DefaultData>
<IdLocation>^PassDB.UsersD</IdLocation>
<IndexLocation>^PassDB.UsersI</IndexLocation>
<StreamLocation>^PassDB.UsersS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
