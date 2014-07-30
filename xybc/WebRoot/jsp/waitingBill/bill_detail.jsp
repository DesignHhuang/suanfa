<%@ page contentType="text/html;charset=GBK"%>
<%@page import="com.blisscloud.hibernate.*"%>
<%@page import="com.blisscloud.util.*"%>
<%@page import="com.blisscloud.dao.*"%>
<%@page import="java.util.*"%>
<%
    String rootPath = request.getContextPath();
	String okButDisplay = "";
	//1.get request parameter
	String optType	 	 	 = request.getParameter("optType");		//optType
	String optID 	  	  	 = request.getParameter("optID");		//optID
	String eventType		 = request.getParameter("eventType");	//eventType---事件类型
	String agentID		 	 = request.getParameter("agentID");		//agentID---信息接收人
	String agentName = "";
	if(!StringUtil.isNullOrEmpty(optType) &&
			"addNewBill".equals(optType) 
		  )
	{
		String qryAgentNameSQL = "select strname from tb000000employee where lid ="+agentID;
		agentName = EZDbUtil.getOnlyStringValue(qryAgentNameSQL );
		if(agentName==null){
			agentName= agentID;
		}
	}
	
	String receiveTime   	 = request.getParameter("receiveTime");	//receiveTime---收到时间
	String endTime		  	 = request.getParameter("endTime");		//endTime---结案时间
	String dealState	  	 = request.getParameter("dealState");	//dealState---处理状态
	String eventNo		  	 = request.getParameter("eventNo");		//eventNo---事件编号
	String receiveMethod 	 = request.getParameter("receiveMethod");//receiveMethod---接收方式
	String localarea         = request.getParameter("localarea");
	String eventFrom		 = request.getParameter("eventFrom");	 //eventFrom---来源
	String callType		  	 = request.getParameter("callType");	 //callType---呼叫类型
	String contactName	 	 = request.getParameter("contactName");	 //contactName---联系人姓名
	String contactTel	 	 = request.getParameter("contactTel");	 //contactTel---联系人电话
	String backupContactName = request.getParameter("backupContactName");//backupContactName---备用联系人
	String backupContactTel	 = request.getParameter("backupContactTel");//backupContactTel---备用联系人电话
	String isReserve		 = request.getParameter("isReserve");		//isReserve----是否预约
	String reserveTime		 = request.getParameter("reserveTime");		//reserveTime---预约时间
	String IDNumber			 = request.getParameter("IDNumber");		//IDNumber---身份证号
	String area				 = request.getParameter("area");			//area---所在地区
	String productName		 = request.getParameter("productName");		//productName---产品名称
	String productBathNo	 = request.getParameter("productBathNo");	//productBathNo---生产批号
	String limitTime		 = request.getParameter("limitTime");		//limitTime---限用日期
	String productBarcode	 = request.getParameter("productBarcode");	//productBarcode---商品条码
	String preventFalseNo	 = request.getParameter("preventFalseNo");	//preventFalseNo---防串货码
	String factory			 = request.getParameter("factory");			//factory---工厂
	String eventMark		 = request.getParameter("eventMark");		//eventMark---事件描述
	String contactMark		 = request.getParameter("contactMark");		//contactMark---沟通情况
	String traceMark		 = request.getParameter("traceMark");		//traceMark---跟踪情况
	String channel			 = request.getParameter("channel");			//channel---渠道
	String isAuthorization	 = request.getParameter("isAuthorization");	//是否授权
	String customerName		 = request.getParameter("customerName");	//customerName---客户名称
	String businessPersonName= request.getParameter("businessPersonName");//businessPersonName---业务员名称
	String contactTelphone	 = request.getParameter("contactTelphone");	  //contactTelphone---业务员联系电话
	String skinState		 = request.getParameter("skinState");		  //skinState---皮肤状态
	String useCycle			 = request.getParameter("useCycle");		  //useCycle---使用周期
	String useMethod		 = request.getParameter("useMethod");		  //useMethod---使用方法
	String symptomMark		 = request.getParameter("symptomMark");		  //symptomMark---症状描述
	String isFirstUseProduct = request.getParameter("isFirstUseProduct"); //isFirstUseProduct---是否首次使用产品
	String otherContactResourse= request.getParameter("otherContactResourse");//otherContactResourse---其他接触源
	String beforeProduct	 = request.getParameter("beforeProduct");		//beforeProduct---使用过的其他化妆品
	String illHistory		 = request.getParameter("illHistory");			//illHistory---病史
	String age				 = request.getParameter("age");					//age---年龄
	String job				 = request.getParameter("job");					//job---职业
	String canRecieveTel	 = request.getParameter("canRecieveTel");		//canRecieveTel---是否愿意接受电话访问
	String productID		 = request.getParameter("productID");			//productID---产品ID
	String interactionID	 = request.getParameter("interactionID");		//interactionID---interactionID
	String customerID		 = request.getParameter("customerID");			//customerID---customerID
	String jetonInteractionID= request.getParameter("jetonInteractionID");	//jetonInteractionID
	String summaryID		 = request.getParameter("summaryID");			//summaryID
	String billSummaryPath	 = request.getParameter("billSummaryPath");		//电话小结路径
	String IPCCCustomerINFO	 = request.getParameter("IPCCCustomerINFO");	//IPCCCustomerINFO
	String contactPersonSex	 = request.getParameter("contactPersonSex");	//联系人称谓
	String contactPersonMemo = request.getParameter("contactPersonMemo");	//联系人备注
	String backupPersonSex	 = request.getParameter("backupPersonSex");		//备用联系人称谓
	String backupPersonMemo	 = request.getParameter("backupPersonMemo");	//备用联系人备注
	String billMemo			 = request.getParameter("billMemo");			//工单备注
	
	
	
	boolean endTimeFlag 	 = false;	//结案时间标记
	boolean reserveTimeFlag  = false;	//预约时间标记
	boolean limitTimeFlag	 = false;	//限用日期标记
	boolean ageFlag			 = false;	//年龄标记
	String mustField         = "<font color=\"#FF0000\">*</font>";
	String myTextSize		 ="size=\"20\"";
	
	if(StringUtil.isNullOrEmpty(optID))optID = "";
	if(StringUtil.isNullOrEmpty(agentID))agentID = "10000";
	if(StringUtil.isNullOrEmpty(receiveTime))receiveTime = "";
	if(StringUtil.isNullOrEmpty(endTime))endTime = "";
	if(!StringUtil.isNullOrEmpty(endTime))endTimeFlag = true;
	if(StringUtil.isNullOrEmpty(dealState))dealState = "";
	if(StringUtil.isNullOrEmpty(eventNo))eventNo = "";
	if(StringUtil.isNullOrEmpty(receiveMethod))receiveMethod = "";
	if(StringUtil.isNullOrEmpty(localarea))localarea = "";
	if(StringUtil.isNullOrEmpty(contactName))contactName = "";
	if(StringUtil.isNullOrEmpty(contactTel))contactTel = "";
	if(StringUtil.isNullOrEmpty(backupContactName))backupContactName = "";
	if(StringUtil.isNullOrEmpty(backupContactTel))backupContactTel = "";
	if(StringUtil.isNullOrEmpty(isReserve))isReserve = "2";
	if(StringUtil.isNullOrEmpty(reserveTime))reserveTime = "";
	if(!StringUtil.isNullOrEmpty(reserveTime))reserveTimeFlag = true;
	if(StringUtil.isNullOrEmpty(IDNumber))IDNumber = "";
	if(StringUtil.isNullOrEmpty(area))area = "";
	if(StringUtil.isNullOrEmpty(productName))productName = "";
	if(StringUtil.isNullOrEmpty(productBathNo))productBathNo = "";
	if(StringUtil.isNullOrEmpty(limitTime))limitTime = "";
	if(!StringUtil.isNullOrEmpty(limitTime))limitTimeFlag = true;
	if(StringUtil.isNullOrEmpty(productBarcode))productBarcode = "";
	if(StringUtil.isNullOrEmpty(preventFalseNo))preventFalseNo = "";
	if(StringUtil.isNullOrEmpty(factory))factory = "";
	if(StringUtil.isNullOrEmpty(eventMark))eventMark = "";
	if(StringUtil.isNullOrEmpty(contactMark))contactMark = "";
	if(StringUtil.isNullOrEmpty(traceMark))traceMark = "";
	if(StringUtil.isNullOrEmpty(channel))channel = "";
	if(StringUtil.isNullOrEmpty(customerName))customerName = "";
	if(StringUtil.isNullOrEmpty(businessPersonName))businessPersonName = "";
	if(StringUtil.isNullOrEmpty(contactTelphone))contactTelphone = "";
	if(StringUtil.isNullOrEmpty(skinState))skinState = "";
	if(StringUtil.isNullOrEmpty(useCycle))useCycle = "";
	if(StringUtil.isNullOrEmpty(useMethod))useMethod = "";
	if(StringUtil.isNullOrEmpty(symptomMark))symptomMark = "";
	if(StringUtil.isNullOrEmpty(isFirstUseProduct))isFirstUseProduct = "1";
	if(StringUtil.isNullOrEmpty(otherContactResourse))otherContactResourse = "";
	if(StringUtil.isNullOrEmpty(beforeProduct))beforeProduct = "";
	if(StringUtil.isNullOrEmpty(illHistory))illHistory = "";
	if(StringUtil.isNullOrEmpty(age))age = "";
	if(!StringUtil.isNullOrEmpty(age))ageFlag = true;
	if(StringUtil.isNullOrEmpty(job))job = "";
	if(StringUtil.isNullOrEmpty(canRecieveTel))canRecieveTel = "2";
	if(StringUtil.isNullOrEmpty(productID))productID = "-1";
	if(StringUtil.isNullOrEmpty(interactionID))interactionID = "8888888888";
	if(StringUtil.isNullOrEmpty(customerID))customerID = "-1";
	if(StringUtil.isNullOrEmpty(jetonInteractionID))jetonInteractionID = "";
	if(StringUtil.isNullOrEmpty(summaryID))summaryID = "-1";
	if(StringUtil.isNullOrEmpty(billSummaryPath))billSummaryPath = "";
	if(StringUtil.isNullOrEmpty(IPCCCustomerINFO))IPCCCustomerINFO = "";
	if(StringUtil.isNullOrEmpty(contactPersonSex))contactPersonSex = "";
	if(StringUtil.isNullOrEmpty(contactPersonMemo))contactPersonMemo = "";
	if(StringUtil.isNullOrEmpty(backupPersonSex))backupPersonSex = "";
	if(StringUtil.isNullOrEmpty(backupPersonMemo))backupPersonMemo = "";
	if(StringUtil.isNullOrEmpty(isAuthorization))isAuthorization = "";
	if(StringUtil.isNullOrEmpty(billMemo))billMemo = "";
	
	
	
	//to add new bill
	if(!StringUtil.isNullOrEmpty(optType) &&
			"toAddNewBill".equals(optType) )
	{
		String myNewBillID = EZDbUtil.getLastNumBySeqName("SEQ_TB_IPS_BILL");
		String addNewBillSQL = "INSERT INTO TB_IPS_BILL( "+
														"SEQID               ,"+
														"EVENTTYPE           ,"+
														"RECEIVEID           ,"+
														"RECEIVETIME         ,";
														if(endTimeFlag)
														{
															addNewBillSQL += "ENDTIME,";
														}
														addNewBillSQL +=
														"DEALSTATE           ,"+
														"EVENTNO             ,"+
														"RECEIVEMETHOD       ,"+
														"LOCALAREA       ,"+
														"EVENTFROM           ,"+
														"CALLTYPE            ,"+
														"CONTACTNAME         ,"+
														"CONTACTTEL          ,"+
														"BACKUPCONTACTNAME   ,"+
														"BACKUPCONTACTTEL    ,"+
														"ISRESERVE           ,";
														if(reserveTimeFlag)
														{
															addNewBillSQL += "RESERVETIME,";
														}
														addNewBillSQL +=
														"IDNUMBER            ,"+
														"AREA                ,"+
														"PRODUCTNAME         ,"+
														"PRPDUCTBATNO        ,";
														if(limitTimeFlag)
														{
															addNewBillSQL += "LIMITTIME,";
														}
														addNewBillSQL +=
														"PRODUCTBARCODE      ,"+
														"FACTORY             ,"+
														"PREVENTFALSENO      ,"+
														"EVENTMARK           ,"+
														"CONTACTMARK         ,"+
														"TRACEMARK           ,"+
														"CHANNEL             ,"+
														"CUSTOMERNAME        ,"+
														"BUSINESSPERSONNAME  ,"+
														"CONTACTTELPHONE     ,"+
														"SKINSTATE           ,"+
														"USECYCLE            ,"+
														"USEMETHOD           ,"+
														"SYMPTOMMARK         ,"+
														"ISFIRSTUSEPRODUCT   ,"+
														"BEFOREPRODUCT       ,"+
														"OTHERCONTACTRESOURSE,"+
														"ILLHISTORY          ,";
														if(ageFlag)
														{
															addNewBillSQL += "AGE,";
														}
														addNewBillSQL +=
														"JOB                 ,"+
														"CANRECEIVETEL       ,"+
														"AGENTID             ,"+
														"PRODUCTID           ,"+
														"INTERACTIONID       ,"+ 
														"CUSTOMERID          ,"+
														"SUMMARYID           ,"+
														"BILLSUMMARYPATH     ,"+
														"IPCCCUSTOMERINFO    ,"+
														"CONTACTPERSONSEX    ,"+
														"CONTACTPERSONMEMO   ,"+
														"BACKUPPERSONSEX     ,"+
														"ISAUTHORIZATION     ,"+
														"BILLMEMO            ,"+
														"BACKUPPERSONMEMO     "+
													") "+
					"VALUES( "+
										    "'"+myNewBillID	      	  +"',"+ 
										    "'"+eventType	      	  +"',"+
										    "'"+agentID		      	  +"',"+ 
											"to_timestamp('"+receiveTime+"','yyyy-mm-dd hh24:mi:ss')::timestamp without time zone,";
											if(endTimeFlag)
											{
												addNewBillSQL += "to_timestamp('"+endTime+"','yyyy-mm-dd hh24:mi:ss')::timestamp without time zone,";
											}
											addNewBillSQL +=
											"'"+dealState	  	      +"',"+
											"'"+eventNo		  	      +"',"+
											"'"+receiveMethod 	      +"',"+
											"'"+localarea 	      +"',"+
											"'"+eventFrom		      +"',"+
											"'"+callType		  	  +"',"+
											"'"+contactName	 	      +"',"+
											"'"+contactTel	 	      +"',"+
											"'"+backupContactName     +"',"+
											"'"+backupContactTel	  +"',"+
											"'"+isReserve		      +"',";
											if(reserveTimeFlag)
											{
												addNewBillSQL += "to_timestamp('"+reserveTime+"','yyyy-mm-dd hh24:mi:ss')::timestamp without time zone,";
											}
											addNewBillSQL +=
											"'"+IDNumber			  +"',"+
											"'"+area				  +"',"+
											"'"+productName		      +"',"+
											"'"+productBathNo	      +"',";
											if(limitTimeFlag)
											{
												addNewBillSQL += "to_timestamp('"+limitTime+"','yyyy-mm-dd hh24:mi:ss')::timestamp without time zone,";
											}
											addNewBillSQL +=
											"'"+productBarcode	      +"',"+
											"'"+preventFalseNo	      +"',"+
											"'"+factory			      +"',"+
											"'"+eventMark		      +"',"+
											"'"+contactMark		      +"',"+
											"'"+traceMark		      +"',"+
											"'"+channel			      +"',"+
											"'"+customerName		  +"',"+
											"'"+businessPersonName    +"',"+
											"'"+contactTelphone	      +"',"+
											"'"+skinState		      +"',"+
											"'"+useCycle			  +"',"+
											"'"+useMethod		      +"',"+
											"'"+symptomMark		      +"',"+
											"'"+isFirstUseProduct     +"',"+
											"'"+otherContactResourse  +"',"+
											"'"+beforeProduct	      +"',"+
											"'"+illHistory		      +"',";
											if(ageFlag)
											{
												addNewBillSQL += "'"+age+"',";
											}
											addNewBillSQL +=
											"'"+job				      +"',"+
											"'"+canRecieveTel	      +"',"+
											"'"+agentID		      	  +"',"+
											"'"+productID	      	  +"',"+
											"'"+interactionID      	  +"',"+  
											"'"+customerID      	  +"',"+
											"'"+summaryID        	  +"',"+
											"'"+billSummaryPath    	  +"',"+
											"'"+IPCCCustomerINFO   	  +"',"+
											"'"+contactPersonSex   	  +"',"+
											"'"+contactPersonMemo  	  +"',"+
											"'"+backupPersonSex   	  +"',"+
											"'"+isAuthorization   	  +"',"+
											"'"+billMemo        	  +"',"+
											"'"+backupPersonMemo   	  +"'"+
						   " )";
		//out.println("addNewBillSQL----->"+addNewBillSQL);
		//若保存成功则操作类型为toUpdateBill
		boolean okFlag = EZDbUtil.runSql(addNewBillSQL);
		if(okFlag)
		{
			optID = myNewBillID;
			optType = "toUpdateBill";
		}
	}
	//add new bill   
	if(!StringUtil.isNullOrEmpty(optType) &&
			"addNewBill".equals(optType) 
		  )
	{
		receiveTime = StringTools.DateToString(new Date());	        //收到时间
		eventNo     = StringTools.getTimeSequeue()+"_"+agentID;		//事件编号  时间序列_当前坐席ID
		optType     = "toAddNewBill";
	}
	//to update bill
	if(!StringUtil.isNullOrEmpty(optType) &&
	   		"toUpdateBill".equals(optType) &&
	   		!StringUtil.isNullOrEmpty(optID)
		  )
	{
		String toUpdateBillSQL = "UPDATE TB_IPS_BILL SET "+
									"ENDTIME             =to_timestamp('"+endTime+"','yyyy-mm-dd hh24:mi:ss')::timestamp without time zone,"+
									"EVENTTYPE           ='"+eventType			   +"',"+
									"DEALSTATE           ='"+dealState			   +"',"+                     																																																																																																																									
									"RECEIVEMETHOD       ='"+receiveMethod 		   +"',"+    
									"LOCALAREA       ='"+localarea 		   +"',"+                    																																																																																																																									
									"EVENTFROM           ='"+eventFrom			   +"',"+                     																																																																																																		
									"CALLTYPE            ='"+callType			   +"',"+                     																																																																																																		
									"CONTACTNAME         ='"+contactName	 	   +"',"+                     																																																																																																																											
									"CONTACTTEL          ='"+contactTel	 		   +"',"+                     																																																																																																																											
									"BACKUPCONTACTNAME   ='"+backupContactName	   +"',"+                     																																																																																																																											
									"BACKUPCONTACTTEL    ='"+backupContactTel	   +"',"+                     																																																																																																																											
									"ISRESERVE           ='"+isReserve			   +"',"+                     																																																																																																																											
									"RESERVETIME         =to_timestamp('"+reserveTime+"','yyyy-mm-dd hh24:mi:ss')::timestamp without time zone,"+                     																																																																																																																											
									"IDNUMBER            ='"+IDNumber			   +"',"+                     																																																																																																																											
									"AREA                ='"+area				   +"',"+                     																																																																																																																											
									"PRODUCTNAME         ='"+productName		   +"',"+                     																																																																																																																											
									"PRPDUCTBATNO        ='"+productBathNo	       +"',"+                     																																																																																																																											
									"LIMITTIME           =to_timestamp('"+limitTime+"','yyyy-mm-dd hh24:mi:ss')::timestamp without time zone,"+                     																																																																																																																											
									"PRODUCTBARCODE      ='"+productBarcode	       +"',"+                     																																																																																																																											
									"FACTORY             ='"+preventFalseNo	       +"',"+                     																																																																																																																											
									"PREVENTFALSENO      ='"+factory			   +"',"+                     																																																																																																																																													
									"EVENTMARK           ='"+eventMark		       +"',"+                     																																																																																																																																													
									"CONTACTMARK         ='"+contactMark		   +"',"+                     																																																																																																																																													
									"TRACEMARK           ='"+traceMark		       +"',"+                     																																																																																																																																																															
									"CHANNEL             ='"+channel			   +"',"+                     																																																																																																																																																															
									"CUSTOMERNAME        ='"+customerName		   +"',"+                     																																																																																																																																																															
									"BUSINESSPERSONNAME  ='"+businessPersonName    +"',"+                     																																																																																																																																																															
									"CONTACTTELPHONE     ='"+contactTelphone	   +"',"+                     																																																																																																																																																																																	
									"SKINSTATE           ='"+skinState		       +"',"+                     																																																																																																																																																																																	
									"USECYCLE            ='"+useCycle			   +"',"+                     																																																																																																																																																																																	
									"USEMETHOD           ='"+useMethod		       +"',"+                     																																																																																																																																																																																	
									"SYMPTOMMARK         ='"+symptomMark		   +"',"+                     																																																																																																																																																																																																			
									"ISFIRSTUSEPRODUCT   ='"+isFirstUseProduct     +"',"+                     																																																																																																																																																																																																			
									"BEFOREPRODUCT       ='"+otherContactResourse  +"',"+                     																																																																																																																																																																																																			
									"OTHERCONTACTRESOURSE='"+beforeProduct	       +"',"+                     																																																																																																																																																																																																																					
									"ILLHISTORY          ='"+illHistory		       +"',";
									if(ageFlag)
									{
										toUpdateBillSQL += "AGE='"+age+"',";
									}
									toUpdateBillSQL +=
									"JOB                 ='"+job				   +"',"+                     																																																																																																																																																																																																																					
									"CANRECEIVETEL       ='"+canRecieveTel	       +"',"+
									"SUMMARYID           ='"+summaryID  	       +"',"+
									"CUSTOMERID          ='"+customerID  	       +"',"+
									"BILLSUMMARYPATH     ='"+billSummaryPath       +"',"+
									"IPCCCUSTOMERINFO    ='"+IPCCCustomerINFO      +"',"+
									"CONTACTPERSONSEX    ='"+contactPersonSex      +"',"+
									"CONTACTPERSONMEMO   ='"+contactPersonMemo     +"',"+
									"BACKUPPERSONSEX     ='"+backupPersonSex       +"',"+
									"ISAUTHORIZATION     ='"+isAuthorization       +"',"+
									"BILLMEMO            ='"+billMemo              +"',"+
									"BACKUPPERSONMEMO    ='"+backupPersonMemo      +"'"+
								 " WHERE SEQID='"+optID+"'";
		//out.println("toUpdateBillSQL--->"+toUpdateBillSQL);
		boolean toUptFlag = EZDbUtil.runSql(toUpdateBillSQL);
		if(toUptFlag)
		{
			out.println("<script language=\"javascript\" type=\"text/javascript\">");
			out.println("window.alert('保存成功!');");
			//out.println("window.close();");
			out.println("</script>");
		}
		if(toUptFlag)optType = "updateBill";
	}
	//update bill
	if(!StringUtil.isNullOrEmpty(optType) &&
	   		"updateBill".equals(optType) &&
	   		!StringUtil.isNullOrEmpty(optID)
		  )
	{
		String uptBillSQL = "SELECT "+
								"RECEIVEID           ,"+   
								"to_char(RECEIVETIME,'yyyy-mm-dd hh24:mi:ss') as RECEIVETIME,"+   
								"to_char(ENDTIME,'yyyy-mm-dd hh24:mi:ss') as ENDTIME,"+   
								"DEALSTATE           ,"+   
								"EVENTNO             ,"+   
								"RECEIVEMETHOD       ,"+   
								"LOCALAREA       ,"+  
								"EVENTFROM           ,"+   
								"CALLTYPE            ,"+   
								"CONTACTNAME         ,"+   
								"CONTACTTEL          ,"+   
								"BACKUPCONTACTNAME   ,"+   
								"BACKUPCONTACTTEL    ,"+   
								"ISRESERVE           ,"+   
								"to_char(RESERVETIME,'yyyy-mm-dd hh24:mi:ss') as RESERVETIME,"+   
								"IDNUMBER            ,"+   
								"AREA                ,"+   
								"PRODUCTNAME         ,"+   
								"PRPDUCTBATNO        ,"+   
								"to_char(LIMITTIME,'yyyy-mm-dd hh24:mi:ss') as LIMITTIME,"+   
								"PRODUCTBARCODE      ,"+   
								"FACTORY             ,"+   
								"PREVENTFALSENO      ,"+   
								"EVENTMARK           ,"+   
								"CONTACTMARK         ,"+   
								"TRACEMARK           ,"+   
								"CHANNEL             ,"+   
								"CUSTOMERNAME        ,"+   
								"BUSINESSPERSONNAME  ,"+   
								"CONTACTTELPHONE     ,"+   
								"SKINSTATE           ,"+   
								"USECYCLE            ,"+   
								"USEMETHOD           ,"+   
								"SYMPTOMMARK         ,"+   
								"ISFIRSTUSEPRODUCT   ,"+   
								"BEFOREPRODUCT       ,"+   
								"OTHERCONTACTRESOURSE,"+   
								"ILLHISTORY          ,"+   
								"AGE                 ,"+   
								"JOB                 ,"+   
								"CANRECEIVETEL       ,"+   
								"AGENTID             ,"+   
								"PRODUCTID           ,"+   
								"INTERACTIONID       ,"+
								"CUSTOMERID          ,"+
								"SUMMARYID           ,"+
								"BILLSUMMARYPATH     ,"+
								"IPCCCUSTOMERINFO    ,"+
								"EVENTTYPE		     ,"+
								"CONTACTPERSONSEX    ,"+
								"CONTACTPERSONMEMO   ,"+
								"BACKUPPERSONSEX     ,"+
								"ISAUTHORIZATION     ,"+
								"BILLMEMO            ,"+
								"BACKUPPERSONMEMO	  "+
						 "FROM TB_IPS_BILL "+
						 "WHERE SEQID='"+optID+"'";
		//out.println(uptBillSQL);
		List billList = EZDbUtil.getStringArrayList(uptBillSQL);
		if(billList != null)
		{
			Object[] s =(Object[])billList.get(0);
			if(s!=null)
			{
				agentID				=	String.valueOf(s[0]);      	                 
				receiveTime   		=	String.valueOf(s[1]);	      							
				endTime				=	String.valueOf(s[2]);		  	       							
				dealState			=	String.valueOf(s[3]);	  	       							
				eventNo				=	String.valueOf(s[4]);	  	       							
				receiveMethod 		=	String.valueOf(s[5]);	      							
				eventFrom			=	String.valueOf(s[6]);	         							
				callType			=	String.valueOf(s[7]);	  	     							
				contactName	 		=	String.valueOf(s[8]);	       							
				contactTel	 		=	String.valueOf(s[9]);	       							
				backupContactName	=	String.valueOf(s[10]);     						
				backupContactTel	=	String.valueOf(s[11]);	   							
				isReserve			=	String.valueOf(s[12]);		         							
				reserveTime		    =	String.valueOf(s[13]);   							
				IDNumber			=	String.valueOf(s[14]);       							
				area				=	String.valueOf(s[15]);         							
				productName		    =	String.valueOf(s[16]);   							
				productBathNo	    =	String.valueOf(s[17]);   							
				limitTime		    =	String.valueOf(s[18]);     							
				productBarcode	    =	String.valueOf(s[19]);  							
				preventFalseNo	    =	String.valueOf(s[20]);  							
				factory			    =	String.valueOf(s[21]);     							
				eventMark		    =	String.valueOf(s[22]);     							
				contactMark		    =	String.valueOf(s[23]);   							
				traceMark		    =	String.valueOf(s[24]);     							
				channel			    =	String.valueOf(s[25]);     							
				customerName		=	String.valueOf(s[26]);     							
				businessPersonName  =	String.valueOf(s[27]);  							
				contactTelphone	    =	String.valueOf(s[28]);  							
				skinState		    =	String.valueOf(s[29]);     							
				useCycle			=	String.valueOf(s[30]);       							
				useMethod		    =	String.valueOf(s[31]);     							
				symptomMark		    =	String.valueOf(s[32]);   							
				isFirstUseProduct   =	String.valueOf(s[33]);  							
				otherContactResourse=	String.valueOf(s[34]);  							
				beforeProduct	    =	String.valueOf(s[35]);   							
				illHistory		    =	String.valueOf(s[36]);   							
				age				    =	String.valueOf(s[37]);       							
				job				    =	String.valueOf(s[38]);       							
				canRecieveTel	    =	String.valueOf(s[39]);   							
				agentID		      	=	String.valueOf(s[40]);   							
				productID	      	=	String.valueOf(s[41]);   							
				interactionID      	=	String.valueOf(s[42]); 
				customerID			=   String.valueOf(s[43]);
				summaryID			=	String.valueOf(s[44]);
				billSummaryPath		=	String.valueOf(s[45]);
				IPCCCustomerINFO	=	String.valueOf(s[46]);
				eventType			=	String.valueOf(s[47]);
				contactPersonSex	=	String.valueOf(s[48]);
				contactPersonMemo	=	String.valueOf(s[49]);
				backupPersonSex		=	String.valueOf(s[50]);
				isAuthorization		=	String.valueOf(s[51]);
				billMemo     		=	String.valueOf(s[52]);
				backupPersonMemo	=	String.valueOf(s[53]);
				localarea   = String.valueOf(s[54]);
				
				//filter data
				if(StringUtil.isNullOrEmpty(agentID))agentID = "10000";
				if(StringUtil.isNullOrEmpty(receiveTime))receiveTime = "";
				if(StringUtil.isNullOrEmpty(endTime) || "0001-01-01 00:00:00".equals(endTime))endTime = "";
				if(StringUtil.isNullOrEmpty(dealState))dealState = "";
				if(StringUtil.isNullOrEmpty(eventNo))eventNo = "";
				if(StringUtil.isNullOrEmpty(receiveMethod))receiveMethod = "";
				if(StringUtil.isNullOrEmpty(localarea))localarea = "";
				if(StringUtil.isNullOrEmpty(contactName))contactName = "";
				if(StringUtil.isNullOrEmpty(contactTel))contactTel = "";
				if(StringUtil.isNullOrEmpty(backupContactName))backupContactName = "";
				if(StringUtil.isNullOrEmpty(backupContactTel))backupContactTel = "";
				if(StringUtil.isNullOrEmpty(isReserve))isReserve = "2";
				if(StringUtil.isNullOrEmpty(reserveTime) || "0001-01-01 00:00:00".equals(reserveTime))reserveTime = "";
				if(StringUtil.isNullOrEmpty(IDNumber))IDNumber = "";
				if(StringUtil.isNullOrEmpty(area))area = "";
				if(StringUtil.isNullOrEmpty(productName))productName = "";
				if(StringUtil.isNullOrEmpty(productBathNo))productBathNo = "";
				if(StringUtil.isNullOrEmpty(limitTime) || "0001-01-01 00:00:00".equals(limitTime))limitTime = "";
				if(StringUtil.isNullOrEmpty(productBarcode))productBarcode = "";
				if(StringUtil.isNullOrEmpty(preventFalseNo))preventFalseNo = "";
				if(StringUtil.isNullOrEmpty(factory))factory = "";
				if(StringUtil.isNullOrEmpty(eventMark))eventMark = "";
				if(StringUtil.isNullOrEmpty(contactMark))contactMark = "";
				if(StringUtil.isNullOrEmpty(traceMark))traceMark = "";
				if(StringUtil.isNullOrEmpty(channel))channel = "";
				if(StringUtil.isNullOrEmpty(customerName))customerName = "";
				if(StringUtil.isNullOrEmpty(businessPersonName))businessPersonName = "";
				if(StringUtil.isNullOrEmpty(contactTelphone))contactTelphone = "";
				if(StringUtil.isNullOrEmpty(skinState))skinState = "";
				if(StringUtil.isNullOrEmpty(useCycle))useCycle = "";
				if(StringUtil.isNullOrEmpty(useMethod))useMethod = "";
				if(StringUtil.isNullOrEmpty(symptomMark))symptomMark = "";
				if(StringUtil.isNullOrEmpty(isFirstUseProduct))isFirstUseProduct = "1";
				if(StringUtil.isNullOrEmpty(otherContactResourse))otherContactResourse = "";
				if(StringUtil.isNullOrEmpty(beforeProduct))beforeProduct = "";
				if(StringUtil.isNullOrEmpty(illHistory))illHistory = "";
				if(StringUtil.isNullOrEmpty(age))age = "";
				if(StringUtil.isNullOrEmpty(job))job = "";
				if(StringUtil.isNullOrEmpty(canRecieveTel))canRecieveTel = "2";
				if(StringUtil.isNullOrEmpty(productID))productID = "17";
				if(StringUtil.isNullOrEmpty(interactionID))interactionID = "1242876451.40";
				if(StringUtil.isNullOrEmpty(customerID))customerID = "-1";
				if(StringUtil.isNullOrEmpty(summaryID))summaryID = "";
				if(StringUtil.isNullOrEmpty(billSummaryPath))billSummaryPath = "";
				if(StringUtil.isNullOrEmpty(IPCCCustomerINFO))IPCCCustomerINFO = "";
				if(StringUtil.isNullOrEmpty(contactPersonSex))contactPersonSex = "";
				if(StringUtil.isNullOrEmpty(contactPersonMemo))contactPersonMemo = "";
				if(StringUtil.isNullOrEmpty(backupPersonSex))backupPersonSex = "";
				if(StringUtil.isNullOrEmpty(backupPersonMemo))backupPersonMemo = "";
				if(StringUtil.isNullOrEmpty(isAuthorization))isAuthorization = "";
				if(StringUtil.isNullOrEmpty(billMemo))billMemo = "";
			}
		}
		optType     = "toUpdateBill";
	}
	
	//update bill
	if(!StringUtil.isNullOrEmpty(optType) &&
	   		"updateBill".equals(optType) &&
	   		!StringUtil.isNullOrEmpty(jetonInteractionID)
		  )
	{
		String myCountSQL = "SELECT count(0) FROM TB_IPS_BILL WHERE INTERACTIONID='"+jetonInteractionID+"'";
		String myCount = EZDbUtil.getOnlyStringValue(myCountSQL);
		//out.println("myCount---->"+myCount);
		if("0".equals(myCount))
		{
			out.println("<script language=\"javascript\" type=\"text/javascript\">");
			out.println("window.alert('相关工单不存在!');");
			out.println("window.close();");
			out.println("</script>");
			return;
		}
		String uptBillSQL = "SELECT "+
								"RECEIVEID           ,"+   
								"to_char(RECEIVETIME,'yyyy-mm-dd hh24:mi:ss') as RECEIVETIME,"+   
								"to_char(ENDTIME,'yyyy-mm-dd hh24:mi:ss') as ENDTIME,"+   
								"DEALSTATE           ,"+   
								"EVENTNO             ,"+   
								"RECEIVEMETHOD       ,"+   
								"LOCALAREA       ,"+ 
								"EVENTFROM           ,"+   
								"CALLTYPE            ,"+   
								"CONTACTNAME         ,"+   
								"CONTACTTEL          ,"+   
								"BACKUPCONTACTNAME   ,"+   
								"BACKUPCONTACTTEL    ,"+   
								"ISRESERVE           ,"+   
								"to_char(RESERVETIME,'yyyy-mm-dd hh24:mi:ss') as RESERVETIME,"+   
								"IDNUMBER            ,"+   
								"AREA                ,"+   
								"PRODUCTNAME         ,"+   
								"PRPDUCTBATNO        ,"+   
								"to_char(LIMITTIME,'yyyy-mm-dd hh24:mi:ss') as LIMITTIME,"+   
								"PRODUCTBARCODE      ,"+   
								"FACTORY             ,"+   
								"PREVENTFALSENO      ,"+   
								"EVENTMARK           ,"+   
								"CONTACTMARK         ,"+   
								"TRACEMARK           ,"+   
								"CHANNEL             ,"+   
								"CUSTOMERNAME        ,"+   
								"BUSINESSPERSONNAME  ,"+   
								"CONTACTTELPHONE     ,"+   
								"SKINSTATE           ,"+   
								"USECYCLE            ,"+   
								"USEMETHOD           ,"+   
								"SYMPTOMMARK         ,"+   
								"ISFIRSTUSEPRODUCT   ,"+   
								"BEFOREPRODUCT       ,"+   
								"OTHERCONTACTRESOURSE,"+   
								"ILLHISTORY          ,"+   
								"AGE                 ,"+   
								"JOB                 ,"+   
								"CANRECEIVETEL       ,"+   
								"AGENTID             ,"+   
								"PRODUCTID           ,"+   
								"INTERACTIONID       ,"+
								"CUSTOMERID          ,"+ 
								"SUMMARYID           ,"+
								"BILLSUMMARYPATH     ,"+
								"IPCCCUSTOMERINFO    ,"+
								"EVENTTYPE		     ,"+
								"CONTACTPERSONSEX    ,"+
								"CONTACTPERSONMEMO   ,"+
								"BACKUPPERSONSEX     ,"+
								"ISAUTHORIZATION     ,"+
								"BILLMEMO            ,"+
								"BACKUPPERSONMEMO	  "+
						 "FROM TB_IPS_BILL "+
						 "WHERE INTERACTIONID='"+jetonInteractionID+"'";
		//out.println(uptBillSQL);
		List billList = EZDbUtil.getStringArrayList(uptBillSQL);
		if(billList != null)
		{
			Object[] s =(Object[])billList.get(0);
			if(s!=null)
			{
				agentID				=	String.valueOf(s[0]);      	                 
				receiveTime   		=	String.valueOf(s[1]);	      							
				endTime				=	String.valueOf(s[2]);		  	       							
				dealState			=	String.valueOf(s[3]);	  	       							
				eventNo				=	String.valueOf(s[4]);	  	       							
				receiveMethod 		=	String.valueOf(s[5]);	      							
				eventFrom			=	String.valueOf(s[6]);	         							
				callType			=	String.valueOf(s[7]);	  	     							
				contactName	 		=	String.valueOf(s[8]);	       							
				contactTel	 		=	String.valueOf(s[9]);	       							
				backupContactName	=	String.valueOf(s[10]);     						
				backupContactTel	=	String.valueOf(s[11]);	   							
				isReserve			=	String.valueOf(s[12]);		         							
				reserveTime		    =	String.valueOf(s[13]);   							
				IDNumber			=	String.valueOf(s[14]);       							
				area				=	String.valueOf(s[15]);         							
				productName		    =	String.valueOf(s[16]);   							
				productBathNo	    =	String.valueOf(s[17]);   							
				limitTime		    =	String.valueOf(s[18]);     							
				productBarcode	    =	String.valueOf(s[19]);  							
				preventFalseNo	    =	String.valueOf(s[20]);  							
				factory			    =	String.valueOf(s[21]);     							
				eventMark		    =	String.valueOf(s[22]);     							
				contactMark		    =	String.valueOf(s[23]);   							
				traceMark		    =	String.valueOf(s[24]);     							
				channel			    =	String.valueOf(s[25]);     							
				customerName		=	String.valueOf(s[26]);     							
				businessPersonName  =	String.valueOf(s[27]);  							
				contactTelphone	    =	String.valueOf(s[28]);  							
				skinState		    =	String.valueOf(s[29]);     							
				useCycle			=	String.valueOf(s[30]);       							
				useMethod		    =	String.valueOf(s[31]);     							
				symptomMark		    =	String.valueOf(s[32]);   							
				isFirstUseProduct   =	String.valueOf(s[33]);  							
				otherContactResourse=	String.valueOf(s[34]);  							
				beforeProduct	    =	String.valueOf(s[35]);   							
				illHistory		    =	String.valueOf(s[36]);   							
				age				    =	String.valueOf(s[37]);       							
				job				    =	String.valueOf(s[38]);       							
				canRecieveTel	    =	String.valueOf(s[39]);   							
				agentID		      	=	String.valueOf(s[40]);   							
				productID	      	=	String.valueOf(s[41]);   							
				interactionID      	=	String.valueOf(s[42]); 
				customerID			=   String.valueOf(s[43]);
				summaryID			=	String.valueOf(s[44]);
				billSummaryPath		=	String.valueOf(s[45]);
				IPCCCustomerINFO	=	String.valueOf(s[46]);
				eventType			=	String.valueOf(s[47]);
				contactPersonSex	=	String.valueOf(s[48]);
				contactPersonMemo	=	String.valueOf(s[49]);
				backupPersonSex		=	String.valueOf(s[50]);
				isAuthorization		=	String.valueOf(s[51]);
				billMemo     		=	String.valueOf(s[52]);
				backupPersonMemo	=	String.valueOf(s[53]);
				localarea = String.valueOf(s[54]);
				//filter data
				if(StringUtil.isNullOrEmpty(agentID))agentID = "10000";
				if(StringUtil.isNullOrEmpty(receiveTime))receiveTime = "";
				if(StringUtil.isNullOrEmpty(endTime) || "0001-01-01 00:00:00".equals(endTime))endTime = "";
				if(StringUtil.isNullOrEmpty(dealState))dealState = "";
				if(StringUtil.isNullOrEmpty(eventNo))eventNo = "";
				if(StringUtil.isNullOrEmpty(receiveMethod))receiveMethod = "";
				if(StringUtil.isNullOrEmpty(localarea))localarea = "";
				if(StringUtil.isNullOrEmpty(contactName))contactName = "";
				if(StringUtil.isNullOrEmpty(contactTel))contactTel = "";
				if(StringUtil.isNullOrEmpty(backupContactName))backupContactName = "";
				if(StringUtil.isNullOrEmpty(backupContactTel))backupContactTel = "";
				if(StringUtil.isNullOrEmpty(isReserve))isReserve = "2";
				if(StringUtil.isNullOrEmpty(reserveTime) || "0001-01-01 00:00:00".equals(reserveTime))reserveTime = "";
				if(StringUtil.isNullOrEmpty(IDNumber))IDNumber = "";
				if(StringUtil.isNullOrEmpty(area))area = "";
				if(StringUtil.isNullOrEmpty(productName))productName = "";
				if(StringUtil.isNullOrEmpty(productBathNo))productBathNo = "";
				if(StringUtil.isNullOrEmpty(limitTime)|| "0001-01-01 00:00:00".equals(limitTime))limitTime = "";
				if(StringUtil.isNullOrEmpty(productBarcode))productBarcode = "";
				if(StringUtil.isNullOrEmpty(preventFalseNo))preventFalseNo = "";
				if(StringUtil.isNullOrEmpty(factory))factory = "";
				if(StringUtil.isNullOrEmpty(eventMark))eventMark = "";
				if(StringUtil.isNullOrEmpty(contactMark))contactMark = "";
				if(StringUtil.isNullOrEmpty(traceMark))traceMark = "";
				if(StringUtil.isNullOrEmpty(channel))channel = "";
				if(StringUtil.isNullOrEmpty(customerName))customerName = "";
				if(StringUtil.isNullOrEmpty(businessPersonName))businessPersonName = "";
				if(StringUtil.isNullOrEmpty(contactTelphone))contactTelphone = "";
				if(StringUtil.isNullOrEmpty(skinState))skinState = "";
				if(StringUtil.isNullOrEmpty(useCycle))useCycle = "";
				if(StringUtil.isNullOrEmpty(useMethod))useMethod = "";
				if(StringUtil.isNullOrEmpty(symptomMark))symptomMark = "";
				if(StringUtil.isNullOrEmpty(isFirstUseProduct))isFirstUseProduct = "1";
				if(StringUtil.isNullOrEmpty(otherContactResourse))otherContactResourse = "";
				if(StringUtil.isNullOrEmpty(beforeProduct))beforeProduct = "";
				if(StringUtil.isNullOrEmpty(illHistory))illHistory = "";
				if(StringUtil.isNullOrEmpty(age))age = "";
				if(StringUtil.isNullOrEmpty(job))job = "";
				if(StringUtil.isNullOrEmpty(canRecieveTel))canRecieveTel = "2";
				if(StringUtil.isNullOrEmpty(productID))productID = "-1";
				if(StringUtil.isNullOrEmpty(interactionID))interactionID = "88888888";
				if(StringUtil.isNullOrEmpty(customerID))customerID = "-1";
				if(StringUtil.isNullOrEmpty(summaryID))summaryID = "";
				if(StringUtil.isNullOrEmpty(billSummaryPath))billSummaryPath = "";
				if(StringUtil.isNullOrEmpty(IPCCCustomerINFO))IPCCCustomerINFO = "";
				if(StringUtil.isNullOrEmpty(contactPersonSex))contactPersonSex = "";
				if(StringUtil.isNullOrEmpty(contactPersonMemo))contactPersonMemo = "";
				if(StringUtil.isNullOrEmpty(backupPersonSex))backupPersonSex = "";
				if(StringUtil.isNullOrEmpty(backupPersonMemo))backupPersonMemo = "";
				if(StringUtil.isNullOrEmpty(isAuthorization))isAuthorization = "2";
				if(StringUtil.isNullOrEmpty(billMemo))billMemo = "";
			}
		}
		optType     = "toUpdateBill";
		okButDisplay = "disabled=\"disabled\"";
	}
	
	//String IPCCCustomerINFO = "";    //name
	String IPCCCustomerSEX = "";	//消费者性别
	String IPCCCompTel   = "";		//消费者公司电话
	String IPCCHomeTel   = "";		//消费者办公电话
	String IPCCMobileTel = "";		//消费者移动电话
	if(!StringUtil.isNullOrEmpty(customerID)  && !"-1".equals(customerID))
	{
		String myCustomerSQL = "select ntitle,strofficephone,strhomephone,strmobilephone "+
							   "from tb000000personalcustomer where lid="+customerID;
		List cusList = EZDbUtil.getStringArrayList(myCustomerSQL);
		if(cusList != null)
		{
			Object[] s =(Object[])cusList.get(0);
			if(s!=null)
			{
				//IPCCCustomerINFO        =   String.valueOf(s[0]);
				IPCCCustomerSEX			=	String.valueOf(s[0]);
				IPCCCompTel				=	String.valueOf(s[1]);
				IPCCHomeTel				=	String.valueOf(s[2]);
				IPCCMobileTel			=	String.valueOf(s[3]);
				//filter data
				if(IPCCCustomerSEX.equals("1"))
				{
					IPCCCustomerSEX = "先生";
				}
				if(IPCCCustomerSEX.equals("2"))
				{
					IPCCCustomerSEX = "小姐";
				}
				if(IPCCCustomerSEX.equals("3"))
				{
					IPCCCustomerSEX = "女士";
				}
				if(StringUtil.isNullOrEmpty(IPCCCompTel))IPCCCompTel = "";
				if(StringUtil.isNullOrEmpty(IPCCHomeTel))IPCCHomeTel = "";
				if(StringUtil.isNullOrEmpty(IPCCMobileTel))IPCCMobileTel = "";
			}
		}
		
		 
	}
