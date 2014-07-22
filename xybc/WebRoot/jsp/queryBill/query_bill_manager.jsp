<%@ page language="java" pageEncoding="GBK"%>
<%@page import="com.blisscloud.util.*"%>
<%@page import="java.util.*"%>
<%
    String rootPath 		= request.getContextPath();
	String agentID	    	= request.getParameter("agentID");		 //agentID
	String customerName 	= request.getParameter("customerName");  //customerName
	String contactPersonTel = request.getParameter("contactPersonTel");//contactPersonTel
	if(StringUtil.isNullOrEmpty(agentID)){
		agentID = "10000";
		}else{
			agentID=new String(agentID.getBytes("ISO-8859-1"),"UTF-8");
		String qryAgentNameSQL = "select lid from tb000000employee where strname ='"+agentID+"'";
		String agent = EZDbUtil.getOnlyStringValue(qryAgentNameSQL );
		if(agent!=null){
			agentID= agent;
		}
		
	}
	if(StringUtil.isNullOrEmpty(customerName))customerName = "";
if(customerName!=""){
		customerName=new String(customerName.getBytes("ISO-8859-1"),"UTF-8");
	}
	if(StringUtil.isNullOrEmpty(contactPersonTel))contactPersonTel = "";
	//out.println("agentID--->"+agentID);
	//out.println("customerName--->"+customerName);
	//out.println("contactPersonTel--->"+contactPersonTel);
	String myTextSize		 = "size=\"28\"";
