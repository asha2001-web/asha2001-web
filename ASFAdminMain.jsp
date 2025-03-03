<jsp:useBean id="sessionBean" scope="session" class="model.common.SessionCheckBean" />
<jsp:useBean id="apdetails" class="java.util.Properties" scope="session"/>

<%!
public String checkNull(Object str) {
	if(str == null)
		return "En";
	else
		return str.toString().trim();
}
public String checkNull1(Object str) {
	if(str == null)
		return "";
	else
		return str.toString().trim();
}
String varpath="";
%>

<%
if( checkNull1(sessionBean.getUserId()).equals("") ) {
	
%>
	<jsp:forward page="/view/common/SessionExpired.jsp" />
<%
}


if(request.getParameter("path")!=null){
	varpath=request.getParameter("path");
}
//System.out.println("-----sessionBean.getAirportCd()-----"+sessionBean.getAirportCd());


model.common.LocaleInfo region = (model.common.LocaleInfo)session.getAttribute("region");
String langChange=checkNull(request.getParameter("langChange"));
region.setLocale(langChange);
region.setModuleCode("TC");
session.setAttribute("moduleCd","TC");
session.setAttribute("mPath","tc");
session.setAttribute("langChange",langChange);
session.setAttribute("region",region);
session.setAttribute("menu","0000000000"); 
//System.out.println("-----sessionBean.getAirportCd()-----"+sessionBean.getAirportCd());
if(checkNull1(sessionBean.getAirportCd()).equals("VOHS") || checkNull1(sessionBean.getAirportCd()).equals("VOHS"))
session.setAttribute("secairport","VOHS");
else
session.setAttribute("secairport","VOBL");

//sessionBean.setPathDt(apdetails.getProperty("upload.path"));

session.setAttribute("lastAcessModule","ASF/ASFAdminMain.jsp");
String template="/ASF/ASFAdminTemp.jsp?langChange="+langChange+"&path1="+varpath;
//System.out.println("template"+template);

%>

 <jsp:include page="/view/common/LocaleCommonCode.jsp" />
<jsp:include page="<%=template%>"  flush="true" />
