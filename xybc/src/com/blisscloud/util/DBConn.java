package com.blisscloud.util;

import javax.naming.*;
import javax.sql.*;
import java.sql.*;
import java.util.*;


public class DBConn {
	
  private ResultSet rs = null;
  private Connection conn = null;
  private Statement stmt = null;
  private List resultList = null;
  
  public DBConn() {
	  
  }
  
  
  private void getConnection() {
    try{
    	
      DataSource ds;
      
      Context ctx = new InitialContext();
      //ds = (DataSource)ctx.lookup("java:/ezactor"); 
      ds = (DataSource)ctx.lookup("java:/FETI");
      conn = ds.getConnection();   
      
    }catch(Exception e){
      System.out.println("Open connction error:"+e.getMessage());
    }
  }
  
  private void getConnection(String _DB){
    try{
    	DataSource ds;
    	Context ctx = new InitialContext();
        ds = (DataSource)ctx.lookup("java:/"+_DB);      
        conn = ds.getConnection();    
    }catch(Exception e){
      System.out.println("Open connction error:"+e.getMessage());
    }  	
  }
  
  private void colseConnection(){
	  try{
	    if(rs!=null){
           rs.close();
	    }
	  }catch(Exception e){
		  System.out.println("Close resultset error:"+e.getMessage());
	  }finally{
		  rs = null;
	  }
	  
	  try{
		  if(stmt!=null){
			  stmt.close();
		  }
	  }catch(Exception e){
		  System.out.println("Close statment error:"+e.getMessage());  
      }finally{
			  stmt = null;
	  }
	  
	  try{
		  if(conn!=null){
			  conn.close();
		  }
      }catch(Exception e){
		  System.out.println("Close connection error:"+e.getMessage());
	  }finally{
		   conn = null;
	  }	  
  }
  
  public List executeQuery(String sSQL){
	resultList = new ArrayList();
	getConnection();
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
        System.out.println(e.getMessage());
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
		getConnection();
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
	        System.out.println(e.getMessage());
	      }finally{
	    	colseConnection();
	      }
	    }
	    return null;
	  }
  /********end************add jeton.dong 20090312******************end*********/
  
  public int getCount(String sSQL){
		int count = 0;
		getConnection();
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
	        System.out.println(e.getMessage());
	      }finally{
	    	colseConnection();
	      }
	      
	    }
	    return count;
  }
  
  public int getCount(String sSQL,String _DB){
		int count = 0;
		getConnection(_DB);
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
	        System.out.println(e.getMessage());
	      }finally{
	    	colseConnection();
	      }
	      
	    }
	    return count;
}
  
  public List executeQuery(String sSQL,String _DB){
    resultList = new ArrayList();
    getConnection(_DB);
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
          System.out.println(e.getMessage());
        }finally{
      	colseConnection();
        }
        
      }
      return null;
  }
  

  public int executeUpdate(String sSQL){
    getConnection();
    int result = 0;
    
    if(conn != null){
      try{
        stmt = conn.createStatement();
        result = stmt.executeUpdate(sSQL);
      }catch(SQLException e){
        System.out.println(e.getMessage());
      }finally{
    	  colseConnection();
      }
    }
    return result;
  }
  
    public int executeUpdate(String sSQL,String _DB){
    getConnection(_DB);
    int result = 0;
    
    if(conn != null){
      try{
        stmt = conn.createStatement();
        result = stmt.executeUpdate(sSQL);
      }catch(SQLException e){
        System.out.println(e.getMessage());
      }finally{
    	  colseConnection();
      }
    }
    return result;
  }
    public String getQueryValue(String sSQL){
        String result = "0";
        getConnection();        
        if(conn != null){                     
          try{
            stmt = conn.createStatement();
            rs = stmt.executeQuery(sSQL);
            if(rs != null){
                while(rs.next()){
                    result = rs.getString(1);
                }
            }
          }catch(Exception e){
              System.out.println(e.getMessage());
          }finally{
              colseConnection();
          }          
        }
        return result;
  }
  
  public String getQueryValue(String sSQL,String _DB){
        String result = "0";
        getConnection(_DB);       
        if(conn != null){                     
          try{
            stmt = conn.createStatement();
            rs = stmt.executeQuery(sSQL);
            if(rs != null){
                while(rs.next()){
                    result = rs.getString(1);
                }
            }
          }catch(Exception e){
              System.out.println(e.getMessage());
          }finally{
              colseConnection();
          }          
        }
        return result;
  }	
      
}
