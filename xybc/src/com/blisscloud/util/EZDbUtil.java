/**
 * 
 */
package com.blisscloud.util;

import java.io.*;
import java.sql.*;
import java.util.*;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.Session;
import org.hibernate.Transaction;


import com.blisscloud.common.StringBean;
import com.blisscloud.hibernate.EZHibernateUtil;

import jxl.Sheet;
import jxl.Workbook;

/**
 * @author Administrator
 * Ken.guo
 */
public class EZDbUtil {
	private static Log log = LogFactory.getLog(EZDbUtil.class);
	public EZDbUtil() {
	}

	public static String getCountSql(String querySql){
		String countSql="select count(0) as recordNum from ("+
															querySql+
														   ") as mycount";
		//int start=querySql.indexOf("from");
		//countSql=countSql+" "+querySql.substring(start);
		return  countSql;
	}
	
	/**
	 * ���һ���ֵ�ԵĶ����Є1�7��һ��������ΪKey���ڶ����ֶ�����value
	 * @param sql
	 * @return
	 */
	public static List getAttList(String sql){
		List list=null;
		 Connection con=null;
		 Statement pt=null;
		 ResultSet rs=null;
		 Session s=EZHibernateUtil.currentSession();
		 try {
			con=s.connection();
			pt=con.createStatement();
			rs=pt.executeQuery(sql);
				if(rs!=null){
					list=new ArrayList();
					while(rs.next()){
					 list.add(new StringBean(rs.getString(1),rs.getString(2)));
					}
				}

			} catch (SQLException e) {
				e.printStackTrace();
			}finally{
				EZDbUtil.closeInfo(con,pt,rs);
				EZHibernateUtil.closeSession();
			}
			return list;

	}
	
   /**
	*��ȡ�������Ե��б� 
	*/
   public static List getSingleAttList(String sql){
		List list=null;
		 Connection con=null;
		 Statement pt=null;
		 ResultSet rs=null;
		 Session s=EZHibernateUtil.currentSession();
		 try {
			con=s.connection();
			pt=con.createStatement();
			rs=pt.executeQuery(sql);
				if(rs!=null){
					list=new ArrayList();
					while(rs.next()){
					 list.add(rs.getString(1));
					}
				}

			} catch (SQLException e) {
				e.printStackTrace();
			}finally{
				EZDbUtil.closeInfo(con,pt,rs);
				EZHibernateUtil.closeSession();
			}
			return list;
	}
	
    		
	 /**
	  *ȡ��һ�������б� 
	  */
	 public static List getPropertyList(String sql){
			 List list=null;
			 Connection con=null;
			 Statement st=null;
			 ResultSet rs=null;
			 Session session=EZHibernateUtil.currentSession();
			 try {
				con=session.connection();
				st=con.createStatement();
				rs=st.executeQuery(sql);
				if(rs!=null){
				    ResultSetMetaData meta=rs.getMetaData();
					int colCount=rs.getMetaData().getColumnCount();
						list=new ArrayList();
						Properties pro=null;
						while(rs.next()){
						 pro=new Properties();
						 for(int k=1;k<colCount+1;k++){
							 String colName=meta.getColumnName(1);
							 pro.put(colName, rs.getString(colName));
						 }
						 list.add(pro);
						}
					}

				} catch (SQLException e) {
					e.printStackTrace();
				}finally{
					EZDbUtil.closeInfo(con,st,rs);
					EZHibernateUtil.closeSession();
				}
				return list;
		}
	 
	 /**
	  * ���sql��ȡ��һ���ַ�������бￄ1�7
	  * @param sql
	  * @return
	  */
	 public static List getStringArrayList(String sql){
		 List list=null;
		 Connection con=null;
		 Statement st=null;
		 ResultSet rs=null;
		 Session session=EZHibernateUtil.currentSession();
		 try {
			con=session.connection();
			st=con.createStatement();
			rs=st.executeQuery(sql);
			if(rs!=null){
			  	int colCount=rs.getMetaData().getColumnCount();
				   String[] s=null;
					list=new ArrayList();
					while(rs.next()){
						 s=new String[colCount];
						 for(int k=0;k<colCount;k++){
						 s[k]=rs.getString(k+1);
					 }
					 list.add(s);
					}
				}

			} catch (SQLException e) {
				LogUtil.log.info("errorSql==>"+sql,e);
		 	}finally{
				EZDbUtil.closeInfo(con,st,rs);
				EZHibernateUtil.closeSession();
			}
			return list;
	}
	 