%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=GBK"/>
	<title>������ѯ</title>
	<link href="<%=rootPath%>/css/chrome.css" rel="stylesheet" type="text/css">
	<script src="<%=rootPath%>/script/DateTime.js" type="text/javascript" type="text/javascript"></script>
	<script type="text/javascript"><%@include file="/script/DateTimeVariable.js"%></script>
	<script type="text/javascript">
		/* query bill*/
		function queryBill()
		{
			//if(dataCheck())
			//{
				//�ж��Ƿ�ѡ����ʾ�����˹���
				var val = form1.showOther.checked;
				if(val == true)
				{
					form1.showOtherVal.value = "0";
				}else
				{
					form1.showOtherVal.value = "1";
				}
				form1.action="query_bill_list.jsp";
	            form1.target = "jetonQueryBillFrame";
				form1.submit();
			//}
		}
	   /*Date check*/
	   function checkDateEarlier(strStart,strEnd)
		{
		    if (( strStart == "" ) || ( strEnd == "" ))
		        return true;
		    var arr1 = strStart.split("-");
		    var arr2 = strEnd.split("-");
		    //var date1 = new Date(arr1[0],parseInt(arr1[1].replace(/^0/,""),10) - 1,arr1[2]);
		    //var date2 = new Date(arr2[0],parseInt(arr2[1].replace(/^0/,""),10) - 1,arr2[2]);
		    if(arr1[1].length == 1)
		        arr1[1] = "0" + arr1[1];
		    if(arr1[2].length == 1)
		        arr1[2] = "0" + arr1[2];
		    if(arr2[1].length == 1)
		        arr2[1] = "0" + arr2[1];
		    if(arr2[2].length == 1)
		        arr2[2]="0" + arr2[2];
		    var d1 = arr1[0] + arr1[1] + arr1[2];
		    var d2 = arr2[0] + arr2[1] + arr2[2];
		    if(parseInt(d1,10) > parseInt(d2,10))
		       return false;
		    else
		       return true;
		}
		/*Data check*/
		function dataCheck()
		{
			var billNo 				= form1.billNo.value;			 //������
			var contactPersonName 	= form1.contactPersonName.value; //��ϵ������
			var contactPersonTel 	= form1.contactPersonTel.value;	 //��ϵ�˵绰
			//var dealState		 	= form1.dealState.value;		 //����״̬
			var startTime 			= form1.startTime.value;		 //��ʼʱ��
			var endTime 			= form1.endTime.value;			 //����ʱ��
			var businessPersonName	= form1.businessPersonName.value;//ҵ��Ա����
			var customerName		= form1.customerName.value;		 //�ͻ�����
			var receiveID			= form1.receiveID.value;		 //��Ϣ������
			if(checkDateEarlier(startTime,endTime) == false)
			{
				alert("����ʱ�䲻�����ڿ�ʼʱ��!");
				form1.endTime.focus();
				return false;
			}
			if((startTime==null||startTime==''||startTime=="")&&
			   (endTime==null||endTime==''||endTime=="")&&
			   (billNo==null||billNo==''||billNo=="")&&
			   (contactPersonName==null||contactPersonName==''||contactPersonName=="")&&
			   (contactPersonTel==null||contactPersonTel==''||contactPersonTel=="")&&
			   (businessPersonName==null||businessPersonName==''||businessPersonName=="")&&
			   (customerName==null||customerName==''||customerName=="")&&
			   (receiveID==null||receiveID==''||receiveID=="")
			  )
			{
				alert("����������һ����ѯ����!");
				return false;
			}
			return true;
		}
		/*reset Bill*/
		function resetBill()
		{
			form1.billNo.value = "";
			form1.startTime.value = "";
			form1.endTime.value = "";
			form1.reserveTime.value = "";
			document.getElementById("dealState").selectedIndex=0;
			document.getElementById("callType").selectedIndex=0;
			//���ԭ��ֵ
			form1.contactPersonTel.value = "";
			form1.contactPersonName.value = "";
			form1.customerName.value = "";
			form1.receiveID.value = "";
		}
		/*Change the option div*/
	    function changeDiv(divName)
	    {
			var myDivName = divName+"_div";
			if(myDivName == 'contactPersonName_div')
			{
				document.getElementById("contactPersonName_div").style.display ="block";
				document.getElementById("contactPersonTel_div").style.display ="none";
				document.getElementById("customerName_div").style.display ="none";
				document.getElementById("receiveID_div").style.display ="none";
				//���ԭ��ֵ
				form1.contactPersonTel.value = "";
				form1.customerName.value = "";
				form1.receiveID.value = "";
			}
			if(myDivName == 'contactPersonTel_div')
			{
				document.getElementById("contactPersonName_div").style.display ="none";
				document.getElementById("contactPersonTel_div").style.display ="block";
				document.getElementById("customerName_div").style.display ="none";
				document.getElementById("receiveID_div").style.display ="none";
				//���ԭ��ֵ
				form1.contactPersonName.value = "";
				form1.customerName.value = "";
				form1.receiveID.value = "";
			}
			if(myDivName == 'customerName_div')
			{
				document.getElementById("contactPersonName_div").style.display ="none";
				document.getElementById("contactPersonTel_div").style.display ="none";
				document.getElementById("customerName_div").style.display ="block";
				document.getElementById("receiveID_div").style.display ="none";
				//���ԭ��ֵ
				form1.contactPersonName.value = "";
				form1.contactPersonTel.value = "";
				form1.receiveID.value = "";
			}
			if(myDivName == 'receiveID_div')
			{
				document.getElementById("contactPersonName_div").style.display ="none";
				document.getElementById("contactPersonTel_div").style.display ="none";
				document.getElementById("customerName_div").style.display ="none";
				document.getElementById("receiveID_div").style.display ="block";
				//���ԭ��ֵ
				form1.contactPersonName.value = "";
				form1.contactPersonTel.value = "";
				form1.customerName.value = "";
			}
		}
	</script>
