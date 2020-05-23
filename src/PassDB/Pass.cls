Class PassDB.Pass Extends %Persistent
{

Property user As PassDB.Users;

Property docID As %Integer;

Property date As %String;

Property reasonType As %String;

Property sourceAddr As %String;

Property dstAddr As %String;

Property medicalOrg As PassDB.Medical;

Property jobOrg As PassDB.Organisation;

ClassMethod updatePass(ID As %Integer, usr As PassDB.Users, date As %String = "", reason As %String = "", src As %String = "", dst As %String = "", med As PassDB.Medical, job As PassDB.Organisation) As %Status
{
	set obj = ##class(PassDB.Pass).%OpenId(ID)
    set obj.user = usr
	If date '= "" {
		set obj.date = date
	}
	If reason '= "" {
		set obj.reasonType = reason
	}
	If src '= "" {
		set obj.sourceAddr = src
	}
    If dst '= "" {
		set obj.dstAddr = dst
	}
	set obj.medicalOrg = med
    set obj.jobOrg = job
	return obj.%Save()
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

        set obj = {"id": (id), "user": (user), "docID": (docID), "date": (date), "reasonType": (reasonType), "sourceAddr": (sourceAddr), "dstAddr": (dstAddr), "medicalOrg": (medicalOrg), "jobOrg": (jobOrg)}
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
  set obj.date = requestPassObj.date
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
    set result = ##class(PassDB.Pass).%DeleteId(ID)
    Return result
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
