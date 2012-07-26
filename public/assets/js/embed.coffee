find_presentation_data = () ->
  scripts = document.getElementsByTagName("script")
  for idx in [scripts.length - 1..0]
    script = scripts[idx]
    url = script.getAttribute("data-presentation-url")
    title = script.getAttribute("data-presentation-title")
    container_id = script.getAttribute("data-presentation-container-id")
    if url? and title?
      result =
        origin: script.src.match(new RegExp("https?://[^/]*"))
        dom_element: script
        container_id: container_id
        url: url
        title: title
      return result
  throw new Error("Missing presentation data: there must be data-presentation-url and data-presentation-title attributes defined")

html_of = (pres) ->
  text = document.createTextNode(pres.title)
  a = document.createElement("a")
  a.href = "#"
  a.onclick = () ->
    open_frame(pres)
    false
  a.appendChild(text)
  div = document.createElement("div")
  div.appendChild(a)
  fragment = document.createDocumentFragment()
  fragment.appendChild(div)
  fragment

container_of = (pres) ->
  return document.getElementById(pres.container_id) if pres.container_id?
  return pres.dom_element.parentNode if pres.dom_element.parentNode.tagName.toUpperCase() isnt "HEAD"
  return document.body

open_frame = (pres) ->
  width = Math.round(window.innerWidth * 0.8)
  height = Math.round(window.innerHeight * 0.8)

  iframe = document.createElement("iframe")
  iframe.width = width
  iframe.height = height
  iframe.src = pres.url
  iframe.style.cssText = "border: 0px none;"

  left = Math.round((window.innerWidth - width) / 2)
  top = Math.round((window.innerHeight - height) / 2)

  div = document.createElement("div")
  div.style.cssText = "position: absolute; z-index: 9999; left: #{left}px; top: #{top}px; -webkit-box-shadow: 0 0 1em grey; -mox-box-shadow: 0 0 1em grey; box-shadow: 0 0 1em grey;"

  div.id = "presentz_#{(Math.round(Math.random() * 1000000))}"
  div.appendChild(iframe)

  close_button_img = document.createElement("img")
  close_button_img.src = "#{pres.origin}/assets/img/close_button.png"
  close_button_img.onclick = () ->
    div.parentNode.removeChild(div)

  close_button = document.createElement("div")
  close_button.style.cssText = "cursor: pointer; height: 29px; overflow: hidden; position: absolute; right: -15px; top: -15px; width: 29px;"
  close_button.appendChild(close_button_img)
  div.appendChild(close_button)

  fragment = document.createDocumentFragment()
  fragment.appendChild(div)
  document.body.appendChild(fragment)


pres = find_presentation_data()
container_node = container_of pres
container_node.appendChild html_of(pres)