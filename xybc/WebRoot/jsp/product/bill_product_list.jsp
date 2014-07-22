<%@ page contentType="text/html;charset=GBK" %>
<%@page import="java.util.*"%>
<%@page import="com.blisscloud.util.*"%>
<%
    String rootPath = request.getContextPath();
%>
<html>
	<head>
		<title>������Ʒ�б�</title>
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
		String billID	  = request.getParameter("billID");		 //����ID
		if(StringUtil.isNullOrEmpty(billID))billID="-1";
		String curpage	  = request.getParameter("curpage");
		
		String sql = "";
		StringBuffer buffer=new StringBuffer();
		buffer.append("SELECT ");
		buffer.append("bp.productbatno,");											//��������
		buffer.append("bp.productlimittime, ");	//��������
		buffer.append("strname,");													//��Ʒ����
		buffer.append("strextend4, ");												//��������
		buffer.append("bp.avoidWrongNo, ");												//��������
		buffer.append("strmanufacturer, ");											//����
		buffer.append("strextend1 as brand,");											//Ʒ��
		buffer.append("strextend2 as series, ");											//ϵ��
		buffer.append("strstandard as form ");								//���
		buffer.append("FROM tb000000product p ");
		buffer.append("left join TB_IPS_BILL_PRODUCT bp on p.lid=bp.productid ");
		buffer.append("WHERE 1=1 ");
  		//productID
		if(!StringUtil.isNullOrEmpty(billID)
				&& !"-1".equals(billID)
		   )
  		{
  			buffer.append(" and bp.billid='"+billID+"' ");  
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
							String productbatno 	 		   =  String.valueOf(s[0]);	//��������
							String productlimittime		  	   =  String.valueOf(s[1]);	//��������
							String strname	   			       =  String.valueOf(s[2]);	//��Ʒ����
							String interNo					   =  String.valueOf(s[3]);	//��������
							String preventfalseno  			   =  String.valueOf(s[4]);	//��������
							String strmanufacturer 			   =  String.valueOf(s[5]);	//����
							String brand	   				   =  String.valueOf(s[6]);	//Ʒ��
							String series					   =  String.valueOf(s[7]);	//ϵ��
							String form					       =  String.valueOf(s[8]);	//���
							if(StringUtil.isNullOrEmpty(productbatno))productbatno="";
							if(StringUtil.isNullOrEmpty(productlimittime))productlimittime="";
							if(StringUtil.isNullOrEmpty(strname))strname="";
							if(StringUtil.isNullOrEmpty(brand))brand="";
							if(StringUtil.isNullOrEmpty(series))series="";
							if(StringUtil.isNullOrEmpty(interNo))interNo="";
							if(StringUtil.isNullOrEmpty(preventfalseno))preventfalseno="";
							if(StringUtil.isNullOrEmpty(strmanufacturer))strmanufacturer="";
							if(StringUtil.isNullOrEmpty(form))form="";  //���
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
		 
		<!-- ҳ�淭ҳ  -->
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
		["���",40],
		["��������",80],	
		["��������",120],
		["Ʒ��",80],
		["ϵ��",80],
		["��Ʒ����",140],
		["���",80],
		["��������",100],	
		["��������",100],
		["������Ϣ",]
		];
		initGrid(fields,"<%=rootPath%>/css/EvanGrid.css","<%=rootPath%>/images/evanGrid");
</script>

