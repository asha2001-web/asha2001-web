<!--
	Created by Sreenivasulu M
	Date:21-11-2008
-->
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<jsp:useBean id="cf" class="model.common.DBAccess" />
<jsp:useBean id="sessionBean" scope="session" class="model.common.SessionCheckBean"/>
<jsp:useBean id="prop" class="java.util.Properties" scope="session"/>
<jsp:useBean id="apdetails" class="java.util.Properties" scope="session"/>
<jsp:useBean id="sh" class="model.common.SQLHelper" />
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
 String path = request.getContextPath();
 String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ path + "/"; 
 cf.makeConnection(sessionBean.getAirportCd());
			java.sql.Connection con = cf.getConnection();
 //System.out.println("base path"+basePath);
 %> 
<%

String agency_cd = checkNull((String)session.getAttribute("sagency_cd"));
String PANNo = "";
String TANNo = "";

PANNo=checkNull(sh.getDescription("dt_global_param","ASF_PANNO","1","1",con));
TANNo=checkNull(sh.getDescription("dt_global_param","ASF_TANNO","1","1",con));

//System.out.println("sessionBean.getUserCd()"+sessionBean.getUserCd());
%>

<!-- Report logo , Header and Address  Block-->
	<table border=0 cellpadding=3 cellspacing=0 width="100%" align="center" valign="middle" bordercolor="black">
	   	<tr>
		   	<td class="tbb" align=right>
			<img src= '<%=request.getContextPath()%>/ASF/images/NASF.png' style="width:113px;height:100px">
			</td>
         
			<td>
				<table border=0  cellpadding=3 cellspacing=0 width="100%" align="center" valign="middle">
						<tr>
						<td class="tbb" align=center nowrap colspan="9"><div class="main-heading" style="font-weight:normal; font-size: 30px; " ><b>National Aviation Security Fee Trust</b></div>
						<div class="header-address">Rajiv Gandhi Bhawan, Safdarjung Airport, New Delhi - 110003.</div>
						<div class="header-address">(A Ministry of Civil Aviation, GOI Trust)</div>
						
						<div class="header-address">PAN : <%=PANNo%>, TAN : <%=TANNo%></div></td>
						</tr>						
				</table>
			</td>

			<Td>
				
			</Td>
		</tr>
	</table>
<%
	//This block of code is for Show All Bills Screen
	String recordCount = checkNull(request.getParameter("recordCount"));
	if(recordCount.equals("N"))	{
		out.println("<TR>");
		out.println("<TD align=center colspan=10><b><center><font color=blue><img border=0 src='"+basePath+"images/gui/info.gif'>"+prop.getProperty("cm.norecordsfound")+"</font></center></b>");
		out.println("</TR>"	);
	}

	cf.closeCon();
%>
<!-- End of the Report Header Block-->