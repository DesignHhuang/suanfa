<%@ page language="java" pageEncoding="gbk"%>
<%@ page import="java.util.*" %>
<%@page import="com.blisscloud.util.StringUtil"%>
<%@page import="com.blisscloud.util.EZDbUtil"%>
<%
      	//1.��ȡsummaryId
      	String summaryId = request.getParameter("summaryId");
      	//System.out.println("222222--->"+summaryId);
      	if(StringUtil.isNullOrEmpty(summaryId))
      	{
      		out.println("-1");
      		return ;
      	}
      	//2.���ݻ�ȡ��summaryId,�õ���С��·��
      	String mySummPath = EZDbUtil.getSumPathById(summaryId);
        //3.����ѯ����С��·����Ϣ���
       	String outVal = "";
        if(!StringUtil.isNullOrEmpty(mySummPath))outVal = mySummPath;
       	out.println(outVal);
       	//System.out.println(outVal);
%>