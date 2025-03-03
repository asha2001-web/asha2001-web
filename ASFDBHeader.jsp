<jsp:useBean id="sessionBean" scope="session" class="model.common.SessionCheckBean" /> 
<jsp:useBean id="db" class="model.common.DBAccess" />
<jsp:useBean id="hf" scope="session" class="model.common.ScreenUtilities" />
<jsp:useBean id="sh" class="model.common.SQLHelper" />
<jsp:useBean id="prop" class="java.util.Properties" scope="session"/>
<%!
	public String checkNull(String str)
	{
		if(str==null)
		return "";
		else
		return str.trim();
	}
%>
<%
String appContext=request.getContextPath();
%>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta content="width=device-width, initial-scale=1.0" name="viewport" />
<meta content="" name="description" />
<meta content="" name="author" />
<meta name="MobileOptimized" content="320">
<title>AAI</title>
<link href="<%=appContext%>/Content/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css"/>
<link href="<%=appContext%>/Content/Styles/bootstrap.min.css" rel="stylesheet" type="text/css"/>
<link href="<%=appContext%>/Content/Styles/style-metronic.css" rel="stylesheet" type="text/css"/>
<link href="<%=appContext%>/Content/Styles/style.css" rel="stylesheet" type="text/css"/>
<link href="<%=appContext%>/Content/Styles/style-responsive.css" rel="stylesheet" type="text/css" />
<link href="<%=appContext%>/Content/Styles/default.css" rel="stylesheet" type="text/css" />
<link href="<%=appContext%>/Content/Styles/blue.css" rel="stylesheet" type="text/css" />
<link href="<%=appContext%>/Content/Styles/datepicker.css" rel="stylesheet" type="text/css" />

<link href="<%=appContext%>/Content/Styles/form-wizard.css" rel="stylesheet" type="text/css" />

<link href="<%=appContext%>/Content/Styles/DataTables/jquery.dataTables.min.css" rel="stylesheet">
<link href="<%=appContext%>/Content/Styles/DataTables/dataTables.responsive.css" rel="stylesheet">
<link href="<%=appContext%>/Content/Styles/DataTables/buttons.dataTables.min.css" rel="stylesheet">

<script src="<%=appContext%>/Scripts/Lib/jquery-2.0.3.min.js" type="text/javascript"></script>
<script src="<%=appContext%>/Scripts/Lib/bootstrap.min.js" type="text/javascript"></script>
<script src="<%=appContext%>/Scripts/Lib/jquery.slimscroll.min.js" type="text/javascript"></script>
<script src="<%=appContext%>/Scripts/Lib/jquery.cokie.min.js" type="text/javascript"></script>
<script src="<%=appContext%>/Scripts/Lib/jquery.validate.min.js" type="text/javascript"></script>
<script src="<%=appContext%>/Scripts/Lib/jquery.bootstrap.wizard.min.js" type="text/javascript"></script>
<script src="<%=appContext%>/Scripts/Lib/spinner.min.js" type="text/javascript"></script>
<script src="<%=appContext%>/Scripts/Lib/bootstrap-datepicker.js" type="text/javascript"></script>

<script src="<%=appContext%>/Scripts/Lib/bootstrap-maxlength.min.js" type="text/javascript"></script>
<script src="<%=appContext%>/Scripts/Lib/bootstrap.touchspin.js" type="text/javascript"></script>
<script src="<%=appContext%>/Scripts/Lib/select2.min.js" type="text/javascript"></script>


<script src="<%=appContext%>/Scripts/News/jquery.newstape.js" type="text/javascript"></script>
<link href="<%=appContext%>/Scripts/News/newstape.css" rel="stylesheet" type="text/css" />

<link href="<%=appContext%>/Scripts/Plugins/texteditor/editor.css" rel="stylesheet" type="text/css" />
<!-- <script type="text/javascript" src="/SEQ/Scripts/Plugins/texteditor/editor.js"></script> -->




