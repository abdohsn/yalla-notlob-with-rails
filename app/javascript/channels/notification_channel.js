import consumer from "./consumer";

consumer.subscriptions.create("NotificationChannel", {
  connected() {
    console.log("connected ya ray2");
    // Called when the subscription is ready for use on the server
  },
  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    console.log(data);
    if(data["header"] ==  "new item"){

      console.log("done");
      console.log(data["users"]);
      let ids =  data["users"].map(user => "#order"+data["order_id"]+"user"+user);

      ids.map(user => {
        if($(user).length) {
          $(user).append('<tr><td>' + data["orderItem"].name + '</td><td>' + data["orderItem"].item_name + '</td><td>' + data["orderItem"].amount + '</td><td>' + data["orderItem"].price + '</td><td>' + data["orderItem"].comment + '</td></tr>')
          // Called when there's incoming data on the websocket for this channel
        }
      });
    }
    
   
  },
});
