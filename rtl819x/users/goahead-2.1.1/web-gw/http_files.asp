<html>
<head>
<title>Realtek uWiFi</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<META http-equiv=Pragma content=no-cache >
<META HTTP-EQUIV="CACHE-CONTROL" CONTENT="NO-CACHE">
<script language="JavaScript" type="text/javascript">	
<!--
var break_continue=0;
var __AjaxReq = null;
var __update_wan_conn_status_period=4000;
var usb_storage_dev_array=new Array(16);
function get_by_id(id)
{
	with(document)
	{
		return getElementById(id);
	}
}





function update_usb_connect(connection)
{
	var usb_connect_disk="";
	var usb_connect;
	var mySplitResult;
	var i;
		if(break_continue==1)
			return;
	usb_connect_disk='<table id="table1" cellSpacing=1 cellPadding=2 width=100% border=0>';
	usb_connect_disk+='<tr><td width=65%></td><td width=25%></td>';
	usb_connect_disk+='<td></td><td></td></tr>';
	/*usb_connect_disk+='<tr><td colspan="4"><hr size=1 noshade align=top></td></tr>';*/
	usb_connect_disk+='<tr><td colspan="4"><font size=5 color="#000000">Shared  Partitions:</font></td></tr>';
	usb_connect = connection;
	mySplitResult= usb_connect.split("?");
	if(mySplitResult.length > 1){
		for(i = 0; i < (mySplitResult.length-1); i++){
			usb_connect_disk +='<tr><td><img src="/graphics/dir.gif" alt="(dir)" border=0 width=16 height=16><a href="'+mySplitResult[i]+'/">'+'<font size=5>'+mySplitResult[i]+'</font></a></td><td></td><td></td><td></td></tr>';
		}
	}else if(mySplitResult.length==1){
		usb_connect_disk +='<tr><td><font size=4 color="#808080">No shared  partition available.</font></td><td></td><td></td><td></td></tr>';
	}
	/*usb_connect_disk+='<tr><td colspan="4"><hr size=1 noshade align=top></td></tr></tbody></table>';*/
	usb_connect_disk+='</tbody></table>';
	document.getElementById("usb_connect_status").innerHTML=usb_connect_disk;
}


function get_by_name(name){
	with(document){
		return getElementsByName(name);
	}
}
function __createRequest()
{
	var request = null;
	try { request = new XMLHttpRequest(); }
	catch (trymicrosoft)
	{
		try { request = new ActiveXObject("Msxml2.XMLHTTP"); }
		catch (othermicrosoft)
		{
			try { request = new ActiveXObject("Microsoft.XMLHTTP"); }
			catch (failed)
			{
				request = null;
			}
		}
	}
	if (request == null) alert("Error creating request object !");
	return request;
}

function __send_request(url)
{
	if (__AjaxReq == null) __AjaxReq = __createRequest();
	__AjaxReq.open("GET", url, true);
	__AjaxReq.onreadystatechange = __update_page;
	__AjaxReq.send(null);
}

function generate_random_str()
{
	var d = new Date();
	var str=d.getFullYear()+"."+(d.getMonth()+1)+"."+d.getDate()+"."+d.getHours()+"."+d.getMinutes()+"."+d.getSeconds();
	return str;
}

function __update_state()
{
	__send_request("/usb_conninfo.asp?t="+generate_random_str());
}

function __update_page()
{
	var conn_msg="";
	if (__AjaxReq != null && __AjaxReq.readyState == 4)
	{
		if (__AjaxReq.responseText.substring(0,3)=="var")
		{
			eval(__AjaxReq.responseText);
			switch (__result[0])
			{
				case "OK":
				update_usb_connect(__result[1]);
				default :
					break;
			}
			setTimeout("__update_state()", __update_wan_conn_status_period);
			delete __result;
		}
	}
}



function change_chk_page()
{
	var i;
	update_usb_connect("<%dump_directory_index();%>");
__update_state();

}
function Apply_Changel()
{
	break_continue=1;
	return true;
}	
function do_change_html(target_page)
{
	location.href='http://<% getInfo("ip-lan"); %>/'+target_page+'?t='+new Date().getTime();
	return true;
}	
// End Script -->
</script>
</head>
<body onLoad="change_chk_page();">
<div id="check_usb_connect_status" style="display:none"></div>
<table id="table_setting" cellSpacing=1 cellPadding=2 width=100% border=0>
<tr><td><h1>Realtek uWiFi</h1></td><td></td><td></td><td align=right><img src="/graphics/router.gif" border=0 width=30 height=30><a href="home.asp"><font size=4>Settings</font></a></td></tr>
<tr><td colspan="4"><hr size=1 noshade align=top></td></tr>
</table>

<div id="usb_connect_status" style="display:block"></div>
<tr><hr size=1 noshade align=top></tr>
</body></html>
 

