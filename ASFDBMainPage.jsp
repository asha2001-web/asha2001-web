<%@ page language="java" import="java.sql.*,java.text.*,java.util.*"%>

<jsp:useBean id="db" class="model.common.DBAccess" />
<jsp:useBean id="cf" class="model.common.DBAccess" />
<jsp:useBean id="sh" class="model.common.SQLHelper" />
<jsp:useBean id="cfmt" class="model.common.CurrencyFormat" />
<jsp:useBean id="sessionBean" scope="session"
	class="model.common.SessionCheckBean" />
<jsp:useBean id="rxd" class="model.fa.ReadingXmlDocumentAssessment" />
<jsp:useBean id="dc" class="model.common.DateConverter" />
<%!public String[] splitData(String airportcds) {

		java.util.StringTokenizer st = new java.util.StringTokenizer(airportcds, ",");
		String airportcds1[] = new String[st.countTokens()];
		int i = 0;
		while (st.hasMoreTokens()) {
			airportcds1[i++] = st.nextToken();
		}

		return airportcds1;
	}
	public String checkNull(String str) {
		if (str == null || str.equals("") || str == "null")
			str = "";

		return str.trim();
	}
	public String checkNull1(String str) {
		if (str == null || str.equals("") || str == "null")
			str = "--";

		return str.trim();
	}
	public String checkNull0(String str) {
		if (str == null)
			return "0";
		else
			return str.trim();
	}%>

<%
	db.makeConnection("DASHBOARD");
	java.sql.Connection con = db.getConnection();

	String qry = "";
																			
	ResultSet rsRs = null;
	ResultSet rsRs1 = null;
	String fromDate = "";
	String toDate = "";

	if (fromDate.equals(""))
		fromDate = "01" + dc.getServerDate(con).substring(2, 11);
	if (toDate.equals(""))
		toDate = dc.getServerDate(con);

		System.out.println("fromDate..." + fromDate);
		System.out.println("toDate..." + toDate);

	double dblR1 = 0;
	double dblR2 = 0;
	double dblR3 = 0;
	double dblR4 = 0;
	double dblR5 = 0;
	double dblR6 = 0;
	double dblR7 = 0;

	qry = "select AIRPORT_CD, AIRPORT_NAME, PROFITCENTER, ASF_MAINGROUP, ASF_GROUP  from BD_AIRPORTS_MT where type = 'R' and PROFITCENTER not in ('17012','15061','13010','15004','15039') ";

