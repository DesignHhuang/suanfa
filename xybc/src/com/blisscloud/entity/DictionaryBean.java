package com.blisscloud.entity;

public class DictionaryBean implements java.io.Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private long seqID;				//����ID
	private long parentID;			//��ID
	private long orderNum;			//�����
	private String dictionaryType;	//�ֵ�����
	private String dictionaryName;	//�ֵ�����
	private String dictionaryCode;	//�ֵ����
	private String comm;			//��ע
	
	
	public String getComm() {
		return comm;
	}
	public void setComm(String comm) {
		this.comm = comm;
	}
	public String getDictionaryCode() {
		return dictionaryCode;
	}
	public void setDictionaryCode(String dictionaryCode) {
		this.dictionaryCode = dictionaryCode;
	}
	public String getDictionaryName() {
		return dictionaryName;
	}
	public void setDictionaryName(String dictionaryName) {
		this.dictionaryName = dictionaryName;
	}
	public String getDictionaryType() {
		return dictionaryType;
	}
	public void setDictionaryType(String dictionaryType) {
		this.dictionaryType = dictionaryType;
	}
	public long getOrderNum() {
		return orderNum;
	}
	public void setOrderNum(long orderNum) {
		this.orderNum = orderNum;
	}
	public long getParentID() {
		return parentID;
	}
	public void setParentID(long parentID) {
		this.parentID = parentID;
	}
	public long getSeqID() {
		return seqID;
	}
	public void setSeqID(long seqID) {
		this.seqID = seqID;
	}

	
}