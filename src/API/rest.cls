Class Api.Rest Extends %CSP.REST
{

Parameter HandleCorsRequest = 1;

/// Docs here https://cedocs.intersystems.com/latest/csp/docbook/DocBook.UI.Page.cls?KEY=GREST_services#GREST_urlmap
XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
  <Route Url="/test" Method="GET" Call="test"/>
  <Route Url="/users/get" Method="GET" Call="Users"/>
  <Route Url="/users/save" Method="POST" Call="SaveUser"/>
  <Route Url="/users/getusernames" Method="GET" Call="UsernamesList"/>
  <Route Url="/passes/get" Method="GET" Call="Passes"/>
  <Route Url="/passes/save" Method="POST" Call="SavePass"/>
  <Route Url="/passes/edit" Method="POST" Call="EditPass"/>
  <Route Url="/passes/delete" Method="DELETE" Call="DeletePass"/>
  <Route Url="/medical/get" Method="GET" Call="Medicals"/>
  <Route Url="/medical/save" Method="POST" Call="SaveMedical"/>
  <Route Url="/medical/getnames" Method="GET" Call="MedicalNamesList"/>
  <Route Url="/work/save" Method="POST" Call="SaveOrganisation"/>
  <Route Url="/work/get" Method="GET" Call="Organisations"/>
  <Route Url="/work/getnames" Method="GET" Call="OrgNamesList"/>
</Routes>
}

ClassMethod SaveUser() As %Status
{
  Try {
    set requestUserObj = {}
    set requestUserObj.fname = %request.Get("fname_f")
    set requestUserObj.sname = %request.Get("sname_f")
    set requestUserObj.age = %request.Get("age_f")
    set requestUserObj.sex = %request.Get("sex_f")
    set result = ##class(PassDB.Users).saveUser(requestUserObj)
    write result.%ToJSON()
  }
  Catch exception {
    set result = {"result": false}
    set result.message = $ZCVT(exception.Name_" "_exception.Location, "O", "HTML")
    write result.%ToJSON()
  }
  Quit $$$OK
}

/// Its test
ClassMethod test() As %Status
{
  //$ZDate function https://docs.intersystems.com/irislatest/csp/docbook/DocBook.UI.Page.cls?KEY=RCOS_fzdate
  set currentDate = $ZDate($Horolog, 3)
  set obj = {"date": (currentDate)}
  write obj.%ToJSON()
  Return $$$OK
}

ClassMethod Users() As %Status
{
  set usersObj = ##class(PassDB.Users).%New()
  do usersObj.getUsers(.usersArray)
  write usersArray.%ToJSON()
  Return $$$OK
}

ClassMethod UsernamesList() As %Status
{
  set usersObj = ##class(PassDB.Users).%New()
  do usersObj.getUsernames(.usersArray)
  write usersArray.%ToJSON()
  Return $$$OK
}

ClassMethod SavePass(requestPassObj) As %Status
{
  Try {
    set requestPassObj = {}
    set requestPassObj.docID = %request.Get("docID")
    set requestPassObj.date = %request.Get("date")
    set requestPassObj.reasonType = %request.Get("reasonType")
    set requestPassObj.sourceAddr = %request.Get("sourceAddr")
    set requestPassObj.dstAddr = %request.Get("dstAddr")
    set requestPassObj.user = %request.Get("user")
    set requestPassObj.medicalOrg = %request.Get("medicalOrg")
    set requestPassObj.jobOrg = %request.Get("jobOrg")
    set result = ##class(PassDB.Pass).SavePass(requestPassObj)
    write result.%ToJSON()
  }
  Catch exception {
    set result = {"result": false}
    set result.message = $ZCVT(exception.Name_" "_exception.Location, "O", "HTML")
    write result.%ToJSON()
  }
  Quit $$$OK
}

ClassMethod Passes() As %Status
{
  set passsObj = ##class(PassDB.Pass).%New()
  do passsObj.getPasses(.passesArray)
  write passesArray.%ToJSON()
  Return $$$OK
}

