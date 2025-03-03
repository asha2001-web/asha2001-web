<%@ page language="java" errorPage="/view/common/ErrorPage.jsp" import="model.common.*,java.sql.*" %>
<jsp:useBean id="sessionBean" scope="session" class="model.common.SessionCheckBean" />
<jsp:useBean id="cf" class="model.common.DBAccess" />
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Information Icon Example</title>


</head>
<!--

-->
</style>
<%!
public String checkNull(Object str) {
	if(str == null)
		return "";
	else
		return str.toString().trim();
}
%>

	

<%
    cf.makeConnection(checkNull(sessionBean.getAirportCd()));
	java.sql.Connection con=cf.getConnection();
	ResultSet rs;
	ResultSet rss;
	ResultSet rs1;
	ResultSet rsAir;

	String sysdate="";
	String contextpath=request.getContextPath();
	
	String moduleCd=session.getAttribute("moduleCd").toString();
    String imagename="";
	rs=cf.getRecordSet(" select  FROM_DATE, TO_DATE, WISHES_DESCRIPTION, IMAGE_NAME, STATUS from moudule_wishes_mt where  sysdate between FROM_DATE and TO_DATE and STATUS='A' ");
	rs1=cf.getRecordSet(" select   to_char(sysdate,'dd Mon yyyy') from dual ");
	if(rs1.next()){
		sysdate=rs1.getString(1);	
	}
	cf.closeRs();
	
	
	 String qry1=" select AIRPORT_CD,AIRPORT_NAME,PROFITCENTER,REGION from AIRPORTS_REGIONS where airport_cd = ?";
	
	qry1 += "  order by PROFITCENTER ";
	System.out.println("ASHA"+qry1);

	
	rsAir=cf.getRecordSetWithPrepared(qry1,sessionBean.getAirportCd());
	String airport ="";
	String airportname  ="";
	String profit ="";
	while(rsAir.next())
	{
	System.out.println(rsAir.getString("AIRPORT_CD"));

	 airport = rsAir.getString("AIRPORT_CD");
	 airportname = rsAir.getString("AIRPORT_NAME");
	 profit = checkNull(rsAir.getString("PROFITCENTER"));
	
	}
	String qry="";

	if(airport.equals("VEGT")||airport.equals("VAAH")||airport.equals("VOHS")||airport.equals("VIDP")||airport.equals("VABB")||airport.equals("VOBL")||airport.equals("VANP")||airport.equals("VICG")||airport.equals("VOKN")||airport.equals("VOCI")||airport.equals("VASD")||airport.equals("VILK")||airport.equals("VOML")||airport.equals("VOTV")||airport.equals("VIJP"))
	{
		qry =" SELECT COUNT(*) from FA_ASF_PAX_DETAIILS where PSFFLAG='N' and  dep_date >='01 Apr 2024' and PSFFLAG='N'   and psfbill_cd is null  ";

	}
	else{
		qry =" SELECT count(*)  FROM TC_CA12INFO CA12 JOIN TC_OPERATOR_MT MT ON CA12.OPERATOR_CD = MT.OPERATOR_CD LEFT JOIN TC_PCM_SEGGREGATION PCM ON CA12.FMUID = PCM.FMUID   WHERE CA12.overflyflag = 'N' AND (CA12.PSFFLAG = 'N' OR CA12.PSF_DELSTATUS = 'Y') AND CA12.PSF_DELSTATUS = 'N' AND CA12.dep_date>='01 Apr 2024' AND CA12.DEP_RCS_STATUS = 'N' AND CA12.PSFFLAG = 'N' AND CA12.BILLABLE_FLAG = 'Y' AND CA12.OVERFLYFLAG = 'N'   AND CA12.operator_cd IN (SELECT operator_cd FROM tc_operator_dt WHERE creditfacility = 'Y') AND CA12.operator_cd NOT IN (SELECT operator_cd FROM tc_operator_dt WHERE FREEFACILITY_FLAG = 'Y') AND CA12.psfbill_cd IS NULL AND SUBSTR(CA12.FMUID, 1, 1) NOT IN ('N')   ORDER BY CA12.dep_date, CA12.dep_gmt  ";
	}
	rss=cf.getRecordSet(qry);
	
	System.out.println("qry 222222222"+qry);

	String fromDate="01 Apr 2024";
	String toDate=sysdate;
	String reportType="html";