	 /**
	  * ���sql��ȡ��һ���ַ�������бￄ1�7
	  * @param sql
	  * @return
	  */
	 public static String[] getSingleArrayList(String sql){
		 String[] s=null;
		 Connection con=null;
		 Statement st=null;
		 ResultSet rs=null;
		 Session session=EZHibernateUtil.currentSession();
		 try {
			con=session.connection();
			st=con.createStatement();
			rs=st.executeQuery(sql);
			if(rs!=null){
			    ResultSetMetaData meta=rs.getMetaData();
				int colCount=rs.getMetaData().getColumnCount();
					if(rs.next()){
						 s=new String[colCount];
						 for(int k=0;k<colCount;k++){
							 String colType = rs.getMetaData().getColumnTypeName(k+1);
							 if("DATE".equals(colType)){
								 s[k]=DateUtil.dateToString(rs.getDate(k+1))+" "+String.valueOf(rs.getTime(k+1));
							 }else{
								 s[k]=rs.getString(k+1);
							 }
					 }
					}
				}

			} catch (SQLException e) {
				e.printStackTrace();
			}finally{
				EZDbUtil.closeInfo(con,st,rs);
				EZHibernateUtil.closeSession();
			}
			return s;
	}
	 

	 /**
      * ִ��һ��sql��ￄ1�7.
      * @param sql
      * @return
      */
     public static  boolean  runSql(String sql){
       boolean ok=false;
       Connection con=null;
       Statement st=null;
       Session session=EZHibernateUtil.currentSession();
       Transaction tx = session.beginTransaction();
       try {
         con =session.connection();
         st = con.createStatement();
         st.execute(sql);
         tx.commit();
         ok=true;
       }
       catch (SQLException ex) {
         ex.printStackTrace();
         tx.rollback();
         System.out.println("runSql Error==>"+sql);
       }finally{
          closeInfo(con,st);
          EZHibernateUtil.closeSession();
        }
       return ok;
     }
     
     /**
      * ͨ��JDBCl����ݿￄ1�7
      * @param url
      * @param usr
      * @param pwd
      * @param drv
      * @return
      */
     public static Connection getConnByJDBC(String url,String usr,String pwd,String drv){
 		Connection conn = null;
 		//��ȡ����
 		try {
 			Class.forName(drv);
 			conn = DriverManager.getConnection(url, usr, pwd);
 		} catch (Exception e) {
 			log.trace("usr="+usr+";pwd="+pwd+";drv="+drv,e);
 		} 
 		return conn;
 	}
     
	    /**
		 * �ر���ݿ����
		 * @param con
		 * @param st
		 * @param rs
		 */
		public static void closeInfo(Connection con,Statement st,ResultSet rs){
			/* disable by jeton.dong 
			try {if(rs!=null){rs.close();rs=null;}} catch (SQLException e) {e.printStackTrace();}
			try {if(st!=null){st.close();st=null;}} catch (SQLException e) {e.printStackTrace();}
			try {if(con!=null){con.close();con=null;}} catch (SQLException e) {e.printStackTrace();}
			*/
		}

