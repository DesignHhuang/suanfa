<%@ page contentType="application/vnd.ms-excel;charset=gbk" pageEncoding="gbk" language="java"%>
<%@page import="com.blisscloud.util.*"%>
<%@page import="java.util.*"%>
<%@page import="java.text.*"%>
<%
    String rootPath = request.getContextPath();
%>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
		<% 
			String startTime  		= 	request.getParameter("startTime");		//��ʼʱ��
			String endTime 	  		= 	request.getParameter("endTime");		//����ʱ��
			//###########begin############��������###########begin############
			String sql = "SELECT 												      "+
						 "		 bill.receiveid,                                      "+     
						 "       to_char(bill.receivetime,'yyyy-mm-dd hh24:mi:ss') as receivetime,"+
						 "       to_char(bill.endtime,'yyyy-mm-dd hh24:mi:ss') as endtime,    "+
						 "       dic2.TYPENAME   as dealstate,                        "+
						 "       bill.eventno,                                        "+
						 "       dic3.TYPENAME   as receivemethod,                    "+
						 
						 "       bill.EVENTTYPE   as eventtype,                       "+
						 
						 "       dic4.TYPENAME   as eventfrom,                        "+
						 "       dic1.TYPENAME   as calltype,                         "+
						 "       percus.strname   as IPCCCusname,                     "+
						 "       case when percus.ntitle = '1' then '����'            	  "+
						 "            when percus.ntitle = '2' then 'С��'               "+
						 "            when percus.ntitle = '3' then 'Ůʿ'               "+
						 "       end as IPCCCustSex,                                  "+
						 "       percus.strmobilephone   as IPCCCusTel,               "+
						 "       bill.contactname,                                    "+
						 "       bill.contacttel,                                     "+
						 
						 "       bill.CONTACTPERSONMEMO,                              "+
						 
						 "       bill.backupcontactname,                              "+
						 "       bill.backupcontacttel,                               "+
						 
						 "       bill.BACKUPPERSONMEMO,                               "+
						 
						 "       case when bill.isreserve = '1' then '��'             "+
						 "            when bill.isreserve = '2' then '��'             "+
						 "       end as isreserve,                                    "+
						 "       to_char(bill.reserveTime,'yyyy-mm-dd hh24:mi:ss') as reserveTime, "+
						 "       percus.strofficephone,                               "+
						 "       percus.strhomephone,                                 "+
						 "       percus.strmobilephone,                               "+
						 "       percus.strcorporation,                               "+
						 "       percus.straddress1,                                  "+
						 "       percus.strpostcode1,                                 "+
						 "       percus.straddress2,                                  "+
						 "       percus.strpostcode2,                                 "+
						 "       percus.stremail,                                     "+
						 "       bill.idnumber,                                       "+
						 "       bill.area,                                           "+
						 "       product.strname,                                     "+
						 
						 
						 "       product.strextend1,                                  "+
						 "       product.strextend2,                                  "+
						 "       product.strstandard,                                  "+
						 
						 
						 "       billproduct.productbatno,                            "+
						 "       billproduct.productlimittime,                        "+
						 "       product.strextend4,                                  "+
						 "       product.strmanufacturer,                             "+
						 
						 "       billproduct.avoidwrongno,                            "+
						 "       bill.interactionid,                                  "+
						 "       bill.eventmark,                                      "+
						 "       bill.contactmark,                                    "+
						 "       bill.tracemark,                                      "+
						 
						 "       bill.billMemo,                                       "+
						 
						 "       dic5.TYPENAME   as channel,                          "+
						 "       bill.customername,                                   "+
						 
						 "       case when bill.ISAUTHORIZATION  = '1' then '��'         "+
						 "       	  when bill.ISAUTHORIZATION  = '2' then '��'         "+
						 "       end as isauthorization,                              "+
						 
						 "       bill.businesspersonname,                             "+
						 "       bill.contacttelphone,                                "+
						 "       dic6.TYPENAME   as skinstate,                        "+
						 "       bill.usecycle,                                       "+
						 "       bill.usemethod,                                      "+
						 "       bill.symptommark,                                    "+
						 "       case when bill.isfirstuseproduct = 1 then '��'       "+
						 "            when bill.isfirstuseproduct = 2 then '��'       "+
						 "       end as isfirstuseproduct,                            "+
						 "       bill.beforeproduct,                                  "+
						 "       bill.othercontactresourse,                           "+
						 "       bill.illhistory,                                     "+
						 "       bill.age,                                            "+
						 "       bill.job,                                            "+
						 "       case when bill.canreceivetel = 1 then '��'           "+
						 "            when bill.canreceivetel = 2 then '��'           "+
						 "       end as canreceivetel,                                "+
						 "       bill.billsummarypath                                 "+
						 "  FROM tb_ips_bill as bill                                  "+
						 "  LEFT JOIN TB_IPS_DICTIONARY dic1                          "+
						 "       on bill.calltype = dic1.TYPEVALUE                    "+
						 "       and dic1.MAINTYPE = 'callType'                       "+
						 "  LEFT JOIN TB_IPS_DICTIONARY dic2                          "+
						 "       on bill.dealstate = dic2.TYPEVALUE                   "+
						 "       and dic2.MAINTYPE = 'dealState'                      "+
						 "  LEFT JOIN TB_IPS_DICTIONARY dic3                          "+
						 "       on bill.receivemethod = dic3.TYPEVALUE               "+
						 "       and dic3.MAINTYPE = 'receiveMethod'                  "+
						 "  LEFT JOIN TB_IPS_DICTIONARY dic4                          "+
						 "       on bill.eventfrom = dic4.TYPEVALUE                   "+
						 "       and dic4.MAINTYPE = 'eventFrom'                      "+
						 "  LEFT JOIN TB_IPS_DICTIONARY dic5                          "+
						 "       on bill.channel = dic5.TYPEVALUE                     "+
						 "       and dic5.MAINTYPE = 'channel'                        "+
						 "  LEFT JOIN TB_IPS_DICTIONARY dic6                          "+
						 "       on bill.skinstate = dic6.TYPEVALUE                   "+
						 "       and dic6.MAINTYPE = 'skinState'                      "+
						 "  LEFT JOIN tb000000personalcustomer percus                 "+
						 "	     on percus.lid=bill.customerid                        "+
						 "  LEFT JOIN tb_ips_bill_product billproduct                 "+
						 "	     on billproduct.billid=bill.eventno                   "+
						 "  LEFT JOIN tb000000product product                         "+
						 "	     on product.lid=billproduct.productid                 "+
				         "  WHERE 1=1 ";
			//��ʼʱ��
			if(!StringUtil.isNullOrEmpty(startTime))
			{
				sql += " and bill.receivetime >= to_timestamp('"+startTime+"','yyyy-mm-dd hh24:mi:ss') ";
			}
			//����ʱ��
			if(!StringUtil.isNullOrEmpty(endTime))
			{
				sql += " and bill.receivetime <= to_timestamp('"+endTime+"','yyyy-mm-dd hh24:mi:ss') ";
			}
			sql += " ORDER BY receivetime desc ";
			//System.out.println("sql--->"+sql);
			List billReportList = EZDbUtil.getStringArrayList(sql);
			//###########end############��������###########end############
		%>
	</head>

	<body leftmargin="0" topmargin="10" rightmargin="0" >
		<table  width="100%" border="1" cellspacing="1" cellpadding="2">
			<tr>
		    	<td nowrap="nowrap" align="center">�¼����</td>
		    	<td nowrap="nowrap" align="center">������</td>
				<td nowrap="nowrap" align="center">��������</td>
				<td nowrap="nowrap" align="center">�᰸����</td>
				<td nowrap="nowrap" align="center">����״̬</td>
				<td nowrap="nowrap" align="center">���շ�ʽ</td>
				
				<td nowrap="nowrap" align="center">��֪����</td>
				
				<td nowrap="nowrap" align="center">�¼���Դ</td>
				<td nowrap="nowrap" align="center">��������</td>
				<td nowrap="nowrap" align="center">����������</td>
				<td nowrap="nowrap" align="center">��ν</td>
				 
				<td nowrap="nowrap" align="center">��ϵ��(һ)</td>
				<td nowrap="nowrap" align="center">��ϵ�绰(һ)</td>
				
				<td nowrap="nowrap" align="center">��ϵ�˱�ע(һ)</td>
				
				<td nowrap="nowrap" align="center">��ϵ��(��)</td>
				<td nowrap="nowrap" align="center">��ϵ�绰(��)</td>
				
				<td nowrap="nowrap" align="center">��ϵ�˱�ע(��)</td>
				
				<td nowrap="nowrap" align="center">�Ƿ�ԤԼ</td>
				<td nowrap="nowrap" align="center">ԤԼʱ��</td>
				<td nowrap="nowrap" align="center">��˾�绰</td>
				<td nowrap="nowrap" align="center">��ͥ�绰</td>
				<td nowrap="nowrap" align="center">�ֻ�</td>
				<td nowrap="nowrap" align="center">��˾����</td>
				<td nowrap="nowrap" align="center">��˾��ַ</td>
				<td nowrap="nowrap" align="center">�ʱ�</td>
				<td nowrap="nowrap" align="center">��ͥ��ַ</td>
				<td nowrap="nowrap" align="center">�ʱ�</td>
				<td nowrap="nowrap" align="center">��������</td>
				<td nowrap="nowrap" align="center">���֤��</td>
				<td nowrap="nowrap" align="center">���ڵ���</td>
				<td nowrap="nowrap" align="center">��Ʒ����</td>
				
				<td nowrap="nowrap" align="center">Ʒ��</td>
				<td nowrap="nowrap" align="center">ϵ��</td>
				<td nowrap="nowrap" align="center">���</td>
				
				<td nowrap="nowrap" align="center">��������</td>
				<td nowrap="nowrap" align="center">��������</td>
				<td nowrap="nowrap" align="center">��Ʒ����</td>
				<td nowrap="nowrap" align="center">����</td>
				<td nowrap="nowrap" align="center">��������</td>
				<td nowrap="nowrap" align="center">������ϸ</td>
				<td nowrap="nowrap" align="center">�¼�����</td>
				<td nowrap="nowrap" align="center">��ͨ���</td>
				<td nowrap="nowrap" align="center">�������</td>
				
				<td nowrap="nowrap" align="center">������ע</td>
				
				<td nowrap="nowrap" align="center">����</td>
				<td nowrap="nowrap" align="center">�ͻ�����</td>
				
				<td nowrap="nowrap" align="center">�Ƿ���Ȩ</td>
				
				<td nowrap="nowrap" align="center">ҵ��Ա����</td>
				<td nowrap="nowrap" align="center">ҵ��Ա��ϵ�绰</td>
				<td nowrap="nowrap" align="center">Ƥ��״̬</td>
				<td nowrap="nowrap" align="center">ʹ������</td>
				<td nowrap="nowrap" align="center">ʹ�÷���</td>
				<td nowrap="nowrap" align="center">֢״����</td>
				<td nowrap="nowrap" align="center">�Ƿ��״�ʹ��</td>
				<td nowrap="nowrap" align="center">�����Ӵ�Դ</td>
				<td nowrap="nowrap" align="center">֮ǰʹ�ù���������ױƷ</td>
				<td nowrap="nowrap" align="center">��ʷ</td>
				<td nowrap="nowrap" align="center">����</td>
				<td nowrap="nowrap" align="center">ְҵ</td>
				<td nowrap="nowrap" align="center">Ը����ܵ绰����</td>
		  	</tr>
		  	<%
		  	if(billReportList!=null){
				for(int i=0;i<billReportList.size();i++){
					Object[] s =(Object[])billReportList.get(i);
					if(s!=null){
						String receiveid		=	String.valueOf(s[0]);
				        String receivetime		=	String.valueOf(s[1]);
				        String endtime			=	String.valueOf(s[2]);
				        String dealstate		=	String.valueOf(s[3]);
				        String eventno			=	String.valueOf(s[4]);
				        String receivemethod	=	String.valueOf(s[5]);
				        String eventtype        =   String.valueOf(s[6]);
				        String eventfrom		=	String.valueOf(s[7]);
				        String calltype			=	String.valueOf(s[8]);
				        String IPCCCustName		= 	String.valueOf(s[9]);
				        String IPCCCustSex		= 	String.valueOf(s[10]);
				        String IPCCCustTel		= 	String.valueOf(s[11]);
				        String contactname		=	String.valueOf(s[12]);
				        String contacttel		=	String.valueOf(s[13]);
				        String contactpersonmemo		=	String.valueOf(s[14]);
				        String backupcontactname=	String.valueOf(s[15]);
				        String backupcontacttel	=	String.valueOf(s[16]);
				        String backuppersonmemo	=	String.valueOf(s[17]);
				        String isreserve		=	String.valueOf(s[18]);
				        String reservetime      =   String.valueOf(s[19]);
				        String strofficephone	=	String.valueOf(s[20]);
				        String strhomephone		=	String.valueOf(s[21]); 
				        String strmobilephone	=	String.valueOf(s[22]);
				        String strcorporation	=	String.valueOf(s[23]);
				        String straddress1		=	String.valueOf(s[24]);
				        String strpostcode1		=	String.valueOf(s[25]);
				        String straddress2		=	String.valueOf(s[26]);
				        String strpostcode2		=	String.valueOf(s[27]);
				        String stremail			=	String.valueOf(s[28]);
				        String idnumber			=	String.valueOf(s[29]);
				        String area				=	String.valueOf(s[30]);
				        String productname		=	String.valueOf(s[31]);
				        String pinpai		    =	String.valueOf(s[32]);
				        String xilie		    =	String.valueOf(s[33]);
				        String guige		    =	String.valueOf(s[34]);
				        String prpductbatno		=	String.valueOf(s[35]);
				        String limittime		=	String.valueOf(s[36]);
				        String productbarcode	=	String.valueOf(s[37]);
				        String factory			=	String.valueOf(s[38]);
				        String preventfalseno	=	String.valueOf(s[39]);
				        Object interactionid	=	s[40];
				        String eventmark		=	String.valueOf(s[41]);
				        String contactmark		=	String.valueOf(s[42]);
				        String tracemark		=	String.valueOf(s[43]);
				        String billmemo		 	=	String.valueOf(s[44]);
				        String channel			=	String.valueOf(s[45]);
				        String customername		=	String.valueOf(s[46]);
				        String isauthorization		=	String.valueOf(s[47]);
				        String businesspersonname=	String.valueOf(s[48]);
				        String contacttelphone	=	String.valueOf(s[49]);
				        String skinstate		=	String.valueOf(s[50]);
				        String usecycle			=	String.valueOf(s[51]);
				        String usemethod		=	String.valueOf(s[52]);
				        String symptommark		=	String.valueOf(s[53]);
				        String isfirstuseproduct=	String.valueOf(s[54]);
				        String beforeproduct	=	String.valueOf(s[55]);
				        String othercontactresourse=String.valueOf(s[56]);
				        String illhistory		=	String.valueOf(s[57]);
				        String age				=	String.valueOf(s[58]);
				        String job				=	String.valueOf(s[59]);
				        String canreceivetel	=	String.valueOf(s[60]);
				        String billsummarypath  =	String.valueOf(s[61]);
				        
				        if(StringUtil.isNullOrEmpty(receiveid))receiveid="";
				        if(StringUtil.isNullOrEmpty(receivetime))receivetime="";
				        if(StringUtil.isNullOrEmpty(endtime) || "0001-01-01 00:00:00".equals(endtime))endtime="";
				        if(StringUtil.isNullOrEmpty(dealstate))dealstate="";
				        if(StringUtil.isNullOrEmpty(eventno))eventno="";
				        if(StringUtil.isNullOrEmpty(receivemethod))receivemethod="";
				        if(StringUtil.isNullOrEmpty(eventtype))eventtype="";      
				        if(StringUtil.isNullOrEmpty(eventfrom))eventfrom="";
				        if(StringUtil.isNullOrEmpty(calltype))calltype="";
				        if(StringUtil.isNullOrEmpty(IPCCCustName))IPCCCustName="";
				        if(StringUtil.isNullOrEmpty(IPCCCustSex))IPCCCustSex="";
				        if(StringUtil.isNullOrEmpty(IPCCCustTel))IPCCCustTel="";
				        if(StringUtil.isNullOrEmpty(contactname))contactname="";
				        if(StringUtil.isNullOrEmpty(contacttel))contacttel="";
				        if(StringUtil.isNullOrEmpty(contactpersonmemo))contactpersonmemo="";
				        if(StringUtil.isNullOrEmpty(backupcontactname))backupcontactname="";
				        if(StringUtil.isNullOrEmpty(backupcontacttel))backupcontacttel="";
				        if(StringUtil.isNullOrEmpty(backuppersonmemo))backuppersonmemo="";
				        if(StringUtil.isNullOrEmpty(isreserve))isreserve="";
				        if(StringUtil.isNullOrEmpty(reservetime) || "0001-01-01 00:00:00".equals(reservetime))reservetime="";
				        if(StringUtil.isNullOrEmpty(strofficephone))strofficephone="";
				        if(StringUtil.isNullOrEmpty(strhomephone))strhomephone="";
				        if(StringUtil.isNullOrEmpty(strmobilephone))strmobilephone="";
				        if(StringUtil.isNullOrEmpty(strcorporation))strcorporation="";
				        if(StringUtil.isNullOrEmpty(straddress1))straddress1="";
				        if(StringUtil.isNullOrEmpty(strpostcode1))strpostcode1="";
				        if(StringUtil.isNullOrEmpty(straddress2))straddress2="";
				        if(StringUtil.isNullOrEmpty(strpostcode2))strpostcode2="";
				        if(StringUtil.isNullOrEmpty(stremail))stremail="";
				        if(StringUtil.isNullOrEmpty(idnumber))idnumber="";
				        if(StringUtil.isNullOrEmpty(area))area="";
				        if(StringUtil.isNullOrEmpty(productname))productname="";
				        if(StringUtil.isNullOrEmpty(pinpai))pinpai="";
				        if(StringUtil.isNullOrEmpty(xilie))xilie="";
				        if(StringUtil.isNullOrEmpty(guige))guige="";
				        if(StringUtil.isNullOrEmpty(prpductbatno))prpductbatno="";
				        if(StringUtil.isNullOrEmpty(limittime) || "0001-01-01 00:00:00 BC".equals(limittime))limittime="";
				        if(StringUtil.isNullOrEmpty(productbarcode))productbarcode="";
				        if(StringUtil.isNullOrEmpty(factory))factory="";
				        if(StringUtil.isNullOrEmpty(preventfalseno))preventfalseno="";
				        if(StringUtil.isNullOrEmpty(eventmark))eventmark="";
				        if(StringUtil.isNullOrEmpty(contactmark))contactmark="";
				        if(StringUtil.isNullOrEmpty(tracemark))tracemark="";
				        if(StringUtil.isNullOrEmpty(billmemo))billmemo="";
				        if(StringUtil.isNullOrEmpty(channel))channel="";
				        if(StringUtil.isNullOrEmpty(customername))customername="";
				        if(StringUtil.isNullOrEmpty(isauthorization))isauthorization="";
				        if(StringUtil.isNullOrEmpty(businesspersonname))businesspersonname="";
				        if(StringUtil.isNullOrEmpty(contacttelphone))contacttelphone="";
				        if(StringUtil.isNullOrEmpty(skinstate))skinstate="";
				        if(StringUtil.isNullOrEmpty(usecycle))usecycle="";
				        if(StringUtil.isNullOrEmpty(usemethod))usemethod="";
				        if(StringUtil.isNullOrEmpty(symptommark))symptommark="";
				        if(StringUtil.isNullOrEmpty(isfirstuseproduct))isfirstuseproduct="";
				        if(StringUtil.isNullOrEmpty(beforeproduct))beforeproduct="";
				        if(StringUtil.isNullOrEmpty(othercontactresourse))othercontactresourse="";
				        if(StringUtil.isNullOrEmpty(illhistory))illhistory="";
				        if(StringUtil.isNullOrEmpty(age))age="";
				        if(StringUtil.isNullOrEmpty(job))job="";
				        if(StringUtil.isNullOrEmpty(canreceivetel))canreceivetel="";
						if(StringUtil.isNullOrEmpty(billsummarypath))billsummarypath="";
				        
				        
				        //�绰С��
				        String mySumPath = "";
				        mySumPath = billsummarypath;
				        //if(interactionid != null)mySumPath = EZDbUtil.getSumPath(interactionid);
			%>
					  	<tr>
		    				   <td><%=eventno              %></td>
		    				   <td><%
								    String qryAgentNameSQL = "select strname from tb000000employee where lid ="+receiveid;
									String agentName = EZDbUtil.getOnlyStringValue(qryAgentNameSQL );
											          		out.println(agentName);
									%>
								</td>            
						       <td style="vnd.ms-excel.numberformat:yyyy-mm-dd hh:mm:ss"><%=receivetime          %></td>     
						       <td style="vnd.ms-excel.numberformat:yyyy-mm-dd hh:mm:ss"><%=endtime              %></td>     
						       <td><%=dealstate            %></td>     
						       <td><%=receivemethod        %></td>  
						       
						       <td>
						         <%
					            	String eventTypeSQL =  "SELECT  typename "+
										            	   "FROM tb_ips_dictionary "+
										            	   "WHERE maintype='eventType' and isuse='1' and typevalue= '"+eventtype+"'";  
									String eventTypeName = EZDbUtil.getOnlyStringValue(eventTypeSQL ); 
					          		out.println(eventTypeName);
					              %>
						       </td>    
						       <td><%=eventfrom            %></td>     
						       <td><%=calltype             %></td> 
						       <td><%=IPCCCustName         %></td> 
						       <td><%=IPCCCustSex          %></td> 
						       
						       <td><%=contactname          %></td>     
						       <td><%=contacttel           %></td>  
						       
						       <td><%=contactpersonmemo    %></td>  
						             
						       <td><%=backupcontactname    %></td>     
						       <td><%=backupcontacttel     %></td>    
						       
						       <td><%=backuppersonmemo    %></td>  
						       
						        
						       <td><%=isreserve            %></td> 
						       <td style="vnd.ms-excel.numberformat:yyyy-mm-dd hh:mm:ss"><%=reservetime%></td> 
						       <td><%=strofficephone       %></td>     
						       <td style="vnd.ms-excel.numberformat:@"><%=strhomephone         %></td>     
						       <td><%=strmobilephone       %></td>     
						       <td><%=strcorporation       %></td>     
						       <td><%=straddress1          %></td>     
						       <td><%=strpostcode1         %></td>     
						       <td><%=straddress2          %></td>     
						       <td><%=strpostcode2         %></td>     
						       <td><%=stremail             %></td>     
						       <td><%=idnumber             %></td>     
						       <td><%=area                 %></td>     
						       <td><%=productname          %></td>  
						       
						       <td><%=pinpai        	   %></td> 
						       <td><%=xilie                %></td> 
						       <td><%=guige                %></td> 
						          
						       <td><%=prpductbatno         %></td>     
						       <td style="vnd.ms-excel.numberformat:yyyy-mm-dd hh:mm:ss"><%=limittime%></td>     
						       <td style="vnd.ms-excel.numberformat:@"><%=productbarcode%></td>     
						       <td><%=factory              %></td>     
						       <td><%=preventfalseno       %></td>     
						       <td><%=mySumPath            %></td>     
						       <td><%=eventmark            %></td>     
						       <td><%=contactmark          %></td>     
						       <td><%=tracemark            %></td> 
						       
						       <td><%=billmemo            %></td>
						           
						       <td><%=channel              %></td>     
						       <td><%=customername         %></td>  
						         
						        <td><%=isauthorization         %></td>
						        
						       <td><%=businesspersonname   %></td>     
						       <td><%=contacttelphone      %></td>     
						       <td><%=skinstate            %></td>     
						       <td><%=usecycle             %></td>     
						       <td><%=usemethod            %></td>     
						       <td><%=symptommark          %></td>     
						       <td><%=isfirstuseproduct    %></td>     
						       <td><%=beforeproduct        %></td>     
						       <td><%=othercontactresourse %></td>     
						       <td><%=illhistory           %></td>     
						       <td><%=age                  %></td>     
						       <td><%=job                  %></td>     
						       <td><%=canreceivetel        %></td>        
					  	</tr>
		  	<%}}}%>
		</table>
	</body>
</html>
