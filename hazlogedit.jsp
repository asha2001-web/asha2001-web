<%@ page language = "java" errorPage="/view/common/ErrorPage.jsp" import="java.sql.*,java.util.ArrayList" %>
<jsp:useBean id = "sh"	class = "model.common.SQLHelper" />
<jsp:useBean id="dc" class="model.common.DateConverter" scope="session" />
<jsp:useBean id = "sessionBean" scope="session" class = "model.common.SessionCheckBean" />
<jsp:useBean id="dbaccess" scope="page" class="model.common.DBAccess" />
 <!-- Below code added on 30-08-2008 by Jaya Sree for Aims Hindi version -->
<jsp:useBean id="prop" scope="session" class="java.util.Properties"/>
<!--end of change -->
<jsp:useBean id="rxd" class="model.fa.ReadingXmlDocument"/>
<jsp:useBean id="ag" class="model.common.AutoGeneration" />
<jsp:useBean id="apdetails" class="java.util.Properties" scope="session"/>
<%!
	public String checkNull( String str )
	{
		if( str == null )
			return " ";
		else
			return str.trim();
	}
 %>

<%	

String contextpath= (String) request.getContextPath();
String uploadpath=apdetails.getProperty("uploadPath");
String mpath=(String)session.getAttribute("mPath");
dbaccess.makeConnection("AVSF");
Connection con=dbaccess.getConnection();
String stationname=sessionBean.getAirportCd();
String str1  = sh.checkNull(dc.getServerDate("YYYYMMDD",con));

String hazid=ag.getNextCodeGBy("tc_hazlog_mt","HAZLOG_ID",12,str1,con);

int slno=1;
int slno1=1;

String HAZLOG_ID=checkNull(request.getParameter("HAZLOG_ID"));
String Parameters="";
String Parameters1="";
String stat ="";

String path = request.getContextPath();
String regionName="";
String userType="";

String readonlyStatus="readonly";
String disabledstatus="disabled";

java.sql.ResultSet rs=null;
java.sql.ResultSet rs1=null;


	userType=sessionBean.getUserCd();

%>
<HTML><HEAD><TITLE>AIMS[Air Traffic Control] - Trainee Log [New]</TITLE>
        
        <META HTTP-EQUIV='expires' CONTENT='0'>
        <link rel="stylesheet" href="css/aai.css" type="text/css">
        <SCRIPT SRC="js/CommonFunctions.js"></SCRIPT>
        <SCRIPT SRC="js/GeneralFunctions.js"></SCRIPT>
        <SCRIPT SRC="js/calendar.js"></SCRIPT>
        <SCRIPT SRC="js/DateTime1.js"></SCRIPT>
        <SCRIPT	SRC="js/EMail and Password.js"></SCRIPT>
        <SCRIPT language = "javascript" >


var detailArray=new Array();   
var detailArray1=new Array();
function loadValues()
{
<%
System.out.println("select HAZLOG_ID,ID,slno,EXISTINGRISK from tc_hazlog_ExistingRisk where  HAZLOG_ID ='"+HAZLOG_ID+"' order by to_number(slno)");
rs = dbaccess.getRecordSet("select HAZLOG_ID,ID,slno,EXISTINGRISK from tc_hazlog_ExistingRisk where  HAZLOG_ID ='"+HAZLOG_ID+"' order by to_number(slno)");

while(rs.next()) {%>

detailArray[detailArray.length]=['<%=checkNull(rs.getString("slno"))%>','<%=checkNull(rs.getString("EXISTINGRISK"))%>'];

<%}
if(rs!=null)
rs.close();
dbaccess.closeRs();
%>		

showValues(-1);

}

function loadValues1()
{
<%
System.out.println("select  slno,NAME ,POTENCIAL_RISK,STATUS_RISK,Description  from tc_hazlog_potencialrisk where  HAZLOG_ID ='"+HAZLOG_ID+"'   order by to_number(slno)");
rs = dbaccess.getRecordSet("select  slno,NAME ,POTENCIAL_RISK,STATUS_RISK,Description  from tc_hazlog_potencialrisk where  HAZLOG_ID ='"+HAZLOG_ID+"'   order by to_number(slno) ");

while(rs.next()) {%>

detailArray1[detailArray1.length]=['<%=checkNull(rs.getString("slno"))%>','<%=checkNull(rs.getString("POTENCIAL_RISK"))%>','<%=checkNull(rs.getString("NAME"))%>','<%=checkNull(rs.getString("STATUS_RISK"))%>','<%=checkNull(rs.getString("Description"))%>'];

<%}
if(rs!=null)
rs.close();
dbaccess.closeRs();
%>		

showValues1(-1);

}


	var winHandle = "";
	var winHandle1 = "";

	var user='<%=userType %>';

	var currentTime = new Date()
	var month = currentTime.getMonth() + 1
	var day = currentTime.getDate()
	var year = currentTime.getFullYear()
	var todaysdate = day + "/" + month + "/" + year ;
	var dtArray=new Array(); 
	
	var httpRequest1; //holds httprequest object
	function sendURL1(url,responseFunction)
	{  
		if (window.ActiveXObject) {			// for IE  
			httpRequest1 = new ActiveXObject("Microsoft.XMLHTTP"); 
		} else if (window.XMLHttpRequest) { // for other browsers  
			httpRequest1 = new XMLHttpRequest(); 
		}
	
		if(httpRequest1) {
			httpRequest1.open("GET", url, true);  // 2nd arg is url with name/value pairs, 3 specify asynchronus communication
			httpRequest1.onreadystatechange = eval(responseFunction) ; //which will handle the callback from the server side element
			httpRequest1.send(null); 
		}
	}

	function closeWin() {
  	  if (vWinCal!=null)    //------line1
		vWinCal.close()     //------line2
	  if (winHandle && winHandle.open && !winHandle.closed) winHandle.close();
	}

	function openWin(Parameters) {    
		winHandle = window.open(Parameters,"a","toolbar=no,status=no,width=300,height=280,left=400,top=250");
		winOpened = true;
		winHandle.window.focus();
	}	
	
	function setMode( mode ) 
	{
if(user=="APD")
{
	if(document.forms[0].APD.value=="")
	{
		alert(" Acceptance  is Mandatory");
		document.forms[0].APD.focus();
		return false;
	}

	if(document.forms[0].APDReview.value=="")
	{
		alert(" 'Reason is Mandatory' is Mandatory");
		document.forms[0].APDReview.focus();
		return false;
	}

}

	
	setValues1();
	setValues();
	document.forms[0].hide.value=mode;		
	}


