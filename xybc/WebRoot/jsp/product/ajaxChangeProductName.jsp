<%@ page language="java" pageEncoding="gbk"%>
<%@ page import="java.util.*" %>
<%@page import="com.blisscloud.util.StringUtil"%>
<%@page import="com.blisscloud.util.EZDbUtil"%>
<%
      	//1.��ȡproductId
      	String productId = request.getParameter("productId");
      	//System.out.println("222222--->"+productId);
      	if(StringUtil.isNullOrEmpty(productId))
      	{
      		out.println("-1");
      		return ;
      	}
      	//2.���ݻ�ȡ��productId,�õ���С��·��
      	String myProductName = EZDbUtil.getProductPathById(productId);
        //3.����ѯ����С��·����Ϣ���
       	String outVal = "";
        if(!StringUtil.isNullOrEmpty(myProductName))outVal = myProductName;
       	out.println(outVal);
       	//System.out.println(outVal);
%>