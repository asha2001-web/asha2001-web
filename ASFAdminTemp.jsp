<jsp:useBean id="sessionBean" scope="session" class="model.common.SessionCheckBean" /> 
<%@ page   import="java.sql.*,java.text.*,java.util.*" %>
<jsp:useBean id="cf" class="model.common.DBAccess" />

<%   
System.out.println("1111111111:::::::::");

if(sessionBean.getUserName() == null || sessionBean.getUserId() == null) {

%>
	<jsp:forward page="/Login/SessionExpired.jsp" />
<%
}  
%> 


<%!
public String checkNull(Object str) {
	if(str == null)
		return "En";
	else
		return str.toString().trim();
}
public String checkMenu(Object str) {
	if(str == null)
		return "";
	else
		return str.toString().trim();
}
%>
<%


String path = request.getContextPath();
String basePath ="";

ServletContext ctx = config.getServletContext();
String xbasePath  = ctx.getInitParameter("xbasePath");
if(!xbasePath.equals("")){
 basePath = xbasePath;
}else{
	basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
}
String varpath="";
varpath=request.getParameter("path1");
String menu =checkMenu(request.getParameter("menu"));

int accessEdit=0;
int accessDelete=0; 

if(varpath==null||varpath=="" ||varpath.equals("") ){
	varpath="/templates/sample.jsp";
}	

System.out.println("varpath:::::::::"+varpath);
%>

<title>Airports Authority of India</title>

<!--<script src="http://www.w3schools.com/lib/w3data.js"></script>-->
<% 
String langChange=session.getAttribute("langChange").toString();

if(menu!=""){
session.setAttribute("menu",menu);
}

//menu="/js/MenuJS/TMMenu_"+session.getAttribute("langChange")+".jsp?menu="+session.getAttribute("menu");

menu="/ASF/js/MenuJS/ASFAdminMenu_En.jsp?menu="+session.getAttribute("menu");
System.out.println("menumenumenumenu"+menu);

%>
 <jsp:include page="/view/common/LocaleCommonCode.jsp" />
   <jsp:include page="/ASF/ASFAdminHeader.jsp"  />
   <jsp:include page="<%=menu %>"  />
	<jsp:include page="<%=varpath %>" > </jsp:include >
    <jsp:include page="/view/CvdPattern/copyright.jsp" />