		/**
		 * �ر���ݿ����
		 * @param con
		 * @param st
	     */
		public static void closeInfo(Connection con,Statement st){
			/* disable by jeton.dong 
			try {if(st!=null){st.close();st=null;}} catch (SQLException e) {e.printStackTrace();}
			try {if(con!=null){con.close();con=null;}} catch (SQLException e) {e.printStackTrace();}
			*/
		}
		/**
		 * �ر���ݿ����
		 * @param rs
		
	     */
		public static void closeInfo(ResultSet rs){
			/* disable by jeton.dong 
			try {if(rs!=null){rs.close();rs=null;}} catch (SQLException e) {e.printStackTrace();}
			*/
		}
		 /**
		  * ���sql��ȡ��һ���ַ�������бￄ1�7
		  * @param sql
		  * @return
		  */
		 public static String getOnlyStringValue(String sql){
			String str="";
			Connection con=null;
			 Statement st=null;
			 ResultSet rs=null;
			 Session session=EZHibernateUtil.currentSession();
			 try {
				con=session.connection();
				st=con.createStatement();
				rs=st.executeQuery(sql);
				if(rs!=null){
						if(rs.next()){
							str=rs.getString(1);
						 }
					}
				} catch (SQLException e) {
					e.printStackTrace();
					System.out.println("getOnlyStringValueSql==>"+sql);
				}finally{
					EZDbUtil.closeInfo(con,st,rs);
					EZHibernateUtil.closeSession();
				}
            return str;
		}
		 
		 
		 /**
		   * 
		   * @param sSQL
		   * @return
		   */
		  public static Map getMapQuery(String sSQL){
			  	Connection con=null;
			    Statement st=null;
			    ResultSet rs=null;
			    Session session=EZHibernateUtil.currentSession();
			  	Map map = new HashMap();
				  try{
					  con=session.connection();
					  st=con.createStatement();
					  rs=st.executeQuery(sSQL);
						if(rs!=null){
							while(rs.next()){
				        		map.put(rs.getObject(1),rs.getObject(2));
				        	}
						}
			      }catch(SQLException e){
			    	  e.printStackTrace();
					  System.out.println("getMapQuery==>"+sSQL);
			      }finally{
			    	  EZDbUtil.closeInfo(con,st,rs);
				      EZHibernateUtil.closeSession();
			      }
			    return map;
			  }
		  
		  /**
		   * 
		   * @param sSQL
		   * @return
		   */
		  public static LinkedHashMap getLinkMapQuery(String sSQL){
			  	Connection con=null;
			    Statement st=null;
			    ResultSet rs=null;
			    Session session=EZHibernateUtil.currentSession();
			    LinkedHashMap map = new LinkedHashMap();
				  try{
					  con=session.connection();
					  st=con.createStatement();
					  rs=st.executeQuery(sSQL);
						if(rs!=null){
							while(rs.next()){
				        		map.put(rs.getObject(1),rs.getObject(2));
				        	}
						}
			      }catch(SQLException e){
			    	  e.printStackTrace();
					  System.out.println("getMapQuery==>"+sSQL);
			      }finally{
			    	  EZDbUtil.closeInfo(con,st,rs);
				      EZHibernateUtil.closeSession();
			      }
			    return map;
			  }
		  
		 
		    /**
			 * ���seq���ȡ���µ�seq��
			 * @param seqName
			 * @return
			 */
		    public static  String   getLastNumBySeqName(String seqName){
				String lastSeq="";
				Connection con=null;
			    Statement st=null;
			    ResultSet rs=null;
			    String sql="select nextval('"+seqName+"') ";
			    Session session=null;
			    try {
			      session=EZHibernateUtil.currentSession();
			      con =session.connection();
			      st = con.createStatement();
			      rs=st.executeQuery(sql);
			      if(rs!=null){
			    	  if(rs.next()){
			    		  lastSeq=rs.getString(1); 
			    	  }
			      }
			     
			    }catch (SQLException ex) {
			    System.out.println("first not get mySeq.");
			    }finally {
			    	EZDbUtil.closeInfo(con,st,rs);
			        EZHibernateUtil.closeSession();
				}
			   return lastSeq;
			}
		    
