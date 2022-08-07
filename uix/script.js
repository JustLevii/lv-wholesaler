var folderName = GetParentResourceName();
var itemsType = "";
$(function () {
    function display(bool) {
    if (bool) {
    $('#realBody').fadeIn();
        $("body").show();
    } else {
    $('#realBody').stop().fadeOut();
    $("body").hide();
    }
  }
  window.addEventListener('message', function(event) {
  var item = event.data;
  if (item.type === "ui") {
      if (item.status == true) {
          display(true)
          itemsType = item.itemsType;
          setItems(item.itemsType);
      } else {
          display(false)
      }
  }
})
display(false);
})

function setItems(itemType){
    $("#realBody").html("");
    $("#realBody").append('<a href="#" class="close" onclick="Close()">');
    $.post('http://'+folderName+'/getItems', JSON.stringify(itemType), function (cb) {
      jQuery.each(cb, function (index, value) {
        if(value.itemName != undefined){
                var limit = value.limit;
                if(value.unlimited){
                    limit = 99999;
                }
            var item = "'"+value.itemName+"'";
            var html = '<div class="product-item">'
            +'<img src="'+value.img+'" width="75px">'
            +'<div class="product-list">'
            +'<h3>'+value.name+'</h3>'
            +'<span class="price">'+value.value+'$</span>'
            +'<input type="number" value="1" class="button" min="1" max="'+limit+'" id="qty-'+value.itemName+'">'
            +'<input type="button" class="button buyItem" data-id="'+value.itemName+'" value="SAT" onclick="sell('+item+')"/>'
            +'</div>'
            +'</div>';
            $("#realBody").append(html);
        }
        });
    });
}
function sell(itemName){
    var qty = $("#qty-"+itemName).val();
    $.post('http://'+folderName+'/buyItem', JSON.stringify({itemName: itemName,qty:qty, shopType: itemsType }), function (cb) {	
        
    });
}
function Close(){
    $.post('http://'+folderName+'/closeUI', JSON.stringify(), function (cb) {	
        
    });
}