//	qry += " and airport_cd in ('VEAT','VOAT')";

	//	qry += " order by AIRPORT_NAME";
	qry += "order by ASF_MAINGROUP, ASF_GROUP, AIRPORT_NAME";

	rsRs = db.getRecordSet(qry);

	while (rsRs.next()) {
		System.out.println("airport..." + rsRs.getString("AIRPORT_CD"));

		try {

			cf.makeConnection(rsRs.getString("AIRPORT_CD"));
	
			qry = " select sum(totbillamt) totbillamt,ROUND(sum(finalized_date - todate)/ count(billcd),2) LeadTime_Avg from fa_asfbills_mt where delstatus = 'N' and billstatus = 'A' and fromdate >= ? and todate <= ?  ";
			System.out.println("AP    :" + qry);
			rsRs1 = cf.getRecordSetWithPrepared(qry,fromDate,toDate);
			while (rsRs1.next()) 
			{
				dblR1 += rsRs1.getDouble("totbillamt");	
				dblR4 += rsRs1.getDouble("LeadTime_Avg");	
			}
			cf.closeRs();

			qry = " select sum(totbillamt) totbillamt from fa_asfbills_mt where delstatus = 'N' and billstatus = 'A' and fromdate >= ? and todate <= ? and irn is null  ";
			System.out.println("AP    :" + qry);
			rsRs1 = cf.getRecordSetWithPrepared(qry,fromDate,toDate);
			while (rsRs1.next()) 
			{
				dblR2 += rsRs1.getDouble("totbillamt");	
				dblR3 += rsRs1.getDouble("totbillamt");	
			}
			cf.closeRs();

			if(rsRs.getString("ASF_MAINGROUP").equals("AAI"))
			{
				qry = " select count(ca12_no) ca12_no from tc_ca12info where dep_date >= ? and dep_date <= ? and OVERFLYFLAG = 'N'";
			}
			else
			{
				qry = " select count(ca12_no) ca12_no from FA_ASF_PAX_DETAIILS where dep_date >= ? and dep_date <= ? ";
			}

			
			System.out.println("AP    :" + qry);
			rsRs1 = cf.getRecordSetWithPrepared(qry,fromDate,toDate);
			while (rsRs1.next()) 
			{
					dblR5 += rsRs1.getDouble("ca12_no");																
			}
			cf.closeRs();

			qry = " select sum(totbillamt) totbillamt from FA_ASFCREDITNOTE_MT where RAISEDATE >= ? and RAISEDATE <= ? ";
			rsRs1 = cf.getRecordSetWithPrepared(qry,fromDate,toDate);
			while (rsRs1.next()) 
			{
					dblR6 += rsRs1.getDouble("totbillamt");																
			}
			cf.closeRs();
			if(rsRs.getString("ASF_MAINGROUP").equals("AAI"))
			{
				qry = " select count(ca12_no) ca12_no from tc_ca12info where dep_date >= ? and dep_date <= ? and OVERFLYFLAG = 'N'";
			}
			else
			{
				qry = " select count(ca12_no) ca12_no from FA_ASF_PAX_DETAIILS where dep_date >= ? and dep_date <= ? ";
			}

			
			System.out.println("AP    :" + qry);
			rsRs1 = cf.getRecordSetWithPrepared(qry,fromDate,toDate);
			while (rsRs1.next()) 
			{
					dblR7 += rsRs1.getDouble("ca12_no");																
			}
			cf.closeRs();

			
			
			cf.closeCon();

		} catch (Exception e) {
			//	out.println("error show");
		}

	}
	db.closeRs();

	System.out.println("AKUUUUUUUUUUUUUUUUUUUUU6...");

	
	db.closeCon();

	String contextpath = request.getContextPath();
	String msg = "";
%>

<!DOCTYPE html>
<html lang="en" class="no-js">

<head>
<meta charset="utf-8" />
<title>MoCA DASHBOARD</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta content="width=device-width, initial-scale=1.0" name="viewport" />
<meta content="" name="description" />
<meta content="" name="author" />
<meta name="MobileOptimized" content="320">

<link
	href="TrendsScripts/assets/plugins/font-awesome/css/font-awesome.min.css"
	rel="stylesheet" type="text/css" />
<link
	href="TrendsScripts/assets/plugins/bootstrap/css/bootstrap.min.css"
	rel="stylesheet" type="text/css" />
<link
	href="TrendsScripts/assets/plugins/uniform/css/uniform.default.css"
	rel="stylesheet" type="text/css" />

<link
	href="TrendsScripts/assets/plugins/bootstrap-daterangepicker/daterangepicker-bs3.css"
	rel="stylesheet" type="text/css" />
<link
	href="TrendsScripts/assets/plugins/fullcalendar/fullcalendar/fullcalendar.css"
	rel="stylesheet" type="text/css" />
<link href="TrendsScripts/assets/plugins/jqvmap/jqvmap/jqvmap.css"
	rel="stylesheet" type="text/css" />
<link
	href="TrendsScripts/assets/plugins/jquery-easy-pie-chart/jquery.easy-pie-chart.css"
	rel="stylesheet" type="text/css" />

<link href="TrendsScripts/assets/css/style-metronic.css"
	rel="stylesheet" type="text/css" />
<link href="TrendsScripts/assets/css/style.css" rel="stylesheet"
	type="text/css" />
<link href="TrendsScripts/assets/css/style-responsive.css"
	rel="stylesheet" type="text/css" />
<link href="TrendsScripts/assets/css/plugins.css" rel="stylesheet"
	type="text/css" />
<link href="TrendsScripts/assets/css/pages/tasks.css" rel="stylesheet"
	type="text/css" />
<link href="TrendsScripts/assets/css/themes/default.css"
	rel="stylesheet" type="text/css" id="style_color" />