		    /**
			 * ���seq���ȡ���µ�seq��
			 * @param seqName
			 * @return
			 */
		    public static  String   getSeperateValue(String sql,String seperator){
				String rtv="";
				Connection con=null;
			    Statement st=null;
			    ResultSet rs=null;
			    Session session=null;
			    try {
			      session=EZHibernateUtil.currentSession();
			      con =session.connection();
			      st = con.createStatement();
			      rs=st.executeQuery(sql);
			      if(rs!=null){
			    	  StringBuffer buffer=new StringBuffer();
			    	  String value="";
						while(rs.next()){
							value=rs.getString(1); 
							buffer.append(value+seperator);
						}
						rtv=buffer.toString();
						if(rtv!=null&&!"".equals(rtv)){
							if(rtv.endsWith(seperator)){
								rtv=rtv.substring(0,rtv.length()-seperator.length());
							}
						}
						
			      }
			     
			     }catch (SQLException ex) {
			    ex.printStackTrace();
			    }finally {
			    	EZDbUtil.closeInfo(con,st,rs);
			        EZHibernateUtil.closeSession();
			  }
			   return rtv;
			}
		   
		    /**
		     * ��ݵ�¼��lid�õ���ǰ��¼�������Ӳ���id
		     * @param lEmployeeID
		     * @return ��","�ָ�������Ӳ���id
		     */
			public static  String getChildDepIDs(String lEmployeeID){
				String rtv="";	//����ֵ
				//���lEmployeeID�õ����������µ������Ӳ���ID
				String tmpSQL="select emp.ldepartmentid from tb000000employee emp "+
						   		"where emp.lid="+lEmployeeID;
				String sql="select t.lid "+
						   "from tb000000department t "+
						   "where t.lid!=("+tmpSQL+") "+
						   "start with t.lid=(" 
						   		+tmpSQL+
						   ") "+
						   "connect by prior t.lid=t.lparentid";	
				Connection con=null;
			    Statement st=null;
			    ResultSet rs=null;
			    Session session=null;
			    try {
			      session=EZHibernateUtil.currentSession();
			      con =session.connection();
			      st = con.createStatement();
			      rs=st.executeQuery(sql);
			      if(rs!=null){
			    	  StringBuffer buffer=new StringBuffer();
			    	  String value="";
						while(rs.next()){
							value=rs.getString(1); 
							buffer.append(value+",");
						}
						rtv=buffer.toString();
						if(rtv!=null&&!"".equals(rtv)){
							if(rtv.endsWith(",")){
								rtv=rtv.substring(0,rtv.length()-",".length());
							}
						}
						
			      }
			     }catch (SQLException ex) {
			    ex.printStackTrace();
			    }finally {
			    	EZDbUtil.closeInfo(con,st,rs);
			        EZHibernateUtil.closeSession();
			  }
			   return rtv;
			}
			
