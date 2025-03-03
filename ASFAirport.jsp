<%/*
   'Programmer 	        :   Ravi Kumar
   'change Date      	:   30-06-2008
   'Purpose   	        :   Multiple Language Support for AIMS package
   'change				:   Language option is provided in Login Page as (English And Hindi)
*/
	
				
%>
<%@ page language="java" errorPage="/view/common/LoginErrorPage.jsp" import="java.sql.*" %>
<jsp:useBean id="dbaccess" scope="page" class="model.common.DBAccess" /> 
<jsp:useBean id="sessionBean" scope="session" class="model.common.SessionCheckBean" />
<jsp:setProperty name="sessionBean" property="*" />
<jsp:useBean id="passwordE" scope="page" class="model.common.PasswordEncrypt" />
<jsp:useBean id="sh" class="model.common.SQLHelper" />
<jsp:useBean id="prop1" class="java.util.Properties" scope="session"/>
<%!	
/*
Mehtod to Check the null values of a string
*/
public String checkNull(String str)  
{
	if(str==null)
	return "";
	else
	return str.trim();
}
%>
  
<%	
	//Clearing the Cache
	response.setHeader("Cache-Control","no-cache");
	response.setHeader("Pragma","no-cache");
	response.setHeader("Expires","0");
	response.setDateHeader("Expires",0);

	ResultSet loginRs=null;
	String strQuery="";
	String usercd="";
	String password="";
	String accesslevel="";
	String jvcstatus = "";
	String msg="";
	String InvalidFlag = "";
	String contactInfoImagepath="/images/gui/contactinfo.jpg";
	if(application.getInitParameter("contactInfoImagePath")!=null)
		contactInfoImagepath=(String)application.getInitParameter("contactInfoImagePath");
	boolean bolFlag=false;  
	boolean check = false;
	boolean exp;
	String airportCd=request.getParameter("airport");  
    String appContext=request.getContextPath();
	ServletContext ctx = config.getServletContext();
