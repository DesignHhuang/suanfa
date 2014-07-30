<%@ page contentType="text/html;charset=GBK" %>
<%@page import="java.util.*"%>
<%@page import="com.blisscloud.util.*"%>
<%
    String rootPath = request.getContextPath();
%>
<html>
	<head>
		<title>工单产品视图</title>
		<link href="<%=rootPath%>/css/chrome.css" rel="stylesheet" type="text/css">
		<script src="<%=rootPath%>/script/EvanGrid.js"></script>
		<script src="<%=rootPath%>/script/DateTime.js" language="JavaScript" type="text/javascript"></script>
	    <script language="javascript"><%@include file="/script/DateTimeVariable.js"%></script>
		<script language="javascript" type="text/javascript">
		/*Go new page*/
		function  goNewPage()
		{
			 document.form1.curpage.value = document.form1.selPage.value;
		     form1.action="<%=request.getContextPath()%>/jsp/product/product_view.jsp";
		     document.form1.submit();
		}
		/*Go to Page*/
	    function  goToPage(_curpage)
	    {
	     document.form1.curpage.value = _curpage;
	     form1.action="<%=request.getContextPath()%>/jsp/product/product_view.jsp";
	     document.form1.submit();
	    }
	    /*Delete BillProduct*/
	    function delBillProduct(billProductSeqID)
	    {
			if(confirm("确定要删除吗?"))
			{
				document.form1.billProductSeqID.value = billProductSeqID;
				document.form1.optType.value = "delBillProduct";
				document.form1.submit();
		    }
		}
		/*refresh the billpage*/
		function refreshBillPage(billID)
		{
			//parent.opener.document.getElementById("jetonBillProductFrame").src = "<%=rootPath%>/jsp/product/bill_product_list.jsp?billID="+billID;
			
			parent.opener.document.frames('jetonBillProductFrame').location.reload();
		}
	    </script>
	</head>
	<%
		String billID	 		= request.getParameter("billID");		 //工单ID
		String productID  		= request.getParameter("productID");	 //产品ID
		String productLimitTime	= request.getParameter("productLimitTime");	//产品限用日期 
		String productBatNo     = request.getParameter("productBatNo");		//产品批号
		String avoidWrongNo = request.getParameter("avoidWrongNo");
		String billProductSeqID = request.getParameter("billProductSeqID"); //billProductSeqID
		String optType	  		= request.getParameter("optType");	 		//optType
		
		if(StringUtil.isNullOrEmpty(billID))billID="-1";
		if(StringUtil.isNullOrEmpty(productLimitTime))productLimitTime="";
		if(StringUtil.isNullOrEmpty(productBatNo))productBatNo="";
		String curpage	  = request.getParameter("curpage");
		
		//1.add product to bill
		if(!StringUtil.isNullOrEmpty(billID)
		   && !"-1".equals(billID)
		   &&!StringUtil.isNullOrEmpty(optType)
		   &&"toAdd".equals(optType)	
		)
		{
			//1.查询当前工单中当前产品信息是否已经存在
			String existSQL = "select count(0) from TB_IPS_BILL_PRODUCT "+
							  "where billID='"+billID+"' "+
							  "and PRODUCTID="+productID+
							  " and PRODUCTBATNO='"+productBatNo+"'"+
							  " and productLimitTime='"+productLimitTime+"'"+
							  " and AVOIDWRONGNO='"+avoidWrongNo+"'";
			String hasExist = EZDbUtil.getOnlyStringValue(existSQL);
			if(!"0".equals(hasExist))
			{
				out.println("<script>");
				out.println("alert('该产品已经在工单中存在!');");
				out.println("</script>");
			}
			//2.将当前选定的产品保存至工单产品列表中
			if("0".equals(hasExist))
			{
				String addProductSQL = "insert  into TB_IPS_BILL_PRODUCT( "+
								   "    SEQID,BILLID,PRODUCTID,PRODUCTBATNO,PRODUCTLIMITTIME,AVOIDWRONGNO "+
								   ") "+
								   "values( "+
										   "nextval('SEQ_TB_IPS_BILL_PRODUCT'),"+
										   "'"+billID+"',"+
										   productID+","+
										   "'"+productBatNo+"',"+
										   "'"+productLimitTime+"', '"+avoidWrongNo+
								   "') ";
				boolean okFlag = EZDbUtil.runSql(addProductSQL);
				//新增成功后更新工单页面
				if(okFlag)
				{
					out.println("<script>");
					out.println("refreshBillPage('"+billID+"');");
					out.println("</script>");
				}
			}
		}
		
		//2.删除当前工单产品
		if(!StringUtil.isNullOrEmpty(billProductSeqID)
				   &&!StringUtil.isNullOrEmpty(optType)
				   &&"delBillProduct".equals(optType)
				
		)
		{
			String delBillProductSQL = "delete from TB_IPS_BILL_PRODUCT where seqid="+billProductSeqID;
			boolean delFlag = EZDbUtil.runSql(delBillProductSQL);
			//删除成功后更新工单页面
			if(delFlag)
			{
				String sql = "select count(*) FROM tb000000product p left join TB_IPS_BILL_PRODUCT bp on p.lid=bp.productid WHERE 1=1";
				if(!StringUtil.isNullOrEmpty(billID)
						&& !"-1".equals(billID)
				   )
		  		{
		  			sql+=" and bp.billid='"+billID+"' ";  
		  		}
				String count = EZDbUtil.getOnlyStringValue(sql);
				if(count!=null&&!"null".equals(count)){
					if(curpage!=null&&!"null".equals(curpage)){
						if(Integer.parseInt(count)%(5)==0){
							if(Integer.parseInt(curpage)>1){
								curpage=String.valueOf(Integer.parseInt(curpage)-1);
							}
						}
					}
				}
				
				out.println("<script>");
				out.println("refreshBillPage('"+billID+"');");
				out.println("</script>");
			}
		}
		
		//3.查询当前工单已经选择的产品
		String sql = "";
		StringBuffer buffer=new StringBuffer();
		buffer.append("SELECT ");
		buffer.append("bp.productbatno,");											//生产批号
		buffer.append("bp.productlimittime, ");	//限用日期
		buffer.append("strname,");													//产品名称
		buffer.append("strextend4, ");												//国际条码
		buffer.append("bp.avoidWrongNo, ");												//防串货码
		buffer.append("strmanufacturer, ");											//工厂
		buffer.append("bp.seqid, ");											        //工单产品ID
		buffer.append("strextend1 as brand,");											//品牌
		buffer.append("strextend2 as series, ");											//系列
		buffer.append("strstandard as form ");								//规格

		buffer.append("FROM tb000000product p ");
		buffer.append("left join TB_IPS_BILL_PRODUCT bp on p.lid=bp.productid ");
		buffer.append("WHERE 1=1 ");
  		//productID
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
		<form  name="form1"  method="post" action="product_view.jsp">
		<input name="curpage" type="hidden" value="<%=curpage%>"/>
		<input name="billID" type="hidden" value="<%=billID%>"/>
		<input name="billProductSeqID" type="hidden" value=""/>
		<input name="optType" type="hidden" value=""/>
		<table border="0" cellspacing="0" cellpadding="3" width="100%" class="opbg">
			<tr valign="top">
				<td align="left" valign="middle">
           			<div id="Title">
           				<img src='<%=rootPath%>/images/ipcc_icon_production.gif' align='absmiddle' width='16' height='16' border='0'/>
           				<strong class="titleMiddle">工单产品选择</strong>
           			</div>              			
           		</td>
           	</tr>
        </table>
		<div id="dataTable">
			<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0" id="theObjTable" style="table-layout:fixed;">
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
								String billProductSeqId			   =  String.valueOf(s[6]);	//工单产品ID
								String brand	   				   =  String.valueOf(s[7]);	//品牌
								String series					   =  String.valueOf(s[8]);	//系列
								String form					       =  String.valueOf(s[9]);	//系列
								if(StringUtil.isNullOrEmpty(productbatno))productbatno="";
								if(StringUtil.isNullOrEmpty(productlimittime))productlimittime="";
								if(StringUtil.isNullOrEmpty(strname))strname="";
								if(StringUtil.isNullOrEmpty(brand))brand="";
								if(StringUtil.isNullOrEmpty(series))series="";
								if(StringUtil.isNullOrEmpty(interNo))interNo="";
								if(StringUtil.isNullOrEmpty(billProductSeqID))billProductSeqID="";
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
								<td nowrap="nowrap" align="center"><a style="cursor:hand;" onclick="delBillProduct('<%=billProductSeqId%>');">删除</a></td>
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
		["限用日期",100],
		["品牌",80],
		["系列",80],
		["产品名称",150],
		["规格",80],
		["国际条码",100],	
		["防串货码",100],
		["工厂信息",150],
		["操作",]
		];
		initGrid(fields,"<%=rootPath%>/css/EvanGrid.css","<%=rootPath%>/images/evanGrid");
	</script>