			/**
		     * ��ݵ�¼��lid�õ���ǰ��¼�������Ӳ���Ա��id
		     * @param lEmployeeID
		     * @return ��","�ָ�������Ӳ���Ա��id
		     */
			public static  String getChildEmpIDs(String lEmployeeID){
				String rtv="";	//����ֵ
				String depIDs = getChildDepIDs(lEmployeeID);
				//��û���Ӳ���ֻ��ѯ�Լ�����ￄ1�7
				if(StringUtil.isNullOrEmpty(depIDs)){
					rtv=lEmployeeID;
					return rtv;
				}
				//���lEmployeeID�õ����������µ�����Ա��ID
				String sql="select emp.lid from tb000000employee emp "+
						   "where emp.ldepartmentid in ("+depIDs+")";	
				Connection con=null;
			    Statement st=null;
			    ResultSet rs=null;
			    Session session=null;
			    try {
			      session=EZHibernateUtil.currentSession();
			      con =session.connection();
			      st = con.createStatement();
			      rs=st.executeQuery(sql);
			      if(rs!=null){
			    	  StringBuffer buffer=new StringBuffer();
			    	  String value="";
						while(rs.next()){
							value=rs.getString(1); 
							buffer.append(value+",");
						}
						rtv=buffer.toString();
						if(rtv!=null&&!"".equals(rtv)){
							if(rtv.endsWith(",")){
								rtv=rtv.substring(0,rtv.length()-",".length());
							}
						}
						
			      }
			     }catch (SQLException ex) {
			    ex.printStackTrace();
			    }finally {
			    	EZDbUtil.closeInfo(con,st,rs);
			        EZHibernateUtil.closeSession();
			  }
			   //��ѯ��������Ա������ǰ�鳤��������Ϣ
			   if(rtv!=null&&!"".equals(rtv)){
				   rtv +=","+lEmployeeID;
			   } 
			   return rtv;
			}
			/**
			 * ɾ��ezqform_user�����ظ��ύ���ʾ���lclientid
			 *
			 */
			public static void delQFormMultiRecord(){
				//1����ѯ�Ƿ����ظ��ύ���ʾ�
				String hasMultiSQL = "select b.lclientid from ( "+
										 	"select t.lclientid,count(t.lclientid) as myrec from ezqform_user t "+
										 	"where t.nisdelete=0 "+
										 	"group by t.lclientid "+
										") b "+
                                     "where b.myrec>1";
				List MultiNumList = getStringArrayList(hasMultiSQL);
				//2��ɾ�������ύ���ʾ���Ϣ,��������ύ���ʾ���lclientid
				if(MultiNumList!=null&&MultiNumList.size()>0){
				      for(int i=0;i<MultiNumList.size();i++){
				    	  Object[] s =(Object[])MultiNumList.get(i);
				    	  String lid = String.valueOf(s[0]); //�������lid
				    	  //��ѯ�����ύ�ʾ�strID
				    	  String strIDSQL="select strid from ezqform_user equ where equ.nisdelete=0 and equ.lclientid="+lid;
				    	  String strID = getOnlyStringValue(strIDSQL);
				    	  //αɾ�������ύ���ʾ�strID,����ezqform_user��nisdeleteΪ1
				    	  String delIDSQL="update ezqform_user equ "+
				    	  					"set equ.nisdelete=1 "+
				    	  				   "where equ.strid="+strID;
				    	  //System.out.println(""+delIDSQL);
				    	  runSql(delIDSQL);
				      }
				}	
			}
			/**
			 * ��ݵ�ǰ��ϯLID��ȡ��ϯ����
			 * @param lID
			 * @return
			 */
			
			public static String getAgentName(String lID){
				//lIDΪ��ʱ
				if(StringUtil.isNullOrEmpty(lID)){
					return "";
				}
				String agentName = "";
				String sql = "select emp.strname from tb000000employee emp where emp.lid="+lID;
				agentName = getOnlyStringValue(sql);
				return agentName;
			}

			public static void main(String[] args) 
			{
//				String pathID = "1242876451.40";
//				String tmp = getSumPath(pathID);
//				System.out.println("tmp--->"+tmp);
				
				String pathID = "140";
				String tmp = getSumPathById(pathID);
				System.out.println("tmp--->"+tmp);
			}
			
