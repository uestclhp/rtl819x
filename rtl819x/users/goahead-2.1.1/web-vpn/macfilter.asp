<html>
<! Copyright (c) Realtek Semiconductor Corp., 2003. All Rights Reserved. ->
<head>
<meta http-equiv="Content-Type" content="text/html">
<title>MAC Filtering</title>
<script type="text/javascript" src="common.js"> </script>
<script>
function addClick()
{
  if (!document.formFilterAdd.enabled.checked)
  	return true;

  if (document.formFilterAdd.mac.value=="" && document.formFilterAdd.comment.value=="" )
	return true;

  var str = document.formFilterAdd.mac.value;
  if ( str.length < 12) {
	alert("Input MAC address is not complete. It should be 12 digits in hex.");
	document.formFilterAdd.mac.focus();
	return false;
  }

  for (var i=0; i<str.length; i++) {
    if ( (str.charAt(i) >= '0' && str.charAt(i) <= '9') ||
			(str.charAt(i) >= 'a' && str.charAt(i) <= 'f') ||
			(str.charAt(i) >= 'A' && str.charAt(i) <= 'F') )
			continue;

	alert("Invalid MAC address. It should be in hex number (0-9 or a-f).");
	document.formFilterAdd.mac.focus();
	return false;
  }
  return true;
}


function deleteClick()
{
  if ( !confirm('Do you really want to delete the selected entry?') ) {
	return false;
  }
  else
	return true;
}

function deleteAllClick()
{
   if ( !confirm('Do you really want to delete the all entries?') ) {
	return false;
  }
  else
	return true;
}

function disableDelButton()
{
	disableButton(document.formFilterDel.deleteSelFilterMac);
	disableButton(document.formFilterDel.deleteAllFilterMac);
}

function updateState()
{
  if (document.formFilterAdd.enabled.checked) {
 	enableTextField(document.formFilterAdd.mac);
	enableTextField(document.formFilterAdd.comment);
  }
  else {
 	disableTextField(document.formFilterAdd.mac);
	disableTextField(document.formFilterAdd.comment);
  }
}

</script>
</head>

<body>
<blockquote>
<h2><font color="#0000FF">MAC Filtering</font></h2>

<table border=0 width="500" cellspacing=4 cellpadding=0>
<tr><td><font size=2>
 Entries in this table are used to restrict certain types of data packets from your local
 network to Internet through the Gateway.  Use of such filters can be helpful in securing
 or restricting your local network.
</font></td></tr>

<tr><td><hr size=1 noshade align=top></td></tr>

<form action=/goform/formFilter method=POST name="formFilterAdd">
<tr><td><font size=2><b>
   	<input type="checkbox" name="enabled" value="ON" <% if (getIndex("macFilterEnabled")) write("checked");
   	%> ONCLICK=updateState()>&nbsp;&nbsp;Enable MAC Filtering</b><br>
    </td>
</tr>

<tr><td>
     <p><font size=2><b>MAC Address: </b> <input type="text" name="mac" size="15" maxlength="12">&nbsp;&nbsp;
   	<b><font size=2>Comment: </b> <input type="text" name="comment" size="16" maxlength="20"></font>
     </p>
     <p><input type="submit" value="Apply Changes" name="addFilterMac" onClick="return addClick()">&nbsp;&nbsp;
        <input type="reset" value="Reset" name="reset">
        <input type="hidden" value="/macfilter.asp" name="submit-url">
     </p>
  </td><tr>
  <script> updateState(); </script>
</form>
</table>

<br>
<form action=/goform/formFilter method=POST name="formFilterDel">
  <table border="0" width=500>
  <tr><font size=2><b>Current Filter Table:</b></font></tr>
  <% macFilterList(); %>
  </table>
  <br>
  <input type="submit" value="Delete Selected" name="deleteSelFilterMac" onClick="return deleteClick()">&nbsp;&nbsp;
  <input type="submit" value="Delete All" name="deleteAllFilterMac" onClick="return deleteAllClick()">&nbsp;&nbsp;&nbsp;
  <input type="reset" value="Reset" name="reset">
  <input type="hidden" value="/macfilter.asp" name="submit-url">
 <script>
   	<% entryNum = getIndex("macFilterNum");
   	  if ( entryNum == 0 ) {
      	  	write( "disableDelButton();" );
       	  } %>
 </script>
</form>

</blockquote>
</body>
</html>