function setValues1()
{
	
	var temp;
	for(var i=0;i<detailArray1.length;i++){
		temp = detailArray1[i][0]+'|'+detailArray1[i][1]+'|'+detailArray1[i][2]+'|'+detailArray1[i][3]+'|'+detailArray1[i][4];
		document.forms[0].achieveDetails1.options[document.forms[0].achieveDetails1.options.length]=new Option('x',temp);
		document.forms[0].achieveDetails1.options[document.forms[0].achieveDetails1.options.length-1].selected=true;
	}
	
}
function setValues()
{
	var temp;
	for(var i=0;i<detailArray.length;i++)	{
		temp = detailArray[i][0]+'|'+detailArray[i][1];
		document.forms[0].achieveDetails.options[document.forms[0].achieveDetails.options.length]=new Option('x',temp);
		document.forms[0].achieveDetails.options[document.forms[0].achieveDetails.options.length-1].selected=true;
	}
}



function saveDetails()
{   
	//alert("saveDetails====");
	if(document.forms[0].Existing.value==""){
		alert("Please Enter Existing Risk Control  ");
		document.forms[0].Existing.focus();
		return false;
	}
	/*if(document.forms[0].Existing.value!=""){
	 var regex = /^[A-Za-z0-9 ]+$/
 
        //Validate TextBox value against the Regex.
        var isValid = regex.test(document.forms[0].Existing.value);
        if (!isValid) {
            alert("Contains Special Characters.");
			 return false;
        } 
       
	}*/
	save();
	showValues();
	clearDetails();
	return true;
}

function save()
{    
	//alert("save===");
	var vehicle;

	var sno;
	if(document.forms[0].slno.value=='')
		sno=' ';
	else
		sno=document.forms[0].slno.value;

	if(document.forms[0].Existing.value=="")	{
		vehicle=' ';}
	else{
		vehicle=document.forms[0].Existing.value;
	}
	
	detailArray[detailArray.length]=[sno,vehicle];
	
}

function saveDetails1()
{   
	if(document.forms[0].Potential.value==""){
			alert("Please Enter  Potential Risk Control ");
            document.forms[0].Potential.focus();
			return false;
	}
	if(document.forms[0].Potential.value!=""){
	 var regex = /^[A-Za-z0-9 ]+$/
        //Validate TextBox value against the Regex.
        var isValid = regex.test(document.forms[0].Potential.value);
        if (!isValid) {
            alert("Contains Special Characters.");
			 return false;
        } 
       
	}
	if(document.forms[0].Name1.value==""){
			alert("Please Enter  Action Officer Details ");
			document.forms[0].Name1.focus();
			return false;
	}
	if(document.forms[0].Name1.value!=""){
	 var regex = /^[A-Za-z0-9 ]+$/
        //Validate TextBox value against the Regex.
        var isValid = regex.test(document.forms[0].Name1.value);
        if (!isValid) {
            alert("Contains Special Characters.");
			 return false;
        } 
       
	}
	if(document.forms[0].Designation.value==""){
			alert("Please Enter  Status of Risk Control ");
			document.forms[0].Designation.focus();
			return false;
	}
	if(document.forms[0].Designation.value!=""){
	 var regex = /^[A-Za-z0-9 ]+$/
        //Validate TextBox value against the Regex.
        var isValid = regex.test(document.forms[0].Designation.value);
        if (!isValid) {
            alert("Contains Special Characters.");
			 return false;
        } 
       
	}
	if(document.forms[0].Description1.value==""){
			alert("Please Enter  Description ");
			document.forms[0].Description1.focus();
			return false;
	}

	if(document.forms[0].Description1.value!=""){
	 var regex = /^[A-Za-z0-9 ]+$/
        //Validate TextBox value against the Regex.
        var isValid = regex.test(document.forms[0].Description1.value);
        if (!isValid) {
            alert("Contains Special Characters.");
			 return false;
        } 
       
	}
	
		
	save1();
		
	showValues1();
	clearDetails1();
	return true;
}	
function save1()
{

	var slno1;
	if(document.forms[0].slno1.value==''){
		slno1=' ';
	}
	else{
		slno1=document.forms[0].slno1.value;
	}

	var Potential;
	if(document.forms[0].Potential.value==""){
		Potential=' ';
	}
	else{
		Potential=document.forms[0].Potential.value;
	}
		
	var Name;
	if(document.forms[0].Name1.value=="")	{
		Name=' ';
	}
	else{
		Name=document.forms[0].Name1.value;
	}	
	
	var Desi;
	if(document.forms[0].Designation.value=="")	{
		Desi=' ';
	}
	else{
		Desi=document.forms[0].Designation.value;
	}		
   var	Description1;

   if(document.forms[0].Description1.value=="")	{
		Description1='  ';
	}
	else{
		Description1=document.forms[0].Description1.value;
	}
	
	detailArray1[detailArray1.length]=[slno1,Potential,Name,Desi,Description1];
}


