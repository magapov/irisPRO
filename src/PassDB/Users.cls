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

ClassMethod SaveUser(requestUserObj) As %Status
{
  set result = {}
  set obj = ##class(PassDB.Users).%New()
  set obj.fname = requestUserObj.fname
  set obj.sname = requestUserObj.sname
  set obj.age = requestUserObj.fage
  set obj.sex = requestUserObj.sex
  set saveResult = obj.%Save()

  if $$$ISOK(saveResult) set result = {"result": true}
  else  set result = {"result": false}
  set ErrorMessage = ##class(%SYSTEM.Status).GetErrorText(saveResult)
  set result.message = ErrorMessage

  return result
}

ClassMethod sampleDynamicRequest(paramAge)
{
	set sqlRaw = "select * from {%1%} where age>?"
	set table = "PassDB.Users"
	set sql = $Replace(sqlRaw, "{%1%}", table)

	set sqlObj = ##class(%SQL.Statement).%New()
	set qStatus = sqlObj.%Prepare(sql)
	set rset = sqlObj.%Execute(paramAge)
	do rset.%Display()
}

ClassMethod sampleStaticRequest()
{
	set searchAge = 18
	&sql(DECLARE C1 CURSOR FOR 
       SELECT id,name,age,sex 
	   INTO :idVar, :nameVar,:ageVar,:sexVar 
       FROM Company.Users
       WHERE age > :searchAge)
  &sql(OPEN C1)
      QUIT:(SQLCODE'=0)
  &sql(FETCH C1)
  WHILE (SQLCODE = 0) {
     WRITE nameVar," is ",ageVar," years",!
    &sql(FETCH C1) }
  &sql(CLOSE C1)
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
