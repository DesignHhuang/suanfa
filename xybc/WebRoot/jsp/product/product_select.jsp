<%@ page contentType="text/html;charset=GBK" %>
<%@page import="java.util.*"%>
<%@page import="com.blisscloud.util.*"%>
<%
    String rootPath = request.getContextPath();
	String myTextSize		 = "size=\"20\"";
%>
<html>
	<head>
		<title>��Ʒ��ѯ</title>
		<link href="<%=rootPath%>/css/chrome.css" rel="stylesheet" type="text/css">
		<script src="<%=rootPath%>/script/EvanGrid.js"></script>
		<script src="<%=rootPath%>/script/DateTime.js" language="JavaScript" type="text/javascript"></script>
	    <script language="javascript"><%@include file="/script/DateTimeVariable.js"%></script>
		<script language="javascript" type="text/javascript">
		/*Search*/
		function queryProduct()
		{
			form1.curpage.value = 1;
			form1.submit();
		}
		/*reset Product */
		function resetProduct()
		{
			form1.productName.value = "";
			form1.productBatno.value = "";
			form1.limitTime.value = "";
			form1.productBarcode.value = "";
			form1.factory.value = "";
			form1.preventFalseno.value = "";
		}
		/*Go new page*/
		function  goNewPage()
		{
			 document.form1.curpage.value = document.form1.selPage.value;
		     form1.action="<%=request.getContextPath()%>/jsp/product/product_select.jsp";
		     document.form1.submit();
		}
		/*Go to Page*/
	    function  goToPage(_curpage)
	    {
	     document.form1.curpage.value = _curpage;
	     form1.action="<%=request.getContextPath()%>/jsp/product/product_select.jsp";
	     document.form1.submit();
	    }
	    /*set select productID value*/
	    function setBillProduct(lid)
	    {
			document.form1.selectProductID.value = lid;
		}
		/*get the Selected porductID*/
		function getSelProductID()
		{
			return document.form1.selectProductID.value;
		}
		</script>
	</head>
	<%
		String productName	  = request.getParameter("productName");     //��Ʒ����
		String productBarcode = request.getParameter("productBarcode");  //��������
		if(StringUtil.isNullOrEmpty(productName))productName="";
		if(StringUtil.isNullOrEmpty(productBarcode))productBarcode="";
		
		String curpage			= request.getParameter("curpage");
		String flag				= request.getParameter("flag");
		String sql = "";
		StringBuffer buffer=new StringBuffer();
		buffer.append("SELECT lid, ");									//��ƷID
		buffer.append("strname, ");										//��Ʒ����
		buffer.append("strextend4, ");									//��������
		//buffer.append("strextend2, ");									//��������
		buffer.append("strmanufacturer, ");								//����
		buffer.append("strextend1 as brand,");								//Ʒ��
		buffer.append("strextend2 as series,");							//ϵ��
		buffer.append("strstandard as form ");								//���
		buffer.append("FROM tb000000product ");
		buffer.append("WHERE 1=1 ");
  		//��Ʒ����
		if(!StringUtil.isNullOrEmpty(productName))
  		{
  			buffer.append(" and strname like '%"+productName+"%' ");  
  		}
		//��Ʒ����(strextend4----��Ӧ��������)
		if(!StringUtil.isNullOrEmpty(productBarcode))
  		{
  			buffer.append(" and strextend4 like '%"+productBarcode+"%' ");  
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
	
	<body topmargin="5" leftmargin="0" rightmargin="0" style="overflow: hidden;"> 
		<form  name="form1"  method="post" action="product_select.jsp">
		<input name="curpage" type="hidden" value="<%=curpage%>"/>
		<input name="selectProductID" type="hidden" value="-1"/>
		<table border="0" cellspacing="0" cellpadding="3" width="100%" class="opbg">
			<tr valign="top">
				<td align="left" valign="middle">
           			<div id="Title">
           				<img src='<%=rootPath%>/images/ipcc_icon_setup.gif' align='absmiddle' width='16' height='16' border='0'/>
           				<strong class="titleMiddle">��Ʒ��ѯ</strong>
           			</div>              			
           		</td>
           	</tr>
        </table>
		<table width="100%" border="0" cellspacing="0" cellpadding="0" class="opbg" style="table-layout:fixed;">
		  <tr>
		    <td align="right" nowrap="nowrap">��Ʒ���ƣ�</td>
		    <td><input name="productName" type="text" class="box01" value="<%=productName%>" <%=myTextSize%>></td>
		    <td align="right" nowrap="nowrap">�������룺</td>
		    <td><input name="productBarcode" type="text" class="box01" value="<%=productBarcode%>" <%=myTextSize%>></td>
		    <td align="left" nowrap="nowrap" height="30px">
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<input value="��ѯ" type="button" style="width:80px;"  onclick="queryProduct();" class="button">
			</td>	
		  </tr>
		</table>
		
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
							String lid 	 		   =  String.valueOf(s[0]);	//lid
							String strname	  	   =  String.valueOf(s[1]);	//��Ʒ����
							String strserialnumber =  String.valueOf(s[2]);	//��������
						//	String preventfalseno  =  String.valueOf(s[3]);	//��������
							String strmanufacturer =  String.valueOf(s[3]);	//����
							String brand		   =  String.valueOf(s[4]);	//Ʒ��
							String series		   =  String.valueOf(s[5]);	//ϵ��
							String form			   =  String.valueOf(s[6]); //���
							
							
							if(StringUtil.isNullOrEmpty(lid))lid="";
							if(StringUtil.isNullOrEmpty(strname))strname="";
							if(StringUtil.isNullOrEmpty(strserialnumber))strserialnumber="";
					//		if(StringUtil.isNullOrEmpty(preventfalseno))preventfalseno="";
							if(StringUtil.isNullOrEmpty(strmanufacturer))strmanufacturer="";
							if(StringUtil.isNullOrEmpty(brand))brand="";	//Ʒ��
							if(StringUtil.isNullOrEmpty(series))series="";	//ϵ��
							if(StringUtil.isNullOrEmpty(series))series="";  //���
					%>
						<TR>
							<td align="center" nowrap="nowrap">
								<input name="myCheckProduct" type="radio" value="<%=lid%>" 
									   onclick="setBillProduct('<%=lid%>');"> 
					        </td>
					        <td nowrap="nowrap" align="center"><%=i+1%></td>
							<td nowrap="nowrap"><%=brand%></td>
							<td nowrap="nowrap"><%=series%></td>
							<td nowrap="nowrap"><%=strname%></td>
							<td nowrap="nowrap"><%=form%></td>
							<td nowrap="nowrap"><%=strserialnumber%></td>
							<td nowrap="nowrap"><%=strmanufacturer%></td>
						</tr>
						<%}}}%>
			</tbody> 
		 </table>
		 </div>
		 
		 <!-- ҳ�淭ҳ  -->
		<table width="100%" align="center" border="0" cellpadding="0" cellspacing="0">
        	<tr id="trPage">
	    		<td colspan="8">
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
	["ѡ��",30],
	["���",30],
	["Ʒ��",80],	
	["ϵ��",80],
	["��Ʒ����",120],
	["���",80],
	["��������",90],
	["������Ϣ",]
	];
	initGrid(fields,"<%=rootPath%>/css/EvanGrid.css","<%=rootPath%>/images/evanGrid");
</script>
