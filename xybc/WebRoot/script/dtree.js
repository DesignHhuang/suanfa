
// Node object
function Node(id, pid, name, value, url, title, target, icon, iconOpen, open, isChecked, isType, isDisabled) {
	this.id = id;
	this.pid = pid;
	this.name = name;
	this.url = url || null;
	this.title = title || null;
	this.target = target || null;
	this.icon = icon || null;
	this.iconOpen = iconOpen || null;
	this._io = open || false;
	this._is = false;	// �Ƿ�չ��
	this._ls = false;	// ���ֵ����Ƿ�Ϊ���һ��
	this._hc = false;	// �Ƿ����ӽڵ�
	this._ai = 0;		// ����id���
	this._p;			// �洢���ڵ����
	
	this.isChecked = isChecked || false;	// �ڵ��Ƿ��û�ѡ��
	this.isType = isType || false;			// �ڵ��Ƿ�Ϊ����
	this.isDisabled = isDisabled || false;	// �ڵ�ؼ��Ƿ񲻿��Ա�����
	this.value = value;				// ����ڵ��ʵ��ֵ�������ݿ�id
};

// Tree object
function dTree(objName) {
	this.config = {
		target					: null,
		folderLinks				: true,				   // ѡ��ڵ��ͬʱ�Ƿ�����չ���������ڵ� 
		useSelection			: true,				   // ѡ��ĳ���ڵ����Ƿ������ʾ
		useCookies				: false,
		useLines				: false,
		useIcons				: true,
		useStatusText			: false,
		closeSameLevel			: false,
		inOrder					: false,
		
		useControl				: true,					// �Ƿ�ʹ��ѡ��ؼ� 
		controlType				: 'radio',				// ѡ��ؼ�������input�ؼ���type�����б�Ĭ��Ϊcheckbox
		isRootUseControl		: false,					// ���ڵ��Ƿ�ʹ�ÿؼ� 
		isDisplay				: true,						// ���Ƿ���ʾ��Ĭ��Ϊ��ʾ
		typeIdArrayName			: 'typeIdArray',		// ��װ����ѡ��id�б������
		nodeIdArrayName			: 'nodeIdArray',		// ��װ��ͨ�ڵ�ѡ��id�б������
		cssLink 				: '<link href=../../css/dtree.css type=text/css rel=StyleSheet>',	// dTree��ʹ�õ�css�ļ�
		strSplitNameSeparator	: ';',					// �û�ѡ��Ľ�����Ƶķָ����
		strSplitIdSeparator		: ',',					// �û�ѡ���database id�еķָ����
		isCorrelateSelect		: true,				// �������¼���ѡ ����ؼ�������Ϊcheckbox����ѡ������ʱ�Ƿ���ѡ���������ͼ��ڵ㣬Ĭ��Ϊfalse ������ѡ��
		isReverseCorrelateSelect		: true,			// �������ϼ���ѡ ����ؼ�������Ϊcheckbox����ѡ�����ͻ�ڵ�ʱ�Ƿ���ѡ����������ֱ������Ĭ��Ϊfalse �����ϼ�����ѡ��
		isSingleCorrelateLayer			: false,			// �Ƿ�Ϊ���㼶��ѡ�񡣼�ֻѡ���������һ�������ͼ��ڵ㡣Ĭ��Ϊfalse�������ѡ��
		isSingleReverseCorrelateLayer	: false,			// �������ϼ���ѡʱ���Ƿ�Ϊ���㼶��ѡ�񡣼�ֻѡ������ͻ�ڵ����һ�������͡�Ĭ��Ϊfalse�������ѡ��ֱ�����ڵ�
		correlateSelectType				: 'all',			// ��ѡ�����ͽڵ�ʱ����ѡ������͡�Ĭ��Ϊall���ͺͽڵ�һ��ѡ��typeֻѡ�����͡�nodeֻѡ��ڵ㡣
		isEventOnOk						: false,			// �û�ѡ��ȷ�����Ƿ񴥷��¼�
		isLockDisabledNodeChecked		: false				// ����������ΪisDisabled==true���ؼ���isCheckedѡ��״̬��false��������true������Ĭ��Ϊfalse

	}
	this.icon = {
		root				: '../../images/tree/icon_yxza.gif',
		folder			: '../../images/tree/folder.gif',
		folderOpen	: '../../images/tree/folderopen.gif',
		node				: '../../images/tree/null.gif',
		empty				: '../../images/tree/empty.gif',
		line				: '../../images/tree/empty.gif',
		join				: '../../images/tree/empty.gif',
		joinBottom	: '../../images/tree/empty.gif',
		plus				: '../../images/tree/folder_sign_close.gif',
		plusBottom	: '../../images/tree/folder_sign_close.gif',
		minus				: '../../images/tree/folder_sign_open.gif',
		minusBottom	: '../../images/tree/folder_sign_open.gif',
		nlPlus			: '../../images/tree/nolines_plus.gif',
		nlMinus			: '../../images/tree/nolines_minus.gif'
	};
	this.obj = objName;
	this.aNodes = [];
	this.aIndent = [];
	this.root = new Node(-1);
	this.selectedNode = null;
	this.selectedFound = false;
	this.completed = false;
};