String encryptCode=ctx.getInitParameter("encryptCode");
	//System.out.println("context..."+appContext);
	try{

	
	usercd=sh.escapeSingleQuotes(checkNull(request.getParameter("loginID")));
	password=sh.escapeSingleQuotes(checkNull(request.getParameter("pwd"))).toUpperCase();
	jvcstatus=checkNull(request.getParameter("jvcstatus"));
	System.out.println("jvcstatus..."+jvcstatus);
	application.setAttribute("jvcstatus",jvcstatus);

	if(!usercd.equals("") && !password.equals("") ){
System.out.println("11111111111111111"+airportCd+"LLLLLLLLLL");
	dbaccess.makeConnection(airportCd);//Hyderabad.
	java.sql.Connection con = dbaccess.getConnection();
System.out.println("11111111111111111");
	model.common.PassEncryptDecrypt ped=new model.common.PassEncryptDecrypt();
try{
	System.out.println("************");
	  
	  
	  password=ped.PassEncryptDecrypt(checkNull(request.getParameter("pwd")),checkNull(encryptCode));
	  System.out.println("password!!!!!!"+password);
	//password=sh.escapeSingleQuotes(checkNull(request.getParameter("pwd")));
System.out.println("passwordpassword"+password);
}catch(Exception e){
	System.out.println("----------"+e);
}

	if(application.getAttribute(airportCd+"queries")==null || application.getAttribute(airportCd+"helpScripts")==null){
		model.common.RetriveScriptData rsd = new model.common.RetriveScriptData();
		java.util.Map queries = rsd.getScreenQueries(con);
		java.util.Map helpScripts = rsd.getHelpScreenScripts(con);
		application.setAttribute("queries",queries);
		application.setAttribute("helpScripts",helpScripts);
	}


	strQuery = "select x.EXPIRE_DT,x.USER_STATUS,x.USER_CD,nvl(x.ACCESS_LEVEL,'EMPTY ')ACCESS_LEVEL,x.PASSWORD,x.usrid,x.Name,x.primary_module,x.dept_cd,x.emp_cd,x.airport_cd,to_date(to_char(x.EXPIRE_DT,'dd/mm/yyyy'),'dd/mm/yyyy') - to_date(to_char(sysdate,'dd/mm/yyyy'),'dd/mm/yyyy') as tDate,handles_complaints,y.description,y.mainpage,terminal_id,nvl(L.ADDRESS,' ')ADDRESS,L.LOCATION_NAME,x.DIVISION_CD,usertheme from am_user_mt x,am_module_mt y,TC_LOCATION_MT L where L.LOCATION_CD=x.airport_cd and x.USER_CD='"+usercd+"' and x.primary_module=y.module_cd and x.primary_module not in ('CR')"; 
	//System.out.println("strQuery"+strQuery);
	try{
		loginRs=dbaccess.getRecordSet(strQuery);

	}catch(Exception e){application.log("THE ERROR IS:"+e.toString());}
	
	if(!usercd.equals("") && !password.equals(""))
	{	
		check = loginRs.next(); 
		try{
				if(password.equals(ped.PassEncryptDecrypt(checkNull(loginRs.getString("password")),checkNull(encryptCode))))
				{
					check = true;
				}else{
					check = false;
				}
				}catch(Exception e){
					System.out.println("OOOOOOOOO"+e);
				}
	/*
		if(check==true)
		{
		
		check=passwordE.PWCompare(password,loginRs.getString("password"));
		}
		*/
			
		 
		if(!check) 
		{
		msg="Invalid Login !";
		InvalidFlag = "N";
		}
 
		if (check) 
		{	
				/*
					The Below code is added on 30-06-2008 by Ravi Kumar to provide multilinguial support for AIMS package
				*/
				String locale = checkNull(request.getParameter("Language"));
				String mCd = checkNull(loginRs.getString("primary_module"));
				String path = application.getRealPath("");
				
				model.common.LocaleInfo region = new model.common.LocaleInfo();
			
				region.setLocale(locale);
				region.setModuleCode(mCd);
				region.setPath(path);
				session.setAttribute("region",region);
				model.common.LocaleProperies localePro = new model.common.LocaleProperies(region);
				//session.setAttribute("prop1",localePro.getSecondaryModuleDetails());
				session.setAttribute("langChange",locale);
				/*
				end of change on 30-06-2008
				*/
			
			if(loginRs.getString("EXPIRE_DT")==null  && loginRs.getString("USER_STATUS").equals("E")  )
			{   
				sessionBean.setUserName(loginRs.getString("name"));
				sessionBean.setUserId(loginRs.getString("usrid"));
				sessionBean.setModDesc(loginRs.getString("description"));

				sessionBean.setMainPage(loginRs.getString("mainpage"));
				sessionBean.setDeptCd(loginRs.getString("dept_cd"));
				sessionBean.setEmpCd(loginRs.getString("emp_cd"));
				sessionBean.setAccessLevel(loginRs.getString("ACCESS_LEVEL"));
				sessionBean.setAirportCd(loginRs.getString("airport_cd"));
				sessionBean.setPrimaryModule(loginRs.getString("primary_module"));
    			sessionBean.setTerminalID(loginRs.getString("terminal_id"));
				session.setAttribute("secairport","VOHS");
				sessionBean.setEmpDivision(loginRs.getString("DIVISION_CD"));
				sessionBean.setAirportDetails(loginRs.getString("ADDRESS"));
				sessionBean.setAirportLocation(loginRs.getString("LOCATION_NAME"));
				session.setAttribute("main",loginRs.getString("mainpage"));
				session.setAttribute("handling",loginRs.getString("handles_complaints"));
				//response.sendRedirect(loginRs.getString("mainpage"));
				session.setAttribute("usertheme",loginRs.getString("usertheme"));
				
				HashMap<String ,String> sm= new HashMap<String,String>();
				String qry="Select a.MODULE_CD MODULE_CD,a.MAINPAGE MAINPAGE from AM_MODULE_MT a,am_user_mt b where  (instr (b.module_cd,a.module_cd)>0 or a.module_cd in (b.primary_module))  and a.MODULE_CD not in ('BA', 'MT', 'AP', 'EM', 'GE', 'TD', 'GC', 'NO', 'CA')  and b.usrid='"+loginRs.getString("usrid")+"' order by DESCRIPTION ";
			     ResultSet mrs=dbaccess.getRecordSet(qry);
				 while(mrs.next()) {  
					sm.put(prop1.getProperty(mrs.getString("MODULE_CD")), (mrs.getString("MAINPAGE").replaceFirst("/view", "view"))+"?mCd="+mrs.getString("MODULE_CD"));
					}
					
					
					
					
					session.setAttribute("usersm",sm);
					
					
					//Map<String, Object> map = oMapper.convertValue(session.getAttribute("usersm"), Map.class);
					//HashMap map = new HashMap();
					//map = session.getAttribute("usersm");
		          // for (Map.Entry<String, String> entry : map.entrySet()) {
		         //System.out.println("Key = " + entry.getKey() + ", Value = " + entry.getValue());
		          // }
		           
        
            dbaccess.closeRs();
	        
				String access=sessionBean.getAccessLevel();
				if(access.substring(0,3).equals("CHQ"))
				{
				   dbaccess.closeCon();
					response.sendRedirect(appContext+"/Aimss.jsp");	
				}
				else
				{   
				    dbaccess.closeCon();
					loginRs.close();
					con.close();
					response.sendRedirect(appContext+"/ASF/ASFAims.jsp");
				}
			}
			else 
			{    if(loginRs.getString("EXPIRE_DT")!=null)
			     {	
				if((Integer.parseInt(loginRs.getString("tDate"))>=0)  && loginRs.getString("USER_STATUS").equals("E")  )
				{        
				
				sessionBean.setUserName(loginRs.getString("name"));
				sessionBean.setUserId(loginRs.getString("usrid"));
				sessionBean.setModDesc(loginRs.getString("description"));
				sessionBean.setMainPage(loginRs.getString("mainpage"));
				sessionBean.setDeptCd(loginRs.getString("dept_cd"));
				sessionBean.setEmpCd(loginRs.getString("emp_cd"));
				sessionBean.setAccessLevel(loginRs.getString("ACCESS_LEVEL"));
				sessionBean.setAirportCd(loginRs.getString("airport_cd"));
				sessionBean.setPrimaryModule(loginRs.getString("primary_module"));
				session.setAttribute("main",loginRs.getString("mainpage"));
     			sessionBean.setTerminalID(loginRs.getString("terminal_id"));

				session.setAttribute("handling",loginRs.getString("handles_complaints"));
				//response.sendRedirect(loginRs.getString("mainpage"));
                session.setAttribute("usertheme",loginRs.getString("usertheme"));
				String access=sessionBean.getAccessLevel();
				if(access.substring(0,3).equals("CHQ"))
				{   
				     dbaccess.closeCon();
					response.sendRedirect(appContext+"/Aimss.jsp");	
				}
				else
				{
				    dbaccess.closeCon();
					response.sendRedirect(appContext+"/ASF/ASFAims.jsp");
				}
								
				}
				else {	
					
						if(loginRs.getString("EXPIRE_DT")!=null)
						{
							if(Integer.parseInt(loginRs.getString("tDate"))<0)
								msg="Your Login Id Expired.<br>Please Contact Administrator";
							if(checkNull(loginRs.getString("USER_STATUS")).equals("D"))
								msg="Login Temporarily Disabled.<br>Please Contact Administrator";
						}
						else 
							if(checkNull(loginRs.getString("USER_STATUS")).equals("D"))
								msg="Login Temporarily Disabled.<br>Please Contact Administrator";
				
							
					    
					    InvalidFlag = "N";
					 }
			    	
			    }
			    else 
			    {	   
					if(loginRs.getString("USER_STATUS").equals("E")  )
					{        				
						sessionBean.setUserName(loginRs.getString("name"));
						sessionBean.setUserId(loginRs.getString("usrid"));
						sessionBean.setModDesc(loginRs.getString("description"));
						sessionBean.setMainPage(loginRs.getString("mainpage"));
						sessionBean.setDeptCd(loginRs.getString("dept_cd"));
						sessionBean.setAccessLevel(loginRs.getString("ACCESS_LEVEL"));
						sessionBean.setEmpCd(loginRs.getString("emp_cd"));
						sessionBean.setAirportCd(loginRs.getString("airport_cd"));
						sessionBean.setPrimaryModule(loginRs.getString("primary_module"));	
						session.setAttribute("main",loginRs.getString("mainpage"));
						sessionBean.setTerminalID(loginRs.getString("terminal_id"));
			
						session.setAttribute("handling",loginRs.getString("handles_complaints"));
						//response.sendRedirect(loginRs.getString("mainpage"));
                        session.setAttribute("usertheme",loginRs.getString("usertheme"));
						String access=sessionBean.getAccessLevel();
						if(access.substring(0,3).equals("CHQ"))
						{
							 dbaccess.closeCon();
							response.sendRedirect(appContext+"/Aimss.jsp");	
						}
						else
						{
							 dbaccess.closeCon();
							response.sendRedirect(appContext+"/ASF/ASFAims.jsp");
						}
				
				}
				else{	
					
						if(loginRs.getString("EXPIRE_DT")!=null)
						{
						
							if(Integer.parseInt(loginRs.getString("tDate"))<0)
								msg="Your Login Id Expired.<br>Please Contact Administrator";
							if(checkNull(loginRs.getString("USER_STATUS")).equals("D"))
								msg="Login Temporarily Disabled.<br>Please Contact Administrator";
						}
						else 
							if(checkNull(loginRs.getString("USER_STATUS")).equals("D"))
								msg="Login Temporarily Disabled.<br>Please Contact Administrator";
					    
			    		InvalidFlag = "N";
					}
			     } 
		 }
		}
		else
			InvalidFlag = "N";
			
	}
	 else
	{
		InvalidFlag = "Y";
	}
	if(loginRs!=null)
	{
		loginRs.close();
		dbaccess.closeRs();	
	}   

	session.setAttribute("connection",con);
	
	try
	{
		if(InvalidFlag.equals("Y")){
		ResultSet rsss= dbaccess.getRecordSet("select * from UserDefinedColors where usrid='"+sessionBean.getUserId()+"'");
		if(rsss!=null){ 
			if(!rsss.next()){
			dbaccess.executeUpdate("Insert into UserDefinedColors(Usrid,BodyBackGround,ScreenBackGround,BorderColor,ScreenHeading) values('"+sessionBean.getUserId()+"','#ECE6DB','#ECE6DB','#CC9966','#000000')");
			}
		}

		if(rsss!=null)
			rsss.close();
		}
		else{
		     dbaccess.closeCon();
			response.sendRedirect(appContext+"/Login.jsp?InvalidFlag="+InvalidFlag+"&msg="+msg);
		}
		
	}
	catch(Exception e)
	{
		application.log("Exception : Login Page :"+e.getMessage());
	}
	//hf.getColors(sessionBean.getUserId(),con);

	 dbaccess.closeCon();
	}//end of main if.
	//}
	//}else{
		//response.sendRedirect(appContext+"/view/common/maintenance.jsp");
	//}
	}catch (Exception e){
     throw new Exception(e.getMessage());
	}
%>

