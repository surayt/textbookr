collapse_top_level_items = ->
  $('nav#sidebar li.level_1 > ul').hide()
  return

restore_toc_scrollbar_position = ->
  pos = Cookies.get('wordcabin_toc_scrollbar_position')
  $('nav#sidebar').scrollTop pos or 0
  return

restore_toc_expansion_state = ->
  # Only one top-level item is supposed to be expanded
  collapse_top_level_items()
  # Figure out which one it is and expand it
  state = Cookies.get('wordcabin_toc_scrollbar_expansion_state')
  if state
    child = parseInt(state) + 1
  else
    child = 1
  $('nav#sidebar li.level_1:nth-child(' + child + ') > ul').show()
  return
  
make_sidebar_user_resizable = (min, max, mainmin) ->
  $('#divider').mousedown (e) ->
    e.preventDefault()
    $(document).mousemove (e) ->
      e.preventDefault()
      x = e.pageX - ($('#sidebar').offset().left)
      if x > min and x < max and e.pageX < $(window).width() - mainmin
        $('#sidebar').css 'width', x
        $('#content').css 'margin-left', x
      return
    return
  $(document).mouseup (e) ->
    $(document).unbind 'mousemove'
    return
    
add_content_fragment_delete_links = ->
  $('body.editor #sidebar ul li a').each ->
    href = $(this).attr('href')
    $(this).append('&nbsp;<a href="'+href+'" class="btn delete" data-method="delete"><i class="fa fa-trash"></i></a>')

$(document).ready ->
  # Need to be able to delete content fragments
  add_content_fragment_delete_links()
  # See to it that the sidebar's width can be changed
  make_sidebar_user_resizable(100, 1000, 200)
  # Restore or initially set TOC state
  restore_toc_scrollbar_position()
  restore_toc_expansion_state()
  # Disable the top level links and make them open their parents' child <ul>.
  # An advantage of doing things in the below order is that clicking an 
  # already expanded section won't close it but just keep it open, which
  # I find preferable from a UI perspective.
  $('nav#sidebar li.level_1 > a').click (e) ->
    # e.preventDefault();
    collapse_top_level_items()
    Cookies.set 'wordcabin_toc_scrollbar_expansion_state', $(this).parent().index()
    $(this).parent().children('ul').toggle()
    return
  # Cause second and third level links to save the TOC scrollbar position
  # to a cookie so it may be restored upon the page being loaded again.
  $('nav#sidebar li.level_2 a').click (e) ->
    Cookies.set 'wordcabin_toc_scrollbar_position', $('nav#sidebar').scrollTop()
    return
  return
