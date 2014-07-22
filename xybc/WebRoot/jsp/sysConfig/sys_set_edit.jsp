<%@ page contentType="text/html;charset=GBK"%>
<%@ page import="com.blisscloud.util.*" %>
<%@page import="java.util.*"%>
<%
    String rootPath = request.getContextPath();
%>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=GBK"/>
		<title>ϵͳ��������</title>
		<link href="<%=rootPath%>/css/style.css" type="text/css" rel="stylesheet" />
		<%
			//1����ȡ����
			String seq_id 		=   request.getParameter("seq_id");			//����ID
			String cn_name 		= 	request.getParameter("cn_name");		//����������
			String param_name 	= 	request.getParameter("param_name");		//������	
			String param_value	= 	request.getParameter("param_value");	//����ֵ
			String memo			= 	request.getParameter("memo");			//��ע
			String optType		=	request.getParameter("optType");		//��������
			String inputDisplay =   "block";
			String optionDisplay=   "none";
			List   camNameList  =   new ArrayList(); 
			//2�����˲���
			if(StringUtil.isNullOrEmpty(seq_id)) 	  seq_id="";
			if(StringUtil.isNullOrEmpty(cn_name)) 	  cn_name="";
			if(StringUtil.isNullOrEmpty(param_name))  param_name="";
			if(StringUtil.isNullOrEmpty(param_value)) param_value="";
			if(StringUtil.isNullOrEmpty(memo)) 		  memo="";
			if(StringUtil.isNullOrEmpty(optType)) 	  optType="add";
			//3�����²���
			if(!StringUtil.isNullOrEmpty(seq_id)&&"update".equals(optType)){
				String sql="select t.cn_name,t.param_value,t.memo,t.param_name from tb_ips_sys_set t where t.seqid="+seq_id;
				//System.out.println(sql);
				String[] s=EZDbUtil.getSingleArrayList(sql);
				if(s!=null){
				 cn_name=s[0];
				 param_value=s[1];
				 memo=s[2];
				 param_name=s[3];
				}
			}
			//param_name��ֵ
			if(!StringUtil.isNullOrEmpty(param_name) && 
					"autoOutbandIVR".equals(param_name))
			{
				inputDisplay =   "none";
				optionDisplay=   "block";
				
				String camNamListSQL = "SELECT appname ||','||applictionid||','||routingpoint as ivrinfo,appname "+
									   "FROM t_ivr_appliction "+
									   "ORDER BY  modifytime desc";
				camNameList = EZDbUtil.getStringArrayList(camNamListSQL);
			}
			
		%>
		<script language="javascript" type="text/javascript">
		function doit() {
		      var param_name=form1.param_name.value;
		      var cn_name=form1.cn_name.value;
		      if(param_name==""){
		        alert("Ӣ�ı�ʶ����Ϊ��");
		        return false;
		      }
		      
		      if(cn_name==""){
		        alert("�������Ʋ���Ϊ��");
		        return false;
		      }
			  document.form1.submit();
			  form1.optType.value="";
		}
		</script>
	</head>
<body topmargin="0">
<table width="100%" border="0">
	<tr><td>
	<TABLE align="center"  width="100%" border="0" cellpadding="2" cellspacing="1" bordercolor="#FFFFFF" class="lab2">
	  <form name="form1" method="post" action="<%=request.getContextPath()%>/jsp/sysConfig/sys_set.jsp"> 
	  <input type="hidden" name="optType" value="<%=optType%>"/> 
	  <input type="hidden" name="seq_id" value="<%=seq_id%>"/> 
	  <tr class="lab2">
	    <td align="center"  colspan="4">
	    	<div align="center" class="font2">
				ϵͳ��������
			</div>
	    </td>
	  </tr>
	  
	  <tr class="lab3">
	    <td align="right" nowrap="nowrap">�������ƣ�</td>
	    <td>
	    	<input type="text" name="cn_name" class="box01" size="30" value='<%=cn_name%>'/> 
	    </td>
	    <td align="right" nowrap="nowrap">Ӣ�ı�ʶ��</td>
		<td>
			<input type="text" name="param_name" class="box01" size="30"  
			<%if(!"add".equals(optType)){out.print("readonly=\"true\"");}%> 
			value='<%=param_name%>'/> 
		</td>
	  </tr>
	  
	  <tr class="lab3" style="display: <%=inputDisplay%>;">
	    <td align="right" nowrap="nowrap">��ֵ��</td>
	    <td class="tinttd" colspan="3">
	    	<input type="text" name="param_value" value='<%=param_value%>'/> 
	    </td>
	  </tr>
	  
	  <tr class="lab3" style="display: <%=optionDisplay%>;">
	    <td align="right" nowrap="nowrap">�ⲦIVR��</td>
	    <td colspan="3">
	    	<select name="param_value_camNameList">
	    		<%
	    			if(camNameList != null)
	    			{
	    				for(int i = 0 ;i < camNameList.size(); i++)
	    				{
	    					Object[] data =(Object[])camNameList.get(i);
							if(data != null)
							{
								String seqID 	 		= String.valueOf(data[0]);		//����ID
								String strName			= String.valueOf(data[1]);		//����
							
	    		%>
	    		<option value="<%=seqID%>" <%if(param_value.equals(seqID))out.println("selected=\"selected\"");%>><%=strName%></option>
	    		<%
							}
	    				}
	    			}
	    		%>
	    	</select> 
	    </td>
	  </tr>
	  
	   <tr class="lab3">
	    <td align="right" nowrap="nowrap">����ע�ͣ�</td>
	    <td class="tinttd" colspan="3"><textarea name="memo" rows="10" style="width:90%"><%=memo%></textarea></td>
	  </tr>
	   <tr class="lab3" height="17">
	    <td  align="center" colspan="4">
		<INPUT onclick="javascript:doit();" type="button" value="ȷ��" style="width: 80px">
		&nbsp;&nbsp;&nbsp;&nbsp;
		<INPUT onclick="javascript:window.history.back();" type="button" value="����" style="width: 80px">
	   </td>
	  </tr>
	  </form>
	</table>
	</td>
	</tr>
	</table>
</body>
</html>