</head>
	<body topmargin="0" rightmargin="0" leftmargin="0" style="overflow: hidden;"> 
		<table width="100%" border="0">
			<tr>
				<td>
					<form name="form1" method="post" action="query_bill_list.jsp" target="jetonQueryBillFrame">
					<input name="agentID" type="hidden" value="<%=agentID%>"/>
					<input name="showOtherVal" type="hidden" value=""/>
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="opbg"> 
					  <tr>
						<td colspan="6">
							<table border="0" cellspacing="0" cellpadding="3" width="100%" class="opbg">
								<tr valign="top">
									<td align="left" valign="middle">
					           			<div id="Title">
					           				<img src='<%=rootPath%>/images/ipcc_icon_setup.gif' align='absmiddle' width='16' height='16' border='0'/>
					           				<strong class="titleMiddle">������ѯ</strong>
					           			</div>              			
					           		</td>
					           	</tr>
					        </table>
						</td>
					  </tr>
					  <tr>
					    <td align="right" nowrap="nowrap">�¼���ţ�</td>
					    <td><input name="billNo" type="text" class="box01" <%=myTextSize%>></td>
					    <td align="right" nowrap="nowrap">����״̬��</td>
					    <td>
						    <select name="dealState" id="dealState">
						      <option value="-1">ȫ��</option>
						      <%
				            	String dealStateSQL =  "SELECT typevalue, typename "+
									            	   "FROM tb_ips_dictionary "+
									            	   "WHERE maintype='dealState' and isuse='1' "+
									            	   "ORDER BY ordernum";   
				            	String  options=EZDmManager.getOptionsBySql(dealStateSQL,"");
				          		out.println(options);
				              %>
						    </select>    
					    </td>
					    <td align="right" nowrap="nowrap">ԤԼʱ�䣺</td>
						<td><input name="reserveTime" type="text" class="box01" value="" <%=myTextSize%> onFocus="ShowCalendar(1)"></td>
					  </tr>
					  <tr >
					    <td align="right" nowrap="nowrap">�������ͣ�</td>
					    <td>
						    <select name="callType" id="callType">
						      <option value="-1">ȫ��</option>
						      <%
				            	String callTypeSQL =  "SELECT typevalue, typename "+
									            	   "FROM tb_ips_dictionary "+
									            	   "WHERE maintype='callType' and isuse='1' "+
									            	   "ORDER BY ordernum";   
				            	String  callTypeOptions=EZDmManager.getOptionsBySql(callTypeSQL,"");
				          		out.println(callTypeOptions);
				              %>
						    </select>    
					    </td>
					    <td align="right" nowrap="nowrap">��ʼʱ�䣺</td>
						<td>
							<input name="startTime" type="text" class="box01" value="" <%=myTextSize%> onFocus="ShowCalendar(0)">
						</td>
					    <td align="right" nowrap="nowrap">����ʱ�䣺</td>
						<td>
							<input name="endTime" type="text" class="box01" value="" <%=myTextSize%> onFocus="ShowCalendar(0)">
						</td>
					  </tr>
					  <tr >
					    <td align="right" nowrap="nowrap">
						    <select name="callType" id="callType" onchange="changeDiv(this.value);">
						    	<option value="contactPersonName">��ϵ������</option>
						        <option value="contactPersonTel">��ϵ�˵绰</option>
						        <option value="customerName">������</option>
						        <option value="receiveID">������</option>
						    </select>  
					    </td>
					     <td>
						     <div style="display: block;" id="contactPersonName_div">
						     	<input name="contactPersonName" type="text" class="box01" <%=myTextSize%>>
						     </div> 
						     <div style="display: none;" id="contactPersonTel_div">
						     	<input name="contactPersonTel" type="text" class="box01"  <%=myTextSize%>>
						     </div>
						     <div style="display: none;" id="customerName_div">
						     	<input name="customerName" type="text" class="box01"  <%=myTextSize%>>
						     </div>
						     <div style="display: none;" id="receiveID_div">
						     	<input name="receiveID" type="text" class="box01" <%=myTextSize%>>
						     </div>
					    </td>					    <td colspan="4">
							<input type="checkbox" name="showOther" id="showOther" value="1" checked/>��ʾ�����˹���
						</td>
						<td colspan="6" align="right" nowrap="nowrap">
							 
							<input value="��ѯ" type="button" style="width:40px;"  onclick="queryBill();" class="button">
							 
							<input value="����" type="button" style="width:40px;" onclick="resetBill();" class="button">
							 
						</td>
					  </tr>
					  <tr height="30px">
					    
					  </tr>
					</table>
					</form>
				</td>
			</tr>
			<tr height="90%"> 
				<td>
					<iframe width="100%" height="100%" src="" 
						    name="jetonQueryBillFrame" scrolling="no" id="jetonQueryBillFrame"
							frameborder="0" border="0" framespacing="0">
					</iframe>
				</td>
			</tr>
		</table>
	</body>
</html>
<script language="javascript">
<%if(customerName!=""){%>
changeDiv('contactPersonName');
form1.contactPersonName.value = "<%=customerName%>";
				
<%}%>
<%if(contactPersonTel!=""){%>
changeDiv('contactPersonTel');
form1.contactPersonTel.value = <%=contactPersonTel%>;
<%}%>
queryBill();
</script>
