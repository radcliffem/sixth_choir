#= require active_admin/base
#= require chosen-jquery

#= require best_in_place
#= require best_in_place.purr
#= require jquery.purr

# CHOSEN
@chosenify = (entry) ->
  entry.chosen
    allow_single_deselect: true,
    width: "100%" # "calc(80% - 22px)"

$ ->
  chosenify $(".chosen")

  $("form.formtastic .inputs .has_many").click ->
    $(".chosen").chosen
      allow_single_deselect: true,
      width: "100%" # "calc(80% - 22px)"

# BEST IN PLACE
$(document).ready ->
  jQuery(".best_in_place").best_in_place()
