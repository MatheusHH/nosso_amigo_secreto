# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'turbolinks:load', ->
  $('.update_campaign input').bind 'blur', ->
    $('.update_campaign').submit()

  $('.update_campaign').on 'submit', (e) ->
    $.ajax e.target.action,
        type: 'PUT'
        dataType: 'json',
        data: $(".update_campaign").serialize()
        success: (data, text, jqXHR) ->
          Materialize.toast('Campanha atualizada', 4000, 'green')
        error: (jqXHR, textStatus, errorThrown) ->
          Materialize.toast('Problema na atualização da Campanha', 4000, 'red')
    return false

  $('.remove_campaign').on 'submit', (e) ->
    $.ajax e.target.action,
        type: 'DELETE'
        dataType: 'json',
        data: {}
        success: (data, text, jqXHR) ->
          $(location).attr('href','/campaigns');
        error: (jqXHR, textStatus, errorThrown) ->
          Materialize.toast('Problema na remoção da Campanha', 4000, 'red')
    return false

  $('.raffle_campaign').on 'submit', (e) ->
    $.ajax e.target.action,
        type: 'POST'
        dataType: 'json',
        data: {}
        success: (data, text, jqXHR) ->
          Materialize.toast('Tudo certo, em breve os participantes receberão um email!', 4000, 'green')
        error: (jqXHR, textStatus, errorThrown) ->
          Materialize.toast(jqXHR.responseText, 4000, 'red')
    return false

  $.rails.allowAction = (link) ->
    return true  unless link.attr("data-confirm")
    $.rails.showConfirmDialog link
    false

  $.rails.confirmed = (link) ->
    link.removeAttr "data-confirm"
    link[0].click() # force click on element directly

  $.rails.showConfirmDialog = (link) ->
    html = undefined
    message = undefined
    message = link.attr("data-confirm")
    html = "<div id=\"modal1\" class=\"modal\" style=\"z-index: 1003; display: block; opacity: 1; transform: scaleX(1); top: 10%;\"> <div class=\"modal-content\"><h4>" + message + "</h4></div><div class=\"modal-footer\"><a class=\"modal-action modal-close waves-effect waves-red btn-flat close\">Cancel</a><a class=\"modal-action modal-close waves-effect waves-green btn-flat confirm\">OK</a></div></div>"
    $("body").append html
    $("#modal1").modal complete: ->
      $("#modal1").remove()

    $("#modal1 .close").on "click", ->
      $("#modal1").modal('close')

    return $("#modal1 .confirm").on("click", ->
      $.rails.confirmed link
    )

  

