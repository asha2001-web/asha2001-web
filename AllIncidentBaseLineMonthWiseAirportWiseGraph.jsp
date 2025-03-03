<%@page import="javax.swing.JOptionPane"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*" %>
<%@page import="java.util.*" %>
<%@page import="com.google.gson.*" %>
<jsp:useBean id="cf" scope="session" class="model.common.DBAccess" />

<%
    
/* 
    The following 4 code lines contain the database connection information.
    Alternatively, you can move these code lines to a separate file and
    include the file here. You can also modify this code based on your 
    database connection. 
 */
/*
   String hostdb = "localhost:3306";  // MySQl host
   String userdb = "root";  // MySQL username
   String passdb = "";  // MySQL password
   String namedb = "fusioncharts_jspsample";  // MySQL database name

    // Establish a connection to the database
    DriverManager.registerDriver(new com.mysql.jdbc.Driver());
    Connection con = DriverManager.getConnection("jdbc:mysql://" + hostdb + "/" + namedb , userdb , passdb);
  */ 

  cf.makeConnection("DASHBOARD");
	java.sql.Connection con = cf.getConnection();
	String appContext = request.getContextPath();
    %>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Creating Charts with Data from a Database - fusioncharts.com</title>
<!-- Step 1: Include the `fusioncharts.js` file. This file is needed to
        render the chart. Ensure that the path to this JS file is correct.
        Otherwise, it may lead to JavaScript errors.
--> 
       <script src="fusioncharts.js"></script>
	   <link href="../Content/Styles/bootstrap.min.css" rel="stylesheet" type="text/css"/>
<link href="../Content/Styles/style-metronic.css" rel="stylesheet" type="text/css"/>
<link href="../Content/Styles/style.css" rel="stylesheet" type="text/css"/>
<link href="../Content/Styles/style-responsive.css" rel="stylesheet" type="text/css" />
<link href="../Content/Styles/default.css" rel="stylesheet" type="text/css" id="style_color"/>

	   <link rel="stylesheet" href="../css/aai.css" type="text/css">