function showValues(index)
{ 
	var str='';
	
									var heading1=	'S No.';
									var heading2=	'Exis. Risk Ctrl';
									var heading3=	'Edit/Delete';
										
	
	 str="<div><table class='col-md-12 table-bordered table-striped table-condensed cf'><thead class='cf'>"; 
 
	
	
	 if(detailArray.length>0)
	{
		
		str+="<tr>";
		 str=str+" <th > "+heading1+"</th> <th >"+heading2+"</th><th >"+heading3+"</th></tr> </thead>";
		
		
     
	}
	for(var i=0;i<detailArray.length;i++){
		
str+='<tbody><TR>';
		
		if(i==index){
		
        str+='<TD data-title='+heading1+' >';
        str+='<input type=text class="form-control" name="sno" value=\''+detailArray[i][0]+'\'></TD>';
        str+='<TD  data-title='+heading2+'>';	
        str+='<input type=text class="form-control" name="Existing1" value=\''+detailArray[i][1]+'\'></TD>';

		str+='<TD data-title='+heading3+' ><a href="javascript:" onclick="editDetails('+i+');">';
        str+='<i class="fa fa-check" ></i></a>';
        str+='<a href="javascript:"  onclick=del('+i+')>';
        str+='<i class="fa fa-trash-o"></i></a></TD>';

		
		str+='</TR>';
		}
		else
		{


		str+='<TD  data-title='+heading1+'>'+detailArray[i][0]+'</TD>';
	    str+='<TD  data-title='+heading2+'>'+detailArray[i][1]+'</TD>';
	
		str+='<TD  data-title='+heading3+'>';
        str+='<a href="javascript:" onclick=showValues('+i+')>';
        str+='<i class="fa fa-pencil-square-o"></i>&nbsp;&nbsp;</a>';
        str+='<a href="javascript:" onclick=del('+i+')>';
		str+='<i class="fa fa-trash-o"></i></a></TD>';
		
		str+='</TR>';

		}
	
	}
	

		str+='</tbody></TABLE></div>';
	document.all['detailsTable'].innerHTML = str;

	i++;
	document.forms[0].slno.value = i;
	
}


function showValues1(index)
{ 
	var str='';
	
	
										var heading1=	'S No.';
										var heading2=	'Pot. Risk Ctrl';
										var heading3=	'Action officer';
										 var heading4=	'PDC';
										var heading5=	'Desc.';
										var heading6=	'Edit/Delete';
										
	
 

	  str="<div><table class='col-md-12 table-bordered table-striped table-condensed cf'><thead class='cf'>"; 
	if(detailArray1.length>0)
	{str+="<tr>";
		 str=str+" <th > "+heading1+"</th> <th >"+heading2+"</th><th>"+heading3+"</th><th > "+heading4+"</th> <th >"+heading5+"</th><th>"+heading6+"</th></tr> </thead>";
		
       
	}
	 
	for(var i=0;i<detailArray1.length;i++){
		

		str+='<tbody><TR>';
		if(i==index){
		
        str+='<TD data-title='+heading1+' >';
        str+='<input type=text class="form-control" name="sno12" value=\''+detailArray1[i][0]+'\'></TD>';
        str+='<TD data-title='+heading2+' >';	
        str+='<input type=text class="form-control" name="Potential1" value=\''+detailArray1[i][1]+'\'></TD>';
		str+='<TD data-title='+heading3+' >';	
        str+='<input type=text class="form-control" name="Name12" value=\''+detailArray1[i][2]+'\'></TD>';

		str+='<TD data-title='+heading4+' >';	
        str+='<input type=text class="form-control" name="Designation1" value=\''+detailArray1[i][3]+'\'></TD>';
		str+='<TD data-title='+heading5+' >';	
        str+='<input type=text class="form-control" name="Description12" value=\''+detailArray1[i][4]+'\'></TD>';

		str+='<TD data-title='+heading6+'><a href="javascript:" onclick="editDetails1('+i+');">';
        str+='<i class="fa fa-check" ></i></a>';
        str+='<a href="javascript:"  onclick=delete1('+i+')>';
        str+='<i class="fa fa-trash-o"></i></a></TD>';

		
		str+='</TR>';
		}
		else
		{


		str+='<TD data-title='+heading1+' >'+detailArray1[i][0]+'</TD>';
	    str+='<TD data-title='+heading2+' >'+detailArray1[i][1]+'</TD>';

		str+='<TD data-title='+heading3+' >'+detailArray1[i][2]+'</TD>';
	    str+='<TD  data-title='+heading4+' >'+detailArray1[i][3]+'</TD>';
		str+='<TD data-title='+heading5+' >'+detailArray1[i][4]+'</TD>';
	   
	
		str+='<TD data-title='+heading6+'>';
        str+='<a href="javascript:" onclick=showValues1('+i+')>';
        str+='<i class="fa fa-pencil-square-o"></i>&nbsp;&nbsp;</a>';
        str+='<a href="javascript:" onclick=delete1('+i+')>';
		str+='<i class="fa fa-trash-o"></i></a></TD>';
		
		str+='</TR>';

		}
	
	}
	
	
	str+='</tbody></TABLE></div>';
	  
	document.all['detailsTable1'].innerHTML = str;

	i++;
	document.forms[0].slno1.value = i;
	
}

function editDetails(index)
{    
	var Existing1;

	var sno;
	if(document.forms[0].sno.value=='')
		sno=' ';
	else
		sno=document.forms[0].sno.value;

	if(document.forms[0].Existing1.value=="")	{
		Existing1=' ';
		}
	else{
		Existing1=document.forms[0].Existing1.value;
	}
	
	detailArray[index]=[sno,Existing1];
	showValues(-1);
	
}

function editDetails1(index)
{    
	
	var slno1;
	if(document.forms[0].sno12.value==""){
		slno1=' ';
	}
	else{
		slno1=document.forms[0].sno12.value;
	}

	var Potential;
	if(document.forms[0].Potential1.value==""){
		Potential=' ';
	}
	else{
		Potential=document.forms[0].Potential1.value;
	}
		
	var Name;
	if(document.forms[0].Name12.value=="")	{
		Name=' ';
	}
	else{
		Name=document.forms[0].Name12.value;
	}	
	
	var Desi;
	if(document.forms[0].Designation1.value=="")	{
		Desi=' ';
	}
	else{
		Desi=document.forms[0].Designation1.value;
	}		
   var	Description1;

   if(document.forms[0].Description12.value==""){
		Description1='  ';
	}
	else{
		Description1=document.forms[0].Description12.value;
	}
	
	//alert("slno1=="+slno1);
	//alert("Potential=="+Potential);
	//alert("Name=="+Name);
	//alert("Desi=="+Desi);
	//alert("Description1=="+Description1);
	detailArray1[index]=[slno1,Potential,Name,Desi,Description1];
	showValues1(-1);
	
}



function clearDetails()
{
	document.form0.Existing.value="";
	
} 

function clearDetails1()
{
    document.form0.Potential.value="";
	document.form0.Name1.value="";
    document.form0.Designation.value="";
	document.form0.Description1.value="";

	
} 

function loadTolerability() 
{

		 var tol;
		tol = document.forms[0].probability.value + document.forms[0].severity.value
		
		document.forms[0].tolerability.value=tol;

		color1();
		 
  return tol;
		

}

