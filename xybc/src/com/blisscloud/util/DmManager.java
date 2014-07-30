package com.blisscloud.util;

import java.util.*;
import java.sql.*;

import org.hibernate.Session;

import com.blisscloud.common.Constants;
import com.blisscloud.common.StringBean;
import com.blisscloud.hibernate.HibernateUtil;

/**
 * <p>
 * Title:锟斤拷锟斤拷值锟斤拷锟�锟斤拷
 * </p>
 * <p>
 * Description:
 * </p>
 * <p>
 * Copyright: Copyright (c) 2006
 * </p>
 * <p>
 * Company:
 * </p>
 * 
 * @author not attributable
 * @version 1.0
 */

public class DmManager {
	public static final String quest_type = "quest_type";
	public static final String direct_flag = "direct_flag";
	public static final String task_status = "task_status";
	public static final String charset_type = "charset_type";
	public static final String is_inner = "is_inner";
	public static final String bill_status = "bill_status";
	public static final String area_code = "area_code";
	public static final String boolean_type = "boolean_type";
	public static final String activities_type = "activities_type";
	public static final String em_level = "em_level";
	public static final String km_file_type = "km_file_type";

	public static final String CALL_TYPE = "bill_type";
	public static final String BIZ_TYPE = "biz_type";

	public DmManager() {

	}

	public static String getZtbjOptions(String chuz) {
		String sql = "select dz.ztbj_code,dz.ztbj_name from dm_ztbj dz";
		return DmManager.getOptionsBySql(sql, chuz);
	}

	public static Map getSummryMap() {
		String sql = "select seq_id,name from dm_summary";
		return getMapBySql(sql);
	}

	/**
	 * 取锟斤拷锟斤拷锟斤拷选锟斤拷锟絆ptions锟叫憋拷 sql:select call_code,call_name from dm_call order
	 * by call_order 只锟斤拷锟斤拷锟斤拷锟街讹拷
	 * 
	 * @return
	 */
	public static String getOptionsBySql(String sql) {
		return getOptionsBySql(sql, "");
	}

	/**
	 * 锟斤拷锟侥筹拷锟窖★拷锟絢ey锟斤拷selectedOption String
	 * 
	 * @param typeKey
	 * @param selectKey
	 * @return
	 */
	public static String getSelectedOption(Hashtable myTable, String selectKey) {
		StringBuffer buffer = null;
		if (myTable != null) {
			Enumeration enum2 = myTable.keys();
			String key = "";
			String name = "";
			buffer = new StringBuffer();
			while (enum2.hasMoreElements()) {
				key = (String) enum2.nextElement();
				name = (String) myTable.get(key);
				String s = "";
				if (key.equals(selectKey)) {
					s = "selected";
				}
				buffer.append("<option value=\"" + key + "\"   " + s + ">"
						+ name + "</option> \n");
			}
		}
		return buffer.toString();
	}

	/**
	 * 锟斤拷锟侥筹拷锟窖★拷锟絢ey锟斤拷selectedOption String
	 * 
	 * @param typeKey
	 * @param selectKey
	 * @return
	 */
	public static String getSelectedOption(List list, String selectKey) {
		StringBuffer buffer = new StringBuffer();
		if (list != null) {
			Iterator enum2 = list.iterator();
			StringBean info = null;
			while (enum2.hasNext()) {
				info = (StringBean) enum2.next();
				String s = "";
				if (info.getKey().equals(selectKey)) {
					s = "selected";
				}
				buffer.append("<option value=\"" + info.getKey() + "\"   " + s
						+ ">" + info.getValue() + "</option> \n");
			}
		}
		return buffer.toString();
	}

	/**
	 * 锟斤拷锟侥筹拷锟窖★拷锟絢ey锟斤拷selectedOption String
	 * 
	 * @param typeKey
	 * @param selectKey
	 * @return
	 */
	public static String getSelectedOptionByArray(List list, String selectKey) {
		StringBuffer buffer = new StringBuffer();
		if (list != null) {
			Iterator enum2 = list.iterator();
			Object[] info = null;
			while (enum2.hasNext()) {
				info = (Object[]) enum2.next();
				String s = "";
				if (info[0].equals(selectKey)) {
					s = "selected";
				}
				buffer.append("<option value=\"" + info[0] + "\"   " + s + ">"
						+ info[1] + "</option> \n");
			}
		}
		return buffer.toString();
	}

