<%@ page contentType="text/html;charset=GBK" %>
<%@page import="java.util.*"%>
<%@page import="com.blisscloud.util.*"%>
<%
    String rootPath = request.getContextPath();
	String myTextSize		 = "size=\"16\"";
	
	String billID	  = request.getParameter("billID");		 //����ID
	if(StringUtil.isNullOrEmpty(billID))billID="-1";
%>
<html>
	<head>
		<title>��Ʒ������Ϣ</title>
		<link href="<%=rootPath%>/css/chrome.css" rel="stylesheet" type="text/css">
		<script src="<%=rootPath%>/script/DateTime.js" language="JavaScript" type="text/javascript"></script>
	    <script language="javascript"><%@include file="/script/DateTimeVariable.js"%></script>
		<script language="javascript" type="text/javascript">
		/*addProductToBill*/
		function addProductToBill()
		{
			var mySelProductID = parent.frames["productSelectFrame"].getSelProductID();
			//alert("mySelProductID--->"+mySelProductID);
			if(mySelProductID == '-1')
			{
				alert("��ѡ���Ʒ!");
				return false;
			}
		//	var productLimitTime = form1.productLimitTime.value;	//��������
		//	var productBatNo = form1.productBatNo.value;			//��������
		//	var avoidWrongNo = form1.avoidWrongNo.value;			//��������
			
	//		if((productLimitTime==null||productLimitTime==''||productLimitTime==""))
	//		{
	//			alert("��ѡ����������!");
	//			form1.productLimitTime.focus();
	//			return false;
	//		}
	//		if((productBatNo==null||productBatNo==''||productBatNo==""))
	//		{
	//			alert("��������������!");
	//			form1.productBatNo.focus();
	//			return false;
	//		}
	//		if((avoidWrongNo==null||avoidWrongNo==''||avoidWrongNo==""))
	//		{
	//			alert("�������������!");
	//			form1.avoidWrongNo.focus();
	//			return false;
	//		}
			
			form1.productID.value = mySelProductID;
			form1.submit();
		}
		</script>
	</head>
	<body topmargin="0" leftmargin="0" rightmargin="0" style="overflow: hidden;"> 
		<form  name="form1"  method="post" action="product_view.jsp" target="productViewFrame">
		<input name="billID" type="hidden" value="<%=billID%>"/>
		<input name="productID" type="hidden" value=""/>
		<input name="optType" type="hidden" value="toAdd"/>
		<table border="0" cellspacing="0" cellpadding="3" width="100%" class="opbg">
			<tr valign="top">
				<td align="left" valign="middle">
          			<div id="Title">
          				<img src='<%=rootPath%>/images/ipcc_icon_production.gif' align='absmiddle' width='16' height='16' border='0'/>
          				<strong class="titleMiddle">��Ʒ������Ϣ</strong>
          			</div>              			
          		</td>
          	</tr>
         </table>
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		  <tr>
		    <td align="right" nowrap="nowrap">�������ţ�</td>
		    <td>
		    	<input name="productBatNo" type="text" class="box01" value="" <%=myTextSize%>>
		    </td>
		  </tr> 


		<tr>
		    <td align="right" nowrap="nowrap">�������ڣ�</td>
		    <td>
		    	<input name="productLimitTime" type="text" class="box01" value=""  <%=myTextSize%>>
		    </td>
		  </tr>
		 
		  
		  <tr>
		    <td align="right" nowrap="nowrap">�������룺</td>
		    <td>
		    	<input name="avoidWrongNo" type="text" class="box01" value="" <%=myTextSize%>>
		    </td>
		  </tr>
		  
		  
		  <tr height="30px">
		    <td align="center" nowrap="nowrap" colspan="2">
				<input value="����" type="button" style="width:40px;"  onclick="addProductToBill();" class="button">
				<input value="����" type="reset" style="width:40px;"   class="button">
			</td>	
		  </tr>
		</table>
		</form>
	</body>	
</html>