<link href="TrendsScripts/assets/css/custom.css" rel="stylesheet"
	type="text/css" />

<link rel="shortcut icon" href="favicon.ico" />
<style type="text/css">
.form-control {
	display: block;
	width: 100px !important;
	height: 28px;
	padding: 3px 9px;
	font-size: 12px;
	line-height: 1.428571429;
	color: #555;
	vertical-align: middle;
	background-color: #fff;
	background-image: none;
	border: 1px solid #ccc;
	border-radius: 6px;
	-webkit-box-shadow: inset 0 1px 1px rgba(0, 0, 0, 0.075);
	box-shadow: inset 0 1px 1px rgba(0, 0, 0, 0.075);
	-webkit-transition: border-color ease-in-out .15s, box-shadow
		ease-in-out .15s;
	transition: border-color ease-in-out .15s, box-shadow ease-in-out .15s;
}

.blinking {
	animation: blinkingText 3s infinite;
}

@
keyframes blinkingText { 0%{
	color: #fff;
}

49%{
color


:

 

transparent


;
}
50%{
color


:

 

transparent


;
}
100%{
color


:

 

#fff


;
}
}
.input-icon input {
	padding-left: 18px !important;
}

.form-control {
	display: block;
	width: 100px !important;
	height: 26px;
	padding: 4px 3px;
	font-size: 12px;
	line-height: 1.428571429;
	color: #555;
	vertical-align: middle;
	background-color: #efefef;
	background-image: none;
	border: 1px solid #ccc;
	border-radius: 5px !important;
	-webkit-box-shadow: inset 0 1px 1px rgba(0, 0, 0, 0.075);
	box-shadow: inset 0 1px 1px rgba(0, 0, 0, 0.075);
	-webkit-transition: border-color ease-in-out .15s, box-shadow
		ease-in-out .15s;
	transition: border-color ease-in-out .15s, box-shadow ease-in-out .15s;
}

.input-icon i {
	color: #aba2a2;
	display: block;
	position: absolute;
	margin: 7px 2px 4px 4px;
	width: 16px;
	height: 16px;
	font-size: 14px;
	text-align: center;
}

.col-xs-1, .col-sm-1, .col-md-1, .col-lg-1, .col-xs-2, .col-sm-2,
	.col-md-2, .col-lg-2, .col-xs-3, .col-sm-3, .col-md-3, .col-lg-3,
	.col-xs-4, .col-sm-4, .col-md-4, .col-lg-4, .col-xs-5, .col-sm-5,
	.col-md-5, .col-lg-5, .col-xs-6, .col-sm-6, .col-md-6, .col-lg-6,
	.col-xs-7, .col-sm-7, .col-md-7, .col-lg-7, .col-xs-8, .col-sm-8,
	.col-md-8, .col-lg-8, .col-xs-9, .col-sm-9, .col-md-9, .col-lg-9,
	.col-xs-10, .col-sm-10, .col-md-10, .col-lg-10, .col-xs-11, .col-sm-11,
	.col-md-11, .col-lg-11, .col-xs-12, .col-sm-12, .col-md-12, .col-lg-12
	{
	position: relative;
	min-height: 1px;
	padding-right: 1px;
	padding-left: 1px;
}

.header .navbar-brand {
	color: #FFF;
	font-size: 13px;
	font-weight: normal;
}

.dashboard-stat .details .number {
	font-size: 15px;
	text-align: left;
}
</style>
<SCRIPT LANGUAGE="JAVASCRIPT">
function funDivert2()
{
	
	var url;		
	url="<%=contextpath%>/prototype/consolidation/tc/MoCAArrOTPReport.jsp?fromdate=01/Apr/2018&todate=31/Mar/2019";
		winHandle1 = window.open(url, "a",
				"toolbar = yes,scrollbars=yes,menubar=yes,resizable=yes,width="
						+ screen.Width + ",height=" + screen.Height
						+ ",top=0,left=0");

		winOpened = true;
		winHandle1.window.focus();

		return false;
	}
</script>


</head>

<body class="page-header-fixed" onload="showContent()">
	<script type="text/javascript">