function loadRTolerability() 
{

		var toler;
		toler = document.forms[0].p1.value + document.forms[0].s1.value
		
		document.forms[0].t1.value=toler;

		color();

	//	document.getElementById("t1").style.background-color="#eeeeee";

	 return toler;		

}
function color()
{
	
	
	if(document.forms[0].t1.value=="5A" || document.forms[0].t1.value=="5B" || document.forms[0].t1.value=="5C" || document.forms[0].t1.value=="4A" || document.forms[0].t1.value=="4B" || document.forms[0].t1.value=="3A" )
	{
    document.getElementById("t1").style.backgroundColor="#FF0000";
	 
	document.forms[0].class1.value="class-I";


	}
	else if(document.forms[0].t1.value=="5D" || document.forms[0].t1.value=="5E" || document.forms[0].t1.value=="4C" || document.forms[0].t1.value=="3B" || document.forms[0].t1.value=="3C" || document.forms[0].t1.value=="2A" || document.forms[0].t1.value=="2B" )
	{
    document.getElementById("t1").style.backgroundColor="#cc3300";

	document.forms[0].class1.value="class-II";
	}
	else if(document.forms[0].t1.value=="4D" || document.forms[0].t1.value=="4E" || document.forms[0].t1.value=="3D" || document.forms[0].t1.value=="2C" || document.forms[0].t1.value=="1A" || document.forms[0].t1.value=="1B" )
	{
    document.getElementById("t1").style.backgroundColor="#FFFF00"
	document.forms[0].class1.value="class-III";
	}
	else if(document.forms[0].t1.value=="3E" || document.forms[0].t1.value=="2D" || document.forms[0].t1.value=="2E" || document.forms[0].t1.value=="1C" || document.forms[0].t1.value=="1D" || document.forms[0].t1.value=="1E" )
	{
    document.getElementById("t1").style.backgroundColor="#339900"
	document.forms[0].class1.value="class-IV";
	}
}

function color1()
{
	
	
	if(document.forms[0].tolerability.value=="5A" || document.forms[0].tolerability.value=="5B" || document.forms[0].tolerability.value=="5C" || document.forms[0].tolerability.value=="4A" || document.forms[0].tolerability.value=="4B" || document.forms[0].tolerability.value=="3A" )
	{
		
		document.getElementById("tolerability").style.backgroundColor="#FF0000";
		//document.getElementById("tolerability").readOnly = true;
		
		
	}
	else if(document.forms[0].tolerability.value=="5D" || document.forms[0].tolerability.value=="5E" || document.forms[0].tolerability.value=="4C" || document.forms[0].tolerability.value=="3B" || document.forms[0].tolerability.value=="3C" || document.forms[0].tolerability.value=="2A" || document.forms[0].tolerability.value=="2B" )
	{
    document.getElementById("tolerability").style.backgroundColor="#cc3300";
	}
	else if(document.forms[0].tolerability.value=="4D" || document.forms[0].tolerability.value=="4E" || document.forms[0].tolerability.value=="3D" || document.forms[0].tolerability.value=="2C" || document.forms[0].tolerability.value=="1A" || document.forms[0].tolerability.value=="1B" )
	{
    document.getElementById("tolerability").style.backgroundColor="#FFFF00"
	}
	else if(document.forms[0].tolerability.value=="3E" || document.forms[0].tolerability.value=="2D" || document.forms[0].tolerability.value=="2E" || document.forms[0].tolerability.value=="1C" || document.forms[0].tolerability.value=="1D" || document.forms[0].tolerability.value=="1E" )
	{
    document.getElementById("tolerability").style.backgroundColor="#339900"
	}
}



	function clear_form() {
		window.location.reload();
		document.forms[0].reset();		
	}	
	
	function retNodeValue1(req,node)
	{
	 	if(req.responseXML.getElementsByTagName(node)[0].firstChild!=null)
			return req.responseXML.getElementsByTagName(node)[0].firstChild.nodeValue;
		else
			return ' ';
	}
	




	
function del(index)
{		
		var temp=new Array();
		for(var i=0;i<detailArray.length;i++)
		{
			if(i!=index)
				temp[temp.length]=detailArray[i];
		}

		detailArray=temp;
		showValues();
		
		return false;
}//end of the function del().

function delete1(index)
{		
		var temp=new Array();
		for(var i=0;i<detailArray1.length;i++)
		{
			if(i!=index)
				temp[temp.length]=detailArray1[i];
		}

		detailArray1=temp;
		showValues1();
		
		return false;
}//end of the function del().



var winHandle = "";
var winHandle2 = "";
var winHandle3 = "";

function openWin4(Parameters)
{    
	winHandle = window.open("view/common/AdvancedHelp.jsp?"+Parameters,"acc","toolbar=no,width=300,height=280,left=400,top=250,resizable=yes,status=no");
	winOpened = true;
	winHandle.window.focus();
}

function openWin3(Parameters)
{    
	winHandle2 = window.open("view/common/AdvancedHelp.jsp?"+Parameters,"acc","toolbar=no,width=300,height=280,left=400,top=250,resizable=yes,status=no");
	winOpened = true;
	winHandle2.window.focus();
}


function getRegion(airport,flag)
{
	var airport=airport.value;
	if(airport!='')
	{
		var url="view/sqms/getData.jsp?mode=Region&type="+flag+"&airport="+airport;
		sendURL1(url,"getRegionDetails"); 	
	}
}


function getRegionDetails()
{
	if (httpRequest1.readyState == 4) { 
		if(httpRequest1.status == 200) {  
			var sttype;
			var node = httpRequest1.responseXML.getElementsByTagName("REGION")[0]; 
			if(node) { 
				sttype=retNodeValue1(httpRequest1,"STTYPE"); 
				 if(sttype=="posted")
				{ 
					document.forms[0].region.value = retNodeValue1(httpRequest1,"REGIONNAME");
					 
				}
				
				return false;      
				
			} 
		 } 
	}         
}

