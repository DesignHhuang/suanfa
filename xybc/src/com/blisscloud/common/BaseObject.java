
package com.blisscloud.common;

import java.io.Serializable;

/**
 * @author Ken.Guo
 * �������
 */
public class BaseObject implements Serializable{
	/**
	 * �Լ���ID
	 */
    private int seqId;
    /**
	 * �Լ�������
	 */
    private String name;
	/**
	 * �յĹ�����
	 */
	public BaseObject() {
	
	}
	/**
	 * �������Ĺ�����
	 */
	public BaseObject(int seqId,String name) {
		this.seqId=seqId;
		this.name=name;
	}

	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public int getSeqId() {
		return seqId;
	}
	public void setSeqId(int seqId) {
		this.seqId = seqId;
	}
	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub

	}

}