function showContent()
{
	document.getElementById("loading").style.display='none';
	document.getElementById("content").style.display='block';
}
document.write('<div id="loading"><table width="100%" height="100%" align="center" border=1><tr><td align="center"><Img Src="<%=contextpath%>/images/gui/loading2.gif"></Img></td></tr></table></div>');
</script>
<div id="content">
<script type="text/javascript">
	document.getElementById("content").style.display='none';
</script>
	<form name="frmAssessReal" method="post">


		<div class="page-content-wrapper">
			<div class="page-content">


				<!-- END PAGE HEADER-->
				<!-- BEGIN DASHBOARD STATS -->
				<div class="row">
					<div class="col-lg-4 col-md-4 col-sm-6 col-xs-12">
						<div class="dashboard-stat purple">
							<div class="visual">
								<i class="fa fa-clock-o" style="color: #9952a9"></i>
							</div>
							<div class="details" style="margin-right: 130px !important;">
								<div class="number" style="margin-right: -68px;">
									<b>Consolidated Summary Report (R1)</b>
								</div>
								<div class="desc"
									style="font-size: 18px; margin-left: -4px !important; color: #ffffff;">



								</div>
								<div class="desc"
									style="font-size: 18px; margin-left: -4px !important; color: #ffffff;">
									<table width="100%" border="0" cellspacing="0" cellpadding="0">
										<tr>
											<td align="right" width="50%"><span style="color: #fff; margin-right: -123px !important;"><%=cfmt.getDecimalCurrency(dblR1)%></span></td>
										</tr>
									</table>


								</div>


							</div>
							<a class="more" href="<%=contextpath%>/asfdb?path1=/ASF/view/fa/asfDBConsolidatedSummary.jsp"> View Details<!--View more <i class="m-icon-swapright m-icon-white"></i> -->
							</a>
						</div>
					</div>
					<div class="col-lg-4 col-md-4 col-sm-6 col-xs-12">
						<div class="dashboard-stat green">
							<div class="visual">
								<i class="fa fa-user" style="color: #17774d"></i>
							</div>
							<div class="details" style="margin-right: 0px !important;">
								<div class="number" style="margin-right: 18px !important;width: 250px;">
									<b>Pending Assessment Report (R2)</b>
								</div>
								<div class="desc"
									style="font-size: 18px; margin-left: -4px !important; color: #ffffff;">
									<table width="100%" border="0" cellspacing="0" cellpadding="0">
										<tr>
											
											<td align="right" width="50%"><span style="color: #fff; margin-right: 0px !important;"><%=cfmt.getDecimalCurrency(dblR2)%></span></td>

										</tr>
									</table>
								</div>

							</div>

							<a class="more" href="<%=contextpath%>/asfdb?path1=/ASF/view/fa/asfDBPendingAssessment2.jsp">View Details <!--View more <i class="m-icon-swapright m-icon-white"></i> -->
							</a>
						</div>
					</div>

					<div class="col-lg-4 col-md-4 col-sm-6 col-xs-12">
						<div class="dashboard-stat red">
							<div class="visual">
								<i class="fa fa-plane" style="color: #bf5c5d;"></i>
							</div>
							<div class="details">
								<div class="number" style="margin-right: 124px !important;">
									<b>Finalization Pending(R3)</b>
								</div>
								<div class="desc"
									style="margin-right: 104px !important; font-size: 18px;">
									<table width="100%" border="0" cellspacing="0" cellpadding="0">

										<tr>
											
											<td align="right" width="50%"><span style="color: #fff; margin-right: -123px !important;"><%=cfmt.getDecimalCurrency(dblR3)%></span></td>

										</tr>
									</table>

								</div>


							</div>
							
							<a class="more"
								href="<%=contextpath%>/asfdb?path1=/ASF/view/fa/asfDBPendFinalizeParam.jsp">
								View Details<!-- View more <i class="m-icon-swapright m-icon-white"></i>-->
							</a>
						</div>
					</div>


					<!-- Second Row -->


					<!-- END PAGE HEADER-->
					<!-- BEGIN DASHBOARD STATS -->
					<div class="row">
						<div class="col-lg-4 col-md-4 col-sm-6 col-xs-12">
							<div class="dashboard-stat blue">
								<div class="visual">
									<i class="fa fa-clock-o" style="color: #9952a9"></i>
								</div>
								<div class="details" style="margin-right: 130px !important;">
									<div class="number" style="margin-right: 18px;">
										<b>Lead Time (R4)</b>
									</div>
									<div class="desc"
										style="font-size: 18px; margin-left: -4px !important; color: #ffffff;">

									</div>
									<div class="desc"
										style="font-size: 18px; margin-left: -4px !important; color: #ffffff;">
										<table width="100%" border="0" cellspacing="0" cellpadding="0">
											<tr>
												
												<td align="right" width="50%"><span style="color: #fff; margin-right: -123px !important;"><%=cfmt.getDecimalCurrency(dblR4)%></span></td>

											</tr>
										</table>


									</div>


								</div>
								<a class="more" href="<%=contextpath%>/asfdb?path1=/ASF/view/fa/asfDBLeadTime.jsp"> View Details<!--View more <i class="m-icon-swapright m-icon-white"></i> -->
								</a>
							</div>
						</div>
						<div class="col-lg-4 col-md-4 col-sm-6 col-xs-12">
							<div class="dashboard-stat yellow">
								<div class="visual">
									<i class="fa fa-plane" style="color: #17774d"></i>
								</div>
								<div class="details" style="margin-right: 115px !important;">
									<div class="number">
										<b>Airport Wise Movements (R5)</b>
									</div>
									<div class="desc"
										style="font-size: 18px; margin-left: -4px !important; color: #ffffff;">
										<table width="100%" border="0" cellspacing="0" cellpadding="0">
											<tr>
												
												<td align="right" width="50%"><span style="color: #fff; margin-right: -123px !important;"><%=cfmt.getDecimalCurrency(dblR5)%></span></td>

											</tr>
										</table>
									</div>

								</div>
								<a class="more" href="<%=contextpath%>/asfdb?path1=/ASF/view/fa/asfDBAirportwiseMovement.jsp">View Details <!--View more <i class="m-icon-swapright m-icon-white"></i> -->
								</a>
							</div>
						</div>

						<div class="col-lg-4 col-md-4 col-sm-6 col-xs-12">
							<div class="dashboard-stat purple">
								<div class="visual">
									<i class="fa fa-list" style="color: #17774d"></i>
								</div>
								<div class="details" style="margin-right: 115px !important;">
									<div class="number">
										<b>Debit / Credit Notes (R6)</b>
									</div>
									<div class="desc"
										style="font-size: 18px; margin-left: -4px !important; color: #ffffff;">
										<table width="100%" border="0" cellspacing="0" cellpadding="0">
											<tr>
												
												<td align="right" width="50%"><span style="color: #fff; margin-right: -123px !important;"><%=cfmt.getDecimalCurrency(dblR6)%></span></td>

											</tr>
										</table>
									</div>

								</div>
								<a class="more" href="<%=contextpath%>/asfdb?path1=/ASF/view/fa/asfDBCreditDebit.jsp">View Details <!--View more <i class="m-icon-swapright m-icon-white"></i> -->
								</a>
							</div>
						</div>
	<div class="row">
						<div class="col-lg-4 col-md-4 col-sm-6 col-xs-12">
							<div class="dashboard-stat green">
								<div class="visual">
									<i class="fa fa-user" style="color: #008000"></i>
								</div>
								<div class="details" style="margin-right: 130px !important;">
								<div class="number" style="margin-right: -68px;">
										<b>ASF and UDF PAX Count (R7)</b>
									</div>
									<div class="desc"
										style="font-size: 18px; margin-left: -4px !important; color: #ffffff;">

									</div>
									<div class="desc"
										style="font-size: 18px; margin-left: -4px !important; color: #ffffff;">
										<table width="100%" border="0" cellspacing="0" cellpadding="0">
											<tr>
												
												<td align="right" width="50%"><span style="color: #fff; margin-right: -123px !important;"><%=cfmt.getDecimalCurrency(dblR7)%></span></td>

											</tr>
										</table>


									</div>


								</div>
								<a class="more" href="<%=contextpath%>/asfdb?path1=/ASF/view/fa/asfDBASFandUDFPAX.jsp"> View Details<!--View more <i class="m-icon-swapright m-icon-white"></i> -->
								</a>
							</div>
						</div>



					</div>
				</div>
			</div>
		</div>


		<div id="myModal1" class="modal"></div>

		<![endif]-->
		<script src="TrendsScripts/assets/plugins/jquery-1.10.2.min.js"
			type="text/javascript"></script>
		<script src="TrendsScripts/assets/plugins/jquery-migrate-1.2.1.min.js"
			type="text/javascript"></script>
		<!-- IMPORTANT! Load jquery-ui-1.10.3.custom.min.js before bootstrap.min.js to fix bootstrap tooltip conflict with jquery ui tooltip -->
		<script
			src="TrendsScripts/assets/plugins/jquery-ui/jquery-ui-1.10.3.custom.min.js"
			type="text/javascript"></script>
		<script
			src="TrendsScripts/assets/plugins/bootstrap/js/bootstrap.min.js"
			type="text/javascript"></script>
		<script
			src="TrendsScripts/assets/plugins/bootstrap-hover-dropdown/twitter-bootstrap-hover-dropdown.min.js"
			type="text/javascript"></script>
		<script
			src="TrendsScripts/assets/plugins/jquery-slimscroll/jquery.slimscroll.min.js"
			type="text/javascript"></script>
		<script src="TrendsScripts/assets/plugins/jquery.blockui.min.js"
			type="text/javascript"></script>
		<script src="TrendsScripts/assets/plugins/jquery.cokie.min.js"
			type="text/javascript"></script>
		<script
			src="TrendsScripts/assets/plugins/uniform/jquery.uniform.min.js"
			type="text/javascript"></script>
		<!-- END CORE PLUGINS -->
		<!-- BEGIN PAGE LEVEL PLUGINS -->
		<script
			src="TrendsScripts/assets/plugins/jqvmap/jqvmap/jquery.vmap.js"
			type="text/javascript"></script>
		<script
			src="TrendsScripts/assets/plugins/jqvmap/jqvmap/maps/jquery.vmap.russia.js"
			type="text/javascript"></script>
		<script
			src="TrendsScripts/assets/plugins/jqvmap/jqvmap/maps/jquery.vmap.world.js"
			type="text/javascript"></script>
		<script
			src="TrendsScripts/assets/plugins/jqvmap/jqvmap/maps/jquery.vmap.europe.js"
			type="text/javascript"></script>
		<script
			src="TrendsScripts/assets/plugins/jqvmap/jqvmap/maps/jquery.vmap.germany.js"
			type="text/javascript"></script>
		<script
			src="TrendsScripts/assets/plugins/jqvmap/jqvmap/maps/jquery.vmap.usa.js"
			type="text/javascript"></script>
		<script
			src="TrendsScripts/assets/plugins/jqvmap/jqvmap/data/jquery.vmap.sampledata.js"
			type="text/javascript"></script>
		<script src="TrendsScripts/assets/plugins/flot/jquery.flot.js"
			type="text/javascript"></script>
		<script src="TrendsScripts/assets/plugins/flot/jquery.flot.resize.js"
			type="text/javascript"></script>
		<script src="TrendsScripts/assets/plugins/jquery.pulsate.min.js"
			type="text/javascript"></script>
		<script
			src="TrendsScripts/assets/plugins/bootstrap-daterangepicker/moment.min.js"
			type="text/javascript"></script>
		<script
			src="TrendsScripts/assets/plugins/bootstrap-daterangepicker/daterangepicker.js"
			type="text/javascript"></script>
		<!-- IMPORTANT! fullcalendar depends on jquery-ui-1.10.3.custom.min.js for drag & drop support -->
		<script
			src="TrendsScripts/assets/plugins/fullcalendar/fullcalendar/fullcalendar.min.js"
			type="text/javascript"></script>
		<script
			src="TrendsScripts/assets/plugins/jquery-easy-pie-chart/jquery.easy-pie-chart.js"
			type="text/javascript"></script>
		<script src="TrendsScripts/assets/plugins/jquery.sparkline.min.js"
			type="text/javascript"></script>
		<!-- END PAGE LEVEL PLUGINS -->
		<!-- BEGIN PAGE LEVEL SCRIPTS -->
		<script src="TrendsScripts/assets/scripts/app.js"
			type="text/javascript"></script>
		<script src="TrendsScripts/assets/scripts/index.js"
			type="text/javascript"></script>
		<script src="TrendsScripts/assets/scripts/tasks.js"
			type="text/javascript"></script>
		<!-- END PAGE LEVEL SCRIPTS -->
		<script>
			jQuery(document).ready(function() {

				App.init(); // initlayout and core plugins
				Index.init();
				//Index.initJQVMAP(); // init index page's custom scripts
				Index.initCalendar(); // init index page's custom scripts
				Index.initCharts(); // init index page's custom scripts
				Index.initChat();
				Index.initMiniCharts();
				Index.initDashboardDaterange();
				Index.initIntro();
				Tasks.initDashboardWidget();

			});

			$('.modal').on(
					'click',
					function(e) {
						e.preventDefault();
						$('#myModal1').modal('show').find('.modal-content')
								.load($(this).attr('href'));
					});
			$('#myModal1').on('hidden.bs.modal', function() {
				location.reload();
			})

			$(document).ready(function() {

				var radioValue = $("input[name='repType']:checked").val();
				if (radioValue) {
					if (radioValue == 'OTP') {
						//alert("You selected the first option and deselected the second one");
						$("#tdYear1").hide();
						$("#tdYear2").hide();
						$("#tdMonth1").hide();
						$("#tdMonth2").hide();

						$("#tdFromDate1").show();
						$("#tdFromDate2").show();
						$("#tdToDate1").show();
						$("#tdToDate2").show();
					} else if (radioValue == 'PAX') {
						//alert("You selected the second option and deselected the first one");
						$("#tdYear1").hide();
						$("#tdYear2").hide();
						$("#tdMonth1").hide();
						$("#tdMonth2").hide();

						$("#tdFromDate1").show();
						$("#tdFromDate2").show();
						$("#tdToDate1").show();
						$("#tdToDate2").show();
					} else {
						//alert("You selected the third option and deselected the first one");
						$("#tdYear1").hide();
						$("#tdYear2").hide();
						$("#tdMonth1").hide();
						$("#tdMonth2").hide();

						$("#tdFromDate1").show();
						$("#tdFromDate2").show();
						$("#tdToDate1").show();
						$("#tdToDate2").show();
					}
				}

			});

			$(function() {
				$('input:radio[name="repType"]').click(function() {
					//alert($(this).val());
					if ($(this).val() == 'OTP') {
						//alert("You selected the first option and deselected the second one");
						$("#tdYear1").hide();
						$("#tdYear2").hide();
						$("#tdMonth1").hide();
						$("#tdMonth2").hide();

						$("#tdFromDate1").show();
						$("#tdFromDate2").show();
						$("#tdToDate1").show();
						$("#tdToDate2").show();
					} else if ($(this).val() == 'PAX') {
						//alert("You selected the second option and deselected the first one");
						$("#tdYear1").hide();
						$("#tdYear2").hide();
						$("#tdMonth1").hide();
						$("#tdMonth2").hide();

						$("#tdFromDate1").show();
						$("#tdFromDate2").show();
						$("#tdToDate1").show();
						$("#tdToDate2").show();
					} else {
						//alert("You selected the third option and deselected the first one");
						$("#tdYear1").hide();
						$("#tdYear2").hide();
						$("#tdMonth1").hide();
						$("#tdMonth2").hide();

						$("#tdFromDate1").show();
						$("#tdFromDate2").show();
						$("#tdToDate1").show();
						$("#tdToDate2").show();
					}
				});
			});
		</script>
		<!-- END JAVASCRIPTS -->
	</form>
	</div>
</body>
<!-- END BODY -->
</html>