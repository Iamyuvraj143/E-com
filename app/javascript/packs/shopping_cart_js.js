$(document).ready(function() {
  $("[id^=quantity-]").on("change", function () {
    var cart_product_id = this.id.split('-')[1];
    var quantity = this.value

    $.ajax({
      type: "patch",
      headers: { 'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content') },
      url: "cart_products/"+ cart_product_id,
      data: { quantity:quantity },
      dataType: "json"
    });
  });
});
