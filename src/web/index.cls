Class web.index Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
  do ..header()
  do ##class(web.index).body()
  do ..footer()
    Quit $$$OK
}

ClassMethod header() As %Status
{
  &HTML<
  <html>
    <head>
      <script type="text/javascript" src="webix/webix.min.js" ></script>
      <link rel="stylesheet" type="text/css" href="webix/webix.min.css">
      <link rel="stylesheet" href="https://cdn.materialdesignicons.com/2.7.94/css/materialdesignicons.css?v=7.2.0" type="text/css" charset="utf-8">
    </head>
  >

  Quit $$$OK
}

/// mostly JS on webix framework
ClassMethod body() As %Status
{
  &JS<
<script type="text/javascript">
  var submitUser = (rawData) => {
    let data = JSON.parse(rawData);
    let message;
    if (data.result) {
      message = { type:"success", text: "User is saved", expire:-1};
      $$('tab2_content').clear();
    }
    else
      message = { type:"error", text: data.message, expire:-1};
    webix.message(message);
  }

  var submitPass = (rawData) => {
    let data = JSON.parse(rawData);
    let message;
    if (data.result) {
      message = { type:"success", text: "Pass is saved", expire:-1};
      $$('tab4_content').clear();
    }
    else
      message = { type:"error", text: data.message, expire:-1};
    webix.message(message);
  } 

  var submitMedical = (rawData) => {
    let data = JSON.parse(rawData);
    let message;
    if (data.result) {
      message = { type:"success", text: "Medical is saved", expire:-1};
      $$('tab6_content').clear();
    }
    else
      message = { type:"error", text: data.message, expire:-1};
    webix.message(message);
  } 

  var submitWork = (rawData) => {
    let data = JSON.parse(rawData);
    let message;
    if (data.result) {
      message = { type:"success", text: "Work organisation is saved", expire:-1};
      $$('tab8_content').clear();
    }
    else
      message = { type:"error", text: data.message, expire:-1};
    webix.message(message);
  } 

var menu_data = [
	{id: "tab1", icon: "mdi mdi-table", value:"Users list"},
	{id: "tab2", icon: "mdi mdi-pencil", value:"User form"},
  {id: "tab3", icon: "mdi mdi-table", value:"Passes list"},
	{id: "tab4", icon: "mdi mdi-pencil", value:"Passes form"},
  {id: "tab5", icon: "mdi mdi-table", value:"Medical facility list"},
  {id: "tab6", icon: "mdi mdi-pencil", value:"Medical facility form"},
  {id: "tab7", icon: "mdi mdi-table", value:"Organizations list"},
  {id: "tab8", icon: "mdi mdi-pencil", value:"Organizations form"},

	//{id: "tab3", icon: "mdi mdi-book", value:"Documentation"}
];

var user_list_template = {
  id:"tab1_content",
  view:"datatable",
  //template:"<div style='padding-left:18px'> First name:#fname#, surname:#sname#, age:#age#, sex:#sex# </div>",
  //type:{
  //  height:60
  //},
  //select:true,
  minHeight:50,
  autoWidth: true,
  autoConfig:true,
  url:"/api/users/get"
};

// Single user form template
var user_form_template = {
  id:"tab2_content",
  view:"form",
  width: "400",
  elements:[
    {view: "text", name: "fname_f", label: "First name"},
    {view: "text", name: "sname_f", label: "Surname"},
    {view: "text", name: "age_f", label: "Age"},
    {view: "text", name: "sex_f", label: "Sex"},
    { view:"button",  value:"Submit", id:"btn1", click:function(){
      console.log('button user');
      var values = this.getFormView().getValues();
      webix.ajax().post("/api/users/save", values, submitUser);
    }}
  ]};

var passes_list_template = {
  id:"tab3_content",
  view:"datatable",
  //template:"<div style='padding-left:18px'> First user:#user#, document ID:#docID#, date:#date#, reason type:#reasonType# source address:#sourceAddr# destination address#dstAddr#</div>",
  //type:{
  //  height:60
  //},
  //select:true,
  minHeight:50,
  autoWidth: true,
  autoConfig:true,
  url:"/api/passes/get"
  };

// Single pass form template
var passes_form_template = {
  id:"tab4_content",
  view:"form",
  width: "400",
  elements:[
    {view: "text", name: "docID", label: "docID"},
    {view: "text", name: "reasonType", label: "reasonType"},
    {view: "text", name: "sourceAddr", label: "sourceAddr"},
    {view: "text", name: "dstAddr", label: "dstAddr"},
    {view: "richselect", name: "user", label:'user', options: "/api/users/getusernames"},
    {view: "richselect", name: "medicalOrg", label:'Medical Organisation', options: "/api/medical/getnames"},
    {view: "richselect", name: "workOrg", label:'Work organisation', options: "/api/work/getnames"},
    {
        view: "datepicker", 
        value: new Date(2017,10,9), 
        label: "Select Date", 
        timepicker: true,
        name: "date"
    },
    

   { view:"button",  value:"Submit", id:"btn2", click:function(){
     console.log('button Pass')
     var values = this.getFormView().getValues();
     webix.ajax().post("/api/passes/save", values, submitPass);
   }}
  ]};

var medical_list_template = {
  id:"tab5_content",
  view:"datatable",
  minHeight:50,
  autoWidth: true,
  autoConfig:true,
  url:"/api/medical/get"
};

// Single user form template
var medical_form_template = {
  id:"tab6_content",
  view:"form",
  width: "400",
  elements:[
    {view: "text", name: "name", label: "Name"},
    {view: "text", name: "adress", label: "Adress"},
    { view:"button",  value:"Submit", id:"bt3", click:function(){
      var values = this.getFormView().getValues();
      webix.ajax().post("/api/medical/save", values, submitMedical);
    }}
  ]};

var work_list_template = {
  id:"tab7_content",
  view:"datatable",
  minHeight:50,
  autoWidth: true,
  autoConfig:true,
  url:"/api/work/get"
};

// Single user form template
var work_form_template = {
  id:"tab8_content",
  view:"form",
  width: "400",
  elements:[
    {view: "text", name: "name", label: "Name"},
    {view: "text", name: "adress", label: "Adress"},
    { view:"button",  value:"Submit", id:"bt4", click:function(){
      var values = this.getFormView().getValues();
      webix.ajax().post("/api/work/save", values, submitWork);
    }}
  ]};

var ui_template = {
  height: '100%',
  rows: [
    { view: "toolbar", padding:3, 
      elements: [
        { view: "button", type: "icon", icon: "mdi mdi-menu",
          width: 37, align: "left", css: "app_button", click: function(){
            $$("$sidebar1").toggle();
          }
        },
        { view: "label", label: "Заказ цифровых пропусков   "},
      ]
    },
    { 
      cols:[
      {
        view: "sidebar",
        data: menu_data,
        on:{
          onAfterSelect: function(id){
            //let value = this.getItem(id).value;
            //webix.message(`Selected ${value}`);
            //$$("t1_content").setHTML(`Selected ${value}`);
            //let displayViewId = `${id}_content`;
            $$(`${id}_content`).show();
            //if (displayViewId === 'tab1_content') $$(displayViewId).refresh();
          }
        }
      },
      { id:"t1_content",
          cells:[
            user_list_template,
            user_form_template,
            passes_list_template,
            passes_form_template,
            medical_list_template,
            medical_form_template,
            work_list_template,
            work_form_template
        ]   
      }
    ]}
  ]};

webix.ready(function(){
  webix.ui(ui_template);
});
</script>
  >
  Quit $$$OK
}

ClassMethod footer() As %Status
{
  &HTML<
    </body></html>
  >
  Quit $$$OK
}

}
