package com.blisscloud.dao;
import com.blisscloud.util.*;

public class CustomerDAO {
	
	public static String getCustomerSex(String customerID)
	{
		String sex = "";
		if(!StringUtil.isNullOrEmpty(customerID))
		{
			String myCustomerSQL = "select nsex from tb000000personalcustomer where lid="+customerID;
			String mySexTemp = EZDbUtil.getOnlyStringValue(myCustomerSQL);
			if(mySexTemp.endsWith("1"))
			{
				sex = "��";
			}
			if(mySexTemp.endsWith("2"))
			{
				sex = "Ů";
			}
		}
		
		return sex;
	}

}