%>


<script type="text/javascript">
function FormValidate()
{ 
	<%-- parameters1="fromDate='01 Apr 2024'&toDate='09 Aug 2024'&reportType='html'";

	//alert(document.forms[0].freefacility.value);
	//return false;
	alert(parameters1);
	
	var reportingpage="";
    
    reportingpage="<%=contextpath%>/ASF/view/fa/asfUnbilledMovementsReport.jsp?"
	
	winHandle1=window.open(reportingpage,"a","toolbar = yes,scrollbars=yes,menubar=yes,resizable=yes,width="+screen.Width+",height="+screen.Height+",top=0,left=0");
   
	winOpened = true;
	
	winHandle1.window.focus();
	
	return false;
 --%>
 
 
 var url='view/fa/asfUnbilledMovementsReport.jsp?fromDate=<%=fromDate%>&toDate=<%=toDate%>&reportType=<%=reportType%>&airport=<%=airport%>'; 

	var queryString = url;
	UtilityWindow(queryString);
	return false;

}



function FormValidate1()
{  
		    
	parameters1="&reportType=html";

	var reportingpage="";
    
    reportingpage="<%=contextpath%>/view/fa/CreditFacilityReport.jsp?"
	
  
	winHandle1=window.open(reportingpage+parameters1,"a","toolbar = yes,scrollbars=yes,menubar=yes,resizable=yes,width="+screen.Width+",height="+screen.Height+",top=0,left=0");
   
	winOpened = true;
	
	winHandle1.window.focus();
	
	return false;
}
</script>
<BODY   >
	<div class="page-content-wrapper">
	    <div class="page-content">
		 <div class="row">                                          
							
									<div class="col-md-12">

					
					<table width="100%">

						<tr>
							<th align="left" width="50%"><font
								style="color: #2a2b2b; font-size: 14px;"><b>Pending Tasks</b></font></th>
							<th width="47%" align="right">&nbsp;</th>
							<th width="7%" align="right">
							    <button  onclick="FormValidate1()" class="btn btn-primary" style="padding: 4px 6px;font-size: 12px;">Credit Facility Details</button>
							</th>
						</TR>
						<tr>
							<td colspan="3">
								<div style="overflow: auto !important; height: 500px;">
									<TABLE class="display nowrap dataTable dtr-inline cf col-md-12" role="grid"
										aria-describedby="example_info" >
										<TR>
											<TH style="width: 25% !important">S No</TH>
										    <TH style="width: 25% !important">Description</TH>
											<TH style="width: 25% !important">Count</TH>
											<TH style="width: 23% !important">Details</TH>
										<!-- 	<TH style="width: 10% !important">Operator Code</TH>
											<TH style="width: 15% !important">Raised Date</TH>
											<TH style="width: 15% !important">Bill Period</TH>
											<TH style="width: 15% !important">Bill Amount</TH>
											<TH style="width: 15% !important">Bill Type</TH> -->
										</TR>
										
										<%
											String strBillType = "";
												while (rss.next()) {
												
													
										%>
										<tr>
                                              <td align="center">1</td>
                                              <td align="center">Unbilled Movements</td>
                                             
                                             <td align="center"><%=rss.getInt(1)%></td>
                                             <td>
                                             <input type="button" value="Show"  class="btn blue button-submit" onclick='FormValidate()'; style=""/>
<!--                <i class="fas fa-info" aria-hidden="true" style="font-size:20px;" '"></i>
 -->
</td>
                                             
											</tr>
										<%
												}
			%>
									</table>
								</div>
							</td>
						</tr>
					</table>
				</div>		
							
							
							
							
							
							
							
							<div class="col-md-6">
								<div class="form-group info">
									<label class="control-label col-md-5"></label>
									<div class="col-md-7">
		<%			
			if(rs!=null)
			 {
				if (rs.next())
					{
						 imagename=checkNull(rs.getString("IMAGE_NAME"));
						 toDate=checkNull(rs.getString("sysdate"));

					
		%>									
										
										<img src="<%=contextpath%>/images/<%=imagename%>" >
									</div>
								</div>
							</div>   

             <%
			     }
			 }
			 %>
		   
		<%
		if(con!=null)
			con.close();
		%>
	    </div>
	</div>
</BODY>