ClassMethod EditPass() As %Status
{
  set result = ##class(PassDB.Pass).updatePass(%request)
  write result
  return $$$OK
}

ClassMethod DeletePass() As %Status
{
  set id = %request.Get("id")
  set deleteResult = ##class(PassDB.Pass).deletePass(id)
  write deleteResult
  return $$$OK
}

ClassMethod MedicalNamesList() As %Status
{
  set medicalsObj = ##class(PassDB.Medical).%New()
  do medicalsObj.getNames(.medicalsArray)
  write medicalsArray.%ToJSON()
  Return $$$OK
}

ClassMethod Medicals() As %Status
{
  set medicalsObj = ##class(PassDB.Medical).%New()
  do medicalsObj.getAll(.medicalsArray)
  write medicalsArray.%ToJSON()
  Return $$$OK
}

ClassMethod SaveMedical() As %Status
{
  Try {
    set requestMedicalObj = {}
    set requestMedicalObj.name = %request.Get("name")
    set requestMedicalObj.adress = %request.Get("adress")
    set result = ##class(PassDB.Medical).saveMedical(requestMedicalObj)
    write result.%ToJSON()
  }
  Catch exception {
    set result = {"result": false}
    set result.message = $ZCVT(exception.Name_" "_exception.Location, "O", "HTML")
    write result.%ToJSON()
  }
  Quit $$$OK
}

ClassMethod Organisations() As %Status
{
  set orgsObj = ##class(PassDB.Organisation).%New()
  do orgsObj.getAll(.orgsArray)
  write orgsArray.%ToJSON()
  Return $$$OK
}

ClassMethod OrgNamesList() As %Status
{
  set orgsObj = ##class(PassDB.Organisation).%New()
  do orgsObj.getNames(.orgsArray)
  write orgsArray.%ToJSON()
  Return $$$OK
}

ClassMethod SaveOrganisation() As %Status
{
  Try {
    set requestOrgObj = {}
    set requestOrgObj.name = %request.Get("name")
    set requestOrgObj.adress = %request.Get("adress")
    set result = ##class(PassDB.Organisation).saveOrganisation(requestOrgObj)
    write result.%ToJSON()
  }
  Catch exception {
    set result = {"result": false}
    set result.message = $ZCVT(exception.Name_" "_exception.Location, "O", "HTML")
    write result.%ToJSON()
  }
  Quit $$$OK
}

ClassMethod SwaggerSpec() As %Status
{
  Set tSC = ##class(%REST.API).GetWebRESTApplication($NAMESPACE, %request.Application, .swagger)
  Do swagger.info.%Remove("x-ISC_Namespace")
  Set swagger.basePath = "/"
  Set swagger.info.title = "PackageManager Registry API"
  Set swagger.info.version = "0.1"
  Set swagger.host = "localhost:52773"
  Return ..%ProcessResult($$$OK, swagger)
}

ClassMethod %ProcessResult(pStatus As %Status = {$$$OK}, pResult As %DynamicObject = "") As %Status [ Internal ]
{
  #dim %response As %CSP.Response
  SET tSC = $$$OK
  IF $$$ISERR(pStatus) {
    SET %response.Status = 500
    SET tSC = ..StatusToJSON(pStatus, .tJSON)
    IF $isobject(tJSON) {
      SET pResult = tJSON
    } ELSE {
      SET pResult = { "errors": [ { "error": "Unknown error parsing status code" } ] }
    }
  } 
  ELSEIF pStatus=1 {
    IF '$isobject(pResult){
      SET pResult = {
      }
    }
  }
  ELSE {
    SET %response.Status = pStatus
    SET error = $PIECE(pStatus, " ", 2, *)
    SET pResult = {
      "error": (error)
    }
  }
  
  IF pResult.%Extends("%Library.DynamicAbstractObject") {
    WRITE pResult.%ToJSON()
  }
  ELSEIF pResult.%Extends("%JSON.Adaptor") {
    DO pResult.%JSONExport()
  }
  ELSEIF pResult.%Extends("%Stream.Object") {
    DO pResult.OutputToDevice()
  }
  
  QUIT tSC
}

}