%>
<html>
	<head>
		<title>工单明细</title>
		<link href="<%=rootPath%>/css/chrome.css" rel="stylesheet" type="text/css">
		<script src="<%=rootPath%>/script/DateTime.js" language="JavaScript" type="text/javascript"></script>
		<script language="javascript"><%@include file="/script/DateTimeVariable.js"%></script>
		<script src="<%=rootPath%>/script/dateUtil.js" language="JavaScript" type="text/javascript"></script>
		<script src="<%=rootPath%>/script/generalCheckfunction.js" language="JavaScript" type="text/javascript"></script>
		<script language="javascript" type="text/javascript">
		/*Save Bill*/
		function saveBill() 
		{
			if(dataCheck())
			{
				document.form1.submit();
				window.alert("保存成功！");
		        //window.close();
			}
		}
		/*Data check*/
		function dataCheck()
		{
			var eventType = form1.eventType.value;	//事件类型
			//if((eventType==null||eventType=='-1'||eventType=="-1"))
			////{
			//	alert("请选择事件类型!");
			//	return false;
			//}
			
			var dealState = form1.dealState.value;	//处理状态
			if((dealState==null||dealState=='-1'||dealState=="-1"))
			{
				alert("请选择处理状态!");
				return false;
			}
			var customerID = form1.customerID.value;	//客户信息
			if((customerID==null||customerID=='-1'||customerID=="-1"))
			{
				alert("请选择客户信息!");
				//selectIPCCCustomer();
				return false;
			}
			
	/**		var contactName 	= form1.contactName.value;	//联系人姓名
			if((contactName==null||contactName==''||contactName==""))
			{
				alert("请输入联系人姓名!");
				form1.contactName.focus();
				return false;
			}
			var contactTel 	= form1.contactTel.value;	//联系人电话
			if((contactTel==null||contactTel==''||contactTel==""))
			{
				alert("请输入联系人电话!");
				form1.contactTel.focus();
				return false;
			}
	**/		
			var contactTel 	= form1.contactTel.value;	//联系人电话
			if(!checkIsInteger(contactTel))
			{
				alert("联系人电话必须是数字!");
				form1.contactTel.focus();
				return false;
			}
			var backupContactTel 	= form1.backupContactTel.value;	//备用联系人电话
			if(!checkIsInteger(backupContactTel))
			{
				alert("备用联系人电话必须是数字!");
				form1.backupContactTel.focus();
				return false;
			}
			//var productName 	= form1.productName.value;	//产品名称
			//if((productName==null||productName==''||productName==""))
			//{
			//	alert("请输入或选择产品名称!");
			//	form1.productName.focus();
			//	return false;
			//}
			var eventMark 	= form1.eventMark.value;	//事件描述
			if((eventMark==null||eventMark==''||eventMark==""))
			{
				alert("请输入事件描述!");
				form1.eventMark.focus();
				return false;
			}
			//var age 	= form1.age.value;	//年龄
			//if(!checkIsInteger(age))
			//{
			//	alert("年龄必须是数字!");
			//	form1.age.focus();
			//	return false;
			//}
			var summaryID = form1.summaryID.value;	//反馈明细
			if((summaryID==''||summaryID==null||summaryID=='-1'||summaryID=="-1"))
			{
				alert("请选择反馈明细!");
				return false;
			}
			return true;
		}
		/*set endtime value*/
		function setEndTime(optVal)
		{
			if(optVal != "2")
			{
				form1.endTime.value = getCurrentTime();
		    }else
			{
		    	form1.endTime.value = "";
			}
		}
		/*open select product window*/
		function selectProduct()
		{
			var width = screen.width-300;
			var height = screen.height-280;
			var x = 400;
			var y = 200;
			var billID = form1.eventNo.value;
			var openURL = "<%=request.getContextPath()%>/jsp/product/bill_product_select_frame.jsp?billID="+billID;
			parent.window.open(openURL,"select_product","width="+width+"',height="+height+
					                      ",left="+x+",top="+y+
					                      ",scrollbars=yes,menubar=no,statusbar=no,");
		}
		/*open select summary window*/
		function selectSummary()
		{
			var width = screen.width-700;
			var height = screen.height-320;
			var x = 400;
			var y = 200;
			var summaryID = form1.summaryID.value;
			var openURL = "<%=request.getContextPath()%>/jsp/summary/summary_select.jsp?summaryID="+summaryID;
			parent.window.open(openURL,"select_summary","width="+width+"',height="+height+
					                      ",left="+x+",top="+y+
					                      ",scrollbars=yes,menubar=no,statusbar=no,");
	    }
	    /*open select EZIPCC customer window*/
		function selectIPCCCustomer()
	    {
			var width = screen.width-300;
			var height = screen.height-280;
			var x = 400;
			var y = 200;
			var customerID = form1.customerID.value;
			var openURL = "<%=request.getContextPath()%>/jsp/IPCCCustomer/customer_select.jsp?optFrom=fromDetail&customerID="+customerID;
			parent.window.open(openURL,"select_EZIPCCCustomer","width="+width+"',height="+height+
					                      ",left="+x+",top="+y+
					                      ",scrollbars=yes,menubar=no,statusbar=no,");
		}
		
	
		
		/*Ajax get summaryPath*/
		var xmlhttp;
		function ajaxGetSummaryPath(summaryId)
		{
			xmlhttp=null;
			//alert("ajax----"+summaryId+":::kk");
			if(summaryId.trim().length>0)
			{
				var url = "../summary/ajaxChangeSummaryPath.jsp?jetonMath=Math.random()&summaryId="+summaryId;
				if (window.XMLHttpRequest)
				{// code for Firefox, Opera, IE7, etc.
				  xmlhttp=new XMLHttpRequest();
				}
				else if (window.ActiveXObject)
				{// code for IE6, IE5
				  xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
				}
				if (xmlhttp!=null)
				{
				  xmlhttp.onreadystatechange=sumPath_Change;
				  xmlhttp.open("GET",url,true);
				  xmlhttp.send(null);
				}
				else
				{
				  alert("Your browser does not support XMLHTTP.");
				}
			}
		}
		/*Trim function*/
		String.prototype.trim= function(){  
		    // 用正则表达式将前后空格  
		    return this.replace(/(^\s*)|(\s*$)/g, "");  
		}
		/*ajax summaryPath change*/
		function sumPath_Change()
		{
			if (xmlhttp.readyState==4)
		  	{// 4 = "loaded"
		  		if (xmlhttp.status==200)
		    	{// 200 = "OK"
					var jetonTmp = xmlhttp.responseText.trim();
		    		if(jetonTmp!='-1'&&jetonTmp!=''&&jetonTmp.length>0)
		    		{
						form1.billSummaryPath.value = jetonTmp;
		    		}
		    	}
		  		else
			    {
			    	alert("Problem retrieving data:" + xmlhttp.statusText);
			    }
		  	}
		 }
		 /*Ajax Get ProductName*/
		 function ajaxGetProductName(productId)
			{
				xmlhttp=null;
				//alert("ajax----"+productId+":::kk");
				if(productId.trim().length>0)
				{
					var url = "../product/ajaxChangeProductName.jsp?jetonMath=Math.random()&productId="+productId;
					if (window.XMLHttpRequest)
					{// code for Firefox, Opera, IE7, etc.
					  xmlhttp=new XMLHttpRequest();
					}
					else if (window.ActiveXObject)
					{// code for IE6, IE5
					  xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
					}
					if (xmlhttp!=null)
					{
					  xmlhttp.onreadystatechange=productName_Change;
					  xmlhttp.open("GET",url,true);
					  xmlhttp.send(null);
					}
					else
					{
					  alert("Your browser does not support XMLHTTP.");
					}
				}
			}
		    /*ajax productName change*/
			function productName_Change()
			{
				if (xmlhttp.readyState==4)
			  	{// 4 = "loaded"
			  		if (xmlhttp.status==200)
			    	{// 200 = "OK"
						var jetonTmp = xmlhttp.responseText.trim();
			    		if(jetonTmp!='-1'&&jetonTmp!=''&&jetonTmp.length>0)
			    		{
							form1.productName.value = jetonTmp;
			    		}
			    	}
			  		else
				    {
				    	alert("Problem retrieving data:" + xmlhttp.statusText);
				    }
			  	}
			 }
			 
			 
			 function closeBill(){
			 	if(confirm("确认已经保存？未保存请先保存再关闭！"))
				{
					window.close();
			    }
			    else
			    {
			    	window.back();
			    }
			 }
			 
			 function load()
			 {
			 	var mySelProductID = parent.frames["productSelectFrame"].getSelProductID();
				form1.productID.value = mySelProductID;
				form1.submit();
			 }
		</script>