			/**
			   * ѭ����ȡExcel�ļ����ݽ��䵼�����ݿ���
			   * @param fileName ѭ����ȡExcel�ļ�
			   * @throws SQLException 
			   */
				public static int importToDB(String fileName,String campaignListID) throws SQLException{
					int procFlag = 0;
					List list=null;
					Connection con=null;
					Statement pt=null;
					ResultSet rs=null;
					PreparedStatement pstmt  = null;		//PreparedStatement
					Session s=EZHibernateUtil.currentSession();
					//1��Excel�ļ�·��
					//System.out.println("---->"+StringTools.getTimeDir());
					String excelFilePath = StringTools.getTimeDir();			//upload path
					String strSQL = "insert into tb_ips_autocampaignlist(seqid,telephone,campaignlistid) "+
									" values(nextval('SEQ_TB_IPS_AUTOCAMPAIGNLIST'),?,"+campaignListID+")";
					
					//�õ�excel�ļ�����
					Workbook wb = null;
					InputStream is = null;
					Sheet sheet = null;
					String content = "";
					try{
						con=s.connection();
						con.setAutoCommit(false);
						content = "";
						is = new FileInputStream(excelFilePath+fileName);
						wb = Workbook.getWorkbook(is);				//Workbook
						int sheetNums = wb.getNumberOfSheets();		//Workbook��sheet����
						String[] sheetNames = wb.getSheetNames();	//Workbook��sheet����
						for(int k = 0;k < sheetNums;k++)
						{
							int tmp = k+1;
							pstmt = con.prepareStatement(strSQL);
							
							sheet = wb.getSheet(k);						//sheet �±��0��ʼ
							int sheetRows = sheet.getRows();			//sheet������
							int sheetColumns = sheet.getColumns();		//sheet������
							
							if(sheetRows>1){
								log.info("��ʼ����"+sheetNames[k]+"......");
								//�ӵڶ��п�ʼ������(���һ��Ϊ����)
								for(int i=1;i<sheetRows ;i++){	
									for(int j=0;j<sheetColumns ;j++){					  				
										content = sheet.getCell(j,i).getContents();
										if(StringUtil.isNullOrEmpty(content))
										{
											content = "";
										}else
										{
											content = content.trim();
										}
										//��excel��Ԫ���е����ݲ��������ݿ��� 
										pstmt.setObject(j+1,content);
									}
									//pstmt.addBatch();	//������������
									pstmt.execute();
								}
									//pstmt.executeBatch();	//ִ��pstmt	
									con.commit();
									log.info(sheetRows-1+"�����ݱ�����!");
							}//endif	
						}
					}catch(Exception e){
						procFlag=10;
						log.error(e.toString());
					}finally{
						try{
							if(wb != null)wb.close();
							if(is != null)is.close();
							EZDbUtil.closeInfo(con,pt,rs);
							EZHibernateUtil.closeSession();
						}catch(Exception e){
							log.error(e.toString());
						}
					}
					return procFlag;
				}
				
				
				/**
				   * ѭ����ȡExcel�ļ����ݽ��䵼�����ݿ���
				   * @param fileName ѭ����ȡExcel�ļ�
				   * @throws SQLException 
				   */
					public static int importToDBForWin(String fileName,String campaignListID) throws SQLException{
						int procFlag = 0;
						List list=null;
						Connection con=null;
						Statement pt=null;
						ResultSet rs=null;
						PreparedStatement pstmt  = null;		//PreparedStatement
						Session s=EZHibernateUtil.currentSession();
						//1��Excel�ļ�·��
						//System.out.println("---->"+StringTools.getTimeDir());
						String excelFilePath = StringTools.getTimeDir();			//upload path
						String strSQL = "insert into tb_ips_autocampaignlist(seqid,telephone,campaignlistid) "+
										" values(nextval('SEQ_TB_IPS_AUTOCAMPAIGNLIST'),?,"+campaignListID+")";
						
						//�õ�excel�ļ�����
						Workbook wb = null;
						InputStream is = null;
						Sheet sheet = null;
						String content = "";
						try{
							con=s.connection();
							con.setAutoCommit(false);
							content = "";
							is = new FileInputStream(excelFilePath+fileName);
							wb = Workbook.getWorkbook(is);				//Workbook
							int sheetNums = wb.getNumberOfSheets();		//Workbook��sheet����
							String[] sheetNames = wb.getSheetNames();	//Workbook��sheet����
							for(int k = 0;k < sheetNums;k++)
							{
								int tmp = k+1;
								pstmt = con.prepareStatement(strSQL);
								
								sheet = wb.getSheet(k);						//sheet �±��0��ʼ
								int sheetRows = sheet.getRows();			//sheet������
								int sheetColumns = sheet.getColumns();		//sheet������
								
								if(sheetRows>1){
									log.info("��ʼ����"+sheetNames[k]+"......");
									//�ӵڶ��п�ʼ������(���һ��Ϊ����)
									for(int i=1;i<sheetRows ;i++){	
										for(int j=0;j<sheetColumns ;j++){					  				
											content = sheet.getCell(j,i).getContents();
											if(StringUtil.isNullOrEmpty(content))
											{
												content = "";
											}else
											{
												content = content.trim();
											}
											//��excel��Ԫ���е����ݲ��������ݿ��� 
											pstmt.setObject(j+1,content);
										}
										pstmt.addBatch();	//������������
									}
										pstmt.executeBatch();	//ִ��pstmt	
										con.commit();
										log.info(sheetRows-1+"�����ݱ�����!");
								}//endif	
							}
						}catch(Exception e){
							procFlag=10;
							log.error(e.toString());
						}finally{
							try{
								if(wb != null)wb.close();
								if(is != null)is.close();
								EZDbUtil.closeInfo(con,pt,rs);
								EZHibernateUtil.closeSession();
							}catch(Exception e){
								log.error(e.toString());
							}
						}
						return procFlag;
					}
					/**
					 * ����interactionIDȡ�����������·��
					 * @param interactionID
					 * @return
					 */
					public static String getSumPath(Object interactionID)
					{
						String mySumPath = "";
						String pathSQL = "";
						if(interactionID == null)
						{
							return mySumPath;
						}else
						{
							//��������
							String reasonTypeSQL = " select ltypeid,strname               "+
												   " from tb000000summary sm              "+
												   " left join tb000000interview intv     "+
												   "    on intv.strreasontype::int=sm.lid "+
												   " left join tb000000contact cont       "+
												   "	on cont.lid=intv.lcontactid       "+
												   " where intv.strreasontype is not null "+
												   "      and intv.lcontactid>0           "+
												   "      and cont.strinteractionid='"+interactionID+"'";
							List reasonList = EZDbUtil.getStringArrayList(reasonTypeSQL);
							for(int i = 0;i< reasonList.size();i++)
							{
								Object[] s =(Object[])reasonList.get(i);
								if(s!=null)
								{
									String reasonType =	String.valueOf(s[0]);
									String reasonName = String.valueOf(s[1]);
									pathSQL = "select getMySummaryPath('"+reasonType+"','->')";
									String myPath = EZDbUtil.getOnlyStringValue(pathSQL);
									if(!StringUtil.isNullOrEmpty(myPath))
									{
										mySumPath += myPath+reasonName+";";
									}
								}
							}
						}
						return mySumPath;
					}
					/**
					 * ���ݵ绰С���ĩ�ڵ�ȡ�����������·��
					 * @param interactionID
					 * @return
					 */
					public static String getSumPathById(Object summaryId)
					{
						String mySumPath = "";
						String pathSQL = "";
						if(summaryId == null)
						{
							return mySumPath;
						}else
						{
							//��������
							String reasonTypeSQL = " select ltypeid,strname "+
												   " from tb000000summary   "+
												   " where lid ='"+summaryId+"'";
							List reasonList = EZDbUtil.getStringArrayList(reasonTypeSQL);
							for(int i = 0;i< reasonList.size();i++)
							{
								Object[] s =(Object[])reasonList.get(i);
								if(s!=null)
								{
									String reasonType =	String.valueOf(s[0]);
									String reasonName = String.valueOf(s[1]);
									pathSQL = "select getMySummaryPath('"+reasonType+"','->')";
									String myPath = EZDbUtil.getOnlyStringValue(pathSQL);
									if(!StringUtil.isNullOrEmpty(myPath))
									{
										mySumPath += myPath+reasonName;
									}
								}
							}
						}
						return mySumPath;
					}
					
					/**
					 * ���ݲ�ƷIDȡ�ò�Ʒ��·��
					 * @param interactionID
					 * @return
					 */
					public static String getProductPathById(Object productId)
					{
						String myProductPath = "";
						String pathSQL = "";
						if(productId == null)
						{
							return myProductPath;
						}else
						{
							//��Ʒ����
							String productTypeSQL = " select ltypeid,strname "+
												    " from tb000000product   "+
												    " where lid ='"+productId+"'";
							List productTypeList = EZDbUtil.getStringArrayList(productTypeSQL);
							for(int i = 0;i< productTypeList.size();i++)
							{
								Object[] s =(Object[])productTypeList.get(i);
								if(s!=null)
								{
									String productType =	String.valueOf(s[0]);
									String productName = String.valueOf(s[1]);
									pathSQL = "select getMyProductPath('"+productType+"','->')";
									String myPath = EZDbUtil.getOnlyStringValue(pathSQL);
									if(!StringUtil.isNullOrEmpty(myPath))
									{
										myProductPath += myPath+productName;
									}
								}
							}
						}
						return myProductPath;
					}
					
}
