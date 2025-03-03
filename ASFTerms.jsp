<%@page import="java.net.URLEncoder"%>
<%
/*
   This is the sample Checkout Page JSP script. It can be directly used for integration with CCAvenue if your application is developed in JSP. You need to simply change the variables to match your variables as well as insert routines (if any) for handling a successful or unsuccessful transaction.
*/
%>
<%@ page import = "java.io.*,java.util.*,java.sql.*," %>
<jsp:useBean id="cf" class="model.common.DBAccess" />
<%

	  //String accessCode= "AVZA05KH10AQ32AZQA";		//Testing
	  String accessCode= "AVEJ18KJ63AM45JEMA";		// aims.aai.aero Production
	 // String accessCode= "AVEJ18KJ63AM46JEMA";		// abridgedaims.aai.aero Production
	
	// String workingKey = "90FF5E6E78752688B3B8A8FBE44080C3";    //Testing
	  String workingKey = "F54B65E9DC3B8700FCB5B93A64A895A7";    //aims.aai.aero Production
	  //String workingKey = "E465EAC5E052BBFEB192787F5A3F2331";    //abridgedaims.aai.aero Production
	 String gst_invoice_no="";
	 String airport_cd="";
	 String CA12No="";
	 Enumeration enumeration=request.getParameterNames();
	 String ccaRequest="", pname="", pvalue="",PAYMENT_AMOUNT="",BILLED_AMOUNT="";
	 while(enumeration.hasMoreElements()) {
	      pname = ""+enumeration.nextElement();
	      pvalue = request.getParameter(pname);

		 if(pname.toUpperCase().equals("MERCHANT_PARAM1")){
						gst_invoice_no=pvalue;
					}
		 if(pname.toUpperCase().equals("MERCHANT_PARAM3")){
						airport_cd=pvalue;
					}
		 if(pname.toUpperCase().equals("MERCHANT_PARAM2")){
			 CA12No=pvalue;
			}
		 if(pname.toUpperCase().equals("AMOUNT")){
						BILLED_AMOUNT=pvalue;
					}

	      ccaRequest = ccaRequest + pname + "=" + URLEncoder.encode(pvalue,"UTF-8") + "&";
	 }
	 String strDatePrefix = "";
	 String contextpath = request.getContextPath();
 
	%>
