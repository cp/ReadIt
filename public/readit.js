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