</head>
<body style="overflow: auto;" topmargin="0" leftmargin="0" rightmargin="0" onload="load()">
	<form name="form1" method="post" action="bill_detail.jsp">
	<input name="optType" type="hidden" value="<%=optType%>"/>
	<input name="optID" type="hidden" value="<%=optID%>"/>
	<input name="agentID" type="hidden" value="<%=agentID%>"/>
	<input name="productID" type="hidden" value="<%=productID%>"/>
	<input name="interactionID" type="hidden" value="<%=interactionID%>"/>
	<input name="customerID" type="hidden" value="<%=customerID%>"/>
	<input name="summaryID" type="hidden" value="<%=summaryID%>"/>
	<table border="0" cellspacing="0" cellpadding="0" width="100%" class="opBg">
		<tr valign="top" height="30px">
			<td align="left" valign="middle">
        			<div id="Title">
        				<img src='<%=rootPath%>/images/ipcc_icon_setup.gif' align='absmiddle' width='16' height='16' border='0'/>
        				<strong class="titleMiddle">相宜本草客服工单明细</strong>
        			</div>              			
        		</td>
        	</tr>
     </table>
	
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="opbg">
	<tr bgcolor="#d5e2f3" height="30px">
		<td align="right" nowrap="nowrap">
			<strong class="titleMiddle">基本信息</strong>
		</td>
		<td colspan="7">&nbsp;</td>
		<td align="right" nowrap="nowrap">获知渠道</td>
		<td>
			<select name="eventType" id="eventType">
		      <option value="-1">请选择:</option>
		      <%
            	String eventTypeSQL =  "SELECT typevalue, typename "+
					            	   "FROM tb_ips_dictionary "+
					            	   "WHERE maintype='eventType' and isuse='1' "+
					            	   "ORDER BY ordernum";   
            	String  eventTypeOptions=EZDmManager.getOptionsBySql(eventTypeSQL,eventType);
          		out.println(eventTypeOptions);
              %>
		    </select>
		</td>
	  </tr>
	  <tr>
	    <td align="right">事件编号:</td>
			<td><input name="eventNo" type="text" value="<%=eventNo%>" class="box01"  readonly="readonly" size="24"></td>
	     <td align="right" nowrap="nowrap"><%=mustField%>处理状态:</td>
		<td>
			<select name="dealState" id="dealState" onchange="setEndTime(this.value);">
		      <option value="-1">请选择</option>
		      <%
            	String dealStateSQL =  "SELECT typevalue, typename "+
					            	   "FROM tb_ips_dictionary "+
					            	   "WHERE maintype='dealState' and isuse='1' "+
					            	   "ORDER BY ordernum";   
            	String  options=EZDmManager.getOptionsBySql(dealStateSQL,dealState);
          		out.println(options);
              %>
		    </select>
		</td>
	    <td align="right" nowrap="nowrap"><%=mustField%>呼叫类型:</td>
		<td>
			<select name="callType" id="callType">
			  <%
            	String callTypeSQL =  "SELECT typevalue, typename "+
					            	   "FROM tb_ips_dictionary "+
					            	   "WHERE maintype='callType' and isuse='1' "+
					            	   "ORDER BY ordernum";   
            	String  callTypeOptions=EZDmManager.getOptionsBySql(callTypeSQL,callType);
          		out.println(callTypeOptions);
              %>
			</select>
		</td>
	    <td align="right" nowrap="nowrap"><%=mustField%>接收方式:</td>
		<td>
			<select name="receiveMethod" id="receiveMethod">
			  <%
            	String receiveMethodSQL =  "SELECT typevalue, typename "+
					            	   "FROM tb_ips_dictionary "+
					            	   "WHERE maintype='receiveMethod' and isuse='1' "+
					            	   "ORDER BY ordernum";   
            	String  receiveMethodOptions=EZDmManager.getOptionsBySql(receiveMethodSQL,receiveMethod);
          		out.println(receiveMethodOptions);
              %>
			</select> 
		</td>
		<td align="right" nowrap="nowrap"><%=mustField%>事件来源:</td>
			<td>
				<select name="eventFrom" id="eventFrom">
				 <%
	            	String eventFromSQL =  "SELECT typevalue, typename "+
						            	   "FROM tb_ips_dictionary "+
						            	   "WHERE maintype='eventFrom' and isuse='1' "+
						            	   "ORDER BY ordernum";   
	            	String  eventFromOptions=EZDmManager.getOptionsBySql(eventFromSQL,eventFrom);
	          		out.println(eventFromOptions);
	              %>
				</select> 
			</td>
	   </tr>
	  <tr>
	    <td align="right" nowrap="nowrap">
	    	<%=mustField%><a style="cursor:hand;" onclick="selectIPCCCustomer();">消费者姓名</a>:</td>
		<td>
			<input name="IPCCCustomerINFO" type="text" class="box01" readonly="readonly" value="<%=IPCCCustomerINFO%>" size="24">
		</td>
	    <td align="right" nowrap="nowrap">称谓:</td>
	    <td>
	    	 <input name="IPCCCustomerSEX" type="text" class="box01" readonly="readonly" value="<%=IPCCCustomerSEX%>" size="20">
	    </td>
	    <td align="right" nowrap="nowrap">年龄:</td>
		<td><input name="age" type="text" class="box01" value="<%=age%>" size="6"></td>
	    <td align="right" nowrap="nowrap">所在地区:</td>
		<td><input name="area" type="text" class="box01" value="<%=area%>" size="20"></td>
		<td align="right" nowrap="nowrap">职业:</td>
		<td><input name="job" type="text" class="box01" value="<%=job%>" <%=myTextSize%>></td>
	   </tr>
	   <tr>
	    <td align="right" nowrap="nowrap">公司电话:</td>
	    <td>
	    	<input name="IPCCCompTel" type="text" class="box01" value="<%=IPCCCompTel%>" size="24" readonly="readonly">
	    </td>
	    <td align="right" nowrap="nowrap">家庭电话:</td>
	    <td>
	    	<input name="IPCCHomeTel" type="text" class="box01" value="<%=IPCCHomeTel%>" size="20" readonly="readonly">
	    </td>
	    <td align="right" nowrap="nowrap">移动电话:</td>
	    <td>
	    	<input name="IPCCMobileTel" type="text" class="box01" value="<%=IPCCMobileTel%>" size="16" readonly="readonly">
	    </td>
		
	    <td align="right" nowrap="nowrap">身份证号码:</td>
		<td ><input name="IDNumber" type="text" class="box01" value="<%=IDNumber%>" size="20"></td>
		<td align="right" nowrap="nowrap">首次<br>使用产品:</td>
		<td>
			<input type="radio" name="isFirstUseProduct" value="1" <%if("1".equals(isFirstUseProduct)){out.print("checked=\"checked\"");}%>>是
			<input type="radio" name="isFirstUseProduct" value="2" <%if("2".equals(isFirstUseProduct)){out.print("checked=\"checked\"");}%>>否
		</td>
	   </tr>
	   <tr>
	    <td align="right" nowrap="nowrap">皮肤状态:</td>
		<td>
			<select name="skinState" id="skinState">
			  <%
            	String skinStateSQL =  "SELECT typevalue, typename "+
					            	   "FROM tb_ips_dictionary "+
					            	   "WHERE maintype='skinState' and isuse='1' "+
					            	   "ORDER BY ordernum";   
            	String  skinStateOptions=EZDmManager.getOptionsBySql(skinStateSQL,skinState);
          		out.println(skinStateOptions);
              %>
			</select>
		</td>
	    <td align="right" nowrap="nowrap">病史:</td>
		<td colspan="3"><input name="illHistory" type="text" class="box01" value="<%=illHistory%>" size="53"></td>
	    <td align="right" nowrap="nowrap">其他接触源:</td>
		<td colspan="3"><input name="otherContactResourse" type="text" class="box01" value="<%=otherContactResourse%>" size="60"></td>
	   </tr>
	   <tr>
		    <td align="right" nowrap="nowrap">使用周期:</td>
			<td><input name="useCycle" type="text" class="box01" value="<%=useCycle%>" size="24"></td>
			<td align="right" nowrap="nowrap">使用方法:</td>
			<td colspan="3"><input name="useMethod" type="text" class="box01" value="<%=useMethod%>" size="53"></td>
			<td align="right" nowrap="nowrap">之前使用过 <br>其他化妆品:</td>
			<td colspan="3"><input name="beforeProduct" type="text" size="60" class="box01" value="<%=beforeProduct%>"></td>
	   </tr>
	  <tr>
	  	<td align="right" nowrap="nowrap">是否预约:</td>
		<td>
			<input type="radio" name="isReserve" value="1" <%if("1".equals(isReserve)){out.print("checked=\"checked\"");}%>>是
			<input type="radio" name="isReserve" value="2" <%if("2".equals(isReserve)){out.print("checked=\"checked\"");}%>>否
		</td>
		<td align="right" nowrap="nowrap">预约时间:</td>
		<td><input name="reserveTime" type="text" class="box01" value="<%=reserveTime%>" onFocus="ShowCalendar(0)" <%=myTextSize%>></td>
		 <td align="right" nowrap="nowrap">所在地区:</td>
		<td>
			<select name="localarea" id="localarea">
			  <%
            	String localareaSQL =  "SELECT typevalue, typename "+
					            	   "FROM tb_ips_dictionary "+
					            	   "WHERE maintype='localarea' and isuse='1' "+
					            	   "ORDER BY ordernum";   
            	String  localareaOptions=EZDmManager.getOptionsBySql(localareaSQL,localarea);
          		out.println(localareaOptions);
              %>
			</select> 
		</td>
	    <td align="right" nowrap="nowrap" colspan="3">愿意接受电话访问:</td>
		<td colspan="4">
		  	<input type="radio" name="canRecieveTel" value="1" <%if("1".equals(canRecieveTel)){out.print("checked=\"checked\"");}%>>是
			<input type="radio" name="canRecieveTel" value="2" <%if("2".equals(canRecieveTel)){out.print("checked=\"checked\"");}%>>否
		</td>
	</tr>
	<tr bgcolor="#d5e2f3" height="30px">
		<td align="left" nowrap="nowrap" colspan="10">
			<strong class="titleMiddle">其他联系信息</strong>
		</td>
	</tr>  
	   
		  <tr>
		  	<td align="right" nowrap="nowrap">
		  		(1)&nbsp;&nbsp;&nbsp;&nbsp;姓名:
		  	</td>
			<td nowrap="nowrap"><input name="contactName" type="text" class="box01" value="<%=contactName%>" size="24"></td>
			<td align="right" nowrap="nowrap">称谓:</td>
			<td nowrap="nowrap">
				<select name="contactPersonSex" id="contactPersonSex">
				  <%
	            	String contactPersonSexSQL =  "SELECT typevalue, typename "+
						            	   "FROM tb_ips_dictionary "+
						            	   "WHERE maintype='sexType' and isuse='1' "+
						            	   "ORDER BY ordernum";   
	            	String  contactPersonSexOptions=EZDmManager.getOptionsBySql(contactPersonSexSQL,contactPersonSex);
	          		out.println(contactPersonSexOptions);
	              %>
				</select>
			</td>
		    <td align="right" nowrap="nowrap">联系方式:</td>
			<td><input name="contactTel" type="text" class="box01" value="<%=contactTel%>" size="16"></td>
			<td align="right" nowrap="nowrap">备注:</td>
			<td nowrap="nowrap" colspan="3">
				<input name="contactPersonMemo" type="text" class="box01" value="<%=contactPersonMemo%>" size="60">
			</td>
		 </tr>
		 <tr>
		 	<td align="right" nowrap="nowrap">
		 		(2)&nbsp;&nbsp;&nbsp;&nbsp;姓名:
		 	</td>
		 	<td nowrap="nowrap"><input name="backupContactName" type="text" class="box01" value="<%=backupContactName%>" size="24"></td>
		 	<td align="right" nowrap="nowrap">称谓:</td>
			<td nowrap="nowrap">
				<select name="backupPersonSex" id="backupPersonSex">
				  <%
	            	String backupPersonSexSQL =  "SELECT typevalue, typename "+
						            	   "FROM tb_ips_dictionary "+
						            	   "WHERE maintype='sexType' and isuse='1' "+
						            	   "ORDER BY ordernum";   
	            	String  backupPersonSexOptions=EZDmManager.getOptionsBySql(backupPersonSexSQL,backupPersonSex);
	          		out.println(backupPersonSexOptions);
	              %>
				</select>
			</td>
			<td align="right" nowrap="nowrap">联系方式:</td>
			<td><input name="backupContactTel" type="text" class="box01" value="<%=backupContactTel%>" size="16"></td>
			<td align="right" nowrap="nowrap">备注:</td>
			<td nowrap="nowrap" colspan="3">
				<input name="backupPersonMemo" type="text" class="box01" value="<%=backupPersonMemo%>" size="60">
			</td>
		  </tr>
		  
		  
		  <tr bgcolor="#d5e2f3" height="30px">
			<td align="right" nowrap="nowrap">
				<strong class="titleMiddle">业务信息</strong>
			</td>
			<td colspan="9">&nbsp;</td>
		  </tr>  
		  <tr>
		    <td align="right" nowrap="nowrap"><%=mustField%>事件描述:</td>
			<td colspan="9">
				<textarea name="eventMark" class="box01" cols="168" rows="4"><%=eventMark%></textarea>
			</td>
		  </tr>
		  <tr>
		    <td align="right" nowrap="nowrap">不良反应<br>症状:</td>
			<td colspan="9">
				<textarea name="symptomMark" class="box01" cols="168" rows="4"><%=symptomMark%></textarea>
			</td>
		  </tr>
		  <tr>
		    <td align="right" nowrap="nowrap">沟通情况:</td>
			<td colspan="9">
				<textarea name="contactMark" class="box01" cols="168" rows="4"><%=contactMark%></textarea>
			</td>
		  </tr>
		  <tr>
		    <td align="right" nowrap="nowrap">跟踪情况:</td>
			<td colspan="9">
				<textarea name="traceMark" class="box01" cols="168" rows="4"><%=traceMark%></textarea>
			</td>
		  </tr>
		  <tr>
		    <td align="right" nowrap="nowrap">工单备注:</td>
			<td colspan="9">
				<textarea name="billMemo" class="box01" cols="168" rows="4"><%=billMemo%></textarea>
			</td>
		  </tr>
		  <tr bgcolor="#d5e2f3" height="30px">
			<td align="right" nowrap="nowrap">
				<strong class="titleMiddle">产品信息</strong>
			</td>
			<td colspan="9" align="right">
				<a style="cursor:hand;" onclick="selectProduct();">选择产品</a>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			</td>
		  </tr>
		  <!-- 产品信息列表 -->
		  <tr>
		  	<td colspan="10" width="100%">
		  		<iframe width="100%" height="120%" src="../product/bill_product_list.jsp?billID=<%=eventNo%>" 
						    name="jetonBillProductFrame" scrolling="no" id="jetonBillProductFrame"
							frameborder="0" border="0" framespacing="0">
				</iframe>
		  	</td>
		  </tr>
		  <tr>
		    <td align="right" nowrap="nowrap">渠道信息:</td>
			<td>
				<select name="channel" id="channel">
				  <%
	            	String channelSQL =  "SELECT typevalue, typename "+
						            	   "FROM tb_ips_dictionary "+
						            	   "WHERE maintype='channel' and isuse='1' "+
						            	   "ORDER BY ordernum";   
	            	String  channelOptions=EZDmManager.getOptionsBySql(channelSQL,channel);
	          		out.println(channelOptions);
	              %>
				</select>
			</td>
			<td align="right" nowrap="nowrap">是否授权:</td>
			<td>
				<input type="radio" name="isAuthorization" value="1" <%if("1".equals(isAuthorization)){out.print("checked=\"checked\"");}%>>是
				<input type="radio" name="isAuthorization" value="2" <%if("2".equals(isAuthorization)){out.print("checked=\"checked\"");}%>>否
				<input type="radio" name="isAuthorization" value="3" <%if("3".equals(isAuthorization)){out.print("checked=\"checked\"");}%>>不确定 
			</td>
			<td align="right" nowrap="nowrap">客户名称:</td>
			<td><input name="customerName" type="text" class="box01" value="<%=customerName%>" size="20"></td>
			<td align="right" nowrap="nowrap">业务员姓名:</td>
			<td><input name="businessPersonName" type="text" class="box01" value="<%=businessPersonName%>" size="16"></td>
			<td align="right" nowrap="nowrap">联系方式:</td>
			<td><input name="contactTelphone" type="text" class="box01" value="<%=contactTelphone%>" <%=myTextSize%>></td>
		  </tr>
		  <tr>
		  	<td align="right" nowrap="nowrap"><%=mustField%>反馈明细:</td>
			<td colspan="9">
				<input name="billSummaryPath" type="text" class="box01" readonly="readonly" value="<%=billSummaryPath%>" size="130">
				&nbsp;&nbsp;<a style="cursor:hand;" onclick="selectSummary();">选择</a>
			</td>
		  </tr>
	   <tr>
	    <td align="right" nowrap="nowrap">创建时间:</td>
	    <td>
	    	<input type="text" name="receiveTime" readonly="readonly" value='<%=receiveTime%>' class="box01" <%=myTextSize%>/> 
	    </td>
	    <td align="right" nowrap="nowrap">结案时间:</td>
	    <td colspan="3">
	    	<input type="text" name="endTime" readonly="readonly" value='<%=endTime%>' class="box01" <%=myTextSize%>/> 
	    </td>
	    <td align="right" nowrap="nowrap">创建人:</td>
	    <td colspan="3">
                <input type="text" name="an" readonly="readonly" value='<%=agentName%>'  class="box01" size="16"/>
	    	<input type="text" name="receiveID" readonly="readonly" value='<%=agentID%>' style="visibility:hidden" class="box01" size="16"/> 
	    </td>
	   </tr>
		  <tr height="30px">
		    <td  align="center" colspan="10">
			<input onclick="javascript:saveBill();" value="保存" type="button" style="width:80px;" <%=okButDisplay%> class="button">
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<input onclick="javascript:closeBill();" value="关闭" type="button" style="width:80px;" class="button">
		   </td>
		  </tr>
	</table>
	</form>
</body>
</html>
