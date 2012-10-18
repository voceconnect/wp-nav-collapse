$ = jQuery
$.fn.menuCollapse = (o)->

  # settings
  s =
    menuListItem  : 'ul.menu li'
    togglerElem   : 'a'
    togglerClass  : 'toggler'
    closedSymbol  : '+'
    openSymbol    : '-'
    speed         : '400'

  s = $.extend s, o

  # methods
  m =
    init: () ->
      m.destroy() # remove old togglers and bindings
      $("#{s.menuListItem}").each (index, element) =>
        prevLI    = $(element).prev 'li'
        nextLI    = $(element).next 'li'
        thisDepth = m.getDepth $(element)
        nextDepth = m.getDepth nextLI
        prevDepth = m.getDepth prevLI
        togglerSelector = "#{s.togglerElem}.#{s.togglerClass}"
        if thisDepth < nextDepth and nextDepth isnt false
          m.addToggler $(element) # add buttons to all LI elements that have children
        else if thisDepth > nextDepth or thisDepth == nextDepth or nextDepth is false
          m.destroy(nextLI.find togglerSelector )
        else if thisDepth > prevDepth or thisDepth == prevDepth or prevDepth is false
          m.destroy(prevLI.find togglerSelector )
      $("#{s.togglerElem}.#{s.togglerClass}").bind('click', m.clickEvent)
      this

    # WP only stores the depth of the LI at the end of a CSS class. We Extract it here.
    getDepth: (el) ->
      theClass = el.attr('class')
      if typeof theClass isnt 'undefined' and theClass?
        theClass = theClass.match(/menu-item-depth-./).toString()
        return parseInt theClass.charAt theClass.length-1
      false

    # append the toggler element to the LI element
    addToggler : (el, status = 'open') ->
      symbol = s.openSymbol
      symbol = s.closedSymbol if status == 'close'
      el.append "<#{s.togglerElem} class='#{s.togglerClass}' rel='#{status}'>#{symbol}</#{s.togglerElem}>"

    # returns the child-menu items as a jQuery object
    getChildren : (el, allChildren = false) ->
      parentLI    = el.parent 'li'
      parentDepth = m.getDepth parentLI
      children   = $() # storing children in a jQuery object
      siblings    = parentLI.nextAll 'li'
      siblings.each (index, element) =>
        # only effect elements w/ children
        if parentDepth < m.getDepth $(element) or parentDepth == m.getDepth $(element)
          if allChildren is true # get all children
            if parentDepth < m.getDepth $(element)
              children = children.add $(element )
          else # exclude grand-children
            if (parentDepth - m.getDepth $(element)) == -1
              children = children.add $(element )
        else # if no children
          return
      children

    # return the state (open/closed) for the toggler
    getState : (el) ->
      if typeof el isnt undefined
        $(el).attr('rel') if typeof $(el).attr('rel') isnt undefined
      else
        false

    # change the status and symbol of the toggler and return it's new state
    switchToggler : (el, state) ->
      el.attr('rel', 'closed').text "#{s.closedSymbol}" if state == 'open'
      el.attr('rel', 'open').text "#{s.openSymbol}" if state == 'closed'
      el.attr('rel')

    # event handler on click toggle
    clickEvent : (event) ->
      event.preventDefault()
      state = m.getState(this)
      if state == 'open'
        m.getChildren($(@), true).slideUp s.speed # close all children
      else if state == 'closed'
        # re-open all of the children of this element if they were previously open
        m.getChildren($(@), true).each (index, element) =>
          toggler = $(element).find "#{s.togglerElem}.#{s.togglerClass}"
          if m.getState(toggler) == 'open'
            m.getChildren(toggler).slideDown("#{s.speed / 2 }")
        m.getChildren($(@)).slideDown s.speed
      m.switchToggler($(@), state)

    # remove togglers and unbind events
    destroy : (el = null) ->
      el = $("#{s.togglerElem}.#{s.togglerClass}") if el is null
      el.unbind('click', m.clickEvent).remove()

  # get this party started
  m.init()
  $.extend m, s

$(document).ready ->
  menuCollapse = $().menuCollapse()
  # collapse all of the child items on page load
  $("#{menuCollapse.togglerElem}.#{menuCollapse.togglerClass}").click()
  # reset when the menu is updated via sortable
  $('ul.menu').bind('sortstop', () ->
    setTimeout("jQuery().menuCollapse()", 500)
    )