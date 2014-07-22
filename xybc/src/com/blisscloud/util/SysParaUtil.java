
package com.blisscloud.util;


import java.io.*;
import java.net.URL;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

/**
 * @author Ken.Guo
 * ��������ϵͳ����ʱ�������ļ�
 * /properties/SysParaSet.properties�Ĳ���
 */
public class SysParaUtil {
	
	public static String WEB_APP_ROOT_IP = "";
	
    //��Ʒ���ݿ����ò���
	public static String PRODUCT_DB_USER = "";
	public static String PRODUCT_DB_PWD = "";
	//֪ʶ����������
	public static String KM_DB_SQL_SERVER_URL = "";
	public static String KM_DB_SQL_SERVER_DRIVER_PATH = "";
	public static String KM_DB_SQL_SERVER_USER = "";
	public static String KM_DB_SQL_SERVER_PWD = "";
	
    //��������������
	public static String VOX_MY_SQL_URL = "";
	public static String VOX_MY_SQL_URL_DRIVER_PATH = "";
	public static String VOX_MY_SQL_URL_USER = "";
	public static String VOX_MY_SQL_URL_PWD = "";
	
	//���ϰ�֤ƽ̨���ݿ�,�ͻ����ϴ���˰�ѽӿ����ݿ�����
	public static String CUSTOMER_SYBASE_URL="";
	public static String CUSTOMER_SYBASE_DRIVER_PATH="";
	public static String CUSTOMER_SYBASE_USER="";
	public static String CUSTOMER_SYBASE_PWD="";
	
	//��Ʊ��ѯ�ӿ����ݿ�����
	public static String INVOICE_SYBASE_URL="";
	public static String INVOICE_SYBASE_DRIVER_PATH="";
	public static String INVOICE_SYBASE_USER="";
	public static String INVOICE_SYBASE_PWD="";
	
	
	//ϵͳ��ɫ����  
	public static String ROLE_FORE="";               //ǰ̨
	public static String ROLE_BACK="";               //��̨
	public static String ROLE_BIZ_EXPORT="";  	     //ҵ��ר��
	public static String ROLE_MONITOR="";  			 //�ʼ�
	public static String ROLE_OA_SYS="";  			 //OA����ϵͳ
	public static String ROLE_DIRECTOR="";  		 //����
	public static String ROLE_SECOND_DIRECTOR="";  	 //������
	public static String ROLE_RUN_MASTER="";  		 //��Ӫ����
	public static String ROLE_SECOND_RUN_MASTER="";  //����Ӫ����
	public static String ROLE_CALLER_CUSTOMER="";    //��˰��
	
	
	public static String OA_GET_MSG_FRUSH_TIME="";    //OA�Զ�ȡ������ʱ����
	public static String GET_OA_START_FLAG="";        //�Ƿ������Զ�ץȡ�����߳�
 	
	public static Properties pro=null;
	
	public SysParaUtil() {}
     
	private static void init(){
		pro=getSysProperties();
	}
	
	/**
	 * �õ�ϵͳ�йؼ��Ľ�ɫ���ñ�
	 * @return
	 */
	public static Map getRolesMap(){
		Map map=new HashMap();	
		map.put(SysParaUtil.ROLE_FORE,"ǰ̨");
		map.put(SysParaUtil.ROLE_BACK,"��̨");
		map.put(SysParaUtil.ROLE_BIZ_EXPORT,"ҵ��ר��");
		map.put(SysParaUtil.ROLE_OA_SYS,"OA����ϵͳ");
		map.put(SysParaUtil.ROLE_DIRECTOR,"����");
		map.put(SysParaUtil.ROLE_SECOND_DIRECTOR,"������");
		map.put(SysParaUtil.ROLE_RUN_MASTER,"��Ӫ����");
		map.put(SysParaUtil.ROLE_SECOND_RUN_MASTER,"����Ӫ����");
		map.put(SysParaUtil.ROLE_CALLER_CUSTOMER,"��˰��");
		return map;
	}
	public static void main(String[] args) {
		String s=SysParaUtil.ROLE_BIZ_EXPORT;
		System.out.println(s);
	}
    /**
     * Java���ṩ��һ��java.util.Properties������
     * ʹ��Properties�������Է���Ĵ�һ��.properties�����ļ��ж�ȡ���ò���
     * @param PROPERTIES_FILE
     * @return
     */
	public static Properties getProperties(String PROPERTIES_FILE) {
     Properties props = new Properties();
     try {
         URL rr=SysParaUtil.class.getResource(PROPERTIES_FILE);
         props.load(rr.openStream());
     } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
       return props;
    }
	
	public static Properties getSysProperties() {
		String pathFile="/properties/SysParaSet.properties";
	    return getProperties(pathFile);
	}
	
	/**
	 * ����key������key����Ӧ����ֵ
	 * @param key
	 * @return
	 */
	public static String  getProParaValue(String key){
		String value="";
		if(pro==null){
			init();
			System.out.println("����ϵͳ���ò���....");
		}
		value=(String)pro.get(key);
		if(value!=null){
			value=value.trim();
		}
		return value;
	}
	
	 /**
	   * ȡ��ϵͳ���ò�����ֵ
	   * @param paramName
	   * @return
	   */
	public static String getSysParamValue(String paramName)
	{
	  String sql="select t.param_value from tb_ips_sys_set t where t.param_name='"+paramName+"'";
	  String value=EZDbUtil.getOnlyStringValue(sql);
	  return value;
	}
}
