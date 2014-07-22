package com.blisscloud.util;

import java.sql.*;
import java.util.*;
import java.io.Reader;
import java.io.BufferedReader;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

public class JDBCConn {
	
  private  String hostIP   			=  "";		//����IP
  private  String hostPort 			=  "";		//���ݿ�˿�
  private  String instanse 			=  "";		//���ݿ�ʵ��
  private  String url      			=  "";		//���ݿ������ַ���
  private  String username 			=  "";		//���ݿ��û���
  private  String password 			=  "";		//���ݿ�����
  private  ResultSet rs    			= null;		//Resultset
  private  Connection conn 			= null;		//Connection
  private  Statement stmt  			= null;		//Statement
  private  List resultList 			= null;		//����б�
  private  PreparedStatement pstmt  = null;		//PreparedStatement
  private  CallableStatement  cstmt = null;		//CallableStatement
  
  private Log JDBCConnLog = LogFactory.getLog(JDBCConn.class);	//��־��
  
  public JDBCConn() {
	  
	  //�����ļ��м�ȡ���ò���
	  hostIP   =  PropertiesTools.readResourceProperty("hostIP");
      hostPort =  PropertiesTools.readResourceProperty("hostPort");
      instanse =  PropertiesTools.readResourceProperty("instanse");
      if(!StringUtil.isNullOrEmpty(hostIP)&&!StringUtil.isNullOrEmpty(hostPort)&&!StringUtil.isNullOrEmpty(instanse)){
      	url      =  "jdbc:oracle:thin:@"+hostIP+":"+hostPort+":"+instanse;
      }
      username =  PropertiesTools.readResourceProperty("username");
      password =  PropertiesTools.readResourceProperty("password");
      
	  
      /*
	  hostIP   =  "10.0.31.32";	//���Ի���
	  //hostIP   =  "188.0.55.117";	//��������
      hostPort =  "1521";
      instanse =  "shaip";
      if(!StringUtil.isNullOrEmpty(hostIP)&&!StringUtil.isNullOrEmpty(hostPort)&&!StringUtil.isNullOrEmpty(instanse)){
      	url      =  "jdbc:oracle:thin:@"+hostIP+":"+hostPort+":"+instanse;
      }
      username =  "ezactor751ums";
      password =  "ezactor751ums";
	  */
  }
  
  private void getJDBCConnection(){
	  try {
	      //��һ��������JDBC����
	      Class.forName("oracle.jdbc.driver.OracleDriver");
	      //�ڶ������������ݿ�����
          conn =DriverManager.getConnection(url, username, password);
	  	  } catch (Exception e) {
	  		JDBCConnLog.error(e.toString());
		}
  }
  
    
  private void colseConnection(){
	  try{
	    if(rs!=null){
           rs.close();
	    }
	  }catch(Exception e){
		  JDBCConnLog.error("Close resultset error:"+e.getMessage());
	  }finally{
		  rs = null;
	  }
	  
	  try{
		  if(stmt!=null){
			  stmt.close();
		  }
	  }catch(Exception e){
		  JDBCConnLog.error("Close statment error:"+e.getMessage());  
      }finally{
			  stmt = null;
	  }
	  
	  try{
		  if(conn!=null){
			  conn.close();
		  }
      }catch(Exception e){
    	  JDBCConnLog.error("Close connection error:"+e.toString());
	  }finally{
		   conn = null;
	  }	  
  }
  
  public List executeQuery(String sSQL){
	resultList = new ArrayList();
	getJDBCConnection();
    if(conn != null){
      try{
        stmt = conn.createStatement();
        rs = stmt.executeQuery(sSQL);
        ResultSetMetaData rsmd = rs.getMetaData();
        int rows = 0;
        if(rs != null){
        	while(rs.next()){
        		Map map = new HashMap();
        		for(int i=1; i<=rsmd.getColumnCount(); i++){
        			map.put(rsmd.getColumnName(i),rs.getObject(i));
        		}
        		resultList.add(rows,map);
        		rows++;
        	}
        }
        return resultList;
      }catch(SQLException e){
    	  JDBCConnLog.error(e.toString());
      }finally{
    	colseConnection();
      }
      
    }
    return null;
  }
  /**
   * 
   * @param sSQL
   * @return
   */
  public Map getMapQuery(String sSQL){
	  	Map map = new HashMap();
		getJDBCConnection();
	    if(conn != null){
	      try{
	        stmt = conn.createStatement();
	        rs = stmt.executeQuery(sSQL);
	        if(rs != null){
	        	while(rs.next()){
	        		map.put(rs.getObject(1),rs.getObject(2));
	        	}
	        }
	        return map;
	      }catch(SQLException e){
	    	  JDBCConnLog.error(e.toString());
	      }finally{
	    	colseConnection();
	      }
	      
	    }
	    return null;
	  }
  
  /**
	  * ����sql��ȡ��һ���ַ����������б�
	  * @param sql
	  * @return
	  */
	 public  String getOnlyStringValue(String sSQL){
		    String str = "";
			getJDBCConnection();
		    if(conn != null){
		      try{
		        stmt = conn.createStatement();
		        rs = stmt.executeQuery(sSQL);
		        if(rs != null){
		        	if(rs.next()){
						str=rs.getString(1);
					 }
		        }
		        return str;
		      }catch(SQLException e){
		    	  JDBCConnLog.error(e.toString());
		      }finally{
		    	colseConnection();
		      }
		      
		    }
		    return null;
	}
	 
  
  /********begin************add jeton.dong 20090312******************begin*********/
  /**
   * ִ��ָ����SQL��䲢�����Ԫ����List����
   * add by jeton.dong 20090312
   * @param sSQL ��ִ�е�SQL���
   * @param isHashMap���Ƿ񽫽����hashMap���з�װ true:��hashMap���з�װ false:��Object���з�װ
   * @return List �������
   */
  public List executeQuery(String sSQL,boolean isHashMap){
		resultList = new ArrayList();
		getJDBCConnection();
		//�Ƿ�ִ�н����hashMap���з�װ
	    if(conn != null && isHashMap){
	    	resultList = executeQuery(sSQL);
	    }else{
	      try{
	        stmt = conn.createStatement();
	        rs = stmt.executeQuery(sSQL);
	        ResultSetMetaData rsmd = rs.getMetaData();
	        if(rs != null){
	        	while(rs.next()){
	        		for(int i=1; i<=rsmd.getColumnCount(); i++){
	        			resultList.add(rs.getObject(i));
	        		}
	        	}
	        }
	        return resultList;
	      }catch(SQLException e){
	    	  JDBCConnLog.error(e.toString());
	      }finally{
	    	colseConnection();
	      }
	    }
	    return null;
	  }
  /********end************add jeton.dong 20090312******************end*********/
  
  public int getCount(String sSQL){
		int count = 0;
		getJDBCConnection();
	    if(conn != null){
	      try{
	        stmt = conn.createStatement();
	        rs = stmt.executeQuery(sSQL);
	        if(rs != null){
	        	while(rs.next()){
                   count = rs.getInt(1);
	        	}
	        }
	      }catch(SQLException e){
	    	  JDBCConnLog.error(e.toString());
	      }finally{
	    	colseConnection();
	      }
	      
	    }
	    return count;
  }
  
  
  public int executeUpdate(String sSQL){
    getJDBCConnection();
    int result = 0;
    
    if(conn != null){
      try{
        stmt = conn.createStatement();
        result = stmt.executeUpdate(sSQL);
      }catch(SQLException e){
    	  JDBCConnLog.error(e.toString());
      }finally{
    	  colseConnection();
      }
    }
    return result;
  }
  /**
   * executePreStatement:ִ��Ԥ�������
   * @param sql:��ִ�е�sql���
   * @param para:����
   * @return List
   */
  public List executePreStatement(String sql,String para){
	  resultList = new ArrayList();
	  getJDBCConnection();
	  try{
		 pstmt = conn.prepareStatement(sql);
		 pstmt.setString(1,para);	//�趨����
	     rs = pstmt.executeQuery();
	     ResultSetMetaData rsmd = rs.getMetaData();
	     int rows = 0;
	     if(rs != null){
        	while(rs.next()){
        		Map map = new LinkedHashMap();
        		for(int i=1; i<=rsmd.getColumnCount(); i++){
        			Object obj = rs.getObject(i);
        			String clobContent = "";
        			//����clob�ֶΣ����ȡ������
        			if(obj instanceof Clob){
        				clobContent = readOracleClob((Clob)obj);
        				map.put(rsmd.getColumnName(i),clobContent);
        			}else{
        				map.put(rsmd.getColumnName(i),obj);
        			}
        		}
        		resultList.add(rows,map);
        		rows++;
        	}
	     }
	    }catch(Exception e)
		{
	    	  JDBCConnLog.error(e.toString());
		}finally{
	    	  colseConnection();
	    }
		return resultList; 
  }
    /**
	 * readOracleClob:��ȡOracle�е�Clob�ֶε�ֵ
	 * @param clob ����ȡ��Clob
	 * @return String ��String��ʽ����Clob�е�����
	 */
	public String readOracleClob(Clob clob){
		String info = "";	//���ص���Ϣ
		Reader reader = null;
		if(clob != null){
			try {
				reader = clob.getCharacterStream();
				BufferedReader bf = new BufferedReader(reader);
				String tmp = bf.readLine();
				while(!StringUtil.isNullOrEmpty(tmp)){
					info +=tmp;
					tmp = bf.readLine();
				}
			} catch (Exception e) {
				JDBCConnLog.error(e.toString());
			}
		}
		return info;
	}
	
	
	
	
	/**
	   * fillPreStatement:���Ԥ�������
	   * @param  pstmt:������pstmt
	   * @param  paras:����
	   * @return PreparedStatement:�����pstmt
	   */
	  public PreparedStatement fillPreStatement(PreparedStatement pstmt,List paras){
		  PreparedStatement  retPstmt = pstmt;	//Ҫ���ص�retPstmt
		  //ѭ��paras����preSQL��Ҫ����
		  if(paras != null){
			  for(int i=0;i<paras.size();i++){
				  String val = (String)paras.get(i);	//Ҫ���õ�ֵ
				  if(val == null){
					  val = "";
				  }
				  try {
					pstmt.setString(i+1,val);
				 } catch (SQLException e) {
					 JDBCConnLog.error(e.toString());
				 }
			  }//endfor
		  }//endif
		  return retPstmt;
	  }
	  
	  /**
	   * �õ�����ֵList
	   * @param �� map		 ����Map		
	   * @param   paraOrder  ����Ҫ������Ӧ�ı��
	   * @return  List 		 ����List
	   */
	  public List getParasList(LinkedHashMap map,String paraOrder){
		  List parasList = new ArrayList();	//�����б�
		  String[] orders = paraOrder.split(";"); 
		  if(orders != null && orders.length>0){
			  for(int i=0;i<orders.length;i++){
				  String val = (String)map.get(orders[i]);
				  parasList.add(val);
				}
			}
		  return parasList;
	  }
	  
	  /**
	   * executePreStatement:ִ��Ԥ�������
	   * @param sql:��ִ�е�sql���
	   * @return int  0:ʧ�� ��0:�ɹ�
	   */
	  public int executePreStatement(String strSQL,List excelContent,String paraOrder){
		  int flag = 0 ;		//0:ʧ�� ��0:�ɹ�
		  getJDBCConnection();
		  
		  try{
			  if(excelContent != null){
					for(int i=0;i<excelContent.size();i++){
					    //List rowList = (List)excelContent.get(i);						//List��ʽ
						LinkedHashMap rowsMap = (LinkedHashMap)excelContent.get(i);		//��Map��ʽ
						List paras = new ArrayList();									//�õ������б�
						if(rowsMap != null){
					    	  paras = getParasList(rowsMap,paraOrder);
							  pstmt = conn.prepareStatement(strSQL);
							  pstmt = fillPreStatement(pstmt,paras);
							  int tmp = pstmt.executeUpdate();
							  if(tmp > 0){
								  flag = 1;
							  }
						}  //endif  
					}//endfor
				}//endif	
			  
		  }catch(Exception e)
		  {
			  JDBCConnLog.error(e.toString());
		  }finally{
		    colseConnection();
		  }
		  
		return flag; 
	  }
	  
	  
	  public int executePreStatementList(String strSQL,List excelContent){
		  int flag = 0 ;		//0:ʧ�� ��0:�ɹ�
		  getJDBCConnection();
		  
		  try{
			  if(excelContent != null){
				
					    //List rowList = (List)excelContent.get(i);						//List��ʽ
						//String  rowsMap = (LinkedHashMap)excelContent.get(i);		//��Map��ʽ
						//List paras = new ArrayList();									//�õ������б�
						
					    	  //paras = getParasList(rowsMap,paraOrder);
							  pstmt = conn.prepareStatement(strSQL);
							  pstmt = fillPreStatement(pstmt,excelContent);
							  int tmp = pstmt.executeUpdate();
							  if(tmp > 0){
								  flag = 1;
							  }
						  //endif  
					//endfor
				}//endif	
			  
		  }catch(Exception e)
		  {
			  JDBCConnLog.error(e.toString());
		  }finally{
		    colseConnection();
		  }
		  
		return flag; 
	  }
	 /**
	  * ����ָ���Ĵ洢����
	  * @param proceName �洢���̵�����
	  */
	  public void callProcedure(String proceName){
		  getJDBCConnection();
		  try {
			cstmt = conn.prepareCall("{call "+proceName+"()}");
			cstmt.execute();
			} catch (SQLException e) {
				JDBCConnLog.error(e.toString());
			}finally{
			    colseConnection();
			}
	  }
	  
}  
	  