<link rel="stylesheet" href="../css/reportstyle.css" type="text/css">
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
<style>
.panel-primary>.panel-heading {
    color: #fff;
    background: linear-gradient(#1479b8, #46a1da) !important;
    border-color: #a4c0e2;
}
.panel-primary {
    border-color: #a4c0e2 !important;
}
.panel-heading {
    padding: 7px 15px;
    border-bottom: 1px solid transparent;
    border-top-right-radius: 3px;
    border-top-left-radius: 3px;
}
.header .navbar-brand {
    color: #FFF;
    font-size: 13px;
    font-weight: normal;
    width: 85%;
}
</style>
    </head>
    <body>

	 <div class="row" style="background: #fafafa;">
						<div class="col-md-12">
						
		<div id="News" class="col-md-10">

							<div class="panel panel-primary">

                    	
						<div class="panel-heading"> 

                        	<h3 class="panel-title">
			<i class="fa fa-cogs" aria-hidden="true" style="font-size:18px;"></i> &nbsp; Graph </h3>
                         </div>
						

                         <div class="panel-body">

                         	<div class="row-fluid">

                            	<div class="span12"  style="height:571px !important; padding:10px;" >

	   <div id="chart" style="text-align: center;"></div>

<div class="row">

<div class="col-md-12">
<div class="col-md-6">
       
<!--    Step 2: Include the `FusionCharts.java` file as a package in your 
        project.
-->
        <%@page import="model.common.fusioncharts.FusionCharts" %>
        
<!--    Step 3:Include the package in the file where you want to show 
        FusionCharts as follows.
        
        Step 4: Create a chart object using the FusionCharts JAVA class 
        constructor. Syntax for the constructor: 
        `FusionCharts("type of chart", "unique chart id", "width of chart",
                        "height of chart", "div id to render the chart", 
                        "data format", "data source")`   
-->           
        <%
         /*
            google-gson
    
            Gson is a Java library that can be used to convert Java Objects into 
            their JSON representation. It can also be used to convert a JSON string to 
            an equivalent Java object. Gson can work with arbitrary Java objects including
            pre-existing objects that you do not have source-code of.
            link : https://github.com/google/gson    
         */
    
            Gson gson = new Gson();
            
            
            // Form the SQL query that returns the top 10 most populous countries
           // String sql="SELECT * FROM `number_of_visitor` ORDER BY `number_of_visitor`.`id` ASC";
//String sqlQueryYear = " select to_char(incid_date,'MON') year,count(*) TotalAmount from tc_incident_mt aa where aa.airport_cd='"+request.getParameter("airportCd")+"' and to_char(aa.incid_date,'YYYY') ='"+request.getParameter("year")+"'  and CATEGORY='BH' group by to_char(incid_date,'MON'),to_char(incid_date,'MM') order by to_char(incid_date,'MM')";
//String sqlQueryYear="select month year ,month_value, sum(cut) TotalAmount  from (select aa.month,         month_value,         airport_cd,         (case           when to_char(bb.incid_date, 'MON') = to_char(aa.month) then            count(*)           else            0         end) cut    from (select  MONTH_NAME month ,MONTH month_value from months) aa,         tc_incident_mt bb   where  to_char(bb.incid_date, 'YYYY') = '"+request.getParameter("year")+"'            group by aa.month, month_value, airport_cd,to_char(bb.incid_date, 'MON')   order by month_value)   group by month,month_value   order by month_value ";

String sqlQueryYear="";
String regionCd=request.getParameter("regionCd");
String regionName=request.getParameter("regionName");
String incident=request.getParameter("incident");
String incidentName=request.getParameter("incidentName");
//if(regionCd.equals("")){
// sqlQueryYear="select month||'-'||substr('"+request.getParameter("year")+"',3,3) year ,month_value, sum(cut) TotalAmount  from (select aa.month,         month_value,         airport_cd,         (case           when to_char(bb.incid_date, 'MON') = to_char(aa.month) then            count(*)           else            0         end) cut    from (select  MONTH_NAME month ,MONTH month_value from months) aa,         tc_incident_mt bb   where  to_char(bb.incid_date, 'YYYY') = '"+request.getParameter("year")+"'     and trim(CATEGORY) = '"+request.getParameter("incident")+"'      group by aa.month, month_value, airport_cd,to_char(bb.incid_date, 'MON')   order by month_value)   group by month,month_value   order by month_value ";

 //sqlQueryYear="select month||'-'||substr('"+request.getParameter("year")+"',3,3) year,        month_value,        round((TotalAmount * BASE_LEVEL) / ((case when ARRIVAL = 'TRUE' then  ARR_COUNT else  0              end) + (case when DEPARTURE = 'TRUE' then  DEP_COUNT else  0              end)+ (case when OVERFLYING = 'TRUE' then  DEP_COUNT else  0              end)),              2) TotalAmount,        ALERT_LEVEL1,        ALERT_LEVEL2,        ALERT_LEVEL3,        arr_count,        dep_count,        BASE_LEVEL,        ARRIVAL,        DEPARTURE,        OVERFLYING   from (select month month, month_value, sum(cut) TotalAmount, (select ALERT_LEVEL1    from ASF_INCID_CATEG_ALERT_LEVEL   where year = '"+request.getParameter("year")+"'     and AIRPORT_CD =  '"+request.getParameter("airportCd")+"'      and INCIDENT_CD = '"+request.getParameter("incident")+"') ALERT_LEVEL1, (select ALERT_LEVEL2    from ASF_INCID_CATEG_ALERT_LEVEL   where year = '"+request.getParameter("year")+"'     and AIRPORT_CD =  '"+request.getParameter("airportCd")+"'     and INCIDENT_CD = '"+request.getParameter("incident")+"') ALERT_LEVEL2, (select ALERT_LEVEL3    from ASF_INCID_CATEG_ALERT_LEVEL   where year = '"+request.getParameter("year")+"'     and AIRPORT_CD =  '"+request.getParameter("airportCd")+"'    and INCIDENT_CD = '"+request.getParameter("incident")+"') ALERT_LEVEL3, (select sum(arr_count) arr_count    from db_arr_dep_count aa   where airport_cd = '"+request.getParameter("airportCd")+"'     and year = '"+request.getParameter("year")+"'     and upper(trim(aa.month)) = upper(trim(a1.month))   group by aa.airport_cd, aa.month, aa.year) arr_count, (select sum(dep_count) dep_count    from db_arr_dep_count aa   where airport_cd = '"+request.getParameter("airportCd")+"'     and year = '"+request.getParameter("year")+"'     and upper(trim(aa.month)) = upper(trim(a1.month))   group by aa.airport_cd, aa.month, aa.year) dep_count, b1.BASE_LEVEL, b1.ARRIVAL, b1.DEPARTURE, b1.OVERFLYING           from (select aa.month,         month_value,         airport_cd,         (case           when to_char(bb.incid_date, 'MON') =                to_char(aa.month) then            count(*)           else            0         end) cut    from (select MONTH_NAME month, MONTH month_value from months where '"+request.getParameter("year")+"'||lpad(month,2,0) <= to_char(sysdate, 'YYYY')||to_char(sysdate, 'MM')) aa,         tc_incident_mt bb   where trim(CATEGORY) = '"+request.getParameter("incident")+"'     and to_char(bb.incid_date, 'YYYY') = '"+request.getParameter("year")+"'     and bb.airport_cd = '"+request.getParameter("airportCd")+"'   group by aa.month,            month_value,            airport_cd,            to_char(bb.incid_date, 'MON')   order by month_value) a1, (select BASE_LEVEL, ARRIVAL, DEPARTURE, OVERFLYING    from ASF_INCID_CATEG_BASE_LINE   where INCIDENT_CD = '"+request.getParameter("incident")+"') b1          group by month,    month_value,    b1.BASE_LEVEL,    b1.ARRIVAL,    b1.DEPARTURE,    b1.OVERFLYING          order by month_value)";

/*
 sqlQueryYear="select month || '-' || substr('"+request.getParameter("year")+"', 3, 3) year,month_value,TotalAmount TotalAmount   from (select month month, month_value, sum(cut) TotalAmount from (select aa.month,month_value,airport_cd,(case when to_char(bb.incid_date, 'MON') =to_char(aa.month) then count(*) else 0 end) cut from (select MONTH_NAME month, MONTH month_value from months where '"+request.getParameter("year")+"' || lpad(month, 2, 0) <= to_char(sysdate, 'YYYY') || to_char(sysdate, 'MM')) aa, tc_incident_mt bb where trim(CATEGORY) = '"+incident+"' and bb.airport_cd in(select AIRPORT_CD from airports_regions ";
 if(!regionCd.equals("")){
 
 sqlQueryYear+=" where trim(upper(REGION_CD)) = trim(upper(trim('"+regionCd+"')))";
 }
 sqlQueryYear+=" ) and to_char(bb.incid_date, 'YYYY') = '"+request.getParameter("year")+"' group by aa.month,                           month_value,                           airport_cd,                           to_char(bb.incid_date, 'MON')                  order by month_value) a1          group by month, month_value          order by month_value)";
*/


 sqlQueryYear="select month || '-' || substr('"+request.getParameter("year")+"', 3, 3) year,        month_value,";
// sqlQueryYear+="(select BASE_LEVEL  from ASF_INCID_CATEG_BASE_LINE a1 where a1.incident_cd = '"+incident+"' ) BASE_LEVEL, ";
 sqlQueryYear+=" round(TotalAmount * (select BASE_LEVEL  from ASF_INCID_CATEG_BASE_LINE a1 where a1.incident_cd = '"+incident+"' ) / ((case          when (select ARRIVAL                  from ASF_INCID_CATEG_BASE_LINE a1                 where a1.incident_cd = '"+incident+"' ) = 'TRUE' then           ArrMCount        end) + (case          when (select DEPARTURE                  from ASF_INCID_CATEG_BASE_LINE a1                 where a1.incident_cd = '"+incident+"' ) = 'TRUE' then           DepMCount        end)),2) TotalAmount,        ArrMCount,        DepMCount   from (select month month,                month_value,                sum(cut) TotalAmount,                sum(b1.ArrMCount) ArrMCount,                sum(b1.DepMCount) DepMCount           from (select month,month_value ,sum(cut) cut from (select aa.month, month_value, airport_cd, (case   when to_char(bb.incid_date, 'MON') =        to_char(aa.month) then    count(*)   else    0 end) cut                   from (select MONTH_NAME month, MONTH month_value    from months   where '"+request.getParameter("year")+"' || lpad(month, 2, 0) <=         to_char(sysdate, 'YYYY') ||         to_char(sysdate, 'MM')) aa, tc_incident_mt bb                  where trim(CATEGORY) = '"+incident+"'                     and bb.airport_cd in (select AIRPORT_CD from airports_regions ";
 
  if(!regionCd.equals("")){
 
 sqlQueryYear+=" where trim(upper(REGION_CD)) = trim(upper(trim('"+regionCd+"')))";
 }

 sqlQueryYear+=")                    and to_char(bb.incid_date, 'YYYY') = '"+request.getParameter("year")+"' ";    
 
 sqlQueryYear+=" group by aa.month,    month_value,    airport_cd,    to_char(bb.incid_date, 'MON')          ) group by month,month_value) a1,                (select MM, sum(ArrMCount) ArrMCount, sum(DepMCount) DepMCount                   from (SELECT TO_CHAR(AA.ARR_DATE, 'MM') MM,         (count(*)) ArrMCount,         0 DepMCount    FROM DB_ARR_PCM_DETAILS AA   WHERE TO_CHAR(AA.ARR_DATE, 'YYYY') = '"+request.getParameter("year")+"'     and airport_cd in         (select AIRPORT_CD from airports_regions";
 
  if(!regionCd.equals("")){
 
 sqlQueryYear+=" where trim(upper(REGION_CD)) = trim(upper(trim('"+regionCd+"')))";
 }
 sqlQueryYear+=" )   group by TO_CHAR(AA.ARR_DATE, 'MM'),            TO_CHAR(AA.ARR_DATE, 'YYYY')  union all  SELECT TO_CHAR(AA.DEP_DATE, 'MM') MM,         0 ArrMCount,         (count(*)) DepMCount    FROM DB_DEP_PCM_DETAILS AA   WHERE TO_CHAR(AA.DEP_DATE, 'YYYY') = '"+request.getParameter("year")+"'     and airport_cd in         (select AIRPORT_CD from airports_regions)   group by TO_CHAR(AA.DEP_DATE, 'MM'),            TO_CHAR(AA.DEP_DATE, 'YYYY'))                  group by MM                  order by MM) b1          where a1.month_value = b1.MM          group by month, month_value          order by month_value)";

//}
//if(!regionCd.equals("")){
// sqlQueryYear="select month||'-'||substr('"+request.getParameter("year")+"',3,3) year ,month_value, sum(cut) TotalAmount ,region_cd from (select aa.month,         month_value,         bb.airport_cd,ar.region_cd region_cd,         (case           when to_char(bb.incid_date, 'MON') = to_char(aa.month) then            count(*)           else            0         end) cut    from (select  MONTH_NAME month ,MONTH month_value from months) aa,         tc_incident_mt bb, airports_regions ar   where  bb.incid_place=ar.airport_cd and to_char(bb.incid_date, 'YYYY') = '"+request.getParameter("year")+"'     and trim(CATEGORY) = '"+request.getParameter("incident")+"'  and ar.region_cd='"+regionCd+"'    group by aa.month, month_value, bb.airport_cd,ar.region_cd,to_char(bb.incid_date, 'MON')   order by month_value)   group by month,month_value,region_cd   order by month_value ";
//}

double bl[] = new double[3];
String baseLevel="";
System.out.println("sqlQueryYear---"+sqlQueryYear);
/*ResultSet rs1 = cf.getRecordSet(sqlQueryYear);
			if(rs1 != null) {
				if(rs1.next()) {
					//System.out.println("arr_count---"+rs1.getString("arr_count"));
					//bl[0]=rs1.getDouble("ALERT_LEVEL1");
					//bl[1]=rs1.getDouble("ALERT_LEVEL2");
					//bl[2]=rs1.getDouble("ALERT_LEVEL3");
					baseLevel=rs1.getString("BASE_LEVEL");



				}
			}
			if(rs1 != null)
				rs1.close();
for(int kk=0 ;kk<bl.length;kk++){

	System.out.println("...."+bl[kk]);

}
*/
System.out.println(" sqlQueryYear"+sqlQueryYear);
            // Execute the query.
            PreparedStatement pt=con.prepareStatement(sqlQueryYear);  
			PreparedStatement pt1=con.prepareStatement(sqlQueryYear);  
            ResultSet result=pt.executeQuery();
			ResultSet result1=pt1.executeQuery();
            
            // The 'chartobj' map object holds the chart attributes and data.
            Map<String, String> chartobj = new HashMap<String, String>();//for getting key value pair
            
            String captionStr=incidentName+" Incidents For ";
			if(!regionCd.equals("")){
			captionStr+=request.getParameter("regionName");
			}else{
				captionStr+=" ALL ";
			}

			captionStr+=" Airports  [Year-"+request.getParameter("year")+"]";
            chartobj.put("caption", captionStr);
           // chartobj.put("subCaption", "Bakersfield Central vs Los Angeles Topanga");
            chartobj.put("captionFontSize", "14");
            chartobj.put("subcaptionFontSize", "14");
            chartobj.put("subcaptionFontBold", "0");
            chartobj.put("paletteColors", "#0075c2,#1aaf5d");
			 chartobj.put("canvasBgColor", "#f7e5ff");// added graph background 

            chartobj.put("bgcolor", "#FF00FF");
            chartobj.put("showBorder", "0");
            chartobj.put("showShadow", "0");
            chartobj.put("showCanvasBorder", "0");
            chartobj.put("usePlotGradientColor", "0");
            chartobj.put("legendBorderAlpha", "0");
            chartobj.put("legendShadow", "0");
            chartobj.put("showAxisLines", "0");
            chartobj.put("showAlternateHGridColor", "0");
            chartobj.put("divlineThickness", "1");
            chartobj.put("divLineDashed", "1");
            chartobj.put("divLineDashLen", "1");
            chartobj.put("divLineGapLen", "1");
            chartobj.put("xAxisName", "Months");
			chartobj.put("yAxisName", "No Of Incidents Per"+baseLevel);
            chartobj.put("showValues", "1");
			chartobj.put("exportEnabled", "1");
            
            //prepare vline
            Map<String, String> vline = new LinkedHashMap<String, String>();
            vline.put("vline", "true");
            vline.put("lineposition", "1");
            vline.put("color", "#6baa01");
            vline.put("labelHAlign", "center");
            vline.put("labelPosition", "1");
            vline.put("label", "National holiday");
            vline.put("dashed", "10");
            
         //  System.out.println("@@@@@@@@@@");
           
            //prepare categorie
            ArrayList categories = new ArrayList();
            categories.add(buildCategories("year", result, vline, 2, gson));
            
            //prepare dataset
            ArrayList dataset = new ArrayList();
            dataset.add(buildDataset("","TotalAmount", result1, gson));
            //dataset.add(buildDataset("Los Angeles Topanga", "TotalAmount", result1, gson));
            
            //prepare trendlines
            ArrayList trendlines= new ArrayList();
            //trendlines.add(buildTrendlines("startvalue","color","displayvalue",gson));
            
            //close the connection.
            result.close();
			result1.close();
 
  
            //create 'dataMap' map object to make a complete FusionCharts datasource.
             Map<String, String> dataMap = new LinkedHashMap<String, String>();  
        /*
            gson.toJson() the data to retrieve the string containing the
            JSON representation of the data in the array.
        */
		//System.out.println("gson.toJson(chartobj)"+gson.toJson(chartobj));
		//System.out.println("gson.toJson(categories)"+gson.toJson(categories));
		//System.out.println("gson.toJson(dataset)"+gson.toJson(dataset));
		//System.out.println("gson.toJson(trendlines)"+gson.toJson(trendlines));

             dataMap.put("chart", gson.toJson(chartobj));
             dataMap.put("categories", gson.toJson(categories));
             dataMap.put("dataset", gson.toJson(dataset));
             dataMap.put("trendlines",gson.toJson(trendlines));
			 dataMap.put("trendlines",gson.toJson(trendlines));
            FusionCharts mslineChart= new FusionCharts(
            "msline",// chartType
                        "chart1",// chartId
                        "600","400",// chartWidth, chartHeight
                        "chart",// chartContainer
                        "json",// dataFormat
                        gson.toJson(dataMap) //dataSource
                    );
           
            %>
            
            
            <%!
            /**
             * @description - Build the Json for the categories
             * @param {String} data_item - Name of the column from table
             * @param {ResultSet} rs - The object of ResultSet maintains a 
             *      cursor pointing to a particular row of data.
             * @param {int} store position of the vline object.
             * @param {Gson}  gson - Gson is a Java library that can be used 
             *      to convert Java Objects into their JSON representation.
             * @return {Map Object} 
             */
            public Map buildCategories(String data_item, ResultSet rs, Map vline, int vline_posi, Gson gson) {
                //creation of the inner category
                Map<String, String> categoryinner = new HashMap<String, String>();
                ArrayList category = new ArrayList();
                int counter = -1;
                try {
                    //to restore the position of the result set.
                    //rs.beforeFirst();
                    while(rs.next()) {    
                        //for creating the key value for the category label from database.
                        Map<String, String> lv = new HashMap<String, String>();
                        lv.put("label", rs.getString(data_item));
                        category.add(lv);
                        
                        counter ++;
                        // checking the given vline position and the current object structure position.
                       /*
						if(counter == vline_posi) {
                            category.add(vline);
                        }
						*/
                    }
                    categoryinner.put("category", gson.toJson(category));
                }catch(Exception ex) {/* if any error occure */}
                
                return categoryinner;
            }
            
            
            /**
             * @description - Build the Json for datasets
             * @param {String} seriesname - Lets you specify the series 
             *      name for a particular dataset.
             * @param {String} seriescolumnname - Name of the column from table
             * @param {ResultSet} - The object of ResultSet maintains a 
             *      cursor pointing to a particular row of data.
             * @param {Gson} gson - Gson is a Java library that can be used 
             *      to convert Java Objects into their JSON representation.
             * @return {Map Object}
-            */
            public Map buildDataset(String seriesname, String seriescolumnname, ResultSet rs, Gson gson ) {
            
                Map<String, String> datasetinner = new HashMap<String, String>();
                datasetinner.put("seriesname", seriesname); 
                
                ArrayList makedata = new ArrayList();
                try {
                //is used to move the cursor to the first row in result set object.
                   //rs.beforeFirst();
                    while(rs.next()) {

                      Map<String, String> preparedata = new HashMap<String, String>();  
                      preparedata.put("value", rs.getString(seriescolumnname));
                      makedata.add(preparedata);  
                    }
                    datasetinner.put("data", gson.toJson(makedata));

                } catch(Exception err) {/* if any error occure */}

                return datasetinner;
            }

            
            public Map buildTrendlines(String startvalue, String color, String displayvalue, Gson gson){

                   Map<String, String> trendlineinner = new HashMap<String, String>();
                     ArrayList lines = new ArrayList();
                        Map<String, String> linesdata1 = new HashMap<String, String>();  
                      linesdata1.put("startvalue", "2");
                      linesdata1.put("color","#6baa01");
                      linesdata1.put("displayvalue","Base Line1 &nbsp;&nbsp;");
					  lines.add(linesdata1); 
					   Map<String, String> linesdata2 = new HashMap<String, String>();  
					  linesdata2.put("startvalue", "10");
                      linesdata2.put("color","#6baa01");
                      linesdata2.put("displayvalue","Base Line2 &nbsp;&nbsp;");
                      lines.add(linesdata2);  
					   Map<String, String> linesdata3 = new HashMap<String, String>();  
					  linesdata3.put("startvalue", "50");
                      linesdata3.put("color","#6baa01");
                      linesdata3.put("displayvalue","Base Line3 &nbsp;&nbsp;");
                      lines.add(linesdata3);  
                   
                    trendlineinner.put("line", gson.toJson(lines));

             

                return trendlineinner;
}
            
            %>
            
<!--    Step 5: Render the chart    -->                
            
        <%= mslineChart.render() %>
		</div>
<!--
<div class="col-md-6" style="margin-top: -404px !important;  margin-left: 608px !important">
<table border=1 class="sample" cellpadding=3 cellspacing=0 width="70%" >
<tr>
	<th class="ColumnName"  nowrap>Sl.No</th>
	<th class="ColumnName"  nowrap>Month</th>
	<th class="ColumnName">Count</th>
	
	
	</tr>
	<%
	 ResultSet rs=cf.getRecordSet(sqlQueryYear);
	 int i=0;
	 while (rs.next()){
	i++;
	%>
	<tr>
	<td class="ColumnName"  nowrap><%=i%></td>
	<td class="ColumnName"  nowrap><%= rs.getString("year")%></td>
	<td class="ColumnName"><%= rs.getString("TotalAmount")%></td>
	
	
	</tr>
	<%}%>
		 

		 
		 </table>
</div>
-->
</div>
</div>
</div>
</div>
</div>
</div>
</div>
</div></div>
</div>
</div>

      
    </body>
</html>

