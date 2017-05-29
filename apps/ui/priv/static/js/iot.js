var iot_reload = function(){
  $.ajax({
      type: "GET",
      url: "/api/v1/get_data",
      dataType: 'JSON',
      success: function(data){
        console.log(data);

        rows = data.data;

        var html = "";
        var color = 'red', icon = 'toys',
          sub_icon = 'updated', metric = 'C';

        var content = $('#iot_sensors');

        content.html(html);

        for (var attr in rows) {
          console.log(attr);
          var row = rows[attr];

          if (row.type == "gas") {
            color = 'orange', icon = 'warning',
              sub_icon = 'updated', metric = '';
          }
          else if (row.type == "switch") {
            color = 'blue', icon = 'settings_power',
              sub_icon = 'updated', metric = '';
          }
          else if (row.type == "flow") {
            color = 'green', icon = 'arrow_forward',
              sub_icon = 'updated', metric = '';
          }
          else if (row.type == "hits") {
            color = 'orange', icon = 'looks_3',
              sub_icon = 'updated', metric = '';
          }
          else{
            color = 'red', icon = 'toys',
              sub_icon = 'updated', metric = 'C';
          }

          html  = '<div class="col-lg-3 col-md-6 col-sm-6">'
          html += '	<div class="card card-stats">'
          html += '		<div class="card-header" data-background-color="' + color + '">'
          html += '			<i class="material-icons">' + icon + '</i>'
          html += '		</div>'
          html += '		<div class="card-content">'
          html += '			<p class="category">' + row.id + '</p>'
          html += '			<h3 class="title">' + row.value + metric + '</h3>'
          html += '		</div>'
          html += '		<div class="card-footer">'
          html += '			<div class="stats">'
          html += '				<i class="material-icons">' + sub_icon + '</i> Just Updated'
          html += '			</div>'
          html += '		</div>'
          html += '	</div>'
          html += '</div>'

          content.append(html);
        }
      },
      error: function(data){
        console.log('Error:');
        console.log(data);
      }
    });
}

$(document).ready(setInterval(iot_reload, 1000));