// Adds a new node to the node array
dTree.prototype.add = function(id, pid, name, isType, isChecked, isDisabled, url, title, target, icon, iconOpen, open) {
	
	// ת���ַ���Ϊboolean�ͣ�����ͳһ��Ҳ��ֹjsp���������Ҳ���Ϊ''����js�ű�����
	if(isChecked=='true' || isChecked==true)
	{
		isChecked = true;
	}
	else
	{
		isChecked = false;
	}
	
	if(isType=='true' || isType==true)
	{
		isType = true;
	}
	else
	{
		isType = false;
	}
	
	if(isDisabled=='true' || isDisabled==true)
	{
		isDisabled = true;
	}
	else
	{
		isDisabled = false;
	}
	
	var valueTemp = id;
	
	// Ϊid,pid���������ͷ
	if(isType==true)
	{
		id = 't' + id;
		if((pid!='-1') && (pid!=-1))
		{
			pid = 't' + pid;
		}
	}
	else
	{
		id = 'n' + id;
		if((pid!='-1') && (pid!=-1))
		{
			pid = 't' + pid;
		}
	}
	
	this.aNodes[this.aNodes.length] = new Node(id, pid, name, valueTemp, url, title, target, icon, iconOpen, open, isChecked, isType, isDisabled);
};

// Open/close all nodes
dTree.prototype.openAll = function() {
	this.oAll(true);
};
dTree.prototype.closeAll = function() {
	this.oAll(false);
};

// ������html
dTree.prototype.toString = function() {
	// shield useCookies
	this.config.useCookies = false;
	
	var str = '<div class="dtree"';
	if(this.config.isDisplay==false)
	{
		str += 'style="display:none"';
	}
	str += '>\n';
	if (document.getElementById) {
		if (this.config.useCookies) this.selectedNode = this.getSelected();
		str += this.addNode(this.root);
	} else str += 'Browser not supported.';
	str += '</div>';
	if (!this.selectedFound) this.selectedNode = null;
	this.completed = true;
	return str;
};


// Creates the tree structure
// ���pNode�������ӽڵ�ṹ����һ�㣩
dTree.prototype.addNode = function(pNode) {
	var str = '';
	var n=0;
	if (this.config.inOrder) n = pNode._ai;
	for (n; n<this.aNodes.length; n++) {
		if (this.aNodes[n].pid == pNode.id) {
			var cn = this.aNodes[n];
			cn._p = pNode;
			cn._ai = n;
			this.setCS(cn);
			if (!cn.target && this.config.target) cn.target = this.config.target;
			if (cn._hc && !cn._io && this.config.useCookies) cn._io = this.isOpen(cn.id);
			if (!this.config.folderLinks && cn._hc) cn.url = null;
			if (this.config.useSelection && cn.id == this.selectedNode && !this.selectedFound) {
					cn._is = true;
					this.selectedNode = n;
					this.selectedFound = true;
			}
			str += this.node(cn, n);
			if (cn._ls) break;
		}
	}
	return str;
};