function loaddetails()
{
	if(document.forms[0].Functionarea.value=="Others")
	{
		document.getElementById("others").style.display='inline';
	}
	else
	{
		document.getElementById("others").style.display='none';
	}
}
function loaddetails1()
{
	
	if(document.forms[0].APD.value=="Station")
	{
		document.forms[0].haz_status.value="Close"
		document.getElementById("123").style.display='inline';
		
	}
	if(document.forms[0].APD.value=="RHQ" || document.forms[0].APD.value=="CHQ")
	{
		document.forms[0].haz_status.value="Active"
		
		document.getElementById("123").style.display='inline';

	}
	
}

function loaddetails5()
{
	
	if(document.forms[0].APD.value=="Station")
	{
		
		document.getElementById("123").style.display='inline';	
	}
	if(document.forms[0].APD.value=="RHQ" || document.forms[0].APD.value=="CHQ")
	{
		
	
	document.getElementById("123").style.display='inline';

	}
	
}
var contextpath='<%=contextpath%>';
function funOpenWin(fileName)
	{
		winHandle3=window.open(contextpath+'/view/common/FileDownload.jsp?FilePath=/uploads/AVSF/&FileName='+fileName,"a","toolbar = yes,scrollbars=yes,menubar=yes,resizable=yes,width="+screen.Width+",height="+screen.Height+",top=0,left=0");
		winOpened = true;
		winHandle3.window.focus();
		self.close();
		return false;
	}

</SCRIPT>
</HEAD>
<BODY  onunload="closeWin();"  onload=" color(); color1(); loadValues(); loadValues1(); loaddetails(); loaddetails5(); " >

<form	name = "form0" method = "post" action = "AVSF/hazlogctrl.jsp" onsubmit = "return setMode('E')" ENCTYPE="multipart/form-data">


	<div class="page-content-wrapper">
		<div class="page-content">
		    <div class="form-horizontal">

			<div class="row">
			    <div class="col-md-12">
				<h3 class="page-title">Hazlog[Edit]</h3>
				<ul class="page-breadcrumb breadcrumb"></ul>
			    </div>
			</div>
				<fieldset> 
                       		<%
String editquery="select HAZLOG_ID,(select AIRPORT_NAME from airports_regions where AIRPORT_CD=m1.ORIGIN_STATION )ORIGIN_STATION1,ORIGIN_STATION,SOURSE,to_char(HAZLOG_DATE,'DD/MON/YYYY')HAZLOG_DATE,FUCTIONAL_AREA,HAZARD_DES,WORST_CONSEUNCE,INITIAL_PROBABILITY,INITIAL_SEVIRITY,INTIAL_TOLORABILITY,RESIDUAL_PROBABILITY,RESIDUAL_SEVIRITY,RESIDUAL_TOLORABILITY,REVIW_PERIOD,REMARKS,APD_ACCEPT,RHQ_ACCEPT,CHQ_STATUS,APDREVIEW,RHQREVIEW,CHQREVIEW,REGION,MODIFY_DATE,FUCTIONAL_AREA_others,hazard_status,ReplyAPD,QueryRHQ,ActionTaken,APD_want_to_raise,RHQ_want_to_raise,HAZZ_document from tc_hazlog_mt m1 where HAZLOG_ID='"+HAZLOG_ID+"' ";

