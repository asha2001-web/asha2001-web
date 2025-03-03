
<%@ page language="java" import="java.sql.* , java.io.* , java.util.*" %>

<jsp:useBean id="sessionBean" scope="session" class="model.common.SessionCheckBean" /> 
<jsp:useBean id="dbaccess" scope="page" class="model.common.DBAccess" />
<jsp:include page="/view/common/SessionCheck.jsp" flush="true" />
<jsp:useBean id="hf" scope="session" class="model.common.ScreenUtilities" />



<HTML><Head><Title>AAI</Title>
 <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
    <meta content="" name="description" />
    <meta content="" name="author" />
    <meta name="MobileOptimized" content="320">
	<META HTTP-EQUIV="CACHE-CONTROL" CONTENT="NO-CACHE">
</Head>
<meta charset="utf-8"/>
<% 
 
 //System.out.println("Login Expiry Query:");
 
 String mainpage=(String)session.getAttribute("main");
 String appContext=request.getContextPath();
 ResultSet passwordExp=null;
 String strQuery="";
 double diffdate=0.0;
 dbaccess.makeConnection(sessionBean.getAirportCd());
 java.sql.Connection con = dbaccess.getConnection();

 strQuery = " select sysdate-nvl(Last_Password_Changed_Date,sysdate-180) Password_Changed_Date from am_user_mt where usrid='"+ sessionBean.getUserId()+ "' and  usrid not in ('00001','00003','00002') "; 

 //System.out.println("strQuery..."+strQuery);
try
{
  

   passwordExp=dbaccess.getRecordSet(strQuery);
   if(passwordExp!=null)
	{
		if(passwordExp.next())
		{
		 
		 diffdate=passwordExp.getFloat("Password_Changed_Date");
		}
      
	   if(diffdate>=180)
		{
		   
		     dbaccess.closeCon();
		    mainpage="/ChangePassword.jsp";
		}

	}
}catch(Exception e)
{
	System.out.println("Login Expiry :"+e.toString());

}finally
{	if(dbaccess!=null)
	{
		dbaccess.closeCon();
	}
}

//System.out.println("mainpage.."+mainpage);

mainpage = "/ASF/ASFAdminMain.jsp";
%>
<jsp:include page='<%=mainpage %>' />



 
</Html>