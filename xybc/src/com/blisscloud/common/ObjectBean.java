package com.blisscloud.common;
/**
 * 
 * @author Ken.Guo
 * ���ڴ洢һ������
 * keyΪ��,valueΪֵ
 *
 */     
public class ObjectBean {
    private Object key;
    private Object value;
	public ObjectBean() {
	}
    
	public ObjectBean(Object _key,Object _value) {
     this.key=_key;
     this.value=_value;
	}

	
	public Object getKey() {
		return key;
	}

	public void setKey(Object key) {
		this.key = key;
	}

	public Object getValue() {
		return value;
	}

	public void setValue(Object value) {
		this.value = value;
	}

}