// Creates the node icon, url and text
dTree.prototype.node = function(node, nodeId) {
	var str = '<div class="dTreeNode">' + this.indent(node, nodeId);
	// �ж��Ƿ�ʹ�ÿؼ�
	if(this.config.useControl==true)
	{
		if(this.root.id!=node.pid || this.config.isRootUseControl==true)
		{// ��Ϊ���ڵ�������˸��ڵ�ʹ�ÿؼ����ɿؼ�
			// ʹ�ÿؼ�������html����
			str += '<input id="ctrl' + this.obj + nodeId + '" name="';
			
			// �����������ɿؼ�����
			if(node.isType==true)
			{
				str += this.config.typeIdArrayName;
			}
			else
			{
				str += this.config.nodeIdArrayName;
			}
			
			str += '" type="' + this.config.controlType + '" value="' + node.value + '" ';
			
			// ���ݲ�����ʾ���ÿؼ��ɲ���״̬
			if(node.isDisabled==true)
			{// �ؼ����ɼ�
				str += ' style="display:none" ';
			}
	
			// �ж��Ƿ�Ϊcheckbox �� radio
			if(this.config.controlType=='checkbox' || this.config.controlType=='radio')
			{
				// ��ѡ�����Ϳؼ����ݽڵ��ѡ��״̬���ÿؼ�״̬
				if(node.isChecked==true)
				{
					str += ' checked="checked" ';
				}
				
				// �û��ı�ҳ��ؼ�ѡ��״̬ʱͬʱ�ı���Ӧ�ڵ�ѡ��״̬
				if(node.isDisabled==false)
				{
					str += ' onClick="javascript: ' + this.obj + '.setChecked(' + nodeId + ', this.checked);" ';
				}
			}
			str += ' />';
		}
	}
	
	if (this.config.useIcons) {
		if (!node.icon) node.icon = (this.root.id == node.pid) ? this.icon.root : ((node._hc || node.isType) ? this.icon.folder : this.icon.node);
		if (!node.iconOpen) node.iconOpen = (node._hc || node.isType) ? this.icon.folderOpen : this.icon.node;
		if (this.root.id == node.pid) {
			node.icon = this.icon.root;
			node.iconOpen = this.icon.root;
		}
		str += '<img id="i' + this.obj + nodeId + '" src="' + ((node._io) ? node.iconOpen : node.icon) + '" alt="" />';
	}
	if (node.url) {
		str += '<a id="s' + this.obj + nodeId + '" class="' + ((this.config.useSelection) ? ((node._is ? 'nodeSel' : 'node')) : 'node') + '" href="' + node.url + '"';
		if (node.title) str += ' title="' + node.title + '"';
		if (node.target) str += ' target="' + node.target + '"';
		if (this.config.useStatusText) str += ' onmouseover="window.status=\'' + node.name + '\';return true;" onmouseout="window.status=\'\';return true;" ';
		if (this.config.useSelection && ((node._hc && this.config.folderLinks) || !node._hc))
			str += ' onclick="javascript: ' + this.obj + '.s(' + nodeId + ');"';
		str += '>';
	}
	else if ((!this.config.folderLinks || !node.url) && node._hc && node.pid != this.root.id)
	{
		str += '<a href="#" onClick="javascript: ' + this.obj + '.o(' + nodeId + ');" class="node">';
	}
	
	str += node.name;
	
	if (node.url || ((!this.config.folderLinks || !node.url) && node._hc)) str += '</a>';
	str += '</div>';
	if (node._hc) {
		str += '<div id="d' + this.obj + nodeId + '" class="clip" style="display:' + ((this.root.id == node.pid || node._io) ? 'block' : 'none') + ';">';
		str += this.addNode(node);
		str += '</div>';
	}
	this.aIndent.pop();
	return str;
};

// Adds the empty and line icons
dTree.prototype.indent = function(node, nodeId) {
	var str = '';
	if (this.root.id != node.pid) {
		for (var n=0; n<this.aIndent.length; n++)
			str += '<img src="' + ( (this.aIndent[n] == 1 && this.config.useLines) ? this.icon.line : this.icon.empty ) + '" alt="" />';
		(node._ls) ? this.aIndent.push(0) : this.aIndent.push(1);
		if (node._hc) {
			str += '<img id="j' + this.obj + nodeId + '" style="CURSOR:hand" onClick="javascript: ' + this.obj + '.o(' + nodeId + ');" src="';
			if (!this.config.useLines) str += (node._io) ? this.icon.nlMinus : this.icon.nlPlus;
			else str += ( (node._io) ? ((node._ls && this.config.useLines) ? this.icon.minusBottom : this.icon.minus) : ((node._ls && this.config.useLines) ? this.icon.plusBottom : this.icon.plus ) );
			str += '" alt="" />';
		} else str += '<img src="' + ( (this.config.useLines) ? ((node._ls) ? this.icon.joinBottom : this.icon.join ) : this.icon.empty) + '" alt="" />';
	}
	return str;
};

// Checks if a node has any children and if it is the last sibling
dTree.prototype.setCS = function(node) {
	var lastId;
	for (var n=0; n<this.aNodes.length; n++) {
		if (this.aNodes[n].pid == node.id) node._hc = true;
		if (this.aNodes[n].pid == node.pid) lastId = this.aNodes[n].id;
	}
	if (lastId==node.id) node._ls = true;
};

// Returns the selected node
dTree.prototype.getSelected = function() {
	var sn = this.getCookie('cs' + this.obj);
	return (sn) ? sn : null;
};

// Highlights the selected node
dTree.prototype.s = function(id) {
	if (!this.config.useSelection) return;
	var cn = this.aNodes[id];
	if (cn._hc && !this.config.folderLinks) return;
	if (this.selectedNode != id) {
		if (this.selectedNode || this.selectedNode==0) {
			eOld = document.getElementById("s" + this.obj + this.selectedNode);
			eOld.className = "node";
		}
		eNew = document.getElementById("s" + this.obj + id);
		eNew.className = "nodeSel";
		this.selectedNode = id;
		if (this.config.useCookies) this.setCookie('cs' + this.obj, cn.id);
	}
};

// Toggle Open or close
dTree.prototype.o = function(id) {
	var cn = this.aNodes[id];
	this.nodeStatus(!cn._io, id, cn._ls);
	cn._io = !cn._io;
	if (this.config.closeSameLevel) this.closeLevel(cn);
	if (this.config.useCookies) this.updateCookie();
};

// Open or close all nodes
dTree.prototype.oAll = function(status) {
	for (var n=0; n<this.aNodes.length; n++) {
		if (this.aNodes[n]._hc && this.aNodes[n].pid != this.root.id) {
			this.nodeStatus(status, n, this.aNodes[n]._ls)
			this.aNodes[n]._io = status;
		}
	}
	if (this.config.useCookies) this.updateCookie();
};

// Opens the tree to a specific node
dTree.prototype.openTo = function(nId, bSelect, bFirst) {
	if (!bFirst) {
		for (var n=0; n<this.aNodes.length; n++) {
			if (this.aNodes[n].id == nId) {
				nId=n;
				break;
			}
		}
	}
	var cn=this.aNodes[nId];
	if (cn.pid==this.root.id || !cn._p) return;
	cn._io = true;
	cn._is = bSelect;
	if (this.completed && cn._hc) this.nodeStatus(true, cn._ai, cn._ls);
	if (this.completed && bSelect) this.s(cn._ai);
	else if (bSelect) this._sn=cn._ai;
	this.openTo(cn._p._ai, false, true);
};

// Opens the tree to a specific node by logic id
dTree.prototype.openToAndHighlightSelectedNode = function(nId, isType, bSelect) {
	for(var i = 0; i < this.aNodes.length; i++)
	{
		if(this.aNodes[i].value==nId && this.aNodes[i].isType==isType)
		{
			break;
		}
	}
	
	if(i < this.aNodes.length)
	{
		this.openTo(this.aNodes[i]._ai, bSelect, true);
	}
};

// Closes all nodes on the same level as certain node
dTree.prototype.closeLevel = function(node) {
	for (var n=0; n<this.aNodes.length; n++) {
		if (this.aNodes[n].pid == node.pid && this.aNodes[n].id != node.id && this.aNodes[n]._hc) {
			this.nodeStatus(false, n, this.aNodes[n]._ls);
			this.aNodes[n]._io = false;
			this.closeAllChildren(this.aNodes[n]);
		}
	}
}

// Closes all children of a node
dTree.prototype.closeAllChildren = function(node) {
	for (var n=0; n<this.aNodes.length; n++) {
		if (this.aNodes[n].pid == node.id && this.aNodes[n]._hc) {
			if (this.aNodes[n]._io) this.nodeStatus(false, n, this.aNodes[n]._ls);
			this.aNodes[n]._io = false;
			this.closeAllChildren(this.aNodes[n]);		
		}
	}
}

// Change the status of a node(open or closed)
dTree.prototype.nodeStatus = function(status, id, bottom) {
	eDiv	= document.getElementById('d' + this.obj + id);
	eJoin	= document.getElementById('j' + this.obj + id);
	if (this.config.useIcons) {
		eIcon	= document.getElementById('i' + this.obj + id);
		eIcon.src = (status) ? this.aNodes[id].iconOpen : this.aNodes[id].icon;
	}
	eJoin.src = (this.config.useLines)?
	((status)?((bottom)?this.icon.minusBottom:this.icon.minus):((bottom)?this.icon.plusBottom:this.icon.plus)):
	((status)?this.icon.nlMinus:this.icon.nlPlus);
	eDiv.style.display = (status) ? 'block': 'none';
};


// [Cookie] Clears a cookie
dTree.prototype.clearCookie = function() {
	var now = new Date();
	var yesterday = new Date(now.getTime() - 1000 * 60 * 60 * 24);
	this.setCookie('co'+this.obj, 'cookieValue', yesterday);
	this.setCookie('cs'+this.obj, 'cookieValue', yesterday);
};

// [Cookie] Sets value in a cookie
dTree.prototype.setCookie = function(cookieName, cookieValue, expires, path, domain, secure) {
	document.cookie =
		escape(cookieName) + '=' + escape(cookieValue)
		+ (expires ? '; expires=' + expires.toGMTString() : '')
		+ (path ? '; path=' + path : '')
		+ (domain ? '; domain=' + domain : '')
		+ (secure ? '; secure' : '');
};

// [Cookie] Gets a value from a cookie
dTree.prototype.getCookie = function(cookieName) {
	var cookieValue = '';
	var posName = document.cookie.indexOf(escape(cookieName) + '=');
	if (posName != -1) {
		var posValue = posName + (escape(cookieName) + '=').length;
		var endPos = document.cookie.indexOf(';', posValue);
		if (endPos != -1) cookieValue = unescape(document.cookie.substring(posValue, endPos));
		else cookieValue = unescape(document.cookie.substring(posValue));
	}
	return (cookieValue);
};

// [Cookie] Returns ids of open nodes as a string
dTree.prototype.updateCookie = function() {
	var str = '';
	for (var n=0; n<this.aNodes.length; n++) {
		if (this.aNodes[n]._io && this.aNodes[n].pid != this.root.id) {
			if (str) str += '.';
			str += this.aNodes[n].id;
		}
	}
	this.setCookie('co' + this.obj, str);
};

// [Cookie] Checks if a node id is in a cookie
dTree.prototype.isOpen = function(id) {
	var aOpen = this.getCookie('co' + this.obj).split('.');
	for (var n=0; n<aOpen.length; n++)
		if (aOpen[n] == id) return true;
	return false;
};

// If Push and pop is not implemented by the browser
if (!Array.prototype.push) {
	Array.prototype.push = function array_push() {
		for(var i=0;i<arguments.length;i++)
			this[this.length]=arguments[i];
		return this.length;
	}
};
if (!Array.prototype.pop) {
	Array.prototype.pop = function array_pop() {
		lastElement = this[this.length-1];
		this.length = Math.max(this.length-1,0);
		return lastElement;
	}
};

// ����������id���Ժż�ѡ��״̬�����ýڵ����ҳ�浱ǰѡ��״̬
dTree.prototype.setTreeNodeChecked = function(id, checked)
{
		this.aNodes[id].isChecked = checked;
		var elementTemp = document.getElementById('ctrl' + this.obj + id);
		
		if(elementTemp!=null)
		{
			elementTemp.checked = checked;
		}
};


// ��������id���ԺŵĽڵ�Ϊ������������ͽڵ�������ȣ�����ǽڵ������ȡ�����ѡ�����ͼ��ڵ�
dTree.prototype.setCorrelateSelect = function(id, checked)
{
	// ���õ�ǰ���ͽڵ�ѡ��״̬
	this.setTreeNodeChecked(id, checked);
	
	// ����ѡ���������ͼ��ڵ�ѡ��״̬
	for(var i=0; i < this.aNodes.length; i++)
	{// ѭ������ѡ�����ͼ��ڵ�
		if(this.aNodes[i].pid==this.aNodes[id].id)
		{// ѭ����ǰ�ڵ�Ϊ���ڵ���һ�������ͻ�ڵ�
			if(this.aNodes[i].isType==false)
			{// �ǽڵ�
				if(this.config.correlateSelectType=='all' || this.config.correlateSelectType=='node')
				{
					this.setTreeNodeChecked(this.aNodes[i]._ai, checked);
				}
			}
			else
			{// ���ͽڵ�
				// �жϼ������
				if(this.config.isSingleCorrelateLayer==false)
				{// �����ѡ��
					this.setCorrelateSelect(this.aNodes[i]._ai, checked);
				}
				else
				{// һ��
					if(this.config.correlateSelectType=='all' || this.config.correlateSelectType=='type')
					{
						this.setTreeNodeChecked(this.aNodes[i]._ai, checked);
					}
				}
			}
		}
	}
};

// ����������id���Ժź�Ŀ�꣬���ýڵ㵱ǰѡ��״̬
dTree.prototype.setChecked = function(id, checked)
{
	// �ؼ�Ϊradio����,������нڵ�ؼ�ѡ��״̬
	if(this.config.controlType=='radio')
	{
		for(var i=0; i < this.aNodes.length; i++)
		{
				this.aNodes[i].isChecked = false;
		}
		
		this.setTreeNodeChecked(id, checked);
	}
	else
	{// Ϊcheckbox�ؼ�
		// �ж��Ƿ�ʹ�ü���ѡ��
		if(this.config.isCorrelateSelect==true)
		{// ����ѡ��
			if(this.aNodes[id].isType==true)
			{
				this.setCorrelateSelect(id, checked);
			}
			else
			{
				this.setTreeNodeChecked(id, checked);
			}
		}
		else
		{
			this.setTreeNodeChecked(id, checked);
		}
		
		// �жϵ�ǰ�ڵ��Ƿ���ѡ��״̬��ֻ��ѡ�вŽ��з�����ѡ
		if(checked==true)
		{
			// �ж��Ƿ�ʹ�÷�����ѡ
			if(this.config.isReverseCorrelateSelect==true)
			{// ������ѡ
				// �õ���ǰ���ͻ�ڵ�ĸ��׽ڵ���󣬳�ʼ��
				var parentNodeTemp = this.aNodes[id]._p;
				
				while(parentNodeTemp.pid!=undefined)
				{// �Ǹ��ڵ�ѡ�и����ͽڵ�
					if(parentNodeTemp.pid!=-1 || this.config.isRootUseControl==true)
					{
						this.setTreeNodeChecked(parentNodeTemp._ai, true);
					}
					
					parentNodeTemp = parentNodeTemp._p;
				}
			}
		}
	}
		
};

// ���ݿؼ�idֵ����ѡ��״̬
dTree.prototype.setCheckedCtrlId = function(id, checked) 
{
	var str = '';
	
	for(var i=0; i<id.length; i++)
	{
		var char = id.substr(i, 1);
		
		if(char=='0' || char=='1' || char=='2' || char=='3' || char=='4' || char=='5' || char=='6' || char=='7' || char=='8' || char=='9')
		{
			str += char;
		}
	}
	
	if(str!='')
	{
		this.aNodes[str].isChecked = checked;
	}
};

function showModalDialogTree(tree, inputCtrlId)
{
    
    var array = new Array(3);
    array[0] = tree;
    array[1] = inputCtrlId;
    array[2] = window;
    
	window.showModalDialog("../jsp/commonTreeIframe.jsp", array, 'dialogWidth=300px;dialogHeight=520px;status:no;resizable:no;help:no;scroll:no');
}

function printTreeToNewWindow(tree, inputCtrlId)
{
	showModalDialogTree(tree, inputCtrlId);
}

function replaceAll(strPrimalString, strOldSubString, strNewSubString)
{
	var str = strPrimalString;
	
	while(str.indexOf(strOldSubString) >= 0)
	{
		str = str.replace(strOldSubString, strNewSubString);
	}
	
	return str;
}

function replaceSpecialCharacter(str)
{
	var str1 = replaceAll(str, '&amp;', '&');
	
	var str2 = replaceAll(str1, '&lt;', '<');
	
	var str3 = replaceAll(str2, '&gt;', '>');
	
	var str4 = replaceAll(str3, '&#039;', '\'');
	
	var str5 = replaceAll(str4, '&#034;', '\"');

	return str5;
}

// �õ��û�ѡ��Ľڵ����ƣ����Էֺ�";"�ָ�,����Ҫ�����ָ������config�ж���
dTree.prototype.getSelectedNameList = function()
{
	if(this.config.useControl==true)
	{// ʹ�ÿؼ�
		// �ж��û�ʹ�ÿؼ�����
		if(this.config.controlType=='radio')
		{
			var str = '';
			
			for(var i=0; i < this.aNodes.length; i++)
			{
				if(this.aNodes[i].isChecked==true)
				{
					str += this.aNodes[i].name + this.config.strSplitNameSeparator + ' ';
					
					break;
				}
			}
		}
		else if(this.config.controlType=='checkbox')
		{
			var str = '';
			
			for(var i=1; i < this.aNodes.length; i++)
			{
				if(this.aNodes[i].isChecked==true)
				{
					if(this.aNodes[i].isType==true)
					{// ����
						if(this.config.correlateSelectType=='all' || this.config.correlateSelectType=='type')
						{
							str += this.aNodes[i].name + this.config.strSplitNameSeparator + ' ';
						}
					}
					else
					{// �ڵ�
						if(this.config.correlateSelectType=='all' || this.config.correlateSelectType=='node')
						{
							str += this.aNodes[i].name + this.config.strSplitNameSeparator + ' ';
						}
					}
				}
			}
		}
		
		// str = replaceSpecialCharacter(str);
		
		if(str.substring(str.length - 2, str.length)==this.config.strSplitNameSeparator + ' ')
		{
			return str.substring(0, str.length - 2);
		}
		else
		{
			return str;
		}
	}
};

// �õ��û�ѡ��Ľڵ����ݿ�id�����Էֺ�","�ָ�,����Ҫ�����ָ������config�ж���
dTree.prototype.getSelectedDatabaseIdList = function()
{
	if(this.config.useControl==true)
	{// ʹ�ÿؼ�
		// �ж��û�ʹ�ÿؼ�����
		var str = '';
		
		if(this.config.controlType=='radio')
		{
			for(var i=0; i < this.aNodes.length; i++)
			{
				if(this.aNodes[i].isChecked==true)
				{
					str += this.aNodes[i].value + this.config.strSplitIdSeparator;
					
					break;
				}
			}
		}
		else if(this.config.controlType=='checkbox')
		{
			for(var i=1; i < this.aNodes.length; i++)
			{
				if(this.aNodes[i].isChecked==true)
				{
					if(this.aNodes[i].isType==true)
					{// ����
						if(this.config.correlateSelectType=='all' || this.config.correlateSelectType=='type')
						{
							str += this.aNodes[i].value + this.config.strSplitIdSeparator;
						}
					}
					else
					{// �ڵ�
						if(this.config.correlateSelectType=='all' || this.config.correlateSelectType=='node')
						{
							str += this.aNodes[i].value + this.config.strSplitIdSeparator;
						}
					}
				}
			}
		}
		
		if(str.substring(str.length - 1, str.length)==this.config.strSplitIdSeparator)
		{
			return str.substring(0, str.length - 1);
		}
		else
		{
			return str;
		}
	}
};

// ���ݽڵ����ݿ�ID�����ͱ�־������ʾ��Ӧ�����ڵ�
dTree.prototype.highlightSelectedNode = function(value, isType) {
	if(value=="")
	{
		value = 0;
	}
	
	if(isType=="true" || isType==true)
	{
		isType = true;
	}
	else
	{
		isType = false;
	}

	for(var i=0; i < this.aNodes.length; i++)
	{// ����������ڵ�
		// �ж��Ƿ������value��isTypeֵ��ȵĽڵ�
		if(this.aNodes[i].value==value && this.aNodes[i].isType==isType)
		{
			// ����Ӧ�ڵ������ʾ
			this.s(this.aNodes[i]._ai);
			
			break;
		}
	}
};

// ����������id���Ժż��ɲ���״̬�����ö�Ӧ�ؼ���ǰ�ɲ���״̬
dTree.prototype.setNodeControlDisabled = function(id, disabled)
{
	var elementTemp = document.getElementById('ctrl' + this.obj + id);
	
	if(elementTemp!=null)
	{
		elementTemp.disabled = disabled;
	}
};

// ���������еĿؼ����ó�disabled״̬
dTree.prototype.setAllControlDisabled = function(disabled)
{
	if(this.config.useControl==true)
	{// ʹ�ÿؼ�
		for(var i=0; i < this.aNodes.length; i++)
		{// ����������ڵ�
			// ����״̬
			this.setNodeControlDisabled(this.aNodes[i]._ai, disabled);
		}
	}
};

// ���ݽڵ����ݿ�ID�����ͱ�־����ѡ��״̬
dTree.prototype.setCheckedNode = function(id, isType, checked) {
	if(isType=="true" || isType==true)
	{
		isType = true;
	}
	else
	{
		isType = false;
	}

	for(var i=0; i < this.aNodes.length; i++)
	{// ����������ڵ�
		// �ж��Ƿ������value��isTypeֵ��ȵĽڵ�
		if(this.aNodes[i].value==id && this.aNodes[i].isType==isType)
		{
			// ����Ӧ�ڵ������ʾ
			this.setChecked(this.aNodes[i]._ai, checked);
			
			break;
		}
	}
};

dTree.prototype.reset = function()
{
	if(this.config.useControl==true)
	{// ֻ��ʹ�ÿؼ�������ѡ��״̬
		// �ж�ʹ�ÿؼ�����
		if(this.config.controlType=='radio')
		{
			// ���������ѡ��״̬
			for(var i=0; i < this.aNodes.length; i++)
			{
				this.aNodes[i].isChecked = false;
			}
			
			// ��ҳ��ؼ�����ѡ��״̬
			for(var i=0; i < this.aNodes.length; i++)
			{
				var elementTemp = document.getElementById('ctrl' + this.obj + this.aNodes[i]._ai);
				if(elementTemp!=null)
				{
					if(elementTemp.checked==true)
					{
						// ����ѡ��״̬
						this.aNodes[i].isChecked = true;
						
						break;
					}
				}
			}
		}
		else if(this.config.controlType=='checkbox')
		{
			// ����ѡ��״̬
			for(var i=0; i < this.aNodes.length; i++)
			{
				var elementTemp = document.getElementById('ctrl' + this.obj + this.aNodes[i]._ai);
				if(elementTemp!=null)
				{
					// ����ѡ��״̬
					this.aNodes[i].isChecked = elementTemp.checked;
				}
			}
		}
	}
};

// ���ݽڵ����ݿ�ID�����ͱ�־����ѡ��״̬
dTree.prototype.getNodeName = function(id, isType) {
	if(isType=="true" || isType==true)
	{
		isType = true;
	}
	else
	{
		isType = false;
	}

	var strName = "";
	
	for(var i=0; i < this.aNodes.length; i++)
	{// ����������ڵ�
		// �ж��Ƿ������value��isTypeֵ��ȵĽڵ�
		if(this.aNodes[i].value==id && this.aNodes[i].isType==isType)
		{
			strName = this.aNodes[i].name;
			
			break;
		}
	}
	
	return strName;
};

//add by jeton.dong 20110805
		dTree.prototype.getMyNodeId = function(dbid) {
			var jetonTreeId = "";
			for(var i=0; i < this.aNodes.length; i++)
			{// ����������ڵ�
				// �ж��Ƿ������value��isTypeֵ��ȵĽڵ�
				if(this.aNodes[i].value==dbid)
				{
					jetonTreeId = i;
					
					break;
				}
			}
			return jetonTreeId;
		};