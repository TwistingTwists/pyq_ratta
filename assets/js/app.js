// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import {Socket} from "phoenix"
import {LiveSocket} from "phoenix_live_view"
import * as UpChunk from "@mux/upchunk"
import topbar from "../vendor/topbar"
import hooks from "./hooks"

let Uploaders = {};

Uploaders.UpChunk = function (entries, onViewError) {

    entries.forEach(entry => {
      // create the upload session with UpChunk
      let { file, meta: { entrypoint } } = entry
      let upload = UpChunk.createUpload({ endpoint: entrypoint, file, chunkSize: 153600 })
  
      // stop uploading in the event of a view error
      onViewError(() => upload.pause())
  
      // upload error triggers LiveView error
      upload.on("error", (e) => entry.error(e.detail.message))
  
      // notify progress events to LiveView
  
      upload.on("progress", (e) => {
        if (e.detail < 100) { entry.progress(e.detail) }
      })
  
      // success completes the UploadEntry
      upload.on("success", () => {
        entry.progress(100)
      })
    })
  }
  

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {uploaders: Uploaders, hooks: hooks, params: {_csrf_token: csrfToken}})

// // Show progress bar on live navigation and form submits
// topbar.config({barColors: {0: "#29d"}, shadowColor: "rgba(0, 0, 0, .3)"})
// window.addEventListener("phx:page-loading-start", _info => topbar.show(300))
// window.addEventListener("phx:page-loading-stop", _info => topbar.hide())

// Show progress bar on live navigation and form submits. Only displays if still
// loading after 120 msec
topbar.config({ barColors: { 0: "#29d" }, shadowColor: "rgba(0, 0, 0, .3)" })

let topBarScheduled = undefined;
window.addEventListener("phx:page-loading-start", () => {
  if (!topBarScheduled) {
    topBarScheduled = setTimeout(() => topbar.show(), 120);
  };
});
window.addEventListener("phx:page-loading-stop", () => {
  clearTimeout(topBarScheduled);
  topBarScheduled = undefined;
  topbar.hide();
});


// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket
