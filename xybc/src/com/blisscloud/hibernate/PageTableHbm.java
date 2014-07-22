package com.blisscloud.hibernate;

import java.io.*;
import java.util.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.Transaction;



/** 
 * @author peter.chen
 * ʱ�� 2006-10-23
 * ��gcf���Ĵ���Ļ�����Peter.chen����Щ�޸�
 * ��HQL��䣬�������ݼ�¼�ļ��ϣ���������ҳ����
 * ���Class�����˵��
 * ����jsp��ҳ�У�Ҫ��page4hibernate.js��src����
 * 
 */
public class PageTableHbm implements java.io.Serializable
{
        private int curPage =1; //��ǰ�ǵڼ�ҳ
        private int maxPage=1 ; //һ���ж���ҳ
        private int maxRowCount=7; //һ���ж�����
        private int rowsPerPage=3 ;//ÿҳ������
        private String baseUrl=null; //jsp page��ҳ�б��Ӧ��URL��modify by peter
        private String HQL=null;        // modify by peter  
        //private List data = new ArrayList(); //modify by peter,ʵʱ�����ݿ���ȡ������
        private boolean isEnd = false;
        private boolean isStart = false;
        private java.util.Vector columnList;
        private String pageURL;
        private HttpServletRequest myRequest;
        private JspWriter myOut;
        private String imagepath="";

        public PageTableHbm(){
            
        }
                
        /**
         *  ��ҳ���췽��
         * @param _baseUrl    �б��Ӧ��url
         * @param _imagepath  ͼƬ���·��,ע������·���� "/"
         * @param _curPage    ��ǰҳ��
         * @param _perRowPage ÿҳ������
         * @param _hql        HQL���
         */
        
        public PageTableHbm(String _baseUrl,String _imagepath,String  _curPage,int _perRowPage,String _hql){
            
            int Count=getRecordCount(_hql); // �õ���¼��������
            this.setBaseUrl(_baseUrl);      // modify by peter Chen
            //this.setData()                // setData���������ﲻ��Ҫ���ã���ΪgetCurPageList�����ʵʱȥ�����ݿ���ȡ������ 
            this.setHQL(_hql);   
            
            this.setImagepath(_imagepath);
            this.setRowsPerPage(_perRowPage);
            this.setCurPage(this.strToInt(_curPage));
            this.setMaxRowCount(Count);
            this.countMaxPage(); 
            
        }
        
public PageTableHbm(String _baseUrl,String _imagepath,String  _curPage,int _perRowPage,String _hql,String ss){
            
            int Count=getRecordCounts(_hql); // �õ���¼��������
            this.setBaseUrl(_baseUrl);      // modify by peter Chen
            //this.setData()                // setData���������ﲻ��Ҫ���ã���ΪgetCurPageList�����ʵʱȥ�����ݿ���ȡ������ 
            this.setHQL(_hql);   
            
            this.setImagepath(_imagepath);
            this.setRowsPerPage(_perRowPage);
            this.setCurPage(this.strToInt(_curPage));
            this.setMaxRowCount(Count);
            this.countMaxPage(); 
            
        }
        
        /** 
         *  ��ҳ���췽��
         * @param _baseUrl    �б��Ӧ��url
         * @param _curPage    ��ǰҳ��
         * @param _perRowPage ÿҳ������
         * @param _hql        HQL���
         */
        
//        public PageTableHbm(String _baseUrl,String  _curPage,int _perRowPage,String _hql){
//            
//            int Count=getRecordCount(_hql); // �õ���¼��������
//            this.setBaseUrl(_baseUrl);      // modify by peter Chen
//            //this.setData()                // setData���������ﲻ��Ҫ���ã���ΪgetCurPageList�����ʵʱȥ�����ݿ���ȡ������ 
//            this.setHQL(_hql);           
//            this.setRowsPerPage(_perRowPage);
//            this.setCurPage(this.strToInt(_curPage));
//            this.setMaxRowCount(Count);
//            this.countMaxPage(); 
//            
//        }

        /**
         * ��HQL����ڵõ���¼��������
         * @param _hql HQL���
         * @return
         */
        private int getRecordCount(String _hql)
        {
            // ���ó�ʼ�����ϾͿ��Եõ����С��
            //( (Integer) session.iterate("select count(*) from ....").next() ).intValue();
            int Count=0;
            Session  session =null;
            try {
            	session = HibernateUtil.currentSession();
            	Count= session.createQuery(_hql).list().size();
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                HibernateUtil.closeSession();
            }
            
            return Count; 
             
        }
        
        private int getRecordCounts(String _hql)
        {
            // ���ó�ʼ�����ϾͿ��Եõ����С��
            //( (Integer) session.iterate("select count(*) from ....").next() ).intValue();
            int Count=0;
            Session  session =null;
            try {
            	session = HibernateUtil.currentSession();
            	Count= session.createSQLQuery(_hql).list().size();
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                HibernateUtil.closeSession();
            }
            return Count; 
             
        }

        
        
        /**
         * @deprecated  ��Ϊ��list�����������ݴ��룬
         *              ������̫������Ч�ʽ�����ܸ�
         * @param _curPage
         * @param list
         */
        public PageTableHbm(String  _curPage,List list){
          this.setCurPage(this.strToInt(_curPage));
          // this.setData(list);
          this.setMaxRowCount(list.size());
          this.countMaxPage();
        }
        /**
         * @deprecated  ��Ϊ��list�����������ݴ��룬
         *              ������̫������Ч�ʽ�����ܸ�
         * @param _perRowPage
         * @param _curPage
         * @param list
         */
        public PageTableHbm(int _perRowPage,String  _curPage,List list){
          this.setRowsPerPage(_perRowPage);
          this.setCurPage(this.strToInt(_curPage));
          //this.setData(list);
          if(list!=null){
             this.setMaxRowCount(list.size());
          }
         this.countMaxPage();
        }
        
 
        /**
         * @deprecated modify by peter.chen
         * @param _perRowPage
         * @param _curPage
         * @param _iCount
         */  
        public PageTableHbm(int _perRowPage,String  _curPage,int _iCount){
          this.setRowsPerPage(_perRowPage);
          this.setCurPage(this.strToInt(_curPage));
         this.setMaxRowCount(_iCount);
         this.countMaxPage();
        }
        
     /**
      * @deprecated modify by peter Chen
      * @param _perRowsPage
      * @param allData
      * @param colList
      * @param _pageURL
      * @param _request
      * @param _myOut
      */

        public PageTableHbm(int _perRowsPage,List allData,Vector colList,String _pageURL,HttpServletRequest _request,JspWriter _myOut){
          this.setRowsPerPage(_perRowsPage);
          //this.setData(allData);
          this.setColumnList(colList);
          this.setPageURL(_pageURL);
          this.setMyRequest(_request);
          this.setMyOut(_myOut);
          String cur=_request.getParameter("pageNo");
          this.setCurPage(this.strToInt(cur));
          this.countMaxPage();
       }


      public List getCurPageList() {
          
          Session ses=null;
          int start=0;
          List list=null;
          list=new ArrayList();
          
             ses = HibernateUtil.currentSession();
              //HQL���ж�                
              if (this.HQL==null)
              {
                  try {
                    throw new Exception("HQL comment ����Ϊ��!");
                } catch (Exception e) {
                    // TODO Auto-generated catch block
                    e.printStackTrace();
                }
                HibernateUtil.closeSession();
                return null; //û�в鵽����
              }
              
            Query query = ses.createQuery(this.HQL);
            // query.setCharacter("sex", 'F');              
              //�ӵڼ�����¼��ʼȡ����
               start=(this.curPage-1)*(this.rowsPerPage); //��һҳ���׼�¼ \
              // �ӵ�'firstrecord'����ʼȡ��'rowsPerPage'����¼
                query.setFirstResult(start);
                query.setMaxResults(this.rowsPerPage);
              
                
                list = query.list();
                /*
              for (Iterator it = query.iterate(); it.hasNext();) {
                  Object obj = (Object) it.next();
                  list.add(obj);
                
              } */ 
                HibernateUtil.closeSession();
              return list;
  }
        
      
public List getCurPageLists() {
          
          Session ses=null;
          Transaction tx=null;
          int start=0;
          List list=null;
          list=new ArrayList();
          
             ses = HibernateUtil.currentSession();
              tx = ses.beginTransaction();
              
              //HQL���ж�                
              if (this.HQL==null)
              {
                  try {
                    throw new Exception("HQL comment ����Ϊ��!");
                } catch (Exception e) {
                    // TODO Auto-generated catch block
                    e.printStackTrace();
                }
                HibernateUtil.closeSession();
                return null; //û�в鵽����
              }
              
            Query query = ses.createSQLQuery(this.HQL);
            // query.setCharacter("sex", 'F');              
              //�ӵڼ�����¼��ʼȡ����
               start=(this.curPage-1)*(this.rowsPerPage); //��һҳ���׼�¼ \
              // �ӵ�'firstrecord'����ʼȡ��'rowsPerPage'����¼
                query.setFirstResult(start);
                query.setMaxResults(this.rowsPerPage);
              
                
                list = query.list();
                /*
              for (Iterator it = query.iterate(); it.hasNext();) {
                  Object obj = (Object) it.next();
                  list.add(obj);
                
              } */ 
                HibernateUtil.closeSession();
              return list;
  }


      
    
        private int strToInt(String s) {
          int icurPage = 0;
          try {
            icurPage = Integer.parseInt(s);
          }
          catch (Exception e) {
            icurPage = 1;
          }
          return icurPage;
        }
        public  boolean  isOnlyOnepage(){
          return  this .getMaxPage()<2;
        }
        public  boolean  isFirstPage(){
          return  this.curPage==1;
        }
        public  boolean  isEndPage(){
          return  this.curPage==this.maxPage;
        }
        public  boolean  isMiddlePage(){
        return  this. curPage>1&&this.curPage<this.maxPage;
         }

        public void countMaxPage() { //����������������ҳ��
          if (this.maxRowCount % this.rowsPerPage == 0) {
            this.maxPage = this.maxRowCount / this.rowsPerPage;
          }
          else {
            this.maxPage = this.maxRowCount / this.rowsPerPage + 1;
          }
        }

  public int getCurPage() {
    return curPage;
  }


  public int getMaxPage() {
    return maxPage;
  }
  public int getMaxRowCount() {
    return maxRowCount;
  }
  public int getRowsPerPage() {
    return rowsPerPage;
  }
  /**
   * �ж�ҳ���Ƿ�ͷ��,�����ǰҳ����С�����ҳ������
   * ��˵����û�е�ͷ������true,����,����false��
   * @return
   */
  public boolean  isEnd(){
   if(this.curPage<this.maxPage){
      isEnd=false;
    }else {
      isEnd=true;
    }
    return isEnd;
  }
  /**
   * �ж�ҳ���Ƿ�����ҳ
   * @return
   */
  public  boolean  isStart(){
   if(this.curPage==1){
     this.isStart=true;
    }else{
      this.isStart=false;
    }
    return isStart;
  }
  public void setRowsPerPage(int rowsPerPage) {
    this.rowsPerPage = rowsPerPage;
  }

  public void setMaxRowCount(int maxRowCount) {
    this.maxRowCount = maxRowCount;
  }
  public void setMaxPage(int maxPage) {
    this.maxPage = maxPage;
  }

  
  
  public void setCurPage(int curPage) {
    this.curPage = curPage;
  }
 
  
  public int prePage(){
     int intpage=this.curPage-1;
     if (intpage<=0)
     {
         intpage=1;
         
     }
             
    return intpage ;
  }
  public int nextPage(){
    return this.curPage+1;
  }
  public int getNowPageNumber(){
    String curPage = (String) myRequest.getParameter("pageNo");
    int h = this.strToInt(curPage);
    return h;
  }
  public java.util.Vector getColumnList() {
    return columnList;
  }
  public void setColumnList(java.util.Vector columnList) {
    this.columnList = columnList;
  }
  
private String getFooter1(){
        StringBuffer buf=new StringBuffer();
        buf.append("<TABLE cellSpacing=0 cellPadding=0 align=center border=0>")
        .append("<TBODY><TR><TD align=middle>")
        .append("��<SPAN class=red>"+getMaxRowCount()+"</SPAN>����¼����<SPAN class=red>"+getMaxPage()+"</SPAN>ҳ��ÿҳ<SPAN class=red>"+getRowsPerPage()+"</SPAN>��¼����ǰҳ��<SPAN class=red>"+this.curPage+"</SPAN>")
        .append("</TD>");
        return buf.toString();
   }
   public String getFooter2(){    
       
      //���page.js �ļ����н��        
      //����jsp��ҳ�У�Ҫ��page4hibernate.js��src����
       
//  curpage ��ǰҳ�Ĳ���       

     StringBuffer buf=new StringBuffer();
     buf.append(" <TD align=middle>");
    if(this.isOnlyOnepage()){
     buf.append("\n<a><IMG height=10 hspace=3 src='"+this.getImagepath()+"images/arow_fore2.gif' width=22 border=0 alt='��һҳ'></a>");
     buf.append("\n<a><IMG height=10 hspace=3 src='"+this.getImagepath()+"images/arow_back2.gif' width=22 border=0 alt='��һҳ'></a>");
     buf.append("\n<a><IMG height=10 hspace=3 src='"+this.getImagepath()+"images/arow_next2.gif' width=22 border=0 alt='��һҳ'></a>");
     buf.append("\n<a><IMG height=10 hspace=3 src='"+this.getImagepath()+"images/arow_last2.gif' width=22 border=0 alt='���һҳ'></a>");
   }else if(this.isFirstPage()){
      buf.append("\n<a >	<IMG height=10 hspace=3 src='"+this.getImagepath()+"images/arow_fore2.gif' width=22 border=0 alt='��һҳ'></a>");
      buf.append("\n<a>	<IMG height=10 hspace=3 src='"+this.getImagepath()+"images/arow_back2.gif' width=22 border=0 alt='��һҳ'></a>");
//      buf.append("<a  href='javascript:goToPage("+this.nextPage()+")';>	<IMG height=10 hspace=3 src=images/arow_next.gif width=22 border=0 alt='��һҳ'></a>");
//      buf.append("<a  href='javascript:goToPage("+this.getMaxPage()+")';>	<IMG height=10 hspace=3 src=images/arow_last.gif width=22 border=0 alt='���һҳ'></a>");
      buf.append("\n<a  href=\"javascript:goToPage('"+this.baseUrl+"',"+this.nextPage()+");\"> " +
                 "\n<IMG height=10 hspace=3 src='"+this.getImagepath()+"images/arow_next.gif' width=22 border=0 alt='��һҳ'></a>");
      buf.append("\n<a  href=\"javascript:goToPage('"+this.baseUrl+"',"+this.getMaxPage()+");\";>   " +
                 "\n<IMG height=10 hspace=3 src='"+this.getImagepath()+"images/arow_last.gif' width=22 border=0 alt='���һҳ'></a>");

   }else if(isEndPage()){
     buf.append("\n<a href=\"javascript:goToPage('"+this.baseUrl+"',"+"1);\">	" +
                "\n <IMG height=10 hspace=3 src='"+this.getImagepath()+"images/arow_fore.gif'  width=22 border=0 border=0 alt='��һҳ'></a>");
     buf.append("\n<a href=\"javascript:goToPage('"+this.baseUrl+"',"+this.prePage()+");\">	" +
                "\n <IMG height=10 hspace=3 src='"+this.getImagepath()+"images/arow_back.gif' width=22 border=0 alt='��һҳ'></a>");
     buf.append("\n<a>	<IMG height=10 hspace=3 src='"+this.getImagepath()+"images/arow_next2.gif' width=22 border=0 alt='��һҳ'></a>");
     buf.append("\n<a>	<IMG height=10 hspace=3 src='"+this.getImagepath()+"images/arow_last2.gif'  width=22 border=0 alt='���һҳ'></a>");
   }else{
    buf.append("\n<a  href=\"javascript:goToPage('"+this.baseUrl+"',"+"1);\">	<IMG height=10 hspace=3 src='"+this.getImagepath()+"images/arow_fore.gif' width=22 border=0 alt='��һҳ'></a>");
    buf.append("\n<a  href=\"javascript:goToPage('"+this.baseUrl+"',"+this.prePage()+");\">	 " +
            "\n<IMG  height=10  hspace=3  src='"+this.getImagepath()+"images/arow_back.gif'   width=22 border=0 alt='��һҳ'></a>");
    buf.append("\n<a  href=\"javascript:goToPage('"+this.baseUrl+"',"+this.nextPage()+");\">	 <IMG  height=10  hspace=3  src='"+this.getImagepath()+"images/arow_next.gif'   width=22 border=0 alt='��һҳ'></a>");
    buf.append("\n<a  href=\"javascript:goToPage('"+this.baseUrl+"',"+this.getMaxPage()+");\"> <IMG  height=10  hspace=3  src='"+this.getImagepath()+"images/arow_last.gif'   width=22 border=0 alt='���һҳ'></a>");
   }
     return buf.toString();
   }

  private String getFooter3(){
        StringBuffer buf=new StringBuffer();
        buf.append("</TD><TD align=middle>�ڣ�<select name=selPage class=bot onChange=\"javascript:goToPage('"+this.baseUrl+"',this.value)\">");
        for(int n=1;n<getMaxPage()+1;n++){
        String s="";if(n==this.curPage){ s="selected";}
        buf.append("<option value="+n+"  "+s +" >"+n+" </option>");
        }
      buf.append(" </select>ҳ</TD><TD align=middle>&nbsp;</TD></TR></TBODY></TABLE>");
     return buf.toString();
  }
public String getFooter(){
    return this.getFooter1()+" "+this.getFooter2()+" "+this.getFooter3();
  }
  public static void  main(String[] s){
    PageTableHbm b=new PageTableHbm();
    b.setPageURL("list.jsp");
 }
 public void outMyFooter(){
  try {
    myOut.println(this.getFooter());
  }
  catch (IOException ex) {
    ex.printStackTrace();
  }
 }

 public String  getTableHeader(){
   StringBuffer buffer = new StringBuffer();
   buffer.append("<SCRIPT  LANGUAGE=javascript> \n");
      buffer.append("function  goNewPage(){ \n");
       buffer.append("document.form1.curpage.value = document.form1.selPage.value; \n");
       buffer.append("document.form1.action=" + this.getPageURL() + "; \n");
       buffer.append(" document.form1.submit(); \n");
       buffer.append("} \n");
       buffer.append(" function  goToPage("+this.baseUrl+","+"_curpage){ \n");
       buffer.append("document.form1.curpage.value = _curpage; \n");
       buffer.append("document.form1.action=" + this.getPageURL() + "; \n");
       buffer.append(" document.form1.submit(); \n");
       buffer.append("} \n");
       buffer.append("</SCRIPT>");
       return buffer.toString();
  }
  public static    String getTable(String url){
     StringBuffer buffer = new StringBuffer();
     buffer.append("<SCRIPT  LANGUAGE=javascript> \n");
      buffer.append("function  goNewPage(){ \n");
       buffer.append("document.form1.curpage.value = document.form1.selPage.value; \n");
       buffer.append("document.form1.action="+url+ "; \n");
       buffer.append(" document.form1.submit(); \n");
        buffer.append("} \n");
       buffer.append(" function  goToPage(_curpage){ \n");
       buffer.append("document.form1.curpage.value = _curpage; \n");
       buffer.append("document.form1.action="+url+ "; \n");
       buffer.append(" document.form1.submit(); \n");
       buffer.append("} \n");
       buffer.append("</SCRIPT>");

      return buffer.toString();
  }
 public  String getColWidth(){
   float k=1/columnList.size();
   int kk=(int)k*100;
   String colWith="width="+kk+"%";
   return colWith;
 }
 private  String getAllColTitle(){
   StringBuffer buffer=new StringBuffer();

   buffer.append("<tr align=center bgcolor=#D7DCF7> \n");
   for(int g=0;g<columnList.size();g++){
   String colName=columnList.get(g).toString();
   buffer.append("<td "+getColWidth()+">"+colName+"</td> \n");
   }
   buffer.append("</tr>");
  return buffer.toString();
 }
  public String getPageURL() {
    return pageURL;
  }
  public void setPageURL(String pageURL) {
    this.pageURL = pageURL;
  }
  public HttpServletRequest getMyRequest() {
    return myRequest;
  }
  public void setMyRequest(HttpServletRequest myRequest) {
    this.myRequest = myRequest;
  }
  public JspWriter getMyOut() {
    return myOut;
  }
  public void setMyOut(JspWriter myOut) {
    this.myOut = myOut;
  }
  public void  outTableHeader(){
    try {
      myOut.println(this.getTableHeader());

    }
    catch (IOException ex) {
      ex.printStackTrace();
    }
  }

public String getBaseUrl() {
    return baseUrl;
}

public void setBaseUrl(String baseUrl) {
    this.baseUrl = baseUrl;
}

public String getHQL() {
    return HQL;
}

public void setHQL(String hql) {
    HQL = hql;
}

public String getImagepath() {
    return imagepath;
}

public void setImagepath(String imagepath) {
    this.imagepath = imagepath;
}
}






