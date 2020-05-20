Class PassDB.Pass Extends %Persistent
{

Property user As PassDB.Users;

Property docID As %Integer;

Property date As %Date;

Property reasonType As %String;

Property sourceAddr As %String;

Property dstAddr As %String;

Method createPass(user As PassDB.Users, docID As %Integer, date As %Date, reasonType As %String, sourceAddr As %String, dstAddr As %String) As %Boolean
{
    do Pass.userSetObjectId(user)
    set ##this.docID = docID
    set ##this.date = date
    set ##this.reasonType = reasonType
    set ##this.sourceAddr = sourceAddr
    set ##this.dstAddr = dstAddr
    set result = ##this.%Save()
    quit result
}

Method getPasses(data) As %String
{
    set data = []
    &sql(
        DECLARE MyCursor CURSOR FOR
        SELECT ID, "date", docID, dstAddr, reasonType, sourceAddr, "user"
        INTO :id, :user, :docID, :date, :reasonType, :sourceAddr, :dstAddr
        FROM PassDB.Pass
    )

    &sql(OPEN MyCursor)

    FOR {
        &sql(FETCH MyCursor)
        if (SQLCODE) quit

        set obj = {"id": (id), "user": (user), "docID": (docID), "date": (date), "reasonType": (reasonType), "sourceAddr": (sourceAddr), "dstAddr": (dstAddr)}
        do data.%Push(obj)
    }
    &sql(CLOSE MyCursor)

    quit
}

ClassMethod SavePass(requestPassObj) As %Status
{
  set result = {}
  set obj = ##class(PassDB.Pass).%New()
#;   set obj.user = requestPassObj.user
  set obj.docID = requestPassObj.docID
  set obj.reasonType = requestPassObj.reasonType
  set obj.sourceAddr = requestPassObj.sourceAddr
  set obj.dstAddr = requestPassObj.dstAddr
  set saveResult = obj.%Save()

  if $$$ISOK(saveResult) set result = {"result": true}
  else  set result = {"result": false}
  set ErrorMessage = ##class(%SYSTEM.Status).GetErrorText(saveResult)
  set result.message = ErrorMessage

  return result
}

Storage Default
{
<Data name="PassDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>docID</Value>
</Value>
<Value name="3">
<Value>date</Value>
</Value>
<Value name="4">
<Value>reasonType</Value>
</Value>
<Value name="5">
<Value>sourceAddr</Value>
</Value>
<Value name="6">
<Value>dstAddr</Value>
</Value>
<Value name="7">
<Value>user</Value>
</Value>
</Data>
<DataLocation>^PassDB.PassD</DataLocation>
<DefaultData>PassDefaultData</DefaultData>
<IdLocation>^PassDB.PassD</IdLocation>
<IndexLocation>^PassDB.PassI</IndexLocation>
<StreamLocation>^PassDB.PassS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