<script src="<%=appContext%>/Scripts/Lib/app.js"></script>
<script src="<%=appContext%>/Scripts/Lib/form-validation.js"></script>
<script src="<%=appContext%>/Scripts/Lib/form-wizard.js"></script>
<script src="<%=appContext%>/Scripts/Lib/form-components.js"></script>
<SCRIPT SRC="<%=appContext%>/js/calendar.js"></SCRIPT>
<SCRIPT SRC="<%=appContext%>/js/DateTime1.js"></SCRIPT>

<SCRIPT SRC="<%=appContext%>/js/CommonForAll.js"> </script>
<SCRIPT SRC="<%=appContext%>/js/CommonFunctions.js"></SCRIPT>
<SCRIPT SRC="<%=appContext%>/js/GeneralFunctions.js"></SCRIPT>
<SCRIPT SRC="<%=appContext%>/js/overlib.js"></SCRIPT>
<SCRIPT SRC="<%=appContext%>/js/EMail and Password.js"></SCRIPT>
<script language="javascript" src="<%=appContext%>/js/Ajax.js"></script>

<script>

jQuery(document).ready(function() {       
   App.init();
   FormValidation.init();
   FormWizard.init();
   FormComponents.init();
});
$(function() {
    $('.newstape').newstape();
});

function helpSelectVal(sValue){
	//alert("sValue"+sValue);
	var sValue =sValue.split(';');
	for(var i=0;i<sValue.length;i++){
	
	var sVal=sValue[i].replace("=","=\'");
	var sValues=sVal+"'";
	var F=new Function (sValues)();
		
	}
	
}
</script>

</head>

<%
String empName = "";
//db.makeConnection("RCS"); 
//java.sql.Connection con = db.getConnection();
String jvcstatus = "";
String jvcString = "";
jvcstatus = (String)application.getAttribute("jvcstatus");
//System.out.println("jvcstatus 2222..."+jvcstatus);
if(jvcstatus.equals("Y"))
{
	jvcString = " - JVC";
}
%>

<body class="page-header-fixed page-sidebar-fixed page-footer-fixed">
<header class="header navbar navbar-inverse navbar-fixed-top">
<input type ="hidden" name ='lastAcessModule' value="">
	<div class="header-inner">
		&nbsp;<img src="<%=appContext%>/ASF/images/logo-for-banner.png" alt=""/ class="logo-img" style="width:45px;height:40px">&nbsp;&nbsp;&nbsp;
		<span class="name desk" style="color:#00ffe9; font-weight:block">National Aviation Security Fee Trust (DashBoard) </span>
		<span class="name mobile">NASFT</span>
		<a href="javascript:;" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
		<img src="<%=appContext%>/RCS/Content/Images/menu-toggler.png" alt=""/>
		</a>
		<ul class="nav navbar-nav pull-right">
			<li class="language"></li>
	  		
	  		<li class="dropdown user">
				<a href="#" class="dropdown-toggle" data-toggle="dropdown" data-hover="dropdown" data-close-others="true">
				<img alt="" src="<%=appContext%>/RCS/Content/Images/avatar1_small.jpg"/>
				<span class="username"><%=sessionBean.getUserName()%></span>
				<i class="fa fa-angle-down"></i>
				</a>
				<ul class="dropdown-menu">
                  <li class="notif-mdisp"><a href="#"><i class="fa fa-bell"></i><span class="badge">5</span> Notifications</a></li>
                  <li><a href="extra_profile.html"><i class="fa fa-user"></i> My Profile</a></li>
                  <li><a href="page_calendar.html"><i class="fa fa-calendar"></i> My Calendar</a></li>
                  <li class="divider"></li>
                  <li><a href="javascript:;" id="trigger_fullscreen"><i class="fa fa-move"></i> Full Screen</a></li>
				  <%
				if(jvcstatus.equals("Y"))
				{
					%>
						<li><a href="<%=appContext%>/ASFDB"><i class="fa fa-key"></i> Log Out</a></li>
					<%
				}
				else
				{
					%>
						<li><a href="<%=appContext%>/ASF"><i class="fa fa-key"></i> Log Out</a></li>
					<%
				}
				%>
                  
				</ul>
			</li>
		</ul>
	</div>
</header>


</body>
</html>
