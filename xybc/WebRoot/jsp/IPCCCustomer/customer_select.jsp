<%@ page contentType="text/html;charset=GBK" %>
<%@page import="java.util.*"%>
<%@page import="com.blisscloud.util.*"%>
<%
    String rootPath = request.getContextPath();

	String myTextSize		 = "size=\"28\"";
%>
<html>
	<head>
		<title>客户选择</title>
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
	    						   username,
	    						   ntitle,age,
	    						   officePhone,
		                           homePhone,
		                           mobilePhone,city,idnumber)
	    {
			if(confirm("确定要选择该客户吗?"))
			{
				//alert("lid--->"+lid+"---IPCCCustomerINFO---"+IPCCCustomerINFO);
				this.opener.form1.customerID.value = lid;
				this.opener.form1.IPCCCustomerINFO.value = username;
				this.opener.form1.IPCCCustomerSEX.value = ntitle;
				this.opener.form1.IPCCCompTel.value = officePhone;
				this.opener.form1.IPCCHomeTel.value = homePhone;
				this.opener.form1.IPCCMobileTel.value = mobilePhone;
				this.opener.form1.area.value = city;
				this.opener.form1.age.value = age;
				this.opener.form1.IDNumber.value = idnumber;
				window.close();
			}
		}
		
		 setTimeout(function() {
	// IE
	if(document.all) {
		document.getElementById("clickMe").click();
	}
	// 其它浏览器
	else {
		var e = document.createEvent("MouseEvents");
		e.initEvent("click", true, true);
		document.getElementById("clickMe").dispatchEvent(e);
	}
}, 500);
		
		function load(lid,
	    						   username,
	    						   ntitle,age,
	    						   officePhone,
		                           homePhone,
		                           mobilePhone,city,idnumber)
		{
			if(this.opener.form1.IPCCCustomerINFO.value != "")
			{	
				this.opener.form1.IPCCCustomerINFO.value = username;
				this.opener.form1.IPCCCustomerSEX.value = ntitle;
				this.opener.form1.IPCCCompTel.value = officePhone;
				this.opener.form1.IPCCHomeTel.value = homePhone;
				this.opener.form1.IPCCMobileTel.value = mobilePhone;
				this.opener.form1.area.value = city;
				this.opener.form1.age.value = age;
				this.opener.form1.IDNumber.value = idnumber;
			}
		}
		</script>
	</head>
	<%
		String userName 	= request.getParameter("userName");		//姓名
		String campany 		= request.getParameter("campany");		//单位名
		String email  		= request.getParameter("email");		//电子邮件
		String phone  		= request.getParameter("phone");		//电话 
		String customerID  	= request.getParameter("customerID");	//customerID 
		String optFrom		= request.getParameter("optFrom");		//optFrom
		
		
		if(StringUtil.isNullOrEmpty(userName))userName="";
		if(StringUtil.isNullOrEmpty(campany))campany="";
		if(StringUtil.isNullOrEmpty(email))email="";
		if(StringUtil.isNullOrEmpty(phone))phone="";
		if(StringUtil.isNullOrEmpty(customerID))customerID="";
		
		String curpage			= request.getParameter("curpage");
		String flag				= request.getParameter("flag");
		//2、根据查询条件得到个人客户信息列表; 
		String sql="select lid, strid, strname, nsex,"+ 
   						   "strcorporation,strmobilephone, strofficephone, strhomephone,stremail,ntitle,strcity1,age,idnumber "+
   					   "from tb000000personalcustomer "+
					   "where nstate='1'  ";
		//姓名 对应EZIPCC字段strname
		if(!StringUtil.isNullOrEmpty(userName)){
			sql += " and strname like '%"+userName+"%'";
		}
		//单位名 对应EZIPCC字段strcorporation
		if(!StringUtil.isNullOrEmpty(campany)){
			sql += " and strcorporation like '%"+campany+"%'";
		}
		//电子邮件 对应EZIPCC字段email
		if(!StringUtil.isNullOrEmpty(email)){
			sql += " and stremail like '%"+email+"%'";
		}
		//电话 对应EZIPCC字段strmobilephone/strofficephone/strhomephone
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
	
	<body topmargin="0" style="overflow: hidden;" > 
		<form  name="form1"  method="post" action="customer_select.jsp">
		<input name="curpage" type="hidden" value="<%=curpage%>"/>
		<input name="customerID" type="hidden" value="<%=customerID%>"/>
		<table border="0" cellspacing="0" cellpadding="3" width="100%" class="opbg">
			<tr valign="top">
				<td align="left" valign="middle">
           			<div id="Title">
           				<img src='<%=rootPath%>/images/ipcc_icon_setup.gif' align='absmiddle' width='16' height='16' border='0'/>
           				<strong class="titleMiddle">消费者选择</strong>
           			</div>              			
           		</td>
           	</tr>
        </table>
		<table width="100%" border="0" cellspacing="0" cellpadding="0" class="opbg">
		  <tr>
		    <td align="right" nowrap="nowrap">姓名：</td>
		    <td><input name="userName" type="text" class="box01" value="<%=userName%>" <%=myTextSize%>></td>
		    <td align="right" nowrap="nowrap">单位名：</td>
		    <td><input name="campany" type="text" class="box01" value="<%=campany%>" <%=myTextSize%>></td>
		  </tr>
		  <tr>
		    <td align="right" nowrap="nowrap">电子邮件：</td>
		    <td><input name="email" type="text" class="box01" value="<%=email%>" <%=myTextSize%>></td>
		    <td align="right" nowrap="nowrap">电话：</td>
		    <td><input name="phone" type="text" class="box01" value="<%=phone%>" <%=myTextSize%>></td>
		  </tr>
		  <tr>
		    <td colspan="6" align="center" nowrap="nowrap" height="30px">
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<input value="查询" type="button" style="width:80px;"  onclick="queryCustomer();" class="button">
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<input value="重置" type="button" style="width:80px;" onclick="resetCustomer();" class="button">
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
						String username	 	=  	String.valueOf(s[2]);		//姓名
						//System.out.print(username);
						String sex		 	=  	String.valueOf(s[3]);		//性别
						String campany0  	=	String.valueOf(s[4]);		//单位名
						String mobilePhone 	=	String.valueOf(s[5]);		//手机
						String officePhone	=	String.valueOf(s[6]);		//工作电话
						String homePhone	=	String.valueOf(s[7]);		//家庭电话
						String email0	  	=	String.valueOf(s[8]);		//电子邮件
						String ntitle	  	=	String.valueOf(s[9]);		//称谓
						String city	  	=	String.valueOf(s[10]);		//城市
						String age = String.valueOf(s[11]);
						String idnumber = String.valueOf(s[12]);
						
						
						if(StringUtil.isNullOrEmpty(strid))strid="";
						if(StringUtil.isNullOrEmpty(username))username="";
						if("0".equals(sex)){sex="";}
						if("1".equals(sex)){sex="男";}
						if("2".equals(sex)){sex="女";}
						if(StringUtil.isNullOrEmpty(campany0))campany0="";
						if(StringUtil.isNullOrEmpty(mobilePhone))mobilePhone="";
						if(StringUtil.isNullOrEmpty(officePhone))officePhone="";
						if(StringUtil.isNullOrEmpty(homePhone))homePhone="";
						if(StringUtil.isNullOrEmpty(email0))email0="";
						if("0".equals(ntitle)){ntitle="";}
						if("1".equals(ntitle)){ntitle="先生";}
						if("2".equals(ntitle)){ntitle="小姐";}
						if("3".equals(ntitle)){ntitle="女士";}
						if(StringUtil.isNullOrEmpty(city))city="";
						if(StringUtil.isNullOrEmpty(age))age="";
						if(StringUtil.isNullOrEmpty(idnumber))idnumber="";
				%>  
					<TR >
					<tbody onload="load();"></tbody>
						<td align="center" nowrap="nowrap" id="0">
							<input name="myCheckCustomer" type="radio" value="<%=lid%>" 
								   onclick="setEZIPCCCustomer('<%=lid%>',
								                              '<%=username%>',
								                              '<%=ntitle%>',
								                              '<%=age%>',
								                              '<%=officePhone%>',
								                              '<%=homePhone%>',
								                              '<%=mobilePhone%>',
								                              '<%=city%>',								                          
								                              '<%=idnumber%>' 
								                              );"
								  <%if(lid.equals(customerID)){out.println("checked=\"checked\"");} %>> 
								  <a id="clickMe" onclick="load('<%=lid%>',
								                              '<%=username%>',
								                              '<%=ntitle%>',
								                              '<%=age%>',
								                              '<%=officePhone%>',
								                              '<%=homePhone%>',
								                              '<%=mobilePhone%>',
								                              '<%=city%>',								                          
								                              '<%=idnumber%>' );"></a>
				        </td>
				        
						<td nowrap="nowrap"><%=username%></td>
						<td nowrap="nowrap" align="center"><%=sex%></td>
						<td nowrap="nowrap"><%=campany0%></td>
						<td nowrap="nowrap" id="4"><%=mobilePhone%></td>
						<td nowrap="nowrap" id="2"><%=officePhone%></td>
						<td nowrap="nowrap" id="3"><%=homePhone%></td>
						<td nowrap="nowrap" id="3"><%=email0%></td>
						<td nowrap="nowrap"><%=age%></td>
						<td nowrap="nowrap"><%=idnumber%></td>
					</tr>
					<%}}}%>
					
		</tbody>
	 </table>
	 </div>
	 
	   <!-- 页面翻页  -->
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
		["选择",40],
		["姓名",80],	
		["性别",60],
		["单位名",160],
		["手机",80],
		["工作电话",80],
		["家庭电话",100],	
		["电子邮件",100],
		["年龄",100],
		["身份证号",]
		];
		initGrid(fields,"<%=rootPath%>/css/EvanGrid.css","<%=rootPath%>/images/evanGrid");
</script>