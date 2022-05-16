console.log("js working")
function qtyUpdate(qty, cart_id, product_qty){
    $.ajax({
    type: "patch",
    headers: { 'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content') },
    url: "cart_products/"+ cart_id,
    data: { qty: qty},
    dataType: "json",
  });
  }