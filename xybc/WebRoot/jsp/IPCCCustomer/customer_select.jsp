<%@ page contentType="text/html;charset=GBK" %>
<%@page import="java.util.*"%>
<%@page import="com.blisscloud.util.*"%>
<%
    String rootPath = request.getContextPath();

	String myTextSize		 = "size=\"28\"";
%>
<html>
	<head>
		<title>�ͻ�ѡ��</title>
		<link href="<%=rootPath%>/css/chrome.css" rel="stylesheet" type="text/css">
		<script src="<%=rootPath%>/script/EvanGrid.js"></script>
		<script src="<%=rootPath%>/script/DateTime.js" language="JavaScript" type="text/javascript"></script>
	    <script language="javascript"><%@include file="/script/DateTimeVariable.js"%></script>
		<script language="javascript" type="text/javascript">
		/*Search Customer*/
		function queryCustomer()
		{
			form1.curpage.value = 1;
			form1.submit();
		}
		/*reset Customer */
		function resetCustomer()
		{
			form1.userName.value = "";
			form1.campany.value = "";
			form1.email.value = "";
			form1.phone.value = "";
		}
		/*Go new page*/
		function  goNewPage()
		{
			 document.form1.curpage.value = document.form1.selPage.value;
		     form1.action="<%=request.getContextPath()%>/jsp/IPCCCustomer/customer_select.jsp";
		     document.form1.submit();
		}
		/*Go to Page*/
	    function  goToPage(_curpage)
	    {
	     document.form1.curpage.value = _curpage;
	     form1.action="<%=request.getContextPath()%>/jsp/IPCCCustomer/customer_select.jsp";
	     document.form1.submit();
	    }
	    /*set EZIPCC Customer info*/
	    function setEZIPCCCustomer(lid,
	    						   IPCCCustomerINFO,
	    						   sex,
	    						   officePhone,
		                           homePhone,
		                           mobilePhone,city)
	    {
			if(confirm("ȷ��Ҫѡ��ÿͻ���?"))
			{
				//alert("lid--->"+lid+"---IPCCCustomerINFO---"+IPCCCustomerINFO);
				this.opener.form1.customerID.value = lid;
				this.opener.form1.IPCCCustomerINFO.value = IPCCCustomerINFO;
				this.opener.form1.IPCCCustomerSEX.value = sex;
				this.opener.form1.IPCCCompTel.value = officePhone;
				this.opener.form1.IPCCHomeTel.value = homePhone;
				this.opener.form1.IPCCMobileTel.value = mobilePhone;
				this.opener.form1.area.value = city;
				window.close();
			}
		}
		</script>
	</head>
	<%
		String userName 	= request.getParameter("userName");		//����
		String campany 		= request.getParameter("campany");		//��λ��
		String email  		= request.getParameter("email");		//�����ʼ�
		String phone  		= request.getParameter("phone");		//�绰 
		String customerID  	= request.getParameter("customerID");	//customerID 
		String optFrom		= request.getParameter("optFrom");		//optFrom
		
		
		if(StringUtil.isNullOrEmpty(userName))userName="";
		if(StringUtil.isNullOrEmpty(campany))campany="";
		if(StringUtil.isNullOrEmpty(email))email="";
		if(StringUtil.isNullOrEmpty(phone))phone="";
		if(StringUtil.isNullOrEmpty(customerID))customerID="";
		
		String curpage			= request.getParameter("curpage");
		String flag				= request.getParameter("flag");
		//2�����ݲ�ѯ�����õ����˿ͻ���Ϣ�б�; 
		String sql="select lid, strid, strname, nsex,"+ 
   						   "strcorporation,strmobilephone, strofficephone, strhomephone,stremail,ntitle,strcity1 "+
   					   "from tb000000personalcustomer "+
					   "where nstate='1'  ";
		//���� ��ӦEZIPCC�ֶ�strname
		if(!StringUtil.isNullOrEmpty(userName)){
			sql += " and strname like '%"+userName+"%'";
		}
		//��λ�� ��ӦEZIPCC�ֶ�strcorporation
		if(!StringUtil.isNullOrEmpty(campany)){
			sql += " and strcorporation like '%"+campany+"%'";
		}
		//�����ʼ� ��ӦEZIPCC�ֶ�email
		if(!StringUtil.isNullOrEmpty(email)){
			sql += " and stremail like '%"+email+"%'";
		}
		//�绰 ��ӦEZIPCC�ֶ�strmobilephone/strofficephone/strhomephone
		if(!StringUtil.isNullOrEmpty(phone)){
			sql += " and ( strmobilephone like '%"+phone+"%'"+
						   " or strofficephone like '%"+phone+"%'"+
						   " or strhomephone like '%"+phone+"%'"+
					" )";
		}
		//productID
		if(!StringUtil.isNullOrEmpty(customerID)
				&& !"-1".equals(customerID)
				&& !StringUtil.isNullOrEmpty(optFrom)
			    && "fromDetail".equals(optFrom)
		   )
  		{
			sql += " and lid='"+customerID+"' ";  
  		}
		sql += " order by lid desc";
		//out.println("sql-->"+sql);
   		List list=null;
   		int currentPageNumber=StringUtil.getIntValue(curpage,1);
   		EZSimpleDataPageBean pageBean=new EZSimpleDataPageBean();
   		String countSql=EZDbUtil.getCountSql(sql);
   		pageBean.setCurrentPageNumber(currentPageNumber);
   		pageBean.execute(countSql,sql,currentPageNumber,10);
   		list=pageBean.getCollection();
   		String picPath=request.getContextPath();
   		pageBean.setPicPath(picPath);
   		pageBean.setEachPageRowLimit(10);
   		pageBean.setFooter();    
		%>
	
	<body topmargin="0" style="overflow: hidden;"> 
		<form  name="form1"  method="post" action="customer_select.jsp">
		<input name="curpage" type="hidden" value="<%=curpage%>"/>
		<input name="customerID" type="hidden" value="<%=customerID%>"/>
		<table border="0" cellspacing="0" cellpadding="3" width="100%" class="opbg">
			<tr valign="top">
				<td align="left" valign="middle">
           			<div id="Title">
           				<img src='<%=rootPath%>/images/ipcc_icon_setup.gif' align='absmiddle' width='16' height='16' border='0'/>
           				<strong class="titleMiddle">������ѡ��</strong>
           			</div>              			
           		</td>
           	</tr>
        </table>
		<table width="100%" border="0" cellspacing="0" cellpadding="0" class="opbg">
		  <tr>
		    <td align="right" nowrap="nowrap">������</td>
		    <td><input name="userName" type="text" class="box01" value="<%=userName%>" <%=myTextSize%>></td>
		    <td align="right" nowrap="nowrap">��λ����</td>
		    <td><input name="campany" type="text" class="box01" value="<%=campany%>" <%=myTextSize%>></td>
		  </tr>
		  <tr>
		    <td align="right" nowrap="nowrap">�����ʼ���</td>
		    <td><input name="email" type="text" class="box01" value="<%=email%>" <%=myTextSize%>></td>
		    <td align="right" nowrap="nowrap">�绰��</td>
		    <td><input name="phone" type="text" class="box01" value="<%=phone%>" <%=myTextSize%>></td>
		  </tr>
		  <tr>
		    <td colspan="6" align="center" nowrap="nowrap" height="30px">
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<input value="��ѯ" type="button" style="width:80px;"  onclick="queryCustomer();" class="button">
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<input value="����" type="button" style="width:80px;" onclick="resetCustomer();" class="button">
			</td>	
		  </tr>
		</table>
		
		<div id="dataTable">
		<table  width="100%" border="0" cellspacing="0" cellpadding="0" id="theObjTable" style="table-layout:fixed;">
		  <tbody id="dataArea">
			<%
			 if(list!=null)
				{
					for(int i=0;i<list.size();i++){
					Object[] s =(Object[])list.get(i);
					if(s!=null)
					{
						String lid 	 		=	String.valueOf(s[0]);		//lid
						String strid 		=	String.valueOf(s[1]);		//strid
						String username	 	=  	String.valueOf(s[2]);		//����
						String sex		 	=  	String.valueOf(s[3]);		//�Ա�
						String campany0  	=	String.valueOf(s[4]);		//��λ��
						String mobilePhone 	=	String.valueOf(s[5]);		//�ֻ�
						String officePhone	=	String.valueOf(s[6]);		//�����绰
						String homePhone	=	String.valueOf(s[7]);		//��ͥ�绰
						String email0	  	=	String.valueOf(s[8]);		//�����ʼ�
						String ntitle	  	=	String.valueOf(s[9]);		//��ν
						String city	  	=	String.valueOf(s[10]);		//����
						
						if(StringUtil.isNullOrEmpty(strid))strid="";
						if(StringUtil.isNullOrEmpty(username))username="";
						if("0".equals(sex)){sex="";}
						if("1".equals(sex)){sex="��";}
						if("2".equals(sex)){sex="Ů";}
						if(StringUtil.isNullOrEmpty(campany0))campany0="";
						if(StringUtil.isNullOrEmpty(mobilePhone))mobilePhone="";
						if(StringUtil.isNullOrEmpty(officePhone))officePhone="";
						if(StringUtil.isNullOrEmpty(homePhone))homePhone="";
						if(StringUtil.isNullOrEmpty(email0))email0="";
						if("0".equals(ntitle)){ntitle="";}
						if("1".equals(ntitle)){ntitle="����";}
						if("2".equals(ntitle)){ntitle="С��";}
						if("3".equals(ntitle)){ntitle="Ůʿ";}
						if(StringUtil.isNullOrEmpty(city))city="";
				%>
					<TR>
						<td align="center" nowrap="nowrap">
							<input name="myCheckCustomer" type="radio" value="<%=lid%>" 
								   onclick="setEZIPCCCustomer('<%=lid%>',
								                              '<%=username%>',
								                              '<%=ntitle%>',
								                              '<%=officePhone%>',
								                              '<%=homePhone%>',
								                              '<%=mobilePhone%>',
								                              '<%=city%>');"
								  <%if(lid.equals(customerID)){out.println("checked=\"checked\"");} %>> 
				        </td>
						<td nowrap="nowrap"><%=username%></td>
						<td nowrap="nowrap" align="center"><%=sex%></td>
						<td nowrap="nowrap"><%=campany0%></td>
						<td nowrap="nowrap"><%=mobilePhone%></td>
						<td nowrap="nowrap"><%=officePhone%></td>
						<td nowrap="nowrap"><%=homePhone%></td>
						<td nowrap="nowrap"><%=email0%></td>
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
		["ѡ��",40],
		["����",80],	
		["�Ա�",60],
		["��λ��",160],
		["�ֻ�",80],
		["�����绰",80],
		["��ͥ�绰",100],	
		["�����ʼ�",]
		];
		initGrid(fields,"<%=rootPath%>/css/EvanGrid.css","<%=rootPath%>/images/evanGrid");
</script>