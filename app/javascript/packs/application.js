// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

import "jquery";
import "popper.js";
import "bootstrap";
import "../stylesheets/application"; 
import "../stylesheets/custom.scss";


Rails.start()
Turbolinks.start()
ActiveStorage.start()


document.addEventListener("turbolinks:load", () => {
  const form = document.getElementById("new_message_form")
  if (!form) return

  form.addEventListener("ajax:success", () => {
    form.reset()
  })
})