System.out.println("editquery==="+editquery);
java.sql.ResultSet rs3= dbaccess.getRecordSet(editquery);
if(rs3!=null)
{
   if(rs3.next())
	{

	String fileName=rs3.getString("HAZZ_document");
%>	
                              <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label class="control-label col-md-6"><span class="required">*</span>Originator Station</label>
                                        <div class="col-md-6" >
                                          <input type=text name="Origin" class="form-control" maxlength=8 readonly="readonly" value="<%= rs3.getString("ORIGIN_STATION1") %>">

											<Input Type="hidden" name="region" class="form-control" value="<%= rs3.getString("REGION") %>">
									  
									  <Input Type="hidden" name="Originator" class="form-control" value="<%= rs3.getString("ORIGIN_STATION") %>">	
                                           
                                        </div>
										
                                    </div>
                                </div>
								
							<div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label class="control-label col-md-6">Hazard ID</label>
                                        <div class="col-md-6">
                                        <input type=text name="hazard_id" class="form-control" maxlength=8 readonly="readonly" value="<%= rs3.getString("HAZLOG_ID") %>">
                                        
                                        </div>
										 
										
                                </div>
                                
                            </div>
                                
                            </div>
							</div>
							
							
							
							
							<div class="row">
                                <div class="col-md-12">
                                    <div class="form-group">
                                        <label class="control-label col-md-3">Source (max char 500) </label>
                                        <div class="col-md-8">
                                         <TEXTAREA name="Source" class="form-control" maxlength="500" onkeypress="return TxtAreaMaxLength(document.form0.Source.value,500)"><%= checkNull(rs3.getString("SOURSE")) %></TEXTAREA>
                                           
                                        </div>
										</div>
                                </div>
                                
                            </div>
							
							
								<div class="row">
                                <div class="col-md-6">
                                    <div class="form-group info">
                                        <label class="control-label col-md-6"><font 
									color="red">*</font>Date of Record in Hazlog </label>
                                        <div class="col-md-6">
                                         <div class="input-icon">
                                                 <i class="fa fa-calendar"></i>
                                                         <input class="form-control date-picker" size="16"  onblur="convert_date(this)" value="<%= rs3.getString("HAZLOG_DATE") %>" name="Hazlogdate" id="Hazlogdate" data-date-format="dd/M/yyyy" data-date-viewmode="years" type="text" placeholder="dd-mm-yyyy" >
                                            </div>	
                                        </div>
										</div>
                                </div>
                                
                            
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label class="control-label col-md-6">Functional Area (unit)</label>
                                        <div class="col-md-6">
                                         <select name="Functionarea" class="form-control"  onchange="loaddetails();">
										 <option value="ATC" <%="ATC".equals(rs3.getString("FUCTIONAL_AREA"))?"selected":""%>>ATC</option >
									<option value="ATM" <%="ATM".equals(rs3.getString("FUCTIONAL_AREA"))?"selected":""%>>ATM</option >
									<option value="CNS" <%="CNS".equals(rs3.getString("FUCTIONAL_AREA"))?"selected":""%>>CNS</option >
									<option value="Operations" <%="Operations".equals(rs3.getString("FUCTIONAL_AREA"))?"selected":""%>>Operations (GFS)</option >
									<option value="Elect" <%="Elect".equals(rs3.getString("FUCTIONAL_AREA"))?"selected":""%>>Engg. (Elect)</option >
									<option value="Civil" <%="Civil".equals(rs3.getString("FUCTIONAL_AREA"))?"selected":""%>> Engg. (Civil)</option >
									<option value="ARFFS" <%="ARFFS".equals(rs3.getString("FUCTIONAL_AREA"))?"selected":""%>> ARFFS</option >
									<option value="Others" <%="Others".equals(rs3.getString("FUCTIONAL_AREA"))?"selected":""%>>Others</option >
									</select>
                                           
                                        </div>
										</div>
                                </div>
                                
                            </div>
							
							<div id="others" style='display:none'>
							<div class="row">
                                <div class="col-md-12">
                                    <div class="form-group">
                                        <label class="control-label col-md-3"> </label>
                                        <div class="col-md-8">
                                        <TEXTAREA name=Others class="form-control" onkeypress="return TxtAreaMaxLength(document.form0.Others.value,100)"><%= checkNull(rs3.getString("FUCTIONAL_AREA_others")) %></TEXTAREA>
                                           
                                        </div>
										</div>
                                </div>
                                
                            </div>
							</div>
							
							
							
							<div class="row">
                                <div class="col-md-12">
                                    <div class="form-group">
                                        <label class="control-label col-md-3">Hazard Description <br>(max char 500) </label>
                                        <div class="col-md-8">
                                         <TEXTAREA name="Description" class="form-control" maxlength="500" onkeypress="return TxtAreaMaxLength(document.form0.Description.value,500)"><%= checkNull(rs3.getString("HAZARD_DES")) %></TEXTAREA>
                                           
                                        </div>
										</div>
                                </div>
                                
                            </div>
							
							
							<div class="row">
                                <div class="col-md-12">
                                    <div class="form-group">
                                        <label class="control-label col-md-3">Worst Consequence <br>(max char 500) </label>
                                        <div class="col-md-8">
                                         <TEXTAREA name="Worst" maxlength="500" class="form-control" onkeypress="return TxtAreaMaxLength(document.form0.Worst.value,500)"><%= checkNull(rs3.getString("WORST_CONSEUNCE")) %></TEXTAREA>
                                           
                                        </div>
										</div>
                                </div>
                                
                            </div>
							
<%
if(userType.equals("USER") ) 
{
%>
							
				              <div class="row">
                                <div class="col-md-12">
                                    <div class="form-group">
                                        <label class="control-label col-md-3">
				                        File Upload 
				                           </label>
				                          <div class="col-md-8">
				                           <input type=file name='FILE_UPLOAD' id='FILE_UPLOAD' style=width:250  maxlength='3' onkeydown="return false;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:" onClick="funOpenWin('<%=fileName%>');" ><font color="Blue">View</font></a>
										   <input type=hidden name="hazzuserType" id="hazzuserType" value=<%=userType%> >
					                      </div>
										</div>
                                </div>
							</div>

										 <% }else{ %>
                                          <div class="row">
                                <div class="col-md-12">
                                    <div class="form-group">
                                        <label class="control-label col-md-3">
				                         
				                           </label>
				                          <div class="col-md-8">
											<input type=hidden name="hazzuserType" id="hazzuserType" value=<%=userType%> >
											<a href="javascript:" onClick="funOpenWin('<%=fileName%>');" ><font color="Blue">Uploded File View </a></font></div>
										</div>
                                </div>
							</div>
										 <%}%>
<%	
if(userType.equals("APD")) 
{
%>


							<div class="row">
                                <div class="col-md-11">
                                    <div class="form-group">
                                        <label class="control-label col-md-3">Existing Risk Control (max char 500) </label>
                                        <div class="col-md-8">
                                         <input type="text" name="Existing" id="Existing" maxlength="500" class="form-control" onkeypress="return TxtAreaMaxLength(document.form0.Existing.value,500)">
                                          
                                        </div>
										</div>
                                </div>
								
								
								<div class="col-md-1">
                                    <div class="form-group">
                                        
                                        <div class="col-md-1">
                                        <a href="javascript:" onclick="saveDetails()"> <i class="fa fa-check" ></i></a>
										  <a href="javascript:" onClick="clearDetails()"<i class="fa fa-times" ></i> </a> 
                                        </div>
                                    </div>
                                 </div>
                                
                            </div>

	
							
							
							
		
							
							<div class="row">
                                <div class="col-md-12">
                                    <div class="form-group">
                                        <label class="control-label col-md-6"></label>
                                        <div id=detailsTable></div>
                                    </div>
                                </div>
							</div>
							
							<div class="row">
						    <div class="col-md-12 background">
								<div class="form-group">
								<label class="control-label col-md-6">Initial Risk</label>
								</div>
						    </div>
		                </div>
							
							
							<div class="row">
								<div class="col-md-4">
                                    <div class="form-group">
                                        <label class="control-label col-md-6">Probability</label>
                                        <div class="col-md-6">
                                           <select name="probability" class="form-control" onchange="loadTolerability();">
									<option value="">[select one]</option >
									<option value="5" <%="5".equals(rs3.getString("INITIAL_PROBABILITY"))?"selected":""%>>Frequent - 5</option >
									<option value="4" <%="4".equals(rs3.getString("INITIAL_PROBABILITY"))?"selected":""%>>Occasional - 4</option >
									<option value="3" <%="3".equals(rs3.getString("INITIAL_PROBABILITY"))?"selected":""%>>Remote - 3</option >
									<option value="2" <%="2".equals(rs3.getString("INITIAL_PROBABILITY"))?"selected":""%>>Improbable - 2</option >
									<option value="1"   <%="1".equals(rs3.getString("INITIAL_PROBABILITY"))?"selected":""%>>Extremely Improbable - 1</option >
									
									</select>
                                        </div>
                                    </div>
                                </div>
								<div class="col-md-4">
                                    <div class="form-group">
                                        <label class="control-label col-md-6">Severity</label>
                                        <div class="col-md-6">
                                           <select name="severity" class="form-control"  onchange="loadTolerability();">
									<option value="">[select one]</option >
									<option value="A" <%="A".equals(rs3.getString("INITIAL_SEVIRITY"))?"selected":""%>>Catastrophic - A</option >
									<option value="B" <%="B".equals(rs3.getString("INITIAL_SEVIRITY"))?"selected":""%>>Hazardous - B</option >
									<option value="C" <%="C".equals(rs3.getString("INITIAL_SEVIRITY"))?"selected":""%>>Major -C </option >
									<option value="D" <%="D".equals(rs3.getString("INITIAL_SEVIRITY"))?"selected":""%>>Minor - D</option >
									<option value="E" <%="E".equals(rs3.getString("INITIAL_SEVIRITY"))?"selected":""%>>Negligible - E</option >
									

									</select>
                                        </div>
                                    </div>
                                </div>
								<div class="col-md-4">
                                    <div class="form-group">
                                        <label class="control-label col-md-6">Tolerability</label>
                                        <div class="col-md-6">
                                           <input type=text name="tolerability" id="tolerability"  maxlength=8  value="<%= checkNull(rs3.getString("INTIAL_TOLORABILITY")) %>" class="form-control" >
                                        </div>
                                    </div>
                                </div>
                            </div>
							
							
					         <div class="row">
					             <div class="col-md-11">
                                    <div class="form-group">
                                        <label class="control-label col-md-3">Potential Risk Control (max char 3000)</label>
                                        <div class="col-md-8">
                                          <input type="text" name="Potential" class="form-control" maxlength="500" onkeypress="return TxtAreaMaxLength(document.form0.Potential.value,500)">
                                        </div>
                                    </div>
                                 </div>
                            </div>
							<div class="row">
					             <div class="col-md-11">
                                    <div class="form-group">
                                        <label class="control-label col-md-3">Action Officer(Name & Desig.) (max char 128)</label>
                                        <div class="col-md-8">
                                          <input type="text" name="Name1" class="form-control" onkeypress="return TxtAreaMaxLength(document.form0.Name1.value,128)">
                                        </div>
                                    </div>
                                 </div>
                            </div>
							<div class="row">
					             <div class="col-md-11">
                                    <div class="form-group">
                                        <label class="control-label col-md-3">Status of Risk Control<BR> (PDC) or Completion Date  (max char 128)</label>
                                        <div class="col-md-8">
                                          <input type="text" name=Designation class="form-control" onkeypress="return TxtAreaMaxLength(document.form0.Designation.value,128)">
                                        </div>
                                    </div>
                                 </div>
                            </div>
							<div class="row">
					             <div class="col-md-11">
                                    <div class="form-group">
                                        <label class="control-label col-md-3">Description (max char 128)</label>
                                        <div class="col-md-8">
                                         <input type="text" name="Description1" class="form-control" onkeypress="return TxtAreaMaxLength(document.form0.Description1.value,128)">
                                        </div>
                                    </div>
                                 </div>
                                <div class="col-md-1">
                                    <div class="form-group">
                                        <label class="control-label col-md-1"></label>
                                        <div class="col-md-1">
                                         <label class="control-label col-md-1"><a href="javascript:" onclick="saveDetails1()"> <i class="fa fa-check" ></i></a>
										<a href="javascript:" onClick="clearDetails1()"><i class="fa fa-times" ></i></a></label>
                                        </div>
                                    </div>
                                 </div>
					             
                            </div>
					    
					
					 
					
					         <div class="row">
                                <div class="col-md-12">
                                    <div class="form-group">
                                        <label class="control-label col-md-6"></label>
                                        <div id=detailsTable1></div>
                                    </div>
                                </div>
							</div>
						
						<div class="row">
						    <div class="col-md-12 background">
								<div class="form-group">
								<label class="control-label col-md-6">Residual Risk</label>
								</div>
						    </div>
		                </div>
						
						
							<div class="row">
								<div class="col-md-4">
                                    <div class="form-group">
                                        <label class="control-label col-md-6">Probability</label>
                                        <div class="col-md-6">
                                           <select name="p1" class="form-control" onchange="loadRTolerability();">
									<option value="">[select one]</option >
									<option value="5" <%="5".equals(rs3.getString("RESIDUAL_PROBABILITY"))?"selected":""%>>Frequent - 5</option >
									<option value="4" <%="4".equals(rs3.getString("RESIDUAL_PROBABILITY"))?"selected":""%>>Occasional - 4</option >
									<option value="3" <%="3".equals(rs3.getString("RESIDUAL_PROBABILITY"))?"selected":""%>>Remote - 3</option >
									<option value="2" <%="2".equals(rs3.getString("RESIDUAL_PROBABILITY"))?"selected":""%>>Improbable - 2</option >
									<option value="1" <%="1".equals(rs3.getString("RESIDUAL_PROBABILITY"))?"selected":""%>>Extremely Improbable - 1</option >
									
									</select>
                                        </div>
                                    </div>
                                </div>
								<div class="col-md-4">
                                    <div class="form-group">
                                        <label class="control-label col-md-6">Severity</label>
                                        <div class="col-md-6">
                                          <select name="s1" class="form-control"  onchange="loadRTolerability();">
									<option value="">[select one]</option >
									<option value="A" <%="A".equals(rs3.getString("RESIDUAL_SEVIRITY"))?"selected":""%>>Catastrophic - A</option >
									<option value="B" <%="D".equals(rs3.getString("RESIDUAL_SEVIRITY"))?"selected":""%>>Hazardous - B</option >
									<option value="C" <%="C".equals(rs3.getString("RESIDUAL_SEVIRITY"))?"selected":""%>>Major - C</option >
									<option value="D" <%="D".equals(rs3.getString("RESIDUAL_SEVIRITY"))?"selected":""%>>Minor - D</option >
									<option value="E" <%="E".equals(rs3.getString("RESIDUAL_SEVIRITY"))?"selected":""%>>Negligible -E</option >
									

									</select>
                                        </div>
                                    </div>
                                </div>
								<div class="col-md-4">
                                    <div class="form-group">
                                        <label class="control-label col-md-6">Tolerability</label>
                                        <div class="col-md-6">
                                          <input type=text name="t1" id="t1" class="form-control" maxlength=8  value="<%= checkNull(rs3.getString("RESIDUAL_TOLORABILITY")) %>">
                                        </div>
                                    </div>
                                </div>
                            </div>
						
						
						 <div class="row">
					             <div class="col-md-11">
                                    <div class="form-group">
                                        <label class="control-label col-md-3">Review Period (max char 128)</label>
                                        <div class="col-md-8">
                                          <TEXTAREA name=Review class="form-control" onkeypress="return TxtAreaMaxLength(document.form0.Review.value,128)"><%= checkNull(rs3.getString("REVIW_PERIOD")) %></TEXTAREA>
                                        </div>
                                    </div>
                                 </div>
                            </div>
							
							 <div class="row">
					             <div class="col-md-11">
                                    <div class="form-group">
                                        <label class="control-label col-md-3">Remarks (max char 500)</label>
                                        <div class="col-md-8">
                                          <TEXTAREA name=Remarks class="form-control" onkeypress="return TxtAreaMaxLength(document.form0.Remarks.value,500)"><%= checkNull(rs3.getString("Remarks")) %></TEXTAREA>
                                        </div>
                                    </div>
                                 </div>
                            </div>
					

					
<%
}
if(userType.equals("APD")) 
{

%>

								<div class="row">
					             <div class="col-md-11">
                                    <div class="form-group">
                                        <label class="control-label col-md-3">Acceptance Level</label>
                                        <div class="col-md-8">
                                          <select name=APD class="form-control" onchange="loaddetails1();" >
										   <Option value="" >[Select one]</option>
										   <Option value="Station" <%="Station".equals(rs3.getString("APD_ACCEPT"))?"selected":""%>>Station</option>
											<Option value="RHQ" <%="RHQ".equals(rs3.getString("APD_ACCEPT"))?"selected":""%>>RHQ </option>
											<Option value="CHQ" <%="CHQ".equals(rs3.getString("APD_ACCEPT"))?"selected":""%>>CHQ </option>
										   </select>
                                        </div>
                                    </div>
                                 </div>
                            </div>

							<div class="row" style='display:none' id="123">
					             <div class="col-md-11">
                                    <div class="form-group">
                                        <label class="control-label col-md-3">Reason (max char 500)</label>
                                        <div class="col-md-8">
                                          <TEXTAREA name="APDReview" class="form-control" maxlength="500" onkeypress="return TxtAreaMaxLength(document.form0.APDReview.value,500)"><%= checkNull(rs3.getString("APDReview")) %></TEXTAREA>
                                        </div>
                                    </div>
                                 </div>
                            </div>




							<div class="row" >
					             <div class="col-md-11">
                                    <div class="form-group">
                                        <label class="control-label col-md-3">Acceptance Status</label>
                                        <div class="col-md-8">
                                           <select name="haz_status" class="form-control" >
										   <Option value="Active" <%="Active".equals(rs3.getString("hazard_status"))?"selected":""%>>Pending</option>
										   <Option value="Close" <%="Close".equals(rs3.getString("hazard_status"))?"selected":""%>>Accepted</option>
										   </select>
                                        </div>
                                    </div>
                                 </div>
                            </div>




                    

				
					 
<%
if(checkNull(rs3.getString("RHQ_want_to_raise")).equals("Yes") && rs3.getString("QueryRHQ")!=null)
{
%>

							<div class="row">
					             <div class="col-md-11">
                                    <div class="form-group">
                                        <label class="control-label col-md-3">Query by RHQ (max char 500)</label>
                                        <div class="col-md-8">
                                          <TEXTAREA name="QueryRHQ" class="form-control" maxlength="500" onkeypress="return TxtAreaMaxLength(document.form0.ReplyAPD.value,500)"><%= checkNull(rs3.getString("QueryRHQ")) %></TEXTAREA>
                                        </div>
                                    </div>
                                 </div>
                            </div>
					  
					  
				
<%
}
if(rs3.getString("QueryRHQ")!=null){
%>

							<div class="row">
					             <div class="col-md-11">
                                    <div class="form-group">
                                        <label class="control-label col-md-3">Reply by APD (max char 500)</label>
                                        <div class="col-md-8">
                                          <TEXTAREA name="ReplyAPD" class="form-control" maxlength="500" onkeypress="return TxtAreaMaxLength(document.form0.ReplyAPD.value,500)"><%= checkNull(rs3.getString("ReplyAPD")) %></TEXTAREA>
                                        </div>
                                    </div>
                                 </div>
                            </div>
					
					
					
<%	
	}
%>
				<%	
				if(rs3.getString("ActionTaken")!=null)
	             {
                %>
						<div class="row">
					             <div class="col-md-11">
                                    <div class="form-group">
                                        <label class="control-label col-md-3">Action Taken (max char 500)</label>
                                        <div class="col-md-8">
                                         <TEXTAREA name=ActionTaken class="form-control" onkeypress="return TxtAreaMaxLength(document.form0.ActionTaken.value,500)" readonly ><%= checkNull(rs3.getString("ActionTaken")) %></TEXTAREA>
                                        </div>
                                    </div>
                                 </div>
                            </div>
						
						
						
					  
				<%
					}
				%>

					
<%
}


	}
}
%>
			<input  type=hidden class="form-control" name="slno" value="<%=slno%>" readonly>
			<input  type=hidden class="form-control" name="slno1" value="<%=slno1%>" readonly>

			<input  type=hidden class="form-control" name="class1" value="" readonly>

					<input type="hidden" name="ipaddress" value="<%=request.getRemoteAddr()%>"/> 
					
							
						
										
										<TR><!-- This row is to provide the icons -->
											
											
										<Input Type="hidden" Name="hide" value="E">
										<input type="hidden" name="flag" value="N" >
										
									</TR>
									<div style="display:none"><select name=achieveDetails multiple></select></div>
									<div style="display:none"><select name=achieveDetails1 multiple></select></div>
										
		<div class="row">
			<div class="col-md-12">
					<div class="btns-group">
					   <div class="back-Tspace">
							<a href="<%=mpath%>?path1=/view/af/HazlogSearchResults.jsp" class="back-btn">Back</a>
							</div>
       	                <INPUT TYPE="RESET" class="btn blue" onclick="clear_form()" value="Reset">	
						 <input type="submit" class="btn green"  value="Save">
						
					</div>
			</div>
		</div>
										
							
 </fieldset>
									                
</div>
       </div>
               </div>
 </form>
 </BODY>
</HTML>
<%

dbaccess.closeCon();
%> 