	/**
	 * 取锟矫伙拷锟斤拷锟斤拷锟斤拷Options
	 * 
	 * @return
	 */
	public static String getCallTypeOptions(String selCalltype) {
		return DmManager.getOptionByType(DmManager.CALL_TYPE, selCalltype);
	}

	/**
	 * 取锟矫伙拷锟斤拷锟斤拷锟斤拷Options
	 * 
	 * @return
	 */
	public static String getOptionByType(String mainType, String selKey) {
		String sql = "select t.out_code,t.name from tb_accttype t where t.maintype='"
				+ mainType + "' order by t.ordernum";
		return getOptionsBySql(sql, selKey);
	}

	/**
	 * 取锟斤拷某锟斤拷锟斤拷锟斤拷锟节的碉拷锟斤拷锟铰碉拷锟斤拷员锟叫憋拷
	 * 
	 * @param local_no
	 * @param selUser
	 * @return
	 */
	public static String getUserOptions(String local_no, String selUser) {
		String sql = "";
		StringBuffer buffer = new StringBuffer();
		buffer.append("select t.user_id,t.name from user_account t  where local_no='"
				+ local_no + "' and t.is_Use='" + Constants.USE_TRUE + "'");
		sql = buffer.toString();
		return getOptionsBySql(sql, selUser);
	}

	/**
	 * 取锟斤拷某锟斤拷锟斤拷锟斤拷锟节的碉拷锟斤拷锟铰碉拷锟斤拷员锟叫憋拷(锟斤拷锟斤拷锟斤拷模锟斤拷)
	 * 
	 * @param selUser
	 * @return
	 */
	public static String getUserListener(String localNo, String selUser) 
	{
		if (selUser != null)
			selUser = selUser.trim();
		String sql = "";
		String roles = SysParaUtil.ROLE_FORE + "," + SysParaUtil.ROLE_BACK;
		StringBuffer buffer = new StringBuffer();
		buffer.append("select distinct b.user_id, b.name  from user_account b left join v_employee t on b.user_id = t.use_id where b.local_no = '"
				+ localNo + "'  and t.roleid in (" + roles + ")");
		sql = buffer.toString();
		System.out.println(sql);
		return getOptionsBySql(sql, selUser);
	}

	/**
	 * 取锟矫碉拷锟斤拷Options
	 * 
	 * @return
	 */
	public static String getAreaOptions(String selArea) {
		return DmManager.getOptionByType("area_code", selArea);
	}

	/**
	 * 取锟矫诧拷锟斤拷锟斤拷锟斤拷Options
	 */
	public static String getDepartmentOptions(String selDept) {
		String PRODUCT_DB_USER = SysParaUtil.PRODUCT_DB_USER;
		String sql = "select tbdept.lid,tbdept.strname from " + PRODUCT_DB_USER
				+ ".tb000000department tbdept";
		return getOptionsBySql(sql, selDept);
	}

	/**
	 * 取锟矫伙拷锟斤拷锟斤拷锟斤拷Options
	 * 
	 * @return
	 */
	public static String getBizTypeOptions(String selBizType) {
		return DmManager.getOptionByType(DmManager.BIZ_TYPE, selBizType);
	}

	/**
	 * 取锟矫伙拷锟斤拷锟斤拷锟斤拷Options
	 * 
	 * @return
	 */
	public static String getBizTypeOptions() {
		String sql = "select biz_code,biz_name from dm_biz  order by biz_order";
		return getOptionsBySql(sql);
	}

	/**
	 * 取锟斤拷某锟斤拷锟斤拷锟斤拷锟铰碉拷业锟斤拷锟斤拷锟斤拷Options
	 * 
	 * @return
	 */
	public static String getBizOptionsByLocal(String localNo, String selKey) {
		if (localNo == null || "".equals(localNo) || "null".equals(localNo)) {
			return "";
		}
		String sql2 = "select a.out_code,a.name from tb_accttype a "
				+ "left join set_biz_permit t on a.ordernum=t.biz_type "
				+ "where t.local_no='" + localNo.trim()
				+ "' and a.maintype='biz_type' order by a.ordernum";
		String optionList = DmManager.getOptionsBySql(sql2, selKey);
		return optionList;
	}

	/**
	 * 取锟矫伙拷锟斤拷锟斤拷锟斤拷Options
	 * 
	 * @return
	 */
	public static String getCallTypeOptions() {
		return DmManager.getOptionByType(DmManager.CALL_TYPE, "");
	}

	/**
	 * 取锟斤拷锟斤拷锟斤拷选锟斤拷锟絆ptions锟叫憋拷 sql:select call_code,call_name from dm_call order
	 * by call_order 只锟斤拷锟斤拷锟斤拷锟街讹拷
	 * 
	 * @return
	 */
	public static String getOptionsBySql(String sql, String selKey) {
		StringBuffer buffer = new StringBuffer();
		Connection con = null;
		Statement pt = null;
		ResultSet rs = null;
		Session session = HibernateUtil.currentSession();
		try {
			con = session.connection();
			pt = con.createStatement();
			rs = pt.executeQuery(sql);
			if (rs != null) {
				String key = "";
				while (rs.next()) {
					key = rs.getString(1);
					String sel = "";
					if (key != null) {
						if (key.equals(selKey)) {
							sel = "selected";
						}
					}
					buffer.append("<option value='" + rs.getString(1) + "'   "
							+ sel + "  >" + rs.getString(2) + "</option> \n");
				}
			}

		} catch (SQLException e) {
			System.out.println("getOptionsBySql==>" + sql);
			e.printStackTrace();
		} finally {
			DbUtil.closeInfo(con, pt, rs);
			HibernateUtil.closeSession();
		}
		return buffer.toString();
	}

	/**
	 * 取锟斤拷锟斤拷锟斤拷值锟斤拷锟秸憋拷
	 * 
	 * @param sql
	 * @return
	 */
	public static Map getDmMap(String sql) {
		return getMapBySql(sql);
	}

	/**
	 * 取锟斤拷锟斤拷锟斤拷值锟斤拷锟秸憋拷
	 * 
	 * @param sql
	 * @return
	 */
	public static Map getDmMapByType(String type) {
		String sql = "select t.out_code,t.name from tb_accttype t where t.maintype='"
				+ type + "'";
		return getMapBySql(sql);
	}

	/**
	 * 取锟斤拷锟斤拷锟斤拷值锟斤拷锟秸憋拷
	 * 
	 * @param sql
	 * @return
	 */
	public static Map getMapBySql(String sql) {
		Map map = new HashMap();
		Connection con = null;
		Statement pt = null;
		ResultSet rs = null;
		Session s = HibernateUtil.currentSession();
		try {
			con = s.connection();
			pt = con.createStatement();
			rs = pt.executeQuery(sql);
			if (rs != null) {
				String key = "";
				while (rs.next()) {
					key = rs.getString(1);
					if (key != null) {
						key = key.trim();
						map.put(key, rs.getString(2));
					}
				}
			}
		} catch (SQLException e) {
			System.out.println("getMapBySql==>" + sql);
			e.printStackTrace();
		} finally {
			DbUtil.closeInfo(con, pt, rs);
			HibernateUtil.closeSession();
		}
		return map;
	}

	public static String getAreaName(String selArea) {
		return getLabelName("area_code", selArea);
	}

	public static String getLabelName(String mainType, String selArea) {
		String sql = "select t.name from tb_accttype t where t.maintype='"
				+ mainType + "'and t.out_code='" + selArea
				+ "' order by t.ordernum";
		String str = DbUtil.getOnlyStringValue(sql);
		return str;
	}

	public static String getBackUser(String callId, String seluserId) {
		String sql = "select a.employee,d.strname from flow_task a ,flow_instances b , bill c ,"
				+ SysParaUtil.PRODUCT_DB_USER
				+ ".tb000000employee d where a.instances_id=b.instances_id(+) and b.bill_id=c.bill_no(+) and c.call_id="
				+ callId
				+ " and a.employee=d.strloginid and a.roleno="
				+ SysParaUtil.ROLE_BACK;
		return getOptionsBySql(sql, seluserId);
	}

	/**
	 * 锟斤拷莼锟斤拷锟揭碉拷锟斤拷锟叫★拷锟�
	 * 
	 * @param call_type
	 * @param biz_type
	 * @return
	 */
	public static String getSumBycall_biz(String call_type, String biz_type,
			String sum) {
		String sql = "select seq_id,name from dm_summary a where a.parent_id in (select b.sum_root  from set_sum_root  b where 1=1";
		if (!"full".equals(call_type) && call_type != null)
			sql = sql + " and call_type='" + call_type + "'";
		if (!"full".equals(biz_type) && biz_type != null)
			sql = sql + " and biz_type='" + biz_type + "'";
		sql = sql + ")";
		if (call_type == null && biz_type == null)
			return "";
		if ("full".equals(call_type) && "full".equals(biz_type))
			return "";
		return getOptionsBySql(sql, sum);
	}

}
