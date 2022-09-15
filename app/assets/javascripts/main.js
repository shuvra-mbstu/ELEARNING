function validate(event) {
  text = document.getElementById('search-text').value
  if (text.length >= 3) return true
  else {
    alert(I18n.t('notice.search_alert'))
    event.preventDefault()
    return false
  }
}

$(function () {
  $('.alert')
    .fadeTo(3000, 500)
    .slideUp(500, function () {
      $('.alert').alert('close')
    })
})
