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
    if (data["header"] == "validate email") {
      if (data["body"] == "valid") {
        let errorid = "#orderFriendsErrors" + data["userId"];
        if ($(errorid).length) {
          $(errorid).empty();
        }

        let friendsToAdd = "#friendsToAdd" + data["userId"];
        if ($(friendsToAdd).val().indexOf(data.email) == -1) {
          $(friendsToAdd).val($(friendsToAdd).val() + data.email + " ");
          let id = "#orderFriends" + data["userId"];
          if ($(id).length) {
            let user = {
              id :data.friend[0]["friend_id"],
              email : data.email
            }
            let clickId= `member${data.friend[0].friend_id}click`
                let addedElement = `<div class = "message text-center border p-3 mt-2" id=member${data.friend[0].friend_id}><p>${data.email}</p><span class = "btn btn-danger" userId = ${data["userId"]} email = ${data["email"]} id=${clickId}> Delete</span></div>`
            $(id).append(addedElement);
            $(id).on("click",`div > ${"#"+clickId}`, (e)=>{
              let hiddenInput = $("#friendsToAdd"+$("#"+ e.target.id).attr("userid"))
              let deletedEmail = $("#"+ e.target.id).attr("email")
              $("#"+ e.target.id).closest("div").fadeOut().remove();
              $(hiddenInput).val($(hiddenInput).val().replace(deletedEmail ,""))
              console.log( $(hiddenInput).val() )
            })
          }
        } else {
          errorMsg("you cant add the same member twice", data);
        }
      } else {
        errorMsg(data.body, data);
      }
    } else if(data["header"] ==  "new item"){



      console.log("done");
      console.log(data["users"]);
      let ids =  data["users"].map(user => "#order"+data["order_id"]+"user"+user);

      ids.map(user => {
        if($(user).length) {
          $(user).append('<tr><td>' + data["orderItem"].name + '</td><td>' + data["orderItem"].item_name + '</td><td>' + data["orderItem"].amount + '</td><td>' + data["orderItem"].price + '</td><td>' + data["orderItem"].comment + '</td></tr>')
        }
      });
    }
    
    else {
      let id = "#notification" + data["userId"];
      if ($(id).length) {
        $(id).append('<h1 class = "message" style="border-bottom: 1px solid black">' + data.body + "</h1>");
        $(id+"Trigger").click()
            .promise().done(
            function(){
            setTimeout( ()=> {
                  console.log("heelllo")
              $(id+"Trigger").click()

                }
                ,3000)
            }
        );
        var audioElement = document.createElement('audio');
        audioElement.setAttribute('src', 'https://cdn.staticcrate.com/stock-hd/audio/soundscrate-click-fx-tonal-18.mp3');
        audioElement.play();
        console.log("I'm here nw ")
      }
    }

    // Called when there's incoming data on the websocket for this channel
  },
});
function errorMsg(msg, data) {

  let id = "#orderFriendsErrors" + data["userId"];
  if ($(id).length) {
    $(id).empty();
    $(id).append('<span class = "message text-danger">' + msg + "</span>");

  }
}

