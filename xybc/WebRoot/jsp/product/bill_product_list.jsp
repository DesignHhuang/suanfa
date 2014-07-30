<%@ page contentType="text/html;charset=GBK" %>
<%@page import="java.util.*"%>
<%@page import="com.blisscloud.util.*"%>
<%
    String rootPath = request.getContextPath();
%>
<html>
	<head>
		<title>工单产品列表</title>
		<link href="<%=rootPath%>/css/chrome.css" rel="stylesheet" type="text/css">
		<script src="<%=rootPath%>/script/EvanGrid.js"></script>
		<script src="<%=rootPath%>/script/DateTime.js" language="JavaScript" type="text/javascript"></script>
	    <script language="javascript"><%@include file="/script/DateTimeVariable.js"%></script>
		<script language="javascript" type="text/javascript">
		/*Go new page*/
		function  goNewPage()
		{
			 document.form1.curpage.value = document.form1.selPage.value;
		     form1.action="<%=request.getContextPath()%>/jsp/product/bill_product_list.jsp";
		     document.form1.submit();
		}
		/*Go to Page*/
	    function  goToPage(_curpage)
	    {
	     document.form1.curpage.value = _curpage;
	     form1.action="<%=request.getContextPath()%>/jsp/product/bill_product_list.jsp";
	     document.form1.submit();
	    }
	    </script>
	</head>
	<%
		String billID	  = request.getParameter("billID");		 //工单ID
		
		if(StringUtil.isNullOrEmpty(billID))
		{
			billID="-1";
		}
		String curpage	  = request.getParameter("curpage");
		
		String sql = "";
		StringBuffer buffer=new StringBuffer();
		buffer.append("SELECT ");
		buffer.append("bp.productbatno,");											//生产批号
		buffer.append("bp.productlimittime, ");	//限用日期
		buffer.append("strname,");													//产品名称
		buffer.append("strextend4, ");												//国际条码
		buffer.append("bp.avoidWrongNo, ");												//防串货码
		buffer.append("strmanufacturer, ");											//工厂
		buffer.append("strextend1 as brand,");											//品牌
		buffer.append("strextend2 as series, ");											//系列
		buffer.append("strstandard as form ");								//规格
		buffer.append("FROM tb000000product p ");
		buffer.append("left join TB_IPS_BILL_PRODUCT bp on p.lid=bp.productid ");
		buffer.append("WHERE 1=1 ");
  		//productID
  		//System.out.print(billID);
		if(!StringUtil.isNullOrEmpty(billID)
				&& !"-1".equals(billID)
		   )
  		{
  			
  			buffer.append(" and bp.billid='"+billID+"' or bp.billid='1' ");  
  		}
  	 	buffer.append(" order by lid desc"); 
   		sql=buffer.toString();
   		//out.println("sql-->"+sql);
   		List list=null;
   		int currentPageNumber=StringUtil.getIntValue(curpage,1);
   		EZSimpleDataPageBean pageBean=new EZSimpleDataPageBean();
   		String countSql=EZDbUtil.getCountSql(sql);
   		pageBean.setCurrentPageNumber(currentPageNumber);
   		pageBean.execute(countSql,sql,currentPageNumber,5);
   		list=pageBean.getCollection();
   		String picPath=request.getContextPath();
   		pageBean.setPicPath(picPath);
   		pageBean.setEachPageRowLimit(5);
   		pageBean.setFooter();    
		%>
	<body topmargin="0" leftmargin="0" rightmargin="0" style="overflow: hidden;">
		<form  name="form1"  method="post" action="bill_product_list.jsp">
		<input name="curpage" type="hidden" value="<%=curpage%>"/>
		<input name="billID" type="hidden" value="<%=billID%>"/>
		<div id="dataTable">
			<table width="100%" border="0" cellspacing="0" cellpadding="0" id="theObjTable" style="table-layout:fixed;">
			<tbody id="dataArea">
			 	<%
				 if(list!=null)
					{
						for(int i=0;i<list.size();i++){
						Object[] s =(Object[])list.get(i);
						if(s!=null)
						{
							String productbatno 	 		   =  String.valueOf(s[0]);	//生产批号
							String productlimittime		  	   =  String.valueOf(s[1]);	//限用日期
							String strname	   			       =  String.valueOf(s[2]);	//产品名称
							String interNo					   =  String.valueOf(s[3]);	//国际条码
							String preventfalseno  			   =  String.valueOf(s[4]);	//防串货码
							String strmanufacturer 			   =  String.valueOf(s[5]);	//工厂
							String brand	   				   =  String.valueOf(s[6]);	//品牌
							String series					   =  String.valueOf(s[7]);	//系列
							String form					       =  String.valueOf(s[8]);	//规格
							if(StringUtil.isNullOrEmpty(productbatno))productbatno="";
							if(StringUtil.isNullOrEmpty(productlimittime))productlimittime="";
							if(StringUtil.isNullOrEmpty(strname))strname="";
							if(StringUtil.isNullOrEmpty(brand))brand="";
							if(StringUtil.isNullOrEmpty(series))series="";
							if(StringUtil.isNullOrEmpty(interNo))interNo="";
							if(StringUtil.isNullOrEmpty(preventfalseno))preventfalseno="";
							if(StringUtil.isNullOrEmpty(strmanufacturer))strmanufacturer="";
							if(StringUtil.isNullOrEmpty(form))form="";  //规格
					%>
						<TR>
							<td align="center" nowrap="nowrap"><%=i+1%></td>
							<td nowrap="nowrap"><%=productbatno%></td>
							<td nowrap="nowrap"><%=productlimittime%></td>
							<td nowrap="nowrap"><%=brand%></td>
							<td nowrap="nowrap"><%=series%></td>
							<td nowrap="nowrap"><%=strname%></td>
							<td nowrap="nowrap"><%=form%></td>
							<td nowrap="nowrap"><%=interNo%></td>
							<td nowrap="nowrap"><%=preventfalseno%></td>
							<td nowrap="nowrap"><%=strmanufacturer%></td>
						</tr>
						<%}}}%>
							
			</tbody>
		 </table>
		 </div>
		 
		<!-- 页面翻页  -->
		<table width="100%" align="center" border="0" cellpadding="0" cellspacing="0">
        	<tr id="trPage">
	    		<td colspan="10">
	    			<table width="100%" align="center" border="0" cellpadding="0" cellspacing="0">
						<tr>
	   						<td><%=pageBean.getFooter()%></td>
	   					</tr>
	  				</table>
	  			</td>
	 		</tr> 	
		</table>
	 </form>
	</body>	
</html>

<script language="javascript" type="text/javascript">
		var fields = [
		["序号",40],
		["生产批号",80],	
		["限用日期",120],
		["品牌",80],
		["系列",80],
		["产品名称",140],
		["规格",80],
		["国际条码",100],	
		["防串货码",100],
		["工厂信息",]
		];
		initGrid(fields,"<%=rootPath%>/css/EvanGrid.css","<%=rootPath%>/images/evanGrid");
</script>

