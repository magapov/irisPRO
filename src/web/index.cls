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

var deletePassFormCallback = (rawData) => {
  let data = JSON.parse(rawData);
  let message;
  if (data.result) {
    message = { type:"success", text: "Pass is deleted", expire: 2000};
  }
  else {
    message = { type:"error", text: data.message, expire:2000};
  }
  webix.message(message);
};

var savePassFormCallback = (rawData) => {
  let data = JSON.parse(rawData);
  let message;
  if (data.result) {
    message = { type:"success", text: "Pass is edited", expire: 2000};
  }
  else {
    message = { type:"error", text: data.message, expire:2000};
  }
  webix.message(message);
};

var menu_data = [
  {id: "tab1", icon: "mdi mdi-account", value:"Users", data: [
  	{id: "tab1_show", icon: "mdi mdi-table", value:"Users list"},
	  {id: "tab1_create", icon: "mdi mdi-pencil", value:"Create user"},
  ]},
  {id: "tab2", icon: "mdi mdi-book", value:"Passes", data:[
    {id: "tab2_show", icon: "mdi mdi-table", value:"Passes list"},
	  {id: "tab2_create", icon: "mdi mdi-pencil", value:"Create pass"},
  ]},
  {id: "tab3", icon: "mdi mdi-hospital", value:"Medical facilities", data:[
    {id: "tab3_show", icon: "mdi mdi-table", value:"Medical facilities list"},
    {id: "tab3_create", icon: "mdi mdi-pencil", value:"Create medical facility"},
  ]},
  {id: "tab4", icon: "mdi mdi-tie", value:"Job rganizations", data:[
    {id: "tab4_show", icon: "mdi mdi-table", value:"Job organizations list"},
    {id: "tab4_create", icon: "mdi mdi-pencil", value:"Create job organization"},
  ]},
];

var user_list_template = {
  id:"tab1_show_content",
  view:"datatable",
  //template:"<div style='padding-left:18px'> First name:#fname#, surname:#sname#, age:#age#, sex:#sex# </div>",
  //type:{
  //  height:60
  //},
  //select:true,
  minHeight:50,
  autoWidth: true,
  autoConfig:true,
  url:"/passesapp/users/get"
};

// Single user form template
var user_form_template = {
  id:"tab1_create_content",
  view:"form",
  width: "400",
  height: "800",
  elements:[
    {view: "text", name: "fname_f", label: "First name"},
    {view: "text", name: "sname_f", label: "Surname"},
    {view: "text", name: "age_f", label: "Age"},
    {view: "text", name: "sex_f", label: "Sex"},
    { view:"button",  value:"Submit", id:"btn1", click:function(){
      console.log('button user');
      var values = this.getFormView().getValues();
      webix.ajax().post("/passesapp/users/save", values, submitUser);
    }}
  ]};

var passes_list_template = {
  id:"tab2_show_content",
  autowidth: true,
  rows: [
  { 
      id: "tab3_dt",
      view:"datatable",
      //template:"<div style='padding-left:18px'> First user:#user#, document ID:#docID#, date:#date#, reason type:#reasonType# source address:#sourceAddr# destination address#dstAddr#</div>",
      //type:{
      //  height:60
      //},
      //select:true,
      minHeight:50,
      autoWidth: true,
      columns:[
        { id:"id", header:"Id",  		width:50},
        { id:"docID", editor:"text",	header:"Document ID", width:200},
        { id:"date", editor:"text",	header:"Date", 	width:200},
        { id:"reasonType", editor:"text",	header:"Reason type", 	width:100},
        { id:"sourceAddr", editor:"text",	header:"Source adress", 	width:200},
        { id:"dstAddr", editor:"text",	header:"Destination adress", 	width:200},
        { id:"user",	header:"User", 	width:100},
        { id:"medicalOrg",	header:"Medical organisation", 	width:100},
        { id:"jobOrg", header:"Job organisation", 	width:100},
      ],
      editable:true,
      editaction:"custom",
      select: "row",
      on:{
        onAfterLoad:function(){
          if (!this.count())
            this.showOverlay("Sorry, there is no data");
        },
        onItemDblClick:function(id, e, node) {
          this.editRow(id);
        }
      },
      url:"/passesapp/passes/get"
    },
    { cols: [
//      { view:"button",  value:"Add Empty Row", id:"tab2_add_button", click:function(){
//          var new_row = { number: "", label: "" , power: ""};
//          $$("tab2_dt").add(new_row);
//          webix.ajax().post(CAR_ADD_URL, new_row, addCarFormCallback);
//      }},
      { view:"button",  value:"Save updated row", id:"tab3_save_button", click:function(){
        var row_id = $$("tab3_dt").getSelectedId();
        if(row_id) {
          var obj = $$("tab3_dt").getSelectedItem(true);
          var values = obj[0];
          webix.message(`Selected to edit ${row_id} : ${values}`);
          webix.ajax().post("/passesapp/passes/edit", values, savePassFormCallback);
        }
      }},
      { view:"button",  value:"Delete Row", id:"tab3_delete_button", click:function(){
        var row_id = $$("tab3_dt").getSelectedId(true);
        console.log(row_id)
        if(row_id) {
          var obj = $$("tab3_dt").getSelectedItem(true);
          var value = obj[0].id;
          webix.message(`Selected to delete ${value}`);
          $$("tab3_dt").remove(row_id);
          webix.ajax().del("/passesapp/passes/delete", {id: value}, deletePassFormCallback);
        }
      }}
    ]}
  ]
};

// Single pass form template
var passes_form_template = {
  id:"tab2_create_content",
  view:"form",
  width: "400",
  height: "800",
  elements:[
    {view: "text", name: "docID", label: "docID"},
    {view: "text", name: "reasonType", label: "reasonType"},
    {view: "text", name: "sourceAddr", label: "sourceAddr"},
    {view: "text", name: "dstAddr", label: "dstAddr"},
    {view: "richselect", name: "user", label:'user', options: "/passesapp/users/getusernames"},
    {view: "richselect", name: "medicalOrg", label:'Medical Organisation', options: "/passesapp/medical/getnames"},
    {view: "richselect", name: "workOrg", label:'Work organisation', options: "/passesapp/work/getnames"},
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
     webix.ajax().post("/passesapp/passes/save", values, submitPass);
   }}
  ]};

var medical_list_template = {
  id:"tab3_show_content",
  view:"datatable",
  minHeight:50,
  autoWidth: true,
  autoConfig:true,
  url:"/passesapp/medical/get"
};

// Single user form template
var medical_form_template = {
  id:"tab3_create_content",
  view:"form",
  width: "400",
  height: "800",
  elements:[
    {view: "text", name: "name", label: "Name"},
    {view: "text", name: "adress", label: "Adress"},
    { view:"button",  value:"Submit", id:"bt3", click:function(){
      var values = this.getFormView().getValues();
      webix.ajax().post("/passesapp/medical/save", values, submitMedical);
    }}
  ]};

var work_list_template = {
  id:"tab4_show_content",
  view:"datatable",
  minHeight:50,
  autoWidth: true,
  autoConfig:true,
  url:"/passesapp/work/get"
};

// Single user form template
var work_form_template = {
  id:"tab4_create_content",
  view:"form",
  width: "400",
  height: "800",
  elements:[
    {view: "text", name: "name", label: "Name"},
    {view: "text", name: "adress", label: "Adress"},
    { view:"button",  value:"Submit", id:"bt4", click:function(){
      var values = this.getFormView().getValues();
      webix.ajax().post("/passesapp/work/save", values, submitWork);
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
