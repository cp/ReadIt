function hourToPeriod() {
  var d = new Date()
  var hour = d.getHours()

  if (hour > 18) {
    return "evening"
  } else if (hour > 12) {
    return "afternoon"
  } else {
    return "morning"
  }
}

function greeting(name, count) {
  return 'Good ' + hourToPeriod() + ', ' + name + '. You have ' + count + ' unread posts.'
}

function decreaseNumber(old) {
  if (old > 1) {
    return (old - 1).toString()
  } else {
    return 'no'
  }
}

function decreaseGreeting() {
  var greeting = document.getElementById('welcome').innerText
  var oldNumber = parseInt(greeting.split(' ')[5])
  var newNumber = decreaseNumber(oldNumber)
  document.getElementById('welcome').innerText = greeting.replace(oldNumber, newNumber);
}

function markRead(id) {
  var element = document.getElementById(id)
  element.className = "animated fadeOut"
  $.ajax({
    type: "POST",
    url: "/read/" + id,
    success: function() {
      decreaseGreeting()
      element.style.display='none';
    },
    error: function(error) {
      element.className = "";
      alert('There was an error. Please try again later.');
      console.log(error);
    }
  });
}