Class PassDB.Pass Extends %Persistent
{

Property user As PassDB.Users;

Property docID As %Integer;

Property date As %Date;

Property reasonType As %String;

Property sourceAddr As %String;

Property dstAddr As %String;

Property medicalOrg As PassDB.Medical;

Property jobOrg As PassDB.Organisation;

ClassMethod updatePass(reqObj) As %DynamicArray
{
    set Id = reqObj.Get("id")
    set obj = ..%OpenId(Id)
	//переделать
    #; set obj = ##class(PassDB.Pass).%OpenId(reqObj.Get("id"))
    #; set obj.user = reqObj.Get("usr")
	set date = reqObj.Get("date")
    If date '= "" {
		set obj.date = date
	}

    set reason = reqObj.Get("reasonType")
	If reason '= "" {
		set obj.reasonType = reason
	}

    set src = reqObj.Get("sourceAddr")
	If src '= "" {
		set obj.sourceAddr = src
	}

    set dst = reqObj.Get("dstAddr")
    If dst '= "" {
		set obj.dstAddr = dst
	}
	#; set obj.medicalOrg = reqObj.Get("medicalOrg")
    #; set obj.jobOrg = reqObj.Get("jobOrg")
	set saveResult = obj.%Save()

    set result = {}
    if $$$ISOK(saveResult) set result = {"result": true}
    else  set result = {"result": false}
    set ErrorMessage = ##class(%SYSTEM.Status).GetErrorText(saveResult)
    set result.message = ErrorMessage

    return result.%ToJSON()
}

Method getPasses(data) As %String
{
    set data = []
    &sql(
        DECLARE MyCursor CURSOR FOR
        SELECT ID, "date", docID, dstAddr, reasonType, sourceAddr, "user", medicalOrg, jobOrg
        INTO :id, :date, :docID, :dstAddr, :reasonType, :sourceAddr, :user, :medicalOrg, :jobOrg
        FROM PassDB.Pass
    )

    &sql(OPEN MyCursor)

    FOR {
        &sql(FETCH MyCursor)
        if (SQLCODE) quit

        set r = ..%OpenId(id)

        set obj = {"id": (id), "user": (r.user.fname_" "_r.user.sname), "docID": (docID), "date": ($ZDate(date, 3)), "reasonType": (reasonType), "sourceAddr": (sourceAddr), "dstAddr": (dstAddr), "medicalOrg": (r.medicalOrg.name), "jobOrg": (r.jobOrg.name)}
        do data.%Push(obj)
    }
    &sql(CLOSE MyCursor)

    quit
}

ClassMethod SavePass(requestPassObj) As %Status
{
  set result = {}
  set obj = ##class(PassDB.Pass).%New()
  do obj.userSetObjectId(requestPassObj.user)
  do obj.medicalOrgSetObjectId(requestPassObj.medicalOrg)
  do obj.jobOrgSetObjectId(requestPassObj.jobOrg)
  set obj.date = $ZDateh(requestPassObj.date, 3)
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

ClassMethod deletePass(ID As %Integer) As %Status
{
    set deleteResult = ##class(PassDB.Pass).%DeleteId(ID)
    set result = {}
    if $$$ISOK(deleteResult) set result = {"result": true}
    else  set result = {"result": false}
    set ErrorMessage = ##class(%SYSTEM.Status).GetErrorText(deleteResult)
    set result.message = ErrorMessage
    return result.%ToJSON()
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
<Value name="8">
<Value>medicalOrg</Value>
</Value>
<Value name="9">
<Value>jobOrg</Value>
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