<html>
<head>
	<title>Sub-merchant checkout page</title>
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta content="width=device-width, initial-scale=1.0" name="viewport" />
	<meta content="" name="description" />
	<meta content="" name="author" />
	<meta name="MobileOptimized" content="320">
	<META HTTP-EQUIV="CACHE-CONTROL" CONTENT="NO-CACHE">
	
	<link href="<%=contextpath%>/Content/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css" />
	<link href="<%=contextpath%>/Content/Styles/bootstrap.min.css" rel="stylesheet" type="text/css" />
	<link href="<%=contextpath%>/Content/Login-CSS/Content/Styles/style-metronic.css" rel="stylesheet" type="text/css" />
	<link href="<%=contextpath%>/Content/Login-CSS/Content/Styles/style.css" rel="stylesheet" type="text/css" />
	<link href="<%=contextpath%>/Content/Login-CSS/Content/Styles/style-responsive.css" rel="stylesheet" type="text/css" />
	<link href="<%=contextpath%>/Content/Login-CSS/Content/Styles/default.css" rel="stylesheet" type="text/css" id="style_color" />
	<link href="<%=contextpath%>/Scripts/Login/login-soft.css" rel="stylesheet" type="text/css" />
	<link href="<%=contextpath%>/Content/Styles/datepicker.css" rel="stylesheet" type="text/css" />
	
	<script src="<%=contextpath%>/Scripts/Login/jquery-1.10.2.min.js" type="text/javascript"></script>
	<script src="<%=contextpath%>/Scripts/Lib/jquery-2.0.3.min.js" type="text/javascript"></script>
	<script src="<%=contextpath%>/Scripts/Lib/bootstrap.min.js" type="text/javascript"></script>
	<script src="<%=contextpath%>/Scripts/Lib/jquery.slimscroll.min.js" type="text/javascript"></script>
	<script src="<%=contextpath%>/Scripts/Lib/jquery.cokie.min.js" type="text/javascript"></script>
	<script src="<%=contextpath%>/Scripts/Lib/jquery.validate.min.js" type="text/javascript"></script>
	<script src="<%=contextpath%>/Scripts/Lib/jquery.bootstrap.wizard.min.js" type="text/javascript"></script>
	<script src="<%=contextpath%>/Scripts/Lib/spinner.min.js" type="text/javascript"></script>
	<script src="<%=contextpath%>/Scripts/Lib/bootstrap-datepicker.js" type="text/javascript"></script>
	
	<script src="<%=contextpath%>/Scripts/Lib/bootstrap-maxlength.min.js" type="text/javascript"></script>
	<script src="<%=contextpath%>/Scripts/Lib/bootstrap.touchspin.js" type="text/javascript"></script>
	<script src="<%=contextpath%>/Scripts/Lib/select2.min.js" type="text/javascript"></script>
	<script src="<%=contextpath%>/Scripts/Login/jquery.validate.min.js"></script>
	<script src="<%=contextpath%>/Scripts/Lib/app.js"></script>
	<script src="<%=contextpath%>/Scripts/Lib/form-validation.js"></script>
	<script src="<%=contextpath%>/Scripts/Lib/form-wizard.js"></script>
	<script src="<%=contextpath%>/Scripts/Lib/form-components.js"></script>
	<script src="<%=contextpath%>/Scripts/Login/login-soft.js"></script>
	<script src="<%=contextpath%>/Scripts/Login/jquery.backstretch.min.js" type="text/javascript"></script>
	<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
	<Script>
	function status(BILLED_AMOUNT,PAYMENT_AMOUNT){
		//alert("PAYMENT_AMOUNT"+PAYMENT_AMOUNT+"BILLED_AMOUNT"+BILLED_AMOUNT);
		if(parseFloat(PAYMENT_AMOUNT)<parseFloat(BILLED_AMOUNT)){
			
			document.redirect.submit();
		}else{
			alert("Bill already Paid.");
		}
}
	function cancel(airport_cd)
	{
		self.close();
	}
	
	
	function check()
	{
        let checkbox=document.getElementById("checks");
		if (checkbox.checked)
		{
			document.getElementById("btnsubmit").disabled = false;
		}
		else
		{
			document.getElementById("btnsubmit").disabled  = true;
		}
	}

	</Script> 
	
	<style>
	  
	 
	table.sample {
		border:solid 1px;
		padding: 6px;
		border-style: solid;
		border-color: #52aff1;
		border-collapse: collapse;
	
	
	}
	table.sample th {
		border: solid 1px;
		padding: 6px;
		border-style: solid;
		border-color: #52aff1;
		 font-size: 13px;
		font-weight:bold;
		
	}
	table.sample td {
		border: solid 1px;
		padding: 6px;
		border-style: solid;
		border-color: #52aff1; 
		font-size: 13px;
		font-weight:normal;
		font-family: 'Poppins', sans-serif !important;
		
		
	}
	.btn-link, .btn-link:hover {
    color: #2a6496  !important;
    text-decoration: underline;
    background-color: #5dbbe1 !important;
    
	border: solid 1px #a9c4d8  !important;
		padding: 7px 14px  !important;
		font-size: 14px;
		outline: none !important ;
		background: #d7eff9  !important;
		width: 100%;
		text-align: left;
		-moz-box-shadow: none !important;
		box-shadow: none !important;
		-webkit-border-radius: 6 !important;
		-moz-border-radius: 6 !important;
		border-radius: 6px !important;
		text-shadow: #666;}
		
	 .btn-link:focus {
    color: #2a6496  !important;
    text-decoration: underline;
    background-color: #5dbbe1 !important;
    
	border: solid 1px #a9c4d8  !important;
		padding: 7px 14px  !important;
		font-size: 14px;
		outline: none !important ;
		background: #a0e3ff !important;
		width: 100%;
		text-align: left;
		-moz-box-shadow: none !important;
		box-shadow: none !important;
		-webkit-border-radius: 6 !important;
		-moz-border-radius: 6 !important;
		border-radius: 6px !important;
		text-shadow: #666;}
	 
	</style>
</head>
<body onload="check()">
<header class="header navbar navbar-inverse navbar-fixed-top">
        <div class="header-inner" style="margin-top:6px;">
    &nbsp; &nbsp; <img src="<%=contextpath%>/ASF/images/logo-for-banner.png" alt="" style="width:45px;height:40px">
        <span class="name-inner" style="color:#00ffe9; font-family: 'Varela Round', sans-serif;"> <b>National Aviation Security Fee Trust -<span style="color:#fff"> NASFT </span></b>  
        </span>
        <span class="name-inner"></span>
    <ul class="nav navbar-nav pull-right">
		<li  style="font-size: 14px; color:#fff; margin-top: -4px;">
	
		<!-- <a href="#" onclick="myFunction()" style="font-size: 14px; color:#fff;" title="About AIMS"><i class="fa fa-info-circle  faa-pulse animated" aria-hidden="true" style="font-size: 30px"></i> <span><b>About AIMS</b></span> </a> </li> -->
                <li class="dropdown" id="header_notification_bar" style="right:20px; top:-2px;">
                 <!--   <img src="Content/Images/flight.png" alt=""> -->
                   <ul class="dropdown-menu extended notification">
                        <li><p>You have 14 new notifications</p></li>
                        <li>
                            <ul class="dropdown-menu-list scroller" style="height: 250px;">
                                <li>
                                    <a href="#">
                                        <span class="label label-sm label-icon label-success">
                                            <i class="fa fa-plus"></i>
                                        </span>
                                        New user registered.
                                        <span class="time">
                                            Just now
                                        </span>
                                    </a>
                                </li>
                            </ul>
                        </li>
                        <li class="external">
                            <a href="#">See all notifications <i class="m-icon-swapright"></i></a>
                        </li>
                    </ul>
                </li>
            </ul>
        </div>
     </header> 	
	


<div class="page-content-wrapper" >
			<div class="page-content">
				<div id="pmd-accordion" class="pmd-accordion" style="padding-top:50px;">
					<div class="card">
						<div class="card-header" id="pmd-headingTwo">
						  <h5 class="mb-0">
							<button class="btn btn-link collapsed" data-toggle="collapse" data-target="#pmd-collapseTwo" aria-expanded="false" aria-controls="pmd-collapseTwo">
								About Us 
								
							</button>
						  </h5>
						</div>
						<div id="pmd-collapseTwo" class="collapse" aria-labelledby="pmd-headingTwo" data-parent="#pmd-accordion">
						  <div class="card-body">
							National Aviation Security Fee Trust (NASFT) has been created as Non-Profit Trust by Ministry of Civil Aviation, Government of India  (MoCA) under powers drawn from Rule 88A of Aircraft Rules 1937 for delegation of its functions of levying Aviation Security Fees and managing of funds collected such being utilized to discharge its fiduciary duty of providing aviation security services through designated Central (Central Industrial Security Force) and / or State(State Police) Security Forces.

							Provision of online payment facility is taken under the objective of the Trust to Develop, promote, initiate necessary systems for collection, management and Application of Trust Fund.
 
						  </div>
						</div>
					</div>
					<div class="card">
						<div class="card-header" id="pmd-headingThree">
						  <h5 class="mb-0">
							<button class="btn btn-link collapsed" data-toggle="collapse" data-target="#pmd-collapseThree" aria-expanded="false" aria-controls="pmd-collapseThree">
								Contact Us
								
							</button>
						  </h5>
						</div>
						<div id="pmd-collapseThree" class="collapse" aria-labelledby="pmd-headingThree" data-parent="#pmd-accordion">
						  <div class="card-body">
							
							Name : Sh.KARAN SONDHI, 
							Designation : Senior Manager (Fin)
							Email - nasft.chq@aai.aero / billing.nasft@aai.aero
							Landline - 011-24632950-EXTN-2174

							Address:
							O/o General Manager (Finance) / Managing Trustee
							National Aviation Security Fee Trust
							Rajiv Gandhi Bhawan, 2nd Floor,
							Safdarjung Airport
							New Delhi - 110 003.

						  </div>
						</div>
					</div>
					<div class="card active">
						<div class="card-header" id="pmd-headingOne">
						  <h5 class="mb-0">
							<button class="btn btn-link" data-toggle="collapse" data-target="#pmd-collapseOne" aria-expanded="true" aria-controls="pmd-collapseOne">
							 Terms And Conditions
							 
							</button>
						  </h5>
						</div>
				
						<div id="pmd-collapseOne" class="collapse show" aria-labelledby="pmd-headingOne" data-parent="#pmd-accordion">
						  <div class="card-body">
							<div class="row">
								<div class="col-md-12">
									 <div class="form-group">   
									   <div class="col-md-1" >&nbsp; </div>
										   <div class="col-md-10"  style="padding: 20px; border: solid 20px #52aff1;"> 
											
											<p style="text-align: justify;"><b>Terms & condition:</b> This website is designed, developed and maintained by M/s.Navayuga on behalf of NASFT. Though all efforts have been made to ensure the accuracy and currency of the content on this website, the same should not be construed as a statement of law or used for any legal purposes. In case of any ambiguity or doubts, users are advised to verify/check with the Department(s) and/or other source(s), and to obtain appropriate professional advice. Under no circumstances will this Department be liable for any expense, loss or damage including, without limitation, indirect or consequential loss or damage, or any expense, loss or damage whatsoever arising from use, or loss of use, of data, arising out of or in connection with the use of this website.</p>
											   <p style="text-align: justify;">These terms and conditions shall be governed by and construed in accordance with the Indian Laws. Any dispute arising under these terms and conditions shall be subject to the jurisdiction of the courts of India.</p>
												<p style="text-align: justify;">The information posted on this website could include hypertext links or pointers to information created and maintained by non-NASFT/non-Government/private organizations. NASFT is providing these links and pointers solely for your information and convenience. When you select a link to an outside website, you are leaving the NASFT website and are subject to the privacy and security policies of the owners/sponsors of the outside website.</p>
											   <p style="text-align: justify;">NASFT does not guarantee the availability of such linked pages at all times. NASFT cannot authorize the use of copyrighted materials contained in linked websites. Users are advised to request such authorization from the owner of the linked website. NASFT does not guarantee that linked websites comply with Indian Government Web Guidelines</p>
											   <p style="text-align: justify;"><b><u>Refund & Cancellation policy:</u></b> There is no any refund & cancellation policy defined for the services offered by NASFT (National Aviation Security Fee Trust). Refund & cancellation have to be routed via e-mail to <u>billing.nasft@aai.aero</u> and & Landline (011-24632950-EXTN-2174).</p> 
											   <p style="text-align: justify;"><b>Privacy Policy:</b></p> 
											   <p style="text-align: justify;"><b>Site Visit Data</b></p>
											   <p style="text-align: justify;">This website records your visit and logs the following information for statistical purposes -your server's address; the name of the top-level domain from which you access the Internet (for example, .gov, .com, .in, etc.); the type of browser you use; the date and time you access the site; the pages you have accessed and the documents downloaded and the previous Internet address from which you linked directly to the site. We will not identify users or their browsing activities, except when a law enforcement agency may exercise a warrant to inspect the service provider's logs.</p>
											   <p style="text-align: justify;"><b>Collection of Personal Information</b></p>
											   <p style="text-align: justify;">If you are asked for any other Personal Information you will be informed how it will be used if you choose to give it. If at any time you believe the principles referred to in this privacy statement have not been followed, or have any other comments on these principles, please notify the webmaster through the contact us page.</p>
											   <p style="text-align: justify;"><b>Email Management</b></p>
											   <p style="text-align: justify;">Your email address will only be recorded if you choose to send a message. It will only be used for the purpose for which you have provided it and will not be added to a mailing list. Your email address will not be used for any other purpose, and will not be disclosed, without your consent.</p>
											   <p style="text-align: justify;"><b>Cookie</b></p>
											   <p style="text-align: justify;">A cookie is a piece of software code that an internet web site sends to your browser when you access information at that site.</p>
											   <p style="text-align: justify;"><b>Copyright Policy</b></p>
											   <p style="text-align: justify;">The information/material on this website is subject to copyright protection. The material which is meant for download purposes can be downloaded without requiring specific permission. Any other proposed use of material is subject to the approval of National Aviation Security Fee Trust Contents of this website may not be reproduced partially or fully, without due permission from Ministry of Civil Aviation.</p>
											   <p style="text-align: justify;">If referred to as a part of another website, the source must be appropriately acknowledged. The contents of this website cannot be used in any misleading or objectionable context.</p>
											   <p style="text-align: justify;"><b>Hyperlinking Policy.</b></p>
											   <p style="text-align: justify;">At many places in this Portal, you shall find links to other websites/portals. These links have been placed for your convenience. NASFT is not responsible for the contents and reliability of the linked websites and does not necessarily endorse the views expressed in them. Mere presence of the link or its listing on this Portal should not be assumed as endorsement of any kind. We cannot guarantee that these links will work all the time and we have no control over availability of linked pages. We do not object to you linking directly to the information that is hosted on this Portal and no prior permission is required for the same.</p>
											   <p style="text-align: justify;">However, we would like you to inform us about any links provided to this Portal so that you can be informed of any changes or updations therein. Also, we do not permit our pages to be loaded into frames on your site. The pages belonging to this Portal must load into a newly opened browser window of the User</p>
											   <p style="text-align: justify;"><b><u>Pricing / Products / Services: </u></b>There is no such range of pricing / products & services [offered by NASFT (National Aviation Security Fee Trust)]. Payment for agreed service “Aviation Security Fee” can be made through payment gateway. Any further information on pricing & services can be routed via e-mail to <u>(billing.nasft@aai.aero)</u> & Landline (011-24632950-EXTN-2174).</p>
										   </div>
										   <div class="col-md-1"> &nbsp;</div>
									   </div>
								 </div>
						   </div> 
						  </div>
						</div>
					</div>
					
				</div> <!-- Propeller Accordion example end-->
			</div>
		</div>
 
	
 </body> 
